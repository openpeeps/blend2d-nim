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
import std/[macros, strutils]
import ./bindings/[bl_globals, bl_context, bl_geometry, bl_style, bl_image]

from ./bindings import `!`

import ./[image, geometry, font, color]
export BLPoint, BLPointI, context

type 
  Context* = ptr BLContextCore

proc newContext*(img: Image, compOp: BLCompOp = BL_COMP_OP_SRC_COPY): Context =
  ## Creates a new Context
  result = create(BLContextCore)
  var cci = create(BLContextCreateInfo)
  !blContextInitAs(result, img, cci)
  !blContextClearAll(result)
  !blContextSetCompOp(result, compOp)

proc opacity*(ctx: Context, alpha: range[0.0..1.0]): Context {.discardable.} =
  ## Applies `blContextSetGlobalAlpha` using `alpha`
  !blContextSetGlobalAlpha(ctx, alpha)
  ctx

template opacity*(alpha: range[0.0..1.0], stmts: untyped) {.dirty.} =
  ## A template that applies `blContextSetGlobalAlpha` using `alpha`
  ## to `stmts` then reset back to 1.0
  this.opacity(alpha)
  stmts
  this.opacity(1)

proc fillStyle*(ctx: Context): Context {.discardable.} =
  ## Fill `ctx` Context with Color
  !blContextSetCompOp(ctx, BLCompOp.BL_COMP_OP_SRC_COPY)
  !blContextSetFillStyleRgba32(ctx, 0xFFFFFFFF'u32)
  !blContextFillAll(ctx)
  ctx

proc fill*(ctx: Context, rgba: BLRgba): Context {.discardable.} =
  ## Fills the entire Context using `rgba` color
  !blContextFillAllExt(ctx, rgba.addr)
  ctx

# proc fillAllC*(impl: ptr BLContextImpl): BLResult {.cdecl.} =
  # blContextFillAllExt(impl[], gradient)

proc fill*(ctx: Context, gradient: ptr BLGradientCore): Context {.discardable.} =
  ## Fills the entire Context with the `gradient` color
  !blContextFillAllExt(ctx, gradient)
  ctx

proc add*(ctx: Context, font: Font, content: string, x, y: int32 = 0,
  color: ColorHex = colWhite): Context {.discardable.} =
  ## Add a new text to Context
  let origin = point(x, y)
  !blContextFillUtf8TextIRgba32(ctx, origin.addr, font,
      content.cstring, content.len.uint, color)

#
# Context Transformers
#
proc translate*(ctx: Context, x, y: float64) =
  # Move 
  let pos = [x, y]
  !ctx.blContextApplyTransformOp(BlTransformOpTranslate, pos.addr)

proc rotate*(ctx: Context, angle: range[-1.0..1.0]) =
  !ctx.blContextApplyTransformOp(BlTransformOpRotate, angle.addr)

proc scale*(ctx: Context, x, y: float64) =
  let scale = [x, y]
  !ctx.blContextApplyTransformOp(BlTransformOpScale, scale.addr)

proc skew*(ctx: Context, x, y: float64) =
  let skew = [x, y]
  !ctx.blContextApplyTransformOp(BlTransformOpSkew, skew.addr)

proc resetTransform*(ctx: Context) =
  ## Reset applied transformations
  !ctx.blContextApplyTransformOp(BlTransformOpReset, nil)

#
# Blendings
#
proc blend*(ctx: Context, img: Image,
    p: ptr BLPointI, r: ptr BLRectI,
    mode: BLCompOp = BLCompOpSrcOver
): Context {.discardable.} =
  !ctx.blContextSetCompOp(mode)
  !ctx.blContextBlitImageI(p, img, r)
  ctx

macro genBlendingModes(blendModes: static seq[string]) =
  # A macro that generates blending mode proc handles
  result = newStmtList()
  for blendMode in blendModes:
    let id = ident("blend" & blendMode)
    let mode = ident("BLCompOp" & blendMode)
    add result, quote do:
      # Generate blending mode handles that calls `blContextSetCompOp`.
      # A `blendClear` call is required to stop blending handle.
      proc `id`*(ctx: Context): Context {.discardable.} =
        !ctx.blContextSetCompOp(`mode`)
        ctx
    let handleId = "blend" & blendMode
    let macroHandleID = ident("apply" & id.strVal.capitalizeAscii)
    add result, quote do:
      # Generate macro-based blending mode handles that injects
      # a `blendClear` call at the end of the statement.
      # These macros can be used only inside a `ctx` macro
      macro `macroHandleID`*(stmts: untyped): untyped =
        result = newStmtList()
        result.add(
          newCall(ident(`handleId`), ident"this"),
          stmts,
          newCall(ident"blendClear", ident"this")
        )

genBlendingModes @["Clear", "SrcOver", "SrcCopy", "SrcIn", "SrcOut", "SrcAtop",
  "DstOver", "DstCopy", "DstIn", "DstOut", "DstAtop", "Xor",
  "Plus", "Minus", "Modulate", "Multiply", "Screen", "Overlay", "Darken", "Lighten",
  "Darken", "Lighten", "ColorDodge", "ColorBurn", "LinearBurn", "LinearLight",
  "PinLight", "HardLight", "SoftLight", "Difference", "Exclusion"]

proc add*(ctx: Context, img: Image, p: ptr BLPointI, r: ptr BLRectI): Context {.discardable.} =
  !ctx.blContextBlitImageI(p, img, r)
  ctx

proc endContext*(ctx: Context) =
  !blContextEnd(ctx)

#
# Macro Utils
#
macro ctx*(img: typed, contextStmt: untyped) =
  result = nnkBlockStmt.newTree()
  add result, newEmptyNode() # unamed block
  add result,
    nnkStmtList.newTree(
      newVarStmt(
        ident"this",
        newCall(
          ident"newContext",
          img
        )
      ),
      contextStmt,
      newCall(
        ident"endContext",
        ident"this"
      )
    )
