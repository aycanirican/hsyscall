{-# LANGUAGE CPP, ForeignFunctionInterface #-}
-- | FreeBSD System Calls
-- http://fxr.watson.org/fxr/source/kern/syscalls.master
module System.Syscall.FreeBSD
       ( c_sendfile_freebsd
       )
       where

import Foreign
import Foreign.C
import System.Posix.Types (COff, Fd)

-- | Sendfile
-- int sendfile(int fd, int s, off_t offset, size_t nbytes, struct sf_hdtr *hdtr, off_t *sbytes, int flags);
foreign import ccall unsafe "sys/uio.h sendfile" c_sendfile_freebsd
  :: Fd -> Fd -> COff -> CSize -> Ptr () -> Ptr COff -> CInt -> IO CInt
