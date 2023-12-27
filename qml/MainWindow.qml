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

    Item {
        id: main_page

        anchors.fill: parent

        // FluNavigationView {
        //     id: navigation
        //
        //     width: parent.width
        //     height: parent.height
        //     anchors.fill: parent
        //     // the toppest
        //     z: 0
        //     pageMode: FluNavigationViewType.NoStack
        //     items: OriginalItems
        //     footerItems: FootItems
        //     topPadding: FluTools.isMacos() ? 20 : 0
        //     // displayMode: undefined
        //     logo: "qrc:///src/ico/App.ico"
        //     title: qsTr("Executable for Operating System Experiment")
        //     // onLogoClicked: { ... }
        //     Component.onCompleted: {
        //         FootItems.navigationView = navigation;
        //         // FootItems.paneItemMenu = nav_item_right_menu
        //         OriginalItems.navigationView = navigation;
        //         setCurrentIndex(0);
        //     }
        // }

        FluText {
            padding: 10
            text: qsTr("File Explorer")
        }

        property var loginPageRegister: registerForWindowResult("/login")

        // Connections{
        //     target: loginPageRegister
        //     function onResult(data)
        //     {
        //         password = data.password
        //     }
        // }

        FluButton{
            text: "[Login_Test]"
            opacity: 0.7
            onClicked: {
                parent.loginPageRegister.launch({stayTop: stayTop})
            }
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

                FluBreadcrumbBar{
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - search_rect.width
                    separator: "/"
                    spacing: 3
                    textSize: 18
                    onClickItem: (model)=>{

                    }

                    Component.onCompleted: {
                        var its = []
                        for (var i = 0; i < 5; i ++)
                            its.push({title: "Folder_" + i})
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
                        text: qsTr("Search")
                    }

                    FluTextBox {
                        anchors.left: parent.children[0].right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 250
                    }

                    FluIconButton {
                        anchors.left: parent.children[1].right
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        iconSource: FluentIcons.Search
                    }
                }
            }

            Rectangle {
                height: parent.height - parent.children[0].height
                width: parent.width
                anchors.top: parent.children[0].bottom
                color: FluColors.Transparent

                FluText {
                    padding: 10
                    text: qsTr("Current User:")
                }

                FluText {
                    anchors.left: parent.children[0].right
                    padding: 10
                    text: "Administrator"
                }

                FluArea {
                    id: left_filetree
                    topPadding: 10
                    bottomPadding: topPadding
                    property int pad_inner: 8
                    property int minW: 52 + pad_inner * 2
                    anchors.left: parent.left
                    anchors.top: parent.children[0].bottom
                    width: parent.width > 850 ? parent.width * 1 / 5 : minW
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
                                }

                                FluText {
                                    visible: type !== 1 && parent.width > left_filetree.minW
                                    anchors.left: icon != "" ? parent.children[0].right : parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: title
                                    font.pixelSize: parent.children[0].iconSize - 2
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

                        // Column{
                        //     id: cont
                        //     width: parent.width
                        //     Rectangle {
                        //         // Layout.alignment: Qt.AlignHCenter
                        //         anchors.horizontalCenter: parent.horizontalCenter
                        //         height: 20
                        //         width: parent.width - 20
                        //         radius: 5
                        //     }

                        //     Rectangle {
                        //         height: 5
                        //         width: parent.width
                        //         color: FluColors.Transparent
                        //     }

                        //     Rectangle {
                        //         // Layout.alignment: Qt.AlignHCenter
                        //         anchors.horizontalCenter: parent.horizontalCenter
                        //         height: 20
                        //         width: parent.width - 20
                        //         radius: 5
                        //     }
                        // }
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
                                FluMenuItem{
                                    text: qsTr("Delete")
                                    enabled: menu.name == ".." ? false : true
                                    iconSource: FluentIcons.Delete
                                    iconSpacing: window.item_pad
                                    opacity: enabled ? 1.0 : 0.5
                                    onTriggered: {
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

                            // Column{
                            //     id: cont
                            //     width: parent.width
                            //     Rectangle {
                            //         // Layout.alignment: Qt.AlignHCenter
                            //         anchors.horizontalCenter: parent.horizontalCenter
                            //         height: 20
                            //         width: parent.width - 20
                            //         radius: 5
                            //     }

                            //     Rectangle {
                            //         height: 5
                            //         width: parent.width
                            //         color: FluColors.Transparent
                            //     }

                            //     Rectangle {
                            //         // Layout.alignment: Qt.AlignHCenter
                            //         anchors.horizontalCenter: parent.horizontalCenter
                            //         height: 20
                            //         width: parent.width - 20
                            //         radius: 5
                            //     }
                            // }
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

    }

}
