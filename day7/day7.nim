import math, sequtils, strutils

type Test = object
    target: int
    values: seq[int]

type Operator = enum
    ADD, MULT, CONCAT,

proc parseInput(input: string): seq[Test] =
    for line in input.splitLines():
        var test: Test
        let sections = line.split(": ")
        test.target = sections[0].parseInt()
        test.values = sections[1].split(' ').map(proc(x: string): int = x.parseInt())
        result.add(test)

proc operatorHelper(test: Test, idx: int, curr: int, op: Operator, allowConcat: bool): bool =
    let next = case op
        of Operator.ADD:
            curr + test.values[idx]
        of Operator.MULT:
            curr * test.values[idx]
        of Operator.CONCAT:
            let size = log10(test.values[idx].toFloat()).floor().toInt() + 1
            curr * (10 ^ size) + test.values[idx]
    if next > test.target:
        return false
    if idx + 1 == test.values.len():
        return next == test.target
    return operatorHelper(test, idx + 1, next, Operator.ADD, allowConcat) or operatorHelper(test, idx + 1, next, Operator.MULT, allowConcat) or (allowConcat and operatorHelper(test, idx + 1, next, Operator.CONCAT, allowConcat))

proc day7p1*(input: string): string =
    var total = 0
    let tests = input.parseInput()
    for test in tests:
        let start = test.values[0]
        if operatorHelper(test, 1, start, Operator.ADD, false) or operatorHelper(test, 1, start, Operator.MULT, false):
            total += test.target
    return $total

proc day7p2*(input: string): string =
    var total = 0
    let tests = input.parseInput()
    for test in tests:
        let start = test.values[0]
        if operatorHelper(test, 1, start, Operator.ADD, true) or operatorHelper(test, 1, start, Operator.MULT, true) or operatorHelper(test, 1, start, Operator.CONCAT, true):
            total += test.target
    return $total
