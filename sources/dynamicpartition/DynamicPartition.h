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

typedef enum {
    FF = 0, // First Fit
    NF,     // Next Fit
    BF,     // Best Fit
    WF      // Worst Fit
} strategy_t;

// zone describe structure
typedef struct zone_desc_s {
    uint zone_num;
    size_t size;
    uintptr_t start_addr;
} zone_desc_t;

typedef struct zone_node_s {
    node_t list;
    zone_desc_t zone;
} zone_node_t;

class DynamicPartition : public QObject {

    General_Constrictor(DynamicPartition, {
        zone_list = initList();
        used_zone = initList();
        strategy = FF;
        m_update = true;
        length = 0;
    })

private:

    list_t zone_list, used_zone;
    strategy_t strategy;
    uint length;

    zone_node_t *checkNewZone(int size, int start);

    void updateNotify();

public:

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
    QVariantList getZones() const;

    Q_INVOKABLE
    QVariantList getZonesUsed() const;

    Q_INVOKABLE
    QVariantMap allocMem(int size);

    Q_INVOKABLE
    bool freeMem(int start);

    Q_INVOKABLE
    bool setStrategy(QString strategy);

    Q_INVOKABLE
    QString getStrategy();

signals:

    void updateChanged();

};

#endif //QT_TEST_DYNAMICPARTITION_H
