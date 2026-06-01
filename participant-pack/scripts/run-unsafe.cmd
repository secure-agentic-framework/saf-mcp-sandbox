@echo off
setlocal enableextensions

rem Determine pack dir (parent of this script) and env file path
set "PACK_DIR=%~dp0.."
set "ENV_FILE=%PACK_DIR%\image.env"

rem Load IMAGE from image.env if not provided
if "%IMAGE%"=="" if exist "%ENV_FILE%" for /f "usebackq tokens=1,* delims==" %%A in ("%ENV_FILE%") do (
  if /I "%%A"=="IMAGE" set "IMAGE=%%B"
)

if "%IMAGE%"=="" set IMAGE=ghcr.io/bishnubista/saf-mcp-hackathon:hackathon-2025-08
if "%FLAGS_DIR%"=="" set FLAGS_DIR=%cd%\flags

docker run --rm -i ^
  --read-only ^
  --pids-limit 128 ^
  --memory 256m ^
  --security-opt no-new-privileges ^
  --network none ^
  -v "%FLAGS_DIR%:/opt/flags:ro" ^
  "%IMAGE%"

endlocal
