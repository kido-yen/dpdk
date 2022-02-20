#!/bin/bash
PROFILE="BASIC"
PKG_VER="20.11.4"
CWD=$(dirname $0)
[[ "${CWD}" == "." ]] && CWD=$(pwd)
docker image build -t dpdk:"${PROFILE}"_"${PKG_VER}" --build-arg PROFILE="${PROFILE}" --build-arg PKG_VER="${PKG_VER}" -f "${CWD}"/docker-images/dpdk/dockerfile .
