import app from "ags/gtk4/app"
import { Astal } from "ags/gtk4"

import Menu from "./menu.tsx";

app.start({
  main() {
    return (
        Menu()
    )
  },
})
