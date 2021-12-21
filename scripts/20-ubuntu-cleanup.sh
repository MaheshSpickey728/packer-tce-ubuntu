#!/bin/bash -eu

#--------------------------------------------------------------------------------------
# Ubuntu OS - Cleanup [ 20-ubuntu-cleanup.sh ]
# juliusn - Sun Dec  5 08:48:39 EST 2021 - first version
#--------------------------------------------------------------------------------------

echo "#--------------------------------------------------------------"
echo "# Starting 20-ubuntu-cleanup.sh"
echo "#--------------------------------------------------------------"

echo "Cleaning up tmp"
rm -rf /tmp/*

# Cleanup apt cache
# apt-get clean: Clears the package files left in /var/cache.
# apt-get autoclean: Clears the obsolete package files, which can not be redownloaded and are virtually redundant.
# apt-get autoremove: Removes interdependencies of uninstalled packages.

apt-get -y clean
apt-get -y autoclean
apt-get -y autoremove --purge

# Disable the firewall
/usr/sbin/ufw disable
/usr/sbin/ufw status verbose

echo "Done 20-ubuntu-cleanup.sh"