FROM tim03/curl:7.52.1
LABEL maintainer Chen, Wenli <chenwenli@chenwenli.com>

WORKDIR /usr/src
ADD http://www.cmake.org/files/v3.7/cmake-3.7.2.tar.gz .
COPY md5sums .
RUN md5sum -c md5sums
COPY --from=tim03/libarchive:3.2.2 /usr/include/archive.h /usr/include/
COPY --from=tim03/libarchive:3.2.2 /usr/include/archive_entry.h /usr/include/
COPY --from=tim03/libarchive:3.2.2 /usr/lib/libarchive.* /usr/lib/
RUN \
	tar xvf cmake-3.7.2.tar.gz && \
	mv -v cmake-3.7.2 cmake && \
	pushd cmake && \
	sed -i '/CMAKE_USE_LIBUV 1/s/1/0/' CMakeLists.txt     && \
	sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake && \
	./bootstrap --prefix=/usr       \
	            --system-libs       \
	            --mandir=/share/man \
	            --no-system-jsoncpp \
	            --docdir=/share/doc/cmake-3.7.2 && \
	make -j"$(nproc)" && \
	(bin/ctest -j"$(nproc)" -O ../cmake-3.7.2-test.log || true) && \
	make install && \
	popd && \
	rm -rf cmake

