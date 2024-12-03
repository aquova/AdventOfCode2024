import re, strscans

proc day3p1*(input: string): string =
    var total = 0
    let regex = re"mul\(\d+,\d+\)"
    for mul in input.findAll(regex):
        let (_, a, b) = mul.scanTuple("mul($i,$i)")
        total += a * b
    return $total

proc day3p2*(input: string): string =
    var total = 0
    var mul_enabled = true
    let regex = re"mul\(\d+,\d+\)|do\(\)|don't\(\)"
    for mul in input.findAll(regex):
        case mul
            of "do()": mul_enabled = true
            of "don't()": mul_enabled = false
            else:
                if mul_enabled:
                    let (_, a, b) = mul.scanTuple("mul($i,$i)")
                    total += a * b
    return $total
