# HP UPS

## Macros

|Macro|Description|Default|
|:----|:----------|:------|
|{$BATTERY.MIN_RUNTIME}|How long should a UPS be able to run for, warns if below.|`900` (15 Minutes).|

## Items

|Item|Description|
|:---|:----------|
|Battery Capacity|The current battery capacity in %.|
|Battery Time Remaining|The estimated time in seconds the battery will run for.|
|ICMP loss|The packet loss in % for pings to the UPS.|
|ICMP Ping|0/1 is the ups pingable.|
|ICMP response time|The response time in seconds.|
|Input Frequency|The Input Power frequenct in Hertz.|
|Input Phase Count|The number of input power phases connected.|
|Output Source|The current output source, e.g. supply, battery etc...|
|SNMP agent availability|0/1 is the SNMP service available.|
|Target Input Voltage|The target voltage for the input.|
|Target Output Voltage|The target voltage for the output.|

## Triggers

|Trigger|Level|Description|
|:------|:----|:----------|
|Battery run time low|Average|Triggers if the run time drops below `{$BATTERY.MIN_RUNTIME}`.|
|Output Source non-normal|High|Triggers if the UPS is running on a supply other than mains power.|

## Discoveries

### Input Discovery

This finds all the available input phases on the UPS.

#### Items

|Item|Description|
|:---|:----------|
|Input (Phase {#INPUTPHASE}): Current|The current input current in Amps.|
|Input (Phase {#INPUTPHASE}): Voltage|The current input voltage in Volts.|

### Output Discovery

This finds all the output phases on the UPS.

#### Items

|Item|Description|
|:---|:----------|
|Output (Phase {#OUTPUTPHASE}): Current|The current output current in Amps.|
|Output (Phase {#OUTPUTPHASE}): Power|The current output power in Watts.|
|Output (Phase {#OUTPUTPHASE}): Voltage|The current output voltage in Volts.|
