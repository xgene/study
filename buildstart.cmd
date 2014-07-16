set DEVROOT=%~d0/alllangdev
set GOHOME=%DEVROOT%/golangdev
set GOROOT=%GOHOME%/go
set GOBIN=%GOROOT%/bin
set MINGW=%DEVROOT%/tools/mingw_gcc481/mingw64
set MSYS=%DEVROOT%/tools/msys
set CYGWIN=%DEVROOT%/tools/cygwin64
set PATH=%GOROOT%/bin;%GOHOME%/liteide/bin;%MINGW%/bin;%MSYS%/bin;%CYGWIN%/bin;%PATH%
 
call buildcmd.cmd
call buildpkg windows 386
call buildpkg linux arm
call buildpkg linux 386
call buildpkg linux amd64