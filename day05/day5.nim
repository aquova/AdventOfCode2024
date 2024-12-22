import math, parseutils, sequtils, strscans, strutils, tables

type RuleTable = Table[int, seq[int]]

proc parseRules(input: string): RuleTable =
    for line in input.splitLines():
        let (success, first, second) = line.scanTuple("$i|$i")
        if success:
            if not result.hasKey(first):
                result[first] = @[second]
            else:
                result[first].add(second)

proc parsePages(input: string): seq[seq[int]] =
    for line in input.splitLines():
        let row = line.split(',').map(proc(c: string): int = c.parseInt())
        result.add(row)

proc isValid(pages: seq[int], rules: RuleTable): bool =
    for i in countdown(pages.len - 1, 1):
        let page = pages[i]
        if not rules.hasKey(page):
            continue
        let rule = rules[page]
        for j in countdown(i - 1, 0):
            if pages[j] in rule:
                return false
    return true

proc correctPages(pages: var seq[int], rules: RuleTable) =
    var i = pages.len - 1
    while i > 0:
        let page = pages[i]
        if not rules.hasKey(page):
            dec(i)
            continue
        let rule = rules[page]
        var swapped = false
        for j in countdown(i - 1, 0):
            if pages[j] in rule:
                swapped = true
                swap(pages[i], pages[j])
        if not swapped:
            dec(i)

proc day5p1*(input: string): string =
    var total = 0
    let sections = input.split("\n\n")
    let rules = parseRules(sections[0])
    let pages = parsePages(sections[1])
    for item in pages:
        if item.isValid(rules):
            let mid = floorDiv(item.len(), 2)
            total += item[mid]
    return $total

proc day5p2*(input: string): string =
    var total = 0
    let sections = input.split("\n\n")
    let rules = parseRules(sections[0])
    var pages = parsePages(sections[1])
    for item in pages.mitems:
        if not item.isValid(rules):
            item.correctPages(rules)
            let mid = floorDiv(item.len(), 2)
            total += item[mid]
    return $total
