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

void PageSwapping::doSwap() {
    switch (strategy) {
        case PS_FIFO:
            doFIFO();
            break;
        case PS_OPT:
            doOPT();
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