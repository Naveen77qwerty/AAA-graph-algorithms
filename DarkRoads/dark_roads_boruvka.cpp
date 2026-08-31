/*
 * UVa 11631 – Dark Roads (Implementation 3: Borůvka's Algorithm)
 * Algorithm: Borůvka's MST (Component contraction)
 *
 * Complexity: O(E log V) time, O(V + E) space
 */

#include <bits/stdc++.h>
using namespace std;

struct Edge {
    int u, v;
    long long w;
};

struct DSU {
    vector<int> parent, rank_;
    DSU(int n) : parent(n), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }
    int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]);
        return parent[x];
    }
    bool unite(int a, int b) {
        a = find(a); b = find(b);
        if (a == b) return false;
        if (rank_[a] < rank_[b]) swap(a, b);
        parent[b] = a;
        if (rank_[a] == rank_[b]) rank_[a]++;
        return true;
    }
};

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int m, n;
    while (cin >> m >> n && (m || n)) {
        long long totalCost = 0;
        vector<Edge> edges(n);

        for (int i = 0; i < n; i++) {
            cin >> edges[i].u >> edges[i].v >> edges[i].w;
            totalCost += edges[i].w;
        }

        if (m <= 1) {
            cout << 0 << "\n";
            continue;
        }

        DSU dsu(m);
        int numTrees = m;
        long long mstCost = 0;
        vector<int> cheapest(m, -1);

        while (numTrees > 1) {
            fill(cheapest.begin(), cheapest.end(), -1);

            // Find cheapest outgoing edge for each component
            for (int i = 0; i < n; i++) {
                int set1 = dsu.find(edges[i].u);
                int set2 = dsu.find(edges[i].v);

                if (set1 == set2) continue;

                if (cheapest[set1] == -1 || edges[cheapest[set1]].w > edges[i].w) {
                    cheapest[set1] = i;
                }
                if (cheapest[set2] == -1 || edges[cheapest[set2]].w > edges[i].w) {
                    cheapest[set2] = i;
                }
            }

            int addedInThisRound = 0;
            for (int i = 0; i < m; i++) {
                if (cheapest[i] != -1) {
                    int set1 = dsu.find(edges[cheapest[i]].u);
                    int set2 = dsu.find(edges[cheapest[i]].v);

                    if (set1 != set2) {
                        dsu.unite(set1, set2);
                        mstCost += edges[cheapest[i]].w;
                        numTrees--;
                        addedInThisRound++;
                    }
                }
            }

            if (addedInThisRound == 0) break; // Disconnected graph safeguard
        }

        cout << (totalCost - mstCost) << "\n";
    }

    return 0;
}
