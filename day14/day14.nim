import math, sequtils, strscans, strutils
import os
import ../utils/vec2

const NUM_ROUNDS = 100
const WIDTH = 101
const HEIGHT = 103
# const WIDTH = 11
# const HEIGHT = 7

type Robot = object
    pos: Point
    vel: Vector2

proc wrap(v: int, max: int): int =
    if v < 0:
        v + max
    elif v >= max:
        v - max
    else:
        v

proc move(r: var Robot) =
    r.pos += r.vel
    r.pos.x = r.pos.x.wrap(WIDTH)
    r.pos.y = r.pos.y.wrap(HEIGHT)

proc countQuads(robots: seq[Robot]): int =
    var quads = (nw: 0, ne: 0, sw: 0, se: 0)
    let mid_x = floorDiv(WIDTH, 2)
    let mid_y = floorDiv(HEIGHT, 2)
    for robot in robots:
        if robot.pos.x < mid_x and robot.pos.y < mid_y:
            inc(quads.nw)
        elif robot.pos.x < mid_x and robot.pos.y > mid_y:
            inc(quads.ne)
        elif robot.pos.x > mid_x and robot.pos.y < mid_y:
            inc(quads.sw)
        elif robot.pos.x > mid_x and robot.pos.y > mid_y:
            inc(quads.se)
    quads.ne * quads.nw * quads.se * quads.sw

proc parseInput(input: string): seq[Robot] =
    for line in input.splitLines():
        let (success, x, y, dx, dy) = line.scanTuple("p=$i,$i v=$i,$i")
        if success:
            result.add(Robot(pos: newPoint(x, y), vel: newVec2(dx, dy)))

proc print(robots: seq[Robot]) =
    var grid = sequtils.repeat(repeat('.', WIDTH), HEIGHT)
    for r in robots:
        grid[r.pos.y][r.pos.x] = '#'
    for row in grid:
        echo(row)

proc day14p1*(input: string): string =
    var robots = input.parseInput()
    for _ in countup(1, NUM_ROUNDS):
        for robot in robots.mitems():
            robot.move()
    return $robots.countQuads()

proc day14p2*(input: string): string =
    var robots = input.parseInput()
    var i = 1
    # I ended up solving this one manually.
    # I printed out the grid after each iteration and noticed a grouping every HEIGHT iterations starting at some offset
    # Then only print the grid at those iterations and waited for the pattern to appear
    while true:
        for robot in robots.mitems():
            robot.move()
        if (i - 65) mod HEIGHT == 0:
            robots.print()
            echo(i)
            sleep(100)
        inc(i)
