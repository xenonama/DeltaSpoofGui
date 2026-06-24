@echo off
cd /d C:\Users\agolb\Desktop\Ubuntu\DeltaSpoof
set PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;C:\Users\agolb\.cargo\bin;%PATH%
rustc +stable-x86_64-pc-windows-gnu -vV
if errorlevel 1 echo RUSTC FAILED & exit /b 1
cargo +stable-x86_64-pc-windows-gnu build --workspace --release
if errorlevel 1 echo CARGO FAILED & exit /b 1
copy /Y target\release\zerodpi.exe dist\zerodpi.exe
copy /Y config.toml dist\config.toml
echo BUILD SUCCESS
