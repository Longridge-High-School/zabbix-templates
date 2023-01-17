# VEEAM

This template pulls VEEAM backup jobs and reports on their status, size and last run time.

## EXTRA INSTALLATION STEPS

Due to the time it takes to request data out of VEEAM we had to setup a scheduled task to run `veeam-data-builder.ps1` every 15 minutes.

## Items

|Item|Description|
|:---|:----------|
|VEEAM Data Creation|This collects the date that the VEEAM data JSON file was created so that you can be warned if your scheduled task stops reporting data.|


## Triggers

|Trigger|Description|
|:------|:---------|
|VEEAM Data is Old|Alerts when the VEEAM data is more than an hour old.|

## Macros

|Macro|Description|Default|
|:----|:----------|:------|
|{$VEEAM.BACKUP_AGE_TRIGGER}|How many seconds after a backup last runs should it be considered missed?|`90000` (25 hours)|

## Discoveries

### Backup Jobs

Finds all backup jobs in VEEAM, except for Tapes.

#### Items

Creates the following items for all backup jobs where `{#JOBNAME}` is the name reported by VEEAM.

|Item|Description|
|:---|:----------|
|Backup {#JOBNAME} Last Result|The last result of the job.|
|Backup {#JOBNAME} Last Run|The Timestamp of the last run completion time.|
|Backup {#JOBNAME} Size|The estimated size in bytes of the backup job.|

#### Triggers

|Trigger|Description|
|:------|:----------|
|Backup {#JOBNAME} Failed|Triggers when the last value of `Backup {#JOBNAME} Last Result` is not `Success`.|
|Backup {#JOBNAME} Missed Last Run|Triggers when the `Backup {#JOBNAME} Last Run` passes `{$VEEAM.BACKUP_AGE_TRIGGER}`.|
