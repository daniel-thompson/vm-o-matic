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

Overriding default settings
---------------------------

vm-o-matic is just a Makefile system. Most of the settings can be
overridden from the command line (and most of the important ones use ?=
so the can also be set from the environment).

Try something like:

```sh
make VM_CPUS=16 VM_RAMSIZE_MB=16384 headless
```

Bridged networking
------------------

vm-o-matic contains logic to automatically allocate a local MAC address
(by hashing the hostname, the bridge name and the directory name) for
bridged networking.

Providing the bridge is listed in /etc/qemu/bridge.conf (e.g.
`allow br0`) then everything should work automatically:

```sh
make BRIDGE=br0
```

Note: *This feature may not work on all architectures since it relies on
PCIe to attached the network device. It has been tested in AArch64 and
x86-64.*


Kernel hacking
--------------

An defconfig kernel usually has enough compiled built in to do a minimal
boot (an arm64 one certainly does). For some recipes we can bypass
grub and load a kernel directly.

```sh
cd debian-11-bullseye-amd64
# Let's assume `make install` has already been run!
make KERNEL=/path/to/linux/source/arch/arm64/boot/Image
```

Note that recipes that don't support this out-of-the-box will give you
a helpful error message and some clues on how to fix it!
