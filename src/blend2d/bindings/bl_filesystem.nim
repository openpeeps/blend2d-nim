import ./bl_globals
{.push importc, header: blend2dHeader.}

type
  BLFileInfoFlags* {.size: sizeof(uint32).} = enum
    BL_FILE_INFO_OWNER_R ## File owner has read permission (compatible with 0400 octal notation).
    BL_FILE_INFO_OWNER_W ## File owner has write permission (compatible with 0200 octal notation).
    BL_FILE_INFO_OWNER_X ## File owner has execute permission (compatible with 0100 octal notation).
    BL_FILE_INFO_OWNER_MASK ## A combination of BL_FILE_INFO_OWNER_R, BL_FILE_INFO_OWNER_W, and BL_FILE_INFO_OWNER_X.
    BL_FILE_INFO_GROUP_R ## File group owner has read permission (compatible with 040 octal notation).
    BL_FILE_INFO_GROUP_W ## File group owner has write permission (compatible with 020 octal notation).
    BL_FILE_INFO_GROUP_X ## File group owner has execute permission (compatible with 010 octal notation).
    BL_FILE_INFO_GROUP_MASK ## A combination of BL_FILE_INFO_GROUP_R, BL_FILE_INFO_GROUP_W, and BL_FILE_INFO_GROUP_X.
    BL_FILE_INFO_OTHER_R ## Other users have read permission (compatible with 04 octal notation).
    BL_FILE_INFO_OTHER_W ## Other users have write permission (compatible with 02 octal notation).
    BL_FILE_INFO_OTHER_X ## Other users have execute permission (compatible with 01 octal notation).
    BL_FILE_INFO_OTHER_MASK ## A combination of BL_FILE_INFO_OTHER_R, BL_FILE_INFO_OTHER_W, and BL_FILE_INFO_OTHER_X.
    BL_FILE_INFO_SUID ## Set user ID to file owner user ID on execution (compatible with 04000 octal notation).
    BL_FILE_INFO_SGID ## Set group ID to file's user group ID on execution (compatible with 02000 octal notation).
    BL_FILE_INFO_PERMISSIONS_MASK ## A combination of all file permission bits.
    BL_FILE_INFO_REGULAR ## A flag specifying that this is a regular file.
    BL_FILE_INFO_DIRECTORY ## A flag specifying that this is a directory.
    BL_FILE_INFO_SYMLINK ## A flag specifying that this is a symbolic link.
    BL_FILE_INFO_CHAR_DEVICE ## A flag describing a character device.
    BL_FILE_INFO_BLOCK_DEVICE ## A flag describing a block device.
    BL_FILE_INFO_FIFO ## A flag describing a FIFO (named pipe).
    BL_FILE_INFO_SOCKET ## A flag describing a socket.
    BL_FILE_INFO_HIDDEN ## A flag describing a hidden file (Windows only).
    BL_FILE_INFO_EXECUTABLE ## A flag describing a hidden file (Windows only).
    BL_FILE_INFO_ARCHIVE ## A flag describing an archive (Windows only).
    BL_FILE_INFO_SYSTEM ## A flag describing a system file (Windows only).
    BL_FILE_INFO_VALID ## File information is valid (the request succeeded).

  BLFileOpenFlags*  {.size: sizeof(uint32).} = enum
    BL_FILE_OPEN_NO_FLAGS ## No flags.
    BL_FILE_OPEN_READ
      ## Opens the file for reading. The following system flags
      ## are used when opening the file: `O_RDONLY` (Posix) `GENERIC_READ` (Windows)
    BL_FILE_OPEN_WRITE
      ## Opens the file for writing: The following system flags are
      ## used when opening the file: `O_WRONLY` (Posix) GENERIC_WRITE (Windows)
    BL_FILE_OPEN_RW
      ## Opens the file for reading & writing. The following system
      ## flags are used when opening the file: `O_RDWR` (Posix) `GENERIC_READ` | `GENERIC_WRITE` (Windows)
    BL_FILE_OPEN_CREATE
      ## Creates the file if it doesn't exist or opens it if it does.
      ## The following system flags are used when opening the file:
      ## `O_CREAT` (Posix) `CREATE_ALWAYS` or `OPEN_ALWAYS` depending on other flags (Windows)
    BL_FILE_OPEN_DELETE
      ## Opens the file for deleting or renaming (Windows).
      ## Adds DELETE flag when opening the file to ACCESS_MASK.
    BL_FILE_OPEN_TRUNCATE
      ## Truncates the file. The following system flags are used
      ## when opening the file: `O_TRUNC` (Posix) `TRUNCATE_EXISTING` (Windows)
    BL_FILE_OPEN_READ_EXCLUSIVE
      ## Opens the file for reading in exclusive mode (Windows).
      ## Exclusive mode means to not specify the FILE_SHARE_READ option.
    BL_FILE_OPEN_WRITE_EXCLUSIVE  ## Opens the file for writing in exclusive mode (Windows). Exclusive mode means to not specify the FILE_SHARE_WRITE option.
    BL_FILE_OPEN_RW_EXCLUSIVE ## Opens the file for both reading and writing (Windows). This is a combination of both BL_FILE_OPEN_READ_EXCLUSIVE and BL_FILE_OPEN_WRITE_EXCLUSIVE.
    BL_FILE_OPEN_CREATE_EXCLUSIVE ## Creates the file in exclusive mode - fails if the file already exists. The following system flags are used when opening the file: O_EXCL (Posix) CREATE_NEW (Windows)
    BL_FILE_OPEN_DELETE_EXCLUSIVE ## Opens the file for deleting or renaming in exclusive mode (Windows). Exclusive mode means to not specify the FILE_SHARE_DELETE option.

  BLFileSeekType* {.size: sizeof(uint32).} = enum
    BL_FILE_SEEK_SET ## Seek from the beginning of the file (SEEK_SET).
    BL_FILE_SEEK_CUR ## Seek from the current position (SEEK_CUR).
    BL_FILE_SEEK_END ## Seek from the end of the file (SEEK_END).
    BL_FILE_SEEK_MAX_VALUE ## Maximum value of BLFileSeekType.
  
  BLFileReadFlags* {.size: sizeof(uint32).} = enum
    BL_FILE_READ_NO_FLAGS ## No flags.
    BL_FILE_READ_MMAP_ENABLED
      ## Use memory mapping to read the content of the file.
      ## The destination buffer BLArray<> would be configured to use the memory mapped buffer instead of allocating its own.
    BL_FILE_READ_MMAP_AVOID_SMALL
      ## Avoid memory mapping of small files. The size of small file
      ## is determined by Blend2D, however, you should expect
      ## it to be 16kB or 64kB depending on host operating system.
    BL_FILE_READ_MMAP_NO_FALLBACK
      ## Do not fallback to regular read if memory mapping fails.
      ## It's worth noting that memory mapping would fail for files
      ## stored on filesystem that is not local (like a mounted network filesystem, etc...).

  BLFileCore* {.bycopy.} = object
    handle*: ptr int
      ## A file handle - either a file descriptor used by POSIX or file handle used by Windows. On both platforms the
      ## handle is always intptr_t to make FFI easier (it's basically the size of a pointer / machine register).
      ## note In C++ mode you can use BLFileCore::Handle or BLFile::Handle to get the handle type. In C mode you
      ## must use intptr_t. A handle of value -1 is considered invalid and/or uninitialized. This value also matches
      ## INVALID_HANDLE_VALUE, which is used by Windows API and defined to -1 as well.

  BLFileInfo* {.bycopy.} = object
    size*: uint64
    modifiedTime*: int64
    flags*: BLFileInfoFlags
    uid*: uint32
    gid*: uint32
    reserved*: array[5, uint32]

