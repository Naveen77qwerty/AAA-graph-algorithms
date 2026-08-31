/*
 * UVa 11906 – Knight in a War Grid (Implementation 3: DSU Grid Connectivity)
 * Algorithm: Disjoint Set Union (DSU) component merging for grid reachability
 *
 * Complexity: O(R·C·8·α(R·C)) per test case
 */

#include <bits/stdc++.h>
using namespace std;

struct DSU {
    vector<int> parent, rank_;
    DSU(int n) : parent(n), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0);
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

vector<pair<int,int>> getDeltas(int M, int N) {
    set<pair<int,int>> s;
    for (int sm : {-1, 1})
        for (int sn : {-1, 1}) {
            s.insert({sm * M, sn * N});
            s.insert({sm * N, sn * M});
        }
    return {s.begin(), s.end()};
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int T;
    if (!(cin >> T)) return 0;

    for (int caseNum = 1; caseNum <= T; caseNum++) {
        int R, C, M, N;
        cin >> R >> C >> M >> N;

        vector<vector<bool>> water(R, vector<bool>(C, false));
        int W;
        cin >> W;
        for (int i = 0; i < W; i++) {
            int x, y;
            cin >> x >> y;
            water[x][y] = true;
        }

        auto deltas = getDeltas(M, N);
        DSU dsu(R * C);

        // Connect valid knight moves in DSU
        for (int r = 0; r < R; r++) {
            for (int c = 0; c < C; c++) {
                if (water[r][c]) continue;
                int id1 = r * C + c;
                for (auto [dr, dc] : deltas) {
                    int nr = r + dr, nc = c + dc;
                    if (nr >= 0 && nr < R && nc >= 0 && nc < C && !water[nr][nc]) {
                        int id2 = nr * C + nc;
                        dsu.unite(id1, id2);
                    }
                }
            }
        }

        int evenCount = 0, oddCount = 0;
        if (!water[0][0]) {
            int startRoot = dsu.find(0);

            for (int r = 0; r < R; r++) {
                for (int c = 0; c < C; c++) {
                    if (water[r][c]) continue;
                    int id = r * C + c;
                    if (dsu.find(id) != startRoot) continue; // Cell is not reachable from (0,0)

                    int neighborCount = 0;
                    for (auto [dr, dc] : deltas) {
                        int nr = r + dr, nc = c + dc;
                        if (nr >= 0 && nr < R && nc >= 0 && nc < C && !water[nr][nc]) {
                            int nid = nr * C + nc;
                            if (dsu.find(nid) == startRoot) {
                                neighborCount++;
                            }
                        }
                    }

                    if (neighborCount % 2 == 0) evenCount++;
                    else                        oddCount++;
                }
            }
        }

        cout << "Case " << caseNum << ": " << evenCount << " " << oddCount << "\n";
    }

    return 0;
}
