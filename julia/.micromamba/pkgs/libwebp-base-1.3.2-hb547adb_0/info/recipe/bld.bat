@echo on

mkdir build
cd build

cmake -G Ninja ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_DATADIR=%LIBRARY_PREFIX% ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DWEBP_BUILD_CWEBP:BOOL=OFF ^
    -DWEBP_BUILD_DWEBP:BOOL=OFF ^
    -DWEBP_BUILD_EXTRAS:BOOL=OFF ^
    -DWEBP_BUILD_GIF2WEBP:BOOL=OFF ^
    -DWEBP_BUILD_IMG2WEBP:BOOL=OFF ^
    -DWEBP_BUILD_LIBWEBPMUX:BOOL=ON ^
    -DWEBP_BUILD_VWEBP:BOOL=OFF ^
    -DWEBP_BUILD_WEBP_JS:BOOL=OFF ^
    -DWEBP_BUILD_WEBPINFO:BOOL=OFF ^
    -DWEBP_BUILD_WEBPMUX:BOOL=OFF ^
    -DWEBP_LINK_STATIC:BOOL=OFF ^
    ..
if %ERRORLEVEL% neq 0 exit 1

cmake --build .
if %ERRORLEVEL% neq 0 exit 1

cmake --install . --prefix %LIBRARY_PREFIX%
if %ERRORLEVEL% neq 0 exit 1