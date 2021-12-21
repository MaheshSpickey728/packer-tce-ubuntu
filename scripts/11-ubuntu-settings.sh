#!/bin/bash -eu

#--------------------------------------------------------------------------------------
# Ubuntu OS - First set of OS customization [ 11-ubuntu-settings.sh ]
# juliusn - Sun Dec  5 08:48:39 EST 2021 - first version
#--------------------------------------------------------------------------------------

echo "#--------------------------------------------------------------"
echo "# Starting 11-ubuntu-settings.sh"
echo "#--------------------------------------------------------------"

# Ensure config file exists
echo "Ensuring vm-tools config exists."
sudo touch /etc/vmware-tools/tools.conf

# Tell open vm tools to ignore other NICs
echo "Ignoring other NICS vm-tools."
grep -qFs 'exclude-nics=' /etc/vmware-tools/tools.conf || sudo tee -a /etc/vmware-tools/tools.conf <<EOF
# Disable additional nics from reporting IP
[guestinfo]
exclude-nics=docker*,veth*,br*
EOF

# Fix issue with ubuntu deploying guest customizations
echo "Fixing guest customization issues."
sed -e 's@.*D /tmp 1777 root root -.*@#D /tmp 1777 root root -.@' /usr/lib/tmpfiles.d/tmp.conf | sudo tee /usr/lib/tmpfiles.d/tmp.conf
sed '/\[Unit\]/a\After=dbus.service' /lib/systemd/system/open-vm-tools.service  | sudo tee /lib/systemd/system/open-vm-tools.service

# Prevents popup questions
export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

apt-get install -y logrotate gnupg rng-tools zip unzip jq nmon make autoconf nmap p11-kit

# setup profile
cat << 'PROFILE' > ${HOME}/.bash_profile
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                     # append to history, don't overwrite it
PROFILE

# Disable SSH timeout
cat >> /etc/ssh/sshd_config << "EOF"
#
# Disabling SSH Timeout 
#
ClientAliveInterval 600
TCPKeepAlive yes
ClientAliveCountMax 10
EOF

## Issue #1 - Kind Known Issue - IPv6 Port Forwarding
## Docker assumes that all the IPv6 addresses should be reachable, hence doesn't implement port mapping using NAT

## Issue #2 - Pre-req check, ensure bootstrap machine has ipv4 forwarding enabled
## https://github.com/vmware-tanzu/tanzu-framework/issues/854

# Enable IP forwarding, keep IPV6 and increase connection tracking table size 
cat >> /etc/sysctl.conf << "EOF"
#
net.ipv4.ip_forward=1
net.ipv4.conf.all.forwarding=1 
net.ipv6.conf.default.forwarding=1
net.ipv6.conf.all.disable_ipv6=0
net.ipv6.conf.default.disable_ipv6=0
# net.netfilter.nf_conntrack_max=524288
EOF

# Docker/Tanzu requirement - Forward IPv4 or IPv6 source-routed packets
for SETTING in $(/sbin/sysctl -aN --pattern "net.ipv[4|6].conf.(all|default|eth.*).accept_source_route")
do 
    sed -i -e "/^${SETTING}/d" /etc/sysctl.conf
    echo "${SETTING}=1" >> /etc/sysctl.conf
done 

sysctl -p

# OS Specific Settings where ordering does not matter
set -euo pipefail

chmod 755 /root/scripts /root/scripts/*

echo "Done 11-ubuntu-settings.sh"

