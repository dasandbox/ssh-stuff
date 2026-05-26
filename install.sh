#!/bin/bash

sudo dnf localinstall *.rpm --disablerepo='*' --nogpgcheck

# Add sysadmin user if not exists
if ! grep -q ":1=sysadmin" /etc/tigervnc/vncserver.users ; then
  echo ":1=sysadmin" | sudo tee -a /etc/tigervnc/vncserver.users
fi

# Un-comment the VNC options we care about
sudo sh -c "sed -i 's/^# securitytypes=.*/securitytypes=none/'  /etc/tigervnc/vncserver-config-mandatory"
sudo sh -c "sed -i 's/^# geometry=.*/geometry=1920x1080/'  /etc/tigervnc/vncserver-config-mandatory"
sudo sh -c "sed -i 's/^# alwaysshared/alwaysshared/'  /etc/tigervnc/vncserver-config-mandatory"

# Add VNC options we care about
if ! grep -q "blacklistthreshold=0" /etc/tigervnc/vncserver-config-mandatory ; then
  echo "blacklistthreshold=0" | sudo tee -a /etc/tigervnc/vncserver-config-mandatory
fi
if ! grep -q "blacklisttimeout=0" /etc/tigervnc/vncserver-config-mandatory ; then
  echo "blacklisttimeout=0" | sudo tee -a /etc/tigervnc/vncserver-config-mandatory
fi

# Firewall
sudo systemctl disable firewalld
sudo systemctl enable  vncserver@:1
# SELinux
sudo sh -c "sed -i 's/^SELINUX=.*/SELINUX=disabled/'  /etc/selinux/config"

echo "check: sudo rm -rf /tmp/.X ..."
echo "Reboot!"
