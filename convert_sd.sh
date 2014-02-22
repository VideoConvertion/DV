ffmpeg -i $1 -acodec libfaac -ab 128k -vcodec libx264 -level 21 -refs 2 -b 345k -bt 345k -threads 1 -s 640x360 $1"_640x360p.mp4"
php "/home/www/DreamVids/utils/state.php" $1 "sd"
ffmpeg -i $1 -c:v libvpx -minrate 345k -maxrate 345k -b:v 345k -c:a libvorbis -b:a 128k -s 640x360 $1"_640x360p.webm"
php "/home/www/DreamVids/utils/state.php" $1 "sd"