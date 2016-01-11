#!/bin/sh

echo "<BODY>"
cat ./current.html
echo "Il est `date +'%H:%M'`<P>"
cat ./set_time.html 
echo "</BODY>"
