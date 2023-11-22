#include "BankAlgorithm.h"

inline
std::vector<int>
calcCost(const std::vector<std::vector<int>> &malloced,
         const std::vector<bool> &exist, int src_n,
         int *out_cost = nullptr,
         int src_i = -1) {
    if (malloced.empty()) {
        if (out_cost)
            *out_cost = 0;
        std::vector<int> res(src_n, 0);
        return res;
    }
    std::vector<int> res(malloced[0].size(), 0);
    if (src_i >= 0) {
        if (src_i >= malloced[0].size()) {
            if (out_cost)
                *out_cost = -1;
            return res;
        }
        if (!out_cost)
            return res;
        *out_cost = 0;
        for (int i = 0; i < malloced.size(); i++)
            if (exist[i])
                *out_cost += malloced[i][src_i];
        return res;
    }
    for (int i = 0; i < malloced.size(); i++) {
        if (exist[i])
            for (int j = 0; j < malloced[i].size(); j++)
                res[j] += malloced[i][j];
    }
    if (out_cost)
        *out_cost = 0;
    return res;
}

template<typename Ty>
int findIndex(std::vector<Ty> &_vector, const Ty &val) {
    auto iter = std::find(_vector.begin(), _vector.end(), val);
    if (iter == _vector.end())
        return -1;
    return std::distance(_vector.begin(), iter);
}

BankAlgorithm::BankAlgorithm(QObject *parent) : QObject(parent) {
    reset();
}

void BankAlgorithm::init(char *argv[]) {
    int n = 1;
    for (int i = 0; i < n; i++)
        addSrc(QString("Src_").append('1' + i), 100);
}

BankAlgorithm::~BankAlgorithm() = default;

//BankAlgorithm *BankAlgorithm::instance() {
//    static BankAlgorithm *instance = new BankAlgorithm();
//    return instance;
//}

void BankAlgorithm::reset() {
    src_n = 0;
    sys_total.clear();
    reset_except_src();
}

void BankAlgorithm::reset_except_src() {
    status_sequence.clear();
    now_st = 0;
    max_history = MAX_HISTORY;
    now = {0,
           std::vector<std::vector<int >>(),
           std::vector<std::vector<int >>(),
           std::vector<bool>(),
           0,
           std::vector<int>()};
    if (now_st < status_sequence.size()) {
        auto iter = status_sequence.begin() + now_st;
        status_sequence.erase(iter);
    }
    need_ReCalc();
}

void BankAlgorithm::need_ReCalc() {
    safe_flag = calc = false;
}

int BankAlgorithm::addSrc(QString name, int max_cap) {
    if (getIndex(name) != -1 || max_cap <= 0)
        return -1;
    src_n++;
    sys_total.push_back(max_cap);
    names.push_back(name);
    for (int i = 0; i < now.malloced.size(); i++)
        now.malloced[i].push_back(0),
                now.need[i].push_back(0);
    return int(sys_total.size()) - 1;
}

bool BankAlgorithm::deleteSrc(QString name) {
    int index = getIndex(name);
    auto last = std::remove(
            names.begin(),
            names.end(),
            name
    );
    if (last == names.end())
        return false;
    auto tt_iter = sys_total.begin() + index;
    sys_total.erase(tt_iter);
    names.erase(
            last,
            names.end()
    );
    src_n--;
    reset_except_src();
    need_ReCalc();
    return true;
}

bool BankAlgorithm::deleteSrc(int index) {
    if (index >= names.size())
        return false;
    auto tt_iter = sys_total.begin() + index;
    sys_total.erase(tt_iter);
    names.erase(
            std::remove(
                    names.begin(), names.end(),
                    names[index]
            ),
            names.end()
    );
    src_n--;
    reset_except_src();
    need_ReCalc();
    return true;
}

int BankAlgorithm::getIndex(QString name) {
    return findIndex(names, name);
}

bool BankAlgorithm::processIdAva(int process_i) const {
    if (process_i < 0 ||
        process_i >= now.malloced.size() ||
        !now.exist[process_i])
        return false;
    return true;
}

int BankAlgorithm::addProcess(std::vector<int> malloced, std::vector<int> need) {
    if (malloced.size() != need.size())
        return -1;
    int i, j, n = malloced.size();
    // check
    j = 0;
    for (i = 0; i < n; i++) {
        if (malloced[i] != 0 || need[i] != 0) {
            j = 1;
            break;
        }
    }
    if (!j || src_n == 0 || n > src_n)
        return -1;
    for (i = 0; i < n; i++) {
        if (sys_total[i] < malloced[i] + need[i])
            return -1;
        int cost;
        calcCost(now.malloced, now.exist, src_n, &cost, i);
        if (sys_total[i] < cost + malloced[i])
            return -1;
    }
    // add
    now.process_n++;
    // find dead process
    int id;
    for (i = 0; i < now.malloced.size(); i++)
        if (!now.exist[i]) {
            id = i,
                    now.exist[i] = true;
            break;
        }
    if (i == now.malloced.size()) {
        id = i;
        now.exist.push_back(true);
        now.malloced.push_back(malloced),
                now.need.push_back(need);
//        std::vector<int> &_malloced = now.malloced.back(),
//                &_need = now.need.back();
//        for (i = 0; i < n; i++)
//            _malloced.push_back(malloced[i]),
//                    _need.push_back(need[i]);
    } else {
        now.malloced[id] = malloced,
                now.need[id] = need;
//        std::vector<int> &_malloced = now.malloced[id],
//                &_need = now.need[id];
//        for (i = 0; i < n; i++)
//            _malloced.push_back(malloced[i]),
//                    _need.push_back(need[i]);
    }
    need_ReCalc();
    return id;
}

