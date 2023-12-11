import QtQuick 2.15
import FluentUI 1.0
import QtQuick.Layouts 1.15

FluScrollablePage {

    id: root

    title: qsTr("Dynamic Partitions")

    width: parent.width
    height: parent.height

    Component{
        id:checbox
        Item{
            FluCheckBox{
                anchors.centerIn: parent
                checked: true === options.checked
                enableAnimation: true
                clickListener: function(){
                    var obj = tableModel.getRow(row)
                    obj.checkbox = table_view.customItem(checbox,{checked:!options.checked})
                    tableModel.setRow(row,obj)
                    checkBoxChanged()
                }
            }
        }
    }

    Component{
        id: action
        Item{
            RowLayout{
                anchors.centerIn: parent
                FluButton{
                    text: qsTr("Delete")
                    onClicked: {
                        // var pid = row.id
                        // var ret = CppBankAlgorithm.deleteProcess(pid)
                        // if (ret) {
                        //     table_view.closeEditor()
                        //     tableModel.removeRow(row)
                        //     checkBoxChanged()
                        //     showSuccess(qsTr("Delete process successfully"))
                        // } else {
                        //     showError(qsTr("Delete process failed"))
                        // }
                    }
                }
            }
        }
    }

    Component{
        id:column_checbox
        Item{
            RowLayout{
                anchors.centerIn: parent
                FluText{
                    text: qsTr("Select all")
                    Layout.alignment: Qt.AlignVCenter
                }
                FluCheckBox{
                    checked: true === options.checked
                    enableAnimation: false
                    Layout.alignment: Qt.AlignVCenter
                    clickListener: function(){
                        var checked = !options.checked
                        itemModel.display = table_view.customItem(column_checbox, {checked: checked})
                        for(var i = 0; i < tableModel.rowCount; i++){
                            var rowData = tableModel.getRow(i)
                            rowData.checkbox = table_view.customItem(checbox, {checked: checked})
                            tableModel.setRow(i, rowData)
                        }
                    }
                }
                Connections{
                    target: root
                    function onCheckBoxChanged(){
                        for(var i = 0; i < tableModel.rowCount; i++){
                            if(false === tableModel.getRow(i).checkbox.options.checked){
                                itemModel.display = table_view.customItem(column_checbox, {checked: false})
                                return
                            }
                        }
                        itemModel.display = table_view.customItem(column_checbox, {checked: true})
                    }
                }
            }
        }
    }

    Component{
        id:column_sort_src
        Item{
            FluText{
                text: options.name
                anchors.centerIn: parent
            }
            ColumnLayout{
                spacing: 0
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronUp
                    iconColor: {
                        if(options.inx === root.sortTypeUp){
                            return FluTheme.primaryColor
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortTypeUp === options.inx){
                            root.sortTypeUp = -1
                            return
                        }
                        root.sortTypeDown = -1
                        root.sortTypeUp = options.inx
                    }
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronDown
                    iconColor: {
                        if(options.inx === root.sortTypeDown){
                            return FluTheme.primaryColor
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortTypeDown === options.inx){
                            root.sortTypeDown = -1
                            return
                        }
                        root.sortTypeUp = -1
                        root.sortTypeDown = options.inx
                    }
                }
            }
        }
    }

    FluArea {

        Layout.topMargin: 10

        width: parent.width

        height: inner_col.height + paddings * 2

        paddings: 10

        Column {

            id: inner_col

            width: parent.width

            FluText {

                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: "Partitions"

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

            FluTableView{
                id:table_view
                width: parent.width
                height: (dataSource.length + 1) * 50 - 8
                color: FluTools.colorAlpha(FluColors.Black, FluTheme.dark ? 0.2 : 0.05)
                radius: 8
                anchors.topMargin: 20
                columnSource: [
                    {
                        title: table_view.customItem(column_checbox, {checked: false}),
                        dataIndex: 'checkbox',
                        width: 100,
                        minimumWidth: 100,
                        maximumWidth: 100,
                    },
                    {
                        title: table_view.customItem(column_sort_src, {name: "Number", inx: 0}),
                        dataIndex: 'index',
                        width: (parent.width - 232) / 3 > 120 ? (parent.width - 232) / 3 : 120,
                        minimumWidth: 120,
                        maximumWidth: (parent.width - 232) / 3 > 120 ? (parent.width - 232) / 3 : 120,
                        readOnly: true
                    },
                    {
                        title: table_view.customItem(column_sort_src, {name: "StartAddress", inx: 1}),
                        dataIndex: 'start',
                        width: (parent.width - 232) / 3 > 120 ? (parent.width - 232) / 3 : 120,
                        minimumWidth: 120,
                        maximumWidth: (parent.width - 232) / 3 > 120 ? (parent.width - 232) / 3 : 120,
                        readOnly: true
                    },
                    {
                        title: table_view.customItem(column_sort_src, {name: "Size", inx: 2}),
                        dataIndex: 'size',
                        width: (parent.width - 232) / 3 > 120 ? (parent.width - 232) / 3 : 120,
                        minimumWidth: 120,
                        maximumWidth: (parent.width - 232) / 3 > 120 ? (parent.width - 232) / 3 : 120,
                        readOnly: true
                    },
                    {
                        title: qsTr("Operation"),
                        dataIndex: "action",
                        width: 100,
                        minimumWidth: 100,
                        maximumWidth: 100
                    }
                ]
            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            FluFilledButton {

                x: (parent.width - width) / 2
                text: "Delete Selected"

            }

            FluText {

                padding: 10
                font.bold: true
                font.pixelSize: 16
                text: "Management"

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

                    text: "Clear All"

                }

                Rectangle {

                    width: childrenRect.width
                    height: childrenRect.height
                    color: FluColors.Transparent
                    anchors.horizontalCenter: parent.horizontalCenter

                    FluText {

                        text: "Strategy"
                        anchors.verticalCenter: parent.verticalCenter

                    }

                    Rectangle {

                        height: childrenRect.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        anchors.leftMargin: 10
                        color: FluColors.Transparent
                        width: 100

                        FluComboBox{
                            editable: false
                            anchors.left: parent.left
                            anchors.right: parent.right
                            model: ListModel {
                                id: model
                                ListElement { text: "FF" }
                                ListElement { text: "NF" }
                                ListElement { text: "BF" }
                                ListElement { text: "WF" }
                            }
                            onAccepted: {

                            }
                        }
                    }

                    FluFilledButton {

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[1].right
                        anchors.leftMargin: 10
                        text: "Apply"

                    }

                }

                FluFilledButton {

                    anchors.right: parent.right

                    text: "Load Default"

                }

            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            FluText {
                padding: 10
                font.bold: true
                text: "Add Partition"
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

                    id: saddr_zone
                    anchors.verticalCenter: parent.verticalCenter
                    height: childrenRect.height
                    width: parent.width * 2 / 5
                    color: FluColors.Transparent

                    FluText {

                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: "Start Address"

                    }

                    FluTextBox {

                        anchors.left: parent.children[0].right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - 10
                        validator: IntValidator {}

                    }

                }

                Rectangle {

                    anchors.left: saddr_zone.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: childrenRect.height
                    width: parent.width * 2 / 5
                    color: FluColors.Transparent

                    FluText {

                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: "Size"

                    }

                    FluTextBox {

                        anchors.left: parent.children[0].right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - 10
                        validator: IntValidator {}

                    }

                }

                Rectangle {

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: childrenRect.height
                    width: parent.width * 1 / 5
                    color: FluColors.Transparent

                    FluFilledButton {

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: "Add"

                    }

                }

            }

            Rectangle {
                height: 10
                width: parent.width
                color: FluColors.Transparent
            }

            FluText {
                padding: 10
                font.bold: true
                text: "Allocate memory / Free memory"
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

                    width: parent.width / 2
                    height: childrenRect.height
                    anchors.verticalCenter: parent.verticalCenter
                    color: FluColors.Transparent

                    FluText {

                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: "Size"

                    }

                    FluTextBox {

                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - parent.children[2].width - 10
                        anchors.left: parent.children[0].right

                    }

                    FluFilledButton {

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: "Allocate"

                    }

                }

                Rectangle {

                    width: parent.width / 2
                    height: childrenRect.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    color: FluColors.Transparent

                    FluText {

                        anchors.verticalCenter: parent.verticalCenter
                        padding: 10
                        text: "Address"

                    }

                    FluTextBox {

                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.children[0].width - parent.children[2].width - 10
                        anchors.left: parent.children[0].right

                    }

                    FluFilledButton {

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        text: "Free"

                    }

                }
            }

        }

    }

    function loadData(){
        const dataSource = []
        for(var i = 0; i < 5; i++){
            var tmp = {
                checkbox: table_view.customItem(checbox,{checked: false}),
                index: i,
                start: i,
                size: i,
                action: table_view.customItem(action),
                minimumHeight: 50
            }
            dataSource.push(tmp)
        }
        table_view.dataSource = dataSource
    }

    Component.onCompleted: {
        loadData()
    }

}
