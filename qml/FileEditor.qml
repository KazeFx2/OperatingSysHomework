import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0


FluWindow {
    property int initW: 400
    property int initH: 400
    width: initW
    height: initH
    minimumHeight: initH
    // maximumHeight: height
    minimumWidth: initW
    // maximumWidth: width

    onInitArgument:
        (argument)=>{
            stayTop = argument.stayTop
            if (stayTop){
                showStayTop = false
            }
        }

    // showStayTop: false
    // showMaximize: false
    // showMinimize: false
    // showClose: false

    // flags: Qt.WindowMaximizeButtonHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint

    modality: Qt.ApplicationModal

    title: "[File Name]"

    FluArea {
        anchors.centerIn: parent
        width: parent.width - 20
        height: parent.height - 20

        Rectangle {
            width: parent.width
            height: childrenRect.height
            color: FluColors.Transparent

            FluIconButton {
                iconSource: FluentIcons.Save
            }
        }

        Flickable {
            anchors {
                top: parent.children[0].bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            contentHeight: editor.height
            clip: true
            ScrollBar.vertical: FluScrollBar {
                anchors.right: parent.right
                anchors.rightMargin: 2
            }

            TextArea {
                id: editor
                color: FluTheme.dark ? FluColors.White : FluColors.Black
                font.pixelSize: 15
                width: parent.width
                // height: Math.max(lineCount * font.pixelSize, font.pixelSize)
                anchors.top: parent.children[0].bottom
                wrapMode: TextEdit.Wrap
                selectByMouse: true
                focus: true
                selectionColor: FluTheme.fontTertiaryColor
            }
        }
    }
}
