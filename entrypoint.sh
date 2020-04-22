#!/bin/bash
set -e
echo "***** Entry Point ***"
export AVD_NAME="WappAVD"
export QTWEBENGINE_DISABLE_SANDBOX=1
# Create the kvm node (required --privileged)
if [ ! -e /dev/kvm ]; then
    echo "KVM not found trying to create"
    mknod /dev/kvm c 10 $(grep '\<kvm\>' /proc/misc | cut -f 1 -d' ')
fi
echo "Nice, there is KVM"

# Install Platforms and SystemImages
${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-24" "system-images;android-24;default;x86_64" --sdk_root=${ANDROID_HOME}

# Create WappAVD, if it doesn't already exist
AVD_NAME="WappAVD"
echo "Searching ${AVD_NAME}..."
search() {
  ${ANDROID_HOME}/tools/bin/avdmanager list avd | grep ${AVD_NAME} | wc -l
}
FOUND=$(search)
if [ $FOUND -eq "0" ]; then
    echo "Creating ${AVD_NAME}..."
    echo "no" | ${ANDROID_HOME}/tools/bin/avdmanager create avd -n ${AVD_NAME} -k "system-images;android-24;default;x86_64" -c 1000M
    echo 'hw.keyboard=yes' >> /root/.android/avd/${AVD_NAME}.avd/config.ini # enable hardware keyboard input
    echo 'runtime.network.latency=none' >> /root/.android/avd/${AVD_NAME}.avd/config.ini
    echo 'runtime.network.speed=full' >> /root/.android/avd/${AVD_NAME}.avd/config.ini
    echo 'vm.heapSize=48' >> /root/.android/avd/${AVD_NAME}.avd/config.ini

else
    echo "Pixel AVD already exists"
fi
# Start Android emulator and install WhatsApp
INIT="${ANDROID_HOME}/tools/emulator -avd ${AVD_NAME} -gpu off -no-audio -no-boot-anim -netfast"
INIT="xterm"
xpra start --pulseaudio=no --speaker=disable --bell=no --microphone=off --bind-tcp=0.0.0.0:10000 --start="${INIT}"
bash install-wa.sh & adb -a server nodaemon
