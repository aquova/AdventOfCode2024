import sequtils, strutils, tables
import ../utils/vec2

type GridItem = enum
    EMPTY
    WALL
    LEFT_BOX
    RIGHT_BOX

type Puzzle = object
    pos: Point
    grid: seq[seq[GridItem]]

proc parsePuzzle(input: string, wide: bool): Puzzle =
    let lines = input.splitLines()
    for y in 0..<lines.len():
        var row: seq[GridItem]
        for x in 0..<lines[y].len():
            let c = lines[y][x]
            let item = case c
                of '#': WALL
                of '.': EMPTY
                of 'O': LEFT_BOX
                else:
                    let mult = if wide: 2 else: 1
                    result.pos = newPoint(mult * x, y)
                    EMPTY
            row.add(item)
            if wide:
                if item == LEFT_BOX:
                    row.add(RIGHT_BOX)
                else:
                    row.add(item)
        result.grid.add(row)

proc parseDirections(input: string): seq[Direction] =
    const PARSE = {'v': SOUTH, '<': WEST, '>': EAST, '^': NORTH}.toTable()
    let single = input.replace("\n")
    result = single.items().toSeq().map(proc(x: char): Direction = PARSE[x])

proc `$`(puzzle: Puzzle): string =
    for y in 0..<puzzle.grid.len():
        var row = ""
        for x in 0..<puzzle.grid[y].len():
            let c = if puzzle.pos == (x, y):
                "@"
            else:
                case puzzle.grid[y][x]
                    of WALL: "#"
                    of EMPTY: "."
                    of LEFT_BOX: "["
                    of RIGHT_BOX: "]"
            row &= c
        result &= row & "\n"

proc move(puzzle: var Puzzle, d: Direction) =
    let delta = getDelta(d)
    let next_pos = puzzle.pos + delta
    let next = puzzle.grid[next_pos]
    case next
        of WALL: return
        of EMPTY: puzzle.pos = next_pos
        else:
            var curr_pos = next_pos
            while true:
                curr_pos += delta
                if puzzle.grid[curr_pos] == WALL:
                    break
                elif puzzle.grid[curr_pos] == EMPTY:
                    puzzle.grid[curr_pos] = LEFT_BOX
                    puzzle.grid[next_pos] = EMPTY
                    puzzle.pos = next_pos
                    break

proc getPair(pt: Point, item: GridItem): Point =
    if item == LEFT_BOX: pt + (1, 0) else: pt + (-1, 0)

proc moveDouble(puzzle: var Puzzle, d: Direction) =
    let delta = getDelta(d)
    let next_pos = puzzle.pos + delta
    let next = puzzle.grid[next_pos]
    case next
        of WALL: return
        of EMPTY: puzzle.pos = next_pos
        of LEFT_BOX, RIGHT_BOX:
            if d == WEST or d == EAST:
                var curr_pos = next_pos
                while true:
                    curr_pos += delta
                    if puzzle.grid[curr_pos] == WALL:
                        break
                    elif puzzle.grid[curr_pos] == EMPTY:
                        puzzle.grid[curr_pos.y].delete(curr_pos.x)
                        puzzle.grid[next_pos.y].insert(EMPTY, next_pos.x)
                        puzzle.pos = next_pos
                        break
            else:
                var stack, checked = @[next_pos]
                while stack.len() > 0:
                    let curr = stack.pop()
                    if puzzle.grid[curr] == WALL:
                        return
                    elif puzzle.grid[curr] == EMPTY:
                        continue

                    let pair = getPair(curr, puzzle.grid[curr])
                    checked.add(curr)
                    stack.add(curr + delta)
                    if pair notin checked:
                        checked.add(pair)
                        stack.add(pair + delta)

                if d == NORTH:
                    for y in 0..<puzzle.pos.y:
                        for x in 0..<puzzle.grid[0].len():
                            let pt = (x, y)
                            if pt in checked:
                                let other = pt + delta
                                swap(puzzle.grid[pt.y][pt.x], puzzle.grid[other.y][other.x])
                else:
                    for y in countdown(puzzle.grid.len() - 1, puzzle.pos.y - 1):
                        for x in 0..<puzzle.grid[0].len():
                            let pt = (x, y)
                            if pt in checked:
                                let other = pt + delta
                                swap(puzzle.grid[pt.y][pt.x], puzzle.grid[other.y][other.x])
                puzzle.pos = next_pos

proc calcScore(puzzle: Puzzle): int =
    for y in 0..<puzzle.grid.len():
        for x in 0..<puzzle.grid[y].len():
            if puzzle.grid[y][x] == LEFT_BOX:
                result += 100 * y + x

proc day15p1*(input: string): string =
    let sections = input.split("\n\n")
    var puzzle = sections[0].parsePuzzle(false)
    let directions = sections[1].parseDirections()
    for d in directions:
        puzzle.move(d)
    return $puzzle.calcScore()

proc day15p2*(input: string): string =
    let sections = input.split("\n\n")
    var puzzle = sections[0].parsePuzzle(true)
    let directions = sections[1].parseDirections()
    for d in directions:
        puzzle.moveDouble(d)
    return $puzzle.calcScore()
