#!/bin/bash
cur=$PWD
machine=''
cmd=$@
app=''
interactive=false


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

if [[ -z "$machine" ]]; then
    echo "You are not in logical environment!"
    exit
fi

while getopts :i:c: OPTION;do
    case $OPTION in
        i)  app=$OPTARG
            interactive=true
            ;;
        c)
            app=$OPTARG
            cmd=${cmd#-c $app *}
            ;;
        ?)
            ;;
    esac
done

if [[ -z "$app" ]]; then
    app=${cmd%% *}
fi

# default get 1
container_name="${machine}${app}1"

if $interactive
then
    #echo "You might want: $cur"
    cmd_exec='${SHELL:-sh}'
    docker exec -it $container_name /bin/sh -c "cd ${cur};exec \"${cmd_exec}\""
else
    #echo "[${container_name} $cur]# $cmd"
    sh_cmd="cd ${cur} && ${cmd}"
    #echo $sh_cmd
    docker exec -it $container_name /bin/sh -c "${sh_cmd}"
fi



