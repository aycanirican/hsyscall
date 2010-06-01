{-# LANGUAGE CPP, ForeignFunctionInterface #-}
-- | Darwin System Calls
-- http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/#group_Section_2
module System.Syscall.Linux 
       ( c_sendfile_darwin
       )
       where

import Foreign.C
import System.Posix.Types (COff,Fd)

-- | sendfile
-- int sendfile(int fd, int s, off_t offset, off_t *len, struct sf_hdtr *hdtr, int flags);
foreign import ccall unsafe "sys/uio.h sendfile" c_sendfile_darwin
  :: Fd -> Fd -> COff -> Ptr COff -> Ptr () -> CInt -> IO CInt
