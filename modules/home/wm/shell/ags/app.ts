import app from "ags/gtk4/app"

import Sidebar from "./widget/sidebar"

import CommonCSS from "./common.scss"

app.start({
    css: CommonCSS,
    main() {
        return (
            Sidebar() 
        )
    },
})
