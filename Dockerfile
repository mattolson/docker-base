FROM debian:wheezy
MAINTAINER Matt Olson <matt@mattolson.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
RUN dpkg-divert --local --rename --add /usr/bin/ischroot &&\
    ln -sf /bin/true /usr/bin/ischroot

# Install/upgrade packages
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git-core \
    less \
    locales \
    software-properties-common \
    vim \
    wget

# Setup locale
RUN dpkg-reconfigure locales && locale-gen --purge en_US.utf8
ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_CTYPE en_US.utf8

# Cleanup
RUN apt-get clean &&\
    rm -rf /tmp/* /var/tmp/* &&\
    rm -rf /var/lib/apt/lists/*

# Use https for git
RUN git config --global url."https://".insteadOf git://

CMD ["bash"]
