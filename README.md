# AAA Graph Algorithms — Lab Eval-2

**Course:** Advanced Algorithms & Analysis (23CSE440)  
**Evaluation:** Lab Eval-2  
**Team:** Team-7

---

## Overview

This repository contains 9 total C++ algorithm implementations across three UVa Online Judge problems (3 distinct algorithm paradigms per problem), providing a comprehensive comparative case study of time/space complexity, data structure efficiency, and benchmark performance trade-offs.

---

## Notation Legend

Before reviewing the complexity matrix, here is the definition of terms used:

* **V**: Number of vertices (junctions) in the graph ($V \le 200,000$).
* **E**: Number of edges (weighted roads) in the graph ($E \le 200,000$).
* **R**: Number of grid rows ($R \le 100$).
* **C**: Number of grid columns ($C \le 100$).
* **N**: Number of word strings ($N \le 100,000$).

---

## Comprehensive Implementation & Complexity Matrix

Below are the detailed tables comparing the Time Complexity, Auxiliary Space Complexity, Data Structures Used, and Algorithmic Characteristics for each problem's implementations:

### 1. Dark Roads (UVa 11631) — MST Complexity Matrix

| Implementation Paradigm | Time Complexity | Auxiliary Space | Key Data Structures Used | Implementation Characteristics & Benchmark Performance |
|-------------------------|-----------------|-----------------|---------------------------|--------------------------------------------------|
| **Impl 1: Kruskal's MST** | O(E log E) | O(V + E) | Edge List Vector (`std::vector<Edge>`), Disjoint Set Union (DSU) | Global edge sorting upfront. Excellent on sparse graphs. |
| **Impl 2: Prim's MST** | O(E log V) | O(V + E) | Adjacency List, Binary Min-Heap (`std::priority_queue`), Visited Vector | Dynamic vertex-by-vertex MST growth. Faster on dense graphs. |
| **Impl 3: Borůvka's MST** | O(E log V) | O(V + E) | Edge List Vector, DSU, Cheapest Edge Array | **Benchmark Winner (18.06 ms)**. Zero edge sorting and zero priority heaps; contracts components in log V scanning rounds. |

### 2. Knight in a War Grid (UVa 11906) — Traversal Complexity Matrix

| Implementation Paradigm | Time Complexity | Auxiliary Space | Key Data Structures Used | Implementation Characteristics & Benchmark Performance |
|-------------------------|-----------------|-----------------|---------------------------|--------------------------------------------------|
| **Impl 1: Queue BFS** | O(R * C) | O(R * C) | FIFO Queue (`std::queue`), 2D Visited & Water Arrays | **Benchmark Winner (6.55 ms)**. Level-by-level wave exploration; optimal memory layout without stack overflow risk. |
| **Impl 2: Stack DFS** | O(R * C) | O(R * C) | Call Stack / Recursive Functions, 2D Visited & Water Arrays | Deep path exploration before backtracking; simple recursive structure. |
| **Impl 3: Grid DSU** | O(R * C) | O(R * C) | 2D-to-1D Grid DSU Mapping `(r * C + c)`, DSU Parent & Rank Arrays | Zero graph traversals (no queues or call stacks); unifies valid land cells into disjoint sets dynamically. |

### 3. Play on Words (UVa 10129) — Eulerian Path Complexity Matrix

| Implementation Paradigm | Time Complexity | Auxiliary Space | Key Data Structures Used | Implementation Characteristics & Benchmark Performance |
|-------------------------|-----------------|-----------------|---------------------------|--------------------------------------------------|
| **Impl 1: DSU + Degree Check** | O(N) | O(1) | 26-element DSU Array, In/Out Degree Arrays | Direct decision check; ultra-compact O(1) constant auxiliary memory footprint. |
| **Impl 2: DFS Graph** | O(N) | O(1) | 26-node Adjacency List, Visited Array, Degree Arrays | **Benchmark Winner (10.73 ms)**. Graph traversal from first active vertex to confirm component connectivity. |
| **Impl 3: Hierholzer's** | O(N) | O(N) | Directed Adjacency List, Trail Stack (`std::stack`), Circuit Vector | **Constructive Trail Generation**. Traces the exact sequence of all N word edges step-by-step. |

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
