{-# LANGUAGE CPP #-}

module System.Syscall 
  ( c_open, c_close,
    c_read, c_write,
    c_fcntl,
    StructStat(..), c_stat, c_fstat, c_lstat,
    c_sendfile
   ) where

#if defined(LINUX)
import System.Syscall.Linux
#endif
#if defined(DARWIN)
import System.Syscall.Darwin
#endif
