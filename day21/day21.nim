import algorithm, strutils, tables
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

proc keepSmallest(tbl: var seq[string]) =
    var output: seq[string]
    var best = tbl[0].len()
    for str in tbl:
        let len = str.len()
        if len == best:
            output.add(str)
        elif len < best:
            best = len
            output = @[str]
    tbl = output

proc isValid(arrows: seq[char], start, blank: Point): bool =
    const d = {'^': (0, -1), 'v': (0, 1), '<': (-1, 0), '>': (1, 0)}.toTable()
    var curr = start
    for a in arrows:
        curr += d[a]
        if curr == blank:
            return false
    return true

proc getPermutations(start, stop, blank: Point, cache: var Table[(Point, Point), seq[string]]): seq[string] =
    if cache.hasKey((start, stop)):
        return cache[(start, stop)]
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
        result.add($chars & "A")
    while chars.nextPermutation():
        if chars.isValid(start, blank):
            result.add($chars & "A")
    cache[(start, stop)] = result

proc solve(lines: seq[string], tbl: Table[char, Point], blank: Point): seq[string] =
    var cache: Table[(Point, Point), seq[string]]
    for line in lines:
        let input = 'A' & line
        var possibilities = @[""]
        for i in 0..input.len() - 2:
            var next: seq[string]
            let perms = getPermutations(tbl[input[i]], tbl[input[i + 1]], blank, cache)
            for p in perms:
                for po in possibilities:
                    next.add(po & p)
            possibilities = next
        result.add(possibilities)
    result.keepSmallest()

proc day21p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        var arrows = solve(@[line], NUMERIC_TABLE, NUMERIC_TABLE['X'])
        for _ in countup(1, P1_NUM_ROBOTS):
            arrows = solve(arrows, ARROW_TABLE, ARROW_TABLE['X'])
        let code = line[0..^2].parseInt()
        total += code * arrows[0].len()
    return $total

proc day21p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        var arrows = solve(@[line], NUMERIC_TABLE, NUMERIC_TABLE['X'])
        for _ in countup(1, P2_NUM_ROBOTS):
            arrows = solve(arrows, ARROW_TABLE, ARROW_TABLE['X'])
            echo(arrows[0].len())
        let code = line[0..^2].parseInt()
        total += code * arrows[0].len()
    return $total
