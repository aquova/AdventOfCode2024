import options, sequtils, strutils, tables

type Filedata = object
    pos: int
    len: int

proc parseInput(input: string): seq[Option[int]] =
    var data = true
    var idx = 0
    for c in input:
        let len = parseInt($c)
        let val = if data:
            some(idx)
        else:
            none(int)
        let new = val.repeat(len)
        result.add(new)
        if data: inc(idx)
        data = not data

proc parseFiledata(input: string): (Table[int, Filedata], seq[Filedata]) =
    var
        data = true
        idx = 0
        pos = 0
        fileTable: Table[int, Filedata]
        emptySeq: seq[Filedata]
    for c in input:
        let len = parseInt($c)
        let next = Filedata(pos: pos, len: len)
        if data:
            fileTable[idx] = next
            inc(idx)
        else:
            emptySeq.add(next)
        pos += len
        data = not data
    return (fileTable, emptySeq)

proc defrag(data: var seq[Option[int]]) =
    var head_ptr = 0
    var tail_ptr = data.len - 1
    while true:
        while data[head_ptr].isSome():
            inc(head_ptr)
        while data[tail_ptr].isNone():
            dec(tail_ptr)
        if tail_ptr <= head_ptr:
            break
        swap(data[head_ptr], data[tail_ptr])

proc defragBlocks(files: var Table[int, Filedata], empty: var seq[Filedata]) =
    let max = files.len() - 1
    for i in countdown(max, 0):
        let len = files[i].len
        let stop = files[i].pos
        for e in empty.mitems():
            if e.pos > stop:
                break
            if len <= e.len:
                files[i].pos = e.pos
                e.len -= len
                e.pos += len
                break

proc calcChecksum(data: seq[Option[int]]): int =
    for i in 0..<data.len():
        if data[i].isNone():
            break
        result += i * data[i].get()

proc calcBlockChecksum(files: Table[int, Filedata]): int =
    for key, val in files.pairs():
        for i in 0..<val.len:
            result += key * (val.pos + i)

proc day9p1*(input: string): string =
    var data = input.parseInput()
    data.defrag()
    return $data.calcChecksum()

proc day9p2*(input: string): string =
    var (fileTable, emptySeq) = input.parseFiledata()
    defragBlocks(fileTable, emptySeq)
    return $ calcBlockChecksum(fileTable)
