CXX := g++
CXXFLAGS := -O2 -std=c++17 -Wall

BINARIES := DarkRoads/dark_roads PlayOnWords/play_on_words KnightInWar/knight_in_war

.PHONY: all build test benchmark clean

all: build

build: clean
	@$(MAKE) --no-print-directory $(BINARIES)

DarkRoads/dark_roads: DarkRoads/dark_roads.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

PlayOnWords/play_on_words: PlayOnWords/play_on_words.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

KnightInWar/knight_in_war: KnightInWar/knight_in_war.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

test: build
	python3 run_tests.py

benchmark: build
	python3 benchmark.py --no-build

clean:
	rm -f $(BINARIES) *.o */*.o
	rm -rf __pycache__ */__pycache__
