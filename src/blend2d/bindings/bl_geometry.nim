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

{.push importc, header: blend2dHeader.}
type
  BLGeometryDirection* {.size: sizeof(uint32).} = enum
    BL_GEOMETRY_DIRECTION_NONE      ## No direction specified
    BL_GEOMETRY_DIRECTION_CW        ## Clockwise direction
    BL_GEOMETRY_DIRECTION_CCW       ## Counter-clockwise direction

  BLGeometryType* {.size: sizeof(uint32).} = enum
    BL_GEOMETRY_TYPE_NONE   ## No geometry provided
    BL_GEOMETRY_TYPE_BOXI   ## BLBoxI struct
    BL_GEOMETRY_TYPE_BOXD   ## BLBox struct
    BL_GEOMETRY_TYPE_RECTI  ## BLRectI struct
    BL_GEOMETRY_TYPE_RECTD  ## BLRect struct
    BL_GEOMETRY_TYPE_CIRCLE   ## BLCircle struct
    BL_GEOMETRY_TYPE_ELLIPSE  ## BLEllipse struct
    BL_GEOMETRY_TYPE_ROUND_RECT   ## BLRoundRect struct
    BL_GEOMETRY_TYPE_ARC  ## BLArc struct
    BL_GEOMETRY_TYPE_CHORD  ## BLArc struct representing chord
    BL_GEOMETRY_TYPE_PIE  ## BLArc struct representing pie
    BL_GEOMETRY_TYPE_LINE   ## BLLine struct
    BL_GEOMETRY_TYPE_TRIANGLE   ## BLTriangle struct
    BL_GEOMETRY_TYPE_POLYLINEI  ## BLArrayView<BLPointI> representing a polyline
    BL_GEOMETRY_TYPE_POLYLINED  ## BLArrayView<BLPoint> representing a polyline
    BL_GEOMETRY_TYPE_POLYGONI   ## BLArrayView<BLPointI> representing a polygon
    BL_GEOMETRY_TYPE_POLYGOND   ## BLArrayView<BLPoint> representing a polygon
    BL_GEOMETRY_TYPE_ARRAY_VIEW_BOXI  ## BLArrayView<BLBoxI> struct
    BL_GEOMETRY_TYPE_ARRAY_VIEW_BOXD  ## BLArrayView<BLBox> struct
    BL_GEOMETRY_TYPE_ARRAY_VIEW_RECTI   ## BLArrayView<BLRectI> struct
    BL_GEOMETRY_TYPE_ARRAY_VIEW_RECTD   ## BLArrayView<BLRect> struct
    BL_GEOMETRY_TYPE_PATH   ## BLPath (or BLPathCore)
    BL_GEOMETRY_TYPE_MAX_VALUE  ## Maximum value of BLGeometryType## 

  BLFillRule* {.size: sizeof(uint32).} = enum
    BL_FILL_RULE_NON_ZERO  ## Non-zero fill-rule.
    BL_FILL_RULE_EVEN_ODD  ## Even-odd fill-rule
    BL_FILL_RULE_MAX_VALUE ## Max value of BLFillRule

  BLHitTest* {.size: sizeof(uint32).} = enum
    BL_HIT_TEST_IN  ## Fully in.
    BL_HIT_TEST_PART  ## Partially in/out.
    BL_HIT_TEST_OUT  ##  Fully out.
    BL_HIT_TEST_INVALID  ##  Hit test failed (invalid argument, NaNs, etc).

  BLTransformType* {.size: sizeof(uint32).} = enum
    ## Transformation matrix type that can be obtained by calling BLMatrix2D::type().
    BL_TRANSFORM_TYPE_IDENTITY    ## Identity matrix
    BL_TRANSFORM_TYPE_TRANSLATE   ## Has translation part (the rest is like identity).
    BL_TRANSFORM_TYPE_SCALE ## Has translation and scaling parts.
    BL_TRANSFORM_TYPE_SWAP ## Has translation and scaling parts, however scaling swaps X/Y.
    BL_TRANSFORM_TYPE_AFFINE  ## Generic affine matrix.
    BL_TRANSFORM_TYPE_INVALID ## Invalid/degenerate matrix not useful for transformations.
    BL_TRANSFORM_TYPE_MAX_VALUE ## Maximum value of BLTransformType.

  BLTransformOp* {.size: sizeof(uint32).} = enum
    ## Transformation matrix operation type
    BL_TRANSFORM_OP_RESET ## Reset matrix to identity (argument ignored, should be nullptr).
    BL_TRANSFORM_OP_ASSIGN  ## Assign (copy) the other matrix.
    BL_TRANSFORM_OP_TRANSLATE ## Translate the matrix by [x, y].
    BL_TRANSFORM_OP_SCALE ## Scale the matrix by [x, y].
    BL_TRANSFORM_OP_SKEW  ## Skew the matrix by [x, y].
    BL_TRANSFORM_OP_ROTATE  ## Rotate the matrix by the given angle about [0, 0].
    BL_TRANSFORM_OP_ROTATE_PT ## Rotate the matrix by the given angle about [x, y].
    BL_TRANSFORM_OP_TRANSFORM ## Transform this matrix by other BLMatrix2D.
    BL_TRANSFORM_OP_POST_TRANSLATE  ## Post-translate the matrix by [x, y].
    BL_TRANSFORM_OP_POST_SCALE  ## Post-scale the matrix by [x, y].
    BL_TRANSFORM_OP_POST_SKEW ## Post-skew the matrix by [x, y].
    BL_TRANSFORM_OP_POST_ROTATE ## Post-rotate the matrix about [0, 0].
    BL_TRANSFORM_OP_POST_ROTATE_PT  ## Post-rotate the matrix about a reference BLPoint.
    BL_TRANSFORM_OP_POST_TRANSFORM  ## Post-transform this matrix by other BLMatrix2D.
    BL_TRANSFORM_OP_MAX_VALUE ## Maximum value of BLTransformOp.

  BLPathCmd* {.size: sizeof(uint32).} = enum
    ## Path command
    BL_PATH_CMD_MOVE ## Move-to command (starts a new figure)
    BL_PATH_CMD_ON ## On-path command (interpreted as line-to or the end of a curve).
    BL_PATH_CMD_QUAD ## Quad-to control point
    BL_PATH_CMD_CONIC ## Conic-to control point
    BL_PATH_CMD_CUBIC ## Cubic-to control point (always used as a pair of commands).
    BL_PATH_CMD_CLOSE ## Close path
    BL_PATH_CMD_WEIGHT ## Conic weight
    BL_PATH_CMD_MAX_VALUE ## Maximum value of `BLPathCmd`.

  BLPathReverseMode* {.size: sizeof(uint32).} = enum
    BL_PATH_REVERSE_MODE_COMPLETE   ## Reverse each figure and their order as well (default)
    BL_PATH_REVERSE_MODE_SEPARATE   ## Reverse each figure separately (keeps their order)
    BL_PATH_REVERSE_MODE_MAX_VALUE  ## Maximum value of BLPathReverseMode.

  BLStrokeJoin* {.size: sizeof(uint32).} = enum
    BL_STROKE_JOIN_MITER_CLIP   ## Miter-join possibly clipped at miterLimit [default]
    BL_STROKE_JOIN_MITER_BEVEL  ## Miter-join or bevel-join depending on miterLimit condition
    BL_STROKE_JOIN_MITER_ROUND  ## Miter-join or round-join depending on miterLimit condition
    BL_STROKE_JOIN_BEVEL  ## Bevel-join
    BL_STROKE_JOIN_ROUND  ## Round-join
    BL_STROKE_JOIN_MAX_VALUE  ## Maximum value of BLStrokeJoin.

  BLStrokeCapPosition* {.size: sizeof(uint32).} = enum
    BL_STROKE_CAP_POSITION_START ## Start of the path.
    BL_STROKE_CAP_POSITION_END ## End of the path.
    BL_STROKE_CAP_POSITION_MAX_VALUE ## Maximum value of BLStrokeCapPosition.

  BLStrokeCap* {.size: sizeof(uint32).} = enum
    BL_STROKE_CAP_BUTT ## Butt cap [default].
    BL_STROKE_CAP_SQUARE ## Square cap.
    BL_STROKE_CAP_ROUND ## Round cap.
    BL_STROKE_CAP_ROUND_REV ## Round cap reversed.
    BL_STROKE_CAP_TRIANGLE ## Triangle cap.
    BL_STROKE_CAP_TRIANGLE_REV ## Triangle cap reversed.
    BL_STROKE_CAP_MAX_VALUE ## Maximum value of BLStrokeCap.

  BLStrokeTransformOrder* {.size: sizeof(uint32).} = enum
    BL_STROKE_TRANSFORM_ORDER_AFTER ## Transform after stroke => Transform(Stroke(Input)) [default].
    BL_STROKE_TRANSFORM_ORDER_BEFORE ## Transform before stroke => Stroke(Transform(Input)).
    BL_STROKE_TRANSFORM_ORDER_MAX_VALUE ## Maximum value of BLStrokeTransformOrder.

  BLFlattenMode* {.size: sizeof(uint32).} = enum
    BL_FLATTEN_MODE_DEFAULT   ## Use default mode (decided by Blend2D).
    BL_FLATTEN_MODE_RECURSIVE   ## Recursive subdivision flattening.
    BL_FLATTEN_MODE_MAX_VALUE   ## Maximum value of BLFlattenMode.

  BLOffsetMode {.size: sizeof(uint32).} = enum
    BL_OFFSET_MODE_DEFAULT ## Use default mode (decided by Blend2D).
    BL_OFFSET_MODE_ITERATIVE ## Iterative offset construction
    BL_OFFSET_MODE_MAX_VALUE ## Maximum value of BLOffsetMode.

  BLPoint* {.bycopy.} = object
    x*, y*: cdouble
  
  BLPointI* {.bycopy.} = object 
    ## Point specified as [x, y] using int as a storage type.
    x*, y*: cint
  
  BLSize* {.bycopy.} = object 
    ## Size specified as [w, h] using double as a storage type.
    w*, h*: cdouble
  
  BLSizeI* {.bycopy.} = object
    ## Size specified as [w, h] using int as a storage type.
    w*, h*: cint
  
  BLBox* {.bycopy.} = object
    ## Box specified as [x0, y0, x1, y1] using double as a storage type.
    x0*, y0*, x1*, y1*: cdouble
  
  BLBoxI* {.bycopy.} = object
    ## Box specified as [x0, y0, x1, y1] using int as a storage type.
    x0*, y0*, x1*, y1*: cint
  
  BLRect* {.bycopy.} = object
    ## Rectangle specified as [x, y, w, h] using double as a storage type.
    x*, y*, w*, h*: cdouble

  BLRectI* {.bycopy.} = object
    ## Rectangle specified as [x, y, w, h] using int as a storage type.
    x*, y*, w*, h*: cint

  BLLine* {.bycopy.} = object
    ## Line specified as [x0, y0, x1, y1] using double as a storage type.
    x0*, y0*, x1*, y1*: cdouble
  
  BLTriangle* {.bycopy.} = object
    ## Triangle data specified as [x0, y0, x1, y1, x2, y2] using double as a storage type.
    x0*, y0*, x1*, y1*, x2*, y2*: cdouble

  BLRoundRect* {.bycopy.} = object
    ## Rounded rectangle specified as [x, y, w, h, rx, ry] using double as a storage type.
    x*, y*, w*, h*, rx*, ry*: cdouble

  BLCircle* {.bycopy.} = object 
    ## Circle specified as [cx, cy, r] using double as a storage type.
    cx*, cy*, r*: cdouble

  BLEllipse* {.bycopy.} = object
    ## Ellipse specified as [cx, cy, rx, ry] using double as a storage type.
    cx*,cy*, rx*, ry*: cdouble

  BLArc* {.bycopy.} = object
    ## Arc specified as [cx, cy, rx, ry, start, sweep] using double as a storage type.
    cx*, cy*, rx*, ry*, start*, sweep*: cdouble
  
  BLMatrix2D* {.bycopy.} = object
    m*: array[6, cdouble]
    m00*, m01*, m10*, m11*,
      m20*, m21*: cdouble

  BLApproximationOptions* {.bycopy.} = object
    flattenMode*: uint8
      ## Specifies how curves are flattened, see FlattenMode.
    offsetMode*: uint8
      ## Specifies how curves are offsetted (used by stroking), see BLOffsetMode.
    reservedFlags*: array[6, uint8]
      ## Reserved for future use, must be zero.
    flattenTolerance*: cdouble
      ## Tolerance used to flatten curves.
    simplifyTolerance*: cdouble
      ## Tolerance used to approximate cubic curves with quadratic curves.
    offsetParameter*: cdouble
      ## Curve offsetting parameter, exact meaning depends on offsetMode.
  
  BLStrokeOptionsCore* {.bycopy.} = object
    startCap*: uint8
    endCap*: uint8
    join*: uint8
    transformOrder*: uint8
    reserved*: array[4, uint8]
    caps*: array[BL_STROKE_CAP_POSITION_MAX_VALUE.ord + 1, uint8]
    hints*: uint64
    width*: cdouble
    miterLimit*: cdouble
    dashOffset*: cdouble
    dashArray*: BLArrayCore

  BLPathCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLPathSinkFunc* =
    proc (path: ptr BLPathCore; info: pointer; userData: pointer): BLResult {.cdecl.}
  BLPathStrokeSinkFunc* =
      proc (a, b, c: ptr BLPathCore; inputStart, inputEnd: uint; userData: pointer): BLResult {.cdecl.}
{.pop.}

