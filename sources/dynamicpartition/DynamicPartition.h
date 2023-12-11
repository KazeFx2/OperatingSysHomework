//
// Created by Kaze Fx on 2023/11/23.
//

#ifndef QT_TEST_DYNAMICPARTITION_H
#define QT_TEST_DYNAMICPARTITION_H

#include "QtIncludes.h"

extern "C" {
#include "C_component/list/CList.h"
#undef bool
};

typedef unsigned short strategy_t;

#define FF 0x1  // First Fit
#define NF 0x2  // Next Fit
#define BF 0x4  // Best Fit
#define WF 0x8  // Worst Fit

#define ADDR_SORT (FF | NF)
#define SIZE_SORT (BF | WF)

#define SET_NODE_(node, start, _size) ((node)->zone.start_addr = (uintptr_t)(start)), \
((node)->zone.size = (size_t)(_size))

// zone describe structure
typedef struct zone_desc_s {
    uint zone_num;
    size_t size;
    uintptr_t start_addr;
    node_t *ref;
} zone_desc_t;

typedef struct zone_node_s {
    node_t list;
    zone_desc_t zone;
} zone_node_t;

typedef struct zone_size_node_s {
    node_t list;
    zone_desc_t *p_zone;
} zone_size_node_t;

#define list_op_after(node, op) FOREACH(zone_node_t, __i, node) __i->zone.zone_num op

class MemList {
private:
    list_t mem, size_sort;
    size_t size;

    node_t *checkNewMem(uintptr_t start, size_t _size) {
        auto end = start + _size;
        FOREACH(zone_node_t, i, mem) {
            if (i->zone.start_addr + i->zone.size <= start)
                continue;
            if (end > i->zone.start_addr)
                return nullptr;
            return (node_t *) i;
        }
        return mem;
    }

    static zone_size_node_t *findAfter(list_t head, size_t new_size) {
        FOREACH(zone_size_node_t, i, head) {
            if (i->p_zone->size > new_size)
                return i;
        }
        return nullptr;
    }

    size_t findIndex(zone_node_t *node) {
        size_t index = 0;
        FOREACH(zone_node_t, i, mem) if (i == node) return index; else index++;
        return index;
    }

    bool checkNodeIsOwned(zone_node_t *node) {
        if (findIndex(node) == size)
            return false;
        return true;
    }

public:

    MemList() {
        mem = initList();
        size_sort = initList();
        size = 0;
    }

    ~MemList() {
        destroyList(mem);
        destroyList(size_sort);
    }

    MemList(MemList &in) {
        mem = initList(), size_sort = initList();
        FOREACH(zone_node_t, i, in.mem)pushEnd(mem, &i->zone, sizeof(zone_node_t));
        FOREACH(zone_size_node_t, i, in.size_sort) pushEnd(size_sort, &i->p_zone, sizeof(zone_size_node_t));
        size = in.size;
    }

    MemList &operator=(MemList &in) {
        clearList(mem), clearList(size_sort);
        FOREACH(zone_node_t, i, in.mem)pushEnd(mem, &i->zone, sizeof(zone_node_t));
        FOREACH(zone_size_node_t, i, in.size_sort) pushEnd(size_sort, &i->p_zone, sizeof(zone_size_node_t));
        size = in.size;
        return *this;
    }

    operator list_t() const {
        return mem;
    }

    void clear() {
        clearList(mem), clearList(size_sort);
        size = 0;
    }

    size_t Size() const { return size; }

    bool addNewMem(uintptr_t start, size_t _size, __out uint &num, __out zone_node_t *&added) {
        node_t *after = checkNewMem(start, _size);
        if (!after)
            return false;
        zone_node_t *new_node = (zone_node_t *) __malloc(sizeof(zone_node_t));
        zone_size_node_t *ref = (zone_size_node_t *) __malloc(sizeof(zone_size_node_t));
        if (!new_node || !ref) {
            if (new_node)
                __free(new_node);
            if (ref)
                __free(ref);
            return false;
        }
        added = new_node;
        SET_NODE_(new_node, start, _size);
        new_node->zone.ref = (node_t *) ref;
        ref->p_zone = &new_node->zone;
        if (after == mem) {
            // add in the end
            num = new_node->zone.zone_num = size;
            pushExistEnd(mem, (node_t *) new_node);
        } else {
            // insert before AFTER
            num = new_node->zone.zone_num = ((zone_node_t *) after)->zone.zone_num;
            addExistNodeBefore(mem, after, (node_t *) new_node);
            list_op_after(after->prev, ++);
        }
        addExistNodeBefore(size_sort, findAfter(size_sort, _size), (node_t *) ref);
        size++;
        return true;
    }

