import QtQuick 2.15
import FluentUI 1.0
import "qrc:///qml/Component"
import "qrc:/src/js/data.js" as Data

FluWindow {
    id: window
    property int initW: 500
    property int initH: 475

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

    title: qsTr("About")

    Rectangle {
        id: cont
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
        color: FluColors.Transparent

        FluImage {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/src/ico/App.ico"
            sourceSize: Qt.size(100, 100)
        }

        FluCopyableText {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.children[0].bottom
            }
            readOnly: true
            text: "File Explorer"
        }

        FluCopyableText {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.children[1].bottom
            }
            readOnly: true
            text: "OS Finnal Experiment/Test"
        }

        FluCopyableText {
            anchors {
                // horizontalCenter: parent.horizontalCenter
                top: parent.children[2].bottom
                topMargin: 10
            }
            readOnly: true
            text: "小组成员"
            font.bold: true
            font.pixelSize: 20
        }

        ScrollableItems {
            height: col.height
            width: window.width - 20
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.children[3].bottom
                topMargin: 10
            }

            Column {
                id: col

                width: parent.width
                Component.onCompleted: {
                    col.children[children.length - 1].is_last = true;
                }

                AboutStaffItem {
                    ico: "qrc:/src/png/Fish.png"
                    name: Data.data[0].name
                    url: Data.data[0].url
                    introduction: Data.data[0].introduction
                }

                AboutStaffItem {
                    ico: "qrc:/src/png/Nine.png"
                    name: Data.data[1].name
                    url: Data.data[1].url
                    introduction: Data.data[1].introduction
                }

                AboutStaffItem {
                    ico: "qrc:/src/png/Kaze.png"
                    name: Data.data[2].name
                    url: Data.data[2].url
                    introduction: Data.data[2].introduction
                }
            }
        }

        FluCopyableText {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.children[4].bottom
                topMargin: 10
            }
            readOnly: true
            text: "MIT Licensed"
            // font.bold: true
            font.pixelSize: 10
            opacity: 0.5
        }
    }
}
