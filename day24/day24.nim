import options, strscans, strutils, tables

type Op = tuple
    gateA, op, gateB: string

proc parseInitial(lines: string): Table[string, Option[bool]] =
    for line in lines.splitLines():
        let (success, name, val) = line.scanTuple("$w: $i")
        if success:
            result[name] = some(val == 1)

proc parseGates(lines: string, values: var Table[string, Option[bool]], ops: var Table[string, Op]) =
    for line in lines.splitLines():
        let (success, gateA, op, gateB, gateC) = line.scanTuple("$w $w $w -> $w")
        if success:
            values[gateC] = none(bool)
            ops[gateC] = (gateA, op, gateB)

proc solve(gates: var Table[string, Option[bool]], ops: Table[string, Op]): bool =
    result = true
    for gate, value in gates.mpairs():
        if value.isSome():
            continue
        let (a, op, b) = ops[gate]
        if gates[a].isSome() and gates[b].isSome():
            case op:
                of "AND":
                    gates[gate] = some(gates[a].get() and gates[b].get())
                of "OR":
                    gates[gate] = some(gates[a].get() or gates[b].get())
                of "XOR":
                    gates[gate] = some(gates[a].get() xor gates[b].get())
                else: discard
        else:
            result = false

proc combineZs(gates: Table[string, Option[bool]]): int =
    var idx = 0
    var value = ""
    while true:
        let gate = "z" & align($idx, 2, '0')
        if gates.contains(gate):
            let bit = if gates[gate].get(): "1" else: "0"
            value = bit & value
            inc(idx)
        else:
            break
    return value.parseBinInt()

proc day24p1*(input: string): string =
    let sections = input.split("\n\n")
    var gateValues = sections[0].parseInitial()
    var ops: Table[string, Op]
    parseGates(sections[1], gateValues, ops)
    while not solve(gateValues, ops):
        discard
    return $gateValues.combineZs()

proc day24p2*(input: string): string =
    discard
