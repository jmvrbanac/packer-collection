#!/bin/sh

# Install pre-reqs
yum -y install fuse fuse-libs

mount -o loop /home/vagrant/linux.iso /mnt
cd /tmp
tar zxf /mnt/VMwareTools-*.tar.gz
umount /mnt

/tmp/vmware-tools-distrib/vmware-install.pl --default

# Clean up
rm -rf /tmp/vmware-tools-distrib
rm -rf /home/vagrant/linux.iso
