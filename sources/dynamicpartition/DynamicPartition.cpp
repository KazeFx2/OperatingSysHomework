//
// Created by Kaze Fx on 2023/11/23.
//

#include "DynamicPartition.h"

zone_node_t *DynamicPartition::checkNewZone(int size, int start) {
    int end = start + size;
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
        FOREACH(zone_node_t, i, after->list.prev)i->zone.zone_num++;
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
    free(dn);
    FOREACH(zone_node_t, i, op_ptr(n, -offset_of(node_t, next)))i->zone.zone_num--;
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
    // TODO
    return true;
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