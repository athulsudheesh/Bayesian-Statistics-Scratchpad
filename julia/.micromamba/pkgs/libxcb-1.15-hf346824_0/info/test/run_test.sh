

set -ex



test -f $PREFIX/lib/libxcb.dylib
test -f $PREFIX/lib/libxcb-composite.dylib
test -f $PREFIX/lib/libxcb-damage.dylib
test -f $PREFIX/lib/libxcb-dpms.dylib
test -f $PREFIX/lib/libxcb-dri2.dylib
test -f $PREFIX/lib/libxcb-glx.dylib
test -f $PREFIX/lib/libxcb-present.dylib
test -f $PREFIX/lib/libxcb-randr.dylib
test -f $PREFIX/lib/libxcb-record.dylib
test -f $PREFIX/lib/libxcb-res.dylib
test -f $PREFIX/lib/libxcb-screensaver.dylib
test -f $PREFIX/lib/libxcb-shape.dylib
test -f $PREFIX/lib/libxcb-shm.dylib
test -f $PREFIX/lib/libxcb-sync.dylib
test -f $PREFIX/lib/libxcb-xf86dri.dylib
test -f $PREFIX/lib/libxcb-xfixes.dylib
test -f $PREFIX/lib/libxcb-xinerama.dylib
test -f $PREFIX/lib/libxcb-xkb.dylib
test -f $PREFIX/lib/libxcb-xtest.dylib
test -f $PREFIX/lib/libxcb-xv.dylib
test -f $PREFIX/lib/libxcb-xvmc.dylib
test -f $PREFIX/lib/libxcb-dri3.dylib
test -f $PREFIX/lib/libxcb-render.dylib
test -f $PREFIX/lib/libxcb-xinput.dylib
exit 0
