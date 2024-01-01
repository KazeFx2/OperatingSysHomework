pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject{

    property var navigationView
    // property var paneItemMenu

    id: foot_items

    // FluPaneItemSeparator{}

    FluPaneItem{
        title: qsTr("About")
        // menuDelegate: paneItemMenu
        icon: FluentIcons.Contact
        url: "qrc:/qml/Pages/About.qml"
        onTap: {
            navigationView.push(url)
        }
    }

    // FluPaneItem{
    //     title: qsTr("Settings")
    //     // menuDelegate: paneItemMenu
    //     icon: FluentIcons.Settings
    //     url: "qrc:/qml/Pages/Settings.qml"
    //     onTap: {
    //         navigationView.push(url)
    //     }
    // }

}
