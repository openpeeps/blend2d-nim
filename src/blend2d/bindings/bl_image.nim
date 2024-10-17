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
from ./bl_geometry import BLSizeI, BLSize, BLPointI

{.push importc, header: blend2dHeader.}
type
  BLFormat* {.size: sizeof(uint32).} = enum
    BL_FORMAT_NONE ## None or invalid pixel format
    BL_FORMAT_PRGB32 ## 32-bit premultiplied ARGB pixel format (8-bit components)
    BL_FORMAT_XRGB32 ## 32-bit (X)RGB pixel format (8-bit components, alpha ignored)
    BL_FORMAT_A8 ## 8-bit alpha-only pixel format.

  BLFormatFlags* {.size: sizeof(uint32).} = enum
    BL_FORMAT_NO_FLAGS ## No flags
    BL_FORMAT_FLAG_RGB ## Pixel format provides RGB components
    BL_FORMAT_FLAG_ALPHA ## Pixel format provides only alpha component
    BL_FORMAT_FLAG_RGBA ## A combination of BL_FORMAT_FLAG_RGB | BL_FORMAT_FLAG_ALPHA
    BL_FORMAT_FLAG_LUM ## Pixel format provides LUM component (and not RGB components
    BL_FORMAT_FLAG_LUMA ## A combination of BL_FORMAT_FLAG_LUM | BL_FORMAT_FLAG_ALPHA
    BL_FORMAT_FLAG_INDEXED ## Indexed pixel format the requires a palette (I/O only)
    BL_FORMAT_FLAG_PREMULTIPLIED ## RGB components are premultiplied by alpha component
    BL_FORMAT_FLAG_BYTE_SWAP ## Pixel format doesn't use native byte-order (I/O only).
    BL_FORMAT_FLAG_BYTE_ALIGNED ## Pixel components are byte aligned (all 8bpp).
    BL_FORMAT_FLAG_UNDEFINED_BITS   
      ## Pixel has some undefined bits that represent no information.
      ## For example a 32-bit XRGB pixel has 8 undefined bits that are usually
      ## set to all ones so the format can be interpreted as premultiplied RGB as well.
      ## There are other formats like 16_0555 where the bit has no information and
      ## is usually set to zero. Blend2D doesn't rely on the content of such bits.
    BL_FORMAT_FLAG_LE
      ## Convenience flag that contains either zero or BL_FORMAT_FLAG_BYTE_SWAP
      ## depending on host byte order. Little endian hosts have this flag set
      ## to zero and big endian hosts to BL_FORMAT_FLAG_BYTE_SWAP.
      ## 
      ## **Note**: This is not a real flag that you can test, it's only provided
      ## for convenience to define little endian pixel formats.
    BL_FORMAT_FLAG_BE
      ## Convenience flag that contains either zero or BL_FORMAT_FLAG_BYTE_SWAP
      ## depending on host byte order. Big endian hosts have this flag set
      ## to zero and little endian hosts to BL_FORMAT_FLAG_BYTE_SWAP.
      ## **Note**: This is not a real flag that you can test, it's only provided
      ## for convenience to define big endian pixel formats.

  BLImageInfoFlags* {.size: sizeof(uint32).} = enum
    ## Flags used by BLImageInfo.
    BL_IMAGE_INFO_FLAG_NO_FLAGS    ## No flags.
    BL_IMAGE_INFO_FLAG_PROGRESSIVE  ## Progressive mode.
  
  BLImageScaleFilter* {.size: sizeof(uint32).} = enum
    BL_IMAGE_SCALE_FILTER_NONE ## No filter or uninitialized.
    BL_IMAGE_SCALE_FILTER_NEAREST ## Nearest neighbor filter (radius 1.0).
    BL_IMAGE_SCALE_FILTER_BILINEAR ## Bilinear filter (radius 1.0).
    BL_IMAGE_SCALE_FILTER_BICUBIC ## Bicubic filter (radius 2.0).
    BL_IMAGE_SCALE_FILTER_LANCZOS ## Lanczos filter (radius 2.0).
    BL_IMAGE_SCALE_FILTER_MAX_VALUE ## Maximum value of BLImageScaleFilter.

  BLImageCodecFeatures* {.size: sizeof(uint32).} = enum
    BL_IMAGE_CODEC_NO_FEATURES ## No features.
    BL_IMAGE_CODEC_FEATURE_READ ## Image codec supports reading images (can create BLImageDecoder).
    BL_IMAGE_CODEC_FEATURE_WRITE ## Image codec supports writing images (can create BLImageEncoder).
    BL_IMAGE_CODEC_FEATURE_LOSSLESS ## Image codec supports lossless compression.
    BL_IMAGE_CODEC_FEATURE_LOSSY ## Image codec supports loosy compression.
    BL_IMAGE_CODEC_FEATURE_MULTI_FRAME ## Image codec supports writing multiple frames (GIF).
    BL_IMAGE_CODEC_FEATURE_IPTC ## Image codec supports IPTC metadata.
    BL_IMAGE_CODEC_FEATURE_EXIF ## Image codec supports EXIF metadata.
    BL_IMAGE_CODEC_FEATURE_XMP ## Image codec supports XMP metadata.

  BLPixelConverterCreateFlags* = enum
    BL_PIXEL_CONVERTER_CREATE_NO_FLAGS   ## No flags.
    BL_PIXEL_CONVERTER_CREATE_FLAG_DONT_COPY_PALETTE
      ## Specifies that the source palette in BLFormatInfo doesn't have
      ## to by copied by BLPixelConverter. The caller must ensure that
      ## the palette would stay valid until the pixel converter is destroyed.
    BL_PIXEL_CONVERTER_CREATE_FLAG_ALTERABLE_PALETTE
      ## Specifies that the source palette in BLFormatInfo is alterable and
      ## the pixel converter can modify it when preparing the conversion.
      ## The modification can be irreversible so only use this flag when
      ## you are sure that the palette passed to BLPixelConverter::create()
      ## won't be needed outside of pixel conversion.
      ## **Note**: The flag BL_PIXEL_CONVERTER_CREATE_FLAG_DONT_COPY_PALETTE must be set as well, otherwise this flag would be ignored.
    BL_PIXEL_CONVERTER_CREATE_FLAG_NO_MULTI_STEP
      ## When there is no built-in conversion between the given pixel
      ## formats it's possible to use an intermediate format that is
      ## used during conversion. In such case the base pixel converter
      ## creates two more converters that are then used internally.
      ## This option disables such feature - creating a pixel converter
      ## would fail with BL_ERROR_NOT_IMPLEMENTED error if direct conversion
      ## is not possible.

  BLFormatInfo* {.bycopy.} = object
    depth*: uint32
    flags*: BLFormatFlags
    sizes*, shifts*: array[4, uint8]
    rSize*, gSize*, bSize*, aSize*,
      rShift*, gShift*, bShift*, aShift*: uint8
    palette*: ptr BLRgba32

  BLImageData* {.bycopy.} = object
    pixelData*: pointer
    stride*: ptr int
    size*: BLSizeI
    format*, flags*: uint32

  BLImageInfo* {.bycopy.} = object
    size*: BLSizeI
    density*: BLSize
    flags*: uint32
    depth*: uint16
    planeCount*: uint16
    frameCount*: uint64
    format*, compression*: array[16, cchar]
  
  BLImageCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLImageCodecCore* {.bycopy.} = object
    ## Image codec
    d*: BLObjectDetail

  BLImageDecoderCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLImageEncoderCore* {.bycopy.} = object
    d*: BLObjectDetail
  
  BLPixelConverterCore* {.bycopy.} = object
    convertFunc*: BLPixelConverterFunc
    internalFlags*: uint8
    data*: array[80, uint8]

  BLPixelConverterOptions* {.bycopy.} = object
    origin*: BLPointI
    gap*: uint

  BLPixelConverterFunc*  =
    proc(self: ptr BLPixelConverterCore;
      dstData: ptr uint8;
      dstStride: ptr int;
      srcData: ptr uint8;
      srcStride: ptr int;
      w, h: uint32;
      options: ptr BLPixelConverterOptions
    ): BLResult {.cdecl.}

