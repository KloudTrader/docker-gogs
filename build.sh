#!/bin/bash

arch=($1)

case ${arch} in
    i386 ) base_image="resin/i386-alpine" ;;
    amd64 ) base_image="alpine:3.7" ;;
    arm ) base_image="resin/rpi-alpine" ;;
    arm64 ) base_image="resin/aarch64-alpine" ;;
esac
cp Dockerfile Dockerfile.${arch}
sed -i "s@alpine:3.7@$base_image@g" Dockerfile.${arch}

