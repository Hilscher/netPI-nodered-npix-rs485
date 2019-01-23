#use armv7hf compatible OS
FROM balenalib/armv7hf-debian:stretch

#enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry) 
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="netpi@hilscher.com" \ 
      version="V0.9.4" \
      description="Node-RED with rs485 nodes to communicate to NIOT-E-NPIX-RS485 extension module"

#version
ENV HILSCHERNETPI_NODERED_NPIX_RS485_VERSION 0.9.4

#copy files
COPY "./init.d/*" /etc/init.d/ 
COPY "./node-red-contrib-npix-rs485/*" "./node-red-contrib-npix-rs485/locales/en-US/*" /tmp/

#do installation
RUN apt-get update  \
    && apt-get install curl build-essential python-dev \
#install node.js
    && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -  \
    && apt-get install -y nodejs  \
#install Node-RED
    && npm install -g --unsafe-perm node-red \
#install node
    && mkdir /usr/lib/node_modules/node-red-contrib-npix-rs485 /usr/lib/node_modules/node-red-contrib-npix-rs485/locales/ /usr/lib/node_modules/node-red-contrib-npix-rs485/locales/en-US \
    && mv /tmp/25-serial.js /tmp/25-serial.html /tmp/package.json -t /usr/lib/node_modules/node-red-contrib-npix-rs485 \
    && mv /tmp/25-serial.json /usr/lib/node_modules/node-red-contrib-npix-rs485/locales/en-US \
    && cd /usr/lib/node_modules/node-red-contrib-npix-rs485 \
    && npm install --unsafe-perm \
#clean up
    && rm -rf /tmp/* \
    && apt-get remove curl \
    && apt-get -yqq autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#Node-RED Port
EXPOSE 1880

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]
