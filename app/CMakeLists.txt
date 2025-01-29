cmake_minimum_required(VERSION 3.1...3.29)

project(
  FFmpegTestApp
  VERSION 1.0
  LANGUAGES CXX)

if (CMAKE_BUILD_TYPE MATCHES Debug)
  add_definitions (-DDEBUG)
endif (CMAKE_BUILD_TYPE MATCHES Debug)

if (CMAKE_BUILD_TYPE MATCHES Release)
  add_definitions (-DNDEBUG)
endif (CMAKE_BUILD_TYPE MATCHES Release)

set(FFMPEG_BASE ${CMAKE_CURRENT_SOURCE_DIR}/../ffmpeg_build)
set(FFMPEG_LIBS_BASE ${FFMPEG_BASE}/lib)
set(FFMPEG_INCLUDES_BASE ${FFMPEG_BASE}/include)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "-D__STDC_CONSTANT_MACROS")



find_path(AVCODEC_INCLUDE_DIR libavcodec/avcodec.h HINTS "${FFMPEG_INCLUDES_BASE}")
find_library(AVCODEC_LIBRARY avcodec HINTS "${FFMPEG_LIBS_BASE}")

find_path(AVFORMAT_INCLUDE_DIR libavformat/avformat.h HINTS "${FFMPEG_INCLUDES_BASE}")
find_library(AVFORMAT_LIBRARY avformat HINTS "${FFMPEG_LIBS_BASE}")

find_path(AVUTIL_INCLUDE_DIR libavutil/avutil.h HINTS "${FFMPEG_INCLUDES_BASE}")
find_library(AVUTIL_LIBRARY avutil HINTS "${FFMPEG_LIBS_BASE}")

find_path(AVDEVICE_INCLUDE_DIR libavdevice/avdevice.h HINTS "${FFMPEG_INCLUDES_BASE}")
find_library(AVDEVICE_LIBRARY avdevice HINTS "${FFMPEG_LIBS_BASE}")
find_path(AVDEVICE_INCLUDE_DIR libavdevice/avfilter.h HINTS "${FFMPEG_INCLUDES_BASE}")
find_library(AVFILTER_LIBRARY avfilter HINTS "${FFMPEG_LIBS_BASE}")

find_library(AOM_LIBRARY aom HINTS "${FFMPEG_LIBS_BASE}")
find_library(SvtAv1Enc_LIBRARY SvtAv1Enc HINTS "${FFMPEG_LIBS_BASE}")
find_library(DAV_LIBRARY dav1d HINTS "${FFMPEG_LIBS_BASE}")
find_library(ZLIB_LIBRARY NAMES z zlib REQUIRED)

find_library(FDK_LIBRARY fdk-aac HINTS "${FFMPEG_LIBS_BASE}")
find_library(OPUS_LIBRARY opus HINTS "${FFMPEG_LIBS_BASE}")
find_library(POSTPROC_LIBRARY postproc HINTS "${FFMPEG_LIBS_BASE}")
find_library(SWRESAMPLE_LIBRARY swresample HINTS "${FFMPEG_LIBS_BASE}")
find_library(VPX_LIBRARY vpx HINTS "${FFMPEG_LIBS_BASE}")
find_library(X264_LIBRARY x264 HINTS "${FFMPEG_LIBS_BASE}")
find_library(X265_LIBRARY x265 HINTS "${FFMPEG_LIBS_BASE}")
find_library(SWSCALE_LIBRARY swscale HINTS "${FFMPEG_LIBS_BASE}")

find_library(VA_LIBRARY va)
find_library(X11_LIBRARY X11)
find_library(GNUTLS_LIBRARY gnutls)

set(FFMPEG_DEP_LIBS
  postproc x264 vorbis vorbisenc vorbisfile mp3lame fdk-aac freetype ogg theora theoradec theoraenc vpx opus z va dl
  ${ZLIB_LIBRARY} 
  ${X11_LIBRARY} 
  ${VA_LIBRARY} 
  ${AOM_LIBRARY} 
  ${SvtAv1Enc_LIBRARY} 
  ${DAV_LIBRARY} 
  ${FDK_LIBRARY} 
  ${OPUS_LIBRARY} 
  ${POSTPROC_LIBRARY}
  ${SWRESAMPLE_LIBRARY} 
  ${VPX_LIBRARY} 
  ${X264_LIBRARY} 
  ${X265_LIBRARY}
  ${GNUTLS_LIBRARY}
)

