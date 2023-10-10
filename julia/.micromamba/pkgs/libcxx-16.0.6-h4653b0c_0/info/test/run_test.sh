

set -ex



echo 1
test -f $PREFIX/include/c++/v1/iterator
bash compile_test.sh
if [ 0 -eq $(cat ${PREFIX}/include/c++/v1/__availability | grep "availability(macos" | grep -vE "(conda-forge|10.9)" | wc -l) ]; then exit 0; else exit 1; fi
if [ -f $PREFIX/lib/libc++abi.dylib ]; then exit 1; fi
exit 0
