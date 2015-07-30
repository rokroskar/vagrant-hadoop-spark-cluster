#!/bin/bash

# building and setting up the SOCKS server
# http://www.linuxexpert.ro/Linux-Tutorials/setup-ss5-socks-proxy.html

yum install rpm-build.x86_64 openldap-devel.x86_64 pam-devel.x86_64 openssl-devel.x86_64 libgssapi-devel.x86_64 -y

wget ftp://rpmfind.net/linux/sourceforge/s/ss/ss5/ss5/3.8.9-8/ss5-3.8.9-8.src.rpm

sudo rpmbuild --rebuild ss5-3.8.9-8.src.rpm

rpm -ivh /root/rpmbuild/RPMS/x86_64/ss5-3.8.9-8.x86_64.rpm

