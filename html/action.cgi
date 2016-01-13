#!/bin/sh

. /home/wpf/config/variables

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

echo "5,10,15,20,25,30,35,40,45,50,55 * * * * /home/wpf/bin/wpf.update.sh" > ${BASE}/cron.tab

cat << EOF > ${BASE}/current.html
Horaires pour $PET_NAME :
<P>
`display_and_save $PROG1_H $PROG1_MN`
`display_and_save $PROG2_H $PROG2_MN`
`display_and_save $PROG3_H $PROG3_MN`
`display_and_save $PROG4_H $PROG4_MN`
<P>
EOF

./refresh.sh
