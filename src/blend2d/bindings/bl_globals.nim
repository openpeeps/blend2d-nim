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

import std/os

const
  blend2DsourceDir = currentSourcePath().parentDir / "blend2d_source"
  blend2Dheader* = blend2DsourceDir / "src" / "blend2d.h"
  blend2Dlib* = blend2DsourceDir / "build"

{.passL:"-L" & blend2Dlib & " -lblend2d".}
{.push importc, header: blend2Dheader.}
type
  BLResultCode* {.size: sizeof(uint32).} = enum
    BL_SUCCESS ## Successful result code.
    BL_ERROR_START_INDEX
    BL_ERROR_OUT_OF_MEMORY  ## Out of memory [ENOMEM].
    BL_ERROR_INVALID_VALUE  ## Invalid value/argument [EINVAL].
    BL_ERROR_INVALID_STATE  ## Invalid state [EFAULT].
    BL_ERROR_INVALID_HANDLE ## Invalid handle or file. [EBADF].
    BL_ERROR_INVALID_CONVERSION ## Invalid conversion.
    BL_ERROR_OVERFLOW ## Overflow or value too large [EOVERFLOW].
    BL_ERROR_NOT_INITIALIZED ## Object not initialized.
    BL_ERROR_NOT_IMPLEMENTED ## Not implemented [ENOSYS].
    BL_ERROR_NOT_PERMITTED  ## Operation not permitted [EPERM].
    BL_ERROR_IO   ## IO error [EIO].
    BL_ERROR_BUSY   ## Device or resource busy [EBUSY].
    BL_ERROR_INTERRUPTED  ## Operation interrupted [EINTR].
    BL_ERROR_TRY_AGAIN  ## Try again [EAGAIN].
    BL_ERROR_TIMED_OUT  ## Timed out [ETIMEDOUT].
    BL_ERROR_BROKEN_PIPE  ## Broken pipe [EPIPE].
    BL_ERROR_INVALID_SEEK ## File is not seekable [ESPIPE].
    BL_ERROR_SYMLINK_LOOP ## Too many levels of symlinks [ELOOP].
    BL_ERROR_FILE_TOO_LARGE ## File is too large [EFBIG].
    BL_ERROR_ALREADY_EXISTS ## File/directory already exists [EEXIST].
    BL_ERROR_ACCESS_DENIED  ## Access denied [EACCES].
    BL_ERROR_MEDIA_CHANGED  ## Media changed [Windows::ERROR_MEDIA_CHANGED].
    BL_ERROR_READ_ONLY_FS ## The file/FS is read-only [EROFS].
    BL_ERROR_NO_DEVICE  ## Device doesn't exist [ENXIO].
    BL_ERROR_NO_ENTRY ## Not found, no entry (fs) [ENOENT].
    BL_ERROR_NO_MEDIA ## No media in drive/device [ENOMEDIUM].
    BL_ERROR_NO_MORE_DATA ## No more data / end of file [ENODATA].
    BL_ERROR_NO_MORE_FILES  ## No more files [ENMFILE].
    BL_ERROR_NO_SPACE_LEFT  ## No space left on device [ENOSPC].
    BL_ERROR_NOT_EMPTY  ## Directory is not empty [ENOTEMPTY].
    BL_ERROR_NOT_FILE ## Not a file [EISDIR].
    BL_ERROR_NOT_DIRECTORY  ## Not a directory [ENOTDIR].
    BL_ERROR_NOT_SAME_DEVICE  ## Not same device [EXDEV].
    BL_ERROR_NOT_BLOCK_DEVICE ## Not a block device [ENOTBLK].
    BL_ERROR_INVALID_FILE_NAME  ## File/path name is invalid [n/a].
    BL_ERROR_FILE_NAME_TOO_LONG ## File/path name is too long [ENAMETOOLONG].
    BL_ERROR_TOO_MANY_OPEN_FILES  ## Too many open files [EMFILE].
    BL_ERROR_TOO_MANY_OPEN_FILES_BY_OS  ## Too many open files by OS [ENFILE].
    BL_ERROR_TOO_MANY_LINKS ## Too many symbolic links on FS [EMLINK].
    BL_ERROR_TOO_MANY_THREADS ## Too many threads [EAGAIN].
    BL_ERROR_THREAD_POOL_EXHAUSTED  ## Thread pool is exhausted and couldn't acquire the requested thread count.
    BL_ERROR_FILE_EMPTY ## File is empty (not specific to any OS error).
    BL_ERROR_OPEN_FAILED ## File open failed [Windows::ERROR_OPEN_FAILED].
    BL_ERROR_NOT_ROOT_DEVICE ## Not a root device/directory [Windows::ERROR_DIR_NOT_ROOT].
    BL_ERROR_UNKNOWN_SYSTEM_ERROR ## Unknown system error that failed to translate to Blend2D result code.
    BL_ERROR_INVALID_ALIGNMENT ## Invalid data alignment.
    BL_ERROR_INVALID_SIGNATURE ## Invalid data signature or header.
    BL_ERROR_INVALID_DATA ## Invalid or corrupted data.
    BL_ERROR_INVALID_STRING ## Invalid string (invalid data of either UTF8, UTF16, or UTF32).
    BL_ERROR_INVALID_KEY ## Invalid key or property.
    BL_ERROR_DATA_TRUNCATED ## Truncated data (more data required than memory/stream provides).
    BL_ERROR_DATA_TOO_LARGE ## Input data too large to be processed.
    BL_ERROR_DECOMPRESSION_FAILED ## Decompression failed due to invalid data (RLE, Huffman, etc).
    BL_ERROR_INVALID_GEOMETRY ## Invalid geometry (invalid path data or shape).
    BL_ERROR_NO_MATCHING_VERTEX ## Returned when there is no matching vertex in path data.
    BL_ERROR_INVALID_CREATE_FLAGS ## Invalid create flags (BLContext).
    BL_ERROR_NO_MATCHING_COOKIE ## No matching cookie (BLContext).
    BL_ERROR_NO_STATES_TO_RESTORE ## No states to restore (BLContext).
    BL_ERROR_TOO_MANY_SAVED_STATES ## Cannot save state as the number of saved states reached the limit (BLContext).
    BL_ERROR_IMAGE_TOO_LARGE ## The size of the image is too large.
    BL_ERROR_IMAGE_NO_MATCHING_CODEC ## Image codec for a required format doesn't exist.
    BL_ERROR_IMAGE_UNKNOWN_FILE_FORMAT ## Unknown or invalid file format that cannot be read.
    BL_ERROR_IMAGE_DECODER_NOT_PROVIDED ## Image codec doesn't support reading the file format.
    BL_ERROR_IMAGE_ENCODER_NOT_PROVIDED ## Image codec doesn't support writing the file format.
    BL_ERROR_PNG_MULTIPLE_IHDR ## Multiple IHDR chunks are not allowed (PNG).
    BL_ERROR_PNG_INVALID_IDAT ## Invalid IDAT chunk (PNG).
    BL_ERROR_PNG_INVALID_IEND ## Invalid IEND chunk (PNG).
    BL_ERROR_PNG_INVALID_PLTE ## Invalid PLTE chunk (PNG).
    BL_ERROR_PNG_INVALID_TRNS ## Invalid tRNS chunk (PNG).
    BL_ERROR_PNG_INVALID_FILTER ## Invalid filter type (PNG).
    BL_ERROR_JPEG_UNSUPPORTED_FEATURE ## Unsupported feature (JPEG).
    BL_ERROR_JPEG_INVALID_SOS ## Invalid SOS marker or header (JPEG).
    BL_ERROR_JPEG_INVALID_SOF ## Invalid SOF marker (JPEG).
    BL_ERROR_JPEG_MULTIPLE_SOF ## Multiple SOF markers (JPEG).
    BL_ERROR_JPEG_UNSUPPORTED_SOF ## Unsupported SOF marker (JPEG).
    BL_ERROR_FONT_NOT_INITIALIZED ## Font doesn't have any data as it's not initialized.
    BL_ERROR_FONT_NO_MATCH  ## Font or font face was not matched (BLFontManager).
    BL_ERROR_FONT_NO_CHARACTER_MAPPING  ## Font has no character to glyph mapping data.
    BL_ERROR_FONT_MISSING_IMPORTANT_TABLE ## Font has missing an important table.
    BL_ERROR_FONT_FEATURE_NOT_AVAILABLE ## Font feature is not available.
    BL_ERROR_FONT_CFF_INVALID_DATA  ## Font has an invalid CFF data.
    BL_ERROR_FONT_PROGRAM_TERMINATED  ## Font program terminated because the execution reached the limit.
    BL_ERROR_GLYPH_SUBSTITUTION_TOO_LARGE ## Glyph substitution requires too much space and was terminated.
    BL_ERROR_INVALID_GLYPH  ## Invalid glyph identifier.
  
  BLByteOrder* {.size: sizeof(uint32).} = enum
    BL_BYTE_ORDER_LE        ## Little endian byte-order.
    BL_BYTE_ORDER_BE        ## Big endian byte-order.
    BL_BYTE_ORDER_NATIVE    ## Native (host) byte-order.
    BL_BYTE_ORDER_SWAPPED   ## Swapped byte-order (BE if host is LE and vice versa).
  
  BLDataAccessFlags* {.size: sizeof(uint32).} = enum
    BL_DATA_ACCESS_NO_FLAGS   ## No data access flags.
    BL_DATA_ACCESS_READ   ## Read access.
    BL_DATA_ACCESS_WRITE  ## Write access.
    BL_DATA_ACCESS_RW     ## Read and write access.

  BLDataSourceType* {.size: sizeof(uint32).} = enum
    BL_DATA_SOURCE_TYPE_NONE        ## No data source.
    BL_DATA_SOURCE_TYPE_MEMORY      ## Memory data source.
    BL_DATA_SOURCE_TYPE_FILE        ## File data source.
    BL_DATA_SOURCE_TYPE_CUSTOM      ## Custom data source.
    BL_DATA_SOURCE_TYPE_MAX_VALUE   ## Maximum value BLDataSourceType.

  BLModifyOP* {.size: sizeof(uint32).} = enum
    BL_MODIFY_OP_ASSIGN_FIT   ## Assign operation, which reserves space only to fit the requested input.
    BL_MODIFY_OP_ASSIGN_GROW  ## Assign operation, which takes into consideration successive appends.
    BL_MODIFY_OP_APPEND_FIT   ## Append operation, which reserves space only to fit the current and appended content.
    BL_MODIFY_OP_APPEND_GROW  ## Append operation, which takes into consideration successive appends.
    BL_MODIFY_OP_MAX_VALUE    ## Maximum value of BLModifyOp.
  BLBooleanOp* {.size: sizeof(uint32).} = enum
    BL_BOOLEAN_OP_COPY  ## Result = B.
    BL_BOOLEAN_OP_AND   ## Result = A & B.
    BL_BOOLEAN_OP_OR    ## Result = A | B.
    BL_BOOLEAN_OP_XOR   ## Result = A ^ B.
    BL_BOOLEAN_OP_AND_NOT   ## Result = A & ~B.
    BL_BOOLEAN_OP_NOT_AND   ## Result = ~A & B.
    BL_BOOLEAN_OP_MAX_VALUE ## Maximum value of BLBooleanOp
  
  BLBitSetConstants* {.size: sizeof(uint32).} = enum
    BL_BIT_SET_INVALID_INDEX  ## Invalid bit-index. This is the only index that cannot be stored in BLBitSet.
    BL_BIT_SET_RANGE_MASK     ## Range mask used by BLBitsetSegment::start value - if set the segment is a range of all ones.
    BL_BIT_SET_SEGMENT_WORD_COUNT ## Number of words in a `BLBitSetSegment`.
  
  BLRange* {.bycopy.} = object
    start*: uint
    `end`*: uint

  BLArrayView* {.bycopy.} = object
    data*: pointer
    size*: uint

  BLRandom* {.bycopy.} = object
    ## Simple pseudo random number generator based on XORSHIFT+,
    ## which has 64-bit seed, 128 bits of state, and full period 2^128 - 1.
    data*: array[2, uint64]

  BLResult* = uint32

  BLVarCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLTag* = uint32
  BLUniqueId* = uint64
  BLUnknown* = distinct pointer # todo use `pointer` instead

  BLRgba* {.bycopy.} = object
    ## 128-bit RGBA color stored as 4 32-bit floating point values in [RGBA] order.
    r*: cfloat ## Red component.
    g*: cfloat ## Green component.
    b*: cfloat ## Blur component.
    a*: cfloat ## Alpha component.
  
  BLRgba32* {.bycopy.} = object
    ## 32-bit RGBA color (8-bit per component) stored as 0xAARRGGBB.
    value*: uint32 ## Packed 32-bit RGBA value.
  
  BLRgba64* {.bycopy.} = object
    ## 64-bit RGBA color (16-bit per component) stored as 0xAAAARRRRGGGGBBBB.
    value*: uint64 ## Packed 64-bit RGBA value.
  
  #
  # BLObject Structure
  #
  BLObjectInfo* {.bycopy.} = object
    bits*: uint32
  
  BLObjectImpl* {.incompleteStruct.} = object

  BLObjectDetail* {.bycopy.} = object
    impl*: ptr BLObjectImpl
    char_data*: array[16, cchar]
    i8_data*: array[16, int8]
    u8_data*: array[16, uint8]
    i16_data*: array[8, int16]
    u16_data*: array[8, uint16]
    i32_data*: array[4, int32]
    u32_data*: array[4, uint32]
    i64_data*: array[2, int64]
    u64_data*: array[2, uint64]
    f32_data*: array[4, cfloat]
    f64_data*: array[2, cdouble]
    rgba*: BLRgba
    rgba32*: BLRgba32
    rgba64*: BLRgba64
    u32_data_overlap*: array[2, uint32]
    impl_payload*: uint32
    info*: BLObjectInfo

  BLObjectCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLObjectVirt* {.bycopy.} = object
    base*: BLObjectVirtBase
  
  BLObjectVirtBase* {.bycopy.} = object
    destroy*: proc (impl: ptr BLObjectImpl): BLResult {.cdecl.}
    getProperty*: proc (impl: ptr BLObjectImpl; name: cstring; nameSize: uint;
                        valueOut: ptr BLVarCore): BLResult {.cdecl.}
    setProperty*: proc (impl: ptr BLObjectImpl; name: cstring; nameSize: uint;
                        value: ptr BLVarCore): BLResult {.cdecl.}

  BLObjectType* {.size: sizeof(uint32).} = enum
    # https://stackoverflow.com/questions/72715226/enums-in-nim-for-wrapper-of-c-library
    BL_OBJECT_TYPE_RGBA = 0 ## Object represents a RGBA value stored as four 32-bit floating point components (can be used as Style).
    BL_OBJECT_TYPE_RGBA32 = 1  ## Object represents a RGBA32 value stored as 32-bit integer in 0xAARRGGBB form.
    BL_OBJECT_TYPE_RGBA64 = 2 ## Object represents a RGBA64 value stored as 64-bit integer in 0xAAAARRRRGGGGBBBB form.
    BL_OBJECT_TYPE_NULL = 3 ## Object is Null (can be used as style).
    BL_OBJECT_TYPE_PATTERN = 4 ## Object is BLPattern (can be used as style).
    BL_OBJECT_TYPE_GRADIENT = 5 ## Object is BLGradient (can be used as style).
    BL_OBJECT_TYPE_IMAGE = 9
      ## Object is BLImage.
    BL_OBJECT_TYPE_PATH = 10
      ## Object is BLPath.
    BL_OBJECT_TYPE_FONT = 16
      ## Object is BLFont.
    BL_OBJECT_TYPE_FONT_FEATURE_SETTINGS = 17 ## Object is BLFontFeatureSettings.
    BL_OBJECT_TYPE_FONT_VARIATION_SETTINGS = 18
      ## Object is BLFontVariationSettings.
    BL_OBJECT_TYPE_BIT_ARRAY = 25
      ## Object is BLBitArray.
    BL_OBJECT_TYPE_BIT_SET = 26
      ## Object is BLBitSet.
    BL_OBJECT_TYPE_BOOL = 28
      ## Object represents a boolean value.
    BL_OBJECT_TYPE_INT64 = 29
      ## Object represents a 64-bit signed integer value.
    BL_OBJECT_TYPE_UINT64 = 30## Object represents a 64-bit unsigned integer value.
    BL_OBJECT_TYPE_DOUBLE = 31
      ## Object represents a 64-bit floating point value.
    BL_OBJECT_TYPE_STRING = 32
      ## Object is BLString.
    BL_OBJECT_TYPE_ARRAY_OBJECT = 33 ## Object is BLArray<T> where T is a BLObject compatible type.
    BL_OBJECT_TYPE_ARRAY_INT8 ## Object is BLArray<T> where T matches 8-bit signed integral type.
    BL_OBJECT_TYPE_ARRAY_UINT8 ## Object is BLArray<T> where T matches 8-bit unsigned integral type.
    BL_OBJECT_TYPE_ARRAY_INT16 ## Object is BLArray<T> where T matches 16-bit signed integral type.
    BL_OBJECT_TYPE_ARRAY_UINT16 ## Object is BLArray<T> where T matches 16-bit unsigned integral type.
    BL_OBJECT_TYPE_ARRAY_INT32 ## Object is BLArray<T> where T matches 32-bit signed integral type.
    BL_OBJECT_TYPE_ARRAY_UINT32 ## Object is BLArray<T> where T matches 32-bit unsigned integral type.
    BL_OBJECT_TYPE_ARRAY_INT64 ## Object is BLArray<T> where T matches 64-bit signed integral type.
    BL_OBJECT_TYPE_ARRAY_UINT64 ## Object is BLArray<T> where T matches 64-bit unsigned integral type.
    BL_OBJECT_TYPE_ARRAY_FLOAT32 ## Object is BLArray<T> where T matches 32-bit floating point type.
    BL_OBJECT_TYPE_ARRAY_FLOAT64 ## Object is BLArray<T> where T matches 64-bit floating point type.
    BL_OBJECT_TYPE_ARRAY_STRUCT_1 ## Object is BLArray<T> where T is a struct of size 1.
    BL_OBJECT_TYPE_ARRAY_STRUCT_2 ## Object is BLArray<T> where T is a struct of size 2.
    BL_OBJECT_TYPE_ARRAY_STRUCT_3 ## Object is BLArray<T> where T is a struct of size 3.
    BL_OBJECT_TYPE_ARRAY_STRUCT_4 ## Object is BLArray<T> where T is a struct of size 4.
    BL_OBJECT_TYPE_ARRAY_STRUCT_6 ## Object is BLArray<T> where T is a struct of size 6.
    BL_OBJECT_TYPE_ARRAY_STRUCT_8 ## Object is BLArray<T> where T is a struct of size 8.
    BL_OBJECT_TYPE_ARRAY_STRUCT_10 ## Object is BLArray<T> where T is a struct of size 10.
    BL_OBJECT_TYPE_ARRAY_STRUCT_12 ## Object is BLArray<T> where T is a struct of size 12.
    BL_OBJECT_TYPE_ARRAY_STRUCT_16 ## Object is BLArray<T> where T is a struct of size 16.
    BL_OBJECT_TYPE_ARRAY_STRUCT_20 ## Object is BLArray<T> where T is a struct of size 20.
    BL_OBJECT_TYPE_ARRAY_STRUCT_24 ## Object is BLArray<T> where T is a struct of size 24.
    BL_OBJECT_TYPE_ARRAY_STRUCT_32 ## Object is BLArray<T> where T is a struct of size 32.
    BL_OBJECT_TYPE_CONTEXT ## Object is BLContext.
    BL_OBJECT_TYPE_IMAGE_CODEC ## Object is BLImageCodec.
    BL_OBJECT_TYPE_IMAGE_DECODER ## Object is BLImageDecoder.
    BL_OBJECT_TYPE_IMAGE_ENCODER ## Object is BLImageEncoder.
    BL_OBJECT_TYPE_FONT_FACE ## Object is BLFontFace.
    BL_OBJECT_TYPE_FONT_DATA ## Object is BLFontData.
    BL_OBJECT_TYPE_FONT_MANAGER ## Object is BLFontManager.
    BL_OBJECT_TYPE_MIN_ARRAY ## Minimum object type of an array object.
    BL_OBJECT_TYPE_MAX_ARRAY ## Maximum object type of an array object.
    BL_OBJECT_TYPE_MIN_STYLE ## Minimum object type identifier that can be used as a style.
    BL_OBJECT_TYPE_MAX_STYLE ## Maximum object type identifier that can be used as a style.
    BL_OBJECT_TYPE_MIN_VIRTUAL ## Minimum object type of an object with virtual function table.
    BL_OBJECT_TYPE_MAX_VIRTUAL ## Maximum object type of an object with virtual function table.
    BL_OBJECT_TYPE_MAX_VALUE ## Maximum possible value of an object type, including identifiers reserved for the future.

  BLDestroyExternalDataFunc* = proc (impl: pointer;
      externalData: pointer; userData: pointer) {.cdecl.}

  #
  # BLArray API
  #
  BLArrayCore* {.bycopy.} = object
    d*: BLObjectDetail
  
  BLArrayImpl* {.bycopy.} = object
    data*: pointer
    size*: uint
    capacity*: uint

  #
  # BLBitArray API
  #
  BLBitArrayCore* {.bycopy.} = object
    d*: BLObjectDetail
  
  BLBitArrayImpl* {.bycopy.} = object
    size*: uint32
      ## Size in bit units.
    capacity*: uint32
      ## Capacity in bit-word units.
  
  #
  # BLBitSet
  #
  BLBitSetCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLBitSetData* {.bycopy.} = object
    segmentData*: ptr BLBitSetSegment
    segmentCount*: uint32
    ssoSegments*: array[3, BLBitSetSegment]

  BLBitSetSegment* {.bycopy.} = object
    startWord*: uint32
    data*: array[BL_BIT_SET_SEGMENT_WORD_COUNT.ord, uint32]

  BLBitSetBuilderCore* {.bycopy.} = object
    areaShift*: uint32
      ## Shift to get _areaIndex from bit index, equals to log2(kBitCount).
    areaIndex*: uint32
      ## Area index - index from 0...N where each index represents kBitCount bits.

  #
  # BLString API
  #
  BLStringCore* {.bycopy.} = object
    d*: BLObjectDetail
  BLStringImpl* {.bycopy.} = object
    size*: uint ## String size [in bytes].
    capacity*: uint
      ## String data capacity [in bytes].

