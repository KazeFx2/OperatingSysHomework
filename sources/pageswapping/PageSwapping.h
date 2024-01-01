//
// Created by Kaze Fx on 2024/1/1.
//

#ifndef QT_TEST_PAGESWAPPING_H
#define QT_TEST_PAGESWAPPING_H

#include "QtIncludes.h"

extern "C" {
#include "C_component/list/CList.h"
#undef bool
};

#include <QObject>
// #include <QRandomGenerator>
#include <vector>

#define MAX_USING 3

typedef enum PS_Strategy {
    PS_FIFO,
    PS_OPT,
    PS_LRU_STACK,
    PS_LRU_OFFSET,
    PS_LFU,
    PS_CLOCK
} PS_Strategy;

typedef struct PAGE_s {
    int page_num;
} PAGE_t;

typedef struct PAGE_node_s {
    node_t list;
    PAGE_t page;
} PAGE_node_t;

class PageSwapping : public QObject {
Q_OBJECT
private:
    list_t pages;
    PS_Strategy strategy;
    int capacity;
    std::vector<QString> result;
    int PageFault;
public:
General_Constrictor(PageSwapping, {
    pages = initList();
    strategy = PS_FIFO;
    capacity = MAX_USING;
    PageFault = 0;
})

    Q_INVOKABLE
    void push_back(int page_num);

    Q_INVOKABLE
    void remove_index(int index);

    Q_INVOKABLE
    void swap_index_index(int index_a, int index_b);

    Q_INVOKABLE
    void move_from_to(int from, int to);

    Q_INVOKABLE
    void setCap(int cap) {
        capacity = cap;
        updateNotify();
    }

    Q_INVOKABLE
    void doSwap();

    void doFIFO();

    void doOPT();

    void doLRU_STACK();

    Q_INVOKABLE
    void updateNotify() {
        doSwap();
        emit update();
    }

    void init(char *argv[]) {
        for (int i = 0; i < 20; i++) {
            push_back(rand() % 10);
        }
    }

    Q_INVOKABLE
    std::vector<QString> getRes() {
        return result;
    }

    Q_INVOKABLE
    int getPageFault() {
        return PageFault;
    }

    Q_INVOKABLE
    std::vector<int> getPages() {
        std::vector<int> ret;
        FOREACH(PAGE_node_t, i, pages) {
            ret.emplace_back(i->page.page_num);
        }
        return ret;
    }

    Q_INVOKABLE
    int getMax() {
        return capacity;
    }

    Q_INVOKABLE
    QString getStrategy() {
        switch (strategy) {
            case PS_FIFO:
                return "FIFO";
            case PS_OPT:
                return "OPT";
            case PS_LRU_STACK:
                return "LRU_STACK";
            case PS_LRU_OFFSET:
                return "LRU_OFFSET";
            case PS_LFU:
                return "LFU";
            case PS_CLOCK:
                return "CLOCK";
        }
        return "";
    }

    Q_INVOKABLE
    bool setStrategy(QString strategy);

signals:

    void update();
};

#endif //QT_TEST_PAGESWAPPING_H
