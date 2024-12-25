import algorithm, options, strscans, strutils, tables

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

proc combineRegister(gates: Table[string, Option[bool]], reg: string): (int, int) =
    var idx = 0
    var value = ""
    while true:
        let gate = reg & align($idx, 2, '0')
        if gates.contains(gate):
            let bit = if gates[gate].get(): "1" else: "0"
            value = bit & value
            inc(idx)
        else:
            break
    return (value.parseBinInt(), idx - 1)

proc day24p1*(input: string): string =
    let sections = input.split("\n\n")
    var gateValues = sections[0].parseInitial()
    var ops: Table[string, Op]
    parseGates(sections[1], gateValues, ops)
    while not solve(gateValues, ops): discard
    return $gateValues.combineRegister("z")[0]

proc day24p2*(input: string): string =
    let sections = input.split("\n\n")
    var gateValues = sections[0].parseInitial()
    var ops: Table[string, Op]
    parseGates(sections[1], gateValues, ops)
    while not solve(gateValues, ops): discard
    let (_, maxZ) = gateValues.combineRegister("z")

    var wrong: seq[string]
    for output, op in ops.pairs():
        if op.op != "XOR" and output[0] == 'z' and output != "z" & $maxZ:
            # Only XOR can output to a Z register
            if output notin wrong:
                wrong.add(output)
        elif op.op == "XOR" and (op.gateA[0] notin ['x', 'y', 'z'] and op.gateB[0] notin ['x', 'y', 'z'] and output[0] notin ['x', 'y', 'z']):
            # XORs can only be involved with X, Y, or Z registers
            if output notin wrong:
                wrong.add(output)
        elif op.op == "OR":
            # Only AND can input into OR
            if op.gateA in ops and ops[op.gateA].op != "AND" and op.gateA notin wrong:
                let prev = ops[op.gateA]
                if prev.gateA[0] in ['x', 'y']:
                    wrong.add(op.gateA)
                    for key, value in ops.pairs():
                        if (value.gateA == prev.gateA or value.gateB == prev.gateA) and value.op != prev.op:
                            wrong.add(key)
            if op.gateB in ops and ops[op.gateB].op != "AND" and op.gateB notin wrong:
                let prev = ops[op.gateB]
                if prev.gateA[0] in ['x', 'y']:
                    wrong.add(op.gateB)
                    for key, value in ops.pairs():
                        if (value.gateA == prev.gateA or value.gateB == prev.gateA) and value.op != prev.op:
                            wrong.add(key)
    return wrong.sorted().join(",")
