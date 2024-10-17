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

from ./bl_image import BLImageCore
from ./bl_geometry import BLMatrix2D, BLRectI, BLTransformType, BLTransformOp

{.push importc, header: blend2dHeader.}
type
  BLExtendMode* {.size: sizeof(uint32).} = enum
    BL_EXTEND_MODE_PAD ## Pad extend [default].
    BL_EXTEND_MODE_REPEAT ## Repeat extend.
    BL_EXTEND_MODE_REFLECT ## Reflect extend.
    BL_EXTEND_MODE_PAD_X_PAD_Y ## Alias to BL_EXTEND_MODE_PAD.
    BL_EXTEND_MODE_PAD_X_REPEAT_Y ## Pad X and repeat Y.
    BL_EXTEND_MODE_PAD_X_REFLECT_Y ## Pad X and reflect Y.
    BL_EXTEND_MODE_REPEAT_X_REPEAT_Y ## Alias to BL_EXTEND_MODE_REPEAT.
    BL_EXTEND_MODE_REPEAT_X_PAD_Y ## Repeat X and pad Y.
    BL_EXTEND_MODE_REPEAT_X_REFLECT_Y ## Repeat X and reflect Y.
    BL_EXTEND_MODE_REFLECT_X_REFLECT_Y ## Alias to BL_EXTEND_MODE_REFLECT.
    BL_EXTEND_MODE_REFLECT_X_PAD_Y ## Reflect X and pad Y.
    BL_EXTEND_MODE_REFLECT_X_REPEAT_Y ## Reflect X and repeat Y.
    BL_EXTEND_MODE_SIMPLE_MAX_VALUE ## Count of simple extend modes (that use the same value for X and Y).
    BL_EXTEND_MODE_COMPLEX_MAX_VALUE ## Count of complex extend modes (that can use independent values for X and Y).
    BL_EXTEND_MODE_MAX_VALUE ## Maximum value of BLExtendMode.

  BLGradientType* {.size: sizeof(uint32).} = enum
    BL_GRADIENT_TYPE_LINEAR ## Linear gradient type.
    BL_GRADIENT_TYPE_RADIAL ## Radial gradient type.
    BL_GRADIENT_TYPE_CONIC ## Conic gradient type.
    BL_GRADIENT_TYPE_MAX_VALUE ## Maximum value of BLGradientType.

  BLGradientValue* {.size: sizeof(uint32).} = enum
    BL_GRADIENT_VALUE_COMMON_X0 ## x0 - start 'x' for a Linear gradient and x center for both Radial and Conic gradients.
    BL_GRADIENT_VALUE_COMMON_Y0 ## y0 - start 'y' for a Linear gradient and y center for both Radial and Conic gradients.
    BL_GRADIENT_VALUE_COMMON_X1 ## x1 - end 'x' for a Linear gradient and focal point x for a Radial gradient.
    BL_GRADIENT_VALUE_COMMON_Y1 ## y1 - end 'y' for a Linear/gradient and focal point y for a Radial gradient.
    BL_GRADIENT_VALUE_RADIAL_R0 ## Radial gradient center radius.
    BL_GRADIENT_VALUE_RADIAL_R1 ## Radial gradient focal radius.
    BL_GRADIENT_VALUE_CONIC_ANGLE ## Conic gradient angle.
    BL_GRADIENT_VALUE_CONIC_REPEAT ## Conic gradient angle.
    BL_GRADIENT_VALUE_MAX_VALUE ## Maximum value of BLGradientValue.

  BLGradientQuality* {.size: sizeof(uint32).} = enum
    BL_GRADIENT_QUALITY_NEAREST ## Nearest neighbor
    BL_GRADIENT_QUALITY_SMOOTH ## Use smoothing, if available (currently never available)
    BL_GRADIENT_QUALITY_DITHER ## The renderer will use an implementation-specific dithering algorithm to prevent banding
    BL_GRADIENT_QUALITY_MAX_VALUE  ## Maximum value of BLGradientQuality.

  BLPatternQuality* {.size: sizeof(uint32).} = enum
    BL_PATTERN_QUALITY_NEAREST ## Nearest neighbor interpolation
    BL_PATTERN_QUALITY_BILINEAR ## Bilinear interpolation.
    BL_PATTERN_QUALITY_MAX_VALUE ## Maximum value of BLPatternQuality.

  BLGradientCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLGradientImpl* {.bycopy.} = object
    stops*: ptr BLGradientStop
      ## Gradient stop data.
    size*: uint
      ## Gradient stop count.
    capacity*: uint
      ## Stop capacity.
    transform*: BLMatrix2D
      ## Gradient transformation matrix.
    values*: array[BL_GRADIENT_VALUE_MAX_VALUE.ord, cdouble]
    linear*: BLLinearGradientValues
    radial*: BLRadialGradientValues
    conic*: BLConicGradientValues
  
  BLGradientStop* {.bycopy.} = object
    offset*: cdouble
    rgba*: BLRgba64

  BLLinearGradientValues* {.bycopy.} = object
    x0*, y0*, x1*, y1*: cdouble

  BLRadialGradientValues* {.bycopy.} = object
    x0*, y0*, x1*, y1*, r0*, r1*: cdouble
  
  BLConicGradientValues* {.bycopy.} = object
    x0*, y0*, angle*, repeat*: cdouble

  BLPatternCore* {.bycopy.} = object
    d*: BLObjectDetail
  BLPatternImpl* {.bycopy.} = object
    image*: BLImageCore
      ## Image used by the pattern.
    area*: BLRectI
      ## Image area to use.
    transform*: BLMatrix2D
      ## Pattern transformation matrix.
{.pop.}

