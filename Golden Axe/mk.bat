SET SGDK=G:\SGDK-Master
SET TOPATCH=..\bin

%SGDK%\bin\as -m68000 patch.s -o patch.o
%SGDK%\bin\objcopy -O binary patch.o patch.bin
%TOPATCH%\TOPatcher -patch patch.to "Golden Axe (World).md" "Golden Axe (World)_Patched.md"
%TOPATCH%\TOPatcher -patch patch_reva.to "Golden Axe (World) (Rev A).md" "Golden Axe (World) (Rev A)_Patched.md"

