import algorithm, options, strutils, tables
import ../utils/vec2

const P1_NUM_ROBOTS = 2
const P2_NUM_ROBOTS = 25

const NUMERIC_TABLE: Table[char, Point] = {
    '7': (0, 0), '8': (1, 0), '9': (2, 0),
    '4': (0, 1), '5': (1, 1), '6': (2, 1),
    '1': (0, 2), '2': (1, 2), '3': (2, 2),
    'X': (0, 3), '0': (1, 3), 'A': (2, 3),
}.toTable()

const ARROW_TABLE: Table[char, Point] = {
    'X': (0, 0), '^': (1, 0), 'A': (2, 0),
    '<': (0, 1), 'v': (1, 1), '>': (2, 1),
}.toTable()

proc `$`(chars: seq[char]): string =
    for c in chars:
        result &= c

proc isValid(arrows: seq[char], start, blank: Point): bool =
    const d = {'^': (0, -1), 'v': (0, 1), '<': (-1, 0), '>': (1, 0)}.toTable()
    var curr = start
    for a in arrows:
        curr += d[a]
        if curr == blank:
            return false
    return true

proc getPermutations(start, stop, blank: Point, depth: int): seq[string] =
    let delta = stop - start
    let vertChar = if delta.y < 0: '^' else: 'v'
    let horzChar = if delta.x < 0: '<' else: '>'
    var chars: seq[char]
    # Favor doing left/down first
    if delta.x < 0 or delta.y < 0:
        for _ in 0..<abs(delta.x):
            chars.add(horzChar)
        for _ in 0..<abs(delta.y):
            chars.add(vertChar)
    else:
        for _ in 0..<abs(delta.y):
            chars.add(vertChar)
        for _ in 0..<abs(delta.x):
            chars.add(horzChar)
    chars.sort()
    if chars.isValid(start, blank):
        result.add($chars & 'A')
    while chars.nextPermutation():
        if chars.isValid(start, blank):
            result.add($chars & 'A')

proc solve(target: string, depth, maxDepth: int, cache: var Table[(Point, Point, int), int]): int =
    let tbl = if depth == 0: NUMERIC_TABLE else: ARROW_TABLE # Hackkkkk
    let input = 'A' & target
    for i in 0..<input.len() - 1:
        let ptA = tbl[input[i]]
        let ptB = tbl[input[i + 1]]
        if cache.contains((ptA, ptB, depth)):
            result += cache[(ptA, ptB, depth)]
            continue
        let perms = getPermutations(ptA, ptB, tbl['X'], depth)
        if depth == maxDepth:
            let len = perms[0].len()
            result += len
            cache[(ptA, ptB, depth)] = len
            continue
        var best = none(int)
        for p in perms:
            let next = solve(p, depth + 1, maxDepth, cache)
            if best.isNone() or next < best.get():
                best = some(next)
        cache[(ptA, ptB, depth)] = best.get()
        result += best.get()

proc day21p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        var cache: Table[(Point, Point, int), int]
        let smallest = solve(line, 0, P1_NUM_ROBOTS, cache)
        let code = line[0..^2].parseInt()
        total += code * smallest
    return $total

proc day21p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        var cache: Table[(Point, Point, int), int]
        let smallest = solve(line, 0, P2_NUM_ROBOTS, cache)
        let code = line[0..^2].parseInt()
        total += code * smallest
    return $total
