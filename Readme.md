# Zabbix Templates

These are our custom [Zabbix](https://www.zabbix.com/) templates for monitoring across the network.

## Windows Agent

When installing windows agent templates the contents of `zabbix_agentd.d` needs to copied to `C:\Program Files\Zabbix Agent\zabbix_agentd.d\` on the host. The contents of `scripts` needs placing at `C:\Scripts\zabbix`.

> You could place the scripts anywhere and update the agent config with the new path.

 - [VEEAM](./windows-agent/veeam/)
 