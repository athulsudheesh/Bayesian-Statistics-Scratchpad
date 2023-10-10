

set -ex



test -f $PREFIX/lib/libomp.dylib
test -f $PREFIX/include/omp.h
$PREFIX/bin/clang -v -fopenmp -I$PREFIX/include -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib $LNK_XTRA omp_hello.c -o omp_hello
./omp_hello
exit 0
