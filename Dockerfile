# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV TZ=US
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get install -y qemu-system fdisk wget mtools xz-utils sudo slirp openssh-server net-tools bzip2 python3-pytest python3-selenium

#Fix locale issue
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure locales

#Change default shell to bash
RUN rm /bin/sh && ln -s bash /bin/sh

# Add you users to sudoers to be able to install other packages in the container
ARG USER
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set the arguments for host_id and user_id to be able to save the build artifacts
# outside the container, on host directories, as docker volumes.
ARG host_uid \
host_gid
RUN groupadd -g $host_gid nxp && \
useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER

# Set ssh service to start automatically
RUN systemctl enable ssh

# Create directory for qemu compilation
#RUN mkdir -p /opt/qemu
#RUN chown -R $USER:$USER /opt/qemu

# Yocto builds should run as a normal user.
USER $USER

# Create build directory
RUN mkdir /home/${USER}/build
