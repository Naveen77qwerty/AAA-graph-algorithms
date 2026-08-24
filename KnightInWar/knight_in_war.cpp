/*
 * UVa 11906 – Knight in a War Grid
 * Algorithm: BFS from (0,0) + neighbor counting with duplicate-move deduplication
 *
 * Problem:
 *   On an R×C grid with water cells, a knight moves (±M, ±N) or (±N, ±M).
 *   Starting at (0,0), find all reachable land cells.
 *   For each reachable cell, count its distinct valid reachable neighbors.
 *   Output: #reachable cells with even neighbor-count, #with odd neighbor-count.
 *
 * Key insight: When M==N, M==0, or N==0, the 8 candidate move-deltas collapse
 *   into fewer unique moves. Use a set to deduplicate.
 *
 * Complexity: O(R·C·8) per test case
 * Constraints: R,C ≤ 100, M,N ≤ 50, T ≤ 50
 */

#include <bits/stdc++.h>
using namespace std;

int R, C, M, N;
bool water[105][105];
bool visited[105][105];

// Generate unique knight-move deltas for current (M, N)
vector<pair<int,int>> getDeltas() {
    set<pair<int,int>> s;
    // All 8 combinations of (±M, ±N) and (±N, ±M)
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
    cin >> T;

    for (int caseNum = 1; caseNum <= T; caseNum++) {
        cin >> R >> C >> M >> N;

        // Reset grids
        memset(water,   false, sizeof(water));
        memset(visited, false, sizeof(visited));

        int W;
        cin >> W;
        for (int i = 0; i < W; i++) {
            int x, y;
            cin >> x >> y;
            water[x][y] = true;
        }

        // Pre-compute unique move deltas
        auto deltas = getDeltas();

        // BFS from (0,0)
        queue<pair<int,int>> bfsQ;
        if (!water[0][0]) {
            visited[0][0] = true;
            bfsQ.push({0, 0});
        }

        vector<pair<int,int>> reachable;
        while (!bfsQ.empty()) {
            auto [r, c] = bfsQ.front();
            bfsQ.pop();
            reachable.push_back({r, c});

            for (auto [dr, dc] : deltas) {
                int nr = r + dr, nc = c + dc;
                if (nr >= 0 && nr < R && nc >= 0 && nc < C
                    && !water[nr][nc] && !visited[nr][nc]) {
                    visited[nr][nc] = true;
                    bfsQ.push({nr, nc});
                }
            }
        }

        // For each reachable cell, count distinct reachable neighbors
        int evenCount = 0, oddCount = 0;
        for (auto [r, c] : reachable) {
            int neighborCount = 0;
            for (auto [dr, dc] : deltas) {
                int nr = r + dr, nc = c + dc;
                if (nr >= 0 && nr < R && nc >= 0 && nc < C
                    && !water[nr][nc] && visited[nr][nc]) {
                    neighborCount++;
                }
            }
            if (neighborCount % 2 == 0) evenCount++;
            else                        oddCount++;
        }

        cout << "Case " << caseNum << ": " << evenCount << " " << oddCount << "\n";
    }

    return 0;
}
