#!/bin/bash
miniature.sh $1
convert_sd.sh $1 > /dev/null &
convert_hd.sh $1 > /dev/null &