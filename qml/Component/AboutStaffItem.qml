import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle{

    property string ico
    property string name
    property string url: ""
    property string introduction
    property bool is_last: false

    color: FluTools.colorAlpha(FluTheme.dark ? FluColors.White : FluColors.Black, mouse.entered ? 0.05 : 0)
    width: parent.width
    height: col.height

    radius: 4

    Column{

        id: col

        // topPadding: 10
        width: parent.width

        Row{

            width: parent.width

            leftPadding: 10

            FluClip{
                width: parent.height - itro.height + 30
                height: width
                radius: [8, 8, 8, 8]
                Image{
                    anchors.fill: parent
                    source: ico
                    sourceSize: Qt.size(80,80)
                }
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle  {
                width: 10
                height: parent.height
                color: FluColors.Transparent
            }

            Column {

                FluCopyableText{
                    topPadding: 10
                    text: name
                    font.pixelSize: 15
                    width: parent.width
                    opacity: mouse.clicked ? 0.5 : 1.0
                }

                FluCopyableText{
                    text: url
                    font.pixelSize: 10
                    textColor: FluTools.colorAlpha(FluTheme.dark ? FluColors.White : FluColors.Grey220, 0.8)
                    opacity: mouse.clicked ? 0.5 : 1.0
                }

                FluCopyableText{
                    id: itro
                    text: introduction
                    // topPadding: 10
                    font.pixelSize: 10
                    textColor: FluTools.colorAlpha(FluTheme.dark ? FluColors.White : FluColors.Grey220, 0.8)
                    opacity: mouse.clicked ? 0.5 : 1.0
                    bottomPadding: 10
                    textFormat: TextEdit.MarkdownText
                }
            }
        }

        FluMenuSeparator{
            visible: !is_last
            width: parent.width
        }

    }

    MouseArea {
        id: mouse
        property bool entered: false
        property bool clicked: false
        anchors.fill: parent
        hoverEnabled: true
        onClicked: (Mouse)=>{
            if (url == "")
                return
            if (Mouse.button === Qt.LeftButton){
                Qt.openUrlExternally(url)
            }
        }
        onEntered: {
            entered = true
        }
        onExited: {
            entered = false
            clicked = false
        }
        onPressed: (Mouse)=>{
            if (Mouse.button === Qt.LeftButton){
                clicked = true
            }
        }
        onReleased: (Mouse)=>{
            if (Mouse.button === Qt.LeftButton){
                clicked = false
            }
        }

    }

}
