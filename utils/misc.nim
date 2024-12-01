import options

# Finds the index of a variable in a sequence, if it exists
proc find_index*[T](list: seq[T], v: T): Option[int] =
    for idx, item in list.pairs():
        if item == v:
            return some(idx)

# Returns the difference of sequence A and B
proc `-`*[T](a: seq[T], b: seq[T]): seq[T] =
    for i in a:
        if i notin b:
            result.add(i)
