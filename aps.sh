#!/bin/bash
#
# This script comes with ABSOLUTELY NO WARRANTY, use at own risk
# Copyright (C) 2012 Osiris Alejandro Gomez <osiux@osiux.com.ar>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# This scripts make a watermark in image using "CC Icons" font.
# Download cc-icons True-Type font for Creative Commons License
# http://mirrors.creativecommons.org/presskit/cc-icons.ttf
#
# REQUIRED: apt-get install graphviz ttf-inconsolata

TOTAL_CLOSED=0
TOTAL_OPEN=0

echo 'graph APs {'$'\n'
echo '  node [shape=plaintext, fontname=inconsolata, fontsize=10, fontcolor=black];'
echo '  edge [style=invis];'

echo '  OSiUX [label="osiux@buenosaireslibre.org",fontcolor=green,fontsize=28];'
echo '  ccbysa [label="cba",fontname="CC Icons",fontcolor=green,fontsize=26];'
echo '  OSiUX -- ccbysa [len="2.6"];'

egrep --color=auto -o "[a-h0-9:]{17}" aps.txt | sort -u >/tmp/mac.tmp

cat /tmp/mac.tmp | while read MAC
do
	LINE=$(grep $MAC aps.txt)
    MAX_LEVEL=$(echo $LINE | awk '{print $NF}' | sort -nr | head -1)
    MIN_LEVEL=$(echo $LINE | awk '{print $NF}' | sort -n | head -1)
	CLOSED=$(echo $LINE | egrep -o "(yes|no)" | head -1)
	SSID=$(echo $LINE | egrep -o "^[a-zA-Z0-9\/\&\@_\ \.\-]+\ ")
    NORMA=$(echo $LINE | egrep -o "\(B\+G\)" | head -1)

    LEN=$[100-$MAX_LEVEL]
    SIZE=27;

    if [ $LEN -ge 10 ];then SIZE=26;fi
    if [ $LEN -ge 20 ];then SIZE=24;fi
    if [ $LEN -ge 30 ];then SIZE=22;fi
    if [ $LEN -ge 40 ];then SIZE=20;fi
    if [ $LEN -ge 50 ];then SIZE=18;fi
    if [ $LEN -ge 60 ];then SIZE=16;fi
    if [ $LEN -ge 70 ];then SIZE=14;fi
    if [ $LEN -ge 80 ];then SIZE=12;fi
    if [ $LEN -ge 90 ];then SIZE=10;fi

    if [ $CLOSED = "yes" ]
    then
        COLOR=red
        TOTAL_CLOSED=$[$TOTAL_CLOSED+1]
    else
        COLOR=limegreen
        TOTAL_OPEN=$[$TOTAL_OPEN+1]
    fi

    BAL=$(echo $SSID | egrep -o buenosaireslibre)
    if [ "$BAL" = "buenosaireslibre" ]
    then
        COLOR=green
    fi

    D=1;

    if [ $LEN -ge 90 ];then D=10;fi
    if [ $LEN -ge 80 ];then D=9;fi
    if [ $LEN -ge 70 ];then D=8;fi
    if [ $LEN -ge 60 ];then D=7;fi
    if [ $LEN -ge 50 ];then D=6;fi
    if [ $LEN -ge 40 ];then D=5;fi
    if [ $LEN -ge 30 ];then D=4;fi
    if [ $LEN -ge 20 ];then D=3;fi
    if [ $LEN -ge 10 ];then D=2;fi

    echo 'OSiUX -- "'$MAC'" [len='$D'.'$LEN'];'
	echo '"'$MAC'"' '[label="'$SSID'",fontcolor='$COLOR',fontsize='$SIZE'];'

    echo $TOTAL_CLOSED >/tmp/closed.tmp
    echo $TOTAL_OPEN >/tmp/open.tmp
done

CLOSED=$(cat /tmp/closed.tmp)
OPEN=$(cat /tmp/open.tmp)
TOTAL=$[$CLOSED+$OPEN]

echo '  graph [bgcolor=black,fontcolor=white,fontname="inconsolata",fontsize=12,label="'$TOTAL' APs, '$CLOSED' closed, '$OPEN' open"]'$'\n'
echo $'\n'
echo '}'