{.pop.}

proc code*(x: BLResult): BLResultCode =
  BLResultCode(x)

{.push importc, cdecl, header: blend2dHeader.}
#
# BLArray API
#
proc blArrayInit*(self: ptr BLArrayCore; arrayType: BLObjectType): BLResult
proc blArrayInitMove*(self: ptr BLArrayCore; other: ptr BLArrayCore): BLResult
proc blArrayInitWeak*(self: ptr BLArrayCore; other: ptr BLArrayCore): BLResult
proc blArrayDestroy*(self: ptr BLArrayCore): BLResult
proc blArrayReset*(self: ptr BLArrayCore): BLResult
proc blArrayGetSize*(self: ptr BLArrayCore): uint
proc blArrayGetCapacity*(self: ptr BLArrayCore): uint
proc blArrayGetItemSize*(self: ptr BLArrayCore): uint
proc blArrayGetData*(self: ptr BLArrayCore): pointer
proc blArrayClear*(self: ptr BLArrayCore): BLResult
proc blArrayShrink*(self: ptr BLArrayCore): BLResult
proc blArrayReserve*(self: ptr BLArrayCore; n: uint): BLResult
proc blArrayResize*(self: ptr BLArrayCore; n: uint; fill: pointer): BLResult
proc blArrayMakeMutable*(self: ptr BLArrayCore; dataOut: ptr pointer): BLResult
proc blArrayModifyOp*(self: ptr BLArrayCore; op: BLModifyOp; n: uint;
                      dataOut: ptr pointer): BLResult
