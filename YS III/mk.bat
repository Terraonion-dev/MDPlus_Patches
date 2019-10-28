SET SGDK=G:\SGDK-Master
SET TOPATCH=..\bin

%SGDK%\bin\as -m68000 patch.s -o patch.o
%SGDK%\bin\objcopy -O binary patch.o patch.bin
%TOPATCH%\TOPatcher -patch patch.to "Ys III (USA).md" "Ys III (USA)_patched.md"

