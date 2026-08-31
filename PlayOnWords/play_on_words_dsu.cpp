/*
 * UVa 10129 – Play on Words
 * Algorithm: Eulerian Path existence check via In/Out-degree + DSU connectivity
 *
 * Problem:
 *   Given N words, determine if they can be arranged in a sequence such that
 *   the last letter of each word matches the first letter of the next word.
 *
 * Graph model:
 *   - 26 nodes (letters a-z)
 *   - Each word "abc" becomes a directed edge: 'a' → 'c'
 *   - Answer: Does this directed graph have an Eulerian path/circuit?
 *
 * Eulerian path conditions (directed graph):
 *   1. All vertices with non-zero degree are in one connected component
 *      (check using DSU on the undirected version)
 *   2a. Eulerian circuit: every vertex has in_degree == out_degree
 *   2b. Eulerian path:    exactly one vertex with out-in=+1 (start),
 *                         exactly one vertex with in-out=+1 (end),
 *                         all others equal
 *
 * Complexity: O(N) per test case (N = number of words)
 */

#include <bits/stdc++.h>
using namespace std;

// ----- Union-Find (DSU) for 26 letters -----
struct DSU {
    int parent[26], rank_[26];
    void init() {
        iota(parent, parent + 26, 0);
        fill(rank_, rank_ + 26, 0);
    }
    int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]);
        return parent[x];
    }
    void unite(int a, int b) {
        a = find(a); b = find(b);
        if (a == b) return;
        if (rank_[a] < rank_[b]) swap(a, b);
        parent[b] = a;
        if (rank_[a] == rank_[b]) rank_[a]++;
    }
};

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int T;
    cin >> T;

    DSU dsu;

    while (T--) {
        int N;
        cin >> N;

        int indeg[26]  = {}, outdeg[26] = {};
        bool used[26]  = {};
        dsu.init();

        for (int i = 0; i < N; i++) {
            string w;
            cin >> w;
            int first = w.front() - 'a';
            int last  = w.back()  - 'a';
            outdeg[first]++;
            indeg[last]++;
            used[first] = used[last] = true;
            dsu.unite(first, last);
        }

        // --- Connectivity check ---
        // All used letters must share one DSU root
        int root = -1;
        bool connected = true;
        for (int i = 0; i < 26; i++) {
            if (!used[i]) continue;
            int r = dsu.find(i);
            if (root == -1) root = r;
            else if (r != root) { connected = false; break; }
        }

        // --- Degree check ---
        // Count vertices with imbalanced degrees
        int startNodes = 0, endNodes = 0;
        bool degreesOK = true;
        for (int i = 0; i < 26; i++) {
            if (!used[i]) continue;
            int diff = outdeg[i] - indeg[i];
            if (diff == 1)       startNodes++;
            else if (diff == -1) endNodes++;
            else if (diff != 0)  { degreesOK = false; break; }
        }

        bool eulerianPath    = (startNodes == 1 && endNodes == 1);
        bool eulerianCircuit = (startNodes == 0 && endNodes == 0);

        if (connected && degreesOK && (eulerianPath || eulerianCircuit)) {
            cout << "Ordering is possible.\n";
        } else {
            cout << "The door cannot be opened.\n";
        }
    }

    return 0;
}
