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

    property int _max_n: CppPageSwapping.getMax()
    property int faults: 0
    property double fr: 0.0

    title: qsTr("Page Swapping")
    width: parent.width
    height: parent.height

    InputDialog {
        id: page_in
        title: qsTr("Add Page")
        message: qsTr("Input the page number")
        negativeText: qsTr("Cancel")
        positiveText: qsTr("Add")
        onNegativeClicked: (txt)=>{
                           }
        onPositiveClicked: (txt)=>{
                               CppPageSwapping.push_back(parseInt(txt.text))
                               tab_view.appendTab(parseInt(txt.text))
                           }
        vali: RegExpValidator {regExp: /[0-9][0-9]/}
    }

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
                text: qsTr("Pages")
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
                closeButtonVisibility: FluTabViewType.OnHover
                width: parent.width
                // moveItem: false
                onNewPressed:{
                    page_in.text = ""
                    page_in.open()
                }
                onItemMoved: (from, to)=>{
                                 console.log(from, to)
                                 CppPageSwapping.move_from_to(from, to)
                             }
                onItemRemove: (index)=>{
                                CppPageSwapping.remove_index(index)
                              }
            }

            FluText {
                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: qsTr("Settings")
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
                        text: qsTr("Max online pages")
                    }

                    FluTextBox {
                        id: max_n
                        anchors {
                            left: parent.children[0].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        placeholderText: _max_n.toString()
                        width: 100
                        validator: RegExpValidator {regExp: /[0-9]/}
                    }

                    FluFilledButton {
                        anchors {
                            left: parent.children[1].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        disabled: max_n.text === ""
                        text: qsTr("Apply")
                        onClicked: {
                            CppPageSwapping.setCap(parseInt(max_n.text))
                            _max_n = CppPageSwapping.getMax()
                            if (_max_n === parseInt(max_n.text)){
                                showSuccess(qsTr("Apply successfully"))
                                max_n.text = ""
                            }else
                                showError(qsTr("Apply failed"))
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
                                    text: "FIFO"
                                }

                                ListElement {
                                    text: "OPT"
                                }

                                ListElement {
                                    text: "LRU_STACK"
                                }

                                ListElement {
                                    text: "LRU_OFFSET"
                                }

                                ListElement {
                                    text: "LFU"
                                }

                                ListElement {
                                    text: "CLOCK"
                                }
                            }
                            Component.onCompleted: {
                                prev = currentIndex = indexOfValue(CppPageSwapping.getStrategy())
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
                            var ret = CppPageSwapping.setStrategy(strategy.currentText)
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
                colorful: true
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
                        text: qsTr("Max n pages: ") + _max_n.toString()
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Pages faults: ") + faults.toString()
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Fault rate: ") + fr.toString()
                    }
                }
            }
        }
    }

    Connections{
        target: CppPageSwapping
        onUpdate: {
            updateRes()
        }
    }

    function updateRes(){
        var res = CppPageSwapping.getRes()
        var page_fault = CppPageSwapping.getPageFault()
        faults = page_fault
        fr = faults / res.length
        var dt = []
        for (var i = 0; i < res.length; i++){
            dt.push({_text: res[i]})
        }
        res_view.setTabList(dt)
    }

    function updatePages(){
        var pages = CppPageSwapping.getPages()
        var dt = []
        for (var i = 0; i < pages.length; i++){
            dt.push({_text: pages[i]})
        }
        tab_view.setTabList(dt)
    }

    Component.onCompleted: {
        CppPageSwapping.doSwap()
        updatePages()
        updateRes()
    }
}
