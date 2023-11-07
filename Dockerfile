FROM ubuntu:22.04
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
    gnupg \
    iputils-ping \
    less \
    locales \
    vim \
    wget

# Setup locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Cleanup
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*

# Use https for git
RUN git config --global url."https://".insteadOf git://

# Install gosu for easy step-down from root
RUN gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -fsSL "https://github.com/tianon/gosu/releases/download/1.17/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }')" &&\
	  curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.17/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }').asc" &&\
	  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu &&\
	  rm /usr/local/bin/gosu.asc &&\
	  chmod +x /usr/local/bin/gosu

ENTRYPOINT ["bash"]
