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

import ./bl_globals

from ./bl_geometry import BLPointI, BLPoint,
  BLSize, BLMatrix2D, BLRectI, BLRect, 
  BLStrokeOptionsCore, BLApproximationOptions,
  BLTransformOp, BLPathCore, BLFlattenMode,
  BLFillRule, BLStrokeCapPosition, BLStrokeCap,
  BLStrokeJoin, BLStrokeTransformOrder, BLGeometryType

from ./bl_image import BLImageCore
from ./bl_text import BLFontCore, BLGlyphRun

{.push importc, header: blend2dHeader.}
type
  BLContextType* {.size: sizeof(uint32).} = enum
    BL_CONTEXT_TYPE_NONE ## No rendering context.
    BL_CONTEXT_TYPE_DUMMY ## Dummy rendering context.
    BL_CONTEXT_TYPE_RASTER  ## Software-accelerated rendering context.
    BL_CONTEXT_TYPE_MAX_VALUE  ## Maximum value of BLContextType.

  BLContextHint* {.size: sizeof(uint32).} = enum
    BL_CONTEXT_HINT_RENDERING_QUALITY ## Rendering quality.
    BL_CONTEXT_HINT_GRADIENT_QUALITY ## Gradient quality.
    BL_CONTEXT_HINT_PATTERN_QUALITY ## Pattern quality.
    BL_CONTEXT_HINT_MAX_VALUE ## Maximum value of BLContextHint.

  BLContextStyleSlot* {.size: sizeof(uint32).} = enum
    BL_CONTEXT_STYLE_SLOT_FILL ## Fill operation style slot
    BL_CONTEXT_STYLE_SLOT_STROKE ## Stroke operation style slot.
    BL_CONTEXT_STYLE_SLOT_MAX_VALUE ## Maximum value of BLContextStyleSlot

  BLContextRenderTextOp* {.size: sizeof(uint32).} = enum
    BL_CONTEXT_RENDER_TEXT_OP_UTF8 ## UTF-8 text rendering operation - UTF-8 string passed as BLStringView or BLArrayView<uint8_t>.
    BL_CONTEXT_RENDER_TEXT_OP_UTF16 ## UTF-16 text rendering operation - UTF-16 string passed as BLArrayView<uint16_t>.
    BL_CONTEXT_RENDER_TEXT_OP_UTF32 ## UTF-32 text rendering operation - UTF-32 string passed as BLArrayView<uint32_t>.
    BL_CONTEXT_RENDER_TEXT_OP_LATIN1 ## LATIN1 text rendering operation - LATIN1 string is passed as BLStringView or BLArrayView<uint8_t>.
    BL_CONTEXT_RENDER_TEXT_OP_WCHAR ## wchar_t text rendering operation - wchar_t string is passed as BLArrayView<wchar_t>.
    BL_CONTEXT_RENDER_TEXT_OP_GLYPH_RUN ## Glyph run text rendering operation - the BLGlyphRun parameter is passed.
    BL_CONTEXT_RENDER_TEXT_OP_MAX_VALUE ## Maximum value of BLContextRenderTextInputType

  BLContextStyleSwapMode* {.size:sizeof(uint32).} = enum
    BL_CONTEXT_STYLE_SWAP_MODE_STYLES
      ## Swap only fill and stroke styles without affecting fill and stroke alpha.
    BL_CONTEXT_STYLE_SWAP_MODE_STYLES_WITH_ALPHA
      ## Swap both fill and stroke styles and their alpha values.
    BL_CONTEXT_STYLE_SWAP_MODE_MAX_VALUE
      ## Maximum value of BLContextStyleSwapMode.

  BLContextStyleTransformMode* {.size:sizeof(uint32).} = enum
    BL_CONTEXT_STYLE_TRANSFORM_MODE_USER
      ## Style transformation matrix should be transformed with the rendering context user and meta matrix (default).
    BL_CONTEXT_STYLE_TRANSFORM_MODE_META
      ## Style transformation matrix should be transformed with the rendering context meta matrix.
    BL_CONTEXT_STYLE_TRANSFORM_MODE_NONE
      ## Style transformation matrix is considered absolute, and is not combined with a rendering context transform.
    BL_CONTEXT_STYLE_TRANSFORM_MODE_MAX_VALUE
      ## Maximum value of BLContextStyleTransformMode.

  BLClipMode* {.size:sizeof(uint32).} = enum
    BL_CLIP_MODE_ALIGNED_RECT ## Clipping to a rectangle that is aligned to the pixel grid.
    BL_CLIP_MODE_UNALIGNED_RECT ## Clipping to a rectangle that is not aligned to pixel grid.
    BL_CLIP_MODE_MASK   ## Clipping to a non-rectangular area that is defined by using mask.
    BL_CLIP_MODE_COUNT  ## Count of clip modes.

  BLCompOp* {.size:sizeof(uint32).} = enum
    BL_COMP_OP_SRC_OVER ## Source-over [default].
    BL_COMP_OP_SRC_COPY ## Source-copy.
    BL_COMP_OP_SRC_IN ## Source-in.
    BL_COMP_OP_SRC_OUT ## Source-out.
    BL_COMP_OP_SRC_ATOP ## Source-atop.
    BL_COMP_OP_DST_OVER ## Destination-over.
    BL_COMP_OP_DST_COPY ## Destination-copy [nop].
    BL_COMP_OP_DST_IN ## Destination-in.
    BL_COMP_OP_DST_OUT ## Destination-out.
    BL_COMP_OP_DST_ATOP ## Destination-atop.
    BL_COMP_OP_XOR ## Xor.
    BL_COMP_OP_CLEAR ## Clear.
    BL_COMP_OP_PLUS ## Plus.
    BL_COMP_OP_MINUS ## Minus.
    BL_COMP_OP_MODULATE ## Modulate.
    BL_COMP_OP_MULTIPLY ## Multiply.
    BL_COMP_OP_SCREEN ## Screen.
    BL_COMP_OP_OVERLAY ## Overlay.
    BL_COMP_OP_DARKEN ## Darken.
    BL_COMP_OP_LIGHTEN ## Lighten.
    BL_COMP_OP_COLOR_DODGE ## Color dodge.
    BL_COMP_OP_COLOR_BURN ## Color burn.
    BL_COMP_OP_LINEAR_BURN ## Linear burn.
    BL_COMP_OP_LINEAR_LIGHT ## Linear light.
    BL_COMP_OP_PIN_LIGHT ## Pin light.
    BL_COMP_OP_HARD_LIGHT ## Hard-light.
    BL_COMP_OP_SOFT_LIGHT ## Soft-light.
    BL_COMP_OP_DIFFERENCE ## Difference.
    BL_COMP_OP_EXCLUSION ## Exclusion.
    BL_COMP_OP_MAX_VALUE ## Count of composition & blending operators.

  BLRenderingQuality* {.size:sizeof(uint32).} = enum
    BL_RENDERING_QUALITY_ANTIALIAS
      ## Maximum value of BLRenderingQuality.
    BL_RENDERING_QUALITY_MAX_VALUE
      ## Render using anti-aliasing.

  BLContextFlushFlags* {.size: sizeof(uint32).} = enum
    BL_CONTEXT_FLUSH_SYNC ## Flushes the command queue and waits for its completion (will block until done).

  BLContextCookie* {.bycopy.} = object
    data*: array[2, uint64]

  BLContextCreateInfo* {.bycopy.} = object
    flags*: uint32
    threadCount*: uint32
    cpuFeatures*: uint32
    commandQueueLimit*: uint32
    savedStateLimit*: uint32
    pixelOrigin*: BLPointI
    reserved*: array[1, uint32]

  BLContextHints* {.bycopy.} = object
    renderingQuality*: uint8
    gradientQuality*: uint8
    patternQuality*: uint8
    hints*: array[BL_CONTEXT_HINT_MAX_VALUE.ord + 1, uint8]

  BLContextCore* {.bycopy.} = object
    d*: BLObjectDetail
  
