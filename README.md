# AAA Graph Algorithms — Lab Eval-2

**Course:** Advanced Algorithms & Analysis (23CSE440)  
**Evaluation:** Lab Eval-2  
**Team:** Team-7

---

## Overview

This repository contains **9 total C++ algorithm implementations** across three UVa Online Judge problems (3 distinct algorithm paradigms per problem), providing a comprehensive comparative case study of time/space complexity, data structure efficiency, and benchmark performance trade-offs.

| Problem | UVa ID | Impl 1 (Primary) | Impl 2 (Alternative) | Impl 3 (Alternative) |
|---------|--------|------------------|----------------------|----------------------|
| **Dark Roads** | 11631 | Kruskal's MST (DSU) | Prim's MST (Min-Heap) | Borůvka's MST (Component Contraction) |
| **Knight in a War Grid** | 11906 | Queue BFS | Recursive / Stack DFS | DSU Grid Connectivity |
| **Play on Words** | 10129 | DSU + Degree Check | DFS Graph Traversal | Hierholzer's Trail Construction |

---

## 🎨 Interactive Graph Visualizer (`index.html`)

An interactive, high-definition web visualizer is included in the repository root to demonstrate all 3 graph algorithms step-by-step for academic presentations.

### Features
* **Full Light Theme & Full-Screen Canvas**: High-DPI canvas scaling (`window.devicePixelRatio`) with spacious node layouts and crisp vector edge rendering.
* **Dark Roads Tab**: Visualizes Kruskal's MST, edge sorting, DSU component merging, edge acceptance/rejection (cycle detection), and cost savings calculations.
* **Knight in War Grid Tab**: Grid representation animating BFS expansion from $(0,0)$, knight jump deltas $(\pm M, \pm N)$, water obstacles, and reachable neighbor parity highlights (even vs. odd).
* **Play on Words Tab**: Directed letter graph visualization with quadratic Bezier curved edges (`quadraticCurveTo`), DSU component verification, in/out-degree counts, and Eulerian path detection.
* **Playback & Custom Inputs**: Play/Pause, Step Back/Forward, Speed Slider, preset input selectors, and an interactive **`✏️ Custom Input`** modal.

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

## Algorithms Breakdown (3 per problem)

### 1. Dark Roads (UVa 11631)
* **Impl 1 (Kruskal's MST)**: $O(E \log E)$ time, $O(V + E)$ space. Sorts edge weights globally using DSU with path compression and rank optimization.
* **Impl 2 (Prim's MST with Min-Heap)**: $O(E \log V)$ time, $O(V + E)$ space. Grows tree vertex-by-vertex using `std::priority_queue`.
* **Impl 3 (Borůvka's MST)**: $O(E \log V)$ time, $O(V + E)$ space. Repeatedly connects minimum outgoing edges across components in logarithmic contracting rounds.

---

### 2. Knight in a War Grid (UVa 11906)
* **Impl 1 (Queue BFS)**: $O(R \cdot C \cdot 8)$ time, $O(R \cdot C)$ space. Level-by-level queue traversal guaranteeing optimal memory layout.
* **Impl 2 (Recursive DFS)**: $O(R \cdot C \cdot 8)$ time, $O(R \cdot C)$ space. Call stack traversal exploring paths deeply.
* **Impl 3 (Grid DSU Reachability)**: $O(R \cdot C \cdot 8 \cdot \alpha(RC))$ time. Unifies adjacent valid land cells into DSU components to check reachability from $(0,0)$.

---

### 3. Play on Words (UVa 10129)
* **Impl 1 (DSU + Degree Check)**: $O(N)$ time, $O(1)$ space. Evaluates graph connectivity via 26-node DSU and verifies Eulerian degree balance arrays.
* **Impl 2 (DFS Component Check)**: $O(N)$ time, $O(1)$ space. Performs graph traversal from the first active vertex to confirm component connectivity.
* **Impl 3 (Hierholzer's Algorithm)**: $O(N)$ time, $O(N)$ space. Hierholzer's trail construction validating that all $N$ edges are traversed in a continuous Eulerian trail.

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
