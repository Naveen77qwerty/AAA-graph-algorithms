/*
 * UVa 11906 – Knight in a War Grid (Implementation 2: Depth-First Search)
 * Algorithm: Recursive DFS from (0,0) + neighbor counting with move deduplication
 *
 * Complexity: O(R·C·8) per test case
 */

#include <bits/stdc++.h>
using namespace std;

int R, C, M, N;
bool water[105][105];
bool visited[105][105];
vector<pair<int,int>> deltas;
vector<pair<int,int>> reachable;

vector<pair<int,int>> getDeltas() {
    set<pair<int,int>> s;
    for (int sm : {-1, 1})
        for (int sn : {-1, 1}) {
            s.insert({sm * M, sn * N});
            s.insert({sm * N, sn * M});
        }
    return {s.begin(), s.end()};
}

void dfs(int r, int c) {
    visited[r][c] = true;
    reachable.push_back({r, c});

    for (auto [dr, dc] : deltas) {
        int nr = r + dr, nc = c + dc;
        if (nr >= 0 && nr < R && nc >= 0 && nc < C
            && !water[nr][nc] && !visited[nr][nc]) {
            dfs(nr, nc);
        }
    }
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int T;
    if (!(cin >> T)) return 0;

    for (int caseNum = 1; caseNum <= T; caseNum++) {
        cin >> R >> C >> M >> N;

        memset(water,   false, sizeof(water));
        memset(visited, false, sizeof(visited));
        reachable.clear();

        int W;
        cin >> W;
        for (int i = 0; i < W; i++) {
            int x, y;
            cin >> x >> y;
            water[x][y] = true;
        }

        deltas = getDeltas();

        if (!water[0][0]) {
            dfs(0, 0);
        }

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