{.pop.}

{.push importc, cdecl, header: blend2dHeader.}
#
# BLFormat API
#
proc blFormatInfoQuery*(self: ptr BLFormatInfo; format: BLFormat): BLResult
proc blFormatInfoSanitize*(self: ptr BLFormatInfo): BLResult

#
# BLImageCodec API
#
proc blImageCodecInit*(self: ptr BLImageCodecCore): BLResult
proc blImageCodecInitMove*(self: ptr BLImageCodecCore; other: ptr BLImageCodecCore): BLResult
proc blImageCodecInitWeak*(self: ptr BLImageCodecCore; other: ptr BLImageCodecCore): BLResult
proc blImageCodecInitByName*(self: ptr BLImageCodecCore; name: cstring; size: uint; codecs: ptr BLArrayCore): BLResult
proc blImageCodecDestroy*(self: ptr BLImageCodecCore): BLResult
proc blImageCodecReset*(self: ptr BLImageCodecCore): BLResult
proc blImageCodecAssignMove*(self: ptr BLImageCodecCore; other: ptr BLImageCodecCore): BLResult
proc blImageCodecAssignWeak*(self: ptr BLImageCodecCore; other: ptr BLImageCodecCore): BLResult
proc blImageCodecFindByName*(self: ptr BLImageCodecCore; name: cstring; size: uint; codecs: ptr BLArrayCore): BLResult
proc blImageCodecFindByExtension*(self: ptr BLImageCodecCore; name: cstring; size: uint; codecs: ptr BLArrayCore): BLResult
proc blImageCodecFindByData*(self: ptr BLImageCodecCore; data: pointer; size: uint; codecs: ptr BLArrayCore): BLResult
proc blImageCodecInspectData*(self: ptr BLImageCodecCore; data: pointer; size: uint): uint32
proc blImageCodecCreateDecoder*(self: ptr BLImageCodecCore; dst: ptr BLImageDecoderCore): BLResult
proc blImageCodecCreateEncoder*(self: ptr BLImageCodecCore; dst: ptr BLImageEncoderCore): BLResult
proc blImageCodecArrayInitBuiltInCodecs*(self: ptr BLArrayCore): BLResult
proc blImageCodecArrayAssignBuiltInCodecs*(self: ptr BLArrayCore): BLResult
proc blImageCodecAddToBuiltIn*(codec: ptr BLImageCodecCore): BLResult
proc blImageCodecRemoveFromBuiltIn*(codec: ptr BLImageCodecCore): BLResult

