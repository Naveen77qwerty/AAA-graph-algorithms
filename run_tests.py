import subprocess, os, sys

base = '/home/renegader/Documents/AAA/Team-7 Lab eval-2/AAA-graph-algorithms'
tests = [
    ('DarkRoads/dark_roads', 'DarkRoads/input1.txt', 'DR-Test1', 'DarkRoads/expected1.txt'),
    ('DarkRoads/dark_roads', 'DarkRoads/input2.txt', 'DR-Test2', 'DarkRoads/expected2.txt'),
    ('DarkRoads/dark_roads', 'DarkRoads/input3.txt', 'DR-Test3', 'DarkRoads/expected3.txt'),
    ('PlayOnWords/play_on_words', 'PlayOnWords/input1.txt', 'PW-Test1', 'PlayOnWords/expected1.txt'),
    ('PlayOnWords/play_on_words', 'PlayOnWords/input2.txt', 'PW-Test2', 'PlayOnWords/expected2.txt'),
    ('PlayOnWords/play_on_words', 'PlayOnWords/input3.txt', 'PW-Test3', 'PlayOnWords/expected3.txt'),
    ('KnightInWar/knight_in_war', 'KnightInWar/input1.txt', 'KW-Test1', 'KnightInWar/expected1.txt'),
    ('KnightInWar/knight_in_war', 'KnightInWar/input2.txt', 'KW-Test2', 'KnightInWar/expected2.txt'),
    ('KnightInWar/knight_in_war', 'KnightInWar/input3.txt', 'KW-Test3', 'KnightInWar/expected3.txt'),
]

all_pass = True
for binary, inp, label, exp_path in tests:
    binary_full = os.path.join(base, binary)
    inp_full = os.path.join(base, inp)
    exp_full = os.path.join(base, exp_path)

    with open(inp_full) as f:
        inp_data = f.read()

    r = subprocess.run([binary_full], input=inp_data, capture_output=True, text=True, timeout=5)
    actual = r.stdout.strip()

    if os.path.exists(exp_full):
        with open(exp_full) as f:
            expected = f.read().strip()
        status = 'PASS' if actual == expected else 'FAIL'
    else:
        expected = '(missing)'
        status = 'NO-EXP'

    print(f'[{status}] {label}')
    print(f'  actual:   {repr(actual)}')
    if status != 'PASS':
        print(f'  expected: {repr(expected)}')
        all_pass = False

print()
print('All PASS!' if all_pass else 'Some tests FAILED - check output above')
