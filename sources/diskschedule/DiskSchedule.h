//
// Created by Kaze Fx on 2024/1/2.
//

#ifndef QT_TEST_DISKSCHEDULE_H
#define QT_TEST_DISKSCHEDULE_H

#include "QtIncludes.h"
#include <QObject>

#define MAX_REQ 1000

typedef enum DS_Strategy {
    DS_FCFS,
    DS_SSTF,
    DS_SCAN,
    DS_C_SCAN,
    DS_LOOK,
    DS_C_LOOK
} DS_Strategy;

class DiskSchedule : public QObject {
Q_OBJECT
private:
    int now_req;
    int req[MAX_REQ];
    DS_Strategy strategy;
    int min;
    int max;
    int head;
    int move_dist;
    int sc[MAX_REQ];
public:
General_Constrictor(DiskSchedule, {
    now_req = 0;
    memset(req, 0, sizeof(int) * MAX_REQ);
    memset(sc, 0, sizeof(int) * MAX_REQ);
    strategy = DS_FCFS;
    min = max = head = move_dist = 0;
})

    void addReq(int req) { this->req[now_req++] = req; }

    Q_INVOKABLE
    void genRandom(int min, int max, int n, int head_pos) {
        now_req = move_dist = 0;
        this->min = min;
        this->max = max;
        this->head = head_pos;
        while (n) {
            addReq(rand() % (max - min) + min);
            n--;
        }
        updateNotify();
    }

    void init(char *argv[]) {}

    Q_INVOKABLE
    bool setStrategy(QString strategy);

    Q_INVOKABLE
    QString getStrategy();

    void doFCFS();

    void doSSTF();

    void doSCAN();

    void doSchedule();

    void updateNotify() {
        doSchedule();
        emit update();
    }

signals:

    void update();

};

#endif //QT_TEST_DISKSCHEDULE_H
