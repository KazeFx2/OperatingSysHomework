import QtQuick 2.15
import FluentUI 1.0


FluWindow {
    property int initW: 400
    property int initH: 400
    width: initW
    height: initH
    minimumHeight: initH
    maximumHeight: initH
    minimumWidth: initW
    maximumWidth: initW

    onInitArgument:
        (argument)=>{
            stayTop = argument.stayTop
        }

    showStayTop: false
    showMaximize: false
    showMinimize: false
    showClose: false

    flags: Qt.WindowMaximizeButtonHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint

    modality: Qt.ApplicationModal

    title: qsTr("Login")

    Rectangle {
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
        color: FluColors.Transparent

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: childrenRect.width
            height: childrenRect.height + 10
            color: FluColors.Transparent

            FluText {
                width: psw_txt.width
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                padding: 10
                text: qsTr("User")
            }

            FluTextBox {
                anchors.verticalCenter: parent.verticalCenter
                width: 250
                anchors.left: parent.children[0].right
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
                anchors.verticalCenter: parent.verticalCenter
                width: 250
                echoMode: TextInput.Password
                anchors.left: parent.children[0].right
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
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.children[2].bottom
            width: childrenRect.width
            height: childrenRect.height + 10
            color: FluColors.Transparent

            FluFilledButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.children[0].right
                text: qsTr("Login")
            }
        }
    }
}
