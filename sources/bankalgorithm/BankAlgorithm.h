#ifndef BANKALGORITHM_H
#define BANKALGORITHM_H

#include <QtCore/qobject.h>
#include <QtQml/qqml.h>
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
    // safe flag
    bool safe_flag;
    // calc flag
    bool calc;
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
    // max history
    int max_history;
    // now_status
    status now;
    // src_names
    std::vector<QString> names;

    explicit BankAlgorithm(QObject *parent = nullptr);

public:

SINGLETON(BankAlgorithm)

    ~BankAlgorithm() override;

    void init(char *argv[]);

    // static BankAlgorithm *instance();

    Q_PROPERTY(int nProcess READ getNProcess NOTIFY nProcessChanged)

    Q_INVOKABLE
    void reset();

    Q_INVOKABLE
    void reset_except_src();

    void need_ReCalc();

    // about resources
    Q_INVOKABLE
    int addSrc(QString name, int max_cap);

    Q_INVOKABLE
    bool deleteSrc(QString name);

    Q_INVOKABLE
    bool deleteSrc(int index);

    Q_INVOKABLE
    int getIndex(QString name);

    // about process
    Q_INVOKABLE
    bool processIdAva(int process_i) const;

    Q_INVOKABLE
    int addProcess(std::vector<int> malloced, std::vector<int> need);

    Q_INVOKABLE
    bool modifyMalloced(int process_i, int src_i, int val);

    Q_INVOKABLE
    bool modifyMalloced(int process_i, QString src_name, int val);

    Q_INVOKABLE
    bool modifyNeed(int process_i, int src_i, int val);

    Q_INVOKABLE
    bool modifyNeed(int process_i, QString src_name, int val);

    Q_INVOKABLE
    bool deleteProcess(int process_i);

    // safety
    Q_INVOKABLE
    bool isSafe();

    Q_INVOKABLE
    std::vector<int> getSequence() const;

    // status switch
    Q_INVOKABLE
    bool nextStatus();

    Q_INVOKABLE
    bool prevStatus();

    Q_INVOKABLE
    bool isBegin() const;

    Q_INVOKABLE
    bool isEnd();

    // get status
    Q_INVOKABLE
    std::vector<int> getMalloced(int process_i) const;

    Q_INVOKABLE
    std::vector<int> getNeed(int process_i) const;

    Q_INVOKABLE
    std::vector<int> getTotal() const;

    Q_INVOKABLE
    std::vector<int> getCost() const;

    Q_INVOKABLE
    std::vector<int> getLeft() const;

    Q_INVOKABLE
    int getNSrc() const;

    Q_INVOKABLE
    int getNProcess() const;

    Q_INVOKABLE
    std::vector<QString> getNames() const;

    Q_INVOKABLE
    std::vector<int> getProcesses() const;

signals:
    void nProcessChanged();
};

#endif // BANKALGORITHM_H
