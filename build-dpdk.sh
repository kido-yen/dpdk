#!/bin/sh
function env_prep_common {
  dnf install -y 'dnf-command(config-manager)' epel-release
  dnf config-manager --set-enabled powertools
  dnf install -y meson ninja-build gcc numactl-devel
  pip3 install pyelftools
}

function env_prep_advanced {
  dnf install -y zlib-devel openssl-devel libbpf-devel libfdt-devel libpcap-devel libatomic intel-ipsec-mb-devel git autoconf automake libtool nasm yasm make help2man
  git clone https://github.com/01org/isa-l/ 
  cd isa-l/ 
  ./autogen.sh
  ./configure --prefix=/usr --libdir=/usr/lib64/isa-l
  make
  make install
  echo "/usr/lib64/isa-l" > /etc/ld.so.conf.d/iasl.conf 
  cat /usr/lib64/isa-l/pkgconfig/libisal.pc > /usr/lib64/pkgconfig/libisal.pc
  ldconfig
  mkdir -p /opt/dpdk-${PKG_VER}/
  cp -dpR /usr/lib64/isa-l /opt/dpdk-${PKG_VER}/
}

function build_dpdk {
  curl https://fast.dpdk.org/rel/dpdk-${PKG_VER}.tar.xz -o dpdk-${PKG_VER}.tar.xz
  tar Jxvf dpdk-${PKG_VER}.tar.xz
  cd dpdk*-${PKG_VER}
  meson -Dprefix=/opt/dpdk-${PKG_VER} build
  cd build
  ninja
  ninja install 
}


function build_basic {
  env_prep_common
  build_dpdk
}
function build_advance {
  env_prep_common
  env_prep_advanced
  build_dpdk
}
case "$PROFILE" in
  "BASIC")
    build_basic
    ;;
  "ADVANCED")
    build_advance
    ;;
esac

