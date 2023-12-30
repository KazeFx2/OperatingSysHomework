import QtQuick 2.15
import FluentUI 1.0


FluWindow {
    id: window
    property int initW: 400
    property int initH: 300

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
    // showClose: false

    // flags: Qt.WindowMaximizeButtonHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint

    modality: Qt.ApplicationModal

    title: qsTr("Register")

    property int st: 0
    property var sts: [0, 0, 0]

    Rectangle {
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
        color: FluColors.Transparent

        Component.onCompleted: {
            usr_txt.width = Math.max(usr_txt.width, psw_txt.width, psw_rpt_txt.width)
            psw_txt.width = Math.max(usr_txt.width, psw_txt.width, psw_rpt_txt.width)
            psw_rpt_txt.width = Math.max(usr_txt.width, psw_txt.width, psw_rpt_txt.width)
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
                text: ""

                Keys.onEnterPressed: {
                    focus = false
                    psw.focus = true
                }
                Keys.onReturnPressed: {
                    focus = false
                    psw.focus = true
                }

                onTextChanged: {
                    if (text != "") {
                        if (!sts[0]) {
                            window.st++
                            sts[0] = 1
                        }
                    } else if (sts[0]) {
                        window.st--
                        sts[0] = 0
                    }
                    if (psw.text != "" && psw_rpt.text != psw.text) {
                        info.text = qsTr("The passwords entered do not match!")
                    } else if (usr.text == "") {
                        info.text = "Please input the user name!"
                    } else {
                        info.text = ""
                    }
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
                text: ""

                Keys.onEnterPressed: {
                    focus = false
                    psw_rpt.focus = true
                }
                Keys.onReturnPressed: {
                    focus = false
                    psw_rpt.focus = true
                }

                onTextChanged: {
                    if (text != "") {
                        if (!sts[1]) {
                            window.st++
                            sts[1] = 1
                        }
                    } else if (sts[1]) {
                        window.st--
                        sts[1] = 0
                    }
                    if (psw_rpt.text != "" && psw_rpt.text != text) {
                        info.text = qsTr("The passwords entered do not match!")
                    } else if (usr.text == "") {
                        info.text = "Please input the user name!"
                    } else {
                        info.text = ""
                    }
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
                id: psw_rpt_txt
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                padding: 10
                text: qsTr("Repeat")
            }

            FluTextBox {
                id: psw_rpt
                anchors.verticalCenter: parent.verticalCenter
                width: 250
                echoMode: TextInput.Password
                anchors.left: parent.children[0].right
                text: ""

                Keys.onEnterPressed: {
                    if (!ok_bt.disabled)
                        ok_bt.clicked()
                }
                Keys.onReturnPressed: {
                    if (!ok_bt.disabled)
                        ok_bt.clicked()
                }

                onTextChanged: {
                    if (text != "" && text == psw.text) {
                        if (!sts[2]) {
                            window.st++
                            sts[2] = 1
                        }
                    } else if (sts[2]) {
                        window.st--
                        sts[2] = 0
                    }
                    if (psw.text != "" && psw.text != text) {
                        info.text = qsTr("The passwords entered do not match!")
                    } else if (usr.text == "") {
                        info.text = "Please input the user name!"
                    } else {
                        info.text = ""
                    }
                }
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.children[2].bottom
            width: childrenRect.width
            height: childrenRect.height + 5
            color: FluColors.Transparent

            FluIcon {
                visible: info.text != ""
                iconSource: FluentIcons.Error
                iconColor: FluColors.Red.light
                iconSize: 15
                padding: 5
                anchors.verticalCenter: parent.verticalCenter
            }

            FluText {
                id: info
                anchors.left: parent.children[0].right
                color: FluColors.Red.light
                text: ""
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.children[3].bottom
            width: childrenRect.width
            height: childrenRect.height + 10
            color: FluColors.Transparent

            FluFilledButton {
                id: ok_bt
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.children[0].right
                text: qsTr("OK")
                disabled: window.st !== 3
                onClicked: {
                    var usr_name = usr.text
                    var pwd = psw.text
                    // TODO
                    onResult({usr: usr_name, pswd: pwd})
                    window.close()
                }
            }
        }
    }
}
