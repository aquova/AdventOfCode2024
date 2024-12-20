import strutils
import ../utils/vec2

const THRESHOLD = 100
const P1_CHEAT_LEN = 2
const P2_CHEAT_LEN = 20

type Racetrack = object
    start, goal: Point
    walls: seq[seq[bool]]

proc parseInput(input: string): Racetrack =
    let lines = input.splitLines()
    for y in 0..<lines.len():
        var row: seq[bool]
        for x in 0..<lines[y].len():
            let c = lines[y][x]
            row.add(c == '#')
            if c == 'S':
                result.start = newPoint(x, y)
            elif c == 'E':
                result.goal = newPoint(x, y)
        result.walls.add(row)

proc getPath(r: Racetrack): seq[Point] =
    result.add(r.start)
    var curr = r.start
    while curr != r.goal:
        for n in curr.neighbors:
            if n notin result and not r.walls[n] and n.inBounds(r.walls):
                curr = n
                result.add(curr)
                break

proc checkCheat(pt: Point, idx: int, maxDist: int, path: seq[Point]): int =
    for i in idx + THRESHOLD..path.high():
        let dist = manhattan(pt, path[i])
        if dist <= maxDist and (i - idx - dist) >= THRESHOLD:
            inc(result)

proc day20p1*(input: string): string =
    let racetrack = input.parseInput()
    let path = racetrack.getPath()
    var total = 0
    for i in 0..path.high() - THRESHOLD:
        total += checkCheat(path[i], i, P1_CHEAT_LEN, path)
    return $total

proc day20p2*(input: string): string =
    let racetrack = input.parseInput()
    let path = racetrack.getPath()
    var total = 0
    for i in 0..path.high() - THRESHOLD:
        total += checkCheat(path[i], i, P2_CHEAT_LEN, path)
    return $total
