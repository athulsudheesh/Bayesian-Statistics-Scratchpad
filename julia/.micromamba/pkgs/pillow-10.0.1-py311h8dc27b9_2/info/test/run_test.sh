

set -ex



pytest -v -k "not (_not_a_real_test or test_tiff_crashes[Tests/images/crash-81154a65438ba5aaeca73fd502fa4850fbde60f8.tif])"
exit 0
