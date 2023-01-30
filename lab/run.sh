#!/bin/bash
set -o pipefail


if [[ "$(id -u)" -ne 0 ]]; then
    if ! groups | grep -q docker; then
        echo "It looks like you are not part of the 'docker' group or aren't using sudo."
        echo "Docker requires sudo privileges. To add your user \"$USER\" to the docker group, please run:"
        echo "usermod -aG $USER docker"
        echo "then, rerun the command: su - $USER"
        echo "...or simply use sudo"
        exit 1
    fi
fi


function setup_containers(){
    sudo docker-compose up --build -d --remove-orphans > /dev/null
    echo "Running tests..."
    if python3 -m pytest -q -W ignore::DeprecationWarning tests/*; then
        echo "OK: lab appears to be up."
    fi
    
}

function setup_teardown(){
    sudo docker-compose down
    echo "OK: lab has shut down."
}

case "$1" in
    deploy)
        setup_containers
    ;;
    teardown)
        setup_teardown
    ;;
    *)
        echo "deploy|teardown"
        exit 1
esac