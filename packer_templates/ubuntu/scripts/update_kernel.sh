#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive

apt-get install -y linux-image-5.0.0-20-generic linux-headers-5.0.0-20-generic;

reboot
