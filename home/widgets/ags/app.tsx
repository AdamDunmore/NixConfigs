import app from "ags/gtk4/app"
import { Astal } from "ags/gtk4"

import Sidebar from "./sidebar"

app.start({
  main() {
    return (
       Sidebar() 
    )
  },
})