    bool deleteNode(uint id) {
        if (id >= size)
            return false;
        node_t **target = findNodeByIndex(&mem, id);
        if (!target)
            return false;
        node_t *dn = *target;
        if (!dn)
            return false;
        // apply delete
        removeNode(((zone_node_t *) dn)->zone.ref);
        list_op_after(dn, --);
        size--;
        removeNode(dn);
        __free(((zone_node_t *) dn)->zone.ref);
        __free(dn);
        return true;
    }

    bool findNode(zone_node_t *node) {
        FOREACH(zone_node_t, i, mem)if (i == node)
                return true;
        return false;
    }

    zone_node_t *operator[](size_t index) {
        return *(zone_node_t **) findNodeByIndex(&mem, index);
    }

    struct size_sorted {
        list_t sorted;

        size_sorted(list_t s) : sorted(s) {}

        zone_node_t *operator[](size_t index) {
            auto ptr = *(zone_size_node_t **) findNodeByIndex(&sorted, index);
            if (ptr == nullptr)
                return nullptr;
            return (zone_node_t *) op_ptr((ptr)->p_zone,
                                          -offset_of(zone_node_t, zone));
        }
    };

    size_sorted getSorted() const {
        return {size_sort};
    }

    bool mergeAfterFree(zone_node_t *new_node) {
        if (!checkNodeIsOwned(new_node))
            return false;
        zone_node_t *before = (zone_node_t *) new_node->list.prev,
                *after = (zone_node_t *) new_node->list.next;
        bool mergeBefore = false, mergeAfter = false;
        if (before != (zone_node_t *) mem && before->zone.start_addr + before->zone.size == new_node->zone.start_addr)
            mergeBefore = true;
        if (after && new_node->zone.start_addr + new_node->zone.size == after->zone.start_addr)
            mergeAfter = true;
        if (mergeAfter) {
            new_node->zone.size += after->zone.size;
            deleteNode(after->zone.zone_num);
        }
        if (mergeBefore) {
            before->zone.size += new_node->zone.size;
            deleteNode(new_node->zone.zone_num);
        }
        return true;
    }
};

class DynamicPartition : public QObject {

General_Constrictor(DynamicPartition, {
    strategy = FF;
    m_update = true;
    last = nullptr;
})

private:

    MemList free_zone, used_zone;
    strategy_t strategy;
    zone_node_t *last;

    void updateNotify();

public:


    void init(char *argv[]) {
        loadDefaultData();
    }

    bool m_update;

    Q_PROPERTY(bool update READ update NOTIFY updateChanged)

    bool update() const {
        return m_update;
    }

    Q_INVOKABLE
    void reset();

    Q_INVOKABLE
    int addZone(int size, int start);

    Q_INVOKABLE
    bool deleteZone(int zone_num);

    Q_INVOKABLE
    bool deleteZoneUsed(int zone_num);

    Q_INVOKABLE
    QVariantList getZones() const;

    Q_INVOKABLE
    QVariantList getZonesUsed() const;

    Q_INVOKABLE
    QVariantList getAllZones() const;

    Q_INVOKABLE
    QVariantMap allocMem(int size);

    Q_INVOKABLE
    bool freeMem(int start);

    Q_INVOKABLE
    bool setStrategy(QString strategy);

    Q_INVOKABLE
    QString getStrategy();

    Q_INVOKABLE
    void loadDefaultData() {
        reset();
        addZone(60, 100);
        addZone(120, 240);
        addZone(100, 500);
        addZone(80, 760);
        addZone(40, 960);
    }

signals:

    void updateChanged();

};

#endif //QT_TEST_DYNAMICPARTITION_H
