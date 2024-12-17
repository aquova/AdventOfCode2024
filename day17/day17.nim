import math, sequtils, strscans, strutils

type Machine = object
    PC, A, B, C: int
    ops: seq[int]

proc parseInput(input: string): Machine =
    result.PC = 0
    let sections = input.split("\n\n")
    let (success, a, b, c) =  sections[0].scanTuple("Register A: $i\nRegister B: $i\nRegister C: $i")
    if success:
        result.A = a
        result.B = b
        result.C = c
    let ops = sections[1].split(' ')[1].split(',').map(proc(x: string): int = x.parseInt())
    result.ops = ops

proc isRunning(m: Machine): bool = m.PC < m.ops.len()

proc getComboOperand(m: Machine, literal: int): int =
    result = case literal
        of 0..3: literal
        of 4: m.A
        of 5: m.B
        of 6: m.C
        else: -1

proc execute(m: var Machine, output: var seq[int]) =
    let opcode = m.ops[m.PC]
    let literal = m.ops[m.PC + 1]
    let combo = m.getComboOperand(literal)
    m.PC += 2

    case opcode
        of 0: m.A = m.A shr combo
        of 1: m.B = m.B xor literal
        of 2: m.B = combo and 0b111
        of 3:
            if m.A != 0: m.PC = literal
        of 4: m.B = m.B xor m.C
        of 5: output.add(combo and 0b111)
        of 6: m.B = m.A shr combo
        of 7: m.C = m.A shr combo
        else: discard

proc day17p1*(input: string): string =
    var machine = input.parseInput()
    var output: seq[int]
    while machine.isRunning():
        machine.execute(output)
    return output.join(",")

proc step(a: int): int =
    var b = a and 0b111
    b = b xor 5
    let c = a shr b
    b = b xor 6
    b = b xor c
    return b and 0b111

proc day17p2*(input: string): string =
    # Might as well hardcode the input since this function only works on it
    let data = [2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0]
    var valid = @[0]
    for i in countdown(data.high(), 0):
        var next: seq[int]
        for a in valid:
            for j in 0..<8:
                var input = 8 * a + j
                if input.step() == data[i]:
                    next.add(input)
        valid = next
    return $min(valid)
