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
import std/[macros, os, strutils]

import ./bindings/[bl_globals, bl_image]
import ./geometry

from ./bindings import `!`

type
  Image* = ptr BLimageCore
  ImageData* = ptr BLImageData

proc init*(width, height: int, pixelFormat: BLFormat = BL_FORMAT_PRGB32): Image =
  ## Create a new Image
  result = create(BLImageCore)
  !blImageInitAs(result, width.cint, height.cint, pixelFormat)

proc open*(path: string): Image = 
  result = create(BLImageCore)
  !blImageInit(result)
  !blImageReadFromFile(result, path.cstring, nil)

proc getAspectRatio*(width, height, minWidth, minHeight: int): (int, int) =
  let ratio: float = system.min((minWidth / width), (minHeight / height))
  result = (toInt(width.toFloat * ratio), toInt(height.toFloat * ratio))

proc getData*(img: Image): ImageData =
  ## Returns a `BLImageData` from img
  result = create(BLImageData)
  !blImageGetData(img, result)

proc resize*(img: Image, width, height: int32,
  scaleFilter: BLImageScaleFilter = BLImageScaleFilterNearest): Image {.discardable.} = 
  ## Resize an image by maintaining the aspect ratio and returns a new Image
  let data = img.getData
  let (w, h) = getAspectRatio(data[].size.w, data[].size.h, width, height)
  let s = size(w, h)
  result = create(BLImageCore)
  !blImageInit(result)
  !blImageScale(result, img, s.addr, scaleFilter)

proc resize*(img: var Image, width, height: int32,
  scaleFilter: BLImageScaleFilter = BLImageScaleFilterNearest) = 
  ## Resize a mutable image, keeping the aspect ratio
  var data = img.getData
  let (w, h) = getAspectRatio(data[].size.w, data[].size.h, width, height)
  let s = size(w, h)
  !blImageMakeMutable(img, data)
  !blImageScale(img, img, s.addr, scaleFilter)

proc getWidth*(img: Image): int32 =
  ## Retrieve the width of an Image
  result = img.getData[].size.w

proc getHeight*(img: Image): int32 =
  ## Retrieve the height of an Image
  result = img.getData[].size.h

proc width*(img: Image): int32 {.inline.} =
  ## An alias of `getWidth`
  img.getWidth()

proc height*(img: Image): int32 {.inline.} =
  ## An alias of `getHeight`
  img.getHeight()

proc exportAs*(img: Image, path: string) =
  ## Exports an Image to given `path`.
  ## The codec is initialized from path extension
  let ext = path.splitFile.ext.replace(".").toUpperAscii
  var codec = create(BLImageCodecCore)
  !blImageCodecInitByName(codec, ext, len(ext).uint, nil)
  !blImageWriteToFile(img, path.cstring, codec)

proc destroyImage*(img: Image) = 
  !blImageDestroy(img)
  dealloc(img)

#
# Macro utils
#
macro group*(imgIdent: untyped, width, height, contextStmt: untyped): untyped =
  ## A macro utility that help organize your
  ## 2D computations in grouped-like layers.
  ## 
  ## This macro calls the `ctx` macro utility, which
  ## expose the current Context as `this` identifier.
  result = newStmtList()
  add result,
    nnkVarSection.newTree(
      nnkIdentDefs.newTree(
        imgIdent,
        ident"Image",
        newCall(
          newDotExpr(ident"image", ident"init"),
          width, height
        )
      )
    ),
    newCall(ident"ctx", imgIdent, contextStmt)
