# TemPager 3E

## Macros

| Macro                      | Description                                       | Default |
| :------------------------- | :------------------------------------------------ | :------ |
| {$ICMP.LOSS_WARN}          | What percentage of packet loss should trigger.    | `20`    |
| {$ICMP.RESPONSE_TIME_WARN} | When to warn on ping response times               | `0.15`  |
| {$SNMP.TIMEOUT}            | How long can SNMP be unavailble before triggering | `5m`    |
| {$TEMP.CRITICAL}           | The critical warning tempature in centigrade      | `40`    |
| {$TEMP.WARN}               | The warning temperature in centigrade             | `30`    |

## Items

| Item                    | Description                                         |
| :---------------------- | :-------------------------------------------------- |
| ICMP Loss               | The packet loss on the last ping as a percentage.   |
| ICMP Ping               | Is the device responding to pings.                  |
| ICMP response time      | What is the response time in seconds of the device. |
| SNMP agent availability | Is the host the available over SNMP.                |
| Model                   | The model reported by SNMP.                         |
| Sensor 1 Name           | The name given to Sensor 1.                         |
| Sensor 1 Temperature    | The current temperature of Sensor 1 in centigrade.  |
| Sensor 2 Name           | The name given to Sensor 2.                         |
| Sensor 2 Temperature    | The current temperature of Sensor 2 in centigrade.  |

## Triggers

| Trigger                      | Level    | Description                                                                            |
| :--------------------------- | :------- | :------------------------------------------------------------------------------------- |
| High ICMP ping loss          | Warning  | Triggers when the ICMP ping packet loss is greater than `{$ICMP.LOSS_WARN}`            |
| High ICMP ping response time | Warning  | Triggers when the ICMP ping response time is greater than `{$ICMP.RESPONSE_TIME_WARN}` |
| No SNMP data collection      | Warning  | Triggers when the host has been unavilable over SNMP for the time in `{$SNMP.TIMEOUT}` |
| Unavailable by ICMP ping     | High     | Triggers when the host has not responded to the last 3 pings.                          |
| High Temperature             | High     | Triggers when either sensors temperature is above `{$TEMP.WARN}`                       |
| Critical Temperature         | Disaster | Triggers when either sensors temerature is above `{$TEMP.CRITICAL}`                    |
