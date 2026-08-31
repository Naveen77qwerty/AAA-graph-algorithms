# AAA Graph Algorithms — Lab Eval-2

**Course:** Advanced Algorithms & Analysis (23CSE440)  
**Evaluation:** Lab Eval-2  
**Team:** Team-7

---

## Overview

This repository contains 9 total C++ algorithm implementations across three UVa Online Judge problems (3 distinct algorithm paradigms per problem), providing a comprehensive comparative case study of time/space complexity, data structure efficiency, and benchmark performance trade-offs.

---

## Notation Legend

Before reviewing the complexity matrix, here is the definition of mathematical terms and variables used:

* **V**: Number of vertices (junctions) in the graph ($V \le 200,000$).
* **E**: Number of edges (weighted roads) in the graph ($E \le 200,000$).
* **R**: Number of grid rows ($R \le 100$).
* **C**: Number of grid columns ($C \le 100$).
* **N**: Number of word strings ($N \le 100,000$).
* **α(X)**: Inverse Ackermann Function ($\alpha(X) \le 4$ for all physical inputs, practically $O(1)$ amortized cost per Disjoint Set Union operation).

---

## Comprehensive Implementation & Complexity Matrix

Below is a detailed master table comparing the Time Complexity, Space Complexity, Data Structures Used, and Algorithmic Characteristics across all 9 implementations:

| Problem & UVa ID | Implementation Paradigm | Time Complexity | Auxiliary Space | Key Data Structures Used | Implementation Characteristics & Benchmark Performance |
|------------------|-------------------------|-----------------|-----------------|---------------------------|--------------------------------------------------|
| **Dark Roads**<br>*(UVa 11631)* | **Impl 1: Kruskal's MST** | $O(E \log E + E \cdot \alpha(V))$ | $O(V + E)$ | Edge List Vector (`std::vector<Edge>`), Disjoint Set Union (DSU with Path Compression & Rank) | Global edge sorting upfront. Excellent on sparse graphs ($E \approx V$). |
| | **Impl 2: Prim's MST** | $O(E \log V)$ | $O(V + E)$ | Adjacency List (`vector<vector<pair<int,int>>>`), Binary Min-Heap (`std::priority_queue`), Visited Vector | Dynamic vertex-by-vertex MST growth. Faster than Kruskal on dense graphs ($E \gg V$). |
| | **Impl 3: Borůvka's MST** | $O(E \log V)$ | $O(V + E)$ | Edge List Vector, DSU, Cheapest Outgoing Edge Array (`vector<int>`) | **Benchmark Winner (18.06 ms)**. Zero edge sorting and zero priority heaps; contracts components in $\log V$ scanning rounds. |
| **Knight in a War Grid**<br>*(UVa 11906)* | **Impl 1: Queue BFS** | $O(R \cdot C \cdot 8)$ | $O(R \cdot C)$ | FIFO Queue (`std::queue<pair<int,int>>`), 2D Visited & Water Arrays (`bool[105][105]`), Move Vector | **Benchmark Winner (6.55 ms)**. Level-by-level wave exploration; optimal memory layout without call stack overflow risk. |
| | **Impl 2: Stack DFS** | $O(R \cdot C \cdot 8)$ | $O(R \cdot C)$ | Call Stack / Recursive Functions, 2D Visited & Water Arrays | Deep path exploration before backtracking; simple recursive structure. |
| | **Impl 3: Grid DSU** | $O(R \cdot C \cdot 8 \cdot \alpha(RC))$ | $O(R \cdot C)$ | 2D-to-1D Grid DSU Mapping `(r * C + c)`, DSU Parent & Rank Arrays | Zero graph traversals (no queues or call stacks); unifies valid land cells into disjoint sets dynamically. |
| **Play on Words**<br>*(UVa 10129)* | **Impl 1: DSU + Degree Check** | $O(N + 26 \cdot \alpha(26)) = O(N)$ | $O(1)$ | 26-element DSU (`parent[26]`, `rank_[26]`), In/Out Degree Arrays (`indeg[26]`, `outdeg[26]`) | Direct decision check; ultra-compact $O(1)$ constant auxiliary memory footprint. |
| | **Impl 2: DFS Graph** | $O(N + 26)$ | $O(1)$ | 26-node Undirected Adjacency List (`vector<int> adj[26]`), Visited Array (`bool visited[26]`), Degree Arrays | **Benchmark Winner (10.73 ms)**. Graph traversal from first active vertex to confirm component connectivity. |
| | **Impl 3: Hierholzer's** | $O(N)$ | $O(N)$ | Directed Adjacency List (`vector<int> adj[26]`), Trail Stack (`std::stack<int>`), Circuit Vector | **Constructive Trail Generation**. Unlike Impl 1 & 2 which return Yes/No, Hierholzer's traces the exact sequence of all $N$ word edges. |

