import sequtils, strutils, ../utils/vec2

type Grid = seq[seq[char]]

const XMAS = ['X', 'M', 'A', 'S']

proc parseInput(input: string): Grid =
    for line in input.splitLines():
        result.add(line.items().toSeq())

proc day4p1*(input: string): string =
    var total = 0
    let grid = parseInput(input)
    for y in countup(0, grid.len() - 1):
        for x in countup(0, grid[0].len() - 1):
            let start = newPoint(x, y)
            for d in start.deltaEight():
                var found = true
                for i in countup(0, XMAS.len - 1):
                    let curr = start + i * d
                    if not curr.inBounds(grid) or grid[curr] != XMAS[i]:
                        found = false
                        break
                if found:
                    inc(total)
    return $total

proc day4p2*(input: string): string =
    var total = 0
    let grid = parseInput(input)
    for y in countup(0, grid.len - 1):
        for x in countup(0, grid[0].len - 1):
            let start = newPoint(x, y)
            if grid[start] != 'A':
                continue
            var tmpCnt = 0
            for d in start.deltaCross:
                let forward = start + d
                let behind = start - d
                if forward.inBounds(grid) and behind.inBounds(grid):
                    if grid[forward] == 'M' and grid[behind] == 'S':
                        inc(tmpCnt)
            if tmpCnt > 1:
                inc(total)
    return $total
