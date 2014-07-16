::$ cat ~/bin/buildpkg
::#!/bin/sh
::if [ -z "$1" ]; then
::        echo 'GOOS is not specified' 1>&2
::        exit 2
::else
::        export GOOS=$1
::        if [ "$GOOS" = "windows" ]; then
::                export CGO_ENABLED=0
::        fi
::fi
::shift
::if [ -n "$1" ]; then
::       export GOARCH=$1
::fi
::cd $GOROOT/src
::go tool dist install -v pkg/runtime
::go install -v -a std

::此脚本名: buildpkg.cmd
::在go/src目录下执行 buildpkg windows 386
::在go/src目录下执行 buildpkg linux arm
::在go/src目录下执行 buildpkg linux 386
::在go/src目录下执行 buildpkg linux amd64

@echo off
::set DEVROOT=%CD%
::set GOROOT=%DEVROOT%/../go

IF "%1" == "" GOTO NOGOOS ELSE GOTO SETVARS

:SETVARS
SET GOOS=%1
IF "%GOOOS%"=="windows" SET CGO_ENABLED=0
IF NOT "%2" == "" SET GOARCH=%2
CD /D %GOROOT%/src
echo goos is %GOOS%
echo cd is %CD%
echo go arch is %GOARCH%
go tool dist install -v pkg/runtime
go install -v -a std
GOTO OVER

:NOGOOS
ECHO "GOOS is not specified"
GOTO OVER

:OVER
