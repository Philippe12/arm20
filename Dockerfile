FROM debian:jessie

# The cross-compiling emulator
RUN apt-get update && apt-get install -y \
  qemu-user \
  qemu-user-static \
  unzip make curl

ENV CROSS_TRIPLE=arm-linux-androideabi
ENV CROSS_ROOT=/usr/${CROSS_TRIPLE}
ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++ \
    LD=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld

ENV ANDROID_NDK_REVISION 10e

RUN mkdir -p /build 



#COPY android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip /build/
RUN cd /build && curl -O https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip 
#ADD https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip /build/android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip


RUN apt-get install -y file

RUN cd /build && \
    unzip ./android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip && \
    cd android-ndk-r${ANDROID_NDK_REVISION} && \
    /bin/bash ./build/tools/make-standalone-toolchain.sh \
      --arch=arm \
      --system=linux-x86_64 \
      --ndk-dir=/build/android-ndk-r${ANDROID_NDK_REVISION} \
      --platform=android-16 \
      --stl=stlport \
      --install-dir=${CROSS_ROOT} && \
    cd / && \
    rm -rf /build && \
    find ${CROSS_ROOT} -exec chmod a+r '{}' \; && \
    find ${CROSS_ROOT} -executable -exec chmod a+x '{}' \;


#ENV DEFAULT_DOCKCROSS_IMAGE dockcross/android-arm

#COPY Toolchain.cmake ${CROSS_ROOT}/
#ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/Toolchain.cmake
RUN apt-get install -y upx git optipng zip php5-cli default-jre-headless

RUN apt-get install -y python
