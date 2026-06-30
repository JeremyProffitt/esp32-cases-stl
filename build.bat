@echo off
REM build.bat - Generate STL + PNG (front & rear) for every .scad in the repo.
REM Windows. Outputs to build\.
REM
REM Usage: build.bat

setlocal enabledelayedexpansion

set "OPENSCAD=openscad"
where %OPENSCAD% >nul 2>&1
if errorlevel 1 (
    if exist "C:\Program Files\OpenSCAD\openscad.exe" set "OPENSCAD=C:\Program Files\OpenSCAD\openscad.exe"
    if exist "C:\Program Files (x86)\OpenSCAD\openscad.exe" set "OPENSCAD=C:\Program Files (x86)\OpenSCAD\openscad.exe"
)

set "ROOT=%~dp0"
set "OUT=%ROOT%build"
if not exist "%OUT%" mkdir "%OUT%"

set "IMGSIZE=800,600"
REM Front: rotX=55, rotY=0, rotZ=45 ; Rear: rotZ=225 (see CLAUDE.md)
set "CAM_FRONT=0,0,0,55,0,45,0"
set "CAM_REAR=0,0,0,55,0,225,0"
set "SCAD_MODEL_DEFINES=-D see_in_color=0"

for /r "%ROOT%" %%S in (*.scad) do (
    echo %%S | findstr /i /c:"\\build\\" /c:"\\tools\\" >nul
    if errorlevel 1 (
        set "NAME=%%~nS"
        echo ^>^> !NAME!
        "%OPENSCAD%" %SCAD_MODEL_DEFINES% -o "%OUT%\!NAME!.stl" --export-format=binstl "%%S"
        "%OPENSCAD%" %SCAD_MODEL_DEFINES% -o "%OUT%\!NAME!_front.png" --camera=%CAM_FRONT% --viewall --autocenter --imgsize=%IMGSIZE% --colorscheme=Tomorrow "%%S"
        "%OPENSCAD%" %SCAD_MODEL_DEFINES% -o "%OUT%\!NAME!_rear.png" --camera=%CAM_REAR% --viewall --autocenter --imgsize=%IMGSIZE% --colorscheme=Tomorrow "%%S"
    )
)

REM Engineering drawing sheets (multi-view, dimensioned). Needs Python + Pillow.
python -c "import PIL" >nul 2>&1
if errorlevel 1 (
    echo ^>^> skipping drawing sheets ^(Python Pillow not installed^)
) else (
    echo ^>^> drawing sheets
    set "OPENSCAD=%OPENSCAD%"
    python "%ROOT%tools\make_drawings.py"
)

echo Done. Artifacts in %OUT%\
endlocal
