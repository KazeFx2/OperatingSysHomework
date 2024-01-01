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
                // closeButtonVisibility: FluTabViewType.Nerver
                width: parent.width
                onNewPressed:{
                    page_in.text = ""
                    page_in.open()
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
                        anchors {
                            left: parent.children[0].right
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        width: 100
                        validator: RegExpValidator {regExp: /[0-9]/}
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
                        width: 100
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
                                    text: "SJF"
                                }

                                ListElement {
                                    text: "PSA"
                                }

                                ListElement {
                                    text: "HRRN"
                                }

                                ListElement {
                                    text: "RR"
                                }

                                ListElement {
                                    text: "MLFQ"
                                }
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
                closeButtonVisibility: FluTabViewType.Nerver
                width: parent.width
                addButtonVisibility: false
                onNewPressed:{
                }
            }
        }
    }

    Component.onCompleted: {
    }
}
