import QtQuick 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15
import "qrc:/src/js/tools.js" as Tools

FluScrollablePage {
    id: root

    property int sortTypeUp: -1
    property int sortTypeDown: -1

    property double tdt: -1
    property double tdwt: -1

    title: qsTr("Process Schedule")
    width: parent.width
    height: parent.height

    Component {
        id: col_sort_button

        Item {

            FluText {
                text: options.name
                anchors.centerIn: parent
            }

            ColumnLayout {
                spacing: 0

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }

                FluIconButton {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding: 0
                    horizontalPadding: 0
                    iconSource: FluentIcons.ChevronUp

                    iconColor: {
                        if (options.inx === root.sortTypeUp)
                            return FluTheme.primaryColor;

                        return FluTheme.dark ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1);
                    }

                    onClicked: {
                        if (root.sortTypeUp === options.inx) {
                            root.sortTypeUp = -1;
                            return;
                        }
                        root.sortTypeDown = -1;
                        root.sortTypeUp = options.inx;
                    }
                }

                FluIconButton {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding: 0
                    horizontalPadding: 0
                    iconSource: FluentIcons.ChevronDown

                    iconColor: {
                        if (options.inx === root.sortTypeDown)
                            return FluTheme.primaryColor;

                        return FluTheme.dark ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1);
                    }

                    onClicked: {
                        if (root.sortTypeDown === options.inx) {
                            root.sortTypeDown = -1;
                            return;
                        }
                        root.sortTypeUp = -1;
                        root.sortTypeDown = options.inx;
                    }
                }
            }
        }
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
                text: qsTr("Processes")
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

            FluTableView {
                id: table_view

                width: parent.width
                height: (dataSource.length + 1) * 50 - 8
                color: FluTools.colorAlpha(FluColors.Black, FluTheme.dark ? 0.2 : 0.05)
                radius: 8

                columnSource: [{
                    "title": qsTr("Name"),
                    "dataIndex": "name",
                    "width": 100,
                    "minimumWidth": 100,
                    "maximumWidth": 100,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("PID"),
                        "inx": 0
                    }),
                    "dataIndex": "pid",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("Priority"),
                        "inx": 1
                    }),
                    "dataIndex": "priority",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("SubmitTime"),
                        "inx": 2
                    }),
                    "dataIndex": "submit",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("ServeTime"),
                        "inx": 3
                    }),
                    "dataIndex": "serve",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("StartTime"),
                        "inx": 4
                    }),
                    "dataIndex": "start",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("FinishTime"),
                        "inx": 5
                    }),
                    "dataIndex": "finish",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("ResponseTime"),
                        "inx": 6
                    }),
                    "dataIndex": "response",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("TurnaroundTime"),
                        "inx": 7
                    }),
                    "dataIndex": "turnaround",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }, {
                    "title": table_view.customItem(col_sort_button, {
                        "name": qsTr("W_TurnaroundTime"),
                        "inx": 8
                    }),
                    "dataIndex": "turnaround_weight",
                    "width": 160,
                    "minimumWidth": 160,
                    "maximumWidth": 160,
                    "readOnly": true
                }]
            }

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: FluColors.Transparent

                FluText {
                    padding: 10
                    anchors.left: parent.left
                    text: Tools.format(qsTr("Mean of Turnaround Time: {0}"), root.tdt == -1 ? "null" : tdt.toString())
                }

                FluText {
                    padding: 10
                    anchors.right: parent.right
                    text: Tools.format(qsTr("Mean of Turnaround Time with Weight: {0}"), root.tdwt == -1 ? "null" : tdwt.toString())
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
                height: childrenRect.height
                width: parent.width
                color: FluColors.Transparent

                FluFilledButton {
                    anchors.left: parent.left
                    text: qsTr("Clear All")
                    onClicked: {
                        // TODO
                        var tmp = table_view.dataSource
                        for (var i = 0; i < tmp.length; i++) {
                            CppProcessSchedule.deleteProcess(tmp[i].pid)
                        }
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right

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
                            var ret = CppProcessSchedule.setStrategy(strategy.currentText)
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
                text: qsTr("Add Process")
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
                    id: line1

                    width: Math.max(line1.childrenRect.width, line2.childrenRect.width, line3.childrenRect.width, line4.childrenRect.width)
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.children[1].left
                        text: qsTr("Name")
                    }

                    FluTextBox {
                        id: name

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: 200
                        placeholderText: qsTr("Input the name")
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        text: qsTr("PID")
                    }

                    FluTextBox {
                        id: pid

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        width: 200
                        placeholderText: qsTr("Input the pid")
                        validator: IntValidator {
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
                    id: line2

                    width: line1.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.children[1].left
                        text: qsTr("Priority")
                    }

                    FluTextBox {
                        id: priority

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: 200
                        placeholderText: qsTr("Input the priority")
                        validator: IntValidator {
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
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        text: qsTr("Serve Time")
                    }

                    FluTextBox {
                        id: serve

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        width: 200
                        placeholderText: qsTr("Input the serve time")
                        validator: IntValidator {
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
                    id: line3

                    width: line1.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.children[1].left
                        text: qsTr("Submit Time")
                    }

                    FluTextBox {
                        id: submit

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: 200
                        placeholderText: qsTr("Input the submit time")
                        validator: IntValidator {
                        }
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: qsTr("Add")
                        disabled: name.text === "" || pid.text === "" || priority.text === "" || serve.text === "" || submit.text === ""

                        onClicked: {
                            var _name = name.text
                            var _pid = parseInt(pid.text)
                            var _priority = parseInt(priority.text)
                            var _serve = parseInt(serve.text)
                            var _submit = parseInt(submit.text)
                            if (CppProcessSchedule.addProcess(_name, _pid, _submit, _serve, _priority)) {
                                showSuccess(qsTr("Add process successfully"))
                                name.text = ""
                                pid.text = ""
                                priority.text = ""
                                serve.text = ""
                                submit.text = ""
                            } else {
                                showError(qsTr("Add process failed"))
                            }
                        }
                    }
                }
            }

            FluText {
                padding: 10
                font.bold: true
                text: qsTr("Delete Process")
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
                    id: line4

                    width: line1.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.children[1].left
                        text: qsTr("PID")
                    }

                    FluTextBox {
                        id: delete_pid

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        width: 200
                        placeholderText: qsTr("Input the pid")
                        validator: IntValidator {
                        }
                    }
                }

                Rectangle {
                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    FluFilledButton {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: qsTr("Delete")
                        disabled: delete_pid.text === ""

                        onClicked: {
                            var _pid = parseInt(delete_pid.text)
                            if (CppProcessSchedule.deleteProcess(_pid)) {
                                showSuccess(qsTr("Delete process successfully"))
                                delete_pid.text = ""
                            } else {
                                showError(qsTr("Delete process failed"))
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loadData()
    }

    Connections {
        target: CppProcessSchedule

        function onUpdateChanged() {
            loadData()
        }
    }

    function loadData() {
        const data = []
        CppProcessSchedule.doSchedule()
        var td = 0.0
        var tdw = 0.0
        var cd = CppProcessSchedule.getProcesses()
        for (var i = 0; i < cd.length; i++) {
            var tmp = {
                "name": cd[i].name,
                "pid": cd[i].pid,
                "priority": cd[i].priority,
                "submit": cd[i].submit,
                "serve": cd[i].serve,
                "start": cd[i].start === CppProcessSchedule.unset ? "null" : cd[i].start,
                "finish": cd[i].start === CppProcessSchedule.unset ? "null" : cd[i].start + cd[i].serve,
                "response": cd[i].start === CppProcessSchedule.unset ? "null" : cd[i].start - cd[i].submit,
                "turnaround": cd[i].start === CppProcessSchedule.unset ? "null" : cd[i].start + cd[i].serve - cd[i].submit,
                "turnaround_weight": cd[i].start === CppProcessSchedule.unset ? "null" : (cd[i].start + cd[i].serve - cd[i].submit) / cd[i].serve,
                "minimumHeight": 50
            }
            td += tmp["turnaround"]
            tdw += tmp["turnaround_weight"]
            data.push(tmp)
        }
        if (cd.length > 0) {
            td /= cd.length
            tdw /= cd.length
        } else {
            td = -1
            tdw = -1
        }
        root.tdt = td
        root.tdwt = tdw
        table_view.dataSource = data
    }
}
