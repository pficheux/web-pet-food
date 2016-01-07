#!/bin/sh

. ./variables

echo MIME-Version: 1.0
echo Content-type: text/html
echo 

# For test
#QUERY_STRING="PROG1_H=--&PROG1_MN=10&PROG2_H=06&PROG2_MN=20&PROG3_H=09&PROG3_MN=--&PROG4_H=10&PROG4_MN=10"

# Extract  CGI variables
QUERY=`echo $QUERY_STRING | sed -e "s/=/='/g" -e "s/&/';/g" -e "s/+/ /g"  -e "s/$/'/"`
eval $QUERY

# Display and save feeding time, skip "--" which means "no feeding time"
display_and_save ()
{
    if [ "$1" = "--" -o "$2" = "--" ]; then
	return
    fi
    
    echo "$1 H $2 MN<BR>"
    echo "$2 $1 * * * /home/wpf/bin/feed.sh" >> ${BASE}/cron.tab
}

# display & save result to cron file

echo "* * * * * crontab ${BASE}/cron.tab" > ${BASE}/cron.tab

cat << EOF
<BODY>
$PET_NAME mangera &agrave; :
<P>
`display_and_save $PROG1_H $PROG1_MN`
`display_and_save $PROG2_H $PROG2_MN`
`display_and_save $PROG3_H $PROG3_MN`
`display_and_save $PROG4_H $PROG4_MN`
<P>
<INPUT TYPE="button" VALUE="Retour" onClick="history.go(-1);">
<BODY>

EOF



