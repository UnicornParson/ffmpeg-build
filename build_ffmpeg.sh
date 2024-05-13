#!/bin/bash
set -e
export FFBASE=`pwd`
rm -vf $FFBASE/ffmpeg_bin/ff*
cd $FFBASE/ffmpeg_orig

PATH="$FFBASE/ffmpeg_bin:$PATH" PKG_CONFIG_PATH="$FFBASE/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$FFBASE/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$FFBASE/ffmpeg_build/include" \
  --extra-ldflags="-L$FFBASE/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --bindir="$FFBASE/ffmpeg_bin" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libsvtav1 \
  --enable-libdav1d \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
PATH="$FFBASE/ffmpeg_bin:$PATH" make -j10
PATH="$FFBASE/ffmpeg_bin:$PATH" make install

