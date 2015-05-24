# Arch Linux administrator cheatsheet

## Periodic acitivities

Synchronize with repositories and update all packages on the system
```
pacman -Syu
```

Remove all but the last three versions of downloaded packages from the local cache
```
paccache -r
```
Remove cached versions of uninstalled packages
```
paccache -ruk0
```
