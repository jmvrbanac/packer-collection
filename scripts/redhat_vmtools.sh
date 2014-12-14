#!/bin/sh

cd /tmp

# VirtualBox Tools
if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)

    # Mount and Install
    mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run

    # Clean up
    umount /mnt
    rm -rf /home/vagrant/VBoxGuestAdditions_*.iso
fi

# VMWare Tools
if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    # Install pre-reqs
    yum -y install fuse fuse-libs

    # Mount and Install
    mount -o loop /home/vagrant/linux.iso /mnt
    tar zxf /mnt/VMwareTools-*.tar.gz
    /tmp/vmware-tools-distrib/vmware-install.pl --default

    # Clean up
    umount /mnt
    rm -rf /tmp/vmware-tools-distrib
    rm -rf /home/vagrant/linux.iso
fi