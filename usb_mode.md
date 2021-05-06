# Instructions to use USB Mode
- Enable adb-debugging on your device, [instructions here](#[headers](https://developer.android.com/studio/command-line/adb.html#Enabling)).
  
- Download the open source [gnirehtet server](#https://github.com/Genymobile/gnirehtet/releases/download/v2.5/gnirehtet-rust-win64-v2.5.zip). (1 MB) and extract it 
  
- Download [Android platform tools](#https://dl.google.com/android/repository/platform-tools-latest-windows.zip) (8 MB), and extract the following files to the gnirehtet folder:
   - adb.exe
   - AdbWinApi.dll
   - AdbWinUsbApi.dll
  
- Plug in your Android device via USB - Double-click on "gnirehtet-run.cmd" in your gnirehtet folder.
  
- Your device will ask you whether you want to connect to the VPN connection Gnirehtet is creating for you Say OK.
  
- Press Windows key -> "Command Prompt" -> type "ipconfig" -> find your IPv4 address
Now start up OpenTrack, set UDP as input (check its port), start up TrackAR, enter your IPv4 address and port and hit Start!