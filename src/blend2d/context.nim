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

proc setCompOp*(ctx: Context, compOp: BLCompOp) {.inline.} =
  !blContextSetCompOp(ctx, compOp)

proc clearAll*(ctx: Context) {.inline.} =
  !blContextClearAll(ctx)

proc newContext*(img: Image, compOp: BLCompOp = BL_COMP_OP_SRC_OVER): Context =
  ## Creates a new Context
  result = create(BLContextCore)
  var cci = create(BLContextCreateInfo)
  !blContextInitAs(result, img, cci)
  result.clearAll()
  result.setCompOp(compOp)

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

proc fillStyle*(ctx: Context, color: ColorHex = colWhite): Context {.discardable.} =
  ## Fill Context with ColorHex
  !blContextSetCompOp(ctx, BLCompOp.BL_COMP_OP_SRC_COPY)
  !blContextSetFillStyleRgba32(ctx, color)
  !blContextFillAll(ctx)
  ctx

proc fill*(ctx: Context, rgba: BLRgba): Context {.discardable.} =
  ## Fills the entire Context using `rgba` color
  !blContextFillAllExt(ctx, rgba.addr)
  ctx

proc fill*(ctx: Context, gradient: ptr BLGradientCore): Context {.discardable.} =
  ## Fills the entire Context with the `gradient` color
  !blContextFillAllExt(ctx, gradient)
  ctx

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
# Blending Modes
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
      # Generate blend mode handles that calls `blContextSetCompOp`.
      # A `blendSrcOver` call is required after this in order
      # to clear the previously applied blending.
      proc `id`*(ctx: Context): Context {.discardable.} =
        !ctx.blContextSetCompOp(`mode`)
        ctx
    let handleId = "blend" & blendMode
    let macroHandleID = ident("apply" & id.strVal.capitalizeAscii)
    add result, quote do:
      # Generate macro-based blend mode handles that auto-injects
      # a `blendSrcOver` call at the end of the statement to switch
      # to default composition mode.
      macro `macroHandleID`*(stmts: untyped): untyped =
        result = newStmtList()
        result.add(
          newCall(ident(`handleId`), ident"this"),
          stmts,
          newCall(ident"blendSrcOver", ident"this")
        )

genBlendingModes @["Clear", "SrcOver", "SrcCopy", "SrcIn", "SrcOut", "SrcAtop",
  "DstOver", "DstCopy", "DstIn", "DstOut", "DstAtop", "Xor",
  "Plus", "Minus", "Modulate", "Multiply", "Screen", "Overlay", "Darken", "Lighten",
  "Darken", "Lighten", "ColorDodge", "ColorBurn", "LinearBurn", "LinearLight",
  "PinLight", "HardLight", "SoftLight", "Difference", "Exclusion"]

#
# Context - Add font
#
proc add*(ctx: Context, font: Font, content: string, x, y: int32 = 0,
  color: ColorHex = colWhite): Context {.discardable.} =
  ## Add a new text to Context
  let origin = point(x, y)
  !blContextFillUtf8TextIRgba32(ctx, origin.addr, font,
      content.cstring, content.len.uint, color)

#
# Context - Add Geometry
#
proc add*(ctx: Context, r: BLRectI) =
  ## Add a `BLRectI` to Context
  !blContextFillRectI(ctx, r.addr)

proc add*(ctx: Context, r: BLRectI, color: BLRgba) =
  ## Add a `BLRectI` to Context
  !blContextFillRectIExt(ctx, r.addr, color.addr)

proc add*(ctx: Context, circle: Circle) = 
  ## Add a `Circle` pointer to current `Context`
  !blContextFillGeometry(ctx, BL_GEOMETRY_TYPE_CIRCLE, circle)

proc add*(ctx: Context, c: Circle, color: ColorHex) = 
  ## Add a colored `Circle` pointer to current `Context`
  !blContextFillGeometryRgba32(ctx, BL_GEOMETRY_TYPE_CIRCLE, c, color)

proc add*(ctx: Context, c: Circle, color: BLRgba) = 
  ## Add a colored `Circle` pointer to current `Context`
  !blContextFillGeometryExt(ctx, BL_GEOMETRY_TYPE_CIRCLE, c, color.addr)

proc add*(ctx: Context, rr: RoundRect, color: ColorHex) =
  ## Add a colored `BLRoundRect` to current `Context`
  !blContextFillGeometryRgba32(ctx, BL_GEOMETRY_TYPE_ROUND_RECT, rr, color)

#
# Context - Blit Image with BLPointI
#
proc add*(ctx: Context, img: Image): Context {.discardable.} =
  ## Add an Image to current Context
  var p = point(0, 0)
  var r = rect(img.width, img.height)
  !ctx.blContextBlitImageI(p.addr, img, r.addr)
  ctx

proc add*(ctx: Context, img: Image,
    p: sink BLPointI, r: sink BLRectI): Context {.discardable.} =
  ## Add an Image to current Context using `BLPointI` as
  ## position origin and `BLRectI` as image area
  !ctx.blContextBlitImageI(p.addr, img, r.addr)
  ctx

proc add*(ctx: Context, img: Image,
    p: sink BLPointI): Context {.discardable.} =
  ## Add an Image to current Context using `BLPointI` position origin
  var r = rect(img.width, img.height)
  !ctx.blContextBlitImageI(p.addr, img, r.addr)
  ctx

#
# Context - Blit Image with BLPoint
#
proc add*(ctx: Context, img: Image,
    p: sink BLPoint, r: sink BLRectI): Context {.discardable.} =
  ## Add an Image to current Context using `BLPointI` as
  ## position origin and `BLRectI` as image area
  !ctx.blContextBlitImageD(p.addr, img, r.addr)
  ctx

proc add*(ctx: Context, img: Image,
    p: sink BLPoint): Context {.discardable.} =
  ## Add an Image to current Context using `BLPointI` position origin
  var r = rect(img.width, img.height)
  !ctx.blContextBlitImageD(p.addr, img, r.addr)
  ctx

proc add*(ctx: Context, img: Image, r: sink BLRectI): Context {.discardable.} =
  ## Add an Image to current Context using `BLRectI` image area
  var p = point(0.0, 0.0)
  !ctx.blContextBlitImageD(p.addr, img, r.addr)
  ctx

#
# Context - Masks
#
proc mask*(ctx: Context, origin: PointI,
    mask: Image, maskArea: RectI): Context {.discardable.} =
  !blContextFillMaskI(ctx, origin, mask, maskArea)
  ctx

proc endContext*(ctx: Context) =
  ## Ends the `ctx` Context
  !blContextEnd(ctx)

#
# Context - Stroke
#

proc stroke*(ctx: Context, c: BLCircle, width: float, color: BLRgba = White): Context {.discardable.} =
  ## Add a stroke to `BLCircle` using `ctx` Context
  !blContextSetStrokeWidth(ctx, width)
  !blContextStrokeGeometryExt(ctx, BLGeometryType.BlGeometryTypeCircle, c.addr, color.addr)
  result = ctx

template stroke*(c: BLCircle, width: float, color: BLRgba = White) =
  ## Add a stroke to `BLCircle` while in a `ctx` Context
  this.stroke(c, width, color)

#
# Macro Utils
#
macro ctx*(img: typed, contextStmt: untyped): untyped =
  ## Macro utility to create a new nestable context.
  ## 
  ## Use `this` identifier to access the Context pointer.
  ## An `endContext` call is injected at the end of the statement.
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
