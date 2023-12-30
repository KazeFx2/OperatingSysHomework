#include<string>
#include<vector>
#include<queue>
#include<unordered_map>
using namespace std;
#define ull unsigned long long
class Primary
{
    //NULL
};

//用户
class User : public Primary
{
public:
    string name;//用户名
    int id;//用户ID
    string password;//密码
public:
    User(string _name,int _id,string _password):name(_name),id(_id),password(_password)
    {
    }
    ~User()
    {
        this->name.clear();
        this->password.clear();
        this->id = 0;
    }
};
//文件夹
class Folder :public Primary
{
public:
    string name;//文件夹名
    int id;//文件夹id
    int mod;//用户权限
public:
    Folder(string _name,int _id,int _mod = 744):name(_name),id(_id),mod(_mod)
    {
    }
    ~Folder()
    {
        this->name.clear();
        this->id = 0;
        this->mod = 0;
    }
};
//文件
class File : public Primary
{
public:
    string name;//文件名称
    int id;//文件ID
    int mod;//用户权限
public:
    File(string _name,int _id,int _mod = 744):name(_name),id(_id),mod(_mod)
    {
    }
    ~File()
    {
        this->name.clear();
        this->id = 0;
        this->mod = 0;
    }
};

//树节点
class Node
{
public:
    string name;//节点所对应文件名称
    ull name_hash;//用户名hash值
    int id;//节点id
    int op;//文件所对应文件类别（0：用户，1：文件，2：目录）
public:
    Node(string _name, ull _name_hash,int _id, int _op) :name(_name), id(_id), op(_op), name_hash(_name_hash)
    {}
    ~Node()
    {
        this->name.clear();
        this->op = 0;
        this->id = 0;
        this->name_hash = 0;
    }
};

class FMS
{
private:
    vector<Primary*> file;//文件数组
    vector<Node*> node;//节点数组
    queue<int> q_id;//回收id存储
    vector<int> h, ver, ne,pre, fa;//前项星建图与father数组
    int fnid,idx;//通用文件与树节点id使用上限,当前id使用情况
    int now;//当前位置
    ull p = 13331;
public:
    FMS(int file_len = 100000):file(file_len,nullptr),node(file_len,nullptr),fnid(file_len),now(0),idx(0), h(file_len,0), ver(file_len, 0), ne(file_len, 0), pre(file_len, 0), fa(file_len, 0)
    {

    }
    ~FMS()
    {
        this->fnid = 0;
        for (auto it : file)
        {
            if (it != nullptr)delete it;
        }
        for (auto it : node)
        {
            if (it != nullptr)delete it;
        }
        while (!this->q_id.empty())this->q_id.pop();
    }
    ull Hash(string str)
    {
        ull res = 0;
        for (char it : str)
        {
            res = res * this->p + it;
        }
        return res;
    }
    void add(int u, int v)
    {
        ver[++idx] = v, ne[idx] = h[u], pre[h[u]] = idx, fa[v] = u, h[u] = idx;
    }
    int Register(string name,string password);//用户名 用户密码->信息(register)
    int Login(string name, string password);//用户名 用户密码->信息(login)
    int Create(string name,int op);//文件名 文件类型->信息(create,mkdir)
    int Open(string name);//文件名->信息(open)
    int Close();//->信息(close)
    string Read();//->读取内容(read)
    int Delete(string name,int op);//文件名 文件类型->信息(delete,remove)
    int Cd(string path);//路径->信息(cd)
    vector<string> Show();//->目录下文件名(dir,ls)
    int Write(string value);//写入内容->信息(write)
    int Change(string name, int mod);//文件名 权限->信息(change)
    string Search(string name);//文件名->文件目录(search)
};