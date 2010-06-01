{-# LANGUAGE CPP, ForeignFunctionInterface #-}
-- | Darwin System Calls
-- http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/#group_Section_2
module System.Syscall.Linux 
       ( c_sendfile
       )
       where

import Foreign
import Foreign.C

-- | sendfile
-- int sendfile(int fd, int s, off_t offset, off_t *len, struct sf_hdtr *hdtr, int flags);
foreign import ccall unsafe "sys/uio.h sendfile" c_sendfile
  :: Fd -> Fd -> (#type off_t) -> Ptr (#type off_t) -> Ptr () -> CInt -> IO CInt
