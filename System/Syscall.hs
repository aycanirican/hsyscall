{-# LANGUAGE CPP #-}

module System.Syscall 
  ( c_open, c_close,
    c_read, c_write,
    c_stat, 
    c_fcntl_read, c_fcntl_write, c_fcntl_lock,
    c_sendfile
   ) where

import System.Posix.Internals

#if defined(LINUX)
import System.Syscall.Linux
#endif
#if defined(DARWIN)
import System.Syscall.Darwin
#endif
