#!/bin/sh

. ./variables

echo MIME-Version: 1.0
echo Content-type: text/html
echo 

QUERY=`echo $QUERY_STRING | sed -e "s/=/='/g" -e "s/&/';/g" -e "s/+/ /g"  -e "s/$/'/"`
eval $QUERY

# display & save result

cat << EOF
<BODY>
Hanae mangera &agrave; :
<P>
$PROG1_H H $PROG1_MN
<BR>
$PROG2_H H $PROG2_MN
<BR>
$PROG3_H H $PROG3_MN
<BR>
$PROG4_H H $PROG4_MN
<P>
<INPUT TYPE="button" VALUE="Retour" onClick="history.go(-1);">
<BODY>
EOF

# Update crontab

# cron.tab should be owned by Apache (www-data:www-data)
cat << EOF > ${BASE}/cron.tab
* * * * * crontab ${BASE}/cron.tab
$PROG1_MN $PROG1_H * * * ${BASE}/feed.sh
$PROG2_MN $PROG2_H * * * ${BASE}/feed.sh
$PROG3_MN $PROG3_H * * * ${BASE}/feed.sh
$PROG4_MN $PROG4_H * * * ${BASE}/feed.sh
EOF

