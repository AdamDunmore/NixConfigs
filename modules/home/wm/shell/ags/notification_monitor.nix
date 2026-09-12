{ pkgs, ... }:
pkgs.writers.writePython3Bin "notification-monitor" {
  libraries = [
    pkgs.python3Packages.dbus-next
  ];
} ''
  import asyncio
  import json

  from dbus_next.aio import MessageBus
  from dbus_next.constants import BusType, MessageType
  from dbus_next.message import Message


  RULE = (
      "type='method_call',"
      "interface='org.freedesktop.Notifications',"
      "member='Notify',"
      "path='/org/freedesktop/Notifications'"
  )


  next_id = 1


  def output(notification):
      print(json.dumps(notification, separators=(",", ":")), flush=True)


  def handle_message(message):
      global next_id

      if (
          message.message_type != MessageType.METHOD_CALL
          or message.interface != "org.freedesktop.Notifications"
          or message.member != "Notify"
          or not message.body
      ):
          return

      (
          app_name,
          replaces_id,
          app_icon,
          summary,
          body,
          actions,
          hints,
          expire_timeout,
      ) = message.body

      urgency = hints.get("urgency")
      urgency = urgency.value if urgency else 1

      output({
          "id": next_id,
          "app_icon": app_icon,
          "app_name": app_name,
          "summary": summary,
          "body": body,
          "urgency": urgency,
          "actions": actions,
          "replaces_id": replaces_id,
      })

      next_id += 1
      return True


  async def main():
      bus = await MessageBus(bus_type=BusType.SESSION).connect()

      reply = await bus.call(
          Message(
              destination="org.freedesktop.DBus",
              path="/org/freedesktop/DBus",
              interface="org.freedesktop.DBus.Monitoring",
              member="BecomeMonitor",
              signature="asu",
              body=[[RULE], 0],
              serial=bus.next_serial(),
          )
      )

      if reply and reply.message_type == MessageType.ERROR:
          raise RuntimeError(reply.body[0])

      bus.add_message_handler(handle_message)

      await asyncio.get_running_loop().create_future()

  asyncio.run(main())
''
