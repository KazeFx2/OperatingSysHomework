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
                        width: 80
                        validator: RegExpValidator {regExp: /[0-9][0-9]/}
                    }

                    FluFilledButton {
                        anchors {
                            left: parent.children[1].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        disabled: max_n.text === ""
                        text: qsTr("Generate")
                        onClicked: {

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
                        width: 100
                        validator: RegExpValidator {regExp: /[0-9][0-9][0-9]/}
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
                                // prev = currentIndex = indexOfValue(CppPageSwapping.getStrategy())
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
                        text: qsTr("Magnetic head start position: ")
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Min magnetic track: ")
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Max magnetic track: ")
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Total distance: ")
                    }

                    FluText {
                        padding: 10
                        font.bold: true
                        text: qsTr("Distance average: ")
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        tab_view.appendTab("1")
        res_view.appendTab("1")
        tab_view.appendTab("1")
        res_view.appendTab("1")
    }
}
