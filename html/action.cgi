#!/bin/sh

echo MIME-Version: 1.0
echo Content-type: text/html
echo 

QUERY=`echo $QUERY_STRING | sed -e "s/=/='/g" -e "s/&/';/g" -e "s/+/ /g"  -e "s/$/'/"`
eval $QUERY

cat << EOF
<BODY>
$PROG1_MN $PROG1_H * * * echo "PROG1 \$(date)" >> /tmp/cron.txt
<BR>
$PROG2_MN $PROG2_H * * * echo "PROG2 \$(date)" >> /tmp/cron.txt
<BR>
$PROG3_MN $PROG3_H * * * echo "PROG3 \$(date)" >> /tmp/cron.txt
<BR>
$PROG4_MN $PROG4_H * * * echo "PROG4 \$(date)" >> /tmp/cron.txt
EOF
