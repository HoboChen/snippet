#ifndef HOBO_HEADER_11
#define HOBO_HEADER_11

#include <iostream>
#include <sstream>
#include <fstream>

#include <string>
#include <queue>
#include <unordered_set>
#include <vector>
#include <bitset>

#include <algorithm>
#include <future>
#include <functional>
#include <random>

#include <cstring>
#include <cstdlib>
namespace hobo {

using namespace std;

// file_system_helper
vector<string> ReadFile(const string & fileName) noexcept {
    vector<string> ret;
    ifstream t;
    t.open(fileName);
    if (t.is_open()) {
        string x;
        getline(t, x);
        while (t.good()) {
            ret.push_back(x);
            getline(t, x);
        }
    }
    t.close();
    return ret;
}

int WriteFile(const vector<string> & s, const string & fileName) {
    ofstream t;
    t.open(fileName);
    if (t.is_open()) {
        for (auto x : s) {
            t << x << endl;
        }
    }
    t.close();
    return 0; // todo
}

// random_helper
// n <= r - l + 1
vector<int> PickNInLR(int n, int l, int r) {
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dis(l, r);
    unordered_set<int> tmp;
    while (tmp.size() < n) {
        tmp.insert(dis(gen));
    }
    vector<int> ret(tmp.begin(), tmp.end());
    return ret;
}

// ----- for test -----
/* template<typename T> */
/* std::ostream& print(std::ostream &out, T const &val) { */
/*       return (out << val << " "); */
/* } */

/* template<typename T1, typename T2> */
/* std::ostream& print(std::ostream &out, std::pair<T1, T2> const &val) { */
/*       return (out << "{" << val.first << " " << val.second << "} "); */
/* } */

/* template<template<typename, typename...> class TT, typename... Args> */
/* std::ostream& operator<<(std::ostream &out, TT<Args...> const &cont) { */
/*       for(auto&& elem : cont) print(out, elem); */
/*         return out; */
/* } */
// ----- end test -----

//debug_helper
template<typename _t>
void AtomicContainerPrint(const _t x) {
    cout << x;
}

template<typename _t1, typename _t2>
void AtomicContainerPrint(const pair<_t1, _t2> x) {
    cout << "(" << x.first << "," << x.second << ")";
}

template<typename _t>
void ContainerPrint(const _t & x, string deli = " ",
                    bool printSize = 1, bool printNextLine = 1 ) {
    int cnt = 0;
    for (auto & t : x) {
        if (!cnt++) { AtomicContainerPrint(t); }
        else { cout << deli; AtomicContainerPrint(t); }
    }
    if (printSize) cout << " | size = " << cnt ;
    if (printNextLine) cout << endl;
}

// string_helper

string StringTrim(const string& src) {
    auto size = src.size();
    int l, r, i;
    for (i = 0; i < size; i++) {
        if (src[i] == ' ') continue;
        else break;
    }
    l = i;
    for (i = size - 1; i > 0; i--) {
        if (src[i] == ' ') continue;
        else break;
    }
    r = i;
    return src.substr(l, r - l + 1);
}

template<typename _t>
inline _t StringToInt(string src) {
    _t x = 0;
    for (int i = 0; i < src.size(); i++) {
        x *= 10;
        x += src[i] - '0';
    }
    return x;
}

template<typename _t>
inline _t StringToInt(char * s) {
    _t x = 0;
    for (int i = 0; s[i] >= '0' && s[i] <= '9'; i++) {
        x *= 10;
        x += s[i] - '0';
    }
    return x;
}

template<typename _t>
_t StringToAnything(const string & x) {
    stringstream ss;
    ss << x;
    _t ret;
    ss >> ret;
    return ret;
}

template<typename _t>
string AnythingToString(const _t & x) {
    ostringstream t;
    t << x;
    return t.str();
}

pair<bitset<64>, bitset<64>> Int128ToPairBitset(const __int128 & x) {
    static_assert(sizeof(unsigned long long) == 8, "sizeof unsigned long long too small!");
    unsigned long long ff = 18446744073709551615ULL;
    bitset<64> bret1(x & ff), bret2((x >> 64) & ff);
    return make_pair(bret1, bret2);
}

vector<int> StringFind(const string & src, const string & pat) noexcept {
    vector<int> ret;
    if (pat.size() == 0 || src.size() == 0) return ret;
    int bpos = 0;
    while (1) {
        int t = src.find(pat, bpos);
        if (t == string::npos) break;
        ret.push_back(t);
        bpos = t + 1;
    }
    return ret;
}

vector<string> StringSplit(const string & src, const string & deli) {
    vector<int> deliPos = StringFind(src, deli);
    if (deliPos.size() == 0) {
        vector<string> t(1, src);
        return t;
    }
    deliPos.push_back(src.size());
    vector<string> ret;
    ret.push_back(src.substr(0, deliPos[0]));
    for (int i = 0; i < deliPos.size() - 1; i++) {
        ret.push_back(src.substr(deliPos[i] + 1, deliPos[i + 1] - 1 - deliPos[i]));
    }
    return ret;
}

string StringFillPrefix(const string & src, int len, char fillChar = ' ') {
    if (src.size() >= len) return src;
    string prefix(len - src.size(), fillChar);
    return prefix + src;
}

string StringFillSuffix(const string & src, int len, char fillChar = ' ') {
    if (src.size() >= len) return src;
    string suffix(len - src.size(), fillChar);
    return src + suffix;
}

inline bool IsUTF8CharBegin(char x) {
    return !((x & (1 << 7)) && !(x & (1 << 6)));
}

inline vector<string> StringSplitUTF8(const string & src) {
    vector<string> ret;
    for (int i = 0; i < src.size(); i++) {
        string t;
        if (IsUTF8CharBegin(src[i])) {
            t.push_back(src[i]);
            i++;
            while (!IsUTF8CharBegin(src[i])) {
                t.push_back(src[i]);
                i++;
            }
        }
        i--;
        ret.push_back(t);
    }
    return ret;
}

string GetFileNameWithoutExt(const string & src) {
    vector<int> pos = StringFind(src, ".");
    pos.insert(pos.begin(), src.size());
    return src.substr(0, pos[pos.size() - 1]);
}

string StringReplace(const string & src, const string & f, const string & t) {
    auto pos = StringFind(src, f);
    if (pos.size() == 0) return src;
    string ret;
    for (int i = 0; i < pos[0]; i++)
        ret.push_back(src[i]);
    for (int i = 0; i < t.size(); i++)
        ret.push_back(t[i]);
    for (int i = pos[0] + f.size(); i < src.size(); i++)
        ret.push_back(src[i]);
    return ret;
}

// a c++11 thread pool

class ThreadPool {
public:
    ThreadPool(size_t);
    template<class F, class... Args>
    auto enqueue(F&& f, Args&&... args)
        -> std::future<typename std::result_of<F(Args...)>::type>;
    ~ThreadPool();
private:
    // need to keep track of threads so we can join them
    std::vector< std::thread > workers;
    // the task queue
    std::queue< std::function<void()> > tasks;

