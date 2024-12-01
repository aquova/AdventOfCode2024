import vec3

type Color = Vector3

proc newColor*(r, g, b: int): Color =
    result.x = r
    result.y = g
    result.z = b

proc r*(c: Color): int {.inline.} =
    return c.x

proc g*(c: Color): int {.inline.} =
    return c.y

proc b*(c: Color): int {.inline.} =
    return c.z

proc `r=`*(c: var Color, r: int) {.inline.} =
    c.x = r

proc `g=`*(c: var Color, g: int) {.inline.} =
    c.y = g

proc `b=`*(c: var Color, b: int) {.inline.} =
    c.z = b

