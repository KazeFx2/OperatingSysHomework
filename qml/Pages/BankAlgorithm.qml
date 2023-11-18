import QtQuick 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Rectangle {

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
                    contentItem: FluScrollablePage {
                        width: parent.width

                        id: sys_status_page

                        property int n_src: 3
                        property var src_capacity: [100, 100, 100]


                        ListView {

                            id: this_list_view

                            implicitWidth: parent.width
                            implicitHeight: 180

                            orientation: ListView.Horizontal

                            spacing: {
                                var tmp = children[0].children
                                var pad = tmp.length > 2 ? (parent.width - tmp[2].width * (tmp.length - 2)) / (tmp.length - 1) : 0
                                if (pad < 0)
                                    pad = 0
                                return pad
                            }

                            model: ListModel {
                                id: ring_view

                                ListElement {
                                    name: ""
                                    cost: 0
                                    total: -1
                                }
                            }

                            delegate: Column {

                                id: ring_view_col

                                anchors.verticalCenter: parent.verticalCenter

                                visible: total !== -1

                                width: total === -1 ? 0 : ring_item.width

                                FluText {
                                    text: "" + name
                                    bottomPadding: 10
                                    x: (ring_item.width - width) / 2
                                }

                                FluProgressRing {

                                    id: ring_item
                                    height: 100
                                    width: height
                                    strokeWidth: 10
                                    indeterminate: false
                                    progressVisible: true
                                    value: (total - cost) / total
                                }

                                FluText {
                                    topPadding: 10
                                    text: cost + "/" + (total - cost) + "/" + total
                                    x: (ring_item.width - width) / 2
                                }
                            }

                            Component.onCompleted: {
                                for (var i = 0; i < sys_status_page.n_src; i++)
                                    ring_view.append({ name: "Src_" + (i + 1), cost: 0, total: sys_status_page.src_capacity[i] })
                            }

                        }

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
            }

            FluRectangle {
                height: prev.height
                width: parent.width - prev.width - next.width - parent.padding * 2
                color: FluColors.Transparent
            }

            FluFilledButton {
                id: next
                text: "Next"
            }

        }

    }

}
