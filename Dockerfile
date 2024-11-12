FROM debian:bookworm-slim AS build

RUN apt update \
    && apt install -y \
      git autoconf automake autotools-dev \
      curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk \
      build-essential bison flex texinfo gperf libtool \
      patchutils bc zlib1g-dev libexpat-dev

RUN git clone -b "releases/gcc-14" --depth=1 -c advice.detachedHead=false "https://github.com/gcc-mirror/gcc" /git_gcc
RUN git clone -b "2024.10.28" --depth=1 -c advice.detachedHead=false https://github.com/riscv/riscv-gnu-toolchain /riscv-gnu-toolchain
RUN cd /riscv-gnu-toolchain && git rm qemu dejagnu llvm glibc spike && git submodule update --init --recursive

WORKDIR /riscv-gnu-toolchain
RUN ./configure \
      --prefix=/opt/riscv \
      --with-gcc-src=/git_gcc \
      --with-arch=rv32ima_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb \
      --with-multilib-generator="rv32ima_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb-ilp32--;rv32imac_zicsr_zifencei_zba_zbb_zbs_zbkb-ilp32--" \
      --with-abi=ilp32
RUN make -j $(nproc)

FROM debian:bookworm-slim

ENV RISCV=/opt/riscv
ENV PATH=$RISCV/bin:$PATH

COPY --from=build /opt/riscv /opt/riscv

RUN apt update \
    && apt install -y git python3 make cmake gcc g++ \
    && apt clean

RUN cd /opt/riscv/bin && ln /opt/riscv/bin/riscv32-unknown-elf-gcc pico_riscv_gcc