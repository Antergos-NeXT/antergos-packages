import io.calamares.ui 1.0
import io.calamares.core 1.0

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: topBar
    color: "#20252B"
    height: 64
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
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 14

        Image {
            id: logo
            sourceSize.width: 34
            sourceSize.height: 34
            fillMode: Image.PreserveAspectFit
            source: Branding.imagePath(Branding.ProductLogo)
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: "Antergos NeXT"
            color: "#E3E2E6"
            font {
                family: "Roboto"
                weight: Font.Medium
                pixelSize: 17
                letterSpacing: 0.3
            }
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            Repeater {
                id: dotRepeater
                model: ViewManager

                Rectangle {
                    width: index === ViewManager.currentStepIndex ? 10 : 7
                    height: 7
                    radius: 3.5
                    color: index === ViewManager.currentStepIndex
                        ? "#4A9EFF" : "#8E9099"
                    opacity: index === ViewManager.currentStepIndex ? 1 : 0.35
                    Behavior on width { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
        }
    }

    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: 3
        color: Qt.rgba(0.56, 0.57, 0.60, 0.2)

        Rectangle {
            height: parent.height
            width: parent.width * ((ViewManager.currentStepIndex + 1) / Math.max(dotRepeater.count, 1))
            color: "#4A9EFF"
            Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        }
    }
}
