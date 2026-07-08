/* Antergos NeXT Minimal — info page */
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    width: parent.width
    spacing: 20

    Image {
        source: "antergos-logo.png"
        sourceSize.width: 96
        sourceSize.height: 96
        fillMode: Image.PreserveAspectFit
        Layout.alignment: Qt.AlignHCenter
    }

    Label {
        text: "Antergos NeXT Minimal"
        font.pointSize: 20
        font.bold: true
        Layout.alignment: Qt.AlignHCenter
        color: "#4A9EFF"
    }

    Rectangle {
        height: 1
        color: "#FF6B6B"
        Layout.fillWidth: true
        Layout.leftMargin: 24
        Layout.rightMargin: 24
    }

    Label {
        text: "⚠  NOTICE"
        font.pointSize: 14
        font.bold: true
        Layout.alignment: Qt.AlignHCenter
        color: "#FF6B6B"
    }

    Label {
        text: "This is the Minimal (Xfce) edition of Antergos NeXT. The main Plasma ISO ballooned to ~2.8 GB (over GitHub's 2 GB release limit) from all the bundled KDE packages, wallpapers, and apps. This Xfce build trims the fat while keeping the full installer and repository access."
        font.pointSize: 11
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.leftMargin: 24
        Layout.rightMargin: 24
        color: "#C8D6E5"
    }

    Label {
        text: "What's different from the Plasma edition:"
        font.pointSize: 11
        font.bold: true
        Layout.leftMargin: 24
        color: "#C8D6E5"
    }

    Column {
        spacing: 4
        Layout.leftMargin: 40
        Repeater {
            model: [
                "Uses Xfce desktop instead of KDE Plasma — lighter and faster",
                "No KDE applications (uses Falkon browser, Xfce native apps)",
                "Smaller ISO size (~1.5 GB vs ~2.8 GB)",
                "Same Calamares installer, same repos, same init choices",
                "Better for older hardware, VMs, or minimal setups"
            ]
            Label {
                text: "• " + modelData
                font.pointSize: 10
                color: "#C8D6E5"
            }
        }
    }

    Label {
        text: "If you installed this just to install Plasma from the repos and pretend it's the full ISO — yeah, fair enough. We can't blame you."
        font.pointSize: 10
        italic: true
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.leftMargin: 24
        Layout.rightMargin: 24
        Layout.topMargin: 8
        color: "#FF6B6B"
    }
}
