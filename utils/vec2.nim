import tables

type Vector2* = tuple
    x, y: int

type Point* = Vector2

type Direction* = enum
    NORTH, SOUTH, EAST, WEST, NORTHWEST, SOUTHWEST, NORTHEAST, SOUTHEAST

const ZERO*: Point = (0, 0)

const FOURWAY = [NORTH, SOUTH, EAST, WEST]

const CROSSWAY = [NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST]

const EIGHTWAY = [NORTH, SOUTH, EAST, WEST, NORTHWEST, SOUTHWEST, NORTHEAST, SOUTHEAST]

const LEFT = {
    NORTH: WEST, WEST: SOUTH, SOUTH: EAST, EAST: NORTH
}.toTable

const RIGHT = {
    NORTH: EAST, EAST: SOUTH, SOUTH: WEST, WEST: NORTH
}.toTable

const DELTA: Table[Direction, Point] = {
    NORTH: (0, -1), SOUTH: (0, 1), EAST: (1, 0), WEST: (-1, 0),
    NORTHWEST: (-1, -1), NORTHEAST: (1, -1), SOUTHEAST: (1, 1), SOUTHWEST: (-1, 1),
}.toTable

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

proc `[]`*[T](grid: seq[seq[T]], p: Point): T =
    return grid[p.y][p.x]

proc `[]=`*[T](grid: var seq[seq[T]], p: Point, val: T) =
    grid[p.y][p.x] = val

proc getDelta*(d: Direction): Point =
    DELTA[d]

proc turnLeft*(d: Direction): Direction =
    LEFT[d]

proc turnRight*(d: Direction): Direction =
    RIGHT[d]

proc inBounds*(p: Point, w: int, h: int): bool =
    return p.x >= 0 and p.y >= 0 and p.y < h and p.x < w

proc inBounds*[T](p: Point, grid: seq[seq[T]]): bool =
    return inBounds(p, grid.len(), grid[0].len())

proc manhattan*(a: Point, b: Point): int =
    return abs(a.x - b.x) + abs(a.y - b.y)

iterator delta*(p: Point): Vector2 =
    for direction in FOURWAY:
        yield DELTA[direction]

iterator neighbors*(p: Point): Point =
    for d in p.delta:
        yield p + d

iterator deltaEight*(p: Point): Vector2 =
    for direction in EIGHTWAY:
        yield DELTA[direction]

iterator neighborsEight*(p: Point): Point =
    for d in p.deltaEight:
        yield p + d

iterator deltaCross*(p: Point): Vector2 =
    for direction in CROSSWAY:
        yield DELTA[direction]

iterator neighborsCross*(p: Point): Point =
    for d in p.delta:
        yield p + d

