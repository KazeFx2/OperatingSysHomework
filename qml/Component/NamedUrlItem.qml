import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle{

    property string ico
    property string name
    property string url
    property string license
    property bool is_last: false

    color: FluTools.colorAlpha(FluTheme.dark ? FluColors.White : FluColors.Black, mouse.entered ? 0.05 : 0)
    width: parent.width
    height: col.height

    radius: 4

    Column{

        id: col

        topPadding: 15
        width: parent.width

        Row{

            width: parent.width

            leftPadding: col.topPadding

            FluClip{
                width: parent.height - 20
                height: width
                radius: [0,0,0,0]
                Image{
                    anchors.fill: parent
                    source: ico
                    sourceSize: Qt.size(80,80)
                }
            }

            Rectangle  {
                width: col.topPadding
                height: parent.height
                color: FluColors.Transparent
            }

            Column {

                FluCopyableText{
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
                    text: license
                    font.pixelSize: 10
                    textColor: FluTools.colorAlpha(FluTheme.dark ? FluColors.White : FluColors.Grey220, 0.8)
                    opacity: mouse.clicked ? 0.5 : 1.0
                    bottomPadding: col.topPadding
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
