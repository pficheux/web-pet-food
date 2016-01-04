#!/bin/sh

echo MIME-Version: 1.0
echo Content-type: text/html
echo 

QUERY=`echo $QUERY_STRING | sed -e "s/=/='/g" -e "s/&/';/g" -e "s/+/ /g"  -e "s/$/'/"`
eval $QUERY

# display result

cat << EOF
<BODY>
Hanae mangera &agrave; :
<BR>
$PROG1_H H $PROG1_MN
<BR>
$PROG2_H H $PROG2_MN
<BR>
$PROG3_H H $PROG3_MN
<BR>
$PROG4_H H $PROG4_MN
<BODY>
EOF

# Update crontab

cat << EOF > /tmp/cron.tab
* * * * * crontab /tmp/cron.tab
$PROG1_MN $PROG1_H * * * echo "PROG1 \$(date)" >> /tmp/cron.txt
$PROG2_MN $PROG2_H * * * echo "PROG2 \$(date)" >> /tmp/cron.txt
$PROG3_MN $PROG3_H * * * echo "PROG3 \$(date)" >> /tmp/cron.txt
$PROG4_MN $PROG4_H * * * echo "PROG4 \$(date)" >> /tmp/cron.txt
EOF
