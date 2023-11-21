import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle {

    id: global_ctx

    property var src_names: []

    width: parent.width
    height: parent.height

    color: FluColors.Transparent

    Column{

        id: col

        height: parent.height
        width: parent.width

        FluText {
            id: title
            leftPadding: 10
            text: qsTr("Bank Algorithm")
            font.pixelSize: 28
            font.bold: true
        }

        Rectangle{
            id: pad
            width: parent.width
            height: 10
            color: FluColors.Transparent
        }

        FluArea{

            id: area

            width: parent.width - 20
            height: parent.height - title.height - bottom_control.height - pad.height

            paddings: 10

            x: 10

            FluPivot{
                id: bank_inner_menu

                width: parent.width
                height: parent.height

                headerSpacing: {
                    var tmp = bank_inner_menu.children[0].contentItem.children
                    var widdest = 0
                    for (var i = 0; i < tmp.length; i++){
                        var j = tmp[i].children[0].data[0]
                        if (typeof(tmp[i].children[0].data[0]) == "undefined" ||
                                typeof(tmp[i].children[0].data[0].text) == "undefined" ||
                                tmp[i].children[0].data[0].width === 0)
                            continue
                        if (widdest < tmp[i].children[0].data[0].width)
                            widdest = tmp[i].children[0].data[0].width
                    }
                    if (widdest === 0)
                        return 0
                    for (i = 0; i < tmp.length; i++){
                        if (typeof(tmp[i].children[0].data[0]) == "undefined" ||
                                typeof(tmp[i].children[0].data[0].text) == "undefined" ||
                                tmp[i].children[0].data[0].width === 0)
                            continue
                        if (tmp[i].children[0].data[0].width !== widdest)
                            tmp[i].children[0].data[0].leftPadding += (widdest - tmp[i].children[0].data[0].width) / 2
                        tmp[i].children[0].data[0].bottomPadding = 10
                        tmp[i].children[0].data[0].width = widdest
                    }
                    var hlight = bank_inner_menu.children[0].highlight
                    if (tmp.length < 3)
                        return 0
                    return (bank_inner_menu.width - widdest * (tmp.length - 1)) / (tmp.length - 2)
                }

                currentIndex: 0

                FluPivotItem{
                    title: "SysStatus"
                    contentItem: FluLoader {
                        width: parent.width
                        height: parent.height
                        source: "qrc:///qml/Pages/BankAlgorithm_SysStatus.qml"
                    }
                }
                FluPivotItem{
                    title: "PMalloced"
                    contentItem: FluText{
                        text: "Unread emails go here."
                    }
                }
                FluPivotItem{
                    title: "PNeed"
                    contentItem: FluText{
                        text: "Flagged emails go here."
                    }
                }
            }
        }

        Row {

            width: parent.width

            id: bottom_control
            padding: 10

            FluFilledButton {
                id: prev
                text: "Prev"
                disabled: CppBankAlgorithm.isBegin()
            }

            FluRectangle {
                height: prev.height
                width: parent.width - prev.width - next.width - parent.padding * 2
                color: FluColors.Transparent
            }

            FluFilledButton {
                id: next
                text: "Next"
                disabled: CppBankAlgorithm.isEnd()
            }

        }

    }

}
