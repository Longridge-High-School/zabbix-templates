# Sophos Central

This template pulls data from the Sophos Central API to provide counts of endpoints and the last checkin + overall health of the endpoint.

## Macros

|Macro|Description|Default|
|:----|:----------|:------|
|{$ENDPOINT.LAST_SEEN_TRIGGER}|How long can an endpoint be out of contact before a warning is generated.|`14d`|
|{$NO_DATA_WARNING}|How long after data comes in should a warning be generated. Ideally this needs to be your schedule interval + 5 minutes.|`35m`|

## Items

|Item|Description|
|:---|:----------|
|Computer Endpoints|A count of all the computer endpoints in Sophos Central.|
|Computer Endpoints with protection issues|A count of the computer endpoints that have protection issues in Sophos Central.|
|Server Endpoints|A count of all the Server endpoints in Sophos Central.|
|Server Endpoints with protection issues|A count of the Server endpoints that have protection issues in Sophos Central.|

## Triggers

|Trigger|Level|Description|
|:------|:----|:----------|
|No data from Sophos Central|Information|Triggers when the number of computer endpoints has not been updated during the `{$NO_DATA_WARNING}` interval.|

## Discoveries

### Alerts Discovery

Find all active alerts in Sophos Central

#### Items

|Item|Description|
|:---|:----------|
|Alert {#ALERTTITLE}: Agent|The agent (hostname) that the alert effects.|

#### Triggers

|Trigger|Level|Description|
|:------|:----|:----------|
|Sophos Central {#ALERTTITLE}|Information|Triggers if the alert exists.|

### Endpoint Discovery

Find all computer and server endpoints in Sophos Central.

#### Items

|Item|Description|
|:---|:----------|
|Endpoint {#ENDPOINTNAME}: Last Seen|How long ago did the endpoint last checkin with Sophos.|
|Endpoint {#ENDPOINTNAME}: Overall Health|What does Sophos report the overall health of the endpoint as.|

#### Triggers

|Trigger|Level|Description|
|:------|:----|:----------|
|Endpoint {#ENDPOINTNAME}: Overall Health not good|Warning|Triggers if the overall health of the endpoint is not `good`.|
|Endpoint {#ENDPOINTNAME}: Overdue Check-in|Information|Triggers if the endpoint has not been seen by Sophos in more than `{$ENDPOINT.LAST_SEEN_TRIGGER}`.|