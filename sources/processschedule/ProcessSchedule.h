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
    QString *name;
    uint pid;
    uint32_t server_need;
    uint32_t submit_time;
    uint priority;
    p_status_t status;
    uint32_t start_time;
} PCB_t;

typedef struct PCB_node_s {
    node_t list;
    PCB_t pcb;
} PCB_node_t;

class ProcessSchedule : public QObject {
Q_OBJECT
General_Constrictor(ProcessSchedule, {
    strategy = P_FCFS;
    pcb_list = initList();
    m_update = false;
})

private:

    p_strategy_t strategy;
    list_t pcb_list;

    bool m_update;

    // true if it has conflict, else false
    bool checkConflict(int pid);

    PCB_node_t *findByPid(uint pid);

    bool doFCFS();

    void updateNotify() {
        m_update = !m_update;
        doFCFS();
        emit updateChanged();
    }

public:

    Q_PROPERTY(bool update READ update NOTIFY updateChanged)

    Q_PROPERTY(QVariant unset READ unset)

    static QVariant unset() { return QVariant(UNSET); }

    bool update() const { return m_update; }

    Q_INVOKABLE
    void reset() { clearList(pcb_list); }

    Q_INVOKABLE
    bool addProcess(QString name, int pid, int submit, int time_need, int priority);

    Q_INVOKABLE
    bool deleteProcess(int pid);

    Q_INVOKABLE
    bool doSchedule();

    Q_INVOKABLE
    QVariantList getProcesses();

    void init(char *argv[]) {
        for (int i = 1; i < 6; i++) {
            addProcess(
                    "name_" + QString(i + '0'),
                    i,
                    i,
                    i,
                    i);
        }
    }

signals:

    void updateChanged();

};

#endif //QT_TEST_PROCESSSCHEDULE_H