import point

proc `[]`*[T](grid: seq[seq[T]], p: Point): T =
    return grid[p.y][p.x]

proc height*(grid: seq[seq[T]]): int =
    return grid.len()

proc width*(grid: seq[seq[T]]): int =
    return grid[0].len()
