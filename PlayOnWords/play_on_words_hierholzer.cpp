/*
 * UVa 10129 – Play on Words (Implementation 3: Hierholzer's Algorithm)
 * Algorithm: Hierholzer's Eulerian Trail Construction
 *
 * Complexity: O(N) per test case
 */

#include <bits/stdc++.h>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    int T;
    if (!(cin >> T)) return 0;

    while (T--) {
        int N;
        cin >> N;

        int indeg[26]  = {}, outdeg[26] = {};
        bool used[26]  = {};
        vector<int> adj[26];

        for (int i = 0; i < N; i++) {
            string w;
            cin >> w;
            int first = w.front() - 'a';
            int last  = w.back()  - 'a';
            outdeg[first]++;
            indeg[last]++;
            used[first] = used[last] = true;
            adj[first].push_back(last);
        }

        // --- Degree Check ---
        int startNodes = 0, endNodes = 0;
        bool degreesOK = true;
        int startVertex = -1;

        for (int i = 0; i < 26; i++) {
            if (!used[i]) continue;
            int diff = outdeg[i] - indeg[i];
            if (diff == 1) {
                startNodes++;
                startVertex = i;
            } else if (diff == -1) {
                endNodes++;
            } else if (diff != 0) {
                degreesOK = false;
                break;
            }
        }

        bool eulerianPath    = (startNodes == 1 && endNodes == 1);
        bool eulerianCircuit = (startNodes == 0 && endNodes == 0);

        if (!degreesOK || !(eulerianPath || eulerianCircuit)) {
            cout << "The door cannot be opened.\n";
            continue;
        }

        // If Eulerian circuit, pick any active vertex with outdeg > 0
        if (startVertex == -1) {
            for (int i = 0; i < 26; i++) {
                if (used[i] && outdeg[i] > 0) {
                    startVertex = i;
                    break;
                }
            }
        }

        // --- Hierholzer's Algorithm ---
        vector<int> path;
        stack<int> currStack;
        if (startVertex != -1) {
            currStack.push(startVertex);
        }

        while (!currStack.empty()) {
            int u = currStack.top();
            if (!adj[u].empty()) {
                int v = adj[u].back();
                adj[u].pop_back();
                currStack.push(v);
            } else {
                path.push_back(u);
                currStack.pop();
            }
        }

        // Check if all N edges were traversed in the Eulerian trail
        int edgesTraversed = (int)path.size() - 1;
        if (edgesTraversed == N) {
            cout << "Ordering is possible.\n";
        } else {
            cout << "The door cannot be opened.\n";
        }
    }

    return 0;
}
