#!/bin/bash
yum update -y
yum install -y wget curl htop

#Volume mounts
mkdir /app
/sbin/mkfs.ext4 /dev/xvdb
/sbin/mkfs.ext4 /dev/xvdc
mount /dev/xvdb /app
echo "/dev/xvdb  /app ext4 defaults,nofail 0 2" >> /etc/fstab
mkdir /app/log
mount /dev/xvdc /app/log
echo "/dev/xvdc  /app/log ext4 defaults,nofail 0 2" >> /etc/fstab
resize2fs /dev/xvdb
resize2fs /dev/xvdc

#Setting hostname
HOSTNAME=${host_name}
if [ -n "$HOSTNAME" ]
then
    hostname $HOSTNAME
    unalias cp
    cp -f /etc/sysconfig/network /etc/sysconfig/network.bak
    sed -ie 's/^\(HOSTNAME\)=.*$/\1='$HOSTNAME'/' /etc/sysconfig/network
else
  echo "No hostname passed."
fi
