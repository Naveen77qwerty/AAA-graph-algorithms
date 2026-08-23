#!/usr/bin/env python3
"""Simulate Knight in War Grid to compute expected outputs."""
from collections import deque

def get_deltas(M, N):
    s = set()
    for sm in (1, -1):
        for sn in (1, -1):
            s.add((sm * M, sn * N))
            s.add((sm * N, sn * M))
    return list(s)

def solve(R, C, M, N, water_cells):
    water = [[False]*C for _ in range(R)]
    for x, y in water_cells:
        water[x][y] = True

    deltas = get_deltas(M, N)

    visited = [[False]*C for _ in range(R)]
    if water[0][0]:
        return 0, 0

    visited[0][0] = True
    q = deque([(0, 0)])
    reachable = []

    while q:
        r, c = q.popleft()
        reachable.append((r, c))
        for dr, dc in deltas:
            nr, nc = r+dr, c+dc
            if 0 <= nr < R and 0 <= nc < C and not water[nr][nc] and not visited[nr][nc]:
                visited[nr][nc] = True
                q.append((nr, nc))

    even_count = odd_count = 0
    for r, c in reachable:
        cnt = sum(1 for dr, dc in deltas
                  if 0 <= r+dr < R and 0 <= c+dc < C
                  and not water[r+dr][c+dc] and visited[r+dr][c+dc])
        if cnt % 2 == 0:
            even_count += 1
        else:
            odd_count += 1

    return even_count, odd_count

# ---- input1: 2 test cases ----
print("=== input1 ===")
e, o = solve(3, 3, 1, 2, [])
print(f"Case 1: {e} {o}")
e, o = solve(2, 2, 1, 1, [])
print(f"Case 2: {e} {o}")

# ---- input2: M==N cases ----
print("\n=== input2 ===")
e, o = solve(4, 4, 2, 2, [])
print(f"Case 1: {e} {o}")
e, o = solve(3, 3, 1, 1, [(1,0),(0,1)])
print(f"Case 2: {e} {o}")

# ---- input3: M==0 or N==0 cases ----
print("\n=== input3 ===")
e, o = solve(5, 5, 0, 3, [])
print(f"Case 1: {e} {o}")
e, o = solve(3, 5, 2, 0, [(2,1)])
print(f"Case 2: {e} {o}")
