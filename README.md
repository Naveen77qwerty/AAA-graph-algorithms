# AAA Graph Algorithms — Lab Eval-2

**Course:** Advanced Algorithms & Analysis (23CSE440)  
**Evaluation:** Lab Eval-2  
**Team:** Team-7

---

## Overview

This repository contains solutions to three UVa Online Judge problems, each demonstrating a distinct class of graph algorithm: weighted graphs (Kruskal's MST), non-obvious graph modeling (Eulerian Path DSU), and grid traversal (BFS move deduplication).

| Problem | UVa ID | Algorithm | Complexity |
|---------|--------|-----------|------------|
| Dark Roads | 11631 | Kruskal's MST (Union-Find) | O(n log n) |
| Play on Words | 10129 | Eulerian Path (DSU + degree check) | O(N) |
| Knight in a War Grid | 11906 | BFS + unique-move deduplication | O(R * C * 8) |

---

## 🎨 Interactive Graph Visualizer (`index.html`)

An interactive, high-definition web visualizer is included in the repository root to demonstrate all 3 graph algorithms step-by-step for academic presentations.

### Features
* **Full Light Theme & Full-Screen Canvas**: High-DPI canvas scaling (`window.devicePixelRatio`) with spacious node layouts and crisp vector edge rendering.
* **Dark Roads Tab**: Visualizes Kruskal's MST, edge sorting, DSU component merging, edge acceptance/rejection (cycle detection), and cost savings calculations.
* **Knight in War Grid Tab**: Grid representation animating BFS expansion from $(0,0)$, knight jump deltas $(\pm M, \pm N)$, water obstacles, and reachable neighbor parity highlights (even vs. odd).
* **Play on Words Tab**: Directed letter graph visualization with quadratic Bezier curved edges (`quadraticCurveTo`), DSU component verification, in/out-degree counts, and Eulerian path detection.
* **Playback & Custom Inputs**: Play/Pause, Step Back/Forward, Speed Slider, preset input selectors (5 presets per problem), and an interactive **`✏️ Custom Input`** modal.

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
├── DarkRoads/
│   ├── dark_roads.cpp
│   ├── input1.txt - input5.txt
│   ├── expected1.txt - expected5.txt
│   └── p11631(Dark Roads).pdf
├── PlayOnWords/
│   ├── play_on_words.cpp
│   ├── input1.txt - input5.txt
│   ├── expected1.txt - expected5.txt
│   └── p10129(play on words).pdf
├── KnightInWar/
│   ├── knight_in_war.cpp
│   ├── input1.txt - input5.txt
│   ├── expected1.txt - expected5.txt
│   └── p11906(Knight in war grid).pdf
└── Makefile
```

---

## Build and Run

All commands are run from the repository root (`AAA-graph-algorithms/`).

**Build all solutions:**
```bash
make build
```

**Run the test suite (15 automated tests):**
```bash
make test
```

**Run the benchmark (correctness + timing):**
```bash
make benchmark
```

**Remove all compiled binaries:**
```bash
make clean
```

---

## Problems & Algorithms

### UVa 11631 — Dark Roads

Given a connected, undirected, weighted graph of junctions and roads where every road is illuminated, find the maximum cost saved by turning off lights on roads that are not needed for connectivity.

**Approach:** The minimum set of roads needed to keep all junctions connected is the Minimum Spanning Tree (MST). The answer is total edge weight minus MST weight. Kruskal's algorithm with Union-Find (DSU) path compression and rank optimization is used for $O(E \log E)$ efficiency on graphs with up to 200,000 edges.

---

### UVa 10129 — Play on Words

Given N words, determine whether they can be arranged in a sequence where the last letter of each word equals the first letter of the next.

**Approach:** Model each word as a directed edge from its first character to its last character in a 26-node letter graph. An arrangement exists if and only if this graph has an Eulerian path/circuit:
1. **Connectivity**: All vertices with non-zero degree belong to one connected component (checked via DSU).
2. **Degree balance**: At most one start node ($\text{out} - \text{in} = 1$) and one end node ($\text{in} - \text{out} = 1$), with all other nodes balanced ($\text{in} == \text{out}$).

---

### UVa 11906 — Knight in a War Grid

On an R x C grid with blocked (water) cells, a knight moves by offsets (M, N) or (N, M) in all sign combinations. Starting from (0, 0), find how many reachable land cells have an even number of reachable neighbors and how many have an odd number.

**Approach:** BFS from (0, 0) to find all reachable cells. For each reachable cell, enumerate valid landing squares using a set to deduplicate moves when $M = N$ or $M=0, N=0$. Count cells by even/odd neighbor totals.

---

## Test Cases Summary (5 per problem)

Each problem directory contains 5 comprehensive test inputs:

| Test | Description |
|------|-------------|
| input1.txt | Official sample test case |
| input2.txt | Edge case (single node / equal M and N / single word) |
| input3.txt | Multi-component / degree-imbalanced / zero offset cases |
| input4.txt | Large dense graph (10 nodes 15 edges / 10x10 grid / Eulerian circuit) |
| input5.txt | Large cyclic graph (8 nodes 12 edges / 12x12 grid / disconnected graph) |

All expected outputs are stored alongside each input in `expected*.txt` files and verified by `make test` and `make benchmark`.

---

## Complexity Summary

| Problem | Time Complexity | Space Complexity |
|---------|-----------------|------------------|
| Dark Roads | $O(E \log E)$ | $O(V + E)$ |
| Play on Words | $O(N)$ | $O(26) = O(1)$ |
| Knight in a War Grid | $O(R \cdot C \cdot 8)$ | $O(R \cdot C)$ |
