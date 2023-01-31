#!/bin/bash
set -o pipefail
declare -r LOG=log.txt

truncate -s 0 $LOG

if [[ "$(id -u)" -ne 0 ]]; then
    if ! groups | grep -q docker; then
        echo "It looks like you are not part of the 'docker' group or aren't using sudo."
        echo "Docker requires sudo privileges. To add your user \"$USER\" to the docker group, please run:"
        echo "usermod -aG $USER docker"
        echo "then, rerun the command: su - $USER"
        exit 1
    fi
fi


function deploy(){
    sudo docker-compose --profile all up --build -d --remove-orphans 2>&1 | tee -a $LOG
    echo "Running tests..."
    if python3 -m pytest -q -W ignore::DeprecationWarning tests/* 2>&1 | tee -a $LOG; then
        echo "OK: lab appears to be up."
    fi
    
}

function teardown(){
    sudo docker-compose down -v
    echo "OK: lab has shut down."
}

function destroy(){
    sudo docker-compose down -v --rmi all
    echo "OK: lab has been destroyed."
}

case "$1" in
    deploy)
        deploy
    ;;
    teardown)
        teardown
    ;;
    destroy)
        destroy
    ;;
    *)
        echo "Usage: ./$(basename $0) deploy|teardown|destroy"
        echo
        echo "deploy   | build images and start containers"
        echo "teardown | stop containers"
        echo "destroy  | stop containers and delete containers and images"
        exit 1
    ;;
esac