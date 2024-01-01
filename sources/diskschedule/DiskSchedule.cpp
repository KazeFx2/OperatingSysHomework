//
// Created by Kaze Fx on 2024/1/2.
//

#include "DiskSchedule.h"

bool DiskSchedule::setStrategy(QString str) {
    if (str == "FCFS") {
        strategy = DS_FCFS;
        updateNotify();
    } else if (str == "SSTF") {
        strategy = DS_SSTF;
        updateNotify();
    } else if (str == "SCAN") {
        strategy = DS_SCAN;
        updateNotify();
    } else if (str == "C_SCAN") {
        return false;
    } else if (str == "LOOK") {
        return false;
    } else if (str == "C_LOOK") {
        return false;
    }
    return true;
}

QString DiskSchedule::getStrategy() {
    switch (strategy) {
        case DS_FCFS:
            return "FCFS";
        case DS_SSTF:
            return "SSTF";
        case DS_SCAN:
            return "SCAN";
        case DS_C_SCAN:
            return "C_SCAN";
        case DS_LOOK:
            return "LOOK";
        case DS_C_LOOK:
            return "C_LOOK";
    }
    return "";
}

void DiskSchedule::doSchedule() {
    switch (strategy) {
        case DS_FCFS:
            doFCFS();
            break;
        case DS_SSTF:
            doSSTF();
            break;
        case DS_SCAN:
            doSCAN();
            break;
        default:
            break;
    }
}

void DiskSchedule::doFCFS() {
    move_dist = 0;
    int sc_pos = 0, mhead = head;
    for (int i = 0; i < now_req; i++) {
        sc[sc_pos++] = req[i];
        move_dist += abs(mhead - req[i]);
        mhead = req[i];
    }
}

void DiskSchedule::doSSTF() {
    move_dist = 0;
    int sc_pos = 0, mhead = head, left = now_req;
    int mk[MAX_REQ];
    memset(mk, 0, sizeof(int) * now_req);
    while (left) {
        // find best
        int now_best = -1, best_dist = -1;
        for (int i = 0; i < now_req; i++) {
            if (mk[i])
                continue;
            if (now_best == -1 || best_dist == -1) {
                now_best = i, best_dist = abs(mhead - req[i]);
            } else {
                if (abs(mhead - req[i]) < best_dist) {
                    now_best = i, best_dist = abs(mhead - req[i]);
                }
            }
        }
        sc[sc_pos++] = req[now_best];
        mk[now_best] = 1;
        move_dist += best_dist;
        mhead = req[now_best];
        left--;
    }
}

void DiskSchedule::doSCAN() {
    move_dist = 0;
    int sc_pos = 0, mhead = head, left = now_req;
    int mk[MAX_REQ];
    memset(mk, 0, sizeof(int) * now_req);

}