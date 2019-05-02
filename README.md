## Node-RED + npix rs485 nodes

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B Architecture based industrial suited Open Edge Connectivity Ecosystem

### Debian with Node-RED and rs485 nodes for netPI extension module NIOT-E-NPIX-RS485

The image provided hereunder deploys a container with installed Debian, Node-RED and rs485 nodes to communicate with netPI extension modules NIOT-E-NPIX-RS485.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with installed Internet of Things flow-based programming web-tool [Node-RED](https://nodered.org/) and two extra nodes *serial rs485 (in/out)* providing access to the RS485 serial port of the module NIOT-E-NPIX-RS485. The nodes communicate to the module across a serial connection over device `/dev/ttyS0` using the CPU's so-called "mini UART" mentioned in the [BCM2835 ARM Peripherals manual](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf). This UART has some restrictions supporting for example 8,7 Databits only or does not support partity handling and hence is not a 16650 compatible UART.

ATTENTION! Never plug or unplug any extension module if netPI is powered. Make sure a module is already inserted before applying 24VDC to netPI. 

#### License

The software includes modified third party software from the Github repository [serialport](https://github.com/node-red/node-red-nodes/tree/master/io/serialport) which is distributed in accordance with [the Apache license, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

#### Container prerequisites

##### Port mapping

To allow the access to Node-RED over a web browser the container TCP port `1880` needs to be exposed to the host.

##### Privileged mode

Only the privileged mode option lifts the enforced container limitations to allow usage of GPIOs in a container needed for the node *serial rs485(out)* to control the transmit/receive mode of the module's rs485 transceiver across GPIO 17. 

Controlling GPIO 17 is done in software causing a jitter. An oscilloscope has shown that GPIO is set to high state (transmit mode) 400usec up to 1ms before data is transmitted and falls back to low state (receive mode) 5ms to 32ms after the last bit has been shifted out of the transmit shift register. Consider that only after that time the module is able to receive data again.

##### Host device

The serial port device `/dev/ttyS0` needs to be added to the container. The device is available only if an inserted module has been recognized by netPI during boot process. Else the container will fail to start.

#### Getting started

STEP 1. Open netPI's landing page under `https://<netpi's ip address>`.

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under **Containers > Add Container**

* **Image**: `hilschernetpi/netpi-nodered-npix-rs485`

* **Port mapping**: `Host "1880" (any unused one) -> Container "1880"` 

* **Restart policy"** : `always`

* **Runtime > Devices > add device**: `Host "/dev/ttyS0" -> Container "/dev/ttyS0"`

* **Runtime > Privileged mode** : `On`

STEP 4. Press the button **Actions > Start/Deploy container**

Pulling the image may take a while (5-10mins). Sometimes it takes so long that a time out is indicated. In this case repeat the **Actions > Start/Deploy container** action.

#### Accessing

After starting the container open Node-RED in your browser with `http://<netpi's ip address>:<mapped host port>` e.g. `http://192.168.0.1:1880`. Two nodes *serial rs485 (in/out)* in the nodes *npix* library palette provides you access to the RS485 interface of the NPIX module. The nodes' info tab in Node-RED explains how to use them.

#### Automated build

The project complies with the scripting based [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build the image output file. Using this method is a precondition for an [automated](https://docs.docker.com/docker-hub/builds/) web based build process on DockerHub platform.

DockerHub web platform is x86 CPU based, but an ARM CPU coded output file is needed for Raspberry systems. This is why the Dockerfile includes the [balena](https://balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) steps.

#### License

View the license information for the software in the project. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
