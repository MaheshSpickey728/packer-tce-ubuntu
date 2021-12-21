#!/bin/bash -eu

#--------------------------------------------------------------------------------------
# Ubuntu OS - Configure NTP client [ 21-install-ntp-client.sh ]
# juliusn - Sun Dec  5 08:48:39 EST 2021 - first version
#--------------------------------------------------------------------------------------

echo "#--------------------------------------------------------------"
echo "# Starting 21-install-ntp-client.sh" 
echo "#--------------------------------------------------------------"

timedatectl set-ntp no
apt-get update
apt-get install -y ntp

# Set timezone
timedatectl set-timezone Europe/London
timedatectl set-ntp true

#------------------------------------
# Update /etc/ntp.conf
#------------------------------------
cp /etc/ntp.conf /etc/ntp.conf.org

cat << EOF > /etc/ntp.conf
driftfile /var/lib/ntp/ntp.drift

# Permit time synchronization with our time source, but do not
# permit the source to query or modify the service on this system.
restrict default nomodify notrap nopeer noquery

# Permit all access over the loopback interface.  This could
# be tightened as well, but to do so would effect some of
# the administrative functions.
restrict 127.0.0.1 
restrict ::1

pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst

EOF

systemctl enable ntp
systemctl start ntp

update-rc.d ntp defaults
update-rc.d ntp enable

echo "Done 21-install-ntp-client.sh"


