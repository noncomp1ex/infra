# Install vm

## partition (dos)
- set boot flag on 500M part
```
vda    253:0    0   20G  0 disk
├─vda1 253:1    0  500M  0 part
└─vda2 253:2    0 19.5G  0 part
```

- check with `sudo parted /dev/sda print`

## format

```
sudo mkfs.ext4 /dev/vda1
sudo mkfs.ext4 /dev/vda2
```

## label (formatting removes labels)
```
sudo e2label /dev/vda1 BOOT
sudo e2label /dev/vda2 ROOT
```

## mount
```
sudo mount /dev/vda2 /mnt
sudo mkdir /mnt/boot
sudo mount /dev/vda1 /mnt/boot
```

## install
```
cd /mnt
sudo nixos-install --flake github:noncomp1ex/infra#noninfra --root /mnt
```


# Deploy new config

- make sure the remote in flake.nix is to good
- also the name is hard coded to crolbar

```
nix develop
deploy
```