{.pop.}

{.push importc, cdecl, header: blend2dHeader.}
proc blContextInit*(self: ptr BLContextCore): BLResult
proc blContextInitMove*(self: ptr BLContextCore; other: ptr BLContextCore): BLResult
proc blContextInitWeak*(self: ptr BLContextCore; other: ptr BLContextCore): BLResult
proc blContextInitAs*(self: ptr BLContextCore; image: ptr BLImageCore; cci: ptr BLContextCreateInfo): BLResult
proc blContextDestroy*(self: ptr BLContextCore): BLResult
proc blContextReset*(self: ptr BLContextCore): BLResult
proc blContextAssignMove*(self: ptr BLContextCore; other: ptr BLContextCore): BLResult
proc blContextAssignWeak*(self: ptr BLContextCore; other: ptr BLContextCore): BLResult
proc blContextGetType*(self: ptr BLContextCore): BLContextType
proc blContextGetTargetSize*(self: ptr BLContextCore; targetSizeOut: ptr BLSize): BLResult
proc blContextGetTargetImage*(self: ptr BLContextCore): ptr BLImageCore
proc blContextBegin*(self: ptr BLContextCore; image: ptr BLImageCore; cci: ptr BLContextCreateInfo): BLResult
proc blContextEnd*(self: ptr BLContextCore): BLResult
proc blContextFlush*(self: ptr BLContextCore; flags: BLContextFlushFlags): BLResult
proc blContextSave*(self: ptr BLContextCore; cookie: ptr BLContextCookie): BLResult
proc blContextRestore*(self: ptr BLContextCore; cookie: ptr BLContextCookie): BLResult
proc blContextGetMetaTransform*(self: ptr BLContextCore; transformOut: ptr BLMatrix2D): BLResult
proc blContextGetUserTransform*(self: ptr BLContextCore; transformOut: ptr BLMatrix2D): BLResult
proc blContextGetFinalTransform*(self: ptr BLContextCore; transformOut: ptr BLMatrix2D): BLResult
proc blContextUserToMeta*(self: ptr BLContextCore): BLResult
proc blContextApplyTransformOp*(self: ptr BLContextCore; opType: BLTransformOp; opData: pointer): BLResult
proc blContextGetHint*(self: ptr BLContextCore; hintType: BLContextHint): uint32
proc blContextSetHint*(self: ptr BLContextCore; hintType: BLContextHint; value: uint32): BLResult
proc blContextGetHints*(self: ptr BLContextCore; hintsOut: ptr BLContextHints): BLResult
proc blContextSetHints*(self: ptr BLContextCore; hints: ptr BLContextHints): BLResult
proc blContextSetFlattenMode*(self: ptr BLContextCore; mode: BLFlattenMode): BLResult
proc blContextSetFlattenTolerance*(self: ptr BLContextCore; tolerance: cdouble): BLResult
proc blContextSetApproximationOptions*(self: ptr BLContextCore; options: ptr BLApproximationOptions): BLResult
proc blContextGetFillStyle*(self: ptr BLContextCore; styleOut: ptr BLVarCore): BLResult
proc blContextGetTransformedFillStyle*(self: ptr BLContextCore; styleOut: ptr BLVarCore): BLResult
proc blContextSetFillStyle*(self: ptr BLContextCore; style: pointer): BLResult
proc blContextSetFillStyleWithMode*(self: ptr BLContextCore; style: ptr BLUnknown; transformMode: BLContextStyleTransformMode): BLResult
proc blContextSetFillStyleRgba*(self: ptr BLContextCore; rgba: ptr BLRgba): BLResult
proc blContextSetFillStyleRgba32*(self: ptr BLContextCore; rgba32: uint32): BLResult
proc blContextSetFillStyleRgba64*(self: ptr BLContextCore; rgba64: uint64): BLResult
proc blContextDisableFillStyle*(self: ptr BLContextCore): BLResult
proc blContextGetFillAlpha*(self: ptr BLContextCore): cdouble
proc blContextSetFillAlpha*(self: ptr BLContextCore; alpha: cdouble): BLResult
proc blContextGetStrokeStyle*(self: ptr BLContextCore; styleOut: ptr BLVarCore): BLResult
proc blContextGetTransformedStrokeStyle*(self: ptr BLContextCore; styleOut: ptr BLVarCore): BLResult
proc blContextSetStrokeStyle*(self: ptr BLContextCore; style: ptr BLUnknown): BLResult
proc blContextSetStrokeStyleWithMode*(self: ptr BLContextCore; style: ptr BLUnknown; transformMode: BLContextStyleTransformMode): BLResult
proc blContextSetStrokeStyleRgba*(self: ptr BLContextCore; rgba: ptr BLRgba): BLResult
proc blContextSetStrokeStyleRgba32*(self: ptr BLContextCore; rgba32: uint32): BLResult
proc blContextSetStrokeStyleRgba64*(self: ptr BLContextCore; rgba64: uint64): BLResult
proc blContextDisableStrokeStyle*(self: ptr BLContextCore): BLResult
proc blContextGetStrokeAlpha*(self: ptr BLContextCore): cdouble
proc blContextSetStrokeAlpha*(self: ptr BLContextCore; alpha: cdouble): BLResult
proc blContextSwapStyles*(self: ptr BLContextCore; mode: BLContextStyleSwapMode): BLResult
proc blContextGetGlobalAlpha*(self: ptr BLContextCore): cdouble
proc blContextSetGlobalAlpha*(self: ptr BLContextCore; alpha: cdouble): BLResult
proc blContextGetCompOp*(self: ptr BLContextCore): BLCompOp
proc blContextSetCompOp*(self: ptr BLContextCore; compOp: BLCompOp): BLResult
proc blContextGetFillRule*(self: ptr BLContextCore): BLFillRule
proc blContextSetFillRule*(self: ptr BLContextCore; fillRule: BLFillRule): BLResult
proc blContextGetStrokeWidth*(self: ptr BLContextCore): cdouble
proc blContextSetStrokeWidth*(self: ptr BLContextCore; width: cdouble): BLResult
proc blContextGetStrokeMiterLimit*(self: ptr BLContextCore): cdouble
proc blContextSetStrokeMiterLimit*(self: ptr BLContextCore; miterLimit: cdouble): BLResult
proc blContextGetStrokeCap*(self: ptr BLContextCore; position: BLStrokeCapPosition): BLStrokeCap
proc blContextSetStrokeCap*(self: ptr BLContextCore; position: BLStrokeCapPosition; strokeCap: BLStrokeCap): BLResult
proc blContextSetStrokeCaps*(self: ptr BLContextCore; strokeCap: BLStrokeCap): BLResult
proc blContextGetStrokeJoin*(self: ptr BLContextCore): BLStrokeJoin
proc blContextSetStrokeJoin*(self: ptr BLContextCore; strokeJoin: BLStrokeJoin): BLResult
proc blContextGetStrokeTransformOrder*(self: ptr BLContextCore): BLStrokeTransformOrder
proc blContextSetStrokeTransformOrder*(self: ptr BLContextCore; transformOrder: BLStrokeTransformOrder): BLResult
proc blContextGetStrokeDashOffset*(self: ptr BLContextCore): cdouble
proc blContextSetStrokeDashOffset*(self: ptr BLContextCore; dashOffset: cdouble): BLResult
proc blContextGetStrokeDashArray*(self: ptr BLContextCore; dashArrayOut: ptr BLArrayCore): BLResult
proc blContextSetStrokeDashArray*(self: ptr BLContextCore; dashArray: ptr BLArrayCore): BLResult
proc blContextGetStrokeOptions*(self: ptr BLContextCore; options: ptr BLStrokeOptionsCore): BLResult
proc blContextSetStrokeOptions*(self: ptr BLContextCore; options: ptr BLStrokeOptionsCore): BLResult
proc blContextClipToRectI*(self: ptr BLContextCore; rect: ptr BLRectI): BLResult
proc blContextClipToRectD*(self: ptr BLContextCore; rect: ptr BLRect): BLResult
proc blContextRestoreClipping*(self: ptr BLContextCore): BLResult
proc blContextClearAll*(self: ptr BLContextCore): BLResult
proc blContextClearRectI*(self: ptr BLContextCore; rect: ptr BLRectI): BLResult
proc blContextClearRectD*(self: ptr BLContextCore; rect: ptr BLRect): BLResult
proc blContextFillAll*(self: ptr BLContextCore): BLResult
proc blContextFillAllRgba32*(self: ptr BLContextCore; rgba32: uint32): BLResult
proc blContextFillAllRgba64*(self: ptr BLContextCore; rgba64: uint64): BLResult
proc blContextFillAllExt*(self: ptr BLContextCore; style: pointer): BLResult
proc blContextFillRectI*(self: ptr BLContextCore; rect: ptr BLRectI): BLResult
proc blContextFillRectIRgba32*(self: ptr BLContextCore; rect: ptr BLRectI; rgba32: uint32): BLResult
proc blContextFillRectIRgba64*(self: ptr BLContextCore; rect: ptr BLRectI; rgba64: uint64): BLResult
proc blContextFillRectIExt*(self: ptr BLContextCore; rect: ptr BLRectI;  style: ptr BLUnknown): BLResult
proc blContextFillRectD*(self: ptr BLContextCore; rect: ptr BLRect): BLResult
proc blContextFillRectDRgba32*(self: ptr BLContextCore; rect: ptr BLRect; rgba32: uint32): BLResult
proc blContextFillRectDRgba64*(self: ptr BLContextCore; rect: ptr BLRect; rgba64: uint64): BLResult
proc blContextFillRectDExt*(self: ptr BLContextCore; rect: ptr BLRect;  style: ptr BLUnknown): BLResult
proc blContextFillPathD*(self: ptr BLContextCore; origin: ptr BLPoint; path: ptr BLPathCore): BLResult
proc blContextFillPathDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint; path: ptr BLPathCore; rgba32: uint32): BLResult
proc blContextFillPathDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint; path: ptr BLPathCore; rgba64: uint64): BLResult
proc blContextFillPathDExt*(self: ptr BLContextCore; origin: ptr BLPoint;  path: ptr BLPathCore; style: ptr BLUnknown): BLResult
proc blContextFillGeometry*(self: ptr BLContextCore; `type`: BLGeometryType; data: pointer): BLResult
proc blContextFillGeometryRgba32*(self: ptr BLContextCore; `type`: BLGeometryType; data: pointer; rgba32: uint32): BLResult
proc blContextFillGeometryRgba64*(self: ptr BLContextCore; `type`: BLGeometryType; data: pointer; rgba64: uint64): BLResult
proc blContextFillGeometryExt*(self: ptr BLContextCore; `type`: BLGeometryType; data: pointer; style: ptr BLUnknown): BLResult
proc blContextFillUtf8TextI*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: cstring; size: uint): BLResult
proc blContextFillUtf8TextIRgba32*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: cstring; size: uint; rgba32: uint32): BLResult
proc blContextFillUtf8TextIRgba64*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: cstring; size: uint; rgba64: uint64): BLResult
proc blContextFillUtf8TextIExt*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: cstring; size: uint; style: pointer #[ptr BLUnknown]#): BLResult
proc blContextFillUtf8TextD*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: cstring; size: uint): BLResult
proc blContextFillUtf8TextDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: cstring; size: uint; rgba32: uint32): BLResult
proc blContextFillUtf8TextDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: cstring; size: uint; rgba64: uint64): BLResult
proc blContextFillUtf8TextDExt*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: cstring; size: uint; style: ptr BLUnknown): BLResult
proc blContextFillUtf16TextI*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint16; size: uint): BLResult
proc blContextFillUtf16TextIRgba32*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint16; size: uint; rgba32: uint32): BLResult
proc blContextFillUtf16TextIRgba64*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint16; size: uint; rgba64: uint64): BLResult
proc blContextFillUtf16TextIExt*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint16; size: uint; style: ptr BLUnknown): BLResult
proc blContextFillUtf16TextD*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint16; size: uint): BLResult
proc blContextFillUtf16TextDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint16; size: uint; rgba32: uint32): BLResult
proc blContextFillUtf16TextDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint16; size: uint; rgba64: uint64): BLResult
proc blContextFillUtf16TextDExt*(self: ptr BLContextCore; origin: ptr BLPoint;  font: ptr BLFontCore; text: ptr uint16;  size: uint; style: ptr BLUnknown): BLResult
proc blContextFillUtf32TextI*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint32; size: uint): BLResult
proc blContextFillUtf32TextIRgba32*(self: ptr BLContextCore;  origin: ptr BLPointI; font: ptr BLFontCore;  text: ptr uint32; size: uint; rgba32: uint32): BLResult
proc blContextFillUtf32TextIRgba64*(self: ptr BLContextCore;  origin: ptr BLPointI; font: ptr BLFontCore;  text: ptr uint32; size: uint; rgba64: uint64): BLResult
proc blContextFillUtf32TextIExt*(self: ptr BLContextCore; origin: ptr BLPointI;  font: ptr BLFontCore; text: ptr uint32;  size: uint; style: ptr BLUnknown): BLResult
proc blContextFillUtf32TextD*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint32; size: uint): BLResult
proc blContextFillUtf32TextDRgba32*(self: ptr BLContextCore;  origin: ptr BLPoint; font: ptr BLFontCore;  text: ptr uint32; size: uint; rgba32: uint32): BLResult
proc blContextFillUtf32TextDRgba64*(self: ptr BLContextCore;  origin: ptr BLPoint; font: ptr BLFontCore;  text: ptr uint32; size: uint; rgba64: uint64): BLResult
proc blContextFillUtf32TextDExt*(self: ptr BLContextCore; origin: ptr BLPoint;  font: ptr BLFontCore; text: ptr uint32;  size: uint; style: ptr BLUnknown): BLResult
proc blContextFillGlyphRunI*(self: ptr BLContextCore; origin: ptr BLPointI;   font: ptr BLFontCore; glyphRun: ptr BLGlyphRun): BLResult
proc blContextFillGlyphRunIRgba32*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba32: uint32): BLResult
proc blContextFillGlyphRunIRgba64*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba64: uint64): BLResult
proc blContextFillGlyphRunIExt*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; style: ptr BLUnknown): BLResult
proc blContextFillGlyphRunD*(self: ptr BLContextCore; origin: ptr BLPoint;   font: ptr BLFontCore; glyphRun: ptr BLGlyphRun): BLResult
proc blContextFillGlyphRunDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba32: uint32): BLResult
proc blContextFillGlyphRunDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba64: uint64): BLResult
proc blContextFillGlyphRunDExt*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; style: ptr BLUnknown): BLResult
proc blContextFillMaskI*(self: ptr BLContextCore; origin: ptr BLPointI; mask: ptr BLImageCore; maskArea: ptr BLRectI): BLResult
proc blContextFillMaskIRgba32*(self: ptr BLContextCore; origin: ptr BLPointI; mask: ptr BLImageCore; maskArea: ptr BLRectI; rgba32: uint32): BLResult
proc blContextFillMaskIRgba64*(self: ptr BLContextCore; origin: ptr BLPointI; mask: ptr BLImageCore; maskArea: ptr BLRectI; rgba64: uint64): BLResult
proc blContextFillMaskIExt*(self: ptr BLContextCore; origin: ptr BLPointI;  mask: ptr BLImageCore; maskArea: ptr BLRectI;  style: ptr BLUnknown): BLResult
proc blContextFillMaskD*(self: ptr BLContextCore; origin: ptr BLPoint; mask: ptr BLImageCore; maskArea: ptr BLRectI): BLResult
proc blContextFillMaskDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint; mask: ptr BLImageCore; maskArea: ptr BLRectI; rgba32: uint32): BLResult
proc blContextFillMaskDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint; mask: ptr BLImageCore; maskArea: ptr BLRectI; rgba64: uint64): BLResult
proc blContextFillMaskDExt*(self: ptr BLContextCore; origin: ptr BLPoint;  mask: ptr BLImageCore; maskArea: ptr BLRectI;  style: ptr BLUnknown): BLResult
proc blContextStrokeRectI*(self: ptr BLContextCore; rect: ptr BLRectI): BLResult
proc blContextStrokeRectIRgba32*(self: ptr BLContextCore; rect: ptr BLRectI;  rgba32: uint32): BLResult
proc blContextStrokeRectIRgba64*(self: ptr BLContextCore; rect: ptr BLRectI;  rgba64: uint64): BLResult
proc blContextStrokeRectIExt*(self: ptr BLContextCore; rect: ptr BLRectI; style: ptr BLUnknown): BLResult
proc blContextStrokeRectD*(self: ptr BLContextCore; rect: ptr BLRect): BLResult
proc blContextStrokeRectDRgba32*(self: ptr BLContextCore; rect: ptr BLRect;  rgba32: uint32): BLResult
proc blContextStrokeRectDRgba64*(self: ptr BLContextCore; rect: ptr BLRect;  rgba64: uint64): BLResult
proc blContextStrokeRectDExt*(self: ptr BLContextCore; rect: ptr BLRect; style: ptr BLUnknown): BLResult
proc blContextStrokePathD*(self: ptr BLContextCore; origin: ptr BLPoint; path: ptr BLPathCore): BLResult
proc blContextStrokePathDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint;  path: ptr BLPathCore; rgba32: uint32): BLResult
proc blContextStrokePathDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint;  path: ptr BLPathCore; rgba64: uint64): BLResult
proc blContextStrokePathDExt*(self: ptr BLContextCore; origin: ptr BLPoint; path: ptr BLPathCore; style: ptr BLUnknown): BLResult
proc blContextStrokeGeometry*(self: ptr BLContextCore; `type`: BLGeometryType; data: pointer): BLResult
proc blContextStrokeGeometryRgba32*(self: ptr BLContextCore;  `type`: BLGeometryType; data: pointer;  rgba32: uint32): BLResult
proc blContextStrokeGeometryRgba64*(self: ptr BLContextCore;  `type`: BLGeometryType; data: pointer;  rgba64: uint64): BLResult
proc blContextStrokeGeometryExt*(self: ptr BLContextCore;  `type`: BLGeometryType; data: pointer;  style: ptr BLUnknown): BLResult
proc blContextStrokeUtf8TextI*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: cstring; size: uint): BLResult
proc blContextStrokeUtf8TextIRgba32*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: cstring; size: uint; rgba32: uint32): BLResult
proc blContextStrokeUtf8TextIRgba64*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: cstring; size: uint; rgba64: uint64): BLResult
proc blContextStrokeUtf8TextIExt*(self: ptr BLContextCore; origin: ptr BLPointI;font: ptr BLFontCore; text: cstring;size: uint; style: ptr BLUnknown): BLResult
proc blContextStrokeUtf8TextD*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: cstring; size: uint): BLResult
proc blContextStrokeUtf8TextDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: cstring; size: uint; rgba32: uint32): BLResult
proc blContextStrokeUtf8TextDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: cstring; size: uint; rgba64: uint64): BLResult
proc blContextStrokeUtf8TextDExt*(self: ptr BLContextCore; origin: ptr BLPoint;font: ptr BLFontCore; text: cstring;size: uint; style: ptr BLUnknown): BLResult
proc blContextStrokeUtf16TextI*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint16; size: uint): BLResult
proc blContextStrokeUtf16TextIRgba32*(self: ptr BLContextCore;  origin: ptr BLPointI;  font: ptr BLFontCore; text: ptr uint16;  size: uint; rgba32: uint32): BLResult
proc blContextStrokeUtf16TextIRgba64*(self: ptr BLContextCore;  origin: ptr BLPointI;  font: ptr BLFontCore; text: ptr uint16;  size: uint; rgba64: uint64): BLResult
proc blContextStrokeUtf16TextIExt*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint16; size: uint; style: ptr BLUnknown): BLResult
proc blContextStrokeUtf16TextD*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint16; size: uint): BLResult
proc blContextStrokeUtf16TextDRgba32*(self: ptr BLContextCore;  origin: ptr BLPoint; font: ptr BLFontCore;  text: ptr uint16; size: uint;  rgba32: uint32): BLResult
proc blContextStrokeUtf16TextDRgba64*(self: ptr BLContextCore;  origin: ptr BLPoint; font: ptr BLFontCore;  text: ptr uint16; size: uint;  rgba64: uint64): BLResult
proc blContextStrokeUtf16TextDExt*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint16; size: uint; style: ptr BLUnknown): BLResult
proc blContextStrokeUtf32TextI*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint32; size: uint): BLResult
proc blContextStrokeUtf32TextIRgba32*(self: ptr BLContextCore;  origin: ptr BLPointI;  font: ptr BLFontCore; text: ptr uint32;  size: uint; rgba32: uint32): BLResult
proc blContextStrokeUtf32TextIRgba64*(self: ptr BLContextCore;  origin: ptr BLPointI;  font: ptr BLFontCore; text: ptr uint32;  size: uint; rgba64: uint64): BLResult
proc blContextStrokeUtf32TextIExt*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; text: ptr uint32; size: uint; style: ptr BLUnknown): BLResult
proc blContextStrokeUtf32TextD*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint32; size: uint): BLResult
proc blContextStrokeUtf32TextDRgba32*(self: ptr BLContextCore;  origin: ptr BLPoint; font: ptr BLFontCore;  text: ptr uint32; size: uint;  rgba32: uint32): BLResult
proc blContextStrokeUtf32TextDRgba64*(self: ptr BLContextCore;  origin: ptr BLPoint; font: ptr BLFontCore;  text: ptr uint32; size: uint;  rgba64: uint64): BLResult
proc blContextStrokeUtf32TextDExt*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; text: ptr uint32; size: uint; style: ptr BLUnknown): BLResult
proc blContextStrokeGlyphRunI*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun): BLResult
proc blContextStrokeGlyphRunIRgba32*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba32: uint32): BLResult
proc blContextStrokeGlyphRunIRgba64*(self: ptr BLContextCore; origin: ptr BLPointI; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba64: uint64): BLResult
proc blContextStrokeGlyphRunIExt*(self: ptr BLContextCore; origin: ptr BLPointI;font: ptr BLFontCore;glyphRun: ptr BLGlyphRun; style: ptr BLUnknown): BLResult
proc blContextStrokeGlyphRunD*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun): BLResult
proc blContextStrokeGlyphRunDRgba32*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba32: uint32): BLResult
proc blContextStrokeGlyphRunDRgba64*(self: ptr BLContextCore; origin: ptr BLPoint; font: ptr BLFontCore; glyphRun: ptr BLGlyphRun; rgba64: uint64): BLResult
proc blContextStrokeGlyphRunDExt*(self: ptr BLContextCore; origin: ptr BLPoint;font: ptr BLFontCore;glyphRun: ptr BLGlyphRun; style: ptr BLUnknown): BLResult
proc blContextBlitImageI*(self: ptr BLContextCore; origin: ptr BLPointI; img: ptr BLImageCore; imgArea: ptr BLRectI): BLResult
proc blContextBlitImageD*(self: ptr BLContextCore; origin: ptr BLPoint; img: ptr BLImageCore; imgArea: ptr BLRectI): BLResult
proc blContextBlitScaledImageI*(self: ptr BLContextCore; rect: ptr BLRectI; img: ptr BLImageCore; imgArea: ptr BLRectI): BLResult
proc blContextBlitScaledImageD*(self: ptr BLContextCore; rect: ptr BLRect; img: ptr BLImageCore; imgArea: ptr BLRectI): BLResult

{.pop.}