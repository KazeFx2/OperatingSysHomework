//
// Created by Kaze Fx on 2023/12/12.
//

#include "ProcessSchedule.h"

bool ProcessSchedule::checkConflict(int pid) {
    FOREACH(PCB_node_t, i, pcb_list) if (i->pcb.pid == pid) return true;
    return false;
}

PCB_node_t *ProcessSchedule::findByPid(uint pid) {
    FOREACH(PCB_node_t, i, pcb_list) if (i->pcb.pid == pid)
            return i;
    return nullptr;
}

bool ProcessSchedule::doFCFS() {
    size_t left = listSize(pcb_list);
    auto sorted = sortBy(pcb_list, [](node_t *a, node_t *b) -> int {
        PCB_node_t *_a = (PCB_node_t *) a,
                *_b = (PCB_node_t *) b;
        if (_a->pcb.submit_time < _b->pcb.submit_time)
            return -1;
        else if (_a->pcb.submit_time == _b->pcb.submit_time)
            return 0;
        return 1;
    }, sizeof(PCB_t), ASC);
    if (!sorted)
        return false;
    uint32_t now = 0;
    FOREACH(PCB_node_t, i, sorted) {
        auto tar = findByPid(i->pcb.pid);
        if (!tar) {
            destroyList(sorted);
            return false;
        }
        if (now < tar->pcb.submit_time)
            now = tar->pcb.submit_time;
        tar->pcb.start_time = now;
        now += tar->pcb.server_need;
    }
    destroyList(sorted);
    return true;
}

bool ProcessSchedule::doPSA() {
    int now = 0;
    int left = listSize(pcb_list);
    int mk[1000];
    memset(mk, 0, sizeof(int) * left);
    while (left) {
        int index = 0, nearest = -1, n_tar = -1, tar = -1, n_p = -1, priority = -1;
        FOREACH(PCB_node_t, i, pcb_list) {
            if (mk[index]) {
                index++;
                continue;
            }
            if (i->pcb.submit_time <= now) {
                if (priority == -1 || i->pcb.priority > priority) {
                    priority = i->pcb.priority;
                    tar = index;
                }
            } else if (priority == -1) {
                if (nearest == -1 || i->pcb.submit_time < nearest ||
                    (i->pcb.submit_time == nearest && i->pcb.priority > n_p)) {
                    nearest = i->pcb.submit_time;
                    n_tar = index;
                    n_p = i->pcb.priority;
                }
            }
            index++;
        }
        PCB_node_t *target;
        if (tar != -1) {
            target = (PCB_node_t *) *findNodeByIndex(&pcb_list, tar);
            mk[tar] = 1;
        } else {
            target = (PCB_node_t *) *findNodeByIndex(&pcb_list, n_tar);
            mk[n_tar] = 1;
        }
        target->pcb.start_time = (now > target->pcb.submit_time ? now : target->pcb.submit_time);
        now = target->pcb.start_time + target->pcb.server_need;
        left--;
    }
    return true;
}

bool ProcessSchedule::doSJF() {
    int now = 0;
    int left = listSize(pcb_list);
    int mk[1000];
    memset(mk, 0, sizeof(int) * left);
    while (left) {
        int index = 0, nearest = -1, n_tar = -1, tar = -1, n_s = -1, ser = -1;
        FOREACH(PCB_node_t, i, pcb_list) {
            if (mk[index]) {
                index++;
                continue;
            }
            if (i->pcb.submit_time <= now) {
                if (ser == -1 || i->pcb.server_need < ser) {
                    ser = i->pcb.server_need;
                    tar = index;
                }
            } else if (ser == -1) {
                if (nearest == -1 || i->pcb.submit_time < nearest ||
                    (i->pcb.submit_time == nearest && i->pcb.server_need < n_s)) {
                    nearest = i->pcb.submit_time;
                    n_tar = index;
                    n_s = i->pcb.server_need;
                }
            }
            index++;
        }
        PCB_node_t *target;
        if (tar != -1) {
            target = (PCB_node_t *) *findNodeByIndex(&pcb_list, tar);
            mk[tar] = 1;
        } else {
            target = (PCB_node_t *) *findNodeByIndex(&pcb_list, n_tar);
            mk[n_tar] = 1;
        }
        target->pcb.start_time = (now > target->pcb.submit_time ? now : target->pcb.submit_time);
        now = target->pcb.start_time + target->pcb.server_need;
        left--;
    }
    return true;
}

bool ProcessSchedule::addProcess(QString name, int pid, int submit, int time_need, int priority) {
    if (checkConflict(pid))
        return false;
    if (time_need <= 0)
        return false;
    PCB_t tmp = {
            new QString(name),
            (uint) pid,
            (uint32_t) time_need,
            (uint32_t) submit,
            (uint) priority,
            CREATE,
            UNSET
    };
    if (!pushEnd(pcb_list, &tmp, sizeof(PCB_t)))
        return false;
    updateNotify();
    return true;
}

bool ProcessSchedule::deleteProcess(int pid) {
    FOREACH(PCB_node_t, i, pcb_list) {
        if (i->pcb.pid == pid) {
            if (i->pcb.name)
                delete i->pcb.name;
            removeNode((node_t *) i);
            updateNotify();
            return true;
        }
    }
    return false;
}

bool ProcessSchedule::doSchedule() {
    switch (strategy) {
        case P_FCFS:
            doFCFS();
            break;
        case P_PSA:
            doPSA();
            break;
        case P_SJF:
            doSJF();
            break;
        case P_HRRN:
        case P_RR:
        case P_MLFQ:
        default:
            return false;
    }
    // updateNotify();
    return true;
}

bool ProcessSchedule::setStrategy(QString str) {
    if (str == "FCFS") {
        strategy = P_FCFS;
    } else if (str == "PSA") {
        strategy = P_PSA;
    } else if (str == "SJF") {
        strategy = P_SJF;
    } else
        return false;
    updateNotify();
    return true;
}

inline
QVariantMap node2map(PCB_node_t *node) {
    QVariantMap map;
    map.insert("name", *node->pcb.name);
    map.insert("pid", node->pcb.pid);
    map.insert("priority", node->pcb.priority);
    map.insert("submit", node->pcb.submit_time);
    map.insert("serve", node->pcb.server_need);
    map.insert("start", node->pcb.start_time);
    return map;
}

QVariantList ProcessSchedule::getProcesses() {
    QVariantList ret;
    FOREACH(PCB_node_t, i, pcb_list) {
        ret.append(node2map(i));
    }
    return ret;
}
