FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

# Install required packages for building Tinker Board (S) Debian
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc gcc-arm-linux-gnueabi device-tree-compiler bc \
    python libssl-dev sudo udev psmisc kmod qemu-user-static parted dosfstools

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo $username >/root/username

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

ENTRYPOINT chroot --skip-chdir --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i