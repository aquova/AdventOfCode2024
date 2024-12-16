import heapqueue, options, sequtils, strutils, tables
import ../utils/vec2

const FORWARD_PENALTY = 1
const TURN_PENALTY = 1000 + FORWARD_PENALTY
const START_DIRECTION = EAST

type Player = tuple
    pos: Point
    facing: Direction

type Movement = tuple
    player: Player
    pts: int
    parents: seq[Point]

proc `<`(a, b: Movement): bool = a.pts < b.pts

type Puzzle = object
    start: Point
    goal: Point
    walls: seq[seq[bool]]

proc findGoal(p: Puzzle, findAll: bool): int =
    var queue = initHeapQueue[Movement]()
    var visited: Table[Player, int]
    var shortestValue = none(int)
    var shortestMembers: seq[Point]

    queue.push(((p.start, START_DIRECTION), 0, @[p.start]))
    while queue.len() > 0:
        let curr = queue.pop()
        if curr.player.pos == p.goal:
            if not findAll:
                return curr.pts
            if shortestValue.isNone():
                shortestValue = some(curr.pts)
            if curr.pts == shortestValue.get():
                shortestMembers.add(curr.parents)
        let forward_d = getDelta(curr.player.facing)
        let forward = curr.player.pos + forward_d
        if not p.walls[forward]:
            let player = (forward, curr.player.facing)
            let pts = curr.pts + FORWARD_PENALTY
            if not visited.contains(player) or pts <= visited[player]:
                let parents = curr.parents & forward
                queue.push((player, pts, parents))
                visited[player] = pts

        let left_d = getDelta(turnLeft(curr.player.facing))
        let left = curr.player.pos + left_d
        if not p.walls[left]:
            let player = (left, turnLeft(curr.player.facing))
            let pts = curr.pts + TURN_PENALTY
            if not visited.contains(player) or pts <= visited[player]:
                let parents = curr.parents & left
                queue.push((player, pts, parents))
                visited[player] = pts

        let right_d = getDelta(turnRight(curr.player.facing))
        let right = curr.player.pos + right_d
        if not p.walls[right]:
            let player = (right, turnRight(curr.player.facing))
            let pts = curr.pts + TURN_PENALTY
            if not visited.contains(player) or pts <= visited[player]:
                let parents = curr.parents & right
                queue.push((player, pts, parents))
                visited[player] = pts
    shortestMembers = shortestMembers.deduplicate()
    return shortestMembers.len()

proc parseInput(input: string): Puzzle =
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

proc day16p1*(input: string): string =
    let puzzle = input.parseInput()
    return $puzzle.findGoal(false)

proc day16p2*(input: string): string =
    let puzzle = input.parseInput()
    return $puzzle.findGoal(true)
