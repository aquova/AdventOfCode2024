import math, options, strscans, strutils

const A_COST = 3
const B_COST = 1
const P2_OFFSET = 10000000000000

type Machine = tuple
    x1, x2, x3, y1, y2, y3: int64

proc solveA(m: Machine, b: int): Option[int] =
    let tmp = (m.y3 - b * m.y2) / m.y1
    if tmp > 0 and tmp.round() == tmp:
        some(tmp.toInt())
    else:
        none(int)

proc solveB(m: Machine): Option[int] =
    let numer = m.x3 * m.y1 - m.x1 * m.y3
    let denom = m.x2 * m.y1 - m.x1 * m.y2
    let tmp = numer / denom
    if tmp > 0 and tmp.round() == tmp:
        some(tmp.toInt())
    else:
        none(int)

proc parseInput(input: string, p2: bool): seq[Machine] =
    for b in input.split("\n\n"):
        let (success, x1, y1, x2, y2, x3, y3) = b.scanTuple("Button A: X+$i, Y+$i\nButton B: X+$i, Y+$i\nPrize: X=$i, Y=$i")
        if success:
            let offset = if p2: P2_OFFSET else: 0
            result.add((cast[int64](x1), cast[int64](x2), cast[int64](x3) + offset, cast[int64](y1), cast[int64](y2), cast[int64](y3) + offset))

proc day13p1*(input: string): string =
    var total = 0
    let machines = input.parseInput(false)
    for m in machines:
        let b = m.solveB()
        if b.isSome():
            let a = m.solveA(b.get())
            if a.isSome():
                total += A_COST * a.get() + B_COST * b.get()
    return $total

proc day13p2*(input: string): string =
    var total = 0
    let machines = input.parseInput(true)
    for m in machines:
        let b = m.solveB()
        if b.isSome():
            let a = m.solveA(b.get())
            if a.isSome():
                total += A_COST * a.get() + B_COST * b.get()
    return $total
