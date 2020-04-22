# Docker Android AVD with WhatsApp pre-installed
A Docker image based on Centos that runs a lightweight Android Virtual Device.


## Deployment

`docker-compose up --build`

## Access Xpra

Visit `localhost:10000`

## Further Development

I'd like to stream a VNC feed via the `v4l2loopback` kernel module into the Android AVD... WIP. This would allow one to scan WhatsApp web barcodes remotely.

## Acknowledgements

* [tracer0tong/android-emulator](https://github.com/tracer0tong/android-emulator)
* [fcwu/docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop)
* [butomo1989/docker-android](https://github.com/butomo1989/docker-android)
