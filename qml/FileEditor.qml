import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import kaze.ui 1.0


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
            property int prev_h: -1
            onContentHeightChanged: {
                if (prev_h === -1 || contentHeight <= height)
                    prev_h = contentHeight
                else {
                    contentY = Math.max(0, contentY + contentHeight - prev_h)
                    prev_h = contentHeight
                }
            }

            onWidthChanged: {
                prev_h = contentHeight
            }

            Rectangle {
                id: highlight
                color: FluTheme.fontPrimaryColor
                width: parent.width
                opacity: 0.2

                Behavior on y{
                    NumberAnimation{
                        duration: 100
                    }
                }
                Behavior on height{
                    NumberAnimation{
                        duration: 100
                    }
                }
            }

            Rectangle {
                id: lineNum
                width: inner.width
                height: editor.height
                color: FluColors.Transparent
                ListView {
                    id: inner

                    property int max_w: 0

                    width: max_w
                    height: parent.height

                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                        }
                    }

                    model: ListModel {
                        id: lineList_model

                        ListElement {
                            lineH: 20
                            lineNumber: 1
                        }

                        onCountChanged: {
                            if (count === 0)
                                return
                            var tmp = count + 1
                            while (tmp > 1)
                                tmp /= 10
                            if (tmp === 1){
                                var t = inner.contentItem
                                inner.max_w = inner.contentItem.children[count - 1].width
                            }
                        }
                    }

                    delegate: Rectangle {
                        height: lineH
                        width: children[0].width
                        x: Math.max(0, inner.max_w - width)
                        color: FluColors.Transparent

                        FluText {
                            property int pad: 5
                            leftPadding: pad
                            rightPadding: pad
                            opacity: 0.5
                            text: "" + lineNumber

                            Component.onCompleted: {
                                if (inner.max_w < width)
                                    inner.max_w = width
                            }
                        }

                        Behavior on x{
                            NumberAnimation{
                                duration: 100
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: rightM
                height: parent.height
                width: 12
                anchors.right: parent.right
                color: FluColors.Transparent
            }
            KaTextArea {
                id: editor
                color: FluTheme.dark ? FluColors.White : FluColors.Black
                font.pixelSize: 15
                width: parent.width - lineNum.width - rightM.width
                anchors.top: parent.top
                anchors.right: rightM.left
                wrapMode: TextEdit.WrapAnywhere
                selectByMouse: true
                focus: true
                selectionColor: FluTools.colorAlpha(FluTheme.primaryColor,0.5)
                selectedTextColor: FluTheme.dark ? FluColors.White : FluColors.Grey220

                onWidthFreshed:
                {
                    var ref = refreshList
                    for (var i = 0; i < ref.length; i++){
                        var d = lineList_model.get(ref[i])
                        d.lineH = lineHeights[ref[i]]
                        lineList_model.set(ref[i], d)
                    }
                    highlight.height = cursorYH[1]
                    highlight.y = cursorYH[0]
                }

                onLineFreshed: {
                    var line = cursorLineNum
                    if (lineHeights.length > lineList_model.count) {
                        for (var i = lineList_model.count; i < lineHeights.length; i++){
                            lineList_model.append({
                                                    lineH: lineHeights[i],
                                                    lineNumber: i + 1
                                                  })
                        }
                    }
                    for (i = lineList_model.count - 1; i >= lineHeights.length; i--) {
                        lineList_model.remove(i)
                    }
                    for (i = 0; i < lineList_model.count; i++){
                        var d = lineList_model.get(i)
                        if (d !== lineHeights[i]) {
                            d.lineH = lineHeights[i]
                            lineList_model.set(i, d)
                        }
                    }
                    highlight.height = cursorYH[1]
                    highlight.y = cursorYH[0]
                }
                Component.onCompleted: {
                    highlight.height = cursorYH[1]
                    highlight.y = cursorYH[0]
                }
                onCursorPositionChanged: {
                    highlight.height = cursorYH[1]
                    highlight.y = cursorYH[0]
                }
            }
        }
    }
}
