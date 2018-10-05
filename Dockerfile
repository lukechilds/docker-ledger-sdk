FROM ubuntu:16.04
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

VOLUME ["/code"]
WORKDIR /code

ENV BOLOS_ENV /opt/bolos-env
ENV BOLOS_SDK /opt/bolos-sdk

RUN apt-get update

RUN apt-get install -y --no-install-recommends libc6-dev-i386 python python-pil curl ca-certificates bzip2 xz-utils git make

RUN echo "Create install directories" && \
  mkdir ${BOLOS_ENV} ${BOLOS_SDK}

RUN echo "Install custom gcc" && \
  curl -L https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q1-update/+download/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2 --output /tmp/gcc.tar.bz2 && \
  echo "217850b0f3297014e8e52010aa52da0a83a073ddec4dc49b1a747458c5d6a223  /tmp/gcc.tar.bz2" | sha256sum -c && \
  tar -xvf /tmp/gcc.tar.bz2 -C ${BOLOS_ENV} && \
  rm /tmp/gcc.tar.bz2

RUN echo "Install custom clang" && \
  curl -L https://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz --output /tmp/clang.tar.xz && \
  echo "8e920c166b00e7869cea443e305933cc410bd1b982c7c5dc56995b6cffb0586f  /tmp/clang.tar.xz" | sha256sum -c && \
  tar -xvf /tmp/clang.tar.xz -C ${BOLOS_ENV} && \
  mv ${BOLOS_ENV}/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04 ${BOLOS_ENV}/clang-arm-fropi && \
  rm /tmp/clang.tar.xz

RUN echo "Install Ledger Nano S SDK" && \
  git clone https://github.com/LedgerHQ/nanos-secure-sdk.git ${BOLOS_SDK} && \
  cd ${BOLOS_SDK} && git checkout tags/nanos-1421

COPY ./bin/init /usr/local/bin/init

ENTRYPOINT ["init"]
