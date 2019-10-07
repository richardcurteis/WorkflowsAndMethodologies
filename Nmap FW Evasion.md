## NMAP FW Evasion ##

### General

#### Nmap Responses

1. Filtered returns nothing or ICMP error

2. TCP Closed returns a RST packets from FW

*NOTE: Some FW's (iptables) will return forged RST.

This is mainly useful for blocking ident (113/tcp) probes which frequently occur when sending mail to broken mail hosts

```~ iptables --reject-with $type```

Types which return the appropriate ICMP error message:
1. icmp-net-unreachable
2. icmp-host-unreachable
3. icmp-port-unreachable (default)
4. icmp-proto-unreachable
5. icmp-net-prohibited
6. icmp-host-prohibited


### Enumerate FW Rules

##### https://nmap.org/book/determining-firewall-rules.html

##### Detect Closed and open ports

*Note: Filtering devices such as firewalls tend to drop packets destined for disallowed ports. In some cases they send ICMP error messages (usually port unreachable) instead

#### Standard SYN

*Note: 'Not shown: n ports'. 'not shown' == 'filtered'

This indicates host has a proper deny-by-default policy.

Only those ports the administrator explicitly allowed are reachable.

Default action is to DENY them 

```Port == 'unfiltered'```: Since the ACK scan cannot further divide ports into open or closed

##### If stateful FW rules in place.

```iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT```

```nmap -sS -T 4 $target```

#### ACK

Open/Closed: Required to respond with RST

Firewalls that block the probe usually make no response or send back an ICMP destination unreachable error.

Many networks allow nearly unrestricted outbound connections, but wish to block Internet hosts from initiating  connections back to them.

Blocking incoming SYN packets (without the ACK bit set) is an easy way to do this, but it still allows any ACK packets through. Blocking those ACK packets is more difficult, because they do not tell which side started the connection. 

```nmap -sA $target```

**Run both and compare reults**

#### IP ID Tricks

** What source addresses make it through the firewall? **

##### Nping

1. Find at least one accessible (open or closed) port of one machine on the internal network. Routers, printers,
	and Windows boxes often work well. Recent releases of Linux, Solaris, and OpenBSD have largely resolved the issue
	of predictable IP ID sequence numbers and will not work.
	The machine chosen should have little network traffic to avoid confusing results.
	
2. Verify that the machine has predictable IP ID sequences.
	The Nping options request that five SYN packets be sent to port 80, one second apart.
	
```nping -c 5 --delay 1 -p 80 --tcp $target```
	
	```IF
		IP ID fields are perfectly sequential, we can move on to the next test.
	ELSE
		If they were random or very far apart, we would have to find a new accessible host.
	FI```

3. Start a flood of probes to the target from a host near your own (just about any host will do).
	Getting replies back is not necessary, because the goal is simply to increment the IP ID sequences.
	!! DO NOT use the real address of the machine you are running Nping from. !!
	Using a machine nearby on the network is advised to reduce the probability that your own ISP will block the packets.

```nping -S $local --rate 10 -p 80 -c 10000 --tcp $target```

**Simultaneously**
	While this is going on, redo the test from the previous step against your target machine.
	
	On new test, check if IP ID's are increasing by --rate + 1
	Each response increments the IP ID
	Some hosts use a unique IP ID sequence for each IP address they communicate with. If that had been the case, we would not have seen the IP ID leaping like this and we would have to look for a different target host on the network.

4. Repeat step 3 using spoofed addresses that you suspect may be allowed through the firewall or trusted.

	Try addresses behind their firewall, as well as the RFC 1918 private networks such as:
		10.0.0.0/8, 192.168.0.0/16, and 172.16.0.0/12.
		Try localhost (127.0.0.1) and maybe another address from 127.0.0.0/8 to detect cases where 127.0.0.1 is hard coded in.
		There have been many security holes related to spoofed localhost packets, including the infamous Land denial of service attack.
		Misconfigured systems sometimes trust these addresses without checking whether they came from the loopback interface.
		
		```IF Source address gets through to the end host:
				IP ID will jump as seen in step 3.
		ELSE Continues to increment slowly as in step 2:
			Packets were likely dropped by a firewall or router.
		FI```


##### Check user agents

```nmap -p $port/s --script http-useragent-tester.nse```

```nmap -p80 --script http-sqli-finder --script-args http.useragent="Mozilla 42" $target```

##### Set User agent manually in script
```options = {header={}}    options['header']['User-Agent'] = "Mozilla/9.1 (compatible; Windows NT 5.0 build 1420;)"    local req = http.get(host, port, uri, options)```

##### Adjust Timing

```nmap -T 0 $target```

```nmap -T 1 $target```

#### MySQl Enum

```nmap -A -n -p3306 <IP Address>```

```nmap -A -n -PN --script:ALL -p3306 <IP Address>```

```Try: telnet IP_Address 3306```