{.pop.}

{.push importc, cdecl, header: blend2dHeader.}
proc blFileInit*(self: ptr BLFileCore): BLResult
proc blFileReset*(self: ptr BLFileCore): BLResult
proc blFileOpen*(self: ptr BLFileCore; fileName: cstring; openFlags: BLFileOpenFlags): BLResult
proc blFileClose*(self: ptr BLFileCore): BLResult
proc blFileSeek*(self: ptr BLFileCore; offset: int64; seekType: BLFileSeekType; positionOut: ptr int64): BLResult
proc blFileRead*(self: ptr BLFileCore; buffer: pointer; n: uint; bytesReadOut: ptr uint): BLResult
proc blFileWrite*(self: ptr BLFileCore; buffer: pointer; n: uint; bytesWrittenOut: ptr uint): BLResult
proc blFileTruncate*(self: ptr BLFileCore; maxSize: int64): BLResult
proc blFileGetInfo*(self: ptr BLFileCore; infoOut: ptr BLFileInfo): BLResult
proc blFileGetSize*(self: ptr BLFileCore; fileSizeOut: ptr uint64): BLResult
proc blFileSystemGetInfo*(fileName: cstring; infoOut: ptr BLFileInfo): BLResult
proc blFileSystemReadFile*(fileName: cstring; dst: ptr BLArrayCore; maxSize: uint; readFlags: BLFileReadFlags): BLResult
proc blFileSystemWriteFile*(fileName: cstring; data: pointer; size: uint; bytesWrittenOut: ptr uint): BLResult
{.pop.}