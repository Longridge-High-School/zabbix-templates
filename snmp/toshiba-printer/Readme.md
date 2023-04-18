# Toshiba Printer (SNMP)

This template gathers data from the Toshiba Printers over SNMP.

## Items

| Item                    | Description                                         |
| :---------------------- | :-------------------------------------------------- |
| Device Name             | The device name from SNMP.                          |
| Device Model            | The devices model.                                  |
| ICMP Loss               | The packet loss on the last ping as a percentage.   |
| ICMP Ping               | Is the device responding to pings.                  |
| ICMP response time      | What is the response time in seconds of the device. |
| SNMP agent availability | Is the host the available over SNMP.                |

## Triggers

| Trigger                      | Level   | Description                                                                            |
| :--------------------------- | :------ | :------------------------------------------------------------------------------------- |
| High ICMP ping loss          | Warning | Triggers when the ICMP ping packet loss is greater than `{$ICMP.LOSS_WARN}`            |
| High ICMP ping response time | Warning | Triggers when the ICMP ping response time is greater than `{$ICMP.RESPONSE_TIME_WARN}` |
| No SNMP data collection      | Warning | Triggers when the host has been unavilable over SNMP for the time in `{$SNMP.TIMEOUT}` |
| Unavailable by ICMP ping     | High    | Triggers when the host has not responded to the last 3 pings.                          |

## Macros

| Macro                      | Description                                      | Default                              |
| :------------------------- | :----------------------------------------------- | :----------------------------------- | ------------------------ | ------------------- |
| {$CONSUMABLE.DO_NOT_MATCH} | Which consumables to ignore                      | `^Waste Toner$`                      |
| {$CONSUMABLE.ERROR_LEVEL}  | What percentage is the consumable considered low | `2`                                  |
| {$ERRORS.DO_NOT_MATCH}     | Which errors to ignore                           | `^(The Time for Periodic Maintenance | .\*? Toner Cartridge Low | .\*? Toner Empty)$` |
| {$ICMP.LOSS_WARN}          | When should packet loss trigger a warning        | `20`                                 |
| {$ICMP.RESPONSE_TIME_WARN} | When should the response time trigger a warning  | `0.15`                               |
| {$SNMP.TIMEOUT}            | How long should SNMP be off before warning       | `5m`                                 |

## Discoveries

### Consumables

Finds all consumables except for any that match `{$CONSUMABLE.DO_NOT_MATCH}`.

> We chose to use a discovery instead of manual items to automatically support mono printers etc...

#### Items

The following items are created for each consumable where `{#CONSUMABLENAME}` is the name of the conumable

| Item                                | Description                               |
| :---------------------------------- | :---------------------------------------- |
| Consumable {#CONSUMABLENAME}: Level | The current level of the consumable in %. |

#### Triggers

The following triggers are created for each consumable:

| Trigger                                 | Level   | Description                                                                                                                                                                                     |
| :-------------------------------------- | :------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Consumable {#CONSUMABLENAME}: Level low | Warning | Triggers then the `Consumable {#CONSUMABLENAME}: Level` drops below `{$CONSUMABLE.ERROR_LEVEL}`. Automatically resolves when the consumable level goes above `{$CONSUMABLE.ERROR_LEVEL}` again. |
| Consumable {#CONSUMABLENAME}: Empty     | Average | Triggers when `Consumable {#CONSUMABLENAME}: Level` reaches `0`. Clears the level low problem.                                                                                                  |

### Errors

Finds all errors except any that match `{$ERRORS.DO_NOT_MATCH}`. Not the cleanest solution as its creating and removing each item for each error but its the only way we could find to get it working. As a result of this there is no history as items get deleted immediatley after they are nolonger discovered.

#### Items

The following items are created for each error where `{#ERRORMESSAGE}` is the current error message.

| Item                  | Description               |
| :-------------------- | :------------------------ |
| Error {#ERRORMESSAGE} | The current error message |

#### Triggers

The following triggers are created for each error:

| Trigger               | Level       | Description                                                                             |
| :-------------------- | :---------- | :-------------------------------------------------------------------------------------- |
| Error {#ERRORMESSAGE} | Information | Gets triggered if the item exists. Cleared when the item is removed (fixed on printer). |
