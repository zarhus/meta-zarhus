# meta-zarhus-webkit

This layer adds WebKit overlay for Zarhus; for now, it supports Weston over DRM
only with the `cog`application preinstalled. `cog` may be launched using the
following command after platform startup:

```bash
_MAXIMIZE="0" WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 cog
```
