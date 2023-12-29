import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Templates 2.15 as T
import "qrc:///qml/NavItems"

FluWindow {
    id: window

    property int item_height: 32
    property int item_pad: item_height / 4

    property int selected_n: 0
    property var editorPageRegister: registerForWindowResult("/editor")
    property var loginPageRegister: registerForWindowResult("/login")

    property string res_usr: ""

    Component.onCompleted: {
        loginPageRegister.launch({stayTop: stayTop})
    }

    title: qsTr("File Explorer")
    width: 1000
    height: 640
    minimumWidth: 650
    minimumHeight: 500
    fitsAppBarWindows: true
    launchMode: FluWindowType.SingleTask

    function editFile() {
        editorPageRegister.launch({stayTop: stayTop})
    }

    FluPopup {
        id: del_dialog
        property string title: qsTr("Delete File(s)")
        property string message: qsTr("Confirm delete?")
        property string neutralText: "Neutral"
        property string negativeText: qsTr("Cancel")
        property string positiveText: qsTr("Delete")
        property alias messageTextFormart: text_message.textFormat
        property int delayTime: 100
        signal neutralClicked
        signal negativeClicked
        signal positiveClicked
        onPositiveClicked: {
        }
        onNegativeClicked: {
        }
        property int buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        focus: true
        implicitWidth: 400
        implicitHeight: text_title.height + sroll_message.height + layout_actions.height
        Rectangle {
            id:layout_content
            anchors.fill: parent
            color: 'transparent'
            radius:5
            FluText{
                id:text_title
                font: FluTextStyle.Title
                text:del_dialog.title
                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                wrapMode: Text.WrapAnywhere
                anchors{
                    top:parent.top
                    left: parent.left
                    right: parent.right
                }
            }
            Flickable{
                id:sroll_message
                contentWidth: width
                clip: true
                anchors{
                    top:text_title.bottom
                    left: parent.left
                    right: parent.right
                }
                boundsBehavior:Flickable.StopAtBounds
                contentHeight: text_message.height
                height: Math.min(text_message.height,300)
                ScrollBar.vertical: FluScrollBar {}
                FluText{
                    id:text_message
                    font: FluTextStyle.Body
                    wrapMode: Text.WrapAnywhere
                    text:del_dialog.message
                    width: parent.width
                    topPadding: 14
                    leftPadding: 20
                    rightPadding: 20
                    bottomPadding: 14
                }
            }
            Rectangle{
                id:layout_actions
                height: 68
                radius: 5
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
                anchors{
                    top:sroll_message.bottom
                    left: parent.left
                    right: parent.right
                }
                RowLayout{
                    anchors
                    {
                        centerIn: parent
                        margins: spacing
                        fill: parent
                    }
                    spacing: 15
                    FluButton{
                        id:neutral_btn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: del_dialog.buttonFlags&FluContentDialogType.NeutralButton
                        text: del_dialog.neutralText
                        onClicked: {
                            del_dialog.close()
                            timer_delay.targetFlags = FluContentDialogType.NeutralButton
                            timer_delay.restart()
                        }
                    }
                    FluButton{
                        id:negative_btn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: del_dialog.buttonFlags&FluContentDialogType.NegativeButton
                        text: del_dialog.negativeText
                        onClicked: {
                            del_dialog.close()
                            timer_delay.targetFlags = FluContentDialogType.NegativeButton
                            timer_delay.restart()
                        }
                    }
                    FluButton{
                        id:positive_btn
                        normalColor: FluColors.Red.light
                        hoverColor: FluColors.Red.normal
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: del_dialog.buttonFlags&FluContentDialogType.PositiveButton
                        text: del_dialog.positiveText
                        onClicked: {
                            del_dialog.close()
                            timer_delay.targetFlags = FluContentDialogType.PositiveButton
                            timer_delay.restart()
                        }
                    }
                }
            }
        }
        Timer{
            property int targetFlags
            id:timer_delay
            interval: del_dialog.delayTime
            onTriggered: {
                if(targetFlags === FluContentDialogType.NegativeButton){
                    del_dialog.negativeClicked()
                }
                if(targetFlags === FluContentDialogType.NeutralButton){
                    del_dialog.neutralClicked()
                }
                if(targetFlags === FluContentDialogType.PositiveButton){
                    del_dialog.positiveClicked()
                }
            }
        }
    }

    FluPopup {
        id: name_input
        property string title: qsTr("Input the new name")
        property string negativeText: qsTr("Cancel")
        property string positiveText: qsTr("OK")
        property alias messageTextFormart: text_message.textFormat
        property int delayTime: 100
        signal negativeClicked
        signal positiveClicked
        onPositiveClicked: {
        }
        onNegativeClicked: {
        }
        property int buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        focus: true
        implicitWidth: 400
        implicitHeight: ni_title.height + ni_actions.height + btm_m.height + name_in.height + 20
        Rectangle {
            anchors.fill: parent
            color: 'transparent'
            radius:5
            FluText{
                id:ni_title
                font: FluTextStyle.Title
                text:name_input.title
                topPadding: 20
                leftPadding: 20
                rightPadding: 20
                wrapMode: Text.WrapAnywhere
                anchors{
                    top:parent.top
                    left: parent.left
                    right: parent.right
                }
            }

            FluTextBox {
                id: name_in
                anchors.top: ni_title.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                width: parent.width - 50
            }

            Rectangle {
                id: btm_m
                anchors.top: name_in.bottom
                height: 20
                width: parent.width
                color: 'transparent'
            }

            Rectangle{
                id:ni_actions
                height: 68
                radius: 5
                color: FluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
                anchors{
                    top:btm_m.bottom
                    left: parent.left
                    right: parent.right
                }
                RowLayout{
                    anchors
                    {
                        centerIn: parent
                        margins: spacing
                        fill: parent
                    }
                    spacing: 15
                    FluButton{
                        id:neg_btn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: name_input.buttonFlags&FluContentDialogType.NegativeButton
                        text: name_input.negativeText
                        onClicked: {
                            name_input.close()
                            ni_timer_delay.targetFlags = FluContentDialogType.NegativeButton
                            ni_timer_delay.restart()
                        }
                    }
                    FluFilledButton{
                        id:pos_btn
                        disabled: name_in.text == ""
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: name_input.buttonFlags&FluContentDialogType.PositiveButton
                        text: name_input.positiveText
                        onClicked: {
                            name_input.close()
                            ni_timer_delay.targetFlags = FluContentDialogType.PositiveButton
                            ni_timer_delay.restart()
                        }
                    }
                }
            }
        }
        Timer{
            property int targetFlags
            id:ni_timer_delay
            interval: name_input.delayTime
            onTriggered: {
                if(targetFlags === FluContentDialogType.NegativeButton){
                    name_input.negativeClicked()
                }
                if(targetFlags === FluContentDialogType.PositiveButton){
                    name_input.positiveClicked()
                }
            }
        }
    }

    function deleteFile() {
            del_dialog.open()
    }

    function nameInput() {
        name_in.text = ""
        name_input.open()
    }

    Connections {
        target: window.loginPageRegister
        function onResult(data){
            if (data.status === -1)
                window.loginPageRegister.launch({stayTop: stayTop})
            else {
                res_usr = data.usr
                wind_loader.sourceComponent = main_win
            }
        }
    }

    FluLoader {
        id: wind_loader
        sourceComponent: login_need
        anchors.fill: parent
    }

    Component {
        id: login_need
        Item{
            anchors.fill: parent
            Rectangle {
                width: childrenRect.width
                height: childrenRect.height
                anchors.centerIn: parent
                color: FluColors.Transparent
                FluText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    padding: 10
                    text: qsTr("Oops! You canceled the login!")
                }
                FluFilledButton{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.children[0].bottom
                    text: "Retry"
                    onClicked: {
                        window.loginPageRegister.launch({stayTop: stayTop})
                    }
                }
            }
        }
    }

    Component {
        id: main_win
        Item {
            id: main_page

            anchors.fill: parent

            FluText {
                padding: 10
                text: qsTr("File Explorer")
            }

            Rectangle {
                y: 40
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 20
                height: parent.height - 50
                color: FluColors.Transparent

                Rectangle {
                    width: parent.width
                    height: childrenRect.height
                    color: FluColors.Transparent

                    FluText {
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                        text: qsTr("Current Directory: ")
                        font.pixelSize: dir_url.textSize - 5
                    }

                    FluText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.children[0].right
                        text: "/"
                        font.pixelSize: dir_url.textSize
                    }

                    FluBreadcrumbBar{
                        id: dir_url
                        anchors.left: parent.children[1].right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - search_rect.width
                        separator: "/"
                        spacing: 1
                        textSize: 18
                        onClickItem: (model)=>{

                        }

                        Component.onCompleted: {
                            var its = [{title: res_usr}]
                            items = its
                        }
                    }

                    Rectangle {
                        id: search_rect
                        anchors.right: parent.right
                        width: childrenRect.width
                        height: childrenRect.height
                        color: FluColors.Transparent

                        FluText {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            padding: 10
                            font.bold: true
                            text: qsTr("Search")
                        }

                        FluTextBox {
                            id: search_input
                            anchors.left: parent.children[0].right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 250
                        }

                        FluIconButton {
                            anchors.left: parent.children[1].right
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            iconSource: FluentIcons.Search
                            disabled: search_input.text == ""
                        }
                    }
                }

                Rectangle {
                    height: parent.height - parent.children[0].height
                    width: parent.width
                    anchors.top: parent.children[0].bottom
                    color: FluColors.Transparent

                    FluText {
                        font.bold: true
                        padding: 10
                        text: qsTr("Current User:")
                    }

                    FluText {
                        id: usr_name
                        anchors.left: parent.children[0].right
                        padding: 10
                        text: res_usr
                    }

                    FluArea {
                        id: left_filetree
                        topPadding: 10
                        bottomPadding: topPadding
                        property int pad_inner: 8
                        property int minW: 52 + pad_inner * 2
                        anchors.left: parent.left
                        anchors.top: parent.children[0].bottom
                        width: parent.width > 900 ? parent.width * 1 / 5 : minW
                        height: parent.height - parent.children[0].height
                        // color: FluColors.Transparent
                        Behavior on width {
                            NumberAnimation {
                                duration: 250
                            }
                        }

                        FluText {
                            leftPadding: 10
                            visible: parent.width > left_filetree.minW
                            text: qsTr("Tool box")
                            font.pixelSize: 15
                            font.bold: true
                            height: visible ? padding * 2 + font.pixelSize : 0
                            Behavior on height {
                                NumberAnimation {
                                    duration: 250
                                }
                            }
                        }

                        Flickable {
                            // policy: T.ScrollBar.AsNeeded
                            boundsBehavior: Flickable.StopAtBounds
                            contentWidth: parent.width
                            contentHeight: cont.height
                            clip: true
                            ScrollBar.vertical: FluScrollBar {
                                anchors.right: parent.right
                                anchors.rightMargin: 2 - left_filetree.paddings
                            }
                            anchors{
                                top: parent.children[0].bottom
                                topMargin: 10
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                            }

                            ListView {
                                id: cont
                                width: parent.width - 2 * left_filetree.pad_inner
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: childrenRect.height
                                // implicitHeight: parent.height
                                orientation: ListView.Vertical
                                spacing: 5

                                model: ListModel {
                                    id: left_filetree_model

                                    // ListElement {
                                    //     icon: FluentIcons.Folder
                                    //     title: "Test"
                                    //     type: 0
                                    //     dis: false
                                    // }
                                }

                                delegate: Rectangle {
                                    property bool _dis: {
                                        switch(index) {
                                        case 3:
                                            return window.selected_n !== 1
                                        case 4:
                                        case 7:
                                            return window.selected_n === 0
                                        default:
                                            break
                                        }
                                        return dis
                                    }
                                    width: type !== 1 ? parent.width - 20 : parent.width - 10
                                    height: type !== 1 ? window.item_height : 2
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    radius: 5
                                    border.color: FluTools.colorAlpha(FluColors.Grey110, 0.5)
                                    border.width: type === 0 ? 1 : 0
                                    color: type === 0 ? _dis ? FluColors.Transparent : (children[3].hover ? (children[3].clicked ? FluColors.Grey110 : FluTools.colorAlpha(FluColors.Grey110, 0.5)) : FluColors.Transparent) : type === 1 ? border.color : FluColors.Transparent
                                    opacity: type === 0 ? _dis ? 0.5 : 1.0 : 1.0
                                    clip: type !== 2

                                    FluIcon {
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: type !== 1 && icon != ""
                                        padding: window.item_pad
                                        iconSize: window.item_height - padding * 2
                                        iconSource: type !== 1 ? icon : FluentIcons.AppIconDefault
                                        iconColor: (icon != "" && icon === FluentIcons.Delete) ? FluColors.Red.light : FluTheme.dark ? "#FFFFFF" : "#000000"
                                    }

                                    FluText {
                                        visible: type !== 1 && parent.width > left_filetree.minW
                                        anchors.left: icon != "" ? parent.children[0].right : parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: title
                                        font.pixelSize: parent.children[0].iconSize - 2
                                        textColor: (icon != "" && icon === FluentIcons.Delete) ? FluColors.Red.light : FluTheme.dark ? "#FFFFFF" : "#000000"
                                    }

                                    Rectangle {
                                        visible: type === 2
                                        anchors.top: parent.children[1].bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.topMargin: 5
                                        height: 2
                                        width: parent.width + 10
                                        color: parent.border.color
                                        radius: 2
                                    }

                                    MouseArea {
                                        enabled: type !== 1
                                        width: parent.width
                                        height: parent.height
                                        hoverEnabled: true
                                        property bool clicked: false
                                        property bool hover: false
                                        onHoveredChanged: {
                                            hover = !hover
                                            if (!hover)
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
                                        onClicked: {
                                            if (!_dis){
                                                func(index, title, type)
                                            }
                                        }
                                        function func(index, title, type) {
                                            // showInfo(index + "_" + title + "_" + type)
                                            switch(index) {
                                            case 3:
                                            case 5:
                                            case 6:
                                            {
                                                window.nameInput()
                                            }
                                                break
                                            case 4:
                                            {
                                                window.deleteFile()
                                            }
                                                break
                                            case 9:
                                            {
                                                for (var i = 0; i < right_files_model.count; i++){
                                                    var tmp = right_files_model.get(i)
                                                    if (tmp.title === "..")
                                                        continue
                                                    tmp.select = true
                                                    right_files_model.set(i, tmp)
                                                }
                                            }
                                                break
                                            case 10:
                                            {
                                                for (i = 0; i < right_files_model.count; i++){
                                                    tmp = right_files_model.get(i)
                                                    if (tmp.title === "..")
                                                        continue
                                                    tmp.select = false
                                                    right_files_model.set(i, tmp)
                                                }
                                            }
                                                break
                                            case 11:
                                            {
                                                for (i = 0; i < right_files_model.count; i++){
                                                    tmp = right_files_model.get(i)
                                                    if (tmp.title === "..")
                                                        continue
                                                    tmp.select = !tmp.select
                                                    right_files_model.set(i, tmp)
                                                }
                                            }
                                                break
                                            default:
                                                break
                                            }
                                        }
                                    }

                                    FluTooltip{
                                        parent: parent.handle
                                        visible: parent.children[3].hover && !parent.children[1].visible
                                        text: String(title)
                                    }
                                }

                                Component.onCompleted: {
                                    var dt = [{
                                                  icon: FluentIcons.DeveloperTools,
                                                  title: qsTr("Quick Operations"),
                                                  type: 2,
                                                  dis: true
                                              },
                                              {
                                                  icon: FluentIcons.Copy,
                                                  title: qsTr("Copy"),
                                                  type: 0,
                                                  dis: true
                                              },
                                              {
                                                  icon: FluentIcons.Paste,
                                                  title: qsTr("Paste"),
                                                  type: 0,
                                                  dis: true
                                              },
                                              {
                                                  icon: FluentIcons.Rename,
                                                  title: qsTr("Rename"),
                                                  type: 0,
                                                  dis: true
                                              },
                                              {
                                                  icon: FluentIcons.Delete,
                                                  title: qsTr("Delete"),
                                                  type: 0,
                                                  dis: true
                                              },
                                              {
                                                  icon: FluentIcons.NewFolder,
                                                  title: qsTr("NewFolder"),
                                                  type: 0,
                                                  dis: false
                                              },
                                              {
                                                  icon: FluentIcons.Add,
                                                  title: qsTr("NewFile"),
                                                  type: 0,
                                                  dis: false
                                              },
                                              {
                                                  icon: FluentIcons.Edit,
                                                  title: qsTr("ChangeMode"),
                                                  type: 0,
                                                  dis: true
                                              },
                                              {
                                                  icon: "",
                                                  title: "",
                                                  type: 1,
                                                  dis: true
                                              },
                                              {
                                                  icon: FluentIcons.SelectAll,
                                                  title: qsTr("SelectAll"),
                                                  type: 0,
                                                  dis: false
                                              },
                                              {
                                                  icon: FluentIcons.ClearSelection,
                                                  title: qsTr("UnselectAll"),
                                                  type: 0,
                                                  dis: false
                                              },
                                              {
                                                  icon: FluentIcons.Switch,
                                                  title: qsTr("Inverse"),
                                                  type: 0,
                                                  dis: false
                                              },
                                              {
                                                  icon: "",
                                                  title: "",
                                                  type: 1,
                                                  dis: true
                                              },
                                              {
                                                  icon: FluentIcons.Folder,
                                                  title: "Home",
                                                  type: 0,
                                                  dis: false
                                              }]
                                    for (var i = 0; i < dt.length; i++){
                                        left_filetree_model.append(dt[i])
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: right_files
                        anchors.top: parent.children[0].bottom
                        anchors.right: parent.right
                        anchors.left: left_filetree.right
                        anchors.leftMargin: 10
                        height: parent.height - parent.children[0].height
                        color: FluColors.Transparent

                        FluArea {
                            width: parent.width
                            height: parent.height

                            Rectangle {
                                height: 10
                                width: parent.width
                                color: FluColors.Transparent
                            }

                            Flickable {
                                // policy: T.ScrollBar.AsNeeded
                                boundsBehavior: Flickable.StopAtBounds
                                contentWidth: parent.width
                                contentHeight: cont_r.height
                                clip: true
                                ScrollBar.vertical: FluScrollBar {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 2
                                }
                                anchors{
                                    top: parent.children[0].bottom
                                    left: parent.left
                                    right: parent.right
                                    bottom: parent.children[2].top
                                }

                                FluMenu {
                                    id: menu
                                    property bool noAct: false
                                    property int type: -1
                                    property string name: ""
                                    property bool select: false
                                    property int index: -1
                                    FluMenuItem{
                                        text: qsTr("Open")
                                        enabled: true
                                        iconSource: FluentIcons.OpenFile
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                            // showInfo(menu.name)
                                            if (type === 1)
                                                window.editFile()
                                        }
                                    }
                                    FluMenuItem{
                                        text: qsTr("Copy")
                                        enabled: false
                                        iconSource: FluentIcons.Copy
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                        }
                                    }
                                    FluMenuItem{
                                        text: qsTr("Paste")
                                        enabled: false
                                        iconSource: FluentIcons.Paste
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                        }
                                    }
                                    FluMenuItem{
                                        text: qsTr("Rename")
                                        enabled: menu.name == ".." ? false : true
                                        iconSource: FluentIcons.Rename
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                            window.nameInput()
                                        }
                                    }
                                    FluMenuItem{
                                        text: qsTr("ChangeMode")
                                        enabled: menu.name == ".." ? false : true
                                        iconSource: FluentIcons.Edit
                                        iconSpacing: window.item_pad
                                        opacity: enabled ? 1.0 : 0.5
                                        onTriggered: {
                                        }
                                    }
                                    FluMenuSeparator {}
                                    Action {
                                        text: qsTr("Select")
                                        enabled: menu.name == ".." ? false : true
                                        checkable: true
                                        checked: menu.select
                                        onCheckedChanged: {
                                            if (menu.noAct)
                                                return
                                            var item = right_files_model.get(menu.index)
                                            item.select = checked
                                            menu.select = checked
                                            right_files_model.set(menu.index, item)
                                        }
                                    }
                                    FluMenuSeparator {}
                                    T.MenuItem {
                                        property int iconSpacing: window.item_pad
                                        property int iconSource: FluentIcons.Delete
                                        property int iconSize: 16
                                        property color textColor: FluColors.Red.light

                                        text: qsTr("Delete")
                                        enabled: menu.name == ".." ? false : true
                                        opacity: enabled ? 1.0 : 0.5
                                        id: control
                                        implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                                                implicitContentWidth + leftPadding + rightPadding)
                                        implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                                                 implicitContentHeight + topPadding + bottomPadding,
                                                                 implicitIndicatorHeight + topPadding + bottomPadding)
                                        padding: 6
                                        spacing: 6
                                        icon.width: 24
                                        icon.height: 24
                                        icon.color: control.palette.windowText
                                        height: visible ? implicitHeight : 0

                                        onTriggered: {
                                            window.deleteFile()
                                        }
                                        Component{
                                            id:com_icon
                                            FluIcon{
                                                id:content_icon
                                                iconSize: control.iconSize
                                                iconSource:control.iconSource
                                                color: FluColors.Red.light
                                            }
                                        }
                                        contentItem: Item{
                                            Row{
                                                spacing: control.iconSpacing
                                                readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
                                                readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
                                                anchors{
                                                    verticalCenter: parent.verticalCenter
                                                    left: parent.left
                                                    leftMargin: (!control.mirrored ? indicatorPadding : arrowPadding)+5
                                                    right: parent.right
                                                    rightMargin: (control.mirrored ? indicatorPadding : arrowPadding)+5
                                                }
                                                FluLoader{
                                                    id:loader_icon
                                                    sourceComponent: com_icon
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    visible: status === Loader.Ready
                                                }
                                                FluText {
                                                    id:content_text
                                                    text: control.text
                                                    color: control.textColor
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                            }
                                        }
                                        indicator: FluIcon {
                                            x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
                                            y: control.topPadding + (control.availableHeight - height) / 2
                                            visible: control.checked
                                            iconSource: FluentIcons.CheckMark
                                        }
                                        arrow: FluIcon {
                                            x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
                                            y: control.topPadding + (control.availableHeight - height) / 2
                                            visible: control.subMenu
                                            iconSource: FluentIcons.ChevronRightMed
                                        }
                                        background: Item {
                                            implicitWidth: 150
                                            implicitHeight: 36
                                            x: 1
                                            y: 1
                                            width: control.width - 2
                                            height: control.height - 2
                                            Rectangle{
                                                anchors.fill: parent
                                                anchors.margins: 3
                                                radius: 4
                                                color:{
                                                    if(control.highlighted){
                                                        return FluTheme.itemCheckColor
                                                    }
                                                    return FluTheme.itemNormalColor
                                                }
                                            }
                                        }
                                    }
                                }

                                ListView {
                                    id: cont_r
                                    width: parent.width
                                    height: childrenRect.height
                                    // implicitHeight: parent.height
                                    orientation: ListView.Vertical
                                    spacing: 5

                                    model: ListModel {
                                        id: right_files_model

                                        // ListElement {
                                        //     icon: FluentIcons.Folder
                                        //     title: "Test"
                                        //     type: 0
                                        //     dis: false
                                        // }
                                    }

                                    delegate: Rectangle {
                                        width: parent.width - 30
                                        height: window.item_height
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        radius: 5
                                        border.color: FluTools.colorAlpha(FluColors.Grey110, 0.5)
                                        border.width: 1
                                        color: children[3].hover ? (children[3].clicked ? FluColors.Grey110 : FluTools.colorAlpha(FluColors.Grey110, 0.5)) : FluColors.Transparent
                                        clip: true

                                        FluCheckBox {
                                            anchors {
                                                top: parent.top
                                                verticalCenter: parent.verticalCenter
                                            }
                                            leftPadding: select ? window.item_pad : -18
                                            checked: select
                                            visible: select
                                            disabled: !select
                                            // size: select ? 18 : 0
                                            onCheckedChanged: {
                                                if (!checked) {
                                                    select = false
                                                }
                                                if (checked) {
                                                    window.selected_n ++
                                                } else {
                                                    window.selected_n --
                                                }
                                            }
                                            onVisibleChanged: {
                                                checked = select
                                            }
                                            Behavior on leftPadding {
                                                NumberAnimation { duration: 250 }
                                            }
                                        }

                                        FluIcon {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.children[0].right
                                            padding: window.item_pad
                                            iconSize: window.item_height - padding * 2
                                            iconSource: type === 0 ? FluentIcons.Folder : FluentIcons.Document
                                        }

                                        FluText {
                                            anchors.left: parent.children[1].right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: title
                                            font.pixelSize: parent.children[1].iconSize - 2
                                        }

                                        MouseArea {
                                            property int doubleclickct: 0
                                            anchors.left: parent.children[0].right
                                            width: parent.width - parent.children[0].width
                                            height: parent.height
                                            hoverEnabled: true
                                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                                            property bool clicked: false
                                            property bool hover: false
                                            onHoveredChanged: {
                                                hover = !hover
                                                if (!hover)
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
                                            function delay(delayTime, cb) {
                                                var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", window);
                                                timer.interval = delayTime;
                                                timer.repeat = false;
                                                timer.triggered.connect(cb);
                                                timer.start();
                                            }
                                            function sg_clk(){
                                                if (doubleclickct == 0){
                                                    select = !select
                                                } else {
                                                    doubleclickct --
                                                }
                                            }
                                            onClicked: (Mouse)=>{
                                                if (Mouse.button === Qt.RightButton){
                                                    menu.noAct = true
                                                    menu.type = type
                                                    menu.name = title
                                                    menu.select = select
                                                    menu.index = index
                                                    menu.noAct = false
                                                    menu.popup()
                                                } else if (Mouse.button === Qt.LeftButton) {
                                                    // select = !select
                                                    if (title == "..")
                                                        return
                                                    delay(200, sg_clk)
                                                }
                                            }
                                            onDoubleClicked: (Mouse)=>{
                                                if (Mouse.button === Qt.LeftButton) {
                                                    doubleclickct ++
                                                    // showInfo(title)
                                                    if (type === 1)
                                                        window.editFile()
                                                }
                                            }
                                        }
                                    }

                                    Component.onCompleted: {
                                        var dt = [{
                                                      title: "..",
                                                      type: 0,
                                                      select: false
                                                  },
                                                  {
                                                      title: "Folder",
                                                      type: 0,
                                                      select: false
                                                  },
                                                  {
                                                      title: "Folder1",
                                                      type: 0,
                                                      select: false
                                                  },
                                                  {
                                                      title: "Empty.txt",
                                                      type: 1,
                                                      select: false
                                                  }]
                                        for (var i = 0; i < dt.length; i++){
                                            right_files_model.append(dt[i])
                                        }
                                        for (i = 0; i < 37; i++)
                                            right_files_model.append(
                                                        {
                                                            title: "Empty" + i + ".txt",
                                                            type: 1,
                                                            select: false
                                                        })
                                    }
                                }
                            }

                            Rectangle {
                                height: 10
                                width: parent.width
                                anchors.bottom: parent.bottom
                                color: FluColors.Transparent
                            }
                        }
                    }
                }
            }
        }
    }

    appBar: FluAppBar {
        id: app_bar

        darkText: qsTr("SwitchTheme")
        showDark: true
        darkClickListener: (button) => {
            if (FluTheme.dark)
                FluTheme.darkMode = FluThemeType.Light;
            else
                FluTheme.darkMode = FluThemeType.Dark;
        }
        closeClickListener: () => {
            FluApp.exit(0);
        }
        z: 0

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        FluMenuBar {
           visible: wind_loader.sourceComponent === main_win
           id: head_menu
           padding: 5
           x: 100
           FluMenu {
               id: about
               title: qsTr("About")
               Action {
                    text: qsTr("This Project...")
                    onTriggered: {

                    }
               }
           }
        }

    }

}
