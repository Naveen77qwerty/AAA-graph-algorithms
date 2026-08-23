#!/usr/bin/env python3
"""
benchmark.py — AAA Graph Algorithms Lab Eval-2 Benchmarking Harness

Builds all three solutions, runs each with its test cases, measures
wall-clock time and memory (RSS), verifies output correctness, and
prints a formatted summary table.

Usage:
    python3 benchmark.py
    python3 benchmark.py --no-build   (skip recompilation)
"""

import subprocess
import time
import os
import sys
import resource
import argparse
from pathlib import Path

# ─── ANSI colours ───────────────────────────────────────────────────────────
GREEN  = "\033[92m"
RED    = "\033[91m"
YELLOW = "\033[93m"
CYAN   = "\033[96m"
BOLD   = "\033[1m"
RESET  = "\033[0m"

BASE = Path(__file__).parent  # repo root

# ─── Problem registry ───────────────────────────────────────────────────────
PROBLEMS = [
    {
        "name":      "Dark Roads (UVa 11631)",
        "algorithm": "Kruskal's MST — O(n log n)",
        "src":       BASE / "DarkRoads" / "dark_roads.cpp",
        "binary":    BASE / "DarkRoads" / "dark_roads",
        "tests": [
            {
                "label":    "Sample (7 junctions, 11 roads)",
                "input":    BASE / "DarkRoads" / "input1.txt",
                "expected": BASE / "DarkRoads" / "expected1.txt",
            },
            {
                "label":    "Edge case (1 junction, 0 roads)",
                "input":    BASE / "DarkRoads" / "input2.txt",
                "expected": BASE / "DarkRoads" / "expected2.txt",
            },
            {
                "label":    "Multiple test cases",
                "input":    BASE / "DarkRoads" / "input3.txt",
                "expected": BASE / "DarkRoads" / "expected3.txt",
            },
        ],
    },
    {
        "name":      "Play on Words (UVa 10129)",
        "algorithm": "Eulerian Path (DSU + degree check) — O(N)",
        "src":       BASE / "PlayOnWords" / "play_on_words.cpp",
        "binary":    BASE / "PlayOnWords" / "play_on_words",
        "tests": [
            {
                "label":    "Official sample (3 test cases)",
                "input":    BASE / "PlayOnWords" / "input1.txt",
                "expected": BASE / "PlayOnWords" / "expected1.txt",
            },
            {
                "label":    "Single word / disconnected graph",
                "input":    BASE / "PlayOnWords" / "input2.txt",
                "expected": BASE / "PlayOnWords" / "expected2.txt",
            },
            {
                "label":    "Degree-imbalanced (impossible)",
                "input":    BASE / "PlayOnWords" / "input3.txt",
                "expected": BASE / "PlayOnWords" / "expected3.txt",
            },
        ],
    },
    {
        "name":      "Knight in a War Grid (UVa 11906)",
        "algorithm": "BFS + unique-move dedup — O(R·C·8)",
        "src":       BASE / "KnightInWar" / "knight_in_war.cpp",
        "binary":    BASE / "KnightInWar" / "knight_in_war",
        "tests": [
            {
                "label":    "Sample cases (3×3 and 2×2 grid)",
                "input":    BASE / "KnightInWar" / "input1.txt",
                "expected": BASE / "KnightInWar" / "expected1.txt",
            },
            {
                "label":    "M==N edge cases",
                "input":    BASE / "KnightInWar" / "input2.txt",
                "expected": BASE / "KnightInWar" / "expected2.txt",
            },
            {
                "label":    "M==0 / N==0 edge cases",
                "input":    BASE / "KnightInWar" / "input3.txt",
                "expected": BASE / "KnightInWar" / "expected3.txt",
            },
        ],
    },
]

# ─── Build ───────────────────────────────────────────────────────────────────
def build_all():
    print(f"\n{BOLD}{CYAN}{'─'*62}{RESET}")
    print(f"{BOLD}{CYAN}  Building all solutions with g++ -O2{RESET}")
    print(f"{BOLD}{CYAN}{'─'*62}{RESET}\n")

    all_ok = True
    for p in PROBLEMS:
        src, binary = p["src"], p["binary"]
        cmd = ["g++", "-O2", "-std=c++17", "-o", str(binary), str(src)]
        t0 = time.perf_counter()
        result = subprocess.run(cmd, capture_output=True, text=True)
        elapsed = (time.perf_counter() - t0) * 1000

        if result.returncode == 0:
            print(f"  {GREEN}✓ Built{RESET}  {src.name}  ({elapsed:.0f} ms)")
        else:
            print(f"  {RED}✗ FAILED{RESET} {src.name}")
            print(result.stderr)
            all_ok = False

    print()
    return all_ok

