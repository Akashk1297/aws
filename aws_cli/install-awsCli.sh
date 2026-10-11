#!/bin/bash

#arch=`uname -m`
arch=`lscpu | grep -i Architecture | cut -d':' -f2- | tr -d '[:blank:]'`

if [ $arch ~= 'x86_64' ];then
    #x86_64 arch
    # 1. Download the installer bundle
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    # 2. Extract the package (install unzip via apt/yum if missing)
    unzip awscliv2.zip

    # 3. Run the installer script
    sudo ./aws/install
else
    print 'Arch Not supported'
fi

aws --version
if  [ `echo $?` -eq 0 ];then
    print 'Aws cli installed'
else
    print 'Aws cli not installed'
fi