    // synchronization
    std::mutex queue_mutex;
    std::condition_variable condition;
    bool stop;
};

// the constructor just launches some amount of workers
inline ThreadPool::ThreadPool(size_t threads)
    :   stop(false)
{
    for(size_t i = 0;i<threads;++i)
        workers.emplace_back(
            [this]
            {
                for(;;)
                {
                    std::function<void()> task;

                    {
                        std::unique_lock<std::mutex> lock(this->queue_mutex);
                        this->condition.wait(lock,
                            [this]{ return this->stop || !this->tasks.empty(); });
                        if(this->stop && this->tasks.empty())
                            return;
                        task = std::move(this->tasks.front());
                        this->tasks.pop();
                    }

                    task();
                }
            }
        );
}

// add new work item to the pool
template<class F, class... Args>
auto ThreadPool::enqueue(F&& f, Args&&... args)
    -> std::future<typename std::result_of<F(Args...)>::type>
{
    using return_type = typename std::result_of<F(Args...)>::type;

    auto task = std::make_shared< std::packaged_task<return_type()> >(
            std::bind(std::forward<F>(f), std::forward<Args>(args)...)
        );

    std::future<return_type> res = task->get_future();
    {
        std::unique_lock<std::mutex> lock(queue_mutex);

        // don't allow enqueueing after stopping the pool
        if(stop)
            throw std::runtime_error("enqueue on stopped ThreadPool");

        tasks.emplace([task](){ (*task)(); });
    }
    condition.notify_one();
    return res;
}

// the destructor joins all threads
inline ThreadPool::~ThreadPool()
{
    {
        std::unique_lock<std::mutex> lock(queue_mutex);
        stop = true;
    }
    condition.notify_all();
    for(std::thread &worker: workers)
        worker.join();
}

unsigned int GetCPUCores() {
    return std::thread::hardware_concurrency();
}

};

#endif
