#!/bin/bash
# build_all.sh — Compile all three graph algorithm solutions
# Usage: bash build_all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAGS="-O2 -std=c++17 -Wall"

echo "Building Dark Roads (UVa 11631)..."
g++ $FLAGS -o "$SCRIPT_DIR/DarkRoads/dark_roads" "$SCRIPT_DIR/DarkRoads/dark_roads.cpp"
echo "  → DarkRoads/dark_roads"

echo "Building Play on Words (UVa 10129)..."
g++ $FLAGS -o "$SCRIPT_DIR/PlayOnWords/play_on_words" "$SCRIPT_DIR/PlayOnWords/play_on_words.cpp"
echo "  → PlayOnWords/play_on_words"

echo "Building Knight in a War Grid (UVa 11906)..."
g++ $FLAGS -o "$SCRIPT_DIR/KnightInWar/knight_in_war" "$SCRIPT_DIR/KnightInWar/knight_in_war.cpp"
echo "  → KnightInWar/knight_in_war"

echo ""
echo "All solutions built successfully."
