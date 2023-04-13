vm-o-matic - Simple, semi-automatic QEMU recipes
================================================

vm-o-matic isn't clever, complete or scaleable. However it *is*
useful if you want to spin up a throwaway VM to test out something
about a specific distro.

Example
-------

```sh
cd debian-11-bullseye-amd64
make help
make install
make
```

Kernel hacking
--------------

A defconfig kernel usually has enough compiled built in to do a minimal
boot (an arm64 one certainly does). For some recipes we can bypass
grub and load a kernel directly.

```sh
cd debian-11-bullseye-amd64
# Let's assume `make install` has already been run!
make KERNEL=/path/to/linux/source/arch/arm64/boot/Image
```

Note that recipes that don't support this out-of-the-box will give you
a helpful error message and some clues on how to fix it!
