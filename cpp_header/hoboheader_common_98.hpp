#include <bits/stdc++.h>

#ifndef pr
#define pr(x) cout << #x << " = " << x << " % ";
#endif
#ifndef pn
#define pn cout << endl;
#endif
namespace hobo {

using namespace std;

vector<string> ReadFile(const string & fileName) {
    vector<string> ret;
    ifstream t;
    t.open(fileName.c_str());
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

int WriteFile(vector<string> & s, const string & fileName) {
    ofstream t;
    t.open(fileName.c_str());
    if (t.is_open()) {
        for (vector<string>::iterator it = s.begin(); it != s.end(); it++) {
            t << *it << endl;
        }
    }
    t.close();
    return 0; // todo
}

/* template<typename _t> */
/* void ContainerPrint(_t & x, string deli = " ", bool printSize = 1, bool printNextLine = 1) { */
/*     int cnt = 0; */
/*     _t::iterator it; */
/*     for (it = x.begin(); it != x.end(); it++) { */
/*          if (!cnt++) cout << *it; */ 
/*         else cout << deli << *it; */
/*     } */
/*     if (printSize) cout << " | size = " << cnt ; */
/*     if (printNextLine) cout << endl; */
/* } */

template<typename _t>
string AnythingToString(const _t & x) {
    ostringstream t;
    t << x;
    return t.str();
}

vector<int> StringFind(const string & src, const string & pat) {
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

bool IsUTF8CharBegin(char x) {
    return !((x & (1 << 7)) && !(x & (1 << 6)));
}

vector<string> StringSplitUTF8(const string & src) {
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

};

