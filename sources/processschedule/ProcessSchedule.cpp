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
        tar->pcb.start_time = now;
        now += tar->pcb.server_need;
    }
    destroyList(sorted);
    return true;
}

bool ProcessSchedule::addProcess(QString name, int pid, int submit, int time_need, int priority) {
    if (checkConflict(pid))
        return false;
    PCB_t tmp = {
            name,
            (uint) pid,
            (uint32_t) time_need,
            (uint32_t) submit,
            (uint) priority,
            CREATE,
            UNSET
    };
    if (!pushEnd(pcb_list, &tmp, sizeof(PCB_t)))
        return false;
    return true;
}

bool ProcessSchedule::doSchedule() {
    return true;
}