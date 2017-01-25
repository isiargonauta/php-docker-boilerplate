#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"

if [ "$#" -lt 1 ]; then
    echo "No business client defined"
    exit 1
fi

if [ "$#" -lt 2 ]; then
    echo "No lamp selection platform defined"
    exit 1
fi

#######################################################
## Check all files are there for client and platform
#######################################################

[ -f "${ROOT_DIR}/Dockerfile.development.$1.$2" ] || { echo "Dockerfile.development.$1.$2 NOT FOUND" ; exit 1 ;}
[ -f "${ROOT_DIR}/docker-compose.development.$1.$2" ] || { echo "docker-compose.development.$1.$2 NOT FOUND" ; exit 1 ;}

logMsg "Enabling conf for $1 $2 ..."
ln -bs "${ROOT_DIR}/Dockerfile.development.$1.$2" "${ROOT_DIR}/Dockerfile"
ln -bs "${ROOT_DIR}/docker-compose.development.$1.$2" "${ROOT_DIR}/docker-compose.yml"
logMsg "Finished. Go ahead with make create project."