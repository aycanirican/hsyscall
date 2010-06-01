{-# LANGUAGE CPP, ForeignFunctionInterface #-}
-- | Linux System Calls
-- http://www.kernel.org/doc/man-pages/online/pages/man2/syscalls.2.html
module System.Syscall.Linux 
       ( c_sendfile_linux
       )
       where

import Foreign
import Foreign.C
import System.Posix.Types (COff,CSsize,Fd)

-- | Sendfile
-- ssize_t sendfile(int out_fd, int in_fd, off_t * offset ", size_t" " count" );

#include <sys/sendfile.h>
foreign import ccall unsafe "sendfile" c_sendfile_linux
  :: Fd -> Fd -> Ptr COff -> CSize -> IO CSsize
