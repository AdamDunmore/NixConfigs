export default function MenuPage({ children }: { children?: JSX.Element | JSX.Element[] }){
    return (
        <box vexpand hexpand class="menu_page">
            { children }
        </box>
    )
}
