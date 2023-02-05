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

function status(){
    local total_expected_containers
    local actual_running_containers

    total_expected_containers="$(grep -c container_name docker-compose.yml)"
    actual_running_containers="$(docker ps | grep -c lab_)"

    if [[ "$actual_running_containers" -ne "$total_expected_containers" ]]; then
        return 1
    else
        return 0
    fi
}

function deploy(){
    echo "\nDeployment started. This process can take a few minutes to complete. Do not close this terminal session while it's running."
    echo "You may run \"tail -f $LOG\" to see the progress of the deployment."
    # shellcheck disable=SC2129
    echo "Start Time: $(date "+%T")" >> $LOG
    # shellcheck disable=SC2024  
    sudo docker-compose up --build --detach --remove-orphans &>> $LOG

    if status; then
        echo "OK: all containers appear to be running. Performing a couple of validation steps..."  | tee -a $LOG
        sleep 5
        if python3 -m pytest -q -W ignore::DeprecationWarning tests/* &>> $LOG; then
            echo "OK: lab appears to be up." | tee -a $LOG
        else
            echo "Error: some unit tests have failed."
        fi
    else
        echo "Error: not all containers are running. check the log file: $LOG"
    fi

    # shellcheck disable=SC2129
    echo "End Time: $(date "+%T")" >> $LOG 
}

function teardown(){
    sudo docker-compose down --volumes
    echo "OK: lab has shut down."
}

function destroy(){
    echo "Destroying the lab environment, this may take a few moments..."
    sudo docker-compose down --volumes --rmi all &> /dev/null
    echo "OK: lab environment has been destroyed."
}

function rebuild(){
    destroy
    deploy
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
    rebuild)
        rebuild
    ;;
    status)
        if status; then
            echo "Lab is up."
        else
            echo "Lab is down."
        fi
        exit 0
    ;;
    *)
        echo "Usage: ./$(basename "$0") deploy|teardown|status|rebuild|destroy"
        echo
        echo "deploy   | build images and start containers"
        echo "teardown | stop containers"
        echo "destroy  | stop containers and delete containers and images"
        echo "rebuild  | rebuilds the lab from scratch"
        echo "status   | check the status of the lab"
        exit 1
    ;;
esac