#
# BLImage API
#
proc blImageInit*(self: ptr BLImageCore): BLResult
proc blImageInitMove*(self: ptr BLImageCore; other: ptr BLImageCore): BLResult
proc blImageInitWeak*(self: ptr BLImageCore; other: ptr BLImageCore): BLResult
proc blImageInitAs*(self: ptr BLImageCore; w: cint; h: cint; format: BLFormat): BLResult
proc blImageInitAsFromData*(self: ptr BLImageCore; w, h: cint; format: BLFormat; pixelData: pointer; stride: ptr int; accessFlags: BLDataAccessFlags; destroyFunc: BLDestroyExternalDataFunc; userData: pointer): BLResult
proc blImageDestroy*(self: ptr BLImageCore): BLResult
proc blImageReset*(self: ptr BLImageCore): BLResult
proc blImageAssignMove*(self: ptr BLImageCore; other: ptr BLImageCore): BLResult
proc blImageAssignWeak*(self: ptr BLImageCore; other: ptr BLImageCore): BLResult
proc blImageAssignDeep*(self: ptr BLImageCore; other: ptr BLImageCore): BLResult
proc blImageCreate*(self: ptr BLImageCore; w: cint; h: cint; format: BLFormat): BLResult
proc blImageCreateFromData*(self: ptr BLImageCore; w, h: cint;
                            format: BLFormat; pixelData: pointer;
                            stride: ptr int; accessFlags: BLDataAccessFlags;
                            destroyFunc: BLDestroyExternalDataFunc;
                            userData: pointer): BLResult
