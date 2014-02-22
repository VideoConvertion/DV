ffmpeg -i $1 -acodec libfaac -ab 256k -vcodec libx264 -level 21 -refs 2 -b 3900k -bt 3900k -threads 1 -s 1280x720 $1"_1280x720p.mp4"
php "/home/www/DreamVids/utils/state.php" $1 "hd"
ffmpeg -i $1 -c:v libvpx -minrate 100k -maxrate 24M -b:v 3900k -c:a libvorbis -b:a 256k -s 1280x720 $1"_1280x720p.webm"
php "/home/www/DreamVids/utils/state.php" $1 "hd"