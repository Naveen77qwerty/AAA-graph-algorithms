/*
 * UVa 11631 – Dark Roads
 * Algorithm: Kruskal's MST with Union-Find (DSU)
 *
 * Problem:
 *   Given m junctions and n roads (weighted edges), every road costs its
 *   weight per day to illuminate. Find the maximum savings by turning off
 *   lights on roads not needed for connectivity.
 *
 *   Answer = sum(all edge weights) − MST weight
 *
 * Complexity: O(n log n) time, O(n) space
 * Constraints: m, n ≤ 200,000
 */

#include <bits/stdc++.h>
using namespace std;

// ----- Union-Find (DSU) -----
struct DSU {
    vector<int> parent, rank_;
    DSU(int n) : parent(n), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }
    int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]); // path compression
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
        vector<tuple<long long, int, int>> edges(n);

        for (auto& [w, u, v] : edges) {
            cin >> u >> v >> w;
            totalCost += w;
        }

        // Sort edges by weight ascending (Kruskal)
        sort(edges.begin(), edges.end());

        DSU dsu(m);
        long long mstCost = 0;

        for (auto& [w, u, v] : edges) {
            if (dsu.unite(u, v)) {
                mstCost += w;
            }
        }

        cout << (totalCost - mstCost) << "\n";
    }

    return 0;
}
