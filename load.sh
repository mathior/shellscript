#!/bin/bash

# assume topic file format: one line contains a dmoz topic 
# and a url separated by a tab character, e.g.
# Top/Arts/Animation    http://animation.about.com/

if [ $# -lt 1 ];
then
    echo 'usage: ' $0 'topic.list'
fi

TOPICLIST=$1
COUNTER="0"
FILENAMEPATTERN="0000000000"
LOGFILE="$1.download.log"
# remove old logfile if there is one
rm -f $LOGFILE

echo $TOPICLIST

while read LINE;
do
    OUTPUT=$FILENAMEPATTERN$COUNTER;
    OUTPUT=${OUTPUT: -10}.html;
    COUNTER=$(expr $COUNTER + 1);
    # i don't know but tab delimiter degenerated to a space in while read LINE
    TOPIC=$(echo $LINE | cut -d ' ' -f 1); 
    URL=$(echo $LINE | cut -d ' ' -f 2);
    echo -e "$OUTPUT\t$TOPIC\t$URL" >> $LOGFILE;
    echo "downloading $URL...";
    curl --connect-timeout 23 -m 60 --retry 3 -L -s -o $OUTPUT "$URL";
done < $TOPICLIST

