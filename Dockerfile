FROM centos:8

RUN cd /etc/yum.repos.d && curl -O https://winswitch.org/downloads/CentOS/winswitch.repo && \
    yum repolist && yum -y update && \
    yum install -y dnf-plugins-core && \
    yum config-manager -y --set-enabled PowerTools && \
    yum install -y xpra xorg-x11-server-Xvfb xterm \
                   java-1.8.0-openjdk \
                   glibc.i686 glibc-devel.i686 libstdc++.i686 zlib-devel.i686 ncurses-devel.i686 \
                   libX11-devel.i686 libXrender.i686 libXrandr.i686 \
                   SDL2 libglvnd qt5-qtbase unzip pulseaudio-libs

# Configure Android SDK Environment
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_ROOT ${ANDROID_HOME}
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
ENV LD_LIBRARY_PATH ${ANDROID_HOME}/emulator/lib64:${ANDROID_HOME}/emulator/lib64/qt/lib

# Installing Android SDK Commandline tools
ARG CMD_TOOLS_VERSION="6200805"
RUN curl "https://dl.google.com/android/repository/commandlinetools-linux-${CMD_TOOLS_VERSION}_latest.zip" --output commandlinetools.zip && \
    unzip commandlinetools.zip -d $ANDROID_HOME && rm commandlinetools.zip

# Accept license and install required android SDK packages
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager "tools" "platform-tools" --sdk_root=${ANDROID_HOME}


EXPOSE 10000
EXPOSE 5037

ADD whatsapp.apk .
ADD install-wa.sh .
ADD entrypoint.sh .
CMD ./entrypoint.sh
