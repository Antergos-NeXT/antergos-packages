import QtQuick

Image {
    id: root
    source: "images/background.png"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }

    Rectangle {
        id: overlay
        color: "#cc1a1c21"
        anchors.fill: parent
    }

    Text {
        id: logoText
        text: "Antergos"
        color: "#2EA3F2"
        font.family: "Roboto"
        font.weight: Font.Light
        font.pointSize: 48
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -40
    }

    Text {
        id: subtitleText
        text: "NeXT"
        color: "#eff0f1"
        font.family: "Roboto"
        font.weight: Font.Thin
        font.pointSize: 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logoText.bottom
        anchors.topMargin: 4
    }

    Rectangle {
        id: progressBarBg
        radius: 2
        color: "#3f4347"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: subtitleText.bottom
            topMargin: 40
        }
        height: 4
        width: 200

        Rectangle {
            id: progressBar
            radius: 2
            color: "#2EA3F2"
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: (parent.width / 6) * (stage - 1)
            Behavior on width {
                PropertyAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    SequentialAnimation {
        id: introAnimation
        running: false

        ParallelAnimation {
            PropertyAnimation {
                property: "opacity"
                target: logoText
                from: 0
                to: 1
                duration: 800
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                property: "opacity"
                target: subtitleText
                from: 0
                to: 1
                duration: 800
                easing.type: Easing.InOutQuad
            }
        }
    }
}