proc blArrayInsertOp*(self: ptr BLArrayCore; index: uint; n: uint;
                      dataOut: ptr pointer): BLResult
proc blArrayAssignMove*(self: ptr BLArrayCore; other: ptr BLArrayCore): BLResult
proc blArrayAssignWeak*(self: ptr BLArrayCore; other: ptr BLArrayCore): BLResult
proc blArrayAssignDeep*(self: ptr BLArrayCore; other: ptr BLArrayCore): BLResult
proc blArrayAssignData*(self: ptr BLArrayCore; data: pointer; n: uint): BLResult
proc blArrayAssignExternalData*(self: ptr BLArrayCore; data: pointer;
                                size: uint; capacity: uint;
                                dataAccessFlags: BLDataAccessFlags;
                                destroyFunc: BLDestroyExternalDataFunc;
                                userData: pointer): BLResult
proc blArrayAppendU8*(self: ptr BLArrayCore; value: uint8): BLResult
proc blArrayAppendU16*(self: ptr BLArrayCore; value: uint16): BLResult
proc blArrayAppendU32*(self: ptr BLArrayCore; value: uint32): BLResult
proc blArrayAppendU64*(self: ptr BLArrayCore; value: uint64): BLResult
proc blArrayAppendF32*(self: ptr BLArrayCore; value: cfloat): BLResult
proc blArrayAppendF64*(self: ptr BLArrayCore; value: cdouble): BLResult
proc blArrayAppendItem*(self: ptr BLArrayCore; item: pointer): BLResult
proc blArrayAppendData*(self: ptr BLArrayCore; data: pointer; n: uint): BLResult
proc blArrayInsertU8*(self: ptr BLArrayCore; index: uint; value: uint8): BLResult
proc blArrayInsertU16*(self: ptr BLArrayCore; index: uint; value: uint16): BLResult
proc blArrayInsertU32*(self: ptr BLArrayCore; index: uint; value: uint32): BLResult
proc blArrayInsertU64*(self: ptr BLArrayCore; index: uint; value: uint64): BLResult
proc blArrayInsertF32*(self: ptr BLArrayCore; index: uint; value: cfloat): BLResult
proc blArrayInsertF64*(self: ptr BLArrayCore; index: uint; value: cdouble): BLResult
proc blArrayInsertItem*(self: ptr BLArrayCore; index: uint; item: pointer): BLResult
proc blArrayInsertData*(self: ptr BLArrayCore; index: uint; data: pointer; n: uint): BLResult
proc blArrayReplaceU8*(self: ptr BLArrayCore; index: uint; value: uint8): BLResult
proc blArrayReplaceU16*(self: ptr BLArrayCore; index: uint; value: uint16): BLResult
proc blArrayReplaceU32*(self: ptr BLArrayCore; index: uint; value: uint32): BLResult
proc blArrayReplaceU64*(self: ptr BLArrayCore; index: uint; value: uint64): BLResult
proc blArrayReplaceF32*(self: ptr BLArrayCore; index: uint; value: cfloat): BLResult
proc blArrayReplaceF64*(self: ptr BLArrayCore; index: uint; value: cdouble): BLResult
proc blArrayReplaceItem*(self: ptr BLArrayCore; index: uint; item: pointer): BLResult
proc blArrayReplaceData*(self: ptr BLArrayCore; rStart: uint; rEnd: uint;
                         data: pointer; n: uint): BLResult
