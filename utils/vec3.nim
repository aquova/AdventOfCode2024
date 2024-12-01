type Vector3* = tuple
    x, y, z: int

proc newVector3*(x, y, z: int): Vector3 =
    result.x = x
    result.y = y
    result.z = z

proc x*(v: Vector3): int {.inline.} =
    return v.x

proc y*(v: Vector3): int {.inline.} =
    return v.y

proc z*(v: Vector3): int {.inline.} =
    return v.z

proc `x=`*(v: var Vector3, x: int) {.inline.} =
    v.x = x

proc `y=`*(v: var Vector3, y: int) {.inline.} =
    v.y = y

proc `z=`*(v: var Vector3, z: int) {.inline.} =
    v.z = z

proc `+`*(a, b: Vector3): Vector3 =
    return (a.x + b.x, a.y + b.y, a.z + b.z)

proc `-`*(a, b: Vector3): Vector3 =
    return (a.x - b.x, a.y - b.y, a.z - b.z)

