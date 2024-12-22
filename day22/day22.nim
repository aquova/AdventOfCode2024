import math, sequtils, strutils, tables
import ../utils/misc

const NUM_ITERATIONS = 2000

type BananaInfo = object
    bananas, diffs: seq[int]

proc parseInput(input: string): seq[int] =
    input.splitLines().map(proc(x: string): int = x.parseInt())

proc mod24(x: int): int {.inline.} = x and (1 shl 24 - 1)
proc peek[T](x: seq[T]): T {.inline.} = x[^1]

proc calcSecret(n: int): int =
    let a = n shl 6
    let b = n xor a
    let c = mod24(b)
    let d = c shr 5
    let e = c xor d
    let f = mod24(e)
    let g = f shl 11
    let h = f xor g
    return mod24(h)

proc getBananaInfo(num: int): BananaInfo =
    var n = num
    var bananas = @[n mod 10]
    var db: seq[int]
    for _ in countup(1, NUM_ITERATIONS):
        n = n.calcSecret()
        let last = bananas.peek()
        let ones = n mod 10
        bananas.add(ones)
        db.add(ones - last)
    return BananaInfo(bananas: bananas, diffs: db)

proc merge(main: var Table[seq[int], seq[int]], tmp: Table[seq[int], int]) =
    for k, v in tmp.pairs():
        main.tableSequenceAdd(k, v)

proc findBestSeq(info: seq[BananaInfo]): int =
    var market: Table[seq[int], seq[int]]
    for bi in info:
        var tmp: Table[seq[int], int]
        for i in 0..<bi.diffs.len() - 3:
            let k = bi.diffs[i..i + 3]
            let v = bi.bananas[i + 4]
            if not tmp.contains(k):
                tmp[k] = v
        market.merge(tmp)
    for v in market.values():
        result = max(result, v.sum)

proc day22p1*(input: string): string =
    let nums = input.parseInput()
    var sum = 0
    for num in nums:
        var n = num
        for _ in countup(1, NUM_ITERATIONS):
            n = n.calcSecret()
        sum += n
    return $sum

proc day22p2*(input: string): string =
    let nums = input.parseInput()
    var bananas: seq[BananaInfo]
    for num in nums:
        let info = num.getBananaInfo()
        bananas.add(info)
    return $bananas.findBestSeq()
