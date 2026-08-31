/*
 * UVa 11631 – Dark Roads (Implementation 2: Prim's Algorithm with Min-Heap)
 * Algorithm: Prim's MST with Binary Heap Priority Queue
 *
 * Complexity: O(E log V) time, O(V + E) space
 */

#include <bits/stdc++.h>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int m, n;
    while (cin >> m >> n && (m || n)) {
        long long totalCost = 0;
        vector<vector<pair<int, int>>> adj(m);

        for (int i = 0; i < n; i++) {
            int u, v;
            long long w;
            cin >> u >> v >> w;
            totalCost += w;
            adj[u].push_back({v, w});
            adj[v].push_back({u, w});
        }

        if (m == 0) {
            cout << 0 << "\n";
            continue;
        }

        vector<bool> visited(m, false);
        // Min-heap storing {edge_weight, vertex}
        priority_queue<pair<long long, int>, vector<pair<long long, int>>, greater<pair<long long, int>>> pq;

        long long mstCost = 0;
        int visitedCount = 0;

        pq.push({0, 0});

        while (!pq.empty() && visitedCount < m) {
            auto [w, u] = pq.top();
            pq.pop();

            if (visited[u]) continue;

            visited[u] = true;
            mstCost += w;
            visitedCount++;

            for (auto& [v, weight] : adj[u]) {
                if (!visited[v]) {
                    pq.push({weight, v});
                }
            }
        }

        cout << (totalCost - mstCost) << "\n";
    }

    return 0;
}
