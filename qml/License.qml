import QtQuick 2.15
import FluentUI 1.0
import "qrc:///qml/Component"

FluWindow {
    id: window
    property int initW: 500
    property int initH: 590

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

    title: qsTr("Licenses")

    Rectangle {
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
            text: "OS Final Experiment/Test"
        }

        FluCopyableText {
            anchors {
                // horizontalCenter: parent.horizontalCenter
                top: parent.children[2].bottom
                topMargin: 10
            }
            readOnly: true
            text: qsTr("Open Source Licenses")
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

                NamedUrlItem {
                    ico: "qrc:///src/ico/Qt.ico"
                    name: "Qt Project"
                    url: "https://github.com/qtproject"
                    license: "GNU LGPL"
                }

                NamedUrlItem {
                    ico: "qrc:///src/svg/FluentUI.svg"
                    name: "FluenUI"
                    url: "https://github.com/zhuzichu520/FluentUI"
                    license: "MIT License"
                }

                NamedUrlItem {
                    ico: "qrc:///src/ico/GitHub.ico"
                    name: "FramelessHelper 2.x"
                    url: "https://github.com/wangwenx190/framelesshelper"
                    license: "MIT License"
                }

                NamedUrlItem {
                    ico: "qrc:///src/ico/GitHub.ico"
                    name: "ZXing-C++"
                    url: "https://github.com/zhuzichu520/zxing-cpps"
                    license: "Apache License 2.0"
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
