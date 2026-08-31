/*
 * UVa 10129 – Play on Words (Implementation 2: DFS Component Connectivity)
 * Algorithm: DFS Traversal for Component Check + In/Out Degree Validation
 *
 * Complexity: O(N + 26) per test case
 */

#include <bits/stdc++.h>
using namespace std;

vector<int> adj[26];
bool visited[26];
bool used[26];

void dfs(int u) {
    visited[u] = true;
    for (int v : adj[u]) {
        if (!visited[v]) {
            dfs(v);
        }
    }
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int T;
    if (!(cin >> T)) return 0;

    while (T--) {
        int N;
        cin >> N;

        int indeg[26]  = {}, outdeg[26] = {};
        memset(used,    false, sizeof(used));
        memset(visited, false, sizeof(visited));
        for (int i = 0; i < 26; i++) adj[i].clear();

        for (int i = 0; i < N; i++) {
            string w;
            cin >> w;
            int first = w.front() - 'a';
            int last  = w.back()  - 'a';
            outdeg[first]++;
            indeg[last]++;
            used[first] = used[last] = true;

            // Build undirected edge for connectivity check
            adj[first].push_back(last);
            adj[last].push_back(first);
        }

        // --- Connectivity Check via DFS ---
        int startLetter = -1;
        for (int i = 0; i < 26; i++) {
            if (used[i]) {
                startLetter = i;
                break;
            }
        }

        bool connected = true;
        if (startLetter != -1) {
            dfs(startLetter);
            for (int i = 0; i < 26; i++) {
                if (used[i] && !visited[i]) {
                    connected = false;
                    break;
                }
            }
        }

        // --- Degree Check ---
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