---

## Interactive Graph Visualizer (`index.html`)

An interactive, high-definition web visualizer is included in the repository root to demonstrate all 3 graph algorithms step-by-step for academic presentations.

### Features
* **Full Light Theme & Full-Screen Canvas**: High-DPI canvas scaling (`window.devicePixelRatio`) with spacious node layouts and crisp vector edge rendering.
* **Best Algo Integration**: Automatically highlights and executes the empirically proven Benchmark Winner algorithm for each problem.
* **Dark Roads Tab**: Visualizes Kruskal's / Borůvka's MST, edge sorting, DSU component merging, edge acceptance/rejection, and cost savings.
* **Knight in War Grid Tab**: Grid representation animating BFS expansion from $(0,0)$, knight jump deltas $(\pm M, \pm N)$, water obstacles, and reachable neighbor parity highlights.
* **Play on Words Tab**: Directed letter graph visualization with quadratic Bezier curved edges (`quadraticCurveTo`), DSU/DFS component verification, degree counts, and Eulerian path detection.
* **Playback & Custom Inputs**: Play/Pause, Step Back/Forward, Speed Slider, preset input selectors, and an interactive Custom Input modal.

### How to Run Visualizer
Simply open [index.html](file:///home/leomarshall/aaa/index.html) directly in any web browser, or launch a local server:
```bash
python3 -m http.server 8080
# Open http://localhost:8080/index.html
```

---

## Repository Structure

```
AAA-graph-algorithms/
├── index.html, index.css, visualizer.js  # Interactive Visualizer Web App
├── generate_large_inputs.py              # Large Dataset Generator
├── DarkRoads/
│   ├── dark_roads_kruskal.cpp   # Impl 1: Kruskal's MST (DSU)
│   ├── dark_roads_prim.cpp      # Impl 2: Prim's MST (Min-Heap)
│   ├── dark_roads_boruvka.cpp   # Impl 3: Borůvka's MST
│   ├── input1.txt - input6.txt
│   └── expected1.txt - expected6.txt
├── KnightInWar/
│   ├── knight_in_war_bfs.cpp    # Impl 1: Queue BFS
│   ├── knight_in_war_dfs.cpp    # Impl 2: Stack/Recursive DFS
│   ├── knight_in_war_dsu.cpp    # Impl 3: Grid DSU Reachability
│   ├── input1.txt - input6.txt
│   └── expected1.txt - expected6.txt
├── PlayOnWords/
│   ├── play_on_words_dsu.cpp        # Impl 1: DSU + Degree Balance Check
│   ├── play_on_words_dfs.cpp        # Impl 2: DFS Component Traversal
│   ├── play_on_words_hierholzer.cpp # Impl 3: Hierholzer's Trail Construction
│   ├── input1.txt - input6.txt
│   └── expected1.txt - expected6.txt
└── Makefile
```

---

## Build, Test, and Comparative Benchmark

All commands are run from the repository root (`AAA-graph-algorithms/`).

**Build all 9 binaries:**
```bash
make build
```

**Run the comprehensive test suite (54 tests: 9 algorithms × 6 test cases):**
```bash
make test
```

**Run the comparative algorithm benchmark table:**
```bash
make benchmark
```

---

## Test Cases Summary (6 per problem)

| Test | Description |
|------|-------------|
| input1.txt | Official sample test case |
| input2.txt | Edge case (single node / equal M and N / single word) |
| input3.txt | Multi-component / degree-imbalanced / zero offset cases |
| input4.txt | Dense graph (10 nodes 15 edges / 10x10 grid / 8 words Eulerian circuit) |
| input5.txt | Cyclic graph (8 nodes 12 edges / 12x12 grid / 7 words disconnected) |
| **input6.txt** | **Large Dataset (10,000 nodes 50,000 edges / 100x100 grid / 100,000 words)** |

All 54 test runs are validated by `make test` and `make benchmark`.
