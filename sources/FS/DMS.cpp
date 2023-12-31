#include "DMS.h"

int FMS::Get_Now_State() {
    return this->NowState;
}

//用户名 用户密码->信息(register)
int FMS::Register(string name, string passage) {
    ull name_hash = Hash(name);//nameHash计算
    //判断是否存在
    bool f = 1;
    for (int i = h[root]; i; i = ne[i]) {
        int j = ver[i];
        if (node[j]->name_hash == name_hash) {
            f = 0;
            break;
        }
    }
    if (!f)//存在
    {
        return EXISTS;
    }
    int id;
    if (!q_id.empty())id = q_id.front(), q_id.pop();
    else if (idx < fnid)id = ++idx;
    else return FULL;
    if (_mkdir((path + "/" + name).c_str()) == -1) {
        q_id.push(id);
        return ERRORS;
    }
    node[id] = new Node(name, Hash(name), id, USER);
    file[id] = (File *) new User(name, id, passage);
    add(root, id);
    return PASS;
}

//用户名 用户密码->信息(login)
int FMS::Login(string name, string password) {
    ull name_hash = Hash(name);
    int id;
    bool f = 1;
    for (int i = h[root]; i; i = ne[i]) {
        int j = ver[i];
        if (node[j]->name_hash == name_hash) {
            f = 0;
            id = node[j]->id;
            break;
        }
    }
    if (f) {
        return NOTEXISTS;
    }
    auto it = (User *) file[id];
    if (it->password == password) {
        now = id;
        path += "/" + name;
        return PASS;
    } else {
        return PASSWORDERROR;
    }
    return PASS;
}

//文件名 文件类型->信息(create,mkdir)
int FMS::Create(string name, int op) {
    if (node[now]->op == FILE) {
        return ERRORS;
    }
    if (op == FOLDER) {
        ull name_hash = Hash(name);
        for (int i = h[now]; i; i = ne[i]) {
            int j = ver[i];
            if (node[j]->name_hash == name_hash) {
                return EXISTS;
            }
        }
        int id;
        if (!q_id.empty())id = q_id.front(), q_id.pop();
        else if (idx < fnid)id = ++idx;
        else return FULL;
        if (_mkdir((path + "/" + name).c_str()) == -1) {
            q_id.push(id);
            return ERRORS;
        }
        file[id] = (File *) new Folder(name, id);
        node[id] = new Node(name, Hash(name), id, FOLDER);
        add(now, id);
    } else if (op == FILE) {
        ull name_hash = Hash(name);
        for (int i = h[now]; i; i = ne[i]) {
            int j = ver[i];
            if (node[j]->name_hash == name_hash) {
                return EXISTS;
            }
        }
        int id;
        if (!q_id.empty())id = q_id.front(), q_id.pop();
        else if (idx < fnid)id = ++idx;
        else return FULL;
        ofstream ofs;
        ofs.open(path + "/" + name, ios::app);
        if (!ofs.is_open()) {
            q_id.push(id);
            return ERRORS;
        }
        file[id] = new File(name, id, path + "/" + name);
        node[id] = new Node(name, Hash(name), id, FILE);
        add(now, id);
    } else
        return ERRORS;
    return PASS;
}

