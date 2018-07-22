#!/bin/bash
#
# Automatic update for made-in-ovh OVH kernels.
#
# VERSION       :0.3
# DATE          :2017-07-22
# AUTHOR        :Luniun
# LICENSE       :The MIT License (MIT)
# URL           :https://github.com/luniun/OVHkernelautoupdate.sh
# BASH-VERSION  :4.2+
# DOCUMENTATION :http://help.ovh.co.uk/KernelInstall
# RSS-FEED      :http://www.ftp2rss.com/rss?v=1&ftp=ftp%3A%2F%2Fftp.ovh.net%2Fmade-in-ovh%2FbzImage&port=21&files=20
# DEPENDS       :apt-get install lftp heirloom-mailx

OVH_KERNELS="ftp://ftp.ovh.net/made-in-ovh/bzImage/latest-production/"
# IPv6 + amd64 + hz1000
CURRENT="$(ls /boot/*-xxxx-std-ipv6-64-hz1000)"

lftp -e "lcd /boot/; mirror -i '.*-xxxx-std-ipv6-64-hz1000$'; bye" "$OVH_KERNELS"
NEW="$(ls /boot/*-xxxx-std-ipv6-64-hz1000)"

if ! [ "$CURRENT" == "$NEW" ]; then
    echo -e "update-grub && reboot\nnewest two:\n$(ls -1tr /boot/bzImage-*|tail -n2)" \
        | mailx -s "[$(hostname -s)] new kernel from OVH" root
fi

