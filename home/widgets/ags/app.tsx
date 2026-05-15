import app from "ags/gtk4/app"

import Sidebar from "./sidebar"
import Menu from "./menu"

import CommonCSS from "./common.scss"

app.start({
    css: CommonCSS,
    main() {
        return (
            Sidebar(), 
            Menu()
        )
    },
})
