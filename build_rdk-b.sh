#!/bin/bash

MANIFEST=${1}
BRANCH=${2}
MACHINE=${3}
SOURCE=${4}

echo "MANIFEST: $MANIFEST"
echo "BRANCH: $BRANCH"
echo "MACHINE: $MACHINE"
echo "SOURCE: $SOURCE"

mkdir -p ${HOME}/build/RDK-B
#chmod 777 /opt/yocto/RDK-B
cd ${HOME}/build/RDK-B
echo ${PWD}

echo "repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests -b ${BRANCH} -m ${MANIFEST}"
repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests -b $BRANCH -m $MANIFEST
repo sync --no-clone-bundle --no-tags

MACHINE=$MACHINE source $SOURCE

bitbake rdk-generic-broadband-image

