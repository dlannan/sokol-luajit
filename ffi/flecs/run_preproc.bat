@echo off
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"

cl /nologo /EP .\flecs.h > flecs_ffi.h

cmd /k