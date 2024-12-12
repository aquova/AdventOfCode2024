import sequtils, strutils
import ../utils/vec2

type Grid = seq[seq[char]]

proc parseInput(input: string): Grid =
    for line in input.splitLines():
        result.add(line.items.toSeq())

proc floodFill(grid: Grid, p: Point, target: char, checked: var seq[Point]) =
    for n in p.neighbors:
        if n.inBounds(grid) and n notin checked and grid[n] == target:
            checked.add(n)
            floodFill(grid, n, target, checked)

proc calcPerimeter(pts: seq[Point]): int =
    for pt in pts:
        var cnt = 4
        for n in pt.neighbors:
            if n in pts:
                dec(cnt)
        result += cnt

proc calcSides(pts: seq[Point]): int =
    const PAIRS = [(NORTH, EAST), (EAST, SOUTH), (SOUTH, WEST), (WEST, NORTH)]
    # Number of sides == Number of corners
    for pt in pts:
        for (a, b) in PAIRS:
            let na = pt + a.getDelta()
            let nb = pt + b.getDelta()
            if na notin pts and nb notin pts:
                inc(result)
            elif na in pts and nb in pts:
                let diag = pt + a.getDelta() + b.getDelta()
                if diag notin pts:
                    inc(result)

proc getGroups(grid: Grid): seq[seq[Point]] =
    var visited: seq[Point]
    for y in 0..<grid.len():
        for x in 0..<grid.len():
            let pt = newPoint(x, y)
            if pt notin visited:
                var group = @[pt]
                floodFill(grid, pt, grid[pt], group)
                result.add(group)
                visited = visited.concat(group)

proc day12p1*(input: string): string =
    let grid = input.parseInput()
    let groups = grid.getGroups()
    var total = 0
    for group in groups:
        let perimeter = group.calcPerimeter()
        total += group.len() * perimeter
    return $total

proc day12p2*(input: string): string =
    let grid = input.parseInput()
    let groups = grid.getGroups()
    var total = 0
    for group in groups:
        let sides = group.calcSides()
        total += group.len() * sides
    return $total