proc blArrayRemoveIndex*(self: ptr BLArrayCore; index: uint): BLResult
proc blArrayRemoveRange*(self: ptr BLArrayCore; rStart: uint; rEnd: uint): BLResult
proc blArrayEquals*(a: ptr BLArrayCore; b: ptr BLArrayCore): bool

#
# BLBitArray API
#
proc blBitArrayInit*(self: ptr BLBitArrayCore): BLResult
proc blBitArrayInitMove*(self: ptr BLBitArrayCore; other: ptr BLBitArrayCore): BLResult
proc blBitArrayInitWeak*(self: ptr BLBitArrayCore; other: ptr BLBitArrayCore): BLResult
proc blBitArrayDestroy*(self: ptr BLBitArrayCore): BLResult
proc blBitArrayReset*(self: ptr BLBitArrayCore): BLResult
proc blBitArrayAssignMove*(self: ptr BLBitArrayCore; other: ptr BLBitArrayCore): BLResult
proc blBitArrayAssignWeak*(self: ptr BLBitArrayCore; other: ptr BLBitArrayCore): BLResult
proc blBitArrayAssignWords*(self: ptr BLBitArrayCore; wordData: ptr uint32;
                            wordCount: uint32): BLResult
proc blBitArrayIsEmpty*(self: ptr BLBitArrayCore): bool
proc blBitArrayGetSize*(self: ptr BLBitArrayCore): uint32
proc blBitArrayGetWordCount*(self: ptr BLBitArrayCore): uint32
proc blBitArrayGetCapacity*(self: ptr BLBitArrayCore): uint32
proc blBitArrayGetData*(self: ptr BLBitArrayCore): ptr uint32
proc blBitArrayGetCardinality*(self: ptr BLBitArrayCore): uint32
proc blBitArrayGetCardinalityInRange*(self: ptr BLBitArrayCore;
                                      startBit: uint32; endBit: uint32): uint32
