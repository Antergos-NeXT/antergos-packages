import io.calamares.ui 1.0
import io.calamares.core 1.0

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: bottomBar
    color: "#20252B"
    height: 68
    width: parent ? parent.width : 1024

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        radius: 4
        samples: 8
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 20
        spacing: 8

        Button {
            id: backButton
            text: qsTr("Back")
            flat: true
            enabled: ViewManager.backEnabled
            implicitHeight: 42
            font {
                family: "Roboto"
                weight: Font.Medium
                pixelSize: 14
            }
            contentItem: Text {
                text: "←   " + parent.text
                font: parent.font
                color: parent.enabled ? "#E3E2E6" : Qt.rgba(0.89, 0.89, 0.90, 0.35)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                leftPadding: 16
                rightPadding: 16
            }
            background: Rectangle {
                color: parent.hovered && parent.enabled
                    ? Qt.rgba(0.89, 0.89, 0.90, 0.06)
                    : "transparent"
                radius: 21
                Behavior on color { ColorAnimation { duration: 120 } }
            }
            onClicked: ViewManager.back()
        }

        Item { Layout.fillWidth: true }

        Button {
            id: cancelButton
            text: qsTr("Cancel")
            flat: true
            enabled: ViewManager.quitEnabled
            implicitHeight: 42
            font {
                family: "Roboto"
                weight: Font.Medium
                pixelSize: 14
            }
            contentItem: Text {
                text: parent.text
                font: parent.font
                color: parent.enabled ? "#FFB4AB" : Qt.rgba(1.0, 0.71, 0.67, 0.35)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                leftPadding: 14
                rightPadding: 14
            }
            background: Rectangle {
                color: parent.hovered && parent.enabled
                    ? Qt.rgba(1.0, 0.71, 0.67, 0.07)
                    : "transparent"
                radius: 21
                Behavior on color { ColorAnimation { duration: 120 } }
            }
            onClicked: ViewManager.quit()
        }

        Button {
            id: nextButton
            enabled: true
            implicitWidth: 120
            implicitHeight: 42
            font {
                family: "Roboto"
                weight: Font.Medium
                pixelSize: 14
            }
            text: qsTr(ViewManager.nextEnabled ? "Next" : "Done")
            contentItem: Text {
                text: parent.text + "   →"
                font: parent.font
                color: "#FFFFFF"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: parent.hovered ? "#3B8BDE" : "#4A9EFF"
                radius: 21
                Behavior on color { ColorAnimation { duration: 120 } }
            }
            onClicked: {
                if (ViewManager.nextEnabled) {
                    ViewManager.next()
                } else {
                    ViewManager.quit()
                }
            }
        }
    }
}
