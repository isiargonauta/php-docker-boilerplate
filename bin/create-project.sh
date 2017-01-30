#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"

if [ "$#" -lt 1 ]; then
    echo "No project type defined (either symfony_new, symfony, git)"
    exit 1
fi

#if app dir exists then backup it with timestamp
if [ -d "$CODE_DIR" ]
then
#    if  execInDir "$CODE_DIR" "git remote"
#    then
#        $(execInDir "$CODE_DIR" "git remote -v | head -n1 | awk '{print \$2}' | sed -e 's,.*:\(.*/\)\?,,' -e 's/\.git$//'")
#        echo mv "$CODE_DIR" "$CODE_DIR".$?.$(date +%Y%m%d%H%M%S)
#    else
#        echo mv "$CODE_DIR" "$CODE_DIR".$(date +%Y%m%d%H%M%S)
#    fi
    mv "$CODE_DIR" "$CODE_DIR".$(date +%Y%m%d%H%M%S)
fi
mkdir -p -- "$CODE_DIR/"
chmod 777 "$CODE_DIR/"

rm -f -- "$CODE_DIR/.gitkeep"

case "$1" in
    ###################################
    ## SYMFONY NEW
    ###################################
    "symfony_new")
        curl -LsS http://symfony.com/installer > /tmp/symfony.$$.phar
        execInDir "$CODE_DIR" "php /tmp/symfony.$$.phar new '$CODE_DIR'"
        rm -f -- /tmp/symfony.$$.phar
        ;;

    ###################################
    ## SYMFONY
    ###################################
    "symfony")
        if [ "$#" -lt 2 ]; then
            echo "Missing git url"
            exit 1
        fi
        git clone --recursive "$2" "$CODE_DIR"
        curl -LsS https://getcomposer.org/installer > /tmp/installer.$$.phar
        execInDir "$CODE_DIR" "php /tmp/installer.$$.phar"
        rm -f -- /tmp/installer.$$.phar
        [ -d "${CODE_DIR}/app/logs" ] || mkdir -p "${CODE_DIR}/app/logs"
        [ -d "${CODE_DIR}/app/cache" ] || mkdir -p "${CODE_DIR}/app/cache"
        ;;
        
    ###################################
    ## GIT
    ###################################
    "git")
        if [ "$#" -lt 2 ]; then
            echo "Missing git url"
            exit 1
        fi
        git clone --recursive "$2" "$CODE_DIR"
        ;;
esac

touch -- "$CODE_DIR/.gitkeep"
