#!/bin/bash

MAKEFLAGS=""
BGPROCESSFILE="$2"

if [ "$1" == "clean" ]
then
  if [ -d .libs ]
  then
    rm -r .libs
  fi
  make distclean
fi

if [ $NUMBER_OF_PROCESSORS > 1 ]; then
  MAKEFLAGS=-j$NUMBER_OF_PROCESSORS
fi

if [ ! -d .libs ]; then
  mkdir .libs
fi

# add --enable-debug (remove --disable-debug ofc) to get ffmpeg log messages in xbmc.log
# the resulting debug dll's are twice to fourth time the size of the release binaries

OPTIONS="
--enable-shared \
--enable-memalign-hack \
--enable-gpl \
--enable-w32threads \
--enable-postproc \
--enable-zlib \
--disable-static \
--disable-altivec \
--disable-muxers \
--disable-encoders \
--disable-debug \
--disable-ffplay \
--disable-ffserver \
--disable-ffmpeg \
--disable-ffprobe \
--disable-devices \
--disable-crystalhd \
--enable-muxer=spdif \
--enable-muxer=adts \
--enable-encoder=ac3 \
--enable-encoder=aac \
--enable-runtime-cpudetect \
--enable-avfilter \
--disable-doc"

./configure --extra-cflags="-fno-common -Iinclude-xbmc-win32/dxva2 -DNDEBUG" --extra-ldflags="-L/xbmc/system/players/dvdplayer" ${OPTIONS} &&
 
make $MAKEFLAGS &&
cp lib*/*.dll .libs/ &&
cp .libs/avcodec-53.dll /xbmc/system/players/dvdplayer/ &&
cp .libs/avformat-53.dll /xbmc/system/players/dvdplayer/ &&
cp .libs/avutil-51.dll /xbmc/system/players/dvdplayer/ &&
cp .libs/avfilter-2.dll /xbmc/system/players/dvdplayer/ &&
cp .libs/postproc-52.dll /xbmc/system/players/dvdplayer/ &&
cp .libs/swresample-0.dll /xbmc/system/players/dvdplayer/ &&
cp .libs/swscale-2.dll /xbmc/system/players/dvdplayer/

#remove the bgprocessfile for signaling the process end
echo deleting $BGPROCESSFILE
rm $BGPROCESSFILE
