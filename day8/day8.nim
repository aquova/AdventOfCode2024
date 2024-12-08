import strutils, tables
import ../utils/vec2

type NodeTable = Table[char, seq[Point]]

proc parseInput(lines: seq[string]): NodeTable =
    for y in 0..<lines.len():
        for x in 0..<lines[y].len():
            let c = lines[y][x]
            if c == '.':
                continue
            if not result.hasKey(c):
                result[c] = @[newPoint(x, y)]
            else:
                result[c].add(newPoint(x, y))

proc day8p1*(input: string): string =
    let lines = input.splitLines()
    let height = lines.len()
    let width = lines[0].len()
    let nodes = lines.parseInput()
    var pts: seq[Point]
    for points in nodes.values():
        for i in 0..<(points.len() - 1):
            for j in (i + 1)..<points.len():
                let delta = points[i] - points[j]
                let p1 = points[i] + delta
                if p1 notin pts and p1.inBounds(width, height):
                    pts.add(p1)
                let p2 = points[j] - delta
                if p2 notin pts and p2.inBounds(width, height):
                    pts.add(p2)
    return $pts.len()

proc day8p2*(input: string): string =
    let lines = input.splitLines()
    let height = lines.len()
    let width = lines[0].len()
    let nodes = lines.parseInput()
    var pts: seq[Point]
    for points in nodes.values():
        for i in 0..<(points.len() - 1):
            for j in (i + 1)..<points.len():
                let delta = points[i] - points[j]
                var curr = points[i]
                while curr.inBounds(width, height):
                    if curr notin pts:
                        pts.add(curr)
                    curr += delta
                curr = points[j]
                while curr.inBounds(width, height):
                    if curr notin pts:
                        pts.add(curr)
                    curr -= delta
    return $pts.len()
