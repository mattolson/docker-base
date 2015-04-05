FROM ubuntu:14.04
MAINTAINER Matt Olson <matt@mattolson.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
RUN dpkg-divert --local --rename --add /usr/bin/ischroot && ln -sf /bin/true /usr/bin/ischroot

# Install/upgrade packages
RUN LC_ALL=C apt-get update &&\
    apt-get install -y --no-install-recommends \
    vim git-core curl wget less build-essential apt-transport-https ca-certificates \
    software-properties-common language-pack-en &&\
    apt-get dist-upgrade -y --no-install-recommends

# Set locale
RUN locale-gen en_US &&\
    update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# Use https for git
RUN echo '[url "https://"]' >> /root/.gitconfig && echo '  insteadOf =git://' >> /root/.gitconfig

# Cleanup
RUN apt-get clean &&\
    rm -rf /tmp/* /var/tmp/* &&\
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
