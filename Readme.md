# Zabbix Templates

These are our custom [Zabbix](https://www.zabbix.com/) templates for monitoring across the network.

## SNMP

 - [Toshiba Printer](./snmp/toshiba-printer/)

## Windows Agent

When installing windows agent templates the contents of `zabbix_agentd.d` needs to copied to `C:\Program Files\Zabbix Agent\zabbix_agentd.d\` on the host. The contents of `scripts` needs placing at `C:\Scripts\zabbix`.

> You could place the scripts anywhere and update the agent config with the new path.

 - [Azure AD Connect](./windows-agent/aadc/)
 - [UniFi Controller](./windows-agent/unifi-controller/)
 - [VEEAM](./windows-agent/veeam/)