{.push importc, cdecl, header: blend2dHeader.}
#
# BLPath API
#
proc blPathInit*(self: ptr BLPathCore): BLResult
proc blPathInitMove*(self: ptr BLPathCore; other: ptr BLPathCore): BLResult
proc blPathInitWeak*(self: ptr BLPathCore; other: ptr BLPathCore): BLResult
proc blPathDestroy*(self: ptr BLPathCore): BLResult
proc blPathReset*(self: ptr BLPathCore): BLResult
proc blPathGetSize*(self: ptr BLPathCore): uint
proc blPathGetCapacity*(self: ptr BLPathCore): uint
proc blPathGetCommandData*(self: ptr BLPathCore): ptr uint8
proc blPathGetVertexData*(self: ptr BLPathCore): ptr BLPoint
proc blPathClear*(self: ptr BLPathCore): BLResult
proc blPathShrink*(self: ptr BLPathCore): BLResult
proc blPathReserve*(self: ptr BLPathCore; n: uint): BLResult
proc blPathModifyOp*(self: ptr BLPathCore; op: BLModifyOp; n: uint; cmdDataOut: ptr ptr uint8; vtxDataOut: ptr ptr BLPoint): BLResult
proc blPathAssignMove*(self: ptr BLPathCore; other: ptr BLPathCore): BLResult
proc blPathAssignWeak*(self: ptr BLPathCore; other: ptr BLPathCore): BLResult
proc blPathAssignDeep*(self: ptr BLPathCore; other: ptr BLPathCore): BLResult
proc blPathSetVertexAt*(self: ptr BLPathCore; index: uint; cmd: uint32; x: cdouble; y: cdouble): BLResult
proc blPathMoveTo*(self: ptr BLPathCore; x0: cdouble; y0: cdouble): BLResult
proc blPathLineTo*(self: ptr BLPathCore; x1: cdouble; y1: cdouble): BLResult
proc blPathPolyTo*(self: ptr BLPathCore; poly: ptr BLPoint; count: uint): BLResult
proc blPathQuadTo*(self: ptr BLPathCore; x1: cdouble; y1: cdouble; x2: cdouble; y2: cdouble): BLResult
proc blPathConicTo*(self: ptr BLPathCore; x1, y1, x2, y2, w: cdouble): BLResult
proc blPathCubicTo*(self: ptr BLPathCore; x1, y1, x2, y2, x3, y3: cdouble): BLResult
proc blPathSmoothQuadTo*(self: ptr BLPathCore; x2, y2: cdouble): BLResult
proc blPathSmoothCubicTo*(self: ptr BLPathCore; x2, y2, x3, y3: cdouble): BLResult
proc blPathArcTo*(self: ptr BLPathCore; x, y, rx, ry, start, sweep: cdouble; forceMoveTo: bool): BLResult
proc blPathArcQuadrantTo*(self: ptr BLPathCore; x1, y1, x2, y2: cdouble): BLResult
proc blPathEllipticArcTo*(self: ptr BLPathCore; rx, ry, xAxisRotation: cdouble; largeArcFlag: bool; sweepFlag: bool; x1, y1: cdouble): BLResult
proc blPathClose*(self: ptr BLPathCore): BLResult
proc blPathAddGeometry*(self: ptr BLPathCore; geometryType: BLGeometryType; geometryData: pointer; m: ptr BLMatrix2D; dir: BLGeometryDirection): BLResult
proc blPathAddBoxI*(self: ptr BLPathCore; box: ptr BLBoxI; dir: BLGeometryDirection): BLResult
proc blPathAddBoxD*(self: ptr BLPathCore; box: ptr BLBox; dir: BLGeometryDirection): BLResult
proc blPathAddRectI*(self: ptr BLPathCore; rect: ptr BLRectI; dir: BLGeometryDirection): BLResult
proc blPathAddRectD*(self: ptr BLPathCore; rect: ptr BLRect; dir: BLGeometryDirection): BLResult
proc blPathAddPath*(self: ptr BLPathCore; other: ptr BLPathCore; range: ptr BLRange): BLResult
proc blPathAddTranslatedPath*(self: ptr BLPathCore; other: ptr BLPathCore; range: ptr BLRange; p: ptr BLPoint): BLResult
proc blPathAddTransformedPath*(self: ptr BLPathCore; other: ptr BLPathCore; range: ptr BLRange; m: ptr BLMatrix2D): BLResult
proc blPathAddReversedPath*(self: ptr BLPathCore; other: ptr BLPathCore; range: ptr BLRange; reverseMode: BLPathReverseMode): BLResult
proc blPathAddStrokedPath*(self: ptr BLPathCore; other: ptr BLPathCore; range: ptr BLRange; options: ptr BLStrokeOptionsCore; approx: ptr BLApproximationOptions): BLResult
proc blPathRemoveRange*(self: ptr BLPathCore; range: ptr BLRange): BLResult
proc blPathTranslate*(self: ptr BLPathCore; range: ptr BLRange; p: ptr BLPoint): BLResult
proc blPathTransform*(self: ptr BLPathCore; range: ptr BLRange; m: ptr BLMatrix2D): BLResult
proc blPathFitTo*(self: ptr BLPathCore; range: ptr BLRange; rect: ptr BLRect; fitFlags: uint32): BLResult
proc blPathEquals*(a: ptr BLPathCore; b: ptr BLPathCore): bool
proc blPathGetInfoFlags*(self: ptr BLPathCore; flagsOut: ptr uint32): BLResult
proc blPathGetControlBox*(self: ptr BLPathCore; boxOut: ptr BLBox): BLResult
proc blPathGetBoundingBox*(self: ptr BLPathCore; boxOut: ptr BLBox): BLResult
proc blPathGetFigureRange*(self: ptr BLPathCore; index: uint; rangeOut: ptr BLRange): BLResult
proc blPathGetLastVertex*(self: ptr BLPathCore; vtxOut: ptr BLPoint): BLResult
proc blPathGetClosestVertex*(self: ptr BLPathCore; p: ptr BLPoint; maxDistance: cdouble; indexOut: ptr uint; distanceOut: ptr cdouble): BLResult
proc blPathHitTest*(self: ptr BLPathCore; p: ptr BLPoint; fillRule: BLFillRule): BLHitTest
proc blStrokeOptionsInit*(self: ptr BLStrokeOptionsCore): BLResult
proc blStrokeOptionsInitMove*(self: ptr BLStrokeOptionsCore; other: ptr BLStrokeOptionsCore): BLResult
proc blStrokeOptionsInitWeak*(self: ptr BLStrokeOptionsCore; other: ptr BLStrokeOptionsCore): BLResult
proc blStrokeOptionsDestroy*(self: ptr BLStrokeOptionsCore): BLResult
proc blStrokeOptionsReset*(self: ptr BLStrokeOptionsCore): BLResult
proc blStrokeOptionsEquals*(a: ptr BLStrokeOptionsCore; b: ptr BLStrokeOptionsCore): bool
proc blStrokeOptionsAssignMove*(self: ptr BLStrokeOptionsCore; other: ptr BLStrokeOptionsCore): BLResult
proc blStrokeOptionsAssignWeak*(self: ptr BLStrokeOptionsCore; other: ptr BLStrokeOptionsCore): BLResult
proc blPathStrokeToSink*(self: ptr BLPathCore; range: ptr BLRange; strokeOptions: ptr BLStrokeOptionsCore;
    approximationOptions: ptr BLApproximationOptions; a,b,c: ptr BLPathCore;
    `sink`: BLPathStrokeSinkFunc; userData: pointer): BLResult

#
# BLMatrix2d API
#
proc blMatrix2DSetIdentity*(self: ptr BLMatrix2D): BLResult
proc blMatrix2DSetTranslation*(self: ptr BLMatrix2D; x: cdouble; y: cdouble): BLResult
proc blMatrix2DSetScaling*(self: ptr BLMatrix2D; x: cdouble; y: cdouble): BLResult
proc blMatrix2DSetSkewing*(self: ptr BLMatrix2D; x: cdouble; y: cdouble): BLResult
proc blMatrix2DSetRotation*(self: ptr BLMatrix2D; angle: cdouble; cx: cdouble; cy: cdouble): BLResult
proc blMatrix2DApplyOp*(self: ptr BLMatrix2D; opType: BLTransformOp; opData: pointer): BLResult
proc blMatrix2DInvert*(dst: ptr BLMatrix2D; src: ptr BLMatrix2D): BLResult
proc blMatrix2DGetType*(self: ptr BLMatrix2D): BLTransformType
proc blMatrix2DMapPointDArray*(self: ptr BLMatrix2D; dst: ptr BLPoint; src: ptr BLPoint; count: uint): BLResult
{.pop.}