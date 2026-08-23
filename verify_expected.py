#!/usr/bin/env python3
"""
Quick manual verification of expected outputs.
Run: python3 verify_expected.py
"""

# Dark Roads: Manual MST computation
# input1: 7 junctions, 11 edges
edges1 = [(5,0,3),(6,0,2),(7,0,1),(8,1,2),(9,1,3),(7,1,4),(5,2,4),(15,3,4),(6,3,5),(8,4,5),(9,4,6),(11,5,6)]
# wait - re-read input: 0 1 7, 0 3 5, 1 2 8, 1 3 9, 1 4 7, 2 4 5, 3 4 15, 3 5 6, 4 5 8, 4 6 9, 5 6 11
edges1 = [(7,0,1),(5,0,3),(8,1,2),(9,1,3),(7,1,4),(5,2,4),(15,3,4),(6,3,5),(8,4,5),(9,4,6),(11,5,6)]
total1 = sum(w for w,u,v in edges1)
print(f"DR-Test1 total={total1}")
# Kruskal
parent = list(range(7))
def find(x):
    while parent[x] != x: parent[x] = parent[parent[x]]; x = parent[x]
    return x
def union(a, b):
    a,b = find(a), find(b)
    if a==b: return False
    parent[b]=a; return True
mst1 = 0
for w,u,v in sorted(edges1):
    if union(u,v): mst1 += w
print(f"DR-Test1 mst={mst1}, savings={total1-mst1}")

# input3 graph1: 4 junctions, 6 edges: 0-1=10, 0-2=6, 0-3=5, 1-3=15, 2-3=4, 1-2=100
parent = list(range(4))
edges3a = [(10,0,1),(6,0,2),(5,0,3),(15,1,3),(4,2,3),(100,1,2)]
total3a = sum(w for w,u,v in edges3a)
mst3a = 0
for w,u,v in sorted(edges3a):
    if union(u,v): mst3a += w
print(f"DR-Test3a total={total3a}, mst={mst3a}, savings={total3a-mst3a}")

# input3 graph2: 5 junctions, 7 edges
parent = list(range(5))
edges3b = [(2,0,1),(3,0,2),(1,1,2),(4,1,3),(5,2,3),(6,3,4),(7,4,0)]
total3b = sum(w for w,u,v in edges3b)
mst3b = 0
for w,u,v in sorted(edges3b):
    if union(u,v): mst3b += w
print(f"DR-Test3b total={total3b}, mst={mst3b}, savings={total3b-mst3b}")
