# Toshiba Printer (SNMP)

This template gathers data from the Toshiba Printers over SNMP.

## Items

|Item|Description|
|:---|:----------|
|Device Name|The device name from SNMP.|
|Device Model|The devices model.|

## Macros

|Macro|Description|Default|
|:----|:----------|:------|
|{$CONSUMABLE.DO_NOT_MATCH}|Which consumables to ignore|`^Waste Toner$`|
|{$CONSUMABLE.ERROR_LEVEL}|What percentage is the consumable considered low|`2`|
|{$ERRORS.DO_NOT_MATCH}|Which errors to ignore|`^(The Time for Periodic Maintenance|.*? Toner Cartridge Low|.*? Toner Empty)$`|

## Discoveries

### Consumables

Finds all consumables except for any that match `{$CONSUMABLE.DO_NOT_MATCH}`. 

> We chose to use a discovery instead of manual items to automatically support mono printers etc...

#### Items

The following items are created for each consumable where `{#CONSUMABLENAME}` is the name of the conumable

|Item|Description|
|:---|:----------|
|Consumable {#CONSUMABLENAME}: Level|The current level of the consumable in %.|

#### Triggers

The following triggers are created for each consumable:

|Trigger|Level|Description|
|:------|:----|:----------|
|Consumable {#CONSUMABLENAME}: Level low|Warning|Triggers then the `Consumable {#CONSUMABLENAME}: Level` drops below `{$CONSUMABLE.ERROR_LEVEL}`. Automatically resolves when the consumable level goes above `{$CONSUMABLE.ERROR_LEVEL}` again.|

### Errors

Finds all errors except any that match `{$ERRORS.DO_NOT_MATCH}`. Not the cleanest solution as its creating and removing each item for each error but its the only way we could find to get it working. As a result of this there is no history as items get deleted immediatley after they are nolonger discovered.

#### Items

The following items are created for each error where `{#ERRORMESSAGE}` is the current error message.

|Item|Description|
|:---|:----------|
|Error {#ERRORMESSAGE}|The current error message|

#### Triggers

The following triggers are created for each error:

|Trigger|Level|Description|
|:------|:----|:----------|
|Error {#ERRORMESSAGE}|Information|Gets triggered if the item exists. Cleared when the item is removed (fixed on printer).|
