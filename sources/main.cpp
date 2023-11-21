#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QLocale>
#include <QTranslator>

#include "AppInfo.h"
#include "helper/SettingsHelper.h"
#include "bankalgorithm/BankAlgorithm.h"

#include <iostream>

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#endif

    SettingsHelper::getInstance()->init(argv);
    if (SettingsHelper::getInstance()->getRender() == "software") {
#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
        QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);
#elif (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
        QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Software);
#endif
    }
    BankAlgorithm::getInstance()->init(argv);

    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale: uiLanguages) {
        const QString baseName = "QT_Test_" + QLocale(locale).name();
        if (translator.load(":/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }
    QQmlApplicationEngine engine;

    AppInfo::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("CppBankAlgorithm", BankAlgorithm::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper", SettingsHelper::getInstance());

    const QUrl url(QStringLiteral("qrc:qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            }, Qt::QueuedConnection);

    engine.addImportPath(QString("qml/"));

    engine.load(url);

    return app.exec();
}
