FROM ubuntu:latest

RUN apt update \
  && apt install -y \
    git \
    podman \
    make \
    meson \
    cpio \
    gzip \
    bison \
    rsync \
    cmake \
    pkg-config \
    golang \
    xz-utils \
    gperf \
    dosfstools \
    mtools \
    fdisk

WORKDIR /workspace

RUN git clone https://github.com/EmilyShepherd/kiOS.git

COPY ./bootpart /workspace/kiOS/bootpart
COPY ./datapart /workspace/kiOS/datapart

WORKDIR /workspace/kiOS
RUN DATAPART_PATH=/workspace/kiOS/datapart BOOTPART_PATH=/workspace/kiOS/bootpart ./scripts/create-image