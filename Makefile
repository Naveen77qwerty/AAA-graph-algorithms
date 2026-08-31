CXX := g++
CXXFLAGS := -O2 -std=c++17 -Wall

BINARIES := \
  DarkRoads/dark_roads_kruskal \
  DarkRoads/dark_roads_prim \
  DarkRoads/dark_roads_boruvka \
  KnightInWar/knight_in_war_bfs \
  KnightInWar/knight_in_war_dfs \
  KnightInWar/knight_in_war_dsu \
  PlayOnWords/play_on_words_dsu \
  PlayOnWords/play_on_words_dfs \
  PlayOnWords/play_on_words_hierholzer

# Colors
BOLD   := \033[1m
GREEN  := \033[1;32m
RED    := \033[1;31m
CYAN   := \033[1;36m
YELLOW := \033[1;33m
DIM    := \033[2m
RESET  := \033[0m

.PHONY: all build test benchmark clean

all: build

build: clean
	@printf "$(BOLD)$(CYAN)Compiling all 9 graph algorithm solutions (3 per problem)...$(RESET)\n"
	@$(MAKE) --no-print-directory $(BINARIES)
	@printf "$(GREEN)✓ All 9 binaries built successfully.$(RESET)\n\n"

# Dark Roads Targets
DarkRoads/dark_roads_kruskal: DarkRoads/dark_roads_kruskal.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

DarkRoads/dark_roads_prim: DarkRoads/dark_roads_prim.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

DarkRoads/dark_roads_boruvka: DarkRoads/dark_roads_boruvka.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

# Knight in War Targets
KnightInWar/knight_in_war_bfs: KnightInWar/knight_in_war_bfs.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

KnightInWar/knight_in_war_dfs: KnightInWar/knight_in_war_dfs.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

KnightInWar/knight_in_war_dsu: KnightInWar/knight_in_war_dsu.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

# Play on Words Targets
PlayOnWords/play_on_words_dsu: PlayOnWords/play_on_words_dsu.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

PlayOnWords/play_on_words_dfs: PlayOnWords/play_on_words_dfs.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

PlayOnWords/play_on_words_hierholzer: PlayOnWords/play_on_words_hierholzer.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

test: build
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════════════════════$(RESET)\n"
	@printf "$(BOLD)$(CYAN)  AAA GRAPH ALGORITHMS — COMPREHENSIVE TEST SUITE (9 ALGORITHMS × 6 TESTS)$(RESET)\n"
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════════════════════$(RESET)\n"
	@pass_count=0; total_count=0; \
	run_test() { \
		binary="$$1"; inp="$$2"; exp="$$3"; label="$$4"; \
		total_count=$$((total_count + 1)); \
		actual=$$(./$$binary < $$inp 2>&1 | tr '\n' ' ' | sed 's/ $$//'); \
		expected=$$(cat $$exp 2>/dev/null | tr '\n' ' ' | sed 's/ $$//'); \
		if [ "$$actual" = "$$expected" ]; then \
			pass_count=$$((pass_count + 1)); \
			printf "  [ $(GREEN)PASS$(RESET) ]  %-55s\n" "$$label"; \
		else \
			printf "  [ $(RED)FAIL$(RESET) ]  %-55s\n" "$$label"; \
			printf "           $(RED)Expected:$(RESET) %s\n" "$$expected"; \
			printf "           $(RED)Actual:  $(RESET) %s\n" "$$actual"; \
		fi; \
	}; \
	printf "\n$(BOLD)$(CYAN)▶ Dark Roads (UVa 11631)$(RESET)\n"; \
	for i in 1 2 3 4 5 6; do \
		run_test "DarkRoads/dark_roads_kruskal" "DarkRoads/input$$i.txt" "DarkRoads/expected$$i.txt" "Impl 1 (Kruskal)  — Test $$i"; \
		run_test "DarkRoads/dark_roads_prim"    "DarkRoads/input$$i.txt" "DarkRoads/expected$$i.txt" "Impl 2 (Prim Heap) — Test $$i"; \
		run_test "DarkRoads/dark_roads_boruvka" "DarkRoads/input$$i.txt" "DarkRoads/expected$$i.txt" "Impl 3 (Boruvka)   — Test $$i"; \
	done; \
	printf "\n$(BOLD)$(CYAN)▶ Play on Words (UVa 10129)$(RESET)\n"; \
	for i in 1 2 3 4 5 6; do \
		run_test "PlayOnWords/play_on_words_dsu"        "PlayOnWords/input$$i.txt" "PlayOnWords/expected$$i.txt" "Impl 1 (DSU Degree) — Test $$i"; \
		run_test "PlayOnWords/play_on_words_dfs"        "PlayOnWords/input$$i.txt" "PlayOnWords/expected$$i.txt" "Impl 2 (DFS Graph)  — Test $$i"; \
		run_test "PlayOnWords/play_on_words_hierholzer" "PlayOnWords/input$$i.txt" "PlayOnWords/expected$$i.txt" "Impl 3 (Hierholzer) — Test $$i"; \
	done; \
	printf "\n$(BOLD)$(CYAN)▶ Knight in a War Grid (UVa 11906)$(RESET)\n"; \
	for i in 1 2 3 4 5 6; do \
		run_test "KnightInWar/knight_in_war_bfs" "KnightInWar/input$$i.txt" "KnightInWar/expected$$i.txt" "Impl 1 (Queue BFS)  — Test $$i"; \
		run_test "KnightInWar/knight_in_war_dfs" "KnightInWar/input$$i.txt" "KnightInWar/expected$$i.txt" "Impl 2 (Stack DFS)  — Test $$i"; \
		run_test "KnightInWar/knight_in_war_dsu" "KnightInWar/input$$i.txt" "KnightInWar/expected$$i.txt" "Impl 3 (Grid DSU)   — Test $$i"; \
	done; \
	printf "\n$(BOLD)$(CYAN)──────────────────────────────────────────────────────────────────────────────$(RESET)\n"; \
	if [ $$pass_count -eq $$total_count ]; then \
		printf "$(BOLD)  SUMMARY: $(GREEN)%d / %d PASSED$(RESET)\n" $$pass_count $$total_count; \
	else \
		printf "$(BOLD)  SUMMARY: $(RED)%d / %d PASSED (%d FAILED)$(RESET)\n" $$pass_count $$total_count $$((total_count - pass_count)); \
	fi; \
	printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════════════════════$(RESET)\n\n"

benchmark: build
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════════════════════════════$(RESET)\n"
	@printf "$(BOLD)$(CYAN)  AAA GRAPH ALGORITHMS — COMPARATIVE ALGORITHM BENCHMARK TABLE$(RESET)\n"
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════════════════════════════$(RESET)\n"
	@run_bench_row() { \
		inp="$$1"; exp="$$2"; label="$$3"; b1="$$4"; b2="$$5"; b3="$$6"; \
		time_binary() { \
			b="$$1"; i="$$2"; e="$$3"; \
			t0=$$(date +%s%N); \
			act=$$(./$$b < $$i 2>&1 | tr '\n' ' ' | sed 's/ $$//'); \
			t1=$$(date +%s%N); \
			ms=$$(awk "BEGIN {printf \"%.2f\", ($$t1 - $$t0)/1000000}"); \
			expected=$$(cat $$e 2>/dev/null | tr '\n' ' ' | sed 's/ $$//'); \
			if [ "$$act" = "$$expected" ]; then \
				printf "%6.2f ms [P]" "$$ms"; \
			else \
				printf "%6.2f ms [F]" "$$ms"; \
			fi; \
		}; \
		res1=$$(time_binary "$$b1" "$$inp" "$$exp"); \
		res2=$$(time_binary "$$b2" "$$inp" "$$exp"); \
		res3=$$(time_binary "$$b3" "$$inp" "$$exp"); \
		printf "  │ %-28s │ %-15s │ %-15s │ %-15s │\n" "$$label" "$$res1" "$$res2" "$$res3"; \
	}; \
	printf "\n$(BOLD)$(CYAN)▶ Dark Roads (UVa 11631) — MST Algorithm Comparison$(RESET)\n"; \
	printf "  ┌──────────────────────────────┬─────────────────┬─────────────────┬─────────────────┐\n"; \
	printf "  │ Test Case                    │ Impl 1: Kruskal │ Impl 2: Prim    │ Impl 3: Boruvka │\n"; \
	printf "  ├──────────────────────────────┼─────────────────┼─────────────────┼─────────────────┤\n"; \
	run_bench_row "DarkRoads/input1.txt" "DarkRoads/expected1.txt" "Test 1 (7 junc, 11 rds)" "DarkRoads/dark_roads_kruskal" "DarkRoads/dark_roads_prim" "DarkRoads/dark_roads_boruvka"; \
	run_bench_row "DarkRoads/input2.txt" "DarkRoads/expected2.txt" "Test 2 (1 junc, 0 rds)"  "DarkRoads/dark_roads_kruskal" "DarkRoads/dark_roads_prim" "DarkRoads/dark_roads_boruvka"; \
	run_bench_row "DarkRoads/input3.txt" "DarkRoads/expected3.txt" "Test 3 (Multi-test)"     "DarkRoads/dark_roads_kruskal" "DarkRoads/dark_roads_prim" "DarkRoads/dark_roads_boruvka"; \
	run_bench_row "DarkRoads/input4.txt" "DarkRoads/expected4.txt" "Test 4 (Dense 10j, 15r)" "DarkRoads/dark_roads_kruskal" "DarkRoads/dark_roads_prim" "DarkRoads/dark_roads_boruvka"; \
	run_bench_row "DarkRoads/input5.txt" "DarkRoads/expected5.txt" "Test 5 (Cyclic 8j, 12r)" "DarkRoads/dark_roads_kruskal" "DarkRoads/dark_roads_prim" "DarkRoads/dark_roads_boruvka"; \
	run_bench_row "DarkRoads/input6.txt" "DarkRoads/expected6.txt" "Test 6 (10k Nodes, 50k Edges)" "DarkRoads/dark_roads_kruskal" "DarkRoads/dark_roads_prim" "DarkRoads/dark_roads_boruvka"; \
	printf "  └──────────────────────────────┴─────────────────┴─────────────────┴─────────────────┘\n"; \
	printf "\n$(BOLD)$(CYAN)▶ Knight in a War Grid (UVa 11906) — Grid Traversal Comparison$(RESET)\n"; \
	printf "  ┌──────────────────────────────┬─────────────────┬─────────────────┬─────────────────┐\n"; \
	printf "  │ Test Case                    │ Impl 1: BFS     │ Impl 2: DFS     │ Impl 3: DSU     │\n"; \
	printf "  ├──────────────────────────────┼─────────────────┼─────────────────┼─────────────────┤\n"; \
	run_bench_row "KnightInWar/input1.txt" "KnightInWar/expected1.txt" "Test 1 (6x6 Grid)"     "KnightInWar/knight_in_war_bfs" "KnightInWar/knight_in_war_dfs" "KnightInWar/knight_in_war_dsu"; \
	run_bench_row "KnightInWar/input2.txt" "KnightInWar/expected2.txt" "Test 2 (5x5 M==N)"    "KnightInWar/knight_in_war_bfs" "KnightInWar/knight_in_war_dfs" "KnightInWar/knight_in_war_dsu"; \
	run_bench_row "KnightInWar/input3.txt" "KnightInWar/expected3.txt" "Test 3 (7x7 M!=N)"    "KnightInWar/knight_in_war_bfs" "KnightInWar/knight_in_war_dfs" "KnightInWar/knight_in_war_dsu"; \
	run_bench_row "KnightInWar/input4.txt" "KnightInWar/expected4.txt" "Test 4 (10x10 Grid)"   "KnightInWar/knight_in_war_bfs" "KnightInWar/knight_in_war_dfs" "KnightInWar/knight_in_war_dsu"; \
	run_bench_row "KnightInWar/input5.txt" "KnightInWar/expected5.txt" "Test 5 (12x12 Grid)"   "KnightInWar/knight_in_war_bfs" "KnightInWar/knight_in_war_dfs" "KnightInWar/knight_in_war_dsu"; \
	run_bench_row "KnightInWar/input6.txt" "KnightInWar/expected6.txt" "Test 6 (100x100 Grid)" "KnightInWar/knight_in_war_bfs" "KnightInWar/knight_in_war_dfs" "KnightInWar/knight_in_war_dsu"; \
	printf "  └──────────────────────────────┴─────────────────┴─────────────────┴─────────────────┘\n"; \
	printf "\n$(BOLD)$(CYAN)▶ Play on Words (UVa 10129) — Eulerian Path Comparison$(RESET)\n"; \
	printf "  ┌──────────────────────────────┬─────────────────┬─────────────────┬─────────────────┐\n"; \
	printf "  │ Test Case                    │ Impl 1: DSU     │ Impl 2: DFS     │ Impl 3: Hierhol.│\n"; \
	printf "  ├──────────────────────────────┼─────────────────┼─────────────────┼─────────────────┤\n"; \
	run_bench_row "PlayOnWords/input1.txt" "PlayOnWords/expected1.txt" "Test 1 (4 Words)"      "PlayOnWords/play_on_words_dsu" "PlayOnWords/play_on_words_dfs" "PlayOnWords/play_on_words_hierholzer"; \
	run_bench_row "PlayOnWords/input2.txt" "PlayOnWords/expected2.txt" "Test 2 (2 Words)"      "PlayOnWords/play_on_words_dsu" "PlayOnWords/play_on_words_dfs" "PlayOnWords/play_on_words_hierholzer"; \
	run_bench_row "PlayOnWords/input3.txt" "PlayOnWords/expected3.txt" "Test 3 (5 Words)"      "PlayOnWords/play_on_words_dsu" "PlayOnWords/play_on_words_dfs" "PlayOnWords/play_on_words_hierholzer"; \
	run_bench_row "PlayOnWords/input4.txt" "PlayOnWords/expected4.txt" "Test 4 (8 Circuit)"    "PlayOnWords/play_on_words_dsu" "PlayOnWords/play_on_words_dfs" "PlayOnWords/play_on_words_hierholzer"; \
	run_bench_row "PlayOnWords/input5.txt" "PlayOnWords/expected5.txt" "Test 5 (7 Disconn)"    "PlayOnWords/play_on_words_dsu" "PlayOnWords/play_on_words_dfs" "PlayOnWords/play_on_words_hierholzer"; \
	run_bench_row "PlayOnWords/input6.txt" "PlayOnWords/expected6.txt" "Test 6 (100k Words)"   "PlayOnWords/play_on_words_dsu" "PlayOnWords/play_on_words_dfs" "PlayOnWords/play_on_words_hierholzer"; \
	printf "  └──────────────────────────────┴─────────────────┴─────────────────┴─────────────────┘\n\n"; \
	printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════════════════════════════$(RESET)\n\n"

clean:
	@rm -f $(BINARIES) *.o */*.o
	@rm -rf __pycache__ */__pycache__
