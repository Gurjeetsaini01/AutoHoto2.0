# AutoHoto2.0
Powershell script to turn on windows Hotspot Automatically on pc sign in or startup. with cool looking Notification badge to verify hotspot's turn on status.

Usage -
 *  simply download/save the AutoHoto2.0.ps1 file on your windows pc.
 *   Right click and Run it as Administrator
 * Done !
      
It will make a hotspot with name MyAutoHotspot and default password will be 123qwe123
 
* You can change it if wanted by using below command in CMD
     
       NETSH WLAN set hostednetwork mode=allow ssid=MyAutoHotspot key=passwordhere
 
 
* To make sure for the first time and to check hostpot status run this command in cmd. (you sign out and sign in back     before using this command to test.

       NETSH wlan show hostednetwork
 
 * if you want stop it for some reason then use
     
        NETSH wlan stop hostednetwork
       
 * To Remove permanently 
       simply delete the task in windows 'Task Scheduler'
    
    
    
       
