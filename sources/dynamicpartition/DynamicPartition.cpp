//
// Created by Kaze Fx on 2023/11/23.
//

#include "DynamicPartition.h"

void DynamicPartition::updateNotify() {
    m_update = !m_update;
    emit updateChanged();
}

void DynamicPartition::reset() {
    free_zone.clear();
    used_zone.clear();
    last = nullptr;
    updateNotify();
}

int DynamicPartition::addZone(int size, int start) {
    uint num;
    zone_node_t *added;
    if (!free_zone.addNewMem(start, size, num, added))
        return -1;
    updateNotify();
    return (int) num;
}

bool DynamicPartition::deleteZone(int zone_num) {
    if (zone_num < 0)
        return false;
    if (!free_zone.deleteNode(zone_num))
        return false;
    updateNotify();
    return true;
}

bool DynamicPartition::deleteZoneUsed(int zone_num) {
    if (zone_num < 0)
        return false;
    if (!used_zone.deleteNode(zone_num))
        return false;
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

inline QVariantList listToQList(const list_t head) {
    auto ret = QVariantList();
    FOREACH(zone_node_t, i, head) {
        ret.append(nodeToQMap(i->zone));
    }
    return ret;
}

QVariantList DynamicPartition::getZones() const {
    return listToQList(free_zone);
}

QVariantList DynamicPartition::getZonesUsed() const {
    return listToQList(used_zone);
}

QVariantList DynamicPartition::getAllZones() const {
    auto ret = QVariantList();
    FOREACH(zone_node_t, i, free_zone) {
        auto tmp = nodeToQMap(i->zone);
        tmp.insert("type", "Free");
        ret.append(tmp);
    }
    FOREACH(zone_node_t, i, used_zone) {
        auto tmp = nodeToQMap(i->zone);
        tmp.insert("type", "Used");
        ret.append(tmp);
    }
    return ret;
}

inline
zone_node_t *divideMem(MemList &used, MemList &free, zone_node_t *node, size_t size, size_t s) {
    if (node->zone.size < size)
        return nullptr;
    zone_node_t *next, *tmp;
    uintptr_t addr_;
    size_t size_;
    uint num;
    uintptr_t addr = node->zone.start_addr;
    if (node->zone.size - size > s) {
        // divide
        addr_ = node->zone.start_addr + size;
        size_ = node->zone.size - size;
        free.deleteNode(node->zone.zone_num);
        free.addNewMem(addr_, size_, num, next);
    } else {
        size = node->zone.size;
        next = (zone_node_t *) node->list.next;
        free.deleteNode(node->zone.zone_num);
    }
    used.addNewMem(addr, size, num, tmp);
    return next;
}

QVariantMap DynamicPartition::allocMem(int size) {
    uintptr_t addr;
    auto ret = QVariantMap();
    switch (strategy) {
        case FF: {
            for (size_t i = 0; i < free_zone.Size(); i++) {
                if (free_zone[i]->zone.size >= size) {
                    // find
                    addr = free_zone[i]->zone.start_addr;
                    last = divideMem(used_zone, free_zone, free_zone[i], size, 0);
                    goto ok;
                }
            }
            goto err;
        }
            break;
        case NF: {
            if (!last)
                last = free_zone[0];
            if (!last)
                goto err;
            auto mk = last;
            auto updt = last;
            FOREACH(zone_node_t, i, last->list.prev) {
                if (i->zone.size >= size) {
                    // find
                    addr = i->zone.start_addr;
                    last = divideMem(used_zone, free_zone, i, size, 0);
                    goto ok;
                    // update last
                }
            }
            FOREACH(zone_node_t, i, free_zone) {
                if (i == last)
                    break;
                if (i->zone.size >= size) {
                    // find
                    addr = i->zone.start_addr;
                    last = divideMem(used_zone, free_zone, i, size, 0);
                    goto ok;
                    // update last
                }
            }
            goto err;
        }
            break;
        case BF: {
            for (size_t i = 0; i < free_zone.Size(); i++) {
                if (free_zone.getSorted()[i]->zone.size >= size) {
                    // find
                    addr = free_zone.getSorted()[i]->zone.start_addr;
                    last = divideMem(used_zone, free_zone, free_zone.getSorted()[i], size, 0);
                    goto ok;
                }
            }
            goto err;
        }
            break;
        case WF: {
            for (size_t i = free_zone.Size() - 1;; i--) {
                if (free_zone.getSorted()[i]->zone.size >= size) {
                    // find
                    addr = free_zone.getSorted()[i]->zone.start_addr;
                    last = divideMem(used_zone, free_zone, free_zone.getSorted()[i], size, 0);
                    goto ok;
                }
                if (i == 0)
                    break;
            }
            goto err;
        }
            break;
        default:
            goto err;
            break;
    }
    err:
    ret.insert("status", -1);
    return ret;
    ok:
    ret.insert("status", 0);
    ret.insert("addr", addr);
    updateNotify();
    return ret;
}

bool DynamicPartition::freeMem(int start) {
    FOREACH(zone_node_t, i, used_zone) {
        if (i->zone.start_addr == start) {
            uintptr_t _s = i->zone.start_addr;
            size_t _size = i->zone.size;
            used_zone.deleteNode(i->zone.zone_num);
            uint num;
            zone_node_t *added;
            if (!free_zone.addNewMem(_s, _size, num, added))
                return false;
            if (!free_zone.mergeAfterFree(added))
                return false;
            updateNotify();
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