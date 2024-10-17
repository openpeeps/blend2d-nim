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
import std/macros
import ./bindings/bl_globals

import ./bindings/[bl_filesystem, bl_style, bl_context, bl_image]
export bl_globals, bl_filesystem, bl_style, bl_context, bl_image

macro `!`*(fn: untyped): untyped =
  result = newStmtList()
  result.add(
    nnkCommand.newTree(
      ident"assert",
      nnkInfix.newTree(
        ident"==",
        newDotExpr(fn, ident"code"),
        ident"BL_SUCCESS"
      )
    )
  )
