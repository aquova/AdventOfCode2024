import math, sequtils, strutils, tables

const P1_BLINKS = 25
const P2_BLINKS = 75

proc parseInput(input: string): CountTable[int] =
    return input.split(' ').map(proc(x: string): int = x.parseInt()).toCountTable()

proc splitInt(x: string): (int, int) =
    let mid = floorDiv(x.len(), 2)
    let left = substr(x, 0, mid - 1).parseInt()
    let right = substr(x, mid).parseInt()
    return (left, right)

proc sum(ct: CountTable[int]): int =
    for v in ct.values():
        result += v

proc blink(stones: CountTable[int]): CountTable[int] =
    for k, v in stones.pairs():
        let str = $k
        if k == 0:
            result.inc(1, v)
        elif str.len() mod 2 == 0:
            let (left, right) = str.splitInt()
            result.inc(left, v)
            result.inc(right, v)
        else:
            result.inc(k * 2024, v)

proc day11p1*(input: string): string =
    var stones = input.parseInput()
    for _ in countup(1, P1_BLINKS):
        stones = stones.blink()
    return $stones.sum()

proc day11p2*(input: string): string =
    var stones = input.parseInput()
    for _ in countup(1, P2_BLINKS):
        stones = stones.blink()
    return $stones.sum()
