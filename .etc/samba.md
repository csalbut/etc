# Samba home server configuration

This guide provides step by step description of configuring samba server for a small local network. The operating system of choice for the server is Arch linux.

## General commands

Service control
```
systemctl [status|show|start|stop|reload|restart|enable] <service_name>
```

## Required packages

- samba -- Samba server. Also allows other hosts to address this host by name [1].
- smbclient (dependency of samba) -- Allows to access samba shares at remote servers. Allows to address other hosts by their names using WINS. To enable it, add â€œwinsâ€ to the â€œhostsâ€ line in /etc/nsswitch.conf. 

## Server settings

Define shares in `/etc/samba/smb.conf`
```
/etc/samba/smb.conf

[global]
    workgroup = SIGIL
    server string = %h samba server
    log file = /var/log/samba/%m.log
    dns proxy = no
    guest account = guest
    syslog = 0
    max log size = 1000
    load printers = No

    # todo: verify if needed
    # netbios name = SERVER
    # name resolve order = bcast host
    # create mask = 0664
    # directory mask = 0775
    # force create mode = 0664
    # force directory mode = 0775
    # wins support = Yes
    # panic action = /usr/share/samba/panic-action %d
    # idmap config * : backend = tdb

[example]
        comment = %h tmp
        path = /tmp
        read only = No

```

## Setup procedure

`systemctl enable smbd nmbd`

Remember to `testparm -s` and `systemctl restart smbd nmbd` after editing configuration files. 

## Monitoring and verification

`testparm` checks validity of `smb.conf` contents.

## References
- [1] https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname
- [2] https://wiki.archlinux.org/index.php/Samba
- [3] https://wiki.archlinux.org/index.php/Samba/Tips_and_tricks