proc blBitArrayHasBit*(self: ptr BLBitArrayCore; bitIndex: uint32): bool
proc blBitArrayHasBitsInRange*(self: ptr BLBitArrayCore; startBit: uint32;
                               endBit: uint32): bool
proc blBitArraySubsumes*(a: ptr BLBitArrayCore; b: ptr BLBitArrayCore): bool
proc blBitArrayIntersects*(a: ptr BLBitArrayCore; b: ptr BLBitArrayCore): bool
proc blBitArrayGetRange*(self: ptr BLBitArrayCore; startOut: ptr uint32;
                         endOut: ptr uint32): bool
proc blBitArrayEquals*(a: ptr BLBitArrayCore; b: ptr BLBitArrayCore): bool
proc blBitArrayCompare*(a: ptr BLBitArrayCore; b: ptr BLBitArrayCore): cint
proc blBitArrayClear*(self: ptr BLBitArrayCore): BLResult
proc blBitArrayResize*(self: ptr BLBitArrayCore; nBits: uint32): BLResult
proc blBitArrayReserve*(self: ptr BLBitArrayCore; nBits: uint32): BLResult
proc blBitArrayShrink*(self: ptr BLBitArrayCore): BLResult
proc blBitArraySetBit*(self: ptr BLBitArrayCore; bitIndex: uint32): BLResult
proc blBitArrayFillRange*(self: ptr BLBitArrayCore; startBit: uint32;
                          endBit: uint32): BLResult
