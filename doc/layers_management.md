
[comment]: # (SPDX-FileCopyrightText: 2022 3mdeb Embedded Systems Consulting <contact@3mdeb.com>)

[comment]: # (SPDX-License-Identifier: MIT)

# Layers management

## Currently used layers

Currently, we use following custom layers:
* `meta-zarhus-distro` - contains metadata for our custom distribution,
  common across all platforms
* `meta-zarhus-bsp` - contains metadata for hardware target(s) - a
  single BSP layer can support a single or multiple machines

```
                       +--------------------+
                       |                    |
                 +-----+  meta-zarhus         +-------+
                 |     |                    |       |
                 |     +--------------------+       |
                 |                                  |
                 |                                  |
                 |                                  |
      +----------v-------------+    +---------------v-----------+
      |                        |    |                           |
      |  meta-zarhus-bsp         |    |  meta-zarhus-distro         |
      |                        |    |                           |
      +------------------------+    +---------------------------+
```

## Future layout

Multiple approaches could be used, depending on how the project would evolve.
One of them would be to keep in the `meta-zarhus-distro`
only the bare minimum. Then we could mix a customer/product layers for example,
to produce a build of product `Y` for the customer `X`.

```
                   +--------------------+
                   |                    |
             +-----+  meta-zarhus         +-------+
             |     |                    |       |
             |     +--------------------+       |
             |                                  |
+-----------------------------------------------------------------------------------------+
|            |                                  |                                         |
| +----------v-------------+    +---------------v-----------+     +-------------------+   |
| |                        |    |                           |     |                   |   |
| |  meta-zarhus-bsp         |    |  meta-zarhus-distro         |     |  meta-customer-x  |   |
| |                        |    |                           |     |                   |   |
| +------------------------+    +---------------------------+     +-------------------+   |
|                                                                                         |
|                                                                                         |
|                                                                 +-------------------+   |
|                                                                 |                   |   |
|                                                                 |  meta-product-y   |   |
|                                                                 |                   |   |
|   Product Y for customer X                                      +-------------------+   |
|                                                                                         |
|                                                                                         |
+-----------------------------------------------------------------------------------------+
```

## Adding new layer

### Adding already existing layer

Most of the active and useful Yocto layers are registered in the
[OpenEmbedded Layer Index](https://layers.openembedded.org/layerindex/branch/master/layers/)
and - this should be the first place to look for layers to use.

Layers are added by inserting an entry to the `kas/common.yml` file. For
example, this is how the `meta-openembedded` could be added:

```
  meta-openembedded:
    url: https://git.openembedded.org/meta-openembedded
    refspec: 2a5c534d2b9f01e9c0f39701fccd7fc874945b1c
    layers:
      meta-oe:
      meta-networking:
      meta-python:
      meta-filesystems:
```

* the `url` points to the repository location
* the `refspec` is a SHA1 of git commit we want to use
* the `layers` section is optional
  - if it does not exists, the `kas` assumes that the root directory is a layer
    itself
  - if it exists, we can choose which layers from given repository should be
    enabled - in this example we enable `oe`, `networking`, `python` and
    `filesystem` layers, but the `meta-openembedded` repository has a few more
    available

More details can be found in the
[kas user guide](https://kas.readthedocs.io/en/latest/userguide.html).

### Creating a new layer

A a layer is a directory which contains some metadata gathered in the
configuration files (`*.conf`), recipes (`*.bb`) or append files
(`*.bbappend`). The crucial file which defines that the given directory is a
layer is the `conf/local.conf` file within that directory. The content of this
file describes what kind of metadata files can be found within their layer, and
what are their paths. More about the `Yocto Project Layer Model` can be found
in the [Yocto documentation](https://docs.yoctoproject.org/singleindex.html#).

Once we crate our custom layer, we can add it to the build in the same way as
we are [adding already axistin layer](#adding-already-existing-layer).

#### Manually

* Create a directory structure:

```
$ mkdir -p meta-customer-a/conf meta-customer-a/recipes-customer-a
```

* Create a license file, for example use the `MIT` license:

> Adjust the copyright holder data within the file

```
wget -O meta-customer-a/COPYING.MIT https://raw.githubusercontent.com/spdx/license-list-data/master/text/MIT.txt
```

* Create a `layer.conf` file, based on `layer.conf` file from one of the
  already existing layers:

```
$ vim meta-customer-a/conf/layer.conf
```

The typical content of `layer.conf` file:

```
# We have a conf and classes directory, add to BBPATH
BBPATH .= ":${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "${LAYERDIR}/recipes-*/*/*.bb \
            ${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "meta-customer-a"
BBFILE_PATTERN_meta-customer-a = "^${LAYERDIR}/"
BBFILE_PRIORITY_meta-customer-a = "6"

LAYERDEPENDS_meta-customer-a = "core"
LAYERSERIES_COMPAT_meta-customer-a = "dunfell"
```

#### Using the bitbake-layers script

* [Enter build container shell](../README.md#enter-docker-shell)

* Use the `bitbake-layers` command:

```
(docker)$ bitbake-layers create-layer /work/meta-customer-a

NOTE: Starting bitbake server...
Add your new layer with 'bitbake-layers add-layer /work/meta-customer-a'
```

* As a result, following structure is created:

```
/work/meta-customer-a/
├── conf
│   └── layer.conf
├── COPYING.MIT
├── README
└── recipes-example
    └── example
        └── example_0.1.bb
```

* Now we can add our recipes specific to the `customer-a` here.
