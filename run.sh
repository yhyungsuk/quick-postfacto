#!/bin/bash
HOME_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PS3='Please enter task: '
options=("start" "backup" "stop" "quit selection")
select opt in "${options[@]}"
do
    case $opt in
        "start")
            sh "$HOME_DIR"/start.sh
            ;;
        "backup")
            sh "$HOME_DIR"/backup.sh
            ;;
        "stop")
            sh "$HOME_DIR"/stop.sh
            ;;
        "quit selection")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
