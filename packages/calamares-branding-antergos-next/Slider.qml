import QtQuick 2.15

Item {
    property list<Slide> slides

    property int currentSlideIndex: 0
    property int _currentSlideIndex: 0
    property int slidesSize: slides.length
    property bool firstIteration: true

    function reset() {
        currentSlideIndex = 0
        firstIteration = true
    }

    onCurrentSlideIndexChanged: {
        if (currentSlideIndex >= slidesSize) {
            firstIteration = false
            currentSlideIndex = 0
        }

        transitionAnimation.start()
    }

    Column {
        anchors.fill: parent
        spacing: 8

        Text {
            id: titleText
            font {
                family: "Roboto"
                weight: Font.Medium
                pixelSize: 22
            }
            color: "#E3E2E6"
            text: slides[_currentSlideIndex].title
        }
        Text {
            id: secondaryTitleText
            font {
                family: "Roboto"
                weight: Font.Normal
                pixelSize: 13
            }
            color: "#4A9EFF"
            text: slides[_currentSlideIndex].secondaryTitle ?? ""
        }
        Item { width: parent.width; height: 4 }
        Text {
            id: bodyText
            font {
                family: "Roboto"
                pixelSize: 13
            }
            width: 400
            color: "#C8D6E5"
            text: slides[_currentSlideIndex].body
            wrapMode: Text.Wrap
            lineHeight: 1.55
        }

        Item { width: parent.width; height: 8 }

        Text {
            id: footerText
            font {
                family: "Roboto"
                weight: Font.Normal
                pixelSize: 12
            }
            width: 400
            color: "#8E9099"
            text: slides[_currentSlideIndex].footer ?? ""
            wrapMode: Text.Wrap
        }
    }

    SequentialAnimation {
        id: transitionAnimation
        property int duration: 700

        ParallelAnimation {
            OpacityAnimator {
                target: titleText
                from: 1.0
                to: 0.0
                duration: transitionAnimation.duration
            }
            OpacityAnimator {
                target: secondaryTitleText
                from: 1.0
                to: 0.0
                duration: transitionAnimation.duration
            }
            OpacityAnimator {
                target: bodyText
                from: 1.0
                to: 0.0
                duration: transitionAnimation.duration
            }
            OpacityAnimator {
                target: footerText
                from: 1.0
                to: 0.0
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: titleText
                from: 0
                to: -30
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: secondaryTitleText
                from: 0
                to: -30
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: bodyText
                from: 0
                to: -25
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: footerText
                from: 0
                to: -25
                duration: transitionAnimation.duration
            }
        }

        ScriptAction {
            script: _currentSlideIndex = currentSlideIndex
        }

        ParallelAnimation {
            OpacityAnimator {
                target: titleText
                from: 0.0
                to: 1.0
                duration: transitionAnimation.duration
            }
            OpacityAnimator {
                target: secondaryTitleText
                from: 0.0
                to: 1.0
                duration: transitionAnimation.duration
            }
            OpacityAnimator {
                target: bodyText
                from: 0.0
                to: 1.0
                duration: transitionAnimation.duration
            }
            OpacityAnimator {
                target: footerText
                from: 0.0
                to: 1.0
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: titleText
                from: 30
                to: 0
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: secondaryTitleText
                from: 30
                to: 0
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: bodyText
                from: 25
                to: 0
                duration: transitionAnimation.duration
            }
            XAnimator {
                target: footerText
                from: 25
                to: 0
                duration: transitionAnimation.duration
            }
        }
    }
}
