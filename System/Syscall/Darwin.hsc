{-# LANGUAGE CPP, ForeignFunctionInterface #-}
-- | Darwin System Calls
-- http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/#group_Section_2
module System.Syscall.Linux 
       ( c_open, c_close,
         c_read, c_write,
         c_fcntl,
         StructStat(..), c_stat, c_fstat, c_lstat,
         c_sendfile
       )
       where

import Foreign
import Foreign.C
#let alignment t = "%lu", (unsigned long)offsetof(struct {char x__; t (y__); }, y__)

foreign import ccall unsafe "fcntl.h open" c_open 
  :: CString -> CInt -> IO CInt
foreign import ccall unsafe "unistd.h close" c_close 
  :: CInt -> IO CInt
foreign import ccall unsafe "unistd.h read" c_read 
  :: CInt -> Ptr () -> CSize -> IO (CSize)
foreign import ccall unsafe "unistd.h write" c_write 
  :: CInt -> Ptr () -> CSize -> IO (CSize)
foreign import ccall unsafe "fcntl.h fcntl" c_fcntl 
  :: CInt -> CInt -> CLong -> IO CInt

-- | Stat
-- int stat(const char *path, struct stat *buf);
-- int fstat(int fd, struct stat *buf);
-- int lstat(const char *path, struct stat *buf);
#include <sys/stat.h>

data StructStat = StructStat {
  stSize :: ! #{type off_t}
  }
type StructStatPtr = Ptr StructStat

instance Storable StructStat where
  alignment _ = #{alignment struct stat}
  sizeOf _    = #{size struct stat}
  peek p = do
    size <- #{peek struct stat, st_size} p
    return (StructStat size)
  poke p (StructStat size) = do
    #{poke struct stat, st_size} p size

foreign import ccall unsafe "stat" c_stat 
  :: CString -> StructStatPtr -> IO CInt
foreign import ccall unsafe "fstat" c_fstat 
  :: CInt -> StructStatPtr -> IO CInt
foreign import ccall unsafe "lstat" c_lstat 
  :: CString -> StructStatPtr -> IO CInt

-- | sendfile
-- int sendfile(int fd, int s, off_t offset, off_t *len, struct sf_hdtr *hdtr, int flags);
foreign import ccall unsafe "sys/uio.h sendfile" c_sendfile
  :: Fd -> Fd -> (#type off_t) -> Ptr (#type off_t) -> Ptr () -> CInt -> IO CInt
