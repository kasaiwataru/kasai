#!/bin/sh

     prefix=/usr/local
exec_prefix=${prefix}

    bin_dir=${exec_prefix}/bin
   sbin_dir=${exec_prefix}/sbin
    lib_dir=${exec_prefix}/lib
libexec_dir=${exec_prefix}/libexec
 sysconfdir=${prefix}/etc

# fws specific dir
fwsconfdir=${prefix}/etc/fws
  fwsdbdir=/var/fws/db
fws_image_dir=${prefix}/var/images
  disk_dir=$fws_image_dir/qemu
 cdrom_dir=$fws_image_dir/iso

# user database
database=/var/fws/db/database


#
# local configurations
#
manager_ip="10.129.145.21"

bokan_user="fws"
bokan_ip="127.0.0.1"

os_installer_iso=debian-live-9.8.0-i386-gnome.iso
