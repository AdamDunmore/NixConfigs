import app from "ags/gtk4/app"

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
