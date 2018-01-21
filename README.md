# asterisk-autoinstall
This is an Asterisk Automatic Install Script based on Shell scripting and CentOS 7 as S.O

## Pre-req:

* CentOS 7 full updated and upgraded:

```bash
apt-get update -y
apt-get upgrade -y
```
* SELINUX and FIREWALLD disabled at all

```bash
vim /etc/selinux/config

SELINUX=disabled  -- CAMBIAR A DISABLED
SELINUXTYPE=targeted
```
```bash
systemctl stop firewalld.service
systemctl disable firewalld.service
```

## Use method:

Clone the complete repository and execute the install script (.sh)

```bash
git clone git@github.com:linuxshark/Asterisk-CentOS7-Install.git
```
