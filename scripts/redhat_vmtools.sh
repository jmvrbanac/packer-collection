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
    ISO_MOUNT="/media"
    VMWARE_INSTALL_SCRIPT="/tmp/vmware/vmware-tools-distrib/vmware-install.pl"
    VMWARE_TOOLS_ISO="/home/vagrant/linux.iso"
    VMWARE_TOOLS_TMP="/tmp/vmware"

    # Install pre-reqs
    yum -y install fuse fuse-libs

    echo "Mounting ${VMWARE_TOOLS_ISO} onto ${ISO_MOUNT}"
    mount -o loop ${VMWARE_TOOLS_ISO} ${ISO_MOUNT}

    echo "Extracting VMWare Tools to /tmp/vmware"
    mkdir -p ${VMWARE_TOOLS_TMP}

    echo "Extracting ${ISO_MOUNT}/VMwareTools-*.tar.gz to ${VMWARE_TOOLS_TMP}"
    tar xzf ${ISO_MOUNT}/VMwareTools-*.tar.gz -C ${VMWARE_TOOLS_TMP}

    echo "Unmounting ${VMWARE_TOOLS_ISO} from ${ISO_MOUNT}"
    umount ${ISO_MOUNT}

    echo "Running ${VMWARE_INSTALL_SCRIPT}"
    ${VMWARE_INSTALL_SCRIPT} -d

    # Enable auto build
    # sed -i "s/AUTO_KMODS_ENABLED_ANSWER no/AUTO_KMODS_ENABLED_ANSWER yes/g" /etc/vmware-tools/locations
    # sed -i "s/AUTO_KMODS_ENABLED no/AUTO_KMODS_ENABLED yes/g" /etc/vmware-tools/locations

    # Clean up
    echo "Cleaning up ${VMWARE_TOOLS_ISO} and ${VMWARE_TOOLS_TMP}"
    rm ${VMWARE_TOOLS_ISO}
    rm -rf ${VMWARE_TOOLS_TMP}
fi
