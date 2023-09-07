# bootstrap

## bootstrap iso

```shell
nix build _bootstrap#bootstrap-install-iso
```

```shell
lsblk
```

```fish
# set DRIVE_NAME sandisk
# set DRIVE_LOCATION /dev/sdb # /dev/disk/by-label/$DRIVE_NAME
test -z $DRIVE_LOCATION && echo "Set the DRIVE_LOCATION variable please :(" || sudo dd status=progress bs=4M if=(ls result/iso/nixos-*.iso) of=$DRIVE_LOCATION conv=fdatasync
```

## pi

- Download NixOS image from [the NixOS website](https://hydra.nixos.org/job/nixos/release-23.05/nixos.sd_image.aarch64-linux).
- Flash the SD card with the image.
- Insert the SD card into the pi and boot it
- Attach keyboard and screen to the pi
- login as `root`
- Generate a default config:

  ```shell
  nixos-generate-config
  ```

- Send

  ```shell
  nix run nixpkgs#magic-wormhole -- send --code='68-scrungo-bepis' ./_bootstrap/bootstrap.nix
  ```

- Receive the config:

  ```shell
  nix run --extra-experimental-features 'nix-command flakes' nixpkgs#magic-wormhole -- receive --output-file=/etc/nixos/bootstrap.nix 68-scrungo-bepis
  ```

- Edit the config:

  ```shell
  nano /etc/nixos/configuration.nix
  ```

  and add to the config:

  ```nix
  imports = [./hardware-configuration.nix ./bootstrap.nix]
  ```

- Rebuild the OS:

  ```shell
  nixos-rebuild switch
  ```

- Add a password to the `hannes` user:

  ```shell
  passwd hannes
  ```

- Login to Tailscale

  ```shell
  tailscale login
  ```

- Check you can SSH in using the password:

  ```shell
  ssh hannes@xxx
  ```

- Exit the SSH session
