import app from "ags/gtk4/app"
import { Astal } from "ags/gtk4"

import Sidebar from "./sidebar"

import SidebarCSS from "./sidebar.scss"

app.start({
    css: SidebarCSS, 
    main() {
        return (
            Sidebar() 
        )
    },
})
