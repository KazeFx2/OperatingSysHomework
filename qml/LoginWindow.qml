import QtQuick 2.15
import FluentUI 1.0
import "qrc:/src/js/tools.js" as Tools
import QFMS 1.0


FluWindow {
    id: window
    property int initW: 400
    property int initH: 300

    property var registerPageRegister: registerForWindowResult("/register")

    property bool isOk: false

    width: initW
    height: initH
    minimumHeight: initH
    maximumHeight: initH
    minimumWidth: initW
    maximumWidth: initW

    fixSize: true

    onInitArgument:
            (argument) => {
        stayTop = argument.stayTop
    }

    showStayTop: false
    showMaximize: false
    showMinimize: false
    showClose: false

    // flags: Qt.WindowMaximizeButtonHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint

    modality: Qt.ApplicationModal

    title: qsTr("Login")

    Rectangle {
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
        color: FluColors.Transparent

        Component.onCompleted: {
            usr_txt.width = Math.max(usr_txt.width, psw_txt.width)
            psw_txt.width = Math.max(usr_txt.width, psw_txt.width)
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: childrenRect.width
            height: childrenRect.height + 10
            color: FluColors.Transparent

            FluText {
                id: usr_txt
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                padding: 10
                text: qsTr("User")
            }

            FluTextBox {
                id: usr
                anchors.verticalCenter: parent.verticalCenter
                width: 250
                anchors.left: parent.children[0].right

                Keys.onEnterPressed: {
                    focus = false
                    psw.focus = true
                }
                Keys.onReturnPressed: {
                    focus = false
                    psw.focus = true
                }
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z._]*/
                }
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.children[0].bottom
            width: childrenRect.width
            height: childrenRect.height + 10
            color: FluColors.Transparent

            FluText {
                id: psw_txt
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                padding: 10
                text: qsTr("Password")
            }

            FluTextBox {
                id: psw
                anchors.verticalCenter: parent.verticalCenter
                width: 250
                echoMode: TextInput.Password
                anchors.left: parent.children[0].right

                Keys.onEnterPressed: {
                    if (!login_bt.disabled)
                        login_bt.clicked()
                }
                Keys.onReturnPressed: {
                    if (!login_bt.disabled)
                        login_bt.clicked()
                }
                Keys.onEscapePressed: {
                    cancel_bt.clicked()
                }
                validator: RegExpValidator {
                    regExp: /[0-9a-zA-Z._]*/
                }
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.children[1].bottom
            width: childrenRect.width
            height: childrenRect.height + 10
            color: FluColors.Transparent

            FluText {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Not have an account? ")
            }

            FluTextButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.children[0].right
                text: qsTr("Register now!")
                onClicked: {
                    registerPageRegister.launch({stayTop: stayTop})
                }
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.children[2].bottom
            width: childrenRect.width
            height: childrenRect.height + 10
            color: FluColors.Transparent

            FluFilledButton {
                id: login_bt
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                text: qsTr("Login")
                disabled: usr.text == "" || psw.text == ""
                onClicked: {
                    var user = usr.text
                    var pswd = psw.text
                    // TODO
                    var ret = FMS.Login(user, pswd)
                    if (ret === FMST.NotExists) {
                        showError(Tools.format(qsTr("User '{0}' not exist!"), user))
                        return
                    } else if (ret === FMST.PasswordError) {
                        showError(qsTr("Wrong password"))
                        return
                    }
                    isOk = true
                    onResult({status: 0, usr: user, pswd: pswd})
                    window.close()
                }
            }

            FluFilledButton {
                id: cancel_bt
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.children[0].right
                anchors.leftMargin: 10
                text: qsTr("Cancel")
                onClicked: {
                    isOk = true
                    onResult({status: 0, usr: "", pswd: ""})
                    window.close()
                }
            }
        }
    }

    Connections {
        target: registerPageRegister

        function onResult(data) {
            // TODO
            usr.text = data.usr
            showSuccess(qsTr("Register successfully!"))
        }
    }

    Component.onDestruction: {
        if (!isOk) {
            onResult({status: -1, usr: "", pswd: ""})
        }
    }
}
