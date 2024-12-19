import strutils, tables

proc checkTowel(target: string, idx: int, towels: seq[string], checked: var Table[int, int]): int =
    if idx == target.len():
        return 1
    for t in towels:
        if idx in checked:
            return checked[idx]
        if target.substr(idx).startsWith(t):
            result += checkTowel(target, idx + t.len(), towels, checked)
    checked[idx] = result

proc day19p1*(input: string): string =
    let sections = input.split("\n\n")
    let towels = sections[0].split(", ")
    var cnt = 0
    for line in sections[1].splitLines():
        var checked: Table[int, int]
        if checkTowel(line, 0, towels, checked) > 0:
            inc(cnt)
    return $cnt

proc day19p2*(input: string): string =
    let sections = input.split("\n\n")
    let towels = sections[0].split(", ")
    var cnt = 0
    for line in sections[1].splitLines():
        var checked: Table[int, int]
        cnt += checkTowel(line, 0, towels, checked)
    return $cnt
