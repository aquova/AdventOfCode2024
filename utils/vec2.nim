import tables

type Vector2* = tuple
    x, y: int

type Point* = Vector2

type Direction* = enum
    NORTH, SOUTH, EAST, WEST

const LEFT* = {
    NORTH: WEST, WEST: SOUTH, SOUTH: EAST, EAST: NORTH
}.toTable

const RIGHT* = {
    NORTH: EAST, EAST: SOUTH, SOUTH: WEST, WEST: NORTH
}.toTable

const DELTA*: Table[Direction, Point] = {
    NORTH: (0, -1), SOUTH: (0, 1), EAST: (1, 0), WEST: (-1, 0)
}.toTable

const ZERO*: Point = (0, 0)

proc newPoint*(x, y: int): Point =
    result.x = x
    result.y = y

proc x*(p: Point): int {.inline.} =
    return p.x

proc y*(p: Point): int {.inline.} =
    return p.y

proc `+`*(a, b: Point): Point =
    return (a.x + b.x, a.y + b.y)

proc `+=`*(a: var Point, b: Point) =
    a = a + b

proc `-`*(a, b: Point): Point =
    return (a.x - b.x, a.y - b.y)

proc `-=`*(a: var Point, b: Point) =
    a = a - b

proc `*`*(a: Point, v: int): Point =
    return (a.x * v, a.y * v)

proc `*`*(v: int, a: Point): Point =
    return a * v

proc `*=`*(a: var Point, v: int) =
    a = a * v

proc manhattan*(a: Point, b: Point): int =
    return abs(a.x - b.x) + abs(a.y - b.y)

iterator neighbors*(p: Point): Point =
    for direction in Direction.items:
        yield p + DELTA[direction]
