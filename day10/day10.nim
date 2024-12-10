import sequtils, strutils
import ../utils/vec2

type Grid = seq[seq[int]]

proc parseInput(input: string): Grid =
    for line in input.splitLines():
        result.add(line.items().toSeq().map(proc(x: char): int = parseInt($x)))

proc scoreTrailhead(grid: Grid, p: Point, countPaths: bool): int =
    var stack: seq[Point]
    var found: seq[Point]
    stack.add(p)
    while stack.len() > 0:
        let curr = stack.pop()
        let val = grid[curr]
        if val == 9:
            if countPaths or curr notin found:
                found.add(curr)
            continue
        for n in curr.neighbors:
            if n.inBounds(grid) and grid[n] == val + 1:
                stack.add(n)
    return found.len()

proc day10p1*(input: string): string =
    let grid = input.parseInput()
    var total = 0
    for y in 0..<grid.len():
        for x in 0..<grid[y].len():
            let pt = newPoint(x, y)
            if grid[pt] == 0:
                total += scoreTrailhead(grid, pt, false)
    return $total

proc day10p2*(input: string): string =
    let grid = input.parseInput()
    var total = 0
    for y in 0..<grid.len():
        for x in 0..<grid[y].len():
            let pt = newPoint(x, y)
            if grid[pt] == 0:
                total += scoreTrailhead(grid, pt, true)
    return $total
