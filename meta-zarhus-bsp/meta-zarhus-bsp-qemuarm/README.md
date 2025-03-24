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
        -drive id=disk0,file=build/tmp/deploy/images/qemuarm-uboot/zarhus-base-image-debug-qemuarm-uboot.rootfs.wic,if=none,format=raw \
        -device virtio-blk-device,drive=disk0 -device qemu-xhci -device usb-tablet \
        -device usb-kbd -machine virt,highmem=off -cpu cortex-a15 -smp 4 -m 1G \
        -serial mon:stdio -device virtio-gpu-gl -display sdl,gl=on \
        -bios build/tmp/deploy/images/qemuarm-uboot/u-boot.bin \
        -kernel build/tmp/deploy/images/qemuarm-uboot/zImage \
        -append 'root=PARTLABEL=root rw ip=dhcp swiotlb=0'
    ```

    `runqemu` uses `-device virtio-gpu-pci` but it's extremely slow and laggy

## Splash

To test splash use `-device virtio-gpu-pci` (without `display sdl,gl=on`).
To keep splash between U-Boot and Linux you need to modify DTB that QEMU
passes to U-Boot. To do that:
1. add `-machine dumpdtb=qemu.dtb` argument to qemu command to generate
`qemu.dtb` file
2. Convert DTB to DTS

    ```sh
    dtc -I dtb qemu.dtb -O dts -o qemu.dts
    ```

3. Add framebuffer and reserved memory nodes:

    ```diff
    --- qemu.dts   2025-03-23 14:28:51.121551241 +0100
    +++ qemu.dts    2025-03-23 14:17:35.353071445 +0100
    @@ -414,11 +414,34 @@
                    #clock-cells = <0x00>;
                    compatible = "fixed-clock";
            };
    +
    +    reserved-memory {
    +        #address-cells = <2>;
    +        #size-cells = <2>;
    +        ranges;
    +
    +        fb: framebuffer@7fe00000 {
    +            reg = <0x0 0x7fe00000 0x0 0xa00000>;
    +        };
    +    };

            chosen {
                    bootargs = "root=PARTLABEL=root rw ip=dhcp swiotlb=0 quiet splash";
                    stdout-path = "/pl011@9000000";
                    rng-seed = <0x3da86298 0xbe5d7724 0x11f59fc5 0xae4cd81b 0xe4efb4ea 0xc1e46854 0xc69fe738 0x95153740>;
                    kaslr-seed = <0x3ffc7adc 0xb71d3355>;
    +               #address-cells = <2>;
    +               #size-cells = <2>;
    +               ranges;
    +
    +               framebuffer@7fe00000 {
    +                       compatible = "simple-framebuffer";
    +                       reg = <0x0 0x7fe00000 0x0 (640 * 480 * 4)>;
    +                       width = <640>;
    +                       height = <480>;
    +                       stride = <(640 * 4)>;
    +                       format = "a8r8g8b8";
    +                       memory-region = <&fb>;
    +               };
            };
     };
    ```

    You might need to modify framebuffer address to be the same as in U-Boot.
    To do that boot into U-Boot and check `FB Base` value when using `bdinfo`
    command e.g.:

    ```txt
    FB base     = 0x7fe00000
    ```

4. Convert DTS to DTB

    ```sh
    dtc -I dts qemu.dts -O dtb -o qemu.dtb
    ```

5. Add `-dtb qemu.dtb` argument to qemu to use modified dtb.
