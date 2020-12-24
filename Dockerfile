FROM ubuntu:18.04
LABEL maintainer="hiroaki-santo"

RUN apt update && apt install -y git \
  clang-9 libc++-9-dev libc++abi-9-dev cmake ninja-build \
  libz-dev libpng-dev libjpeg-dev libxrandr-dev libxinerama-dev libxcursor-dev \
  python3-dev python3-distutils python3-setuptools \
  python3-pytest python3-pytest-xdist python3-numpy \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV CC=clang-9
ENV CXX=clang++-9

RUN git clone --recursive https://github.com/mitsuba-renderer/mitsuba2.git /mitsuba2

WORKDIR /mitsuba2
RUN git checkout fe2a1bd78e3916fccb8a3457e8b552e53f9c32d2 && git submodule update
ADD mitsuba.conf.cpu mitsuba.conf 
RUN mkdir build && cd build && cmake -GNinja -DPYTHON_EXECUTABLE=$(which python) .. && ninja

ENV PYTHONPATH=/mitsuba2/dist/python:/mitsuba2/build/dist/python:$PYTHONPATH
ENV PATH=/mitsuba2/dist:/mitsuba2/build/dist:$PATH
