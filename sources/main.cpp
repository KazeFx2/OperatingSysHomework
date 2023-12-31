#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QLocale>
#include <QTranslator>
#include <QIcon>
#include <QTextEdit>

#include "AppInfo.h"
#include "helper/SettingsHelper.h"
#include "FS/New_FS_Types.h"

#include "UIComponent/KaTextArea.h"
#include <filesystem>
// #include <iostream>

void registerQml() {
    int verMajor = 1;
    int verMinor = 0;

    qmlRegisterType<KaTextArea>("kaze.ui", verMajor, verMinor, "KaTextArea");
    qmlRegisterType<QFMS>("QFMS", verMajor, verMinor, "FMST");
}

void cleanRoot() {
    std::filesystem::remove_all("./root");
}

int main(int argc, char *argv[]) {
    //获取系统temp目录
    char strTmpPath[MAX_PATH];
    GetTempPath(sizeof(strTmpPath), strTmpPath);
    printf("获取系统temp目录：%s\n", strTmpPath);
    SetCurrentDirectory(strTmpPath);

    cleanRoot();

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
    QFMS::getInstance()->init(argv);

    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale: uiLanguages) {
        const QString baseName = "QT_Test_" + QLocale(locale).name();
//        if (baseName == "QT_Test_zh_CN")
//            continue;
        if (translator.load(":/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }
    QQmlApplicationEngine engine;

    AppInfo::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("FMS", QFMS::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper", SettingsHelper::getInstance());

    registerQml();

    const QUrl url(QStringLiteral("qrc:qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            }, Qt::QueuedConnection);

    engine.addImportPath(QString("qml/"));
    engine.addImportPath(QString("/"));
    engine.load(url);
    auto ret = app.exec();
    delete QFMS::getInstance();
    return 0;
}
