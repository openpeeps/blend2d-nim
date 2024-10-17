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

import ./bindings/[bl_globals, bl_filesystem, bl_text, bl_style]
from ./bindings import `!`

import ./color
export BLFontCore, BLFontFaceCore


type
  Font* = ptr BLFontCore
  FontFace* = ptr BLFontFaceCore

proc newTypeface*: FontFace =
  ## Initialize a new FontFace
  result = create(BLFontFaceCore)
  !blFontFaceInit(result)

proc load*(f: FontFace, path: string, readFlags: BLFileReadFlags = BL_FILE_READ_NO_FLAGS): FontFace =
  ## Load a font from path
  !blFontFaceCreateFromFile(f, path, readFlags)
  f

proc newTypeface*(path: string, readFlags: BLFileReadFlags = BL_FILE_READ_NO_FLAGS): FontFace =
  ## Initialize a new `Font` reading a font from `path`
  newTypeface().load(path, readFlags)

proc font*(f: FontFace, size: float = 16.0): Font =
  result = create(BLFontCore)
  !blFontInit(result)
  !blFontCreateFromFace(result, f, size)

proc size*(f: Font): float =
  ## Returns the current font size
  result = blFontGetSize(f)

proc size*(f: Font, x: float) =
  ## Update the font size
  !blFontSetSize(f, x)

proc metrics*(f: Font, data: ptr string): ptr BLTextMetrics =
  result = create(BLTextMetrics)
  var gb = create(BLGlyphBufferCore)
  !blGlyphBufferInit(gb)
  !blGlyphBufferSetText(gb, data, len(data[]).uint, BL_TEXT_ENCODING_UTF8)
  !blFontShape(f, gb)
  !blFontGetTextMetrics(f, gb, result)
