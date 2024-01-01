import QtQuick 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import "qrc:/src/js/tools.js" as Tools
import "qrc:///qml/Component" 1.0

FluScrollablePage {
    id: root

    property int sortTypeUp: -1
    property int sortTypeDown: -1

    property double tdt: -1
    property double tdwt: -1

    property int _min: 0
    property int _max: 0
    property int _head: 0
    property int _dist: 0
    property int _n: 0

    title: qsTr("Disk Schedule")
    width: parent.width
    height: parent.height

    FluArea {
        Layout.topMargin: 10
        height: inner_col.height + paddings * 2
        width: parent.width
        paddings: 10

        Column {
            id: inner_col

            width: parent.width

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: qsTr("Magnetic track requests")
            }

            Rectangle {
                width: parent.width
                height: 1
                radius: 1
                color: FluColors.Grey110
            }

            Rectangle {
                width: parent.width
                height: 10
                color: FluColors.Transparent
            }

            ModTabView{
                id: tab_view
                closeButtonVisibility: FluTabViewType.Nerver
                width: parent.width
                moveItem: false
                addButtonVisibility: false
                onNewPressed:{
                    page_in.text = ""
                    page_in.open()
                }
                onItemMoved: (from, to)=>{
                                 // console.log(from, to)
                                 // CppPageSwapping.move_from_to(from, to)
                             }
                onItemRemove: (index)=>{
                                // CppPageSwapping.remove_index(index)
                              }
            }

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: qsTr("Management")
            }

            Rectangle {
                width: parent.width
                height: 1
                radius: 1
                color: FluColors.Grey110
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: FluColors.Transparent

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    color: FluColors.Transparent

                    FluText {
                        padding: 10
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        text: qsTr("Min")
                    }

                    FluTextBox {
                        id: mag_min
                        anchors {
                            left: parent.children[0].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        placeholderText: _min.toString()
                        width: 100
                        validator: RegExpValidator {regExp: /[0-9][0-9][0-9]/}
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.children[0].right
                    }
                    color: FluColors.Transparent

                    FluText {
                        padding: 10
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        text: qsTr("Max")
                    }

                    FluTextBox {
                        id: mag_max
                        anchors {
                            left: parent.children[0].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        placeholderText: _max.toString()
                        width: 100
                        validator: RegExpValidator {regExp: /[0-9][0-9][0-9]/}
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    color: FluColors.Transparent

                    FluText {
                        padding: 10
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        text: qsTr("N Random")
                    }

                    FluTextBox {
                        id: n_rand
                        anchors {
                            left: parent.children[0].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        placeholderText: _n.toString()
                        width: 80
                        validator: RegExpValidator {regExp: /[0-9][0-9]/}
                    }

                    FluFilledButton {
                        anchors {
                            left: parent.children[1].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        disabled: mag_min.text === "" || mag_max.text === "" || n_rand.text === ""
                        text: qsTr("Generate")
                        onClicked: {
                            if (parseInt(n_rand.text) === 0)
                                showError(qsTr("Random times can not be 0!"))
                            else if (parseInt(mag_min.text) > _head || parseInt(mag_max.text) < _head)
                                showError(qsTr("Head position must between the min magnetic track and the max magnetic track!"))
                            else {
                                var _mi = parseInt(mag_min.text)
                                var _ma = parseInt(mag_max.text)
                                var _n_ = parseInt(n_rand.text)
                                CppDiskSchedule.genRandomNH(_mi, _ma, _n_)
                                if (_min === _mi && _max === _ma && _n_ === _n) {
                                    showSuccess(qsTr("Generate successfully!"))
                                    mag_max.text = ""
                                    mag_min.text = ""
                                    n_rand.text = ""
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            Rectangle {
                height: childrenRect.height
                width: parent.width
                color: FluColors.Transparent

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    anchors.left: parent.left
                    color: FluColors.Transparent

                    FluText {
                        padding: 10
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        text: qsTr("Magnetic head position")
                    }

                    FluTextBox {
                        id: start_pos
                        anchors {
                            left: parent.children[0].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        placeholderText: _head.toString()
                        width: 100
                        validator: RegExpValidator {regExp: /[0-9][0-9][0-9]/}
                    }

                    FluFilledButton {
                        anchors {
                            left: parent.children[1].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        disabled: start_pos.text === ""
                        text: qsTr("Apply")
                        onClicked: {
                            if (_min > parseInt(start_pos.text) || _max < parseInt(start_pos.text)){
                                showError(qsTr("Head position must between the min magnetic track and the max magnetic track!"))
                            } else {
                                CppDiskSchedule.setHead(parseInt(start_pos.text))
                                if (_head === parseInt(start_pos.text)){
                                    showSuccess(qsTr("Change head position successfully!"))
                                    start_pos.text = ""
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        text: qsTr("Strategy")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        height: childrenRect.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        anchors.leftMargin: 10
                        width: 120
                        color: FluColors.Transparent
                        Component.onCompleted: {
                            // TODO

                        }

                        FluComboBox {
                            id: strategy

                            property int prev: 0

                            editable: false
                            anchors.left: parent.left
                            anchors.right: parent.right

                            model: ListModel {
                                id: model

                                ListElement {
                                    text: "FCFS"
                                }

                                ListElement {
                                    text: "SSTF"
                                }

                                ListElement {
                                    text: "SCAN"
                                }

                                ListElement {
                                    text: "C_SCAN"
                                }

                                ListElement {
                                    text: "LOOK"
                                }

                                ListElement {
                                    text: "C_LOOK"
                                }
                            }
                            Component.onCompleted: {
                                prev = currentIndex = indexOfValue(CppDiskSchedule.getStrategy())
                            }
                        }
                    }

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[1].right
                        anchors.leftMargin: 10
                        text: qsTr("Apply")
                        onClicked: {
                            // TODO
                            var ret = CppDiskSchedule.setStrategy(strategy.currentText)
                            if (ret) {
                                showSuccess(qsTr("Apply successfully"))
                                strategy.prev = strategy.currentIndex
                            } else {
                                showError(qsTr("Apply failed, not supported"))
                                strategy.currentIndex = strategy.prev
                            }
                        }
                    }
                }
            }

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: qsTr("Results")
            }

            Rectangle {
                width: parent.width
                height: 1
                radius: 1
                color: FluColors.Grey110
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            ModTabView{
                id: res_view
                // colorful: true
                closeButtonVisibility: FluTabViewType.Nerver
                moveItem: false
                width: parent.width
                addButtonVisibility: false
                onNewPressed:{
                }
            }

            Rectangle {

                width: parent.width
                height: childrenRect.height
                color: FluColors.Transparent

                Column {

                    Rectangle {
                        width: parent.width
                        height: 10
                        color: FluColors.Transparent
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Magnetic head start position: ") + _head.toString()
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Min magnetic track: ") + _min.toString()
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Max magnetic track: ") + _max.toString()
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Total distance: ") + _dist.toString()
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Distance average: ") + (_dist / _n).toString()
                    }
                }
            }
        }
    }

    Connections {
        target: CppDiskSchedule
        onUpdate: {
            updateAll()
        }
    }

    function updateAll(){
        var reqs = CppDiskSchedule.getReq()
        var res = CppDiskSchedule.getSc()
        var tt = CppDiskSchedule.getTotal()
        var n = CppDiskSchedule.getN()
        var min = CppDiskSchedule.getMin()
        var max = CppDiskSchedule.getMax()
        var head = CppDiskSchedule.getHead()
        var dt = []
        for (var i = 0; i< reqs.length; i++){
            dt.push({_text: reqs[i].toString()})
        }
        tab_view.setTabList(dt)
        dt = []
        for (i = 0; i< res.length; i++){
            dt.push({_text: res[i].toString()})
        }
        res_view.setTabList(dt)
        _min = min
        _max = max
        _head = head
        _n = n
        _dist = tt
    }

    Component.onCompleted: {
        updateAll()
    }
}
