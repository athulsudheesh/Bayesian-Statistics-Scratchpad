

set -ex



test -f $PREFIX/lib/libwebp.dylib
test ! -f $PREFIX/lib/libwebp.a
test $PREFIX/pkgconfig/libwebp.pc
test -f $PREFIX/lib/libwebpdemux.dylib
test ! -f $PREFIX/lib/libwebpdemux.a
test $PREFIX/pkgconfig/libwebpdemux.pc
test -f $PREFIX/lib/libwebpmux.dylib
test ! -f $PREFIX/lib/libwebpmux.a
test $PREFIX/pkgconfig/libwebpmux.pc
test -f $PREFIX/lib/libwebpdecoder.dylib
test ! -f $PREFIX/lib/libwebpdecoder.a
test $PREFIX/pkgconfig/libwebpdecoder.pc
test -f $PREFIX/lib/libsharpyuv.dylib
test ! -f $PREFIX/lib/libsharpyuv.a
test $PREFIX/pkgconfig/libsharpyuv.pc
test -f $PREFIX/include/webp/decode.h || (echo "decode.h not found" && exit 1)
test -f $PREFIX/include/webp/demux.h || (echo "demux.h not found" && exit 1)
test -f $PREFIX/include/webp/encode.h || (echo "encode.h not found" && exit 1)
test -f $PREFIX/include/webp/mux_types.h || (echo "mux_types.h not found" && exit 1)
test -f $PREFIX/include/webp/mux.h || (echo "mux.h not found" && exit 1)
test -f $PREFIX/include/webp/types.h || (echo "types.h not found" && exit 1)
test ! -f $PREFIX/bin/cwebp
test ! -f $PREFIX/bin/dwebp
test ! -f $PREFIX/bin/gif2webp
test ! -f $PREFIX/bin/img2webp
test ! -f $PREFIX/bin/webpinfo
test ! -f $PREFIX/bin/webpmux
exit 0
