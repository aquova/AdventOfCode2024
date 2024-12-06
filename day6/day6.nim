import sequtils, strutils
import ../utils/vec2

type Puzzle = object
    pos: Point
    facing: Direction
    grid: seq[seq[bool]]

type PosInfo = tuple
    pos: Point
    facing: Direction

proc parseInput(input: string): Puzzle =
    result.facing = Direction.NORTH # I think this is always the case
    let rows = input.splitLines()
    for y in countup(0, rows.len - 1):
        var row: seq[bool]
        for x in countup(0, rows[y].len - 1):
            let char = rows[y][x]
            row.add(char == '#')
            if char == '^':
                result.pos = newPoint(x, y)
        result.grid.add(row)

proc findVisited(puzzle: var Puzzle): seq[Point] =
    while true:
        result.add(puzzle.pos)
        let next_p = puzzle.pos + getDelta(puzzle.facing)
        if not next_p.inBounds(puzzle.grid):
            break
        if puzzle.grid[next_p]:
            puzzle.facing = turnRight(puzzle.facing)
        else:
            puzzle.pos = next_p
    result = result.deduplicate()

proc hasCycle(puzzle: var Puzzle): bool =
    var visited: seq[PosInfo]
    while true:
        let next_p = puzzle.pos + getDelta(puzzle.facing)
        if not next_p.inBounds(puzzle.grid):
            return false
        if puzzle.grid[next_p]:
            let info = (puzzle.pos, puzzle.facing)
            if info in visited:
                return true
            visited.add(info)
            puzzle.facing = turnRight(puzzle.facing)
        else:
            puzzle.pos = next_p

proc day6p1*(input: string): string =
    var puzzle = parseInput(input)
    let visited = puzzle.findVisited()
    return $visited.len()

proc day6p2*(input: string): string =
    var puzzle = parseInput(input)
    var virginPuzzle = puzzle
    let pointsToCheck = virginPuzzle.findVisited()
    var total = 0
    for point in pointsToCheck:
        var puzzleCopy = puzzle
        puzzleCopy.grid[point] = true
        if puzzleCopy.hasCycle():
            inc(total)
    return $total
