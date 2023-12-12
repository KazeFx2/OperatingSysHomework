//
// Created by Kaze Fx on 2023/12/12.
//

#ifndef QT_TEST_PROCESSSCHEDULE_H
#define QT_TEST_PROCESSSCHEDULE_H

#include "QtIncludes.h"

extern "C" {
#include "C_component/list/CList.h"
#undef bool
};
#define UNSET 0xffffffff

typedef enum {
    P_FCFS = 0,
    P_SJF,
    P_PSA,
    P_HRRN,
    P_RR,
    P_MLFQ
} p_strategy_t;

typedef enum {
    CREATE = 0,
    RUNNING,
    ACTIVE_READY,
    ACTIVE_BLOCK,
    SUSPEND_READY,
    SUSPEND_BLOCK,
    TERMINATE
} p_status_t;

typedef struct PCB_s {
    QString name;
    uint pid;
    uint32_t server_need;
    uint32_t submit_time;
    uint priority;
    p_status_t status;
    uint32_t start_time;
} PCB_t;

typedef struct PCB_node_s {
    list_t list;
    PCB_t pcb;
} PCB_node_t;

class ProcessSchedule : public QObject {
Q_OBJECT
General_Constrictor(ProcessSchedule, {
    strategy = P_FCFS;
    pcb_list = initList();
})

private:

    p_strategy_t strategy;
    list_t pcb_list;

    // true if it has conflict, else false
    bool checkConflict(int pid);

    PCB_node_t *findByPid(uint pid);

    bool doFCFS();

public:

    Q_INVOKABLE
    void reset() { clearList(pcb_list); }

    Q_INVOKABLE
    bool addProcess(QString name, int pid, int submit, int time_need, int priority);

    Q_INVOKABLE
    bool doSchedule();

    void init(char *argv[]) {}

signals:

};

#endif //QT_TEST_PROCESSSCHEDULE_H