{.push importc, cdecl, header: blend2dHeader.}
#
# BLGradient API
#
proc blGradientInit*(self: ptr BLGradientCore): BLResult
proc blGradientInitMove*(self: ptr BLGradientCore; other: ptr BLGradientCore): BLResult
proc blGradientInitWeak*(self: ptr BLGradientCore; other: ptr BLGradientCore): BLResult
proc blGradientInitAs*(self: ptr BLGradientCore; `type`: BLGradientType;
                       values: pointer; extendMode: BLExtendMode;
                       stops: ptr BLGradientStop; n: uint;
                       transform: ptr BLMatrix2D): BLResult
proc blGradientDestroy*(self: ptr BLGradientCore): BLResult
proc blGradientReset*(self: ptr BLGradientCore): BLResult
proc blGradientAssignMove*(self: ptr BLGradientCore; other: ptr BLGradientCore): BLResult
proc blGradientAssignWeak*(self: ptr BLGradientCore; other: ptr BLGradientCore): BLResult
proc blGradientCreate*(self: ptr BLGradientCore; `type`: BLGradientType;
                       values: pointer; extendMode: BLExtendMode;
                       stops: ptr BLGradientStop; n: uint;
                       transform: ptr BLMatrix2D): BLResult
proc blGradientShrink*(self: ptr BLGradientCore): BLResult
proc blGradientReserve*(self: ptr BLGradientCore; n: uint): BLResult
proc blGradientGetType*(self: ptr BLGradientCore): BLGradientType
proc blGradientSetType*(self: ptr BLGradientCore; `type`: BLGradientType): BLResult
proc blGradientGetExtendMode*(self: ptr BLGradientCore): BLExtendMode
proc blGradientSetExtendMode*(self: ptr BLGradientCore; extendMode: BLExtendMode): BLResult
proc blGradientGetValue*(self: ptr BLGradientCore; index: uint): cdouble
proc blGradientSetValue*(self: ptr BLGradientCore; index: uint; value: cdouble): BLResult
proc blGradientSetValues*(self: ptr BLGradientCore; index: uint;
                          values: ptr cdouble; n: uint): BLResult
proc blGradientGetSize*(self: ptr BLGradientCore): uint
proc blGradientGetCapacity*(self: ptr BLGradientCore): uint
proc blGradientGetStops*(self: ptr BLGradientCore): ptr BLGradientStop
proc blGradientResetStops*(self: ptr BLGradientCore): BLResult
proc blGradientAssignStops*(self: ptr BLGradientCore; stops: ptr BLGradientStop;
                            n: uint): BLResult
