{-# LANGUAGE CPP #-}

module System.Syscall 
  ( c_open, c_close,
    c_read, c_write,
    c_stat, 
    c_fcntl_read, c_fcntl_write, c_fcntl_lock,
    c_sendfile
   ) where

import System.Posix.Internals
import System.Posix.Types
import Foreign.C
import Foreign.Storable(poke)
import Foreign.Marshal (alloca)

#if defined(LINUX)
import System.Syscall.Linux
#endif

#if defined(DARWIN)
import System.Syscall.Darwin
#endif

#if defined(FREEBSD)
import System.Syscall.FreeBSD
#endif

-- | A unified primitive signature for the sendfile syscall.
c_sendfile :: Fd -> Fd -> COff -> CSize -> IO (Either Errno CSsize)
c_sendfile ofd ifd o c = do 
  r <- _c_sendfile ofd ifd o c
  if (r < 0)
    then do e <- getErrno
            return $ Left e
    else return $ Right r


_c_sendfile :: Fd -> Fd -> COff -> CSize -> IO CSsize
#if defined(LINUX)
_c_sendfile ofd ifd o c = do
  alloca $ \off -> do
  poke off o
  r <- c_sendfile_linux ofd ifd off c
  return r
#endif

#if defined(DARWIN)
_c_sendfile ofd ifd o c = do
  alloca $ \sbytes ->
    do poke sbytes c
       r <- c_sendfile_darwin ifd ofd o sbytes 0 0
       sc <- peek $ ((castPtr sbytes)::Ptr CSsize)
       if sc > 0
         then return s
         else return r
#endif

#if defined(FREEBSD)
_c_sendfile ofd ifd o c = do
  alloca $ \sbytes ->
    do r <- c_sendfile_freebsd ifd ofd o c 0 sbytes 0
       sc <- peek $ ((castPtr sbytes)::Ptr CSsize)
       if sc > 0
         then return s
         else return r
#endif