@echo off
setlocal enableextensions

rem Default to organizer image under your GHCR owner. For now use 'bishnubista'.
if "%IMAGE%"=="" set IMAGE=ghcr.io/bishnubista/saf-mcp-sandbox:latest
if "%FLAGS_DIR%"=="" set FLAGS_DIR=%cd%\flags

docker run --rm -i ^
  --read-only ^
  --pids-limit 128 ^
  --memory 256m ^
  --security-opt no-new-privileges ^
  --network none ^
  -e MODE=safe ^
  -v "%FLAGS_DIR%:/opt/flags:ro" ^
  "%IMAGE%"

endlocal
