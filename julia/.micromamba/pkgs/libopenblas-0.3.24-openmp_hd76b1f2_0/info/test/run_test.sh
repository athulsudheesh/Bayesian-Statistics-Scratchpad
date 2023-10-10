

set -ex



test -f ${PREFIX}/lib/libopenblasp-r0.3.24.dylib
nm -g ${PREFIX}/lib/libopenblasp-r0.3.24.dylib | grep dsecnd
python -c "import ctypes; ctypes.cdll['${PREFIX}/lib/libopenblasp-r0.3.24.dylib']"
exit 0
