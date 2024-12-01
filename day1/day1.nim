import algorithm, sequtils, strscans, strutils

proc day1p1*(input: string): string =
    var
        leftList: seq[int]
        rightList: seq[int]
    for line in input.splitLines():
        let (success, left, right) = line.scanTuple("$i$s$i")
        if success:
            leftList.add(left)
            rightList.add(right)
    leftList.sort()
    rightList.sort()
    var sum = 0
    for (left, right) in leftList.zip(rightList):
        sum += abs(left - right)
    return $sum

proc day1p2*(input: string): string =
    var
        leftList: seq[int]
        rightList: seq[int]
    for line in input.splitLines():
        let (success, left, right) = line.scanTuple("$i$s$i")
        if success:
            leftList.add(left)
            rightList.add(right)
    var sum = 0
    for left in leftList:
        sum += left * rightList.count(left)
    return $sum
