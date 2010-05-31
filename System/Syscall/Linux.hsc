{-# LANGUAGE CPP, ForeignFunctionInterface #-}
-- | Linux System Calls
-- http://www.kernel.org/doc/man-pages/online/pages/man2/syscalls.2.html
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

#include <unistd.h>

-- | Open, Close
-- int open(const char *pathname, int flags);
-- int close(int fd);
#include <sys/fcntl.h>
newtype FcntlFlags = FcntlFlags { unFcntlFlags :: CInt } deriving (Eq, Ord)

#{enum FcntlFlags, FcntlFlags,
  o_rdonly = O_RDONLY,
  o_wronly = O_WRONLY,
  o_rdwr   = O_RDWR,
  o_creat  = O_CREAT,
  o_append = O_APPEND
 }
  
instance Show FcntlFlags where
  show f | f == o_rdonly = "O_RDONLY"
         | f == o_wronly = "O_WRONLY"
         | f == o_rdwr   = "O_RDWR"
         | f == o_creat  = "O_CREAT"
         | f == o_append = "O_APPEND"
         | otherwise = show $ unFcntlFlags f

foreign import ccall unsafe "unistd.h open" c_open 
  :: CString -> CInt -> IO CInt
foreign import ccall unsafe "unistd.h close" c_close 
  :: CInt -> IO CInt

-- | Read, Write

foreign import ccall unsafe "unistd.h read" c_read 
  :: CInt -> Ptr () -> CSize -> IO (CSize)
foreign import ccall unsafe "unistd.h write" c_write 
  :: CInt -> Ptr () -> CSize -> IO (CSize)

-- | Fcntl

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

-- | Sendfile
-- ssize_t sendfile(int out_fd, int in_fd, off_t * offset ", size_t" " count" );

#include <sys/sendfile.h>
foreign import ccall unsafe "sendfile" c_sendfile 
  :: CInt -> CInt -> Ptr (#type off_t) -> (#type size_t) -> IO (#type ssize_t)
