# AAA Graph Algorithms — Lab Eval-2

**Course:** Advanced Algorithms & Analysis (23CSE440)  
**Evaluation:** Lab Eval-2  
**Team:** Team-7

---

## Overview

This repository contains solutions to three UVa Online Judge problems, each demonstrating a distinct class of graph algorithm: weighted, unweighted, and non-obvious graph modelling.

| Problem | UVa ID | Algorithm | Complexity |
|---------|--------|-----------|------------|
| Dark Roads | 11631 | Kruskal's MST (Union-Find) | O(n log n) |
| Play on Words | 10129 | Eulerian Path (DSU + degree check) | O(N) |
| Knight in a War Grid | 11906 | BFS + unique-move deduplication | O(R * C * 8) |

---

## Repository Structure

```
AAA-graph-algorithms/
├── DarkRoads/
│   ├── dark_roads.cpp
│   ├── input1.txt, input2.txt, input3.txt
│   ├── expected1.txt, expected2.txt, expected3.txt
│   └── p11631(Dark Roads).pdf
├── PlayOnWords/
│   ├── play_on_words.cpp
│   ├── input1.txt, input2.txt, input3.txt
│   ├── expected1.txt, expected2.txt, expected3.txt
│   └── p10129(play on words).pdf
├── KnightInWar/
│   ├── knight_in_war.cpp
│   ├── input1.txt, input2.txt, input3.txt
│   ├── expected1.txt, expected2.txt, expected3.txt
│   └── p11906(Knight in war grid).pdf
├── Makefile
├── sim_knight.py
└── verify_expected.py
```

---

## Requirements

- `g++` with C++17 support
- GNU `make`

---

## Build and Run

All commands are run from the repository root (`AAA-graph-algorithms/`).

**Build all solutions:**
```bash
make build
```

**Run the test suite (correctness check):**
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

## Problems

### UVa 11631 — Dark Roads

Given a connected, undirected, weighted graph of junctions and roads where every road is illuminated, find the maximum cost saved by turning off lights on roads that are not needed for connectivity.

**Approach:** The minimum set of roads needed to keep all junctions connected is the Minimum Spanning Tree. The answer is the total edge weight minus the MST weight. Kruskal's algorithm with a Union-Find (DSU) structure is used for efficiency on graphs with up to 200,000 edges.

---

### UVa 10129 — Play on Words

Given N words, determine whether they can be arranged in a sequence where the last letter of each word equals the first letter of the next.

**Approach:** Model each word as a directed edge from its first character to its last character in a 26-node letter graph. An arrangement exists if and only if this graph has an Eulerian path, which requires (1) all nodes with non-zero degree belong to one connected component, and (2) the in/out degree condition is satisfied. Both checks are done using DSU and a degree count array.

---

### UVa 11906 — Knight in a War Grid

On an R x C grid with blocked (water) cells, a knight moves by offsets (M, N) or (N, M) in all sign combinations. Starting from (0, 0), find how many reachable land cells have an even number of reachable neighbors and how many have an odd number.

**Approach:** BFS from (0, 0) to find all reachable cells. For each reachable cell, enumerate its valid landing squares using a set to deduplicate moves when M equals N or either value is zero. Count cells by even/odd neighbor totals.

---

## Test Cases

Each problem has three test inputs:

| Test | Description |
|------|-------------|
| input1.txt | Official sample from the problem statement |
| input2.txt | Edge case (single node / single word / equal M and N) |
| input3.txt | Additional case (multiple test cases / disconnected graph / zero offset) |

Expected outputs are stored alongside each input in `expected*.txt` files and used by `make test` and `make benchmark` for automated verification.

---

## Complexity Summary

| Problem | Time | Space |
|---------|------|-------|
| Dark Roads | O(n log n) | O(n) |
| Play on Words | O(N) | O(26) |
| Knight in a War Grid | O(R * C * 8) | O(R * C) |
