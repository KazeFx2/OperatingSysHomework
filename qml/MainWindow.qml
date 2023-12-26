import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import QtQuick.Templates 2.15 as T
import "qrc:///qml/NavItems"

FluWindow {
    id: window

    title: qsTr("File Explorer")
    width: 1000
    height: 640
    minimumWidth: 650
    minimumHeight: 500
    fitsAppBarWindows: true
    launchMode: FluWindowType.SingleTask

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
                parent.loginPageRegister.launch({username:"zhuzichu"})
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
                    anchors.left: parent.left
                    anchors.top: parent.children[0].bottom
                    width: parent.width * 1 / 5
                    height: parent.height - parent.children[0].height
                    // color: FluColors.Transparent

                    FluText {
                        padding: 10
                        text: qsTr("Fast operations")
                    }

                    Flickable {
                        // policy: T.ScrollBar.AsNeeded
                        boundsBehavior: Flickable.StopAtBounds
                        contentWidth: parent.width
                        contentHeight: cont.height
                        clip: true
                        ScrollBar.vertical: FluScrollBar {
                            anchors.right: parent.right
                            anchors.rightMargin: 2
                        }
                        anchors{
                            top: parent.children[0].bottom
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }

                        ListView {
                            id: cont
                            width: parent.width
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
                                width: parent.width - 20
                                height: type !== 1 ? 20 : 2
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 5
                                border.color: FluTools.colorAlpha(FluColors.Grey110, 0.5)
                                border.width: type !== 1 ? 1 : 0
                                color: type !== 1 ? dis ? FluColors.Transparent : (children[2].hover ? (children[2].clicked ? FluColors.Grey110 : FluTools.colorAlpha(FluColors.Grey110, 0.5)) : FluColors.Transparent) : border.color
                                opacity: dis ? 0.5 : 1.0

                                FluIcon {
                                    visible: type !== 1
                                    padding: 3
                                    iconSize: 20 - padding * 2
                                    iconSource: type !== 1 ? icon : FluentIcons.AppIconDefault
                                }

                                FluText {
                                    visible: type !== 1
                                    anchors.left: parent.children[0].right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: title
                                    font.pixelSize: parent.children[0].iconSize - 2
                                }

                                MouseArea {
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
                                        if (!dis){
                                        }
                                    }
                                }
                            }

                            Component.onCompleted: {
                                var dt = [{
                                              icon: FluentIcons.Copy,
                                              title: qsTr("Copy"),
                                              type: 0,
                                              dis: false
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
                                              dis: false
                                          },
                                          {
                                              icon: FluentIcons.Delete,
                                              title: qsTr("Delete"),
                                              type: 0,
                                              dis: false
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
                    width: parent.width * 4 / 5 - 10
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
                                bottom: parent.bottom
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
                                    height: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    radius: 5
                                    border.color: FluTools.colorAlpha(FluColors.Grey110, 0.5)
                                    border.width: 1
                                    color: children[2].hover ? (children[2].clicked ? FluColors.Grey110 : FluTools.colorAlpha(FluColors.Grey110, 0.5)) : FluColors.Transparent

                                    FluIcon {
                                        padding: 3
                                        iconSize: 20 - padding * 2
                                        iconSource: type === 0 ? FluentIcons.Folder : FluentIcons.Document
                                    }

                                    FluText {
                                        anchors.left: parent.children[0].right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: title
                                        font.pixelSize: parent.children[0].iconSize - 2
                                    }

                                    MouseArea {
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
                                        }
                                    }
                                }

                                Component.onCompleted: {
                                    var dt = [{
                                                  title: ".",
                                                  type: 0
                                              },
                                              {
                                                  title: "..",
                                                  type: 0
                                              },
                                              {
                                                  title: "Empty.txt",
                                                  type: 1
                                              }]
                                    for (var i = 0; i < dt.length; i++){
                                        right_files_model.append(dt[i])
                                    }
                                    for (i = 0; i < 100; i++)
                                        right_files_model.append(
                                                    {
                                                        title: "Empty" + i + ".txt",
                                                        type: 1
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
