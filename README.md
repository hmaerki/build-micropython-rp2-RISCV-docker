# Docker image providing the RISCV compiler for the Raspberry Pi Pico rp2350

The container is used to build micropython but does not contain any dependency to micropython.

## Compiler version

Versions
* [Riscv toolchain](https://github.com/riscv/riscv-gnu-toolchain) is from branch `2024.10.28`.

This is the compiler binary

```bash
$ pico_riscv_gcc -dumpversion
14.2.1
```

## How to build Micropython for rp2350 RISCV using this docker container

```bash
git clone https://github.com/micropython
cd ports

mpbuild build --build-container micropython/build-micropython-rp2350riscv RPI_PICO2 RISCV
```

## Building the container

```bash
docker buildx build -f Dockerfile --tag micropython/build-micropython-rp2350riscv .
docker run -it --rm micropython/build-micropython-rp2350riscv
```

*Takes about 40min to build on my i7 notebook!*

Image size
```
docker images
REPOSITORY                          TAG       IMAGE ID       CREATED             SIZE
build-micropython-rp2350riscv       latest    be8b348eea27   6 minutes ago       2.71GB
```

The riscv toolchain in /opt/riscv is about 2GB.  
The interims multi-stage build image is about 22GB!

## Collected links which helped me to set up this container

### This docker image is based on

* The build instruction for the raspberry pi: [build-riscv-gcc.sh](https://github.com/raspberrypi/pico-sdk-tools/blob/main/packages/linux/riscv/build-riscv-gcc.sh)


### Links

* Install instructions taken from https://github.com/raspberrypi/pico-bootrom-rp2350 'Getting a RISC-V compiler'.
* https://github.com/kamiyaowl/riscv-gnu-toolchain-docker/blob/master/README.md
* https://learnk8s.io/blog/smaller-docker-images
* https://bernardnongpoh.github.io/posts/riscv
* https://hub.docker.com/r/coderitter/pulp-riscv-gnu-toolchain
* https://github.com/coderitter/pulp-riscv-gnu-toolchain-docker
* https://plctlab.org/aosp/create-a-minimal-android-system-for-riscv.html


### Compiled

* https://forums.raspberrypi.com/viewtopic.php?t=375135


### Raspberry

* https://github.com/raspberrypi/pico-sdk-tools/blob/main/packages/linux/riscv/build-riscv-gcc.sh
