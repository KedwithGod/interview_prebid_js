#!/bin/bash

# Update package list
sudo apt-get update

# Install required packages
sudo apt-get install -y linux-tools-generic libbz2-dev python-dev scons \
                        libtool liblzma-dev libblas-dev make automake \
                        ccache ant libcppunit-dev doxygen \
                        libcrypto++-dev libACE-dev gfortran liblapack-dev \
                        libevent-dev libssh2-1-dev libicu-dev libv8-dev \
                        g++ google-perftools libgoogle-perftools-dev \
                        zlib1g-dev git pkg-config valgrind autoconf \
                        libcurl4-openssl-dev cmake libsigc++-2.0-dev

# Install JDK 8
sudo apt-get install -y openjdk-8-jdk

# Set up user environment variables
cat <<EOL >> ~/.profile
# Add local directory for libraries, etc
mkdir -p \$HOME/local/bin
PATH="\$HOME/local/bin:\$PATH"

mkdir -p \$HOME/local/lib
export LD_LIBRARY_PATH="\$HOME/local/lib:\$LD_LIBRARY_PATH"

export PKG_CONFIG_PATH="\$HOME/local/lib/pkgconfig/:\$HOME/local/lib/pkgconfig/"
EOL

# Apply changes to the current shell
source ~/.profile

# Verify environment setup
echo "Verifying environment setup..."
env | grep PATH

# Clone the RTBkit dependencies
git clone https://github.com/rtbkit/rtbkit-deps.git
cd rtbkit-deps
git submodule update --init

# Build RTBkit dependencies (for Ubuntu 14 - disable Node.js)
make all NODEJS_ENABLED=0

# Clone the RTBkit repository and build
cd ..
git clone https://github.com/rtbkit/rtbkit.git
cd rtbkit
cp jml-build/sample.local.mk local.mk

# Build and test RTBkit
make dependencies NODEJS_ENABLED=0
make compile NODEJS_ENABLED=0
make test NODEJS_ENABLED=0

echo "RTBkit setup and compilation completed successfully!"