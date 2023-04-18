# UniFi Controller

These templates gather data from UniFi Controller using the HTTP API.

These scripts can be on any server on the network, doesn't have to be the one running unifi controller.

> After copying the script you need to set the username, password and base url.

## Discoveries

### Sites

Each site in UniFi Controller is discovered here.

#### Items

The following items are created for each site where `{#SITENAME}` is the site.

| Item                                    | Description                                  |
| :-------------------------------------- | :------------------------------------------- |
| Unifi Site {#SITENAME}: Wireless Guests | The current number of guests on the network. |
| Unifi Site {#SITENAME}: Wireless Users  | The current number of users on the network.  |

### Devices

Each device is discovered for every site.

#### Items

The following items are created for each device where `{#DEVICENAME}` is the devices name.

| Item                                   | Description                                   |
| :------------------------------------- | :-------------------------------------------- |
| Unifi Device {#DEVICENAME}: Model      | The device model.                             |
| Unifi Device {#DEVICENAME}: Status     | The current status of the device.             |
| Unifi Device {#DEVICENAME}: Upgradable | Is there an upgrade available for the device. |
| Unifi Device {#DEVICENAME}: Uptime     | Device's uptime in seconds.                   |

#### Triggers

The following triggers are created for each device.

| Trigger                                 | Level       | Description                                                                   |
| :-------------------------------------- | :---------- | :---------------------------------------------------------------------------- |
| Unifi Device {#DEVICENAME} Disconnected | Warning     | Triggers if the device has a current status of `0` (Disconnected).            |
| Unifi Device {#DEVICENAME} has upgrade  | Information | Triggers if the device has an upgrade to install.                             |
| Unifi Device {#DEVICENAME} Low Uptime   | Information | Triggers if the device has under 1 hours uptime. Useful to spot PoE problems. |
