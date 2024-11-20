# Copyright (c) 2017-2024 The Blend2D Authors
#
# This software is provided 'as-is', without any express or
# implied warranty. In no event will the authors be held liable
# for any damages arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
# 
# The origin of this software must not be misrepresented; you must not
# claim that you wrote the original software. If you use this software in
# a product, an acknowledgment in the product documentation would be
# appreciated but is not required.
#
# Altered source versions must be plainly marked as such, and must not
# be misrepresented as being the original software.
#
# This notice may not be removed or altered from any source distribution.
# 
#
# blend2d-nim is a Nim wrapper for the libblend2d library
# providing low-level & high-level API for rendering 2D graphics.
#
# (c) 2024 George Lemon | ZLib License
#     Made by Humans from OpenPeeps
#     https://github.com/openpeeps/blend2d-nim
import ./bindings/bl_geometry
type
  RectI* = ptr BLRectI
  PointI* = ptr BLPointI
  Point* = ptr BLPoint
  Circle* = ptr BLCircle
  RoundRect* = ptr BLRoundRect

proc point*(x, y: float): BLPoint =
  BLPoint(x: x, y: y)

proc point*(x, y: int32 = 0): BLPointI =
  BLPointI(x: x, y: y)

proc rect*(x, y, w, h: int32): BLRectI =
  BLRectI(x: x, y: y, w: w, h: h)

proc rect*(w, h: int32): BLRectI =
  rect(0, 0, w, h)

proc square*(size: int32, x, y: int32 = 0): BLRectI =
  rect(x, y, size, size)

proc rect*(x, y, w, h, rx, ry: float): BLRoundRect =
  BLRoundRect(x: x, y: y, w: w, h: h, rx: rx, ry: ry)

proc roundRect*(x, y, w, h: float; rx, ry = 10.0): BLRoundRect {.inline.} =
  rect(x, y, w, h, rx, ry)

proc roundSquare*(x, y, size: float, rx, ry = 10.0): BLRoundRect {.inline.} =
  rect(x, y, size, size, rx, ry)

proc roundSquare*(x, y, size, radius: float): BLRoundRect {.inline.} =
  rect(x, y, size, size, radius, radius)

proc size*(w, h: float): BLSize =
  BLSize(w: w, h: h)

proc size*(w, h: int32): BLSizeI =
  BLSizeI(w: w, h: h)

proc size*(w, h: int): BLSizeI =
  BLSizeI(w: w.int32, h: h.int32)

proc circle*(cx, cy, r: float): BLCircle =
  result = BLCircle(cx: cx, cy: cy, r: r)