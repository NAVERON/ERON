# Raspberry Pi3 software

# 安装python GPIO

## 下面的资料来自网站

[Raspberry Pi Hardware Programming with Python](http://radiostud.io/raspberrypi-hardware-interface-programming-python/)  

### RPi.GPIO Installation
Raspbian Wheezy
The RPi.GPIO module is installed by default in Raspbian. To make sure that it is at the latest version:
```
$ sudo apt-get update
$ sudo apt-get install python-rpi.gpio python3-rpi.gpio
```
To install the latest development version from the project source code library:
```
$ sudo apt-get install python-dev python3-dev
$ sudo apt-get install mercurial
$ sudo apt-get install python-pip python3-pip
$ sudo apt-get remove python-rpi.gpio python3-rpi.gpio
$ sudo pip install hg+http://hg.code.sf.net/p/raspberry-gpio-python/code#egg=RPi.GPIO
$ sudo pip-3.2 install hg+http://hg.code.sf.net/p/raspberry-gpio-python/code#egg=RPi.GPIO
```
To revert back to the default version in Raspbian:
```
$ sudo pip uninstall RPi.GPIO
$ sudo pip-3.2 uninstall RPi.GPIO
$ sudo apt-get install python-rpi.gpio python3-rpi.gpio
```
Other Distributions
It is recommended that you install RPi.GPIO using the pip utility as superuser (root):
```
# pip install RPi.GPIO
```

# 远程控制设备(数字信号)

具体过程参见网络  
[网页远程控制树莓派LED信号](https://www.pubnub.com/blog/2015-06-11-remote-control-raspberry-pi-leds-from-a-web-browser-ui/)  

# 模拟信号Analog signal

具体的网页  
[模拟信号案例](http://radiostud.io/sensing-analog-signal-raspberrypi/?utm_source=rpi-py-res-page&utm_medium=analoginput&utm_campaign=rpi-hwintf&doing_wp_cron=1525790331.7828059196472167968750)  




