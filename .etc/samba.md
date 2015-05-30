# Samba home server configuration

This guide provides step by step description of configuring samba server for a small local network. The operating system of choice for the server is Arch linux.

## General commands

Service control
```
systemctl [status|show|start|stop|reload|restart|enable] <service_name>
```

## Required packages

- samba -- Samba server. Also allows other hosts to address this host by name [1].
- smbclient (dependency of samba) -- Allows to access samba shares at remote servers. Allows to address other hosts by their names using WINS. To enable it, add “wins” to the “hosts” line in /etc/nsswitch.conf.

## Server settings

Define shares in `/etc/samba/smb.conf`
```
[global]
        workgroup = SIGIL
        server string = %h samba server
        syslog = 0
        log file = /var/log/samba/log.all
        max log size = 1000
        load printers = no
        dns proxy = no
        security = user

[olive]
        comment = %h %S
        path = /mnt/olive
        read only = no
        valid users = +alpha
        admin users = alpha
        create mask = 0660
        directory mask = 0770

[music]
        comment = %h %S
        path = /mnt/olive/muz
        read only = no
        valid users = +beta,+gamma
        admin users = alpha
        create mask = 0664
        directory mask = 0775

[upload]
        comment = %h %S
        path = /mnt/upload
        read only = no
        public = yes
        create mask = 0664
        directory mask = 0775
```

## Setup procedure

`systemctl enable smbd nmbd`

Remember to `testparm -s` and `systemctl restart smbd nmbd` after editing configuration files.

A linux user account should exist for each samba user. Create them.
```
useradd -c "samba user alpha" -d /dev/null -s /bin/false alpha
useradd -c "samba user beta" -d /dev/null -s /bin/false beta
useradd -c "samba user gamma" -d /dev/null -s /bin/false gamma
```

Samba uses separate password database. Set passwords for samba users.
```
pdbedit -a -u alpha
```

From the three created users, user alpha is the most privileged and user gamma -- the least. Privilege graduation is achieved by assigning users to groups according to the following scheme.
```
user    groups
--------------------------
alpha   alpha, beta, gamma
beta    beta, gamma
gamma   gamma
```

Create groups on linux clients, explicitly setting group ids.
```
groupadd -g 2000 alpha
groupadd -g 2001 beta
groupadd -g 2002 gamma
```

On the server groups already exist (they were created automatically together with new user accounts), so they only need to be modified.
```
groupmod -g 2000 alpha
groupmod -g 2001 beta
groupmod -g 2002 gamma
```

Assign users to groups on the server.
```
usermod -a -G gamma beta
usermod -a -G gamma,beta alpha
```

Deny ssh access to newly created users by adding this line to `/etc/ssh/sshd_config`
```
DenyUsers alpha beta gamma
```

Mount external drives on the server using this fstab entry.
```
/dev/sdb2   /mnt/olive  ntfs-3g    rw,user,gid=alpha,dmask=002,fmask=113 0 0
```

Fstab entry for mounting remote samba shares on a client machine.
```
//hauru/olive   /mnt/olive cifs users,rw,gid=alpha,username=alpha,credentials=/home/cs/.sambacreds 0 0
```

Create `~/.sambacreds` file and chmod it to 600 permissions:
```
username=alpha
password=<password>
```

Make sure that smbd and nmbd are started on the server, and mount shares on the client.

## Monitoring and verification

`testparm` checks validity of `smb.conf` contents.

List servers, workgroups and public shares on a server:
```
smbclient -L hostname -U%
```

Discover servers and shares accessible for a user (like network neighborhood):
```
smbtree -U username
```

List all samba users allowed to access shares on the server:
```
TODO
```


## References
- [1] https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname
- [2] https://wiki.archlinux.org/index.php/Samba
- [3] https://wiki.archlinux.org/index.php/Samba/Tips_and_tricks
- [4] http://superuser.com/questions/752136/samba-with-individual-users-per-shared-directory
- [5] man 8 mount