set(DIRECT_LINKS
  ${FFMPEG_LIBS_BASE}/libSvtAv1Enc.a
  ${FFMPEG_LIBS_BASE}/libaom.a
  ${FFMPEG_LIBS_BASE}/libavcodec.a
  ${FFMPEG_LIBS_BASE}/libavdevice.a
  ${FFMPEG_LIBS_BASE}/libavfilter.a
  ${FFMPEG_LIBS_BASE}/libavformat.a
  ${FFMPEG_LIBS_BASE}/libavutil.a
  ${FFMPEG_LIBS_BASE}/libdav1d.a
  ${FFMPEG_LIBS_BASE}/libfdk-aac.a
  ${FFMPEG_LIBS_BASE}/libopus.a
  ${FFMPEG_LIBS_BASE}/libpostproc.a
  ${FFMPEG_LIBS_BASE}/libswresample.a
  ${FFMPEG_LIBS_BASE}/libswscale.a
  ${FFMPEG_LIBS_BASE}/libvpx.a
  ${FFMPEG_LIBS_BASE}/libx264.a
  ${FFMPEG_LIBS_BASE}/libx265.a
)
message("X11: ${X11_LIBRARY}")
message("aom: ${AOM_LIBRARY}")
message("zlib: ${ZLIB_LIBRARY}")
message("SvtAv1Enc: ${SvtAv1Enc_LIBRARY}")
message("dav1d: ${DAV_LIBRARY}")

message("fdk: ${FDK_LIBRARY}")
message("opus: ${OPUS_LIBRARY}")
message("postproc: ${POSTPROC_LIBRARY}")
message("swresample: ${SWRESAMPLE_LIBRARY}")
message("vpx: ${VPX_LIBRARY}")
message("x264: ${X264_LIBRARY}")
message("x265: ${X265_LIBRARY}")

message("avcodec: ${AVCODEC_LIBRARY}")
message("avformat: ${AVFORMAT_LIBRARY}")
message("avutil: ${AVUTIL_LIBRARY}")
message("avdevice: ${AVDEVICE_LIBRARY}")
message("avfilter: ${AVFILTER_LIBRARY}")
message("va: ${VA_LIBRARY}")

message("DIRECT_LINKS: ${DIRECT_LINKS}")
message("FFMPEG_DEP_LIBS: ${FFMPEG_DEP_LIBS}")

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

set(SOURCE
   ${SOURCE}
   ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
)
set(HEADERS
   ${HEADERS}
   ${CMAKE_CURRENT_SOURCE_DIR}/src/ffmpeg_inc.h
   ${CMAKE_CURRENT_SOURCE_DIR}/src/stdafx.h
)


include_directories(${FFMPEG_INCLUDES_BASE})
link_directories(${FFMPEG_LIBS_BASE})
add_executable(FFmpegTestApp ${HEADERS} ${SOURCE})
target_include_directories(FFmpegTestApp PUBLIC  ${AVCODEC_INCLUDE_DIR} ${AVFORMAT_INCLUDE_DIR} ${AVUTIL_INCLUDE_DIR} ${AVDEVICE_INCLUDE_DIR})
target_link_libraries(FFmpegTestApp PUBLIC ${DIRECT_LINKS})
target_link_libraries(FFmpegTestApp PUBLIC ${AVCODEC_LIBRARY} ${AVFORMAT_LIBRARY} ${AVDEVICE_LIBRARY} ${AVUTIL_LIBRARY} ${SWSCALE_LIBRARY})
target_link_libraries(FFmpegTestApp PUBLIC ${FFMPEG_DEP_LIBS})
target_link_libraries(FFmpegTestApp PRIVATE Threads::Threads)
#target_link_libraries(FFmpegTestApp ${CMAKE_SOURCE_DIR}/libbingitup.a)