//
// Created by Kaze Fx on 2024/1/1.
//

#include "PageSwapping.h"

int QueueRightPush(int *queue, int size, int &used, int val) {
    if (used < size) {
        queue[used++] = val;
        return -1;
    } else {
        int ret = queue[0];
        while (size != 1) {
            queue[used - size] = queue[used - size + 1];
            size--;
        }
        queue[used - 1] = val;
        return ret;
    }
}

void StackToTop(int *stack, int size, int val) {
    for (int i = 0; i < size; i++) {
        if (stack[i] == val) {
            for (int j = i; j < size - 1; j++)
                stack[j] = stack[j + 1];
            stack[size - 1] = val;
            break;
        }
    }
}

inline bool checkIn(int *queue, int used, int val) {
    for (int i = 0; i < used; i++)
        if (val == queue[i])
            return true;
    return false;
}

void PageSwapping::push_back(int page_num) {
    pushEnd(pages, &page_num, sizeof(int));
    updateNotify();
}

void PageSwapping::remove_index(int index) {
    removeByIndex(pages, index);
    updateNotify();
}

void PageSwapping::swap_index_index(int index_a, int index_b) {
    swapNodesByIndex(pages, index_a, index_b);
    updateNotify();
}

void PageSwapping::move_from_to(int from, int to) {
    moveFromTo(pages, from, to);
    updateNotify();
}

void PageSwapping::doFIFO() {
    std::vector<QString> ret;
    int cap[10], page_fault = 0, length = listSize(pages);
    memset(cap, 0, sizeof(int) * capacity);
    int used = 0;
    for (int i = 0; i < length; i++) {
        QString tmp = "";
        int pageNum = ((PAGE_node_t *) findPNodeByIndex(pages, i))->page.page_num;
        if (!checkIn(cap, used, pageNum)) {
            page_fault++;
            tmp += "X\n";
            QueueRightPush(cap, capacity, used, pageNum);
        } else
            tmp += "V\n";
        int j = 0;
        for (j = 0; j < used; j++) {
            tmp += std::to_string(cap[j]).c_str();
            if (j != capacity - 1)
                tmp += "\n";
        }
        for (; j < capacity; j++) {
            tmp += "-1";
            if (j != capacity - 1)
                tmp += "\n";
        }
        ret.push_back(tmp);
    }
    PageFault = page_fault;
    result = ret;
}

void PageSwapping::doOPT() {
    std::vector<QString> ret;
    int cap[10], page_fault = 0, length = listSize(pages);
    memset(cap, 0, sizeof(int) * capacity);
    int used = 0;
    for (int i = 0; i < length; i++) {
        QString tmp = "";
        node_t *node = findPNodeByIndex(pages, i);
        int pageNum = ((PAGE_node_t *) node)->page.page_num;
        if (!checkIn(cap, used, pageNum)) {
            page_fault++;
            tmp += "X\n";
            if (used < capacity)
                QueueRightPush(cap, capacity, used, pageNum);
            else {
                // find best
                int best_j = -1, best_dist = -1;
                for (int j = 0; j < capacity; j++) {
                    int dist = 1;
                    bool find = false;
                    FOREACH(PAGE_node_t, n, node) {
                        if (n->page.page_num == cap[j]) {
                            find = true;
                            if (dist > best_dist)
                                best_j = j, best_dist = dist;
                            break;
                        }
                        dist++;
                    }
                    if (!find) {
                        best_j = j;
                        break;
                    }
                }
                cap[best_j] = pageNum;
            }
        } else
            tmp += "V\n";
        int j = 0;
        for (j = 0; j < used; j++) {
            tmp += std::to_string(cap[j]).c_str();
            if (j != capacity - 1)
                tmp += "\n";
        }
        for (; j < capacity; j++) {
            tmp += "-1";
            if (j != capacity - 1)
                tmp += "\n";
        }
        ret.push_back(tmp);
    }
    PageFault = page_fault;
    result = ret;
}

void PageSwapping::doLRU_STACK() {
    std::vector<QString> ret;
    int cap[10], page_fault = 0, length = listSize(pages);
    memset(cap, 0, sizeof(int) * capacity);
    int used = 0;
    for (int i = 0; i < length; i++) {
        QString tmp = "";
        node_t *node = findPNodeByIndex(pages, i);
        int pageNum = ((PAGE_node_t *) node)->page.page_num;
        if (!checkIn(cap, used, pageNum)) {
            page_fault++;
            tmp += "X\n";
            QueueRightPush(cap, capacity, used, pageNum);
        } else {
            tmp += "V\n";
            StackToTop(cap, capacity, pageNum);
        }
        int j = 0;
        for (j = 0; j < used; j++) {
            tmp += std::to_string(cap[j]).c_str();
            if (j != capacity - 1)
                tmp += "\n";
        }
        for (; j < capacity; j++) {
            tmp += "-1";
            if (j != capacity - 1)
                tmp += "\n";
        }
        ret.push_back(tmp);
    }
    PageFault = page_fault;
    result = ret;
}

void PageSwapping::doSwap() {
    switch (strategy) {
        case PS_FIFO:
            doFIFO();
            break;
        case PS_OPT:
            doOPT();
            break;
        case PS_LRU_STACK:
            doLRU_STACK();
            break;
        default:
            break;
    }
}

bool PageSwapping::setStrategy(QString str) {
    if (str == "FIFO") {
        strategy = PS_FIFO;
        updateNotify();
        return true;
    } else if (str == "OPT") {
        strategy = PS_OPT;
        updateNotify();
        return true;
    } else if (str == "LRU_STACK") {
        strategy = PS_LRU_STACK;
        updateNotify();
        return true;
    } else if (str == "LRU_OFFSET") {}
    else if (str == "LFU") {}
    else if (str == "CLOCK") {}
    return false;
}