my email: boyseeyou at 163.com

64位WIN7中golang交叉编译环境(适用于go1.1-1.4, go1.5请看文末)
================================================

# 准备交叉编译环境
------------------------------

## 下载go源码　
本例以go1.1beta2为例,你可以在此处下载[go源码](http://www.golangtc.com/download)，我下载的是“go1.1beta2.windows-amd64.zip”，下载完后解压到目录“L:\golangdev\go”（因为本人的go开发环境放在移动硬盘上,所以不是一般建议的放在“C:\go”）。为了在后面的段落中便于描述，我将设置环境变量“set DEVROOT=L:/golangdev”,便于后面引用。

------------------------------
## 编译本机系统go编译环境([本节参考于此处](https://code.google.com/p/go-wiki/wiki/WindowsCrossCompiling))
在“%DEVROOT%/go/src”中建立脚本start.cmd,内容如下：

```dos
:: 本人习惯用脚本开启命令行
start set PATH=L:\golangdev\go\bin;%PATH%
```

执行脚本start.cmd,出现命令窗口，执行脚本：all.bat,另外PATH中应该有GCC编译环境,我加入了MINGW。

--------------------------
## 编译各平台的编译器和连接器([本节参考于此处](https://code.google.com/p/go-wiki/wiki/WindowsCrossCompiling))
在“%DEVROOT%/go/src”中建立脚本buildcmd.cmd,内容如下：

```dos
:: 此脚本名: buildcmd.cmd
:: 在go/src目录下执行此脚本
@echo off
FOR %%A IN (8 6 5) DO FOR %%C IN (a c g l) DO go tool dist install -v cmd/%%A%%C
```

执行脚本start.cmd开启命令窗口，执行脚本：buildcmd.cmd 

---------------------------
## 生成各平台的标准命令工具和库
在“%DEVROOT%/go/src”中建立脚本buildpkg.cmd,内容如下：

```dos
::此脚本名: buildpkg.cmd
::在go/src目录下执行 buildpkg windows 386
::在go/src目录下执行 buildpkg linux arm
::在go/src目录下执行 buildpkg linux 386
::在go/src目录下执行 buildpkg linux amd64

@echo off
set DEVROOT=%~d0/golangdev
set GOROOT=%DEVROOT%/go

IF "%1" == "" GOTO NOGOOS ELSE GOTO SETVARS

:SETVARS
SET GOOS=%1
IF "%GOOOS%"=="windows" SET CGO_ENABLED=0
IF NOT "%2" == "" SET GOARCH=%2
CD /D %GOROOT%/src
go tool dist install -v pkg/runtime
go install -v -a std
GOTO OVER

:NOGOOS
ECHO "GOOS is not specified"
GOTO OVER

:OVER
```

本机是64位WIN7,如果需要
* 能编译在XP上运行的程序执行 buildpkg windows 386
* 能编译在ARM CPU上运行的程序执行 buildpkg linux arm
* 能编译在32 LINUX上运行的程序执行 buildpkg linux 386
* 能编译在64 LINUX上运行的程序执行 buildpkg linux amd64

**至此应该可以编译几个平台的程序了**


-----------------------------
## 配置LiteIDE
关于LiteIDE,你可以在此处[下载](http://sourceforge.net/projects/liteide/files/)，下载后将其解压在“%DEVROOT%/liteide”目录下，与go目录同级。
在“%DEVROOT%”中建立脚本start\_liteide.cmd,内容如下：

```dos
set DEVROOT=%~d0/golangdev
start liteide/bin/liteide.exe
```

我建立此脚本的原因是我的移动硬盘在公司电脑和家里的电脑上，盘符会改变，每次都要手动变更LiteIDE的配置盘符，我又不想把这些环境变量配置到系统环境变量中。


如果需要编译于C,C++相关的代码，如数据库驱动，则需要mingw,msys（要这个是因为有git和一些命令行工具）。　下载他们放入以下目录
* mingw32放入“%DEVROOT%\mingwxx\mingw32” 
* mingw64放入“%DEVROOT%\mingwxx\mingw64” 
* msys放入“%DEVROOT%\mingwxx\msys” 


配置LiteIDE下的win32编译环境变量：

```dos
# native compiler windows 386

# DEVROOT=L:/golangdev
GOROOT=%DEVROOT%/go
GOBIN=%GOROOT%/bin
GOARCH=386
GOOS=windows
CGO_ENABLED=1

LITEIDE_GDB=gdb
LITEIDE_MAKE=mingw32-make
LITEIDE_TERM=%COMSPEC%
LITEIDE_TERMARGS=
LITEIDE_EXEC=%COMSPEC%
LITEIDE_EXECOPT=/C

MINGW=%DEVROOT%/mingwxx/mingw32
MSYS=%DEVROOT%/mingwxx/msys
PATH=%GOROOT%/bin;%DEVROOT%/liteide/bin;%MINGW%/bin;%MSYS%/bin;%PATH%

CGO_CFLAGS=-I%MINGW%/include
CGO_LDFLAGS=-L%MINGW%/lib
```

可以看到上面的DEVROOT被注释掉了，所以需要用 **start\_liteide.cmd** 脚本启动LiteIDE。

配置LiteIDE下的win64编译环境变量：

```dos
# native compiler windows amd64

# DEVROOT=L:/golangdev
GOROOT=%DEVROOT%/go
GOBIN=%GOROOT%/bin
GOARCH=amd64
GOOS=windows
CGO_ENABLED=1

LITEIDE_GDB=gdb64
LITEIDE_MAKE=mingw32-make
LITEIDE_TERM=%COMSPEC%
LITEIDE_TERMARGS=
LITEIDE_EXEC=%COMSPEC%
LITEIDE_EXECOPT=/C

MINGW=%DEVROOT%/mingwxx/mingw64
MSYS=%DEVROOT%/mingwxx/msys
PATH=%GOROOT%/bin;%DEVROOT%/liteide/bin;%MINGW%/bin;%MSYS%/bin;%PATH%

CGO_CFLAGS=-I%MINGW%/include
CGO_LDFLAGS=-L%MINGW%/lib

```

配置LiteIDE下的linux32编译环境变量：
```dos
# cross-compiler linux 386

#DEVROOT=L:/golangdev
GOROOT=%DEVROOT%/go
GOBIN=%GOROOT%/bin
GOARCH=386
GOOS=linux
CGO_ENABLED=0

LITEIDE_GDB=gdb
LITEIDE_MAKE=mingw32-make
LITEIDE_TERM=%COMSPEC%
LITEIDE_TERMARGS=
LITEIDE_EXEC=%COMSPEC%
LITEIDE_EXECOPT=/C

MINGW=%DEVROOT%/mingwxx/mingw32
MSYS=%DEVROOT%/mingwxx/msys
PATH=%GOROOT%/bin;%DEVROOT%/liteide/bin;%MINGW%/bin;%MSYS%/bin;%PATH%

CGO_CFLAGS=-I%MINGW%/include
CGO_LDFLAGS=-L%MINGW%/lib
```

## 编译一个数据库驱动
### 建立一个脚本来设置环境变量，执行命令行从github.com上下载工程代码
```dos
set DEVROOT=%~d0/golangdev
set GOARCH=amd64
set GOOS=windows
set GOROOT=%DEVROOT%/go
set MINGW=%DEVROOT%/mingwxx/mingw64
set MSYS=%DEVROOT%/mingwxx/msys
set PATH=%GOROOT%/bin;%DEVROOT%/liteide/bin;%MINGW%/bin;%MSYS%/bin;%PATH%
set GOPATH=E:/KDISK/3-APPSRC/9-GO/workspace
```
其中GOPATH是你下载代码的本地存放处， **在LiteIDE中你也要配置“自定义GOPATH”** ,msys中有git,所以用一下命令来获取代码：
```dos
go get github.com/mattn/go-oci8

```

### 下载数据库ＳＤＫ，修改代码并编译

去oracle官网下载ＳＤＫ，放到目录“L:\msdotnet\instantclient_11_2”
将go-oci8工程中oci.go的一处代码“#cgo pkg-config: oci8”　修改为：
```go
#cgo windows LDFLAGS: -LL:/msdotnet/instantclient_11_2 -loci
#cgo windows CFLAGS: -IL:/msdotnet/instantclient_11_2/sdk/include/
```
这两行也可以写在LiteIDE的配置文件中，你可以参考前面的说明。
至此，你可以编译win32的驱动了

#编译GO1.5
先将go1.4复制到C:\Users\Administrator\go1.4,在go/src下建立buildgo15bygo14.cmd,内容如下
```dos
set DEVROOT=%~d0/alllangdev
set GOHOME=%DEVROOT%/golangdev
set GOROOT=%GOHOME%/go
set GOBIN=%GOROOT%/bin
set MINGW=%DEVROOT%/tools/mingw_gcc492/mingw64
set MSYS=%DEVROOT%/tools/msys
set CYGWIN=%DEVROOT%/tools/cygwin64
set PATH=%GOROOT%/bin;%GOHOME%/liteide/bin;%MINGW%/bin;%MSYS%/bin;%CYGWIN%/bin;%PATH%
 


::GOOS    GOARCH
::windows 386
::linux arm
::linux 386
::linux amd64

SET GOOS=windows
SET GOARCH=386
call make.bat --no-clean --no-local

SET GOOS=linux

SET GOARCH=386
call make.bat --no-clean --no-local
SET GOARCH=arm
call make.bat --no-clean --no-local
SET GOARCH=amd64
call make.bat --no-clean --no-local

```
最后执行buildgo15bygo14.cmd吧.

## 包管理
建议使用[glide](https://github.com/Masterminds/glide),我见过的最好的包管理工具。可以学习这两篇文章[《Golang依赖管理工具：glide从入门到精通使用》](https://studygolang.com/articles/10453?fr=email)[《Golang包管理工具Glide，你值得拥有》](https://blog.csdn.net/chenqijing2/article/details/55050843)
解决包路径与git库路径不一致的问题,示例如下
```
- package: golang.org/x/sys
  repo: https://github.com/golang/sys.git
```
# 后记
**本文是作为笔记记录的，很杂乱，可能有很多谬误，如果有什么指正可告知我，顶部有我的邮件地址，但是不能保证及时回复。**



