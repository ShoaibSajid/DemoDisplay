#!/bin/sh
i=0
while i==0:
    do
        echo 'Checking again.'
        #rm /home/msis/Shoaib/AI_Black_Box_Server/data/20210608-173310.mp4
        find $(pwd)"/data" | sort -k 2 > old_files.txt
        # rm -r data
        # mkdir data
        # sudo rsync -avze  "ssh -i ./LightsailDefaultKey-ap-northeast-2.pem"  "ubuntu@15.165.215.123:/home/ubuntu/remote_recording/*" ./data > dump.txt
        scp -i ./LightsailDefaultKey-ap-northeast-2.pem "ubuntu@15.165.215.123:/home/ubuntu/remote_recording/*" ./data > dump.txt
        find $(pwd)"/data" | sort -k 2 > new_files.txt
        if [ -z "$(diff old_files.txt new_files.txt  -x "txt" | grep mp4 | cut -c 3-)" ]
        then
            echo "No new file found"
            echo " "
            # mplayer -fs /data/AI_Black_Box_Server/results/Detection_results.avi
        else
            echo "New file found  --> "$(diff old_files.txt new_files.txt  -x "txt" | grep mp4 | cut -c 3-)
            sleep 5
            echo "Copying again"
            scp -i ./LightsailDefaultKey-ap-northeast-2.pem "ubuntu@15.165.215.123:/home/ubuntu/remote_recording/*" ./data > dump.txt
            echo "Running YOLO"
            ~/Aroona/Codes/Yolo/darknet/./darknet detector demo ~/Aroona/Codes/Yolo/darknet/cfg_bdd/bdd.data ~/Aroona/Codes/Yolo/darknet/cfg_bdd/yolov4_608_384.cfg ~/Aroona/Codes/Yolo/darknet/backup/bdd_608x384_yolov4_35k/yolov4_final.weights -thresh 0.5 $(diff old_files.txt new_files.txt  -x "txt" | grep mp4 | cut -c 3-) -dont_show -out_filename results/Detection_results.avi
            echo "Convert AVI to MP4"
            python /data/AI_Black_Box_Server/08_DisplayVideo.py           
            echo "Copy video to end-device."
            /home/msis/Aroona/Codes/./1_copy.sh
            echo "Run the webpage on end-device"
            /home/msis/Aroona/Codes/./2_run.sh
            echo "Move old files from database into backup."
            mv /data/AI_Black_Box_Server/results/Detection_results* /data/AI_Black_Box_Server/old_data            
            # echo "Play on Server"
            # mplayer /data/AI_Black_Box_Server/results/Detection_results.avi
            echo "Remove old video recordings from AWS Server"
            ssh -i ./LightsailDefaultKey-ap-northeast-2.pem "ubuntu@15.165.215.123" "find /home/ubuntu/remote_recording -mmin +2 -type f -exec rm -fv {} \;"
    fi
done
