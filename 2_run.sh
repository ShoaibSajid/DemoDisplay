#!/usr/bin/expect
        # spawn scp  /data/AI_Black_Box_Server/results/Detection_results.avi 210.125.150.52:c:/
        # C:\Users\Aroona Ayub\Desktop\DisplayVideo.html
        # spawn ssh "aroona ayub@210.125.150.52" "C:/Users/Aroona Ayub/Desktop/DisplayVideo.html"
        # spawn ssh "aroona ayub@210.125.150.52" "start %windir%\explorer.exe “C:\DisplayVideo.html"
        spawn ssh "nano2@210.125.145.134" "export DISPLAY=:0;\
        chromium-browser --disable-gpu DisplayVideo.html;\
        sleep 10;\
        pkill chromium;\
        rm -rf Detection_results.mp4"
        expect "password:"
        send 1\n;
        interact
        