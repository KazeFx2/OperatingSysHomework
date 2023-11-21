import QtQuick 2.15
import FluentUI 1.0
import "qrc:///qml/NavItems"

FluWindow {

    id: window
    title: qsTr("Executable for Operating System Experiment")
    width: 1000
    height: 640
    minimumWidth: 650
    minimumHeight: 500
    fitsAppBarWindows: true
    launchMode: FluWindowType.SingleTask
    appBar: FluAppBar {
            id: app_bar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            darkText: qsTr("SwitchTheme")
            showDark: true
            darkClickListener: (button) => {
                if (FluTheme.dark) {
                    FluTheme.darkMode = FluThemeType.Light
                } else {
                    FluTheme.darkMode = FluThemeType.Dark
                }
            }
            closeClickListener: () => {
                FluApp.exit(0)
            }
            z: 0
        }


    Item {
        id: main_page
        anchors.fill: parent

        FluNavigationView {
            id: navigation
            width: parent.width
            height: parent.height
            anchors.fill: parent
            // the toppest
            z: 0
            pageMode: FluNavigationViewType.NoStack
            items: OriginalItems
            footerItems: FootItems
            topPadding: FluTools.isMacos() ? 20 : 0
            // displayMode: undefined
            // logo: "undefined"
            title: qsTr("Executable for Operating System Experiment")
            // onLogoClicked: { ... }
            Component.onCompleted: {
                FootItems.navigationView = navigation
                // FootItems.paneItemMenu = nav_item_right_menu
                OriginalItems.navigationView = navigation
                setCurrentIndex(0)
            }
        }

    }

}
