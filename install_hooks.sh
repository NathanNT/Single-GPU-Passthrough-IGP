#!/bin/bash
# taken from https://gitlab.com/risingprismtv/single-gpu-passthrough
if test -e /etc/libvirt/ && ! test -e /etc/libvirt/hooks;
then
    mkdir -p /etc/libvirt/hooks;
fi
if test -e /etc/libvirt/hooks/qemu;
then
    mv /etc/libvirt/hooks/qemu /etc/libvirt/hooks/qemu_last_backup
fi

# Create the directories for the hooks if they don't already exist
mkdir -p /etc/libvirt/hooks/qemu.d/win10/prepare/begin
mkdir -p /etc/libvirt/hooks/qemu.d/win10/started/begin
mkdir -p /etc/libvirt/hooks/qemu.d/win10/release/end

# Move and backup existing scripts if they exist
if test -e /etc/libvirt/hooks/qemu.d/win10/prepare/begin/load-vfio.sh;
then
    mv /etc/libvirt/hooks/qemu.d/win10/prepare/begin/load-vfio.sh /etc/libvirt/hooks/qemu.d/win10/prepare/begin/load-vfio.sh.bkp
fi

if test -e /etc/libvirt/hooks/qemu.d/win10/started/begin/reload-gdm-vt.sh;
then
    mv /etc/libvirt/hooks/qemu.d/win10/started/begin/reload-gdm-vt.sh /etc/libvirt/hooks/qemu.d/win10/started/begin/reload-gdm-vt.sh.bkp
fi

if test -e /etc/libvirt/hooks/qemu.d/win10/release/end/unload-vfio.sh;
then
    mv /etc/libvirt/hooks/qemu.d/win10/release/end/unload-vfio.sh /etc/libvirt/hooks/qemu.d/win10/release/end/unload-vfio.sh.bkp
fi

if test -e /etc/systemd/system/libvirt-nosleep@.service;
then
    rm /etc/systemd/system/libvirt-nosleep@.service
fi

cp systemd-no-sleep/libvirt-nosleep@.service /etc/systemd/system/libvirt-nosleep@.service
cp hooks/vfio-startup.sh /etc/libvirt/hooks/qemu.d/win10/prepare/begin/load-vfio.sh
cp hooks/reload-gdm-vt.sh /etc/libvirt/hooks/qemu.d/win10/started/begin/reload-gdm-vt.sh
cp hooks/vfio-teardown.sh /etc/libvirt/hooks/qemu.d/win10/release/end/unload-vfio.sh

# Update permissions for the scripts
chmod +x /etc/libvirt/hooks/qemu.d/win10/prepare/begin/load-vfio.sh
chmod +x /etc/libvirt/hooks/qemu.d/win10/started/begin/reload-gdm-vt.sh
chmod +x /etc/libvirt/hooks/qemu.d/win10/release/end/unload-vfio.sh
