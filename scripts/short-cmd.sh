#!/bin/bash
cur=$PWD
machine=''
cmd=$@

if [ -z "$cmd" ]
then
    echo "You should input some cmds!"
    exit
fi

if [[ ${PWD:0:6} = '/data-' ]]
then
    t=${PWD#*/data-}
    machine="${t%%/*}_"
    t=${t#*/}
    cur="/$t"
fi

if [[ ${cmd:0:2} = '-i' ]]
then
    app=${cmd#-i *}
    container_name="${machine}${app}1"
    echo "You might want: $cur"
    #docker exec -it $container_name /bin/sh
else
    app=${cmd%% *}
    container_name="${machine}${app}1"
    echo "[${container_name} $cur]$ $cmd"
    #docker exec -it $container_name /bin/sh  -c "cd $cur && $cmd"
fi
