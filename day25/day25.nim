import sequtils, strutils

type Puzzle = object
    locks, keys: seq[seq[int]]
    height: int

proc parseInput(input: string): Puzzle =
    for b in input.split("\n\n"):
        let lines = b.splitLines()
        if result.height == 0: result.height = lines.len() - 2
        if lines[0][0] == '#':
            var lock: seq[int]
            for x in 0..<lines[0].len():
                for y in 0..<lines.len():
                    if lines[y][x] == '.':
                        lock.add(y - 1)
                        break
            result.locks.add(lock)
        else:
            var key: seq[int]
            for x in 0..<lines[0].len():
                for y in countdown(lines.len() - 1, 0):
                    if lines[y][x] == '.':
                        key.add(result.height - y)
                        break
            result.keys.add(key)

proc day25p1*(input: string): string =
    let puzzle = input.parseInput()
    var cnt = 0
    for key in puzzle.keys:
        for locks in puzzle.locks:
            var valid = true
            for (k, l) in zip(key, locks):
                if k + l > puzzle.height:
                    valid = false
                    break
            if valid: inc(cnt)
    return $cnt

proc day25p2*(input: string): string =
    return "Merry Christmas"
