# meta-zarhus-bsp-qemuarm

Build image that can run on QEMU along with U-Boot.
To run image after build completes enter kas shell and:

```sh
kas-container shell meta-zarhus/kas/common.yml:meta-zarhus/kas/qemuarm.yml
runqemu slirp nographic
```

To run QEMU outside of kas shell

* nographic

    ```sh
    qemu-system-arm -device virtio-net-device,netdev=net0 \
        -netdev user,id=net0,hostfwd=tcp:127.0.0.1:2222-:22 \
        -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0 \
        -drive id=disk0,file=build/tmp/deploy/images/qemuarm-uboot/zarhus-base-image-debug-qemuarm-uboot.rootfs.wic,if=none,format=raw \
        -device virtio-blk-device,drive=disk0 -device qemu-xhci -device usb-tablet \
        -device usb-kbd -machine virt,highmem=off -cpu cortex-a15 -smp 4 -m 1G \
        -serial mon:stdio -nographic -device virtio-gpu-pci \
        -bios build/tmp/deploy/images/qemuarm-uboot/u-boot.bin \
        -kernel build/tmp/deploy/images/qemuarm-uboot/zImage \
        -append 'root=PARTLABEL=root rw ip=dhcp console=ttyAMA0 console=hvc0 swiotlb=0'
    ```

* graphic

    ```sh
    qemu-system-arm -device virtio-net-device,netdev=net0 \
        -netdev user,id=net0,hostfwd=tcp:127.0.0.1:2222-:22 \
        -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0 \
        -drive id=disk0,file=/build/tmp/deploy/images/qemuarm-uboot/zarhus-base-image-debug-qemuarm-uboot.rootfs.wic,if=none,format=raw \
        -device virtio-blk-device,drive=disk0 -device qemu-xhci -device usb-tablet \
        -device usb-kbd -machine virt,highmem=off -cpu cortex-a15 -smp 4 -m 1G \
        -serial mon:stdio -device virtio-gpu-gl -display sdl,gl=on \
        -bios /build/tmp/deploy/images/qemuarm-uboot/u-boot.bin \
        -kernel /build/tmp/deploy/images/qemuarm-uboot/zImage \
        -append 'root=PARTLABEL=root rw ip=dhcp swiotlb=0'
    ```

    `runqemu` uses `-device virtio-gpu-pci` but it's extremely slow and laggy
