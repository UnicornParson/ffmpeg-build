#!/bin/bash
set -e
export FFBASE=`pwd`
mkdir -p ffmpeg_build
mkdir -p ffmpeg_bin

rm -rvf ffmpeg_build/*
rm -rvf ffmpeg_bin/*

cd ffmpeg_build
wget https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.bz2
tar xjvf nasm-2.16.01.tar.bz2
cd nasm-2.16.01
./autogen.sh
PATH="$FFBASE/ffmpeg_bin:$PATH" ./configure --prefix="$FFBASE/ffmpeg_build" --bindir="$FFBASE/ffmpeg_bin"
make
make install
echo "-------------- NASM OK --------------"


cd $FFBASE/ffmpeg_build
git clone --depth 1 https://code.videolan.org/videolan/dav1d.git
mkdir -p dav1d/build
cd dav1d/build
PATH="$FFBASE/ffmpeg_bin:$PATH" meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. --prefix "$FFBASE/ffmpeg_build" --libdir="$FFBASE/ffmpeg_build/lib"
ninja
ninja install
echo "-------------- libdav1d OK --------------"

cd $FFBASE/ffmpeg_build
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$FFBASE/ffmpeg_build" --disable-shared
make
make install
echo "-------------- fdk-aac OK --------------"

cd $FFBASE/ffmpeg_build
git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git
mkdir -p SVT-AV1/build
cd SVT-AV1/build
PATH="$FFBASE/ffmpeg_bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFBASE/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF ..
PATH="$FFBASE/ffmpeg_bin:$PATH" make
make install
echo "-------------- AV1 OK --------------"

cd $FFBASE/ffmpeg_build
git clone --depth 1 https://aomedia.googlesource.com/aom
mkdir -p aom_build
cd aom_build
PATH="$FFBASE/ffmpeg_bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFBASE/ffmpeg_build" -DENABLE_TESTS=OFF -DENABLE_NASM=on ../aom 
PATH="$FFBASE/ffmpeg_bin:$PATH" make
make install

echo "-------------- AOM OK --------------"

cd $FFBASE/ffmpeg_build
git clone --depth 1 https://github.com/xiph/opus.git
cd opus
./autogen.sh
./configure --prefix="$FFBASE/ffmpeg_build" --disable-shared
make
make install
echo "-------------- OPUS OK --------------"

cd $FFBASE/ffmpeg_build
wget -O x265.tar.bz2 https://bitbucket.org/multicoreware/x265_git/get/master.tar.bz2
tar xjvf x265.tar.bz2
cd multicoreware*/build/linux
PATH="$FFBASE/ffmpeg_bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFBASE/ffmpeg_build" -DENABLE_SHARED=off ../../source
PATH="$FFBASE/ffmpeg_bin:$PATH" make
make install
echo "-------------- libx265 OK --------------"


cd $FFBASE/ffmpeg_build
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
PATH="$FFBASE/ffmpeg_bin:$PATH" ./configure --prefix="$FFBASE/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
PATH="$FFBASE/ffmpeg_bin:$PATH" make
make install
echo "-------------- libvpx OK --------------"


cd $FFBASE/ffmpeg_build
git clone --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
PATH="$FFBASE/ffmpeg_bin:$PATH" PKG_CONFIG_PATH="$FFBASE/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$FFBASE/ffmpeg_build" --bindir="$FFBASE/bin" --enable-static --enable-pic
PATH="$FFBASE/ffmpeg_bin:$PATH" make
make install
echo "-------------- libx264 OK --------------"




