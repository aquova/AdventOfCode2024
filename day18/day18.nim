import deques, options, strscans, strutils, tables
import ../utils/vec2

const WIDTH = 71
const HEIGHT = 71
const P1_COUNT = 1024

proc parseInput(input: string): seq[Point] =
    for line in input.splitLines():
        let (_, x, y) = line.scanTuple("$i,$i")
        result.add(newPoint(x, y))

proc findGoal(walls: seq[Point]): Option[int] =
    let start = newPoint(0, 0)
    let goal = newPoint(WIDTH - 1, HEIGHT - 1)
    var queue: Deque[Point] = toDeque([start])
    var parents: Table[Point, Point]
    var found = false
    while queue.len() > 0:
        let curr = queue.popFirst()
        if curr == goal:
            found = true
            break

        for n in curr.neighbors:
            if parents.contains(n) or not n.inBounds(WIDTH, HEIGHT) or n in walls:
                continue
            queue.addLast(n)
            parents[n] = curr
    if found:
        var cnt = 0
        var curr = goal
        while curr != start:
            inc(cnt)
            curr = parents[curr]
        return some(cnt)
    else:
        return none(int)

proc day18p1*(input: string): string =
    let walls = input.parseInput()[0..<P1_COUNT]
    return $walls.findGoal().get()

proc day18p2*(input: string): string =
    let walls = input.parseInput()
    var left = 0
    var right = walls.high()

    while right - left > 5:
        var mid = left + ((right - left) / 2).toInt()
        if walls[0..mid].findGoal().isSome():
            left = mid
        else:
            right = mid

    for i in left..right:
        if walls[0..i].findGoal().isNone():
            return $walls[i]
