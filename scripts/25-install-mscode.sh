#!/bin/sh

#--------------------------------------------------------------------------------------
# Ubuntu OS - Install MS code [ 25-install-mscode.sh ]
# juliusn - Sun Dec  5 08:48:39 EST 2021 - first version
#--------------------------------------------------------------------------------------

echo "#--------------------------------------------------------------"
echo "# Starting 25-install-mscode.sh" 
echo "#--------------------------------------------------------------"

apt-get install -y software-properties-common apt-transport-https

# import the Microsoft GPG key 
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- |  apt-key add -

#  enable the Visual Studio Code repository
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

apt-get update
apt-get install -y code

echo "Done 25-install-mscode.sh"