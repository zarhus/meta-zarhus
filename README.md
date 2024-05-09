# meta-zarhus

## Prerequisites

* Linux PC (tested on `Ubuntu 20.04 LTS`)

* [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) installed

* [kas-container 2.6.3](https://raw.githubusercontent.com/siemens/kas/2.6.3/kas-container)
  script downloaded and available in [PATH](https://en.wikipedia.org/wiki/PATH_(variable))

```bash
wget -O ~/bin/kas-container https://raw.githubusercontent.com/siemens/kas/2.6.3/kas-container
chmod +x ~/bin/kas-container
```

* `meta-zarhus` repository cloned

```bash
mkdir yocto
cd yocto
git clone GIT_URL
```

* [bmaptool](https://source.tizen.org/documentation/reference/bmaptool) installed

```bash
sudo apt install bmap-tools
```

> You can also use `bmap-tools`
> [from github](https://github.com/intel/bmap-tools) if it is not available in
> your distro.

## Build

Depending on which version of build you want to run, replace `kas-debug.yml`
with desired `.yml` file.

- From `yocto` directory run:

```shell
$ SHELL=/bin/bash kas-container build meta-zarhus/kas-debug.yml
```

- Image build takes time, so be patient and after build's finish you should see
something similar to (the exact tasks numbers may differ):

```shell
Initialising tasks: 100% |###########################################################################################| Time: 0:00:01
Sstate summary: Wanted 2 Found 0 Missed 2 Current 931 (0% match, 99% complete)
NOTE: Executing Tasks
NOTE: Tasks Summary: Attempted 2532 tasks of which 2524 didn't need to be rerun and all succeeded.
```

### Private git repositories

When fetching from private repositories is needed (either during the layers
fetching or during the build process itself), we need to expose access to the
SSH keys somehow. The preferred way (at least when using the `kas-container`) is
to use the `--ssh-dir <ssh_keys_directory>` option.

It's important to use keys that don't have password (are not encrypted)!

The contents of the `~/ssh-keys` can look like:

```shell
config
github_key_ro
github_key_ro.pub
gitlab_key_ro
gitlab_key_ro.pub
```

And the `~/ssh-keys/config` file:

```shell
Host gitlab.com
    HostName       gitlab.com
    User           git
    IdentityFile   ~/.ssh/gitlab_key_ro
    StrictHostKeyChecking no
    IdentitiesOnly yes

Host github.com
    HostName       github.com
    User           git
    IdentityFile   ~/.ssh/github_key_ro
    StrictHostKeyChecking no
    IdentitiesOnly yes
```

- From `yocto` directory run:

```shell
$ SHELL=/bin/bash kas-container --ssh-dir ~/ssh-keys build meta-zarhus/kas-debug.yml
```

## Enter docker shell

Some Yocto related work may need to use bitbake environment. The easiest way to
achive that is to start `kas-container` in shell mode. Depending on which
version of build you want to use, replace `kas-debug.yml` with desired `.yml`
file.

- From `yocto` directory run:

```shell
$ SHELL=/bin/bash kas-container shell meta-3mdeb/kas-debug.yml
```

## Flash

This section assumes that image can be flashed on SD card.

- Find out your device name:

```shell
$ fdisk -l
```

output:

```shell
(...)
Device     Boot  Start    End Sectors  Size Id Type
/dev/sdx1  *      8192 131433  123242 60,2M  c W95 FAT32 (LBA)
/dev/sdx2       139264 186667   47404 23,2M 83 Linux
```

in this case the device name is `/dev/sdx` **but be aware, in next steps
replace `/dev/sdx` with right device name on your platform or else you can
damage your system!.**

- From where you ran image build type:

```shell
$ cd build/tmp/deploy/images/zarhus-machine
$ sudo umount /dev/sdx*
$ sudo bmaptool copy --bmap zarhus-base-image-zarhus-machine.wic.bmap zarhus-base-image-zarhus-machine.wic.gz /dev/sdx
```

and you should see output similar to this (the exact size number may differ):

```shell
zarhus-base-image-zarhus-machine.wic.bmap zarhus-base-image-zarhus-machine.wic.gz /dev/sdx
bmaptool: info: block map format version 2.0
bmaptool: info: 74650 blocks of size 4096 (291.6 MiB), mapped 42052 blocks (164.3 MiB or 56.3%)
bmaptool: info: copying image 'zarhus-base-image-zarhus-machine.wic.gz' to block device '/dev/sdx' using bmap file 'zarhus-base-image-zarhus-machine.wic.bmap'
bmaptool: WARNING: failed to enable I/O optimization, expect suboptimal speed (reason: cannot switch to the 'noop' I/O scheduler: [Errno 22] Invalid argument)
bmaptool: info: 100% copied
bmaptool: info: synchronizing '/dev/sdx'
bmaptool: info: copying time: 11.0s, copying speed 15.0 MiB/sec
```

- Boot the platform
