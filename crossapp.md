### 1.下载源码
### 2.eclipse加载CrossApp\CrossApp\proj.android
### 3.eclipse加载CrossApp\samples\Test\proj.android
### 4.编辑CrossApp\samples\Test\proj.android\jni\Android.mk,去掉下面两行前的注释,使之有效
### $(call import-add-path, $(LOCAL_PATH)/../../../..)
### $(call import-add-path, $(LOCAL_PATH)/../../../../CrossApp/the_third_party/)
### 5,eclipse工程=>properties=>c/c++build=>Environment=>NDK_ROOT 修改为你实际的NDK目录(该目录下包含ndk_build.cmd)
### 6.eclipse工程=>properties=>c/c++build=>(TAB)builder settings=>build command: 的值修改为 ${NDK_ROOT}\ndk-build.cmd 
### 7.eclipse工程=>properties=>c/c++ general=>Paths and Symbols=>(TAB)includes=> Assembly=>修改实际的包含文件目录地址
* ${ProjDirPath}/../../../CrossApp
* ${ProjDirPath}/../../../CrossApp/samples/Test/proj.android/jni
* ${NDK_ROOT}/sources/......................
* ${NDK_ROOT}/platforms/...........................
* ${NDK_ROOT}/toolchains/.................................
