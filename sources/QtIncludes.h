//
// Created by Kaze Fx on 2023/11/23.
//

#ifndef QT_TEST_QTINCLUDES_H
#define QT_TEST_QTINCLUDES_H

#include <QtCore/qobject.h>
#include <QtQml/qqml.h>
#include "singleton.h"


#define General_Constrictor(_class, inner) \
SINGLETON(_class)\
explicit _class(QObject *parent = nullptr) : QObject(parent) { \
    inner   \
}


#endif //QT_TEST_QTINCLUDES_H
