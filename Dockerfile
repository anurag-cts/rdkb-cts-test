# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV TZ=US
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG DEBIAN_FRONTEND=noninteractive

# install app dependencies
RUN apt-get update && apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python2 python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint xterm bmap-tools

RUN apt-get update && apt-get install -y git cmake autoconf texinfo openjdk-8-jdk openjdk-8-jre m4 libtool libtool-bin curl pkg-config lib32z1 doxygen lz4 zstd sudo

#Create link for python
RUN ln /usr/bin/python2 /usr/bin/python

#Fix locale issue
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure locales

#Change default shell to bash
RUN rm /bin/sh && ln -s bash /bin/sh

# Add you users to sudoers to be able to install other packages in the container
#ARG USER
RUN echo "azureuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set the arguments for host_id and user_id to be able to save the build artifacts
# outside the container, on host directories, as docker volumes.
#ARG host_uid \
#host_gid
RUN groupadd -g 1000 azureuser && \
useradd -g 1000 -m -s /bin/bash -u 1000 azureuser

# Yocto builds should run as a normal user.
USER azureuser

# Create build directory
RUN mkdir /home/azureuser/build

#RDK-B repo setup
RUN echo '<<<<<<<<<< Install repo >>>>>>>>>'
RUN mkdir ~/bin
ENV PATH="/home/azureuser/bin:$PATH:/usr/bin"
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
RUN chmod a+x ~/bin/repo

#Git user configuration
RUN  git config --global user.email "docker@rdk-b.com"
RUN  git config --global user.name "Docker RDK-B"
RUN  git config --global color.ui false 


RUN mkdir -p /home/azureuser/build/RDK-B
#chmod 777 /opt/yocto/RDK-B
WORKDIR /home/azureuser/build/RDK-B
RUN echo ${PWD}

RUN echo "repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests -b rdkb-2024q1-kirkstone -m rdkb-extsrc.xml"
RUN repo init -u https://code.rdkcentral.com/r/rdkcmf/manifests -b rdkb-2024q1-kirkstone -m rdkb-extsrc.xml
RUN repo sync --no-clone-bundle --no-tags

RUN MACHINE=raspberrypi4-64-rdk-broadband source meta-cmf-raspberrypi/setup-environment
CMD ["bash"]
#CMD ["bitbake", "rdk-generic-broadband-image"]
#RUN bitbake rdk-generic-broadband-image