proc blBitArrayFillWords*(self: ptr BLBitArrayCore; bitIndex: uint32;
                          wordData: ptr uint32; wordCount: uint32): BLResult
proc blBitArrayClearBit*(self: ptr BLBitArrayCore; bitIndex: uint32): BLResult
proc blBitArrayClearRange*(self: ptr BLBitArrayCore; startBit: uint32;
                           endBit: uint32): BLResult
proc blBitArrayClearWord*(self: ptr BLBitArrayCore; bitIndex: uint32;
                          wordValue: uint32): BLResult
proc blBitArrayClearWords*(self: ptr BLBitArrayCore; bitIndex: uint32;
                           wordData: ptr uint32; wordCount: uint32): BLResult
proc blBitArrayReplaceOp*(self: ptr BLBitArrayCore; nBits: uint32;
                          dataOut: ptr ptr uint32): BLResult
proc blBitArrayReplaceBit*(self: ptr BLBitArrayCore; bitIndex: uint32;
                           bitValue: bool): BLResult
proc blBitArrayReplaceWord*(self: ptr BLBitArrayCore; bitIndex: uint32;
                            wordValue: uint32): BLResult
proc blBitArrayReplaceWords*(self: ptr BLBitArrayCore; bitIndex: uint32;
                             wordData: ptr uint32; wordCount: uint32): BLResult
proc blBitArrayAppendBit*(self: ptr BLBitArrayCore; bitValue: bool): BLResult
proc blBitArrayAppendWord*(self: ptr BLBitArrayCore; wordValue: uint32): BLResult
proc blBitArrayAppendWords*(self: ptr BLBitArrayCore; wordData: ptr uint32;
                            wordCount: uint32): BLResult


#
# BLBitSetCore
#
proc blBitSetInit*(self: ptr BLBitSetCore): BLResult
proc blBitSetInitMove*(self: ptr BLBitSetCore; other: ptr BLBitSetCore): BLResult
proc blBitSetInitWeak*(self: ptr BLBitSetCore; other: ptr BLBitSetCore): BLResult
proc blBitSetInitRange*(self: ptr BLBitSetCore; startBit: uint32; endBit: uint32): BLResult
proc blBitSetDestroy*(self: ptr BLBitSetCore): BLResult
proc blBitSetReset*(self: ptr BLBitSetCore): BLResult
proc blBitSetAssignMove*(self: ptr BLBitSetCore; other: ptr BLBitSetCore): BLResult
proc blBitSetAssignWeak*(self: ptr BLBitSetCore; other: ptr BLBitSetCore): BLResult
proc blBitSetAssignDeep*(self: ptr BLBitSetCore; other: ptr BLBitSetCore): BLResult
proc blBitSetAssignRange*(self: ptr BLBitSetCore; startBit: uint32;
                          endBit: uint32): BLResult
proc blBitSetAssignWords*(self: ptr BLBitSetCore; startWord: uint32;
                          wordData: ptr uint32; wordCount: uint32): BLResult
proc blBitSetIsEmpty*(self: ptr BLBitSetCore): bool
proc blBitSetGetData*(self: ptr BLBitSetCore; `out`: ptr BLBitSetData): BLResult
proc blBitSetGetSegmentCount*(self: ptr BLBitSetCore): uint32
proc blBitSetGetSegmentCapacity*(self: ptr BLBitSetCore): uint32
proc blBitSetGetCardinality*(self: ptr BLBitSetCore): uint32
proc blBitSetGetCardinalityInRange*(self: ptr BLBitSetCore; startBit: uint32;
                                    endBit: uint32): uint32
proc blBitSetHasBit*(self: ptr BLBitSetCore; bitIndex: uint32): bool
proc blBitSetHasBitsInRange*(self: ptr BLBitSetCore; startBit: uint32;
                             endBit: uint32): bool
proc blBitSetSubsumes*(a: ptr BLBitSetCore; b: ptr BLBitSetCore): bool
proc blBitSetIntersects*(a: ptr BLBitSetCore; b: ptr BLBitSetCore): bool
proc blBitSetGetRange*(self: ptr BLBitSetCore; startOut: ptr uint32;
                       endOut: ptr uint32): bool
proc blBitSetEquals*(a: ptr BLBitSetCore; b: ptr BLBitSetCore): bool
proc blBitSetCompare*(a: ptr BLBitSetCore; b: ptr BLBitSetCore): cint
proc blBitSetClear*(self: ptr BLBitSetCore): BLResult
proc blBitSetShrink*(self: ptr BLBitSetCore): BLResult
proc blBitSetOptimize*(self: ptr BLBitSetCore): BLResult
proc blBitSetChop*(self: ptr BLBitSetCore; startBit: uint32; endBit: uint32): BLResult
proc blBitSetAddBit*(self: ptr BLBitSetCore; bitIndex: uint32): BLResult
proc blBitSetAddRange*(self: ptr BLBitSetCore; rangeStartBit: uint32;
                       rangeEndBit: uint32): BLResult
