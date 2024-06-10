#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

CONFLINE="MACHINE = \"qemuarm64\""
CONF_DL_DIR="DL_DIR = \"/home/pravinraghul/yocto/downloads\""
CONF_SSTATE_DIR="SSTATE_DIR = \"/home/pravinraghul/yocto/sstate-cache\""
CONF_TMPDIR="TMPDIR = \"/home/pravinraghul/yocto/tmp\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	echo ${CONF_DL_DIR} >> conf/local.conf
	echo ${CONF_SSTATE_DIR} >> conf/local.conf
	echo ${CONF_TMPDIR} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

bitbake-layers show-layers | grep "meta-aesd" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-aesd layer"
	bitbake-layers add-layer ../meta-aesd
else
	echo "meta-aesd layer already exists"
fi

set -e
bitbake core-image-aesd
