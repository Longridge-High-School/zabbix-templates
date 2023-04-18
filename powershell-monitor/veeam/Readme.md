# VEEAM

This template pulls VEEAM backup jobs and reports on their status, size and last run time.

## EXTRA INSTALLATION STEPS

1.  Set the variables in `veeam.ps1`
1.  Setup a scheduled task to run `veeam.ps1` every 15 minutes.

## Macros

<!-- prettier-ignore-start -->
| Macro                            | Description                                                                            | Default            |
| :------------------------------- | :------------------------------------------------------------------------------------- | :----------------- |
| {$VEEAM.BACKUP_AGE_TRIGGER}      | How many seconds after a backup last runs should it be considered missed?              | `90000` (25 hours) |
| {$VEEAM.MEDIA_POOL.DO_NOT_MATCH} | Which media pools should be ignored.                                                   | `^(Imported|Retired|Unrecognized|Free)$`|
| {$VEEAM.TAPE_AGE_TRIGGER}        | How many seconds after a media pool is last written to should it be considered missed? | `90000` (25 hours) |
<!-- prettier-ignore-end -->

## Discoveries

### Backup Jobs

Finds all backup jobs in VEEAM, except for Tapes.

#### Items

Creates the following items for all backup jobs where `{#JOBNAME}` is the name reported by VEEAM.

| Item                          | Description                                    |
| :---------------------------- | :--------------------------------------------- |
| Backup {#JOBNAME} Last Result | The last result of the job.                    |
| Backup {#JOBNAME} Last Run    | The Timestamp of the last run completion time. |
| Backup {#JOBNAME} Size        | The estimated size in bytes of the backup job. |

#### Triggers

| Trigger                           | Level | Description                                                                          |
| :-------------------------------- | :---- | :----------------------------------------------------------------------------------- |
| Backup {#JOBNAME} Failed          | High  | Triggers when the last value of `Backup {#JOBNAME} Last Result` is not `Success`.    |
| Backup {#JOBNAME} Missed Last Run | High  | Triggers when the `Backup {#JOBNAME} Last Run` passes `{$VEEAM.BACKUP_AGE_TRIGGER}`. |

### Media Pools

Finds all the tape media pools, excluding any that match `{$VEEAM.MEDIA_POOL.DO_NOT_MATCH}`.

#### Items

| Item                                | Description                                        |
| :---------------------------------- | :------------------------------------------------- |
| Media Pool {#MEDIAPOOL}: Last Tape  | The latest tape used in the media pool.            |
| Media Pool {#MEDIAPOOL}: Last Write | The last time any tape in the pool was written to. |

#### Triggers

| Trigger                                     | Level | Description                                                                             |
| :------------------------------------------ | :---- | :-------------------------------------------------------------------------------------- |
| Media Pool {#MEDIAPOOL}: Last Write too old | High  | Triggers when the last tape write for the media pool passes `{$VEEAM.TAPE_AGE_TRIGGER}` |

### Tapes

Finds all the tapes across all the media pools, excluding any in the media pools that match `{$VEEAM.MEDIA_POOL.DO_NOT_MATCH}`.

#### Items

| Item                                        | Description                        |
| :------------------------------------------ | :--------------------------------- |
| Tape {#MEDIAPOOL} - {#TAPENAME}: Capacity   | The capacity of the tape.          |
| Tape {#MEDIAPOOL} - {#TAPENAME}: Last Write | When the tape was last written to. |
