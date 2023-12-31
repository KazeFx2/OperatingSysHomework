//
// Created by Kaze Fx on 2023/12/30.
//

#ifndef QT_TEST_NEW_FS_TYPES_H
#define QT_TEST_NEW_FS_TYPES_H

#include <QObject>
#include "QtIncludes.h"
#include "DMS.h"
#include <QDebug>

class QFMS : public QObject {
Q_OBJECT
private:
    FMS fms;
public:
General_Constrictor(QFMS, {
})

    ~QFMS() {}

    Q_INVOKABLE
    void clean() {
        fms.fakeDestructor();
    }

    void init(char *argv[]) {
    }


    enum Option {
        NotExists,
        Exists,
        Full,
        Empty,
        Errors,
        User,
        Folder,
        File,
        PasswordError,
        Pass
    };

    Q_ENUM(Option)

    Q_INVOKABLE
    std::vector<QString> Ls() {
        std::vector<QString> ret;
        auto r = fms.Show();
        for (auto i = r.begin(); i != r.end(); i++) {
            ret.push_back(i->c_str());
        }
        return ret;
    }

    Q_INVOKABLE
    Option Login(QString name, QString psd) {
        return (Option) fms.Login(name.toStdString(), psd.toStdString());
    }

    Q_INVOKABLE
    Option Register(QString name, QString psd) {
        return (Option) fms.Register(name.toStdString(), psd.toStdString());
    }

    Q_INVOKABLE
    Option Create(QString name, Option type) {
        return (Option) fms.Create(name.toStdString(), type);
    }

    Q_INVOKABLE
    Option Delete(QString path) {
        string _pth = path.toStdString();
        auto pos = _pth.rfind('/');
        string pa = _pth.substr(0, pos);
        string name = _pth.substr(pos + 1, _pth.length() - pos - 1);
        return (Option) fms.Delete(name, pa);
    }

    Q_INVOKABLE
    Option Open(QString path) {
        return (Option) fms.Open(path.toStdString());
    }

    Q_INVOKABLE
    QString Read() {
        return QString(fms.Read().c_str());
    }

    Q_INVOKABLE
    Option Write(QString text) {
        return (Option) fms.Write(text.toStdString());
    }

    Q_INVOKABLE
    Option Close() {
        return (Option) fms.Close();
    }

    Q_INVOKABLE
    void noCh() {
        fms.noCh();
    }

    Q_INVOKABLE
    Option Cd(QString path) {
        return (Option) fms.Cd(path.toStdString());
    }

    Q_INVOKABLE
    QString Search(QString name) {
        return QString(fms.Search(name.toStdString()).c_str());
    }

    Q_INVOKABLE
    Option Change(QString name, int mod) {
        return (Option) fms.Change(name.toStdString(), mod);
    }
};

#endif //QT_TEST_NEW_FS_TYPES_H
