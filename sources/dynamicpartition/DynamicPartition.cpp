//
// Created by Kaze Fx on 2023/11/23.
//

#include "DynamicPartition.h"

zone_node_t *DynamicPartition::checkNewZone(int size, int start) {
    int end = start + size;
    FOREACH(zone_node_t, i, used_zone) {
        if (i->zone.start_addr + i->zone.size <= start)
            continue;
        if (end > i->zone.start_addr)
            return nullptr;
        break;
    }
    FOREACH(zone_node_t, i, zone_list) {
        if (i->zone.start_addr + i->zone.size <= start)
            continue;
        if (end > i->zone.start_addr)
            return nullptr;
        return i;
    }
    return (zone_node_t *) this->zone_list;
}

void DynamicPartition::updateNotify() {
    m_update = !m_update;
}

void DynamicPartition::reset() {
    // TODO
}

#define list_op_after(node, op) FOREACH(zone_node_t, __i, node) __i->zone.zone_num op

int DynamicPartition::addZone(int size, int start) {
    zone_node_t *after = checkNewZone(size, start);
    if (after == nullptr)
        return -1;
    uint num;
    if (after == (zone_node_t *) zone_list)
        after = nullptr, num = length;
    else
        num = after->zone.zone_num;
    zone_desc_t zd = {
            num,
            (uint) size,
            (uintptr_t) start
    };
    if (!addNodeBefore(zone_list, after, &zd, sizeof(zone_desc_t)))
        return -1;
    if (after)
        list_op_after(after->list.prev, ++);
    length++;
    updateNotify();
    return (int) num;
}

bool DynamicPartition::deleteZone(int zone_num) {
    if (zone_num >= length)
        return false;
    node_t **n = findNodeByIndex(&zone_list, zone_num);
    if (!n)
        return false;
    node_t *dn = *n;
    if (!removeNode(dn))
        return false;
    __free(dn);
    list_op_after(op_ptr(n, -offset_of(node_t, next)), --);
    length--;
    updateNotify();
    return true;
}

inline QVariantMap nodeToQMap(const zone_desc_t &zone) {
    auto map = QVariantMap();
    map.insert("index", QVariant(zone.zone_num));
    map.insert("size", QVariant(zone.size));
    map.insert("start", QVariant(zone.start_addr));
    return map;
}

inline QVariantList listToQList(const list_t &head) {
    auto ret = QVariantList();
    FOREACH(zone_node_t, i, head) {
        ret.append(nodeToQMap(i->zone));
    }
    return ret;
}

QVariantList DynamicPartition::getZones() const {
    return listToQList(zone_list);
}

QVariantList DynamicPartition::getZonesUsed() const {
    return listToQList(used_zone);
}

QVariantMap DynamicPartition::allocMem(int size) {
    // TODO
    return QVariantMap();
}

bool DynamicPartition::freeMem(int start) {
    FOREACH(zone_node_t, i, used_zone) {
        if (i->zone.start_addr == start) {
            if (i->zone.size == 0) {
                if (!removeNode((node_t *) i))
                    return false;
                __free(i);
                return true;
            }
            bool mk = false;
            FOREACH(zone_node_t, j, zone_list) {
                if (j->zone.start_addr + j->zone.size < start)
                    continue;
                if (j->zone.start_addr + j->zone.size == start) {
                    j->zone.size += i->zone.size;
                    removeNode((node_t *) i);
                    mk = true;
                } else if (j->zone.start_addr == start + i->zone.size) {
                    if (i->list.prev->next != (node_t *) i) {
                        ((zone_node_t *) j->list.prev)->zone.size += j->zone.size;
                        removeNode((node_t *) j);
                        list_op_after(j->list.prev, --);
                        length--;
                        __free(j);
                    } else {
                        j->zone.size += i->zone.size;
                        j->zone.start_addr = start;
                        removeNode((node_t *) i);
                    }
                    __free(i);
                    break;
                } else if (!mk) {
                    removeNode((node_t *) i);
                    addExistNodeBefore(zone_list, j, (node_t *) i);
                    list_op_after(i, ++);
                    length++;
                    break;
                } else {
                    __free(i);
                    break;
                }
            }
            return true;
        }
    }
    return false;
}

bool DynamicPartition::setStrategy(QString strategy) {
    if (strategy == "FF") {
        this->strategy = FF;
    } else if (strategy == "NF") {
        this->strategy = NF;
    } else if (strategy == "BF") {
        this->strategy = BF;
    } else if (strategy == "WF") {
        this->strategy = WF;
    } else {
        return false;
    }
    return true;
}

#define strategy_case(x) case x: return #x;

QString DynamicPartition::getStrategy() {
    switch (strategy) {
        strategy_case(FF)
        strategy_case(NF)
        strategy_case(BF)
        strategy_case(WF)
        default:
            return "unknown";
    }
}