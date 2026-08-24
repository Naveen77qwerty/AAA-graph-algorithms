CXX := g++
CXXFLAGS := -O2 -std=c++17 -Wall

BINARIES := DarkRoads/dark_roads PlayOnWords/play_on_words KnightInWar/knight_in_war

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
	@printf "$(BOLD)$(CYAN)Compiling graph algorithm solutions...$(RESET)\n"
	@$(MAKE) --no-print-directory $(BINARIES)
	@printf "$(GREEN)✓ All binaries built successfully.$(RESET)\n\n"

DarkRoads/dark_roads: DarkRoads/dark_roads.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

PlayOnWords/play_on_words: PlayOnWords/play_on_words.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

KnightInWar/knight_in_war: KnightInWar/knight_in_war.cpp
	@printf "  $(CYAN)► Compiling$(RESET) %s -> %s\n" "$<" "$@"
	@$(CXX) $(CXXFLAGS) -o $@ $<

test: build
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════$(RESET)\n"
	@printf "$(BOLD)$(CYAN)  AAA GRAPH ALGORITHMS — TEST SUITE RESULTS$(RESET)\n"
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════$(RESET)\n"
	@pass_count=0; total_count=0; \
	run_test() { \
		binary="$$1"; inp="$$2"; exp="$$3"; label="$$4"; \
		total_count=$$((total_count + 1)); \
		actual=$$(./$$binary < $$inp 2>&1 | tr '\n' ' ' | sed 's/ $$//'); \
		expected=$$(cat $$exp 2>/dev/null | tr '\n' ' ' | sed 's/ $$//'); \
		if [ "$$actual" = "$$expected" ]; then \
			pass_count=$$((pass_count + 1)); \
			printf "  [ $(GREEN)PASS$(RESET) ]  %-42s\n" "$$label"; \
		else \
			printf "  [ $(RED)FAIL$(RESET) ]  %-42s\n" "$$label"; \
			printf "           $(RED)Expected:$(RESET) %s\n" "$$expected"; \
			printf "           $(RED)Actual:  $(RESET) %s\n" "$$actual"; \
		fi; \
	}; \
	printf "\n$(BOLD)$(CYAN)▶ Dark Roads (UVa 11631)$(RESET)\n"; \
	run_test "DarkRoads/dark_roads" "DarkRoads/input1.txt" "DarkRoads/expected1.txt" "DR-Test1 (Sample 7 junctions, 11 roads)"; \
	run_test "DarkRoads/dark_roads" "DarkRoads/input2.txt" "DarkRoads/expected2.txt" "DR-Test2 (Edge case 1 junction, 0 roads)"; \
	run_test "DarkRoads/dark_roads" "DarkRoads/input3.txt" "DarkRoads/expected3.txt" "DR-Test3 (Multiple test cases)"; \
	printf "\n$(BOLD)$(CYAN)▶ Play on Words (UVa 10129)$(RESET)\n"; \
	run_test "PlayOnWords/play_on_words" "PlayOnWords/input1.txt" "PlayOnWords/expected1.txt" "PW-Test1 (Official sample)"; \
	run_test "PlayOnWords/play_on_words" "PlayOnWords/input2.txt" "PlayOnWords/expected2.txt" "PW-Test2 (Single word / disconnected)"; \
	run_test "PlayOnWords/play_on_words" "PlayOnWords/input3.txt" "PlayOnWords/expected3.txt" "PW-Test3 (Degree-imbalanced)"; \
	printf "\n$(BOLD)$(CYAN)▶ Knight in a War Grid (UVa 11906)$(RESET)\n"; \
	run_test "KnightInWar/knight_in_war" "KnightInWar/input1.txt" "KnightInWar/expected1.txt" "KW-Test1 (Sample 3x3 and 2x2 grid)"; \
	run_test "KnightInWar/knight_in_war" "KnightInWar/input2.txt" "KnightInWar/expected2.txt" "KW-Test2 (M==N edge cases)"; \
	run_test "KnightInWar/knight_in_war" "KnightInWar/input3.txt" "KnightInWar/expected3.txt" "KW-Test3 (M==0 / N==0 edge cases)"; \
	printf "\n$(BOLD)$(CYAN)──────────────────────────────────────────────────────────────$(RESET)\n"; \
	if [ $$pass_count -eq $$total_count ]; then \
		printf "$(BOLD)  SUMMARY: $(GREEN)%d / %d PASSED$(RESET)\n" $$pass_count $$total_count; \
	else \
		printf "$(BOLD)  SUMMARY: $(RED)%d / %d PASSED (%d FAILED)$(RESET)\n" $$pass_count $$total_count $$((total_count - pass_count)); \
	fi; \
	printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════$(RESET)\n\n"

