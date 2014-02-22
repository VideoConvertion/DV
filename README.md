#DV Doc Convertion
==
##First

###Code explain :

####Convert.sh


```bash
#!/bin/bash
miniature.sh $1
convert_sd.sh $1 > /dev/null &
convert_hd.sh $1 > /dev/null &
```

convert.sh est le scrit executer par php via le code suivant :

dans m_upload.php fonction addDbInfos():
```php
convert(getcwd().'/'.$video->getPath());
```
qui renvoie à la fonction convert() de functions.php

```php
function convert($input)
{
	system('sudo -u www-data convert.sh '.$input.'');
}
```
convert.sh prend donc comme arg, le fullpath de la video à convertir.

ensuite, il lance un thread de convertion HD et un autre de SD, 'convert_sd.sh' et 'convert_hd.sh'

####convert_sd.sh

```bash
ffmpeg -i $1 -acodec libfaac -ab 128k -vcodec libx264 -level 21 -refs 2 -b 345k -bt 345k -threads 1 -s 640x360 $1"_640x360p.mp4"
php "/home/www/DreamVids/utils/state.php" $1 "sd"
ffmpeg -i $1 -c:v libvpx -minrate 345k -maxrate 345k -b:v 345k -c:a libvorbis -b:a 128k -s 640x360 $1"_640x360p.webm"
php "/home/www/DreamVids/utils/state.php" $1 "sd"
```

rentrons dans le vif du sujet :p 

la première ligne :

```bash
ffmpeg -i $1 -acodec libfaac -ab 128k -vcodec libx264 -level 21 -refs 2 -b 345k -bt 345k -threads 1 -s 640x360 $1"_640x360p.mp4"
```

expliquation : 

- "-i $1" <=> définie le fichier a convertir.
- "-acodec libfaac" <=> défini le codec audio, ici libfaac pour aac.
- "-ab 128k" <=> ici, le bitrate audio, donc 128kb/s
- "-vcodec libx264" <=> défini le codec video, ici libx264 pour mp4.
- "-b 345k -bt 345k" <=> bitrate video donc 345kb/s (sd)
- "-s 640x360" <=> le format video donc 640*360 (sd)
- " $1"_640x360p.mp4" " <=> le fichier de sortie.

la deuxième ligne :

```bash
php "/home/www/DreamVids/utils/state.php" $1 "sd"
```

expliquation :

exécute tout simplement le script php state.php avec comme argument, le fichier d'entrer(original) et la qualité.
je reviendrais sur state.php plus tard.

la troisième ligne :

```bash
ffmpeg -i $1 -c:v libvpx -minrate 345k -maxrate 345k -b:v 345k -c:a libvorbis -b:a 128k -s 640x360 $1"_640x360p.webm"
```

expliquation :

- "-i $1" <=> définie le fichier d'entrer
- a convertir.
- "-c:v libvpx" <=> défini le codec video, ici libvpx pour le webm.
- "-minrate 345k -maxrate 345k -b:v 345k" <=> bitrate video donc 345kb/s (sd).
- "-c:a libvorbis" défini le codec audio.
- "-b:a 128k" <=> ici, le bitrate audio, donc 128kb/s.
- "-s 640x360" <=> le format video donc 640*360 (sd).
- " $1"_640x360p.mp4" " <=> le fichier de sortie.

et bah la dernière ligne vous l'aurez compris ^^

####convert_hd.sh

le fichier convert_hd.sh est sensiblement le même que le convert_sd.sh, juste la qualité change.

constater par vous même :

HD:
```bash
ffmpeg -i $1 -acodec libfaac -ab 256k -vcodec libx264 -level 21 -refs 2 -b 3900k -bt 3900k -threads 1 -s 1280x720 $1"_1280x720p.mp4"
php "/home/www/DreamVids/utils/state.php" $1 "hd"
ffmpeg -i $1 -c:v libvpx -minrate 100k -maxrate 24M -b:v 3900k -c:a libvorbis -b:a 256k -s 1280x720 $1"_1280x720p.webm"
php "/home/www/DreamVids/utils/state.php" $1 "hd"
```

SD:
```bash
ffmpeg -i $1 -acodec libfaac -ab 128k -vcodec libx264 -level 21 -refs 2 -b 345k -bt 345k -threads 1 -s 640x360 $1"_640x360p.mp4"
php "/home/www/DreamVids/utils/state.php" $1 "sd"
ffmpeg -i $1 -c:v libvpx -minrate 345k -maxrate 345k -b:v 345k -c:a libvorbis -b:a 128k -s 640x360 $1"_640x360p.webm"
php "/home/www/DreamVids/utils/state.php" $1 "sd"
```

####miniature.sh

le fichier miniature.sh sert à créer une migniature de la video uploader.

```bash
ffmpeg -itsoffset -4 -i $1 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 120x90 -y $1".jpg"
```

expliquation :

- "-itsoffset -4" <=> récupere la 4ème image de la video
- "-i $1" <=> définie le fichier d'entrer
- "-vcodec mjpeg" <=> selectionne le codec mjpeg
- "-s 120x90" <=> la taille.


