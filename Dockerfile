FROM ubuntu:18.04
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
  curl -L https://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz --output /tmp/clang.tar.xz && \
  echo "e74ce06d99ed9ce42898e22d2a966f71ae785bdf4edbded93e628d696858921a  /tmp/clang.tar.xz" | sha256sum -c && \
  tar -xvf /tmp/clang.tar.xz -C ${BOLOS_ENV} && \
  mv ${BOLOS_ENV}/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04 ${BOLOS_ENV}/clang-arm-fropi && \
  rm /tmp/clang.tar.xz

RUN echo "Install Ledger Nano S SDK" && \
  git clone https://github.com/LedgerHQ/nanos-secure-sdk.git ${BOLOS_SDK} && \
  cd ${BOLOS_SDK} && git checkout tags/nanos-1552

COPY ./bin/init /usr/local/bin/init

ENTRYPOINT ["init"]
