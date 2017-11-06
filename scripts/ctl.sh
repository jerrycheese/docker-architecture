#!/bin/bash
source base.sh
while getopts ex: option
do
    case "$option" in
        ex)
            docker exec -it "$OPTARG"
        i)
            echo "option:h, value $OPTARG"
            echo "next arg index:$OPTIND";;
        \?)
           echo "Usage: args -r|-i CONTAINER_ID"
            echo "-r means reload nginx configuration"
            echo "-i means run /bin/bash on nginx container"
            exit 1;;
    esac
done

echo "*** do something now ***"

