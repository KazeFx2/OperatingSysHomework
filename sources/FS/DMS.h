#pragma once

#include<direct.h>
#include<string>
#include<vector>
#include<queue>
#include<fstream>
#include<unordered_map>
#include<iostream>
#include <sstream>

using namespace std;
#define ull unsigned long long

//文件
class File {
public:
    string name;//文件名
    int id;//文件id
    int mod;//文件权限
public:
    File(string _name, int _id, string path, int _mod = 744) : name(_name), id(_id), mod(_mod) {
    }

    File(string _name, int _id, int _mod = 744) : name(_name), id(_id), mod(_mod) {}

    ~File() {
        this->name.clear();
        this->id = 0;
        this->mod = 0;
    }
};

//文件夹
class Folder : public File {
public:
    //NULL
public:
    Folder(string _name, int _id, int _mod = 744) : File(_name, _id, _mod) {
    }

    ~Folder() {
    }
};

//用户
class User : public Folder {
public:
    string password;//密码
public:
    User(string _name, int _id, string _password) : Folder(_name, _id), password(_password) {
    }

    ~User() {
        this->password.clear();
    }
};

//树节点
class Node {
public:
    string name;//节点所对应文件名称
    ull name_hash;//用户名hash值
    int id;//节点id
    int op;//文件所对应文件类别
public:
    Node(string _name, ull _name_hash, int _id, int _op) : name(_name), id(_id), op(_op), name_hash(_name_hash) {}

    ~Node() {
        this->name.clear();
        this->op = 0;
        this->id = 0;
        this->name_hash = 0;
    }
};

class FMS {
private:
    enum OPTION {
        NOTEXISTS, EXISTS, FULL, EMPTY, ERRORS, USER, FOLDER, FILE, PASSWORDERROR, PASS
    };
    vector<File *> file;//文件数组
    vector<Node *> node;//节点数组
    queue<int> q_id;//回收id存储
    vector<int> h, ver, ne, pre, fa;//前项星建图与father数组
    int fnid, idx;//通用文件与树节点id使用上限,当前id使用情况
    int root;//根节点
    int now;//当前位置
    string path;//当前位置的路径
    bool fopened;
    int fd;
    string cont_buf;
    ull p = 13331;
    OPTION NowState;
    ifstream ifs;//当前文件读
    ofstream ofs;//当前文件写
public:
    FMS(int file_len = 100000) : file(file_len, nullptr), node(file_len, nullptr), fnid(file_len), now(1), idx(1),
                                 root(1), h(file_len, 0), ver(file_len, 0), ne(file_len, 0), pre(file_len, 0),
                                 fa(file_len, 0), path("root") {
        _mkdir(path.c_str());
        node[now] = new Node("root", Hash("root"), root, FOLDER);
        file[now] = new Folder("root", root);
    }

    ~FMS() {
        // fakeDestructor();
    }

    void fakeDestructor(){
        for (int& i = h[root]; i; i = ne[i])
        {
            int j = ver[i];
            this->Delete(node[j]->name,"root",root);
        }
        this->fnid = 0;
        for (auto it: file) {
            if (it != nullptr)delete it;
        }
        for (auto it: node) {
            if (it != nullptr)delete it;
        }
        while (!this->q_id.empty())this->q_id.pop();}

    ull Hash(string str) {
        ull res = 0;
        for (char it: str) {
            res = res * this->p + it;
        }
        return res;
    }
    int Get_Now_State();
    void add(int u, int v) {
        int idx = v;
        ver[idx] = v, ne[idx] = h[u], pre[h[u]] = idx, fa[v] = u, h[u] = idx;
    }
    void sub(int u,int v)
    {
        h[u] = 0;
        if(h[fa[u]] == u)h[fa[u]] = ne[h[fa[u]]];
        ne[pre[v]] = ne[v];
        pre[ne[v]] = pre[v];
        fa[u] = 0;
    }
    int Register(string name, string password);//用户名 用户密码->信息(register)
    int Login(string name, string password);//用户名 用户密码->信息(login)
    int Create(string name, int op);//文件名 文件类型->信息(create,_mkdir)
    int Open(string name);//文件名->信息(open)
    int Close();//->信息(close)
    string Read();//->读取内容(read)
    int Delete(string name, string pa = "",int idd = -1);//文件名 文件类型 当前位置->信息(delete,remove)
    int Cd(string path);//路径->信息(cd)
    vector<string> Show();//->目录下文件名(dir,ls)
    int Write(string value);//写入内容->信息(write)
    int Change(string name, int mod);//文件名 权限->信息(change)
    string Search(string name);//文件名->文件目录(search)
    void noCh() {
        Write(cont_buf);
    }
    void dfs_delete(string path, int id, int idd);
};
