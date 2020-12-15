@echo off
:: To build extensions for 64 bit Python 3, we need to configure environment
:: variables to use the MSVC 2010 C++ compilers from GRMSDKX_EN_DVD.iso of:
:: MS Windows SDK for Windows 7 and .NET Framework 4
::
:: More details at:
:: https://github.com/cython/cython/wiki/64BitCythonExtensionsOnWindows


:: note: VS 2010 has stdint.h bundled so simply copy it. Cython should not
::       depend on it for py27 (works fine when compiling using C code)
::       but this works differently for C++ (maybe there is some other issue
::       with environment setup).
:: try to do a dirty workaround for Cython with C++ for py27
IF "%PYTHON%"=="C:\Python27" SET _py27=1
IF "%PYTHON%"=="C:\Python27-x64" SET _py27=1

IF "%_py27%"=="1" (
    ECHO "PYTHON 2.7 => copying stdint.h"
    cp "c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include\stdint.h" "C:\Users\appveyor\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0\VC\include\stdint.h"
) ELSE (
    ECHO "NOT PYTHON 2.7"
)

IF "%DISTUTILS_USE_SDK%"=="1" (
    ECHO Configuring environment to build with MSVC on a 64bit architecture
    ECHO Using Windows SDK 7.1
    "C:\Program Files\Microsoft SDKs\Windows\v7.1\Setup\WindowsSdkVer.exe" -q -version:v7.1
    CALL "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64 /release
    SET MSSdk=1
    REM Need the following to allow tox to see the SDK compiler
    SET TOX_TESTENV_PASSENV=DISTUTILS_USE_SDK MSSdk INCLUDE LIB
) ELSE (
    ECHO Using default MSVC build environment
)

CALL %*
