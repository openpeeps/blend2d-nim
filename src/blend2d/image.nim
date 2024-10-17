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
import std/[os, strutils]

import ./bindings/[bl_globals, bl_image]
from ./bindings import `!`

type
  Image* = ptr BLimageCore

proc init*(width, height: int): Image =
  ## Create a new Image
  result = create(BLImageCore)
  !blImageInitAs(result, width.cint, height.cint, BL_FORMAT_PRGB32)

proc open*(path: string): ptr BLImageCore = 
  result = create(BLImageCore)
  !blImageInit(result)
  # assert blImageCodecInitByName(result.codecCore, ext, len(ext).uint, nil).code == BLSuccess
  !blImageReadFromFile(result, path.cstring, nil)

proc exportAs*(img: Image, path: string) =
  ## Exports an Image to given `path`.
  ## The codec is automatically 
  let ext = path.splitFile.ext.replace(".").toUpperAscii
  var codec = create(BLImageCodecCore)
  !blImageCodecInitByName(codec, ext, len(ext).uint, nil)
  !blImageWriteToFile(img, path.cstring, codec)
