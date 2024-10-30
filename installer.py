from textual.app import App, ComposeResult
from textual.screen import Screen
from textual.containers import Horizontal, Vertical
from textual.widgets import Footer, Header, SelectionList, Label, Button, Markdown, Select, Static, Switch

import json

### JSON Exporter ###
def savejson(data):
    with open('options.json', 'w') as f:
        json.dump(data, f, indent=4)

#####################

Head = """
# DesktopOnCodespaces Installer

> DesktopOnCodespaces allows you to run graphical Linux and Windows apps in your codespace for free.

It includes:
* Windows App Support (using Wine)
* Audio Support
* Root Access
* Support File Persistence
* Entirely in web browser
* Bypass School Network
* Fast VMs Using KVM (Windows and Linux)
"""

InstallHead = """
# DesktopOnCodespaces Installer
"""     

LINES = ["KDE Plasma (Heavy)", "XFCE4 (Lightweight)", "I3 (Very Lightweight)"]

class InstallScreen(Screen):
    CSS_PATH = "installer.tcss"

    def compose(self) -> ComposeResult:
        yield Header()
        yield Markdown(InstallHead)
        
        # App selections
        yield Horizontal(
            Vertical(
                Label("Default Apps (you should keep them)"),
                SelectionList(
                    ("Wine", 0),
                    ("Brave", 1),
                    ("Xarchiver", 2),
                    id="defaultapps"
                ),
            ),
            Vertical(
                Label("Programming"),
                SelectionList(
                    ("OpenJDK 8 (jre)", 0),
                    ("OpenJDK 17 (jre)", 1),
                    ("VSCodium", 2),
                    id="programming"
                ),
            ),
            Vertical(
                Label("Apps"),
                SelectionList(
                    ("VLC", 0),
                    ("LibreOffice", 1),
                    ("Synaptic", 2),
                    ("AQemu (VMs)", 3),
                    ("Discord", 4),
                    id="apps"
                ),
            ),
        )

        # Desktop Environment selection
        yield Vertical(
            Horizontal(
                Label("\nDesktop Environment: "),
                Select(id="de", value="KDE Plasma (Heavy)", options=[(line, line) for line in LINES]),
            ),
        )

        # Navigation buttons
        yield Horizontal(
            Button("Back", id="back"),
            Button("Install NOW", id="install"),
        )

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "back":
            self.app.pop_screen()
        elif event.button.id == "install":
            # Save configuration
            data = {
                "defaultapps": [item[0] for item in self.query_one("#defaultapps").selected],
                "programming": [item[0] for item in self.query_one("#programming").selected],
                "apps": [item[0] for item in self.query_one("#apps").selected],
                "enablekvm": True,
                "DE": self.query_one("#de").value
            }
            savejson(data)
            self.app.exit("Installation data saved!")

class InstallApp(App):
    CSS_PATH = "installer.tcss"

    def compose(self) -> ComposeResult:
        yield Header()
        yield Markdown(Head)
        
        yield Vertical(
            Button("Install", id="install"),
        )

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "install":
            self.push_screen(InstallScreen())

if __name__ == "__main__":
    app = InstallApp()
    app.run()
