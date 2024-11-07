#!/bin/bash

UBUNTU_VERSION=$(lsb_release -c | awk '{print $2}')

echo "Downloading Microsoft Edge-----------------------------------------------------------------------------------------------------"
wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_130.0.2849.68-1_amd64.deb

echo "Installing Microsoft Edge-----------------------------------------------------------------------------------------------------"
sudo dpkg -i microsoft-edge-stable_130.0.2849.68-1_amd64.deb

echo "Installing prerequisites (curl, gpg)-----------------------------------------------------------------------------------------------------"
sudo apt update
sudo apt install -y curl gpg

echo "Downloading Microsoft GPG key-----------------------------------------------------------------------------------------------------"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o microsoft.gpg

echo "Installing Microsoft GPG key-----------------------------------------------------------------------------------------------------"
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/

echo "Adding Microsoft repository for Ubuntu ${UBUNTU_VERSION}   -----------------------------------------------------------------------------------------------------"

if [ "$UBUNTU_VERSION" == "jammy" ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" | sudo tee /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list
elif [ "$UBUNTU_VERSION" == "focal" ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | sudo tee /etc/apt/sources.list.d/microsoft-ubuntu-focal-prod.list
else
    echo "Unsupported Ubuntu version: $UBUNTU_VERSION"
    exit 1
fi

echo "Updating APT package index -----------------------------------------------------------------------------------------------------"
sudo apt update

echo "Installing Intune Portal -----------------------------------------------------------------------------------------------------"
sudo apt install -y intune-portal