//文件名->信息(open)
//文件名->信息(open)
int FMS::Open(string pathname) {
    //cout << "node[1]->name" << node[1]->name << endl;
    bool is_absolute_path = false; // 是否为绝对路径
    queue<string> paths;// 各步的文件夹
    string target_name;// 目标文件的name
    string ofs_op_str = pathname;


    if (node[now]->op == FILE) {
        return ERRORS;
    }
    if (pathname.substr(0, 2) == "//") {
        is_absolute_path = 1;
    }

    // 储存当前目录
    auto pre_now = now;

    //将pathname分为 path 和 name
    if (is_absolute_path == false) {
        int cut_num = 0;
        if (pathname.substr(0, 2) == "./") pathname = pathname.substr(2);// 假设开头是./114514
        if (pathname[0] == '/') pathname = pathname.substr(1);// 假设开头是/114514
        for (int i = 0; i < pathname.size(); i++) {
            if (pathname[i] == '/') {
                paths.push(pathname.substr(cut_num, i - cut_num));
                cut_num = i + 1;
            }
        }
        target_name = pathname.substr(cut_num, pathname.size() - cut_num);
    } else {
        int cut_num = 0;
        pathname = pathname.substr(2);
        for (int i = 0; i < pathname.size(); i++) {
            if (pathname[i] == '/') {
                paths.push(pathname.substr(cut_num, i - cut_num));
                cut_num = i + 1;
            }
        }
        target_name = pathname.substr(cut_num, pathname.size() - cut_num);
    }

    //target寻找并存储目标节点的id
    int target;
    if (is_absolute_path) target = 1; //根节点id为1
    else target = now;

    //一个个寻找对应文件夹
    while (!paths.empty()) {
        string opstr = paths.front();
        paths.pop();
        bool success_find = 0;
        if (opstr == "..") target = fa[target], success_find = 1; // 进入父节点（上级）
        else {
            //int hash_opstr = Hash(opstr);
            for (int i = h[target]; i; i = ne[i]) {
                int j = ver[i];
                auto wtf = node[j]->name;
                if (node[j]->name == opstr) {
                    target = j, success_find = 1;
                    break;
                }
            }
        }
        if (success_find == 0) {
            printf("unable to find folder: %s", opstr.c_str());
            return ERRORS;
        } else continue;
    }

    //target 现在为目标所在的文件夹，现在需要寻找文件
    ull hash_opstr = Hash(target_name);
    bool success_find = 0;
    for (int i = h[target]; i; i = ne[i]) {
        int j = ver[i];
        if (node[j]->name_hash == hash_opstr) {
            target = j, success_find = true;
            break;
        }
    }

    if (success_find == false) {
        printf("unable to find file: %s", target_name.c_str());
        return ERRORS;
    }

    //文件运行在本项目的根，因此需要使用fms下的绝对路径来作为ofs的参数（相对路径
    //如果不是绝对路径，将其更新为绝对路径;绝对路径则在前面加上"root/"
    if (is_absolute_path == false) {
        ofs_op_str = node[target]->name;
        int i = fa[target];
        while (true) {

            ofs_op_str = node[i]->name + "/" + ofs_op_str;

            if (i == 1) break;
            i = fa[i];
        }
    } else ofs_op_str = node[1]->name + '/' + pathname;

    this->fopened = true;
    int fDISCRIPTION = target;

    printf("已打开文件%s", ofs_op_str.c_str());

    ifs.open(ofs_op_str);
    stringstream buffer;
    buffer << ifs.rdbuf();
    cont_buf = string(buffer.str());
    ifs.close();
    ofs.open(ofs_op_str);

    return PASS;

}

//->信息(close)
int FMS::Close() {
    if (!ofs.is_open()) {
        if (ifs.is_open())
            ifs.close();
        return ERRORS;
    }
    if (ifs.is_open())
        ifs.close();
    ofs.close();
    return PASS;
}

//->读取内容(read)
string FMS::Read() {
    return cont_buf;
}

////路径->信息(cd)
int FMS::Cd(string path) {
    if (node[now]->op == FILE) {
        return ERRORS;
    }

    bool is_absolute_path = false; // 是否为绝对路径
    queue<string> paths;// 各步的文件夹
    string target_name;// 目标文件的name


    if (node[now]->op == FILE) {
        return ERRORS;
    }
    if (path.substr(0, 2) == "//") {
        is_absolute_path = 1;
    }

    // 储存当前目录
    auto pre_now = now;

    //将pathname分为 path 和 name
    if (is_absolute_path == false) {
        int cut_num = 0;
        if (path.substr(0, 2) == "./") path = path.substr(2);// 假设开头是./114514
        if (path[0] == '/') path = path.substr(1);// 假设开头是/114514
        for (int i = 0; i < path.size(); i++) {
            if (path[i] == '/') {
                paths.push(path.substr(cut_num, i - cut_num));
                cut_num = i + 1;
            }
        }
        //如果结尾不是'/'，加入最后的文件夹名
        if (path[path.size() - 1] != '/') paths.push(path.substr(cut_num, path.size() - cut_num));
    } else {
        int cut_num = 0;
        path = path.substr(2);
        for (int i = 0; i < path.size(); i++) {
            if (path[i] == '/') {
                paths.push(path.substr(cut_num, i - cut_num));
                cut_num = i + 1;
            }
        }
        if (path[path.size() - 1] != '/') paths.push(path.substr(cut_num, path.size() - cut_num));
    }

    //target寻找并存储目标节点的id
    int target;
    if (is_absolute_path) target = 1; //根节点id为1
    else target = now;

    //一个个寻找对应文件夹
    while (!paths.empty()) {
        string opstr = paths.front();
        paths.pop();
        bool success_find = 0;
        if (opstr == "..") target = fa[target], success_find = 1; // 进入父节点（上级）
        else {
            //int hash_opstr = Hash(opstr);
            for (int i = h[target]; i; i = ne[i]) {
                int j = ver[i];
                //auto wtf = node[j]->name;
                if (node[j]->name == opstr) {
                    target = j, success_find = 1;
                    break;
                }
            }
        }
        if (success_find == 0) {
            printf("unable to find folder: %s", opstr.c_str());
            return ERRORS;
        } else continue;
    }

    //文件运行在本项目的根，因此需要使用fms下的绝对路径来作为ofs的参数（相对路径
    //如果不是绝对路径，将其更新为绝对路径;绝对路径则在前面加上"root/"
    string folder_open_str;
    if (is_absolute_path == false) {
        folder_open_str = node[target]->name;
        int i = fa[target];
        while (true) {

            folder_open_str = node[i]->name + "/" + folder_open_str;

            if (i == 1) break;
            i = fa[i];
        }
    } else {
        if (path.substr(path.length() - 2, 2) == "..") {
            auto tmp_sub = path.substr(0, path.rfind('/'));
            folder_open_str = node[1]->name + "/" + tmp_sub.substr(0, tmp_sub.rfind('/'));
        } else
            folder_open_str = node[1]->name + "/" + path;
    }

    //修改fms变量
    now = target;
    this->path = folder_open_str;


    return PASS;
}