proc blGradientAddStopRgba32*(self: ptr BLGradientCore; offset: cdouble;
                              argb32: uint32): BLResult
proc blGradientAddStopRgba64*(self: ptr BLGradientCore; offset: cdouble;
                              argb64: uint64): BLResult
proc blGradientRemoveStop*(self: ptr BLGradientCore; index: uint): BLResult
proc blGradientRemoveStopByOffset*(self: ptr BLGradientCore; offset: cdouble;
                                   all: uint32): BLResult
proc blGradientRemoveStopsByIndex*(self: ptr BLGradientCore; rStart: uint;
                                   rEnd: uint): BLResult
proc blGradientRemoveStopsByOffset*(self: ptr BLGradientCore;
                                    offsetMin: cdouble; offsetMax: cdouble): BLResult
proc blGradientReplaceStopRgba32*(self: ptr BLGradientCore; index: uint;
                                  offset: cdouble; rgba32: uint32): BLResult
proc blGradientReplaceStopRgba64*(self: ptr BLGradientCore; index: uint;
                                  offset: cdouble; rgba64: uint64): BLResult
proc blGradientIndexOfStop*(self: ptr BLGradientCore; offset: cdouble): uint
proc blGradientGetTransform*(self: ptr BLGradientCore;
                             transformOut: ptr BLMatrix2D): BLResult
proc blGradientGetTransformType*(self: ptr BLGradientCore): BLTransformType
proc blGradientApplyTransformOp*(self: ptr BLGradientCore;
                                 opType: BLTransformOp; opData: pointer): BLResult
proc blGradientEquals*(a: ptr BLGradientCore; b: ptr BLGradientCore): bool


#
# BLPattern API
#
proc blPatternInit*(self: ptr BLPatternCore): BLResult
proc blPatternInitMove*(self: ptr BLPatternCore; other: ptr BLPatternCore): BLResult
proc blPatternInitWeak*(self: ptr BLPatternCore; other: ptr BLPatternCore): BLResult
proc blPatternInitAs*(self: ptr BLPatternCore; image: ptr BLImageCore;
                      area: ptr BLRectI; extendMode: BLExtendMode;
                      transform: ptr BLMatrix2D): BLResult
proc blPatternDestroy*(self: ptr BLPatternCore): BLResult
proc blPatternReset*(self: ptr BLPatternCore): BLResult
proc blPatternAssignMove*(self: ptr BLPatternCore; other: ptr BLPatternCore): BLResult
proc blPatternAssignWeak*(self: ptr BLPatternCore; other: ptr BLPatternCore): BLResult
proc blPatternAssignDeep*(self: ptr BLPatternCore; other: ptr BLPatternCore): BLResult
proc blPatternCreate*(self: ptr BLPatternCore; image: ptr BLImageCore;
                      area: ptr BLRectI; extendMode: BLExtendMode;
                      transform: ptr BLMatrix2D): BLResult
proc blPatternGetImage*(self: ptr BLPatternCore; image: ptr BLImageCore): BLResult
proc blPatternSetImage*(self: ptr BLPatternCore; image: ptr BLImageCore;
                        area: ptr BLRectI): BLResult
proc blPatternResetImage*(self: ptr BLPatternCore): BLResult
proc blPatternGetArea*(self: ptr BLPatternCore; areaOut: ptr BLRectI): BLResult
proc blPatternSetArea*(self: ptr BLPatternCore; area: ptr BLRectI): BLResult
proc blPatternResetArea*(self: ptr BLPatternCore): BLResult
proc blPatternGetExtendMode*(self: ptr BLPatternCore): BLExtendMode
proc blPatternSetExtendMode*(self: ptr BLPatternCore; extendMode: BLExtendMode): BLResult
proc blPatternGetTransform*(self: ptr BLPatternCore;
                            transformOut: ptr BLMatrix2D): BLResult
proc blPatternGetTransformType*(self: ptr BLPatternCore): BLTransformType
proc blPatternApplyTransformOp*(self: ptr BLPatternCore; opType: BLTransformOp;
                                opData: pointer): BLResult
proc blPatternEquals*(a: ptr BLPatternCore; b: ptr BLPatternCore): bool
{.pop.}