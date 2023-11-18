#ifndef BANKALGORITHM_H
#define BANKALGORITHM_H

#include <QObject>
#include <QQmlEngine>
#include <vector>
#include "singleton.h"

#define MAX_HISTORY 512

typedef struct {
    // num of process (alive)
    // because of process will be "removed" (not exist),
    // so PROCESS_N USUALLY NOT EQUALS TO MALLOCED.SIZE()
    int process_n;
    // src_malloced
    std::vector<std::vector<int>> malloced;
    // src_need
    std::vector<std::vector<int>> need;
    // process_status
    std::vector<bool> exist;
    // seq_pos
    int pos;
    // available_sequence
    std::vector<int> ava_seq;
} status;

class BankAlgorithm : public QObject {
Q_OBJECT
// QML_ELEMENT
private:
    // num of system resource
    int src_n;
    // system resource total
    std::vector<int> sys_total;
    // statuses
    std::vector<status> status_sequence;
    // now status, default 0
    int now_st;
    // safe_flag
    bool safe_flag, calc;
    // max history
    int max_history;
    // now_status
    status now;
    // src_names
    std::vector<QString> names;
public:
SINGLETON(BankAlgorithm)

    explicit BankAlgorithm(QObject *parent = nullptr);

    ~BankAlgorithm() = default;

    static BankAlgorithm *instance();

    Q_INVOKABLE void reset();

    Q_INVOKABLE void reset_except_src();

    void need_ReCalc();

    // about resources
    Q_INVOKABLE int addSrc(const QString &name, int max_cap);

    Q_INVOKABLE bool deleteSrc(QString &name);

    Q_INVOKABLE bool deleteSrc(int index);

    // about process
    Q_INVOKABLE int addProcess(const std::vector<int> &malloced, const std::vector<int> &need);

    Q_INVOKABLE bool modifyMalloced(int process_i, int src_i, int val);

    Q_INVOKABLE bool modifyMalloced(int process_i, const QString &src_name, int val);

    Q_INVOKABLE bool modifyNeed(int process_i, int src_i, int val);

    Q_INVOKABLE bool modifyNeed(int process_i, const QString &src_name, int val);

    Q_INVOKABLE bool deleteProcess(int process_i);

    // safety
    Q_INVOKABLE bool isSafe();

    Q_INVOKABLE std::vector<int> getSequence() const;

    // status switch
    Q_INVOKABLE bool nextStatus();

    Q_INVOKABLE bool prevStatus();

    Q_INVOKABLE bool isBegin() const;

    Q_INVOKABLE bool isEnd() const;

    // get status

signals:

};

#endif // BANKALGORITHM_H
