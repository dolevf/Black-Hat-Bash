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
    local total_expected_containers
    local actual_running_containers

    echo "Installing... this process can take a few minutes to complete."
    # shellcheck disable=SC2129
    echo "Start Time: $(date "+%T")" >> $LOG
    # shellcheck disable=SC2024  
    sudo docker-compose up --build --detach --remove-orphans &>> $LOG 
    # shellcheck disable=SC2129
    echo "End Time: $(date "+%T")" >> $LOG 
    
    total_expected_containers="$(grep -c container_name docker-compose.yml)"
    actual_running_containers="$(docker-compose ps | grep -c Up)"

    if [[ "$actual_running_containers" -ne $total_expected_containers ]]; then
        echo "[$actual_running_containers/$total_expected_containers] - not all containers are running. check the log file: $LOG"
        exit 1
    else
        echo "All containers appear to be running. Moving on to performing unit testing..."
    fi
    sleep 5
    if python3 -m pytest -q -W ignore::DeprecationWarning tests/* &>> $LOG; then
        echo "OK: lab appears to be up."
    fi
    
}

function teardown(){
    sudo docker-compose down --volumes
    echo "OK: lab has shut down."
}

function destroy(){
    sudo docker-compose down --volumes --rmi all &> /dev/null
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
        echo "Usage: ./$(basename "$0") deploy|teardown|destroy"
        echo
        echo "deploy   | build images and start containers"
        echo "teardown | stop containers"
        echo "destroy  | stop containers and delete containers and images"
        exit 1
    ;;
esac