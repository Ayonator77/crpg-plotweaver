@echo off
REM -collection:pw=src makes `import "pw:engine/platform"` work from any file in the tree,
REM so packages never refer to each other with fragile ../../ relative paths.
REM -debug turns on ODIN_DEBUG (tracking allocator, GL debug context) and emits PDB symbols.
odin run src -collection:pw=src -out:bin/plotweaver.exe -debug
