# meta-zarhus

## Prerequisites

* Linux PC (tested on `Fedora 39`)

* [docker](https://docs.docker.com/engine/install/fedora/) installed

* [kas-container 4.2](https://raw.githubusercontent.com/siemens/kas/4.2/kas-container)
script downloaded and available in [PATH](https://en.wikipedia.org/wiki/PATH_(variable))

  ```bash
  wget -O ~/bin/kas-container https://raw.githubusercontent.com/siemens/kas/4.2/kas-container
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

## Configuration

To configure different features or target machine to build for you can either
pass `.yml` files and set `KAS_*` variables manually or for easier configuration
you can use:

```sh
kas-container menu meta-zarhus/Kconfig
```

After which you can select desired options

```text
┌──────────────────────┤ Main menu ├───────────────────────┐
│                                                          │
│                        Machine  --->                     │
│                        Distro  --->                      │
│                        Features  --->                    │
│                                                          │
│  ┌───────┐   ┌─────────────┐   ┌────────┐   ┌────────┐   │
│  │ Build │   │ Save & Exit │   │  Exit  │   │  Help  │   │
│  └───────┘   └─────────────┘   └────────┘   └────────┘   │
│                                                          │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

After saving your first config you can then use `menu`/`build`/`shell` kas
subcommands without passing config argument e.g.:

```sh
kas-container menu
kas-container shell
kas-container build
```

## Build

Depending on which features you want to have in your build, pass the desired
`.yml` files via command line. You can read more on that in
[kas documentation.](https://kas.readthedocs.io/en/latest/userguide/project-configuration.html#including-configuration-files-via-the-command-line)

Then check BSP layers for available target platform (target platforms configs
are located in `conf/machine` directory of every BSP layer) and choose one.
Then, from `yocto` directory run:

```shell
SHELL=/bin/bash KAS_MACHINE=<TARGET_NAME> kas-container build <KAS_FILES>
```

> Note: replace `<TARGET_NAME>` with the name of the chosen target
> configuration file, and `<KAS_FILES>` with a list of kas files, separated by
> `:`.

For example:

```shell
SHELL=/bin/bash KAS_MACHINE=orangepi-cm4 kas-container build meta-zarhus/kas/common.yml:meta-zarhus/kas/rockchip.yml
```

* Image build takes time, so be patient and after build's finish you should see
something similar to (the exact tasks numbers may differ):

  ```shell
  Initialising tasks: 100% |###########################################################################################| Time: 0:00:01
  Sstate summary: Wanted 2 Found 0 Missed 2 Current 931 (0% match, 99% complete)
  NOTE: Executing Tasks
  NOTE: Tasks Summary: Attempted 2532 tasks of which 2524 didn't need to be rerun and all succeeded.
  ```

More info about building is available here:

* [Zarhus Docs: Building](https://docs.zarhus.com/getting-started/building/)
* [Zarhus Docs: Targets](https://docs.zarhus.com/supported-targets/targets/)

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
  $ cd build/tmp/deploy/images/orangepi-cm4
  $ sudo umount /dev/sdx*
  $ sudo bmaptool copy zarhus-base-image-orangepi-cm4.wic.gz /dev/sdx
  ```

and you should see output similar to this (the exact size number may differ):

  ```shell
  zarhus-base-image-orangepi-cm4.wic.bmap zarhus-base-image-orangepi-cm4.wic.gz /dev/sdx
  bmaptool: info: block map format version 2.0
  bmaptool: info: 74650 blocks of size 4096 (291.6 MiB), mapped 42052 blocks (164.3 MiB or 56.3%)
  bmaptool: info: copying image 'zarhus-base-image-orangepi-cm4.wic.gz' to block device '/dev/sdx' using bmap file 'zarhus-base-image-orangepi-cm4.wic.bmap'
  bmaptool: WARNING: failed to enable I/O optimization, expect suboptimal speed (reason: cannot switch to the 'noop' I/O scheduler: [Errno 22] Invalid argument)
  bmaptool: info: 100% copied
  bmaptool: info: synchronizing '/dev/sdx'
  bmaptool: info: copying time: 11.0s, copying speed 15.0 MiB/sec
  ```

* Boot the platform

## Release process

The release process is described [here][zarhus-release-process]. Mind that in
step 2 you have to bump `DISTRO_VERSION` in
`meta-zarhus-distro/conf/distro/include/zarhus-distro-common.conf`.

When generating the changelog, you can provide your GitHub access token as a
parameter to `generate-changelog.sh`. This will disable the API call limit,
which may otherwise prevent you from running `git cliff`.

[zarhus-release-process]: https://docs.zarhus.com/development-process/standard-release-process
