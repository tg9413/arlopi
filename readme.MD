## Still Work in progress, huge shoutout to the TeslaUSB project for the inspiration and code samples

****


Due to Arlo removing the 7 days free cloud storage for the Arlo Pro camera due to EOL, this project is aim to use the local stoage provide by the base in combine with Raspberry Pi Zero W to enable remote access of the clips capture by the camera. The project is still in just a proof of concept stage, and the setup process might be varies quiet differently due to the Arlo Base station itself is rather picky on the USB device connected to it as well. I will be going over some of the common issues I saw during testing in the section after the setup instruction.


Raspberry Pi Zero 2, Pi4 will also work. Due to the lack of hardware, and the project is still in poc stage, the scripts has a lot of hardcoded parameter and test specifically against the original RPiZero W.

Also huge shoutout to the teslausb project, this project is inspired by the wonderful work they've done.

### Hardware Requirement:
    
    . Raspberry Pi Zero W 
    . Micro B to A USB cable, with Data 
    . Power supply for Raspberry Pi Zero W, and optionally a case


****
### Installation Steps:
1. Flash image with [Raspberry Pi Imagr](https://www.raspberrypi.com/software/)
     - Choose Raspberry Pi OS Lite (32-Bit) from Operating System <br> 

    In Setting 
     - Set hostname, this will be use for Samba / SSH access
     - Enable SSH acccess
     - Input username / password to be used with SSH and Samba access
     - Enable Wifi, enter SSID, Wifi password
     - Select Country as US, and local based on your location, then click flash
<br>
<br>

2. Once flash finished, remove the sd card from PC and plug it into the pi, and plug in power. There are 2 micro USB port on the raspberry pie zero w, make sure the power goes into the one on the edge labeled PWR. Either port will power the pi up, but only the port in the middle labeled as USB will be able to act as an USB host for the Arlo base station to connect. 

<br>
<br>

3. Once the pi is fully booted up, SSH into the pi
 ```
 #find out your ip for the pi from your router's device list or if you set a hostname in the previouse
 #step, you can login with the hostname. e.g if hostname is arlo-pi, username pi

 ssh pi@arlo-pi.local
 ```
 
 <br>
 <br>
 
4. Once logged into terminal, run the following commands to clone the repo and setup the pi. The pi will reboot when the setup is finished.
 ```
 cd /home/pi
 sudo apt-get install git -y
 git clone https://github.com/tg9413/arlopi.git
 cd arlopi/setup
 sh setup.sh
 ```
<br>
<br>

5. When the pi fully reboot, connect the middle micro usb port to Arlo Basestation, and start the app to enable local storage. Settings > My Devices > Name of the base Station > Storage Settings. Once setup, you should be able to see the clips captured on the local storage via Samba with couple caveats I will be going over below