# ─── Run one test ─────────────────────────────────────────────────────────────
def run_test(binary, input_path, expected_path):
    """
    Returns (status, elapsed_ms, rss_kb, actual_output, expected_output).
    status: 'PASS', 'FAIL', 'ERROR', 'MISSING'
    """
    if not expected_path.exists():
        return "MISSING", 0.0, 0, "", ""

    expected = expected_path.read_text().strip()

    try:
        with open(input_path) as fin:
            t0 = time.perf_counter()
            result = subprocess.run(
                [str(binary)],
                stdin=fin,
                capture_output=True,
                text=True,
                timeout=10,
            )
            elapsed_ms = (time.perf_counter() - t0) * 1000

        # Memory via /usr/bin/time -v isn't easy to parse here, so we use
        # resource.getrusage on the parent process as a proxy.
        rss_kb = resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss

        actual = result.stdout.strip()
        status = "PASS" if actual == expected else "FAIL"
        return status, elapsed_ms, rss_kb, actual, expected

    except subprocess.TimeoutExpired:
        return "ERROR", 10000.0, 0, "TIMEOUT", expected
    except FileNotFoundError:
        return "ERROR", 0.0, 0, "BINARY NOT FOUND", expected

# ─── Main ────────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-build", action="store_true", help="Skip compilation")
    args = parser.parse_args()

    if not args.no_build:
        ok = build_all()
        if not ok:
            print(f"{RED}Build failed. Aborting benchmark.{RESET}")
            sys.exit(1)

    total_tests = 0
    passed = 0
    slowest = ("", 0.0)
    results_log = []

    print(f"\n{BOLD}{'═'*62}{RESET}")
    print(f"{BOLD}  BENCHMARK RESULTS — AAA Graph Algorithms Lab Eval-2{RESET}")
    print(f"{BOLD}{'═'*62}{RESET}\n")

    for prob in PROBLEMS:
        print(f"{BOLD}{CYAN}▶  {prob['name']}{RESET}")
        print(f"   Algorithm: {prob['algorithm']}")
        print()

        for test in prob["tests"]:
            label    = test["label"]
            inp      = test["input"]
            exp      = test["expected"]
            binary   = prob["binary"]

            status, elapsed_ms, rss_kb, actual, expected = run_test(binary, inp, exp)
            total_tests += 1

            if status == "PASS":
                passed += 1
                badge = f"{GREEN}PASS{RESET}"
            elif status == "FAIL":
                badge = f"{RED}FAIL{RESET}"
            elif status == "MISSING":
                badge = f"{YELLOW}SKIP{RESET} (expected file missing)"
            else:
                badge = f"{RED}ERROR{RESET}"

            mem_str = f"{rss_kb:,} KB" if rss_kb else "n/a"
            print(f"   [{badge}]  {label}")
            print(f"           ⏱  {elapsed_ms:.2f} ms   📦 {mem_str}")

            if status == "FAIL":
                print(f"           {RED}Expected:{RESET} {repr(expected[:80])}")
                print(f"           {RED}Got:     {RESET} {repr(actual[:80])}")

            if elapsed_ms > slowest[1]:
                slowest = (f"{prob['name']} / {inp.name}", elapsed_ms)

            results_log.append((prob["name"], label, status, elapsed_ms))
            print()

        print(f"{'─'*62}\n")

    # ── Summary ──────────────────────────────────────────────────────────────
    print(f"{BOLD}{'═'*62}{RESET}")
    print(f"{BOLD}  SUMMARY{RESET}")
    print(f"{'─'*62}")
    print(f"  Total tests : {total_tests}")
    pass_colour = GREEN if passed == total_tests else RED
    print(f"  Passed      : {pass_colour}{passed}{RESET} / {total_tests}")
    print(f"  Failed      : {RED}{total_tests - passed}{RESET}")
    if slowest[0]:
        print(f"  Slowest     : {slowest[0]}  ({slowest[1]:.2f} ms)")
    total_time = sum(r[3] for r in results_log)
    print(f"  Total time  : {total_time:.2f} ms")
    print(f"{BOLD}{'═'*62}{RESET}\n")

    sys.exit(0 if passed == total_tests else 1)


if __name__ == "__main__":
    main()
