# Nilan client iOS app

Nilan client app displays readings of Nilan heatpump and can control basic
settings such as room temperature, ventilation mode or pause.

App requires
[Nilan REST API](https://github.com/pjuzeliunas/nilan-rest-api)
server to be running in the same network as iOS
device. Currently only heatpumps that expose CTS700 Modbus over TCP are
supported.

### Hardware setup

Nilan heatpump must be connected to a host running Nilan REST API server. It
could, for example, be Raspbery Pi that runs server on Docker.

For more detailed guide, please refer to
[Nilan REST API](https://github.com/pjuzeliunas/nilan-rest-api)
project.


## Disclaimer

This initial version of Nilan client app is developed by home automation enthusiast (outside Nilan company) and is based on existing open protocols.

Nilan is a registered trademark and belongs to [Nilan A/S](https://www.nilan.dk/Default.aspx).