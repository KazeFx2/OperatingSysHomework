//
// Created by Kaze Fx on 2023/11/23.
//

#ifndef QT_TEST_DYNAMICPARTITION_H
#define QT_TEST_DYNAMICPARTITION_H

#include "QtIncludes.h"

enum {
    FF = 0, // First Fit
    NF,     // Next Fit
    BF,     // Best Fit
    WF      // Worst Fit
} PartAlgorithms;

class DynamicPartition : public QObject {

    General_Constrictor(DynamicPartition,)

private:

public:

signals:

};

#endif //QT_TEST_DYNAMICPARTITION_H