////->目录下文件名(dir,ls)
vector<string> FMS::Show() {
    if (node[now]->op == FILE) {
        NowState = ERRORS;
        return vector<string>();
    }
    // vector<string> names;
    vector<string> dirs;
    vector<string> files;
    for (auto i = h[now]; i; i = ne[i]) {
        auto id = ver[i];
        if (node[i]->op == FILE) {
            files.push_back(node[id]->name + "/" + to_string(file[i]->mod) + "/" + (node[i]->op == FILE ? "f" : "d"));
        } else {
            dirs.push_back(node[id]->name + "/" + to_string(file[i]->mod) + "/" + (node[i]->op == FILE ? "f" : "d"));
        }
    }
    std::sort(dirs.begin(), dirs.end());
    std::sort(files.begin(), files.end());
    for (auto i = files.begin(); i != files.end(); i++)
        dirs.emplace_back(*i);
    return dirs;
}

//写入内容->信息(write)
int FMS::Write(string value) {
    if (!ofs.is_open())
        return ERRORS;
    ofs.seekp(0);
    ofs << value;
    ofs.flush();
    return PASS;
}

////文件名 权限->信息(change)
///文件名 权限->信息(change)
int FMS::Change(string name, int mod) {
    ull name_hash = Hash(name);
    bool f = 1;
    for (int i = h[now]; i; i = ne[i]) {
        int j = ver[i];
        if (node[j]->name_hash == name_hash) {
            file[j]->mod = mod;
            f = 0;
            break;
        }
    }
    if (f) {
        return NOTEXISTS;
    }
    return PASS;
}

////文件名->文件目录(search)
//文件名->文件目录(search)
string FMS::Search(string name) {
    queue<int> q;
    q.push(now);
    int id = -1;
    ull name_hash = Hash(name);
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        for (int i = h[u]; i; i = ne[i]) {
            int j = ver[i];
            if (node[j]->name_hash == name_hash) {
                id = j;
                break;
            } else if (node[j]->op == FOLDER) {
                q.push(j);
            }
        }
        if (id != -1)break;
    }
    if (id == -1) {
        NowState = NOTEXISTS;
        return "";
    } else {
        string path = name;
        NowState = PASS;
        while (fa[id]) {
            path = node[fa[id]]->name + "/" + path;
            id = fa[id];
        }
        return path;
    }
}

//递归删除
void FMS::dfs_delete(string path, int id, int idd) {
    for (int &i = h[id]; i; i = ne[i]) {
        int j = ver[i];
        if (node[j]->op == FILE) {
            remove((path + "/" + node[j]->name).c_str());
            delete node[j];
            delete file[j];
            node[j] = nullptr;
            file[j] = nullptr;
            q_id.push(j);
        } else {
            dfs_delete(path + "/" + node[j]->name, j, i);
        }
    }
    _rmdir(path.c_str());
    delete node[id];
    delete file[id];
    node[id] = nullptr;
    file[id] = nullptr;
    q_id.push(id);
    sub(id, idd);
}

//文件名 文件类型->信息(delete,remove)
int FMS::Delete(string name, string pa, int idd) {
    if (idd == -1)idd = now, pa = path;
    ull name_hash = Hash(name);
    int id = -1, idw, op;
    for (int i = h[idd]; i; i = ne[i]) {
        int j = ver[i];
        if (node[j]->name_hash == name_hash) {
            id = j;
            idw = i;
            op = node[j]->op;
            break;
        }
    }
    if (id == -1)return PASS;
    if (op == FOLDER || op == USER) {
        dfs_delete(pa + "/" + name, id, idw);
        return PASS;
    } else if (op == FILE) {
        remove((pa + "/" + name).c_str());
        sub(id, idw);
        delete node[id];
        delete file[id];
        node[id] = nullptr;
        file[id] = nullptr;
        q_id.push(id);
        return PASS;
    }
}
