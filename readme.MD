## <p style="color:red">Still Work in progress. Huge shoutout to the TeslaUSB project for the inspiration and code samples.</p>

Disclaimer: I work full time as a full stack engineer and shell script is not my strong suit, so it might take a while for me to work things out elegantly. So don't count on it if this is something you must have to be able to stick with Arlo. I am doing this project just for the sheer rage that Arlo can just screw all their users without a blink of the eye. I take no response if the project fails work / capture / sync clips under any circumstance. You should consider how much value you put into your survalliance system, and is something without any sort of company support you want to rely on for your home security. 

****
Due to the EOL BS Arlo pulled on Jan 1st, 2023, some of the older devices that used to come with the 7 days free storage will no longer be supported. There are many ways Arlo can go about addressing the issue if they think they are losing money on storages such as open capability stream the video from user local storage with one last firmware update. But frankly, they probably just want to push user to purchase their subscriptions plans. 

This project is aim at giving the legacy users some ways to access the video clips stored on local storage without having to physically move the drive to a PC with some sort of SBC that has OTG usb capability. Currently tested and working on Raspberry Pi Zero W. Raspberry Pi Zero 2, Pi4 will also work. Due to the lack of hardware, I can't test them yet. Feel free to clone and make your own modification, or create pull request to consolidate the effort. 

### Hardware Requirement:
    
    . Raspberry Pi Zero W 
    . Micro B to A USB cable, with Data 
    . Power supply for Raspberry Pi Zero W, and optionally a case
    . 64GB Micro SD Card

### What's working so far
```
 . Video captured on the camera will be saved to local storage and save on host device
 . Host device have a samba server that will expose the video clips
```

### What's not ideal
```
 . There is 1min sync interval in between when the clip generated till available on Samba. This is to avoid potential data corruption with having two source accessing the same mount.
 
 . Same reason above, so we only expose 30GB out of the 64GB on the SD to Arlo, and rest act as sync backup for Samba to read from
 
 . Arlo will auto truncate clips when storage reaches 80% (24GB in this case), host machine itself doesn't have a mechanism to auto truncate the sync clips yet. This will come later when the core operation is stable. Advanced users can create their own cron scripts either on host or remote to deal with the truncation for now
 
 . Arlo base station is very senstive about flash drive selection, currently I only found 30GB configuration works. Other sizing options will have to spend some time into figure out why certain configuration doesn't get registered with the base station
 
 . Due to the same finiky behavior between Arlo base station and flash drives, when powering off the Rpi, make sure eject the drive from Arlo's app first, else there is very high chance the disk image may get corrupted. Synced clips will still be available on the host / sd card for backup / view, just the disk image itself will need to be wiped and recated
```

### What's coming
```
. A full flashable image to skip all the initial setup
. Web interface to view / manage clips (not sure if RPi Zero W has enough horse power for this while all other things going on)
. Web interface to adjust settings such as truncation interval, push clips to remote samba / cifs etc...

```


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
 sudo sh setup.sh
 ```
<br>
<br>

5. When the pi fully reboot, connect the middle micro usb port to Arlo Basestation. Now open the Arlo app to enable local storage. Settings > My Devices > Name of the base Station > Storage Settings
<br>
<br>

6. SSH back into the pi again following step 3, and create Samba user and password with the following commands, assuming user is pi, you can create a different user than the one you use to SSH into the pi.
```
sudo smbpasswd -a pi
```

7. Now you can add the Samba mount other service on your home network to expose the videos. Easist method is some media server like plex / jellyfin, HomeAssistant is also an option but that in itself is another whole topic




****
<br>
Money jar to save up for an RPi4 or some beer in the lonely night :)

Thank you!

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=J58W48P8U345G)