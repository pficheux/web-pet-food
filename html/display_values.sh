#!/bin/sh
#
# Production automatique du formulaire de saisie HH/MM
#
i=0

echo "<BODY>"

echo "<SELECT NAME=\"PROG1_H\">"

while [ 1 ]
do
    printf "\t<OPTION VALUE=\"%02d\">%02d\n" $i $i
    i=$(expr $i + 1)
    if [ $i -gt 24 ]; then
	echo "</SELECT> H"
	break
    fi
done

echo "<SELECT NAME=\"PROG1_MN\">"

i=0

while [ 1 ]
do
    printf "\t<OPTION VALUE=\"%02d\">%02d\n" $i $i
    i=$(expr $i + 10)
    if [ $i -eq 60 ]; then
	echo "</SELECT> MN"
	echo "<P><INPUT TYPE=\"SUBMIT\">"
	echo "</BODY>"
	
	exit 0
    fi
done



