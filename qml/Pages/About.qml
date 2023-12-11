import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "qrc:///qml/Component"

FluScrollablePage {
    title: qsTr("About")

    FluText {
        topPadding: 10
        text: qsTr("Author")
        font.pixelSize: 20
    }

    FluClip {
        width: 75
        height: width
        Layout.topMargin: 10
        Layout.alignment: Qt.AlignHCenter
        radius: [width / 2, width / 2, width / 2, width / 2]

        Image {
            anchors.fill: parent
            source: "qrc:///src/png/Kaze.png"
            sourceSize: Qt.size(80, 80)
        }

        MouseArea {
            width: parent.width
            height: parent.height
            onClicked: (Mouse) => {
                Qt.openUrlExternally("https://github.com/KazeFx2");
            }
        }

    }

    FluText {
        topPadding: 10
        text: "KazeFx"
        font.pixelSize: 20
        Layout.alignment: Qt.AlignHCenter
    }

    FluText {
        padding: 10
        Layout.alignment: Qt.AlignHCenter
        text: "Version 1.0"
    }

    FluArea {
        Layout.topMargin: 10
        width: parent.width
        height: col_lay.height

        Column {
            id: col_lay

            width: parent.width

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 15
                text: qsTr("What's this?")
            }

            FluText {
                width: parent.width
                wrapMode: Text.WordWrap
                padding: 10
                text: qsTr("    This is an experimental course鈥榮 homework of operating system. Meanwhile, I am learning the Qt programming, so I tried to combinate them together. Then this project is given birth to. In order to learn to work with 'git' and 'camke', I uploaded it to the github. lisence? Maybe the MIT, I'll add it after I read the lisences and rules.")
            }

            FluText {
                width: parent.width
                wrapMode: Text.WordWrap
                padding: 10
                text: qsTr("    This is my first try to make my contributions(?) If there is any mistakes that I made, I'll be very grateful if you can tell me :)")
            }

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 15
                text: "GitHub: "
            }

            FluText {
                padding: 10
                text: "\thttps://github.com/KazeFx2/OperatingSysHomework"
                color: FluColors.Blue.normal

                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked: {
                        Qt.openUrlExternally("https://github.com/KazeFx2/OperatingSysHomework");
                    }
                }

            }

        }

    }

    FluText {
        topPadding: 10
        text: qsTr("Open Source Licenses")
        font.pixelSize: 20
    }

    ScrollableItems {
        height: col.height

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
                ico: "qrc:///src/ico/FluentUI.ico"
                name: "FluenUI"
                url: "https://github.com/zhuzichu520/FluentUI"
                license: "MIT License"
            }

            NamedUrlItem {
                ico: "qrc:///src/svg/GitHub.svg"
                name: "FramelessHelper 2.x"
                url: "https://github.com/wangwenx190/framelesshelper"
                license: "MIT License"
            }

            NamedUrlItem {
                ico: "qrc:///src/svg/GitHub.svg"
                name: "ZXing-C++"
                url: "https://github.com/zhuzichu520/zxing-cpps"
                license: "Apache License 2.0"
            }

        }

    }

}
