#!/usr/bin/expect
        spawn scp  /data/AI_Black_Box_Server/results/Detection_results.mp4 nano2@210.125.145.134:~/
        # spawn scp  /data/AI_Black_Box_Server/DisplayVideo.html nano2@210.125.145.134:~/
        expect "password:"
        send 1\n;
        interact
        