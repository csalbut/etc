# TonidoPlug2 administration notes

## Hardware configuration

I have a TonidoPlug2 equipped with 2TB SATA HDD and 2 TB USB 3.0 HDD. I nicknamed the SATA HDD "green", because it is a WD Green model. The USB disk received the "olive" label for no particular reason -- it is just a different color.

Disk green is the main working disk, and disk olive is only intended for backups.

On the green disk, there are two partitions: sda1 contains the operating system, and sda2 (labeled "green") contains data.

## Setup steps

Install Arch Linux ARM according to this guide: http://archlinuxarm.org/platforms/armv5/tonidoplug-2.

If you cannot ssh into the new installation, establish a serial port connection, for example with `picocom`:

```
picocom -b 115200 -c /dev/ttyUSB0
```

In my case, eth0 interface was started in IPv6 mode only, but entire local network was running on IPv4. Manually asking the router for an IP lease solved the problem.

```
dhcpcd
systemctl enable dhcpcd
```

First step on a fresh install: upgrade the system.

```
pacman -Syu
```

In my setup, the green disk spins down every few minutes, only to be spun up again in a second. And while doing that, the disk head makes a disturbing 'click' sound. To prevent excessive wear of the disk, disable automatic spin-downs.

Monitor spin-down counter with
```
pacman -S smartmontools
smartctl -A /dev/sda | grep -i load_cycle_count
```

Verify "advanced power management level"
```
hdparm -B /dev/sda
```

And disable automatic spin-downs
```
hdparm -B 254 /dev/sda
```
