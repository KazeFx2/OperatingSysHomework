import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import "qrc:///qml/Component"

FluScrollablePage{

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

    }

    FluText {
        topPadding: 10
        text: "KazeFx"
        font.pixelSize: 20
        Layout.alignment: Qt.AlignHCenter
    }

    FluArea {
        Layout.topMargin: 10
        width: parent.width
        height: 50
    }

    FluText {
        topPadding: 10
        text: qsTr("Open Source Licenses")
        font.pixelSize: 20
    }

    ScrollableItems{

        height: col.height

        Column{

            id: col

            width: parent.width

            NamedUrlItem{
                ico: "qrc:///src/ico/Qt.ico"
                name: "Qt Project"
                url: "https://github.com/qtproject"
                license: "GNU LGPL"
            }

            NamedUrlItem{
                ico: "qrc:///src/ico/FluentUI.ico"
                name: "FluenUI"
                url: "https://github.com/zhuzichu520/FluentUI"
                license: "MIT License"
            }

            NamedUrlItem{
                ico: "qrc:///src/svg/GitHub.svg"
                name: "FramelessHelper 2.x"
                url: "https://github.com/wangwenx190/framelesshelper"
                license: "MIT License"
            }

            NamedUrlItem{
                ico: "qrc:///src/svg/GitHub.svg"
                name: "ZXing-C++"
                url: "https://github.com/zhuzichu520/zxing-cpps"
                license: "Apache License 2.0"
            }

            Component.onCompleted: {
                col.children[children.length - 1].is_last = true
            }

        }

    }

}
