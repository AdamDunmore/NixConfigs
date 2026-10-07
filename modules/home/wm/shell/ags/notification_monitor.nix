{ pkgs, ... }:
pkgs.writers.writePython3Bin "notification-monitor" {
    doCheck = false;
    libraries = [
        pkgs.python3Packages.dbus-next
    ];
} ''
import asyncio
import json
import os

from dbus_next.aio import MessageBus
from dbus_next.constants import BusType, MessageType
from dbus_next.message import Message
from dbus_next import Variant

RULE = (
    "type='method_call',"
    "interface='org.freedesktop.Notifications',"
    "member='Notify',"
    "path='/org/freedesktop/Notifications'"
)

next_id = 1

def output(notification):
    print(json.dumps(notification, separators=(",", ":")), flush=True)

def unwrap(value):
    if isinstance(value, Variant):
        return unwrap(value.value)
    if isinstance(value, dict):
        return {k: unwrap(v) for k, v in value.items()}
    if isinstance(value, (list, tuple)):
        return type(value)(unwrap(v) for v in value)
    return value

def handle_message(message):
    global next_id

    if (
        message.message_type != MessageType.METHOD_CALL
        or message.interface != "org.freedesktop.Notifications"
        or message.member != "Notify"
        or not message.body
    ):
        return
        
    # TODO fix bug where sometimes notifications are duplicated (it happens on rebuild? (if so not really a big deal))
    # TODO limit to 20ish lines
    home = os.getenv("HOME")
    file_path = home + "/.local/share/ags_config/notifications.csv"
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, 'a') as file:
        json.dump(unwrap(message.body), file)
        file.write("\t\n")

    output(unwrap(message.body))

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