proc blBitSetAddWords*(self: ptr BLBitSetCore; startWord: uint32;
                       wordData: ptr uint32; wordCount: uint32): BLResult
proc blBitSetClearBit*(self: ptr BLBitSetCore; bitIndex: uint32): BLResult
proc blBitSetClearRange*(self: ptr BLBitSetCore; rangeStartBit: uint32;
                         rangeEndBit: uint32): BLResult
proc blBitSetBuilderCommit*(self: ptr BLBitSetCore;
                            builder: ptr BLBitSetBuilderCore;
                            newAreaIndex: uint32): BLResult
proc blBitSetBuilderAddRange*(self: ptr BLBitSetCore;
                              builder: ptr BLBitSetBuilderCore;
                              startBit: uint32; endBit: uint32): BLResult

#
# BLObject API
#
proc blObjectAllocImpl*(self: ptr BLObjectCore; objectInfo: uint32;
                        implSize: uint): BLResult
proc blObjectAllocImplAligned*(self: ptr BLObjectCore; objectInfo: uint32;
                               implSize: uint; implAlignment: uint): BLResult
proc blObjectAllocImplExternal*(self: ptr BLObjectCore; objectInfo: uint32;
                                implSize: uint; immutable: bool;
                                destroyFunc: BLDestroyExternalDataFunc;
                                userData: pointer): BLResult
proc blObjectFreeImpl*(impl: ptr BLObjectImpl): BLResult
proc blObjectInitMove*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blObjectInitWeak*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blObjectReset*(self: ptr BLUnknown): BLResult
proc blObjectAssignMove*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blObjectAssignWeak*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blObjectGetProperty*(self: ptr BLUnknown; name: cstring; nameSize: uint;
                          valueOut: ptr BLVarCore): BLResult
proc blObjectGetPropertyBool*(self: ptr BLUnknown; name: cstring;
                              nameSize: uint; valueOut: ptr bool): BLResult
proc blObjectGetPropertyInt32*(self: ptr BLUnknown; name: cstring;
                               nameSize: uint; valueOut: ptr int32): BLResult
proc blObjectGetPropertyInt64*(self: ptr BLUnknown; name: cstring;
                               nameSize: uint; valueOut: ptr int64): BLResult
proc blObjectGetPropertyUInt32*(self: ptr BLUnknown; name: cstring;
                                nameSize: uint; valueOut: ptr uint32): BLResult
proc blObjectGetPropertyUInt64*(self: ptr BLUnknown; name: cstring;
                                nameSize: uint; valueOut: ptr uint64): BLResult
proc blObjectGetPropertyDouble*(self: ptr BLUnknown; name: cstring;
                                nameSize: uint; valueOut: ptr cdouble): BLResult
proc blObjectSetProperty*(self: ptr BLUnknown; name: cstring; nameSize: uint;
                          value: ptr BLUnknown): BLResult
proc blObjectSetPropertyBool*(self: ptr BLUnknown; name: cstring;
                              nameSize: uint; value: bool): BLResult
proc blObjectSetPropertyInt32*(self: ptr BLUnknown; name: cstring;
                               nameSize: uint; value: int32): BLResult
proc blObjectSetPropertyInt64*(self: ptr BLUnknown; name: cstring;
                               nameSize: uint; value: int64): BLResult
proc blObjectSetPropertyUInt32*(self: ptr BLUnknown; name: cstring;
                                nameSize: uint; value: uint32): BLResult
proc blObjectSetPropertyUInt64*(self: ptr BLUnknown; name: cstring;
                                nameSize: uint; value: uint64): BLResult
proc blObjectSetPropertyDouble*(self: ptr BLUnknown; name: cstring;
                                nameSize: uint; value: cdouble): BLResult


#
# BLString API
#
type
  va_list* {.importc: "va_list", header: "<stdarg.h>".} = object

proc blStringInit*(self: ptr BLStringCore): BLResult
proc blStringInitMove*(self: ptr BLStringCore; other: ptr BLStringCore): BLResult
proc blStringInitWeak*(self: ptr BLStringCore; other: ptr BLStringCore): BLResult
proc blStringInitWithData*(self: ptr BLStringCore; str: cstring; size: uint): BLResult
proc blStringDestroy*(self: ptr BLStringCore): BLResult
proc blStringReset*(self: ptr BLStringCore): BLResult
proc blStringGetData*(self: ptr BLStringCore): cstring
proc blStringGetSize*(self: ptr BLStringCore): uint
proc blStringGetCapacity*(self: ptr BLStringCore): uint
proc blStringClear*(self: ptr BLStringCore): BLResult
proc blStringShrink*(self: ptr BLStringCore): BLResult
proc blStringReserve*(self: ptr BLStringCore; n: uint): BLResult
proc blStringResize*(self: ptr BLStringCore; n: uint; fill: cchar): BLResult
proc blStringMakeMutable*(self: ptr BLStringCore; dataOut: ptr cstring): BLResult
proc blStringModifyOp*(self: ptr BLStringCore; op: BLModifyOp; n: uint;
                       dataOut: ptr cstring): BLResult
proc blStringInsertOp*(self: ptr BLStringCore; index: uint; n: uint;
                       dataOut: ptr cstring): BLResult
proc blStringAssignMove*(self: ptr BLStringCore; other: ptr BLStringCore): BLResult
proc blStringAssignWeak*(self: ptr BLStringCore; other: ptr BLStringCore): BLResult
proc blStringAssignDeep*(self: ptr BLStringCore; other: ptr BLStringCore): BLResult
proc blStringAssignData*(self: ptr BLStringCore; str: cstring; n: uint): BLResult
proc blStringApplyOpChar*(self: ptr BLStringCore; op: BLModifyOp; c: cchar;
                          n: uint): BLResult
proc blStringApplyOpData*(self: ptr BLStringCore; op: BLModifyOp; str: cstring;
                          n: uint): BLResult