bool BankAlgorithm::modifyMalloced(int process_i, int src_i, int val) {
    // find process
    if (src_i < 0 ||
        src_n <= src_i ||
        val < 0 ||
        !processIdAva(process_i))
        return false;
    // check new val whether legal
    int cost, left, add;
    calcCost(now.malloced, now.exist, src_n, &cost, src_i);
    if (cost == -1)
        return false;
    left = sys_total[src_i] - cost;
    add = val - now.malloced[process_i][src_i];
    if (left < add)
        return false;
    // apply
    now.malloced[process_i][src_i] = val;
    need_ReCalc();
    return true;
}

bool BankAlgorithm::modifyMalloced(int process_i, QString src_name, int val) {
    return modifyMalloced(process_i, findIndex(names, src_name), val);
}

bool BankAlgorithm::modifyNeed(int process_i, int src_i, int val) {
    // find process
    if (src_i < 0 ||
        src_n <= src_i ||
        val < 0 ||
        !processIdAva(process_i))
        return false;
    // check new val whether legal
    if (sys_total[src_i] < now.malloced[process_i][src_i] + val)
        return false;
    // apply
    now.need[process_i][src_i] = val;
    need_ReCalc();
    return true;
}

bool BankAlgorithm::modifyNeed(int process_i, QString src_name, int val) {
    return modifyNeed(process_i, findIndex(names, src_name), val);
}

bool BankAlgorithm::deleteProcess(int process_i) {
    if (!processIdAva(process_i))
        return false;
    now.exist[process_i] = false;
    now.process_n--;
    need_ReCalc();
    return true;
}

bool BankAlgorithm::isSafe() {
    if (calc)
        return safe_flag;
    // main part of bank algorithm

    int left_process = now.process_n, i, j, position = 0;
    bool flag;
    std::vector<int> tmp_sequence(now.process_n, -1);
    std::vector<bool> alive = now.exist;
    std::vector<int> left = calcCost(now.malloced, now.exist, src_n);
    for (i = 0; i < src_n; i++)
        left[i] = sys_total[i] - left[i];
    while (left_process > 0) {
        for (i = tmp_sequence[position] + 1; i < now.malloced.size(); i++) {
            if (!alive[i])
                continue;
            flag = true;
            // need < left
            for (j = 0; j < src_n; j++) {
                if (left[j] < now.need[i][j]) {
                    flag = false;
                    break;
                }
            }
            if (flag)
                break;
        }
        if (i < now.malloced.size()) {
            tmp_sequence[position++] = i;
            alive[i] = false;
            for (j = 0; j < src_n; j++)
                left[j] += now.malloced[i][j];
            left_process--;
        } else {
            // rollback
            // data recovery
            position--;
            if (position < 0) {
                // not safe
                now.ava_seq = std::vector<int>();
                calc = true;
                safe_flag = false;
                return false;
            }
            i = tmp_sequence[position];
            alive[i] = true;
            for (j = 0; j < src_n; j++)
                left[j] -= now.malloced[i][j];
            left_process++;
        }
    }
    now.ava_seq = tmp_sequence;
    now.pos = 0;
    return true;
}

std::vector<int> BankAlgorithm::getSequence() const {
    return now.ava_seq;
}

bool BankAlgorithm::nextStatus() {
    if (now_st < status_sequence.size()) {
        now = status_sequence[now_st];
        now_st++;
        return true;
    }
    if (now_st >= max_history || isEnd())
        return false;
    if (!calc)
        if (!isSafe())
            return false;
    if (!safe_flag)
        return false;
    // save status
    status_sequence.push_back(now);
    now_st++;
    // switch status
    now.exist[now.ava_seq[now.pos]] = false;
    now.process_n--;
    now.pos++;
    return true;
}

bool BankAlgorithm::prevStatus() {
    if (isBegin())
        return false;
    if (now_st == status_sequence.size() && now_st < max_history)
        status_sequence.push_back(now);
    now_st--;
    now = status_sequence[now_st];
    return true;
}

bool BankAlgorithm::isBegin() const {
    if (now_st <= 0)
        return true;
    return false;
}

bool BankAlgorithm::isEnd() const {
    if (now.process_n <= 0)
        return true;
    return false;
}

std::vector<int> BankAlgorithm::getMalloced(int process_i) const {
    if (!processIdAva(process_i))
        return std::vector<int>(1, -1);
    return now.malloced[process_i];
}

std::vector<int> BankAlgorithm::getNeed(int process_i) const {
    if (!processIdAva(process_i))
        return std::vector<int>(1, -1);
    return now.need[process_i];
}

std::vector<int> BankAlgorithm::getTotal() const {
    return sys_total;
}

std::vector<int> BankAlgorithm::getCost() const {
    return calcCost(now.malloced, now.exist, src_n);
}

std::vector<int> BankAlgorithm::getLeft() const {
    auto left = calcCost(now.malloced, now.exist, src_n);
    auto i = left.begin();
    auto j = sys_total.begin();
    for (; i != left.end() && j != sys_total.end(); i++, j++)
        *i = *j - *i;
    return left;
}

int BankAlgorithm::getNSrc() const {
    return src_n;
}

int BankAlgorithm::getNProcess() const {
    return now.process_n;
}

std::vector<QString> BankAlgorithm::getNames() const {
    return names;
}

std::vector<int> BankAlgorithm::getProcesses() const {
    std::vector<int> ret(now.process_n, -1);
    int pos = 0;
    for (int i = 0; i < now.exist.size(); i++)
        if (now.exist[i])
            ret[pos++] = i;
    return ret;
}