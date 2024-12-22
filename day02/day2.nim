import sequtils, strutils

proc findError(data: seq[int]): int =
    let increasing = data[0] < data[1]
    var i = 0
    while i < data.len() - 1:
        let diff = data[i + 1] - data[i]
        if increasing != (diff > 0):
            break
        if abs(diff) > 3 or abs(diff) < 1:
            break
        inc(i)
    return i

proc day2p1*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let data = line.splitWhitespace().map(proc(x: string): int = x.parseInt())
        if findError(data) == data.len() - 1:
            inc(total)
    return $total

proc day2p2*(input: string): string =
    var total = 0
    for line in input.splitLines():
        let data = line.splitWhitespace().map(proc(x: string): int = x.parseInt())
        let firstTry = findError(data)
        if firstTry == data.len() - 1:
            inc(total)
        else:
            for di in countup(0, firstTry + 1):
                var temp = data
                temp.delete(di..di)
                if findError(temp) == temp.len() - 1:
                    inc(total)
                    break
    return $total