benchmark: build
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════$(RESET)\n"
	@printf "$(BOLD)$(CYAN)  AAA GRAPH ALGORITHMS — BENCHMARK RESULTS$(RESET)\n"
	@printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════$(RESET)\n"
	@pass_count=0; total_count=0; total_time=0; slowest_label=""; slowest_time=0; \
	run_bench() { \
		binary="$$1"; inp="$$2"; exp="$$3"; label="$$4"; \
		total_count=$$((total_count + 1)); \
		t0=$$(date +%s%N); \
		actual=$$(./$$binary < $$inp 2>&1 | tr '\n' ' ' | sed 's/ $$//'); \
		t1=$$(date +%s%N); \
		elapsed_ms=$$(awk "BEGIN {printf \"%.2f\", ($$t1 - $$t0)/1000000}"); \
		expected=$$(cat $$exp 2>/dev/null | tr '\n' ' ' | sed 's/ $$//'); \
		total_time=$$(awk "BEGIN {printf \"%.2f\", $$total_time + $$elapsed_ms}"); \
		is_slowest=$$(awk "BEGIN {print ($$elapsed_ms > $$slowest_time ? 1 : 0)}"); \
		if [ "$$is_slowest" -eq 1 ]; then slowest_time=$$elapsed_ms; slowest_label="$$label"; fi; \
		if [ "$$actual" = "$$expected" ]; then \
			pass_count=$$((pass_count + 1)); \
			printf "  [ $(GREEN)PASS$(RESET) ]  %-42s  ⏱  %6.2f ms\n" "$$label" "$$elapsed_ms"; \
		else \
			printf "  [ $(RED)FAIL$(RESET) ]  %-42s  ⏱  %6.2f ms\n" "$$label" "$$elapsed_ms"; \
			printf "           $(RED)Expected:$(RESET) %s\n" "$$expected"; \
			printf "           $(RED)Actual:  $(RESET) %s\n" "$$actual"; \
		fi; \
	}; \
	printf "\n$(BOLD)$(CYAN)▶ Dark Roads (UVa 11631)$(RESET)\n"; \
	printf "   $(DIM)Algorithm: Kruskal's MST — O(n log n)$(RESET)\n\n"; \
	run_bench "DarkRoads/dark_roads" "DarkRoads/input1.txt" "DarkRoads/expected1.txt" "Sample (7 junctions, 11 roads)"; \
	run_bench "DarkRoads/dark_roads" "DarkRoads/input2.txt" "DarkRoads/expected2.txt" "Edge case (1 junction, 0 roads)"; \
	run_bench "DarkRoads/dark_roads" "DarkRoads/input3.txt" "DarkRoads/expected3.txt" "Multiple test cases"; \
	printf "\n$(BOLD)$(CYAN)▶ Play on Words (UVa 10129)$(RESET)\n"; \
	printf "   $(DIM)Algorithm: Eulerian Path (DSU + degree check) — O(N)$(RESET)\n\n"; \
	run_bench "PlayOnWords/play_on_words" "PlayOnWords/input1.txt" "PlayOnWords/expected1.txt" "Official sample (3 test cases)"; \
	run_bench "PlayOnWords/play_on_words" "PlayOnWords/input2.txt" "PlayOnWords/expected2.txt" "Single word / disconnected graph"; \
	run_bench "PlayOnWords/play_on_words" "PlayOnWords/input3.txt" "PlayOnWords/expected3.txt" "Degree-imbalanced (impossible)"; \
	printf "\n$(BOLD)$(CYAN)▶ Knight in a War Grid (UVa 11906)$(RESET)\n"; \
	printf "   $(DIM)Algorithm: BFS + unique-move dedup — O(R·C·8)$(RESET)\n\n"; \
	run_bench "KnightInWar/knight_in_war" "KnightInWar/input1.txt" "KnightInWar/expected1.txt" "Sample cases (3x3 and 2x2 grid)"; \
	run_bench "KnightInWar/knight_in_war" "KnightInWar/input2.txt" "KnightInWar/expected2.txt" "M==N edge cases"; \
	run_bench "KnightInWar/knight_in_war" "KnightInWar/input3.txt" "KnightInWar/expected3.txt" "M==0 / N==0 edge cases"; \
	printf "\n$(BOLD)$(CYAN)──────────────────────────────────────────────────────────────$(RESET)\n"; \
	if [ $$pass_count -eq $$total_count ]; then \
		printf "$(BOLD)  SUMMARY: $(GREEN)%d / %d PASSED$(RESET)\n" $$pass_count $$total_count; \
	else \
		printf "$(BOLD)  SUMMARY: $(RED)%d / %d PASSED (%d FAILED)$(RESET)\n" $$pass_count $$total_count $$((total_count - pass_count)); \
	fi; \
	printf "  $(DIM)Slowest Test case: %s (%.2f ms)$(RESET)\n" "$$slowest_label" "$$slowest_time"; \
	printf "  $(DIM)Total Benchmark Execution Time: %.2f ms$(RESET)\n" "$$total_time"; \
	printf "$(BOLD)$(CYAN)══════════════════════════════════════════════════════════════$(RESET)\n\n"

clean:
	@rm -f $(BINARIES) *.o */*.o
	@rm -rf __pycache__ */__pycache__
