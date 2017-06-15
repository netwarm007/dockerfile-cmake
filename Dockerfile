FROM tim03/gcc
LABEL maintainer Chen, Wenli <chenwenli@chenwenli.com＞

WORKDIR /usr/local/src
RUN \
  curl https://cmake.org/files/v3.8/cmake-3.8.2.tar.gz | tar zxvf -
RUN \
  cd cmake-3.8.2 && \
  mkdir build && cd build && \
  ../bootstrap --prefix=/usr/local && \
  make && make install && cd .. && rm -rf build

CMD /usr/local/bin/cmake
