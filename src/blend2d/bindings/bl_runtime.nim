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

type
  BLRuntimeScopeCore* {.bycopy.} = object
    data*: array[2, uint32]

  BLRuntimeBuildInfo* {.bycopy.} = object
    majorVersion*: uint32
    minorVersion*: uint32
    patchVersion*: uint32
    buildType*: uint32
    baselineCpuFeatures*: uint32
    supportedCpuFeatures*: uint32
    maxImageSize*: uint32
    maxThreadCount*: uint32
    reserved*: array[2, uint32]
    compilerInfo*: array[32, cchar]
  
  BLRuntimeSystemInfo* {.bycopy.} = object
    cpuArch*: uint32
    cpuFeatures*: uint32
    coreCount*: uint32
    threadCount*: uint32
    threadStackSize*: uint32
    removed*: uint32
    allocationGranularity*: uint32
    reserved*: array[5, uint32]
    cpuVendor*: array[16, cchar]
    cpuBrand*: array[64, cchar]
  
  BLRuntimeResourceInfo* {.bycopy.} = object
    vmUsed*: uint
    vmReserved*: uint
    vmOverhead*: uint
    vmBlockCount*: uint
    zmUsed*: uint
    zmReserved*: uint
    zmOverhead*: uint
    zmBlockCount*: uint
    dynamicPipelineCount*: uint
    reserved*: array[7, uint]

{.push importc, cdecl, header: blend2dHeader.}
proc blRuntimeInit*(): BLResult
proc blRuntimeShutdown*(): BLResult
proc blRuntimeCleanup*(cleanupFlags: BLRuntimeCleanupFlags): BLResult
proc blRuntimeQueryInfo*(infoType: BLRuntimeInfoType; infoOut: pointer): BLResult
proc blRuntimeMessageOut*(msg: cstring): BLResult
proc blRuntimeMessageFmt*(fmt: varargs[cstring]): BLResult
proc blRuntimeMessageVFmt*(fmt: varargs[cstring]; ap: va_list): BLResult
proc blResultFromPosixError*(e: cint): BLResult
proc blRuntimeScopeBegin*(self: ptr BLRuntimeScopeCore): BLResult
proc blRuntimeScopeEnd*(self: ptr BLRuntimeScopeCore): BLResult
proc blRuntimeScopeIsActive*(self: ptr BLRuntimeScopeCore): bool
{.pop.}