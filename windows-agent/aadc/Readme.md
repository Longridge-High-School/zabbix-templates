# AADC

This template monitors the Azure AD Connect service and reports on any errors.

## Discoveries

### AADC Discovery

#### Items

Creates the following items for each `{#CONNECTORNAME}` and `{#RUNSTEP}`.

|Item|Description|
|:---|:----------|
|AADC: {#CONNECTORNAME} - {#RUNSTEP}|The last result of the given connector run.|
|AADC: {#CONNECTORNAME} - {#RUNSTEP} Last Run|When the connector/step last ran.|

#### Triggers

Create the sollowing triggers for each `{#CONNECTORNAME}` and `{#RUNSTEP}`.

|Trigger|Level|Description|
|:------|:----|:----------|
|AADC: {#CONNECTORNAME} - {#RUNSTEP} Failed|High|Triggers when the run steps last result is not `Success`.|
|AADC: {#CONNECTORNAME} - {#RUNSTEP} Missed|High|Triggers when the run steps last run was more than 40 minutes ago.|