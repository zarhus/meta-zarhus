# meta-zarhus

## Prerequisites

* Linux PC (tested on `Fedora 39`)

* [docker](https://docs.docker.com/engine/install/fedora/) installed

* [kas-container 3.0.2](https://raw.githubusercontent.com/siemens/kas/3.0.2/kas-container)
script downloaded and available in [PATH](https://en.wikipedia.org/wiki/PATH_(variable))

  ```bash
  wget -O ~/bin/kas-container https://raw.githubusercontent.com/siemens/kas/3.0.2/kas-container
  chmod +x ~/bin/kas-container
  ```

* `meta-zarhus` repository cloned

  ```bash
  mkdir yocto
  cd yocto
  git clone https://github.com/zarhus/meta-zarhus.git
  ```

* [bmaptool](https://docs.yoctoproject.org/dev-manual/bmaptool.html) installed

  ```bash
  sudo dnf install bmap-tools
  ```

  > You can also use `bmap-tools`
  > [from GitHub](https://github.com/yoctoproject/bmaptool) if it is not
  > available in your distro.

## Build

Depending on which features you want to have in your build, pass the desired
`.yml` files via command line. You can read more on that in
[kas documentation](https://kas.readthedocs.io/en/latest/userguide/project-configuration.html#including-configuration-files-via-the-command-line)

* From `yocto` directory run:

  ```shell
  SHELL=/bin/bash kas-container build meta-zarhus/kas/common.yml:meta-zarhus/kas/rockchip.yml
  ```

* Image build takes time, so be patient and after build's finish you should see
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

The contents of the `<ssh_keys_directory>` can look like:

```shell
config
github_key_ro
github_key_ro.pub
gitlab_key_ro
gitlab_key_ro.pub
```

And the `<ssh_keys_directory>/config` file:

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

It's important to have paths in `IdentityFile` in format `~/.ssh/<path/to/key>`
as `kas-container` mounts `<ssh_keys_directory>` as `.ssh` folder inside
container.

From `yocto` directory run:

  ```shell
  $ SHELL=/bin/bash kas-container --ssh-dir <ssh_keys_directory> build meta-zarhus/kas-debug.yml
  ```

## Enter docker shell

Some Yocto related work may need to use BitBake environment. The easiest way to
achieve that is to start `kas-container` in shell mode. Depending on which
version of build you want to use, replace `kas-debug.yml` with desired `.yml`
file.

* From `yocto` directory run:

  ```shell
  $ SHELL=/bin/bash kas-container shell meta-3mdeb/kas-debug.yml
  ```

## Flash

This section assumes that image can be flashed on SD card.

* Find out your device name:

  ```shell
  $ lsblk
  NAME                                     MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
  sdx                                      179:0    0  14.8G  0 disk
  ├─sdx1                                   179:1    0     4M  0 part
  └─sdx2                                   179:2    0     4M  0 part
  ```

  In this case the device name is `/dev/sdx` **but be aware, in next steps
  replace `/dev/sdx` with right device name on your platform or else you can
  damage your system!.**

* From where you ran image build type:

  ```shell
  $ cd build/tmp/deploy/images/zarhus-machine-cm3
  $ sudo umount /dev/sdx*
  $ sudo bmaptool copy zarhus-base-image-zarhus-machine-cm3.wic.gz /dev/sdx
  ```

and you should see output similar to this (the exact size number may differ):

  ```shell
  zarhus-base-image-zarhus-machine-cm3.wic.bmap zarhus-base-image-zarhus-machine-cm3.wic.gz /dev/sdx
  bmaptool: info: block map format version 2.0
  bmaptool: info: 74650 blocks of size 4096 (291.6 MiB), mapped 42052 blocks (164.3 MiB or 56.3%)
  bmaptool: info: copying image 'zarhus-base-image-zarhus-machine-cm3.wic.gz' to block device '/dev/sdx' using bmap file 'zarhus-base-image-zarhus-machine-cm3.wic.bmap'
  bmaptool: WARNING: failed to enable I/O optimization, expect suboptimal speed (reason: cannot switch to the 'noop' I/O scheduler: [Errno 22] Invalid argument)
  bmaptool: info: 100% copied
  bmaptool: info: synchronizing '/dev/sdx'
  bmaptool: info: copying time: 11.0s, copying speed 15.0 MiB/sec
  ```

* Boot the platform