proc blStringApplyOpString*(self: ptr BLStringCore; op: BLModifyOp;
                            other: ptr BLStringCore): BLResult
proc blStringApplyOpFormat*(self: ptr BLStringCore; op: BLModifyOp; fmt: varargs[cstring]): BLResult
proc blStringApplyOpFormatV*(self: ptr BLStringCore; op: BLModifyOp;
                             fmt: cstring; ap: va_list): BLResult
proc blStringInsertChar*(self: ptr BLStringCore; index: uint; c: cchar; n: uint): BLResult
proc blStringInsertData*(self: ptr BLStringCore; index: uint; str: cstring;
                         n: uint): BLResult
proc blStringInsertString*(self: ptr BLStringCore; index: uint;
                           other: ptr BLStringCore): BLResult
proc blStringRemoveIndex*(self: ptr BLStringCore; index: uint): BLResult
proc blStringRemoveRange*(self: ptr BLStringCore; rStart: uint; rEnd: uint): BLResult
proc blStringEquals*(a: ptr BLStringCore; b: ptr BLStringCore): bool
proc blStringEqualsData*(self: ptr BLStringCore; str: cstring; n: uint): bool
proc blStringCompare*(a: ptr BLStringCore; b: ptr BLStringCore): cint
proc blStringCompareData*(self: ptr BLStringCore; str: cstring; n: uint): cint

proc blVarInitType*(self: ptr BLUnknown; `type`: BLObjectType): BLResult
proc blVarInitNull*(self: ptr BLUnknown): BLResult
proc blVarInitBool*(self: ptr BLUnknown; value: bool): BLResult
proc blVarInitInt32*(self: ptr BLUnknown; value: int32): BLResult
proc blVarInitInt64*(self: ptr BLUnknown; value: int64): BLResult
proc blVarInitUInt32*(self: ptr BLUnknown; value: uint32): BLResult
proc blVarInitUInt64*(self: ptr BLUnknown; value: uint64): BLResult
proc blVarInitDouble*(self: ptr BLUnknown; value: cdouble): BLResult
proc blVarInitRgba*(self: ptr BLUnknown; rgba: ptr BLRgba): BLResult
proc blVarInitRgba32*(self: ptr BLUnknown; rgba32: uint32): BLResult
proc blVarInitRgba64*(self: ptr BLUnknown; rgba64: uint64): BLResult
proc blVarInitMove*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blVarInitWeak*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blVarDestroy*(self: ptr BLUnknown): BLResult
proc blVarReset*(self: ptr BLUnknown): BLResult
proc blVarAssignNull*(self: ptr BLUnknown): BLResult
proc blVarAssignBool*(self: ptr BLUnknown; value: bool): BLResult
proc blVarAssignInt32*(self: ptr BLUnknown; value: int32): BLResult
proc blVarAssignInt64*(self: ptr BLUnknown; value: int64): BLResult
proc blVarAssignUInt32*(self: ptr BLUnknown; value: uint32): BLResult
proc blVarAssignUInt64*(self: ptr BLUnknown; value: uint64): BLResult
proc blVarAssignDouble*(self: ptr BLUnknown; value: cdouble): BLResult
proc blVarAssignRgba*(self: ptr BLUnknown; rgba: ptr BLRgba): BLResult
proc blVarAssignRgba32*(self: ptr BLUnknown; rgba32: uint32): BLResult
proc blVarAssignRgba64*(self: ptr BLUnknown; rgba64: uint64): BLResult
proc blVarAssignMove*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blVarAssignWeak*(self: ptr BLUnknown; other: ptr BLUnknown): BLResult
proc blVarGetType*(self: ptr BLUnknown): BLObjectType
proc blVarToBool*(self: ptr BLUnknown; `out`: ptr bool): BLResult
proc blVarToInt32*(self: ptr BLUnknown; `out`: ptr int32): BLResult
proc blVarToInt64*(self: ptr BLUnknown; `out`: ptr int64): BLResult
proc blVarToUInt32*(self: ptr BLUnknown; `out`: ptr uint32): BLResult
proc blVarToUInt64*(self: ptr BLUnknown; `out`: ptr uint64): BLResult
proc blVarToDouble*(self: ptr BLUnknown; `out`: ptr cdouble): BLResult
proc blVarToRgba*(self: ptr BLUnknown; `out`: ptr BLRgba): BLResult
proc blVarToRgba32*(self: ptr BLUnknown; `out`: ptr uint32): BLResult
proc blVarToRgba64*(self: ptr BLUnknown; `out`: ptr uint64): BLResult
proc blVarEquals*(a: ptr BLUnknown; b: ptr BLUnknown): bool
proc blVarEqualsNull*(self: ptr BLUnknown): bool
proc blVarEqualsBool*(self: ptr BLUnknown; value: bool): bool
proc blVarEqualsInt64*(self: ptr BLUnknown; value: int64): bool
proc blVarEqualsUInt64*(self: ptr BLUnknown; value: uint64): bool
proc blVarEqualsDouble*(self: ptr BLUnknown; value: cdouble): bool
proc blVarEqualsRgba*(self: ptr BLUnknown; rgba: ptr BLRgba): bool
proc blVarEqualsRgba32*(self: ptr BLUnknown; rgba32: uint32): bool
proc blVarEqualsRgba64*(self: ptr BLUnknown; rgba64: uint64): bool
proc blVarStrictEquals*(a: ptr BLUnknown; b: ptr BLUnknown): bool

proc blRandomReset*(self: ptr BLRandom; seed: uint64): BLResult
proc blRandomNextUInt32*(self: ptr BLRandom): uint32
proc blRandomNextUInt64*(self: ptr BLRandom): uint64
proc blRandomNextDouble*(self: ptr BLRandom): cdouble

#
#
#
proc blTraceError*(result: BLResult): BLResult
proc blRuntimeAssertionFailure*(file: cstring; line: cint; msg: cstring)
type
    BLDebugMessageSinkFunc* =
      proc (message: cstring; size: uint; userData: pointer) {.cdecl.}
{.pop.}