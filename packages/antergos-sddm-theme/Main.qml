import QtQuick 2.14
import SddmComponents 2.0
import 'components'


Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            errorMessage.color = "#2EA3F2"
            errorMessage.text = textConstants.loginSucceeded
        }

        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "#ed1515"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#661a1c21" }
            GradientStop { position: 0.5; color: "#aa1a1c21" }
            GradientStop { position: 1.0; color: "#ee0d0e12" }
        }

        Rectangle {
            id: loginCard
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -24
            width: 360
            height: cardColumn.implicitHeight + 40
            radius: 16
            color: "#232629"
            border.color: "#3f4347"
            border.width: 1

            Column {
                id: cardColumn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 28
                spacing: 16
                width: parent.width - 40

                Text {
                    text: "Antergos"
                    color: "#2EA3F2"
                    font.family: "Roboto"
                    font.weight: Font.Light
                    font.pointSize: 34
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    width: parent.width
                    spacing: 10

                    TextBox {
                        id: name
                        width: parent.width
                        height: 40
                        text: userModel.lastUser
                        font.pixelSize: 14
                        color: "#1d1f21"
                        textColor: "#eff0f1"
                        focusColor: "#2EA3F2"
                        KeyNavigation.backtab: rebootButton
                        KeyNavigation.tab: password
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionCombo.index)
                                event.accepted = true
                            }
                        }
                    }

                    PasswordBox {
                        id: password
                        width: parent.width
                        height: 40
                        font.pixelSize: 14
                        color: "#1d1f21"
                        textColor: "#eff0f1"
                        focusColor: "#2EA3F2"
                        KeyNavigation.backtab: name
                        KeyNavigation.tab: loginButton
                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionCombo.index)
                                event.accepted = true
                            }
                        }
                    }
                }

                Text {
                    id: errorMessage
                    width: parent.width
                    height: errorMessage.text ? 16 : 0
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    visible: errorMessage.text !== ""
                }

                Button {
                    id: loginButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: textConstants.login
                    color: "#2EA3F2"
                    textColor: "#ffffff"
                    activeColor: "#268acc"
                    pressedColor: "#1a6da0"
                    KeyNavigation.backtab: password
                    KeyNavigation.tab: shutdownButton
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionCombo.index)
                            event.accepted = true
                        }
                    }
                    onClicked: sddm.login(name.text, password.text, sessionCombo.index)
                }

                Row {
                    spacing: 8
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        color: "#3f4347"
                        textColor: "#eff0f1"
                        activeColor: "#ed1515"
                        KeyNavigation.backtab: loginButton
                        KeyNavigation.tab: rebootButton
                        onClicked: sddm.powerOff()
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        color: "#3f4347"
                        textColor: "#eff0f1"
                        activeColor: "#2EA3F2"
                        KeyNavigation.backtab: shutdownButton
                        KeyNavigation.tab: sessionCombo
                        onClicked: sddm.reboot()
                    }
                }
            }
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                bottomMargin: 32
                horizontalCenter: parent.horizontalCenter
            }
            width: 360
            height: 44
            radius: 12
            color: "#1a1c21"
            border.color: "#3f4347"
            border.width: 1

            Row {
                anchors.centerIn: parent
                spacing: 16

                ComboBox {
                    id: sessionCombo
                    width: 140
                    height: 32
                    model: sessionModel
                    index: sessionModel.lastIndex
                    color: "#31363b"
                    textColor: "#eff0f1"
                    menuColor: "#232629"
                    focusColor: "#2EA3F2"
                    hoverColor: "#3f4347"
                    borderColor: "#3f4347"
                    arrowIcon: "angle-up.png"
                    arrowColor: "#8a8f9c"
                    font.pixelSize: 12
                    KeyNavigation.backtab: rebootButton
                    KeyNavigation.tab: layoutCombo
                }

                LayoutBox {
                    id: layoutCombo
                    width: 110
                    height: 32
                    color: "#31363b"
                    textColor: "#eff0f1"
                    hoverColor: "#3f4347"
                    menuColor: "#232629"
                    borderColor: "#3f4347"
                    focusColor: "#2EA3F2"
                    arrowIcon: "angle-up.png"
                    arrowColor: "#8a8f9c"
                    font.pixelSize: 12
                    KeyNavigation.backtab: sessionCombo
                    KeyNavigation.tab: name
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
