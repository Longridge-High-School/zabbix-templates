# Zabbix Templates

These are our custom [Zabbix](https://www.zabbix.com/) templates for monitoring across the network.

## PowerShell Monitor

These make use of `zabbix_sender.exe` on the Windows Agents to send data. This allows for long-run processes that would normally time out, or for monitoring external APIs.

 - [Sophos Central](./powershell-monitor/sophos-central/)
 - [VEEAM](./powershell-monitor/veeam/)

## SNMP

 - [Toshiba Printer](./snmp/toshiba-printer/)

## Windows Agent

When installing windows agent templates the contents of `zabbix_agentd.d` needs to copied to `C:\Program Files\Zabbix Agent\zabbix_agentd.d\` on the host. The contents of `scripts` needs placing at `C:\Scripts\zabbix`.

> You could place the scripts anywhere and update the agent config with the new path.

 - [Azure AD Connect](./windows-agent/aadc/)
 - [UniFi Controller](./windows-agent/unifi-controller/)
