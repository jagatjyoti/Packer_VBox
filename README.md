# Packer_VBox
Create a VirtualBox OVA image with complex option set

## Description
This build script creates an OVA image with customized network, storage and some other parameters using Packer.

### Prerequisites
* [VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads) - The virtualization platform used
* [Packer](https://www.packer.io/downloads.html) - The Build tool used
* [Provisioning script](https://www.writebash.com) - Shell script taken for Provisioning

## How to Run
Just run the build_image.sh script which will invoke packer and initiate the build. Sample output as below:
```
# ./build_image.sh



###################################################
####              IMAGE BUILD TOOL             ####
###################################################



INFO: Directory Archive already exists !
INFO: Creating directory builds ...
INFO: No previous build data found. Maybe it's the first run ...
INFO: Checking for necessary files ...

INFO: scripts/utility_install.sh found
INFO: vboxcentos7.json found
INFO: All good. Commencing build of CentOS server using Packer ;-)

virtualbox-iso output will be in this color.

==> virtualbox-iso: Downloading or copying Guest additions
    virtualbox-iso: Downloading or copying: file:///usr/share/virtualbox/VBoxGuestAdditions.iso
==> virtualbox-iso: Downloading or copying ISO
    virtualbox-iso: Downloading or copying: file:///home/luckee/Packer_VBox/CentOS-7-x86_64-Minimal-1708.iso
==> virtualbox-iso: Deleting previous output directory...
==> virtualbox-iso: Starting HTTP server on port 8010
==> virtualbox-iso: Creating virtual machine...
==> virtualbox-iso: Creating hard drive...
==> virtualbox-iso: Creating forwarded port mapping for communicator (SSH, WinRM, etc) (host port 3664)
==> virtualbox-iso: Executing custom VBoxManage commands...
    virtualbox-iso: Executing: modifyvm CentOS-server --memory 4096
    virtualbox-iso: Executing: modifyvm CentOS-server --cpus 2
    virtualbox-iso: Executing: modifyvm CentOS-server --audio none
    virtualbox-iso: Executing: modifyvm CentOS-server --nic1 nat
    virtualbox-iso: Executing: modifyvm CentOS-server --nic2 hostonly --hostonlyadapter2 vboxnet0
    virtualbox-iso: Executing: createmedium disk --filename mongo.vdi --size 78000
    virtualbox-iso: Executing: storagectl CentOS-server --add sata --controller IntelAHCI --name SATA Controller
    virtualbox-iso: Executing: storageattach CentOS-server --storagectl SATA Controller --port 1 --device 0 --type hdd --medium mongo.vdi
==> virtualbox-iso: Starting the virtual machine...
==> virtualbox-iso: Waiting 10s for boot...
==> virtualbox-iso: Typing the boot command...
==> virtualbox-iso: Waiting for SSH to become available...
==> virtualbox-iso: Connected to SSH!
==> virtualbox-iso: Uploading VirtualBox version info (5.2.16)
==> virtualbox-iso: Uploading VirtualBox guest additions ISO...
==> virtualbox-iso: Provisioning with shell script: scripts/utility_install.sh
    virtualbox-iso: Checking SELinux status ...
```
## INFO
A lot of configuration changes can be done to ks.cfg inside http directory. Just edit according to needs and there you go with the customized image. ;) 
