import algorithm, options, sequtils, strscans, strutils, tables
import ../utils/misc

type Connections = Table[string, seq[string]]

proc parseInput(input: string): Connections =
    for line in input.splitLines():
        let (success, left, right) = line.scanTuple("$w-$w")
        if success:
            result.tableSequenceAdd(left, right)
            result.tableSequenceAdd(right, left)

proc findTriplets(conns: Connections): seq[seq[string]] =
    let keys = conns.keys().toSeq()
    for i in 0..<keys.len() - 1:
        for j in i + 1..<keys.len():
            if keys[j] notin conns[keys[i]]:
                continue
            let common = conns[keys[i]] * conns[keys[j]]
            for c in common:
                let trip = @[keys[i], keys[j], c].sorted()
                if trip notin result:
                    result.add(trip)

proc findLargestHelper(nodes: seq[string], conns: Connections, rem: int): Option[seq[string]] =
    if rem == 0:
        let empty: seq[string] = @[]
        return some(empty)
    for k in nodes:
        var next: seq[string]
        for other in nodes:
            if k != other and other in conns[k]:
                next.add(other)
        let ret = findLargestHelper(next, conns, rem - 1)
        if ret.isSome():
            return some(ret.get() & k)
    return none(seq[string])

proc day23p1*(input: string): string =
    let connections = input.parseInput()
    let triplets = connections.findTriplets()
    let t = triplets.filter(proc(x: seq[string]): bool = x.any(proc(y: string): bool = y[0] == 't'))
    return $t.len()

proc day23p2*(input: string): string =
    let connections = input.parseInput()
    var largest = 0
    for v in connections.values():
        largest = max(largest, v.len())
    for i in countdown(largest, 1):
        let group = findLargestHelper(connections.keys().toSeq(), connections, i)
        if group.isSome():
            return group.get().sorted().join(",")
