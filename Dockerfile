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
RUN sed -i "s/^# en_US/en_US/" /etc/locale.gen &&\
    locale-gen &&\
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# Cleanup
RUN apt-get clean &&\
    rm -rf /tmp/* /var/tmp/* &&\
    rm -rf /var/lib/apt/lists/*

# Use https for git
RUN git config --global url."https://".insteadOf git://

# Install gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" &&\
	  curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" &&\
	  gpg --verify /usr/local/bin/gosu.asc &&\
	  rm /usr/local/bin/gosu.asc &&\
	  chmod +x /usr/local/bin/gosu

CMD ["bash"]
