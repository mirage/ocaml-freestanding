#!/bin/sh

export PKG_CONFIG_PATH=$(opam config var prefix)/share/pkgconfig
pkg_exists() {
    pkg-config --exists "$@"
}
if pkg_exists solo5-kernel-ukvm solo5-kernel-virtio; then
    echo "ERROR: Conflicting packages." 1>&2
    echo "ERROR: Only one of solo5-kernel-ukvm, solo5-kernel-virtio can be installed." 1>&2
    exit 1
fi
PKG_CONFIG_DEPS=
pkg_exists solo5-kernel-ukvm && PKG_CONFIG_DEPS=solo5-kernel-ukvm
pkg_exists solo5-kernel-virtio && PKG_CONFIG_DEPS=solo5-kernel-virtio
if [ -z "${PKG_CONFIG_DEPS}" ]; then
    echo "ERROR: No supported kernel package found." 1>&2
    echo "ERROR: solo5-kernel-ukvm or solo5-kernel-virtio must be installed." 1>&2
    exit 1
fi

FREESTANDING_CFLAGS="$(pkg-config --cflags ${PKG_CONFIG_DEPS})"

case $(ocamlopt -version) in
    4.02.3)
        ;;
    4.03.0)
        OCAML_EXTRA_DEPS=build/ocaml/byterun/caml/version.h
        ;;
    4.04.[0-9]|4.04.[0-9]+*)
        OCAML_EXTRA_DEPS=build/ocaml/byterun/caml/version.h
        ;;
    *)
        echo "ERROR: Unsupported OCaml version: $(ocamlopt -version)." 1>&2
        exit 1
        ;;
esac

cat <<EOM >Makeconf
FREESTANDING_CFLAGS=${FREESTANDING_CFLAGS}
NOLIBC_SYSDEP_OBJS=sysdeps_solo5.o
PKG_CONFIG_DEPS=${PKG_CONFIG_DEPS}
OCAML_EXTRA_DEPS=${OCAML_EXTRA_DEPS}
EOM
