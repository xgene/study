::$ cat ~/bin/buildcmd
::#!/bin/sh
::set -e
::for arch in 8 6; do
::        for cmd in a c g l; do
::                go tool dist install -v cmd/$arch$cmd
::        done
::done
::exit 0

::此脚本名: buildcmd.cmd
:: 在go/src目录下执行此脚本
@echo off
FOR %%A IN (8 6 5) DO FOR %%C IN (a c g l) DO go tool dist install -v cmd/%%A%%C