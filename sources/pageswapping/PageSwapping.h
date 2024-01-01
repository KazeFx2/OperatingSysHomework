//
// Created by Kaze Fx on 2024/1/1.
//

#ifndef QT_TEST_PAGESWAPPING_H
#define QT_TEST_PAGESWAPPING_H

#include "QtIncludes.h"
#include <QObject>

#define MAX_USING 3

typedef enum PS_Strategy {
    PS_OPT,
    PS_LRU_OFFSET,
    PS_CLOCK,
    PS_FIFO,
    PS_LRU_STACK,
    PS_LFU
} PS_Strategy;

typedef struct PAGE_s{
    int page_num;
} PAGE_t;

extern int max_n_using;

class PageSwapping : public QObject {
Q_OBJECT
private:
public:
General_Constrictor(PageSwapping, {

})

signals:

};

#endif //QT_TEST_PAGESWAPPING_H