proc blImageGetData*(self: ptr BLImageCore; dataOut: ptr BLImageData): BLResult
proc blImageMakeMutable*(self: ptr BLImageCore; dataOut: ptr BLImageData): BLResult
proc blImageConvert*(self: ptr BLImageCore; format: BLFormat): BLResult
proc blImageEquals*(a: ptr BLImageCore; b: ptr BLImageCore): bool
proc blImageScale*(dst: ptr BLImageCore; src: ptr BLImageCore; size: ptr BLSizeI; filter: BLImageScaleFilter): BLResult
proc blImageReadFromFile*(self: ptr BLImageCore; fileName: cstring; codecs: ptr BLArrayCore): BLResult
proc blImageReadFromData*(self: ptr BLImageCore; data: pointer; size: uint; codecs: ptr BLArrayCore): BLResult
proc blImageWriteToFile*(self: ptr BLImageCore; fileName: cstring; codec: ptr BLImageCodecCore): BLResult
proc blImageWriteToData*(self: ptr BLImageCore; dst: ptr BLArrayCore; codec: ptr BLImageCodecCore): BLResult

#
# BLImageDecoder API
#
proc blImageDecoderInit*(self: ptr BLImageDecoderCore): BLResult
proc blImageDecoderInitMove*(self: ptr BLImageDecoderCore; other: ptr BLImageDecoderCore): BLResult
proc blImageDecoderInitWeak*(self: ptr BLImageDecoderCore; other: ptr BLImageDecoderCore): BLResult
proc blImageDecoderDestroy*(self: ptr BLImageDecoderCore): BLResult
proc blImageDecoderReset*(self: ptr BLImageDecoderCore): BLResult
proc blImageDecoderAssignMove*(self: ptr BLImageDecoderCore; other: ptr BLImageDecoderCore): BLResult
proc blImageDecoderAssignWeak*(self: ptr BLImageDecoderCore; other: ptr BLImageDecoderCore): BLResult
proc blImageDecoderRestart*(self: ptr BLImageDecoderCore): BLResult
proc blImageDecoderReadInfo*(self: ptr BLImageDecoderCore; infoOut: ptr BLImageInfo; data: ptr uint8; size: uint): BLResult
proc blImageDecoderReadFrame*(self: ptr BLImageDecoderCore; imageOut: ptr BLImageCore; data: ptr uint8; size: uint): BLResult

#
# BLImageEncoder API
#
proc blImageEncoderInit*(self: ptr BLImageEncoderCore): BLResult
proc blImageEncoderInitMove*(self: ptr BLImageEncoderCore; other: ptr BLImageEncoderCore): BLResult
proc blImageEncoderInitWeak*(self: ptr BLImageEncoderCore; other: ptr BLImageEncoderCore): BLResult
proc blImageEncoderDestroy*(self: ptr BLImageEncoderCore): BLResult
proc blImageEncoderReset*(self: ptr BLImageEncoderCore): BLResult
proc blImageEncoderAssignMove*(self: ptr BLImageEncoderCore; other: ptr BLImageEncoderCore): BLResult
proc blImageEncoderAssignWeak*(self: ptr BLImageEncoderCore; other: ptr BLImageEncoderCore): BLResult
proc blImageEncoderRestart*(self: ptr BLImageEncoderCore): BLResult
proc blImageEncoderWriteFrame*(self: ptr BLImageEncoderCore; dst: ptr BLArrayCore; image: ptr BLImageCore): BLResult

#
# BLPixelConvereter API
#
proc blPixelConverterInit*(self: ptr BLPixelConverterCore): BLResult
proc blPixelConverterInitWeak*(self: ptr BLPixelConverterCore; other: ptr BLPixelConverterCore): BLResult
proc blPixelConverterDestroy*(self: ptr BLPixelConverterCore): BLResult
proc blPixelConverterReset*(self: ptr BLPixelConverterCore): BLResult
proc blPixelConverterAssign*(self: ptr BLPixelConverterCore; other: ptr BLPixelConverterCore): BLResult
proc blPixelConverterCreate*(self: ptr BLPixelConverterCore; dstInfo, srcInfo: ptr BLFormatInfo; createFlags: BLPixelConverterCreateFlags): BLResult
proc blPixelConverterConvert*(self: ptr BLPixelConverterCore; dstData: pointer;
    dstStride: ptr int; srcData: pointer; srcStride: ptr int; w, h: uint32; options: ptr BLPixelConverterOptions): BLResult
{.pop.}