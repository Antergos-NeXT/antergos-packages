import QtQuick 2.15

Item {
    property list<Dia> slides
    property int currentSlideIndex: 0
    property int _currentSlideIndex: 0

    function reset() {
        currentSlideIndex = 0
        _currentSlideIndex = 0
        wrapper.opacity = 1
    }

    onCurrentSlideIndexChanged: {
        if (currentSlideIndex >= slides.length) {
            currentSlideIndex = 0
        }
        if (_currentSlideIndex !== currentSlideIndex) {
            slideOut.start()
        }
    }

    Item {
        id: wrapper
        anchors.fill: parent

        Column {
            anchors.centerIn: parent
            width: parent.width
            spacing: 0

            Rectangle {
                width: 48
                height: 3
                radius: 1.5
                color: "#4A9EFF"
                bottomPadding: 24
            }

            Text {
                id: titleText
                font {
                    family: "Roboto"
                    weight: Font.Bold
                    pixelSize: 28
                }
                color: "#FFFFFF"
                text: slides[_currentSlideIndex].title
                wrapMode: Text.WordWrap
                width: parent.width
                lineHeight: 1.2
                bottomPadding: 16
            }

            Text {
                id: bodyText
                width: parent.width
                font {
                    family: "Roboto"
                    weight: Font.Normal
                    pixelSize: 14
                }
                color: "#C8D6E5"
                text: slides[_currentSlideIndex].body
                wrapMode: Text.WordWrap
                lineHeight: 1.6
                bottomPadding: 24
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(1, 1, 1, 0.06)
                bottomPadding: 20
            }

            Text {
                id: footerText
                font {
                    family: "Roboto"
                    weight: Font.Normal
                    pixelSize: 12
                }
                color: "#8E9099"
                text: slides[_currentSlideIndex].footer ?? ""
                wrapMode: Text.WordWrap
                width: parent.width
                lineHeight: 1.4
            }
        }
    }

    SequentialAnimation {
        id: slideOut
        NumberAnimation { target: wrapper; property: "opacity"; to: 0; duration: 100; easing.type: Easing.OutQuad }
        PropertyAction { target: wrapper; property: "opacity"; value: 0 }
        ScriptAction { script: _currentSlideIndex = currentSlideIndex }
        NumberAnimation { target: wrapper; property: "opacity"; to: 1; duration: 160; easing.type: Easing.InQuad }
    }
}
