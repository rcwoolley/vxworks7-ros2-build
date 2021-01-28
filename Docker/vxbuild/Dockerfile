FROM ubuntu:20.04

RUN dpkg --add-architecture i386 && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  g++-multilib libncurses5:i386 libc6:i386 libgcc1:i386 \
  unzip bc git wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libstdc++5:i386 libstdc++6:i386 libxtst6 libgtk2.0-0:i386 libxtst6:i386 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV GID 1000
ENV GROUP wruser
ENV UID 1000
ENV USER wruser
ENV HOME /home/${USER}
ENV WRENV vxworks-7

COPY ./docker-entrypoint.sh /

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections \
&& DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

WORKDIR /work

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
