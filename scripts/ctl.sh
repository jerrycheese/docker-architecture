#!/bin/bash
source base.sh
while getopts -c: option
do
    case "$option" in
        -c)
            echo 'cmd for ex';;

        \?)
           echo "Usage: args -r|-i CONTAINER_ID"
            echo "-r means reload nginx configuration"
            echo "-i means run /bin/bash on nginx container"
            exit 1;;
    esac
done

echo "*** do something now ***"

