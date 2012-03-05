#!/bin/bash

TOTAL_CLOSED=0
TOTAL_OPEN=0

echo 'graph APs {'$'\n'
#echo '  overlap=scale';
echo '  node [shape=plaintext, fontname=inconsolata, fontsize=10, fontcolor=black];'
echo '  edge [style=invis];'

echo '  OSiUX [label="osiux@buenosaireslibre.org",fontcolor=green,fontsize=28];'

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
        #if [ "$NORMA" = "(B+G)" ]
        #then
            COLOR=red
        #else
        #    COLOR=hotpink
        #fi
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

    #if [ $LEN -gt 10 -a $CLOSED = "yes" ];then COLOR="red";fi
    #if [ $LEN -gt 20 -a $CLOSED = "yes" ];then COLOR="darksalmon";fi
    #if [ $LEN -gt 40 -a $CLOSED = "yes" ];then COLOR="firebrick";fi
    #if [ $LEN -gt 60 -a $CLOSED = "yes" ];then COLOR="coral";fi
    #if [ $LEN -gt 80 -a $CLOSED = "yes" ];then COLOR="indianred";fi
    #if [ $LEN -gt 90 -a $CLOSED = "yes" ];then COLOR="lightsalmon";fi

    #if [ $LEN -gt 10 -a $CLOSED = "no" ];then COLOR="green";fi
    #if [ $LEN -gt 20 -a $CLOSED = "no" ];then COLOR="darkgreen";fi
    #if [ $LEN -gt 40 -a $CLOSED = "no" ];then COLOR="mediumseagreen";fi
    #if [ $LEN -gt 60 -a $CLOSED = "no" ];then COLOR="darkgreen";fi
    #if [ $LEN -gt 80 -a $CLOSED = "no" ];then COLOR="mediumspringgreen";fi
    #if [ $LEN -gt 90 -a $CLOSED = "no" ];then COLOR="springgreen";fi

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

echo '  graph [bgcolor=black,fontcolor=white,fontname=inconsolata,fontsize=12,label="'$TOTAL' APs, '$CLOSED' closed, '$OPEN' open"]'$'\n'
echo $'\n'
echo '}'
