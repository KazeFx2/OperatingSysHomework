/* This file is generated and only relevant for integrating the project into a Qt 6 and cmake based
C++ project. */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    id: app

    Component.onCompleted: {
        FluApp.init(app);
        FluApp.vsync = SettingsHelper.getVsync();
        FluTheme.darkMode = SettingsHelper.getDarkMode();
        FluTheme.enableAnimation = true;
        FluApp.routes = {
            "/": "qrc:/qml/MainWindow.qml"
        };
        FluApp.initialRoute = "/";
        FluApp.httpInterceptor = interceptor;
        FluApp.run();
    }

    Connections {
        function onDarkModeChanged() {
            SettingsHelper.saveDarkMode(FluTheme.darkMode);
        }

        target: FluTheme
    }

    Connections {
        function onVsyncChanged() {
            SettingsHelper.saveVsync(FluApp.vsync);
        }

        target: FluApp
    }

    FluHttpInterceptor {
        id: interceptor

        // ?
        function onIntercept(request) {
            if (request.method === "get")
                request.params["method"] = "get";

            if (request.method === "post")
                request.params["method"] = "post";

            request.headers["token"] = "yyds";
            request.headers["os"] = "pc";
            console.debug(JSON.stringify(request));
            return request;
        }

    }

}
