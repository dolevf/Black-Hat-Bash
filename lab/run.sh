#!/bin/bash

################################
#          Maintainers:        # 
#     dolev@blackhatbash.com   #
#     nick@blackhatbash.com    #
################################

set -o pipefail
source provision.sh

LOG="log.txt"
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

if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Make sure to start the docker service."
    exit 1
fi

function status(){
    local total_expected_containers
    local actual_running_containers

    total_expected_containers="$(grep -c container_name docker-compose.yml)"
    actual_running_containers="$(docker ps | grep -c lab-)"

    if [[ "$actual_running_containers" -ne "$total_expected_containers" ]]; then
        return 1
    else
        return 0
    fi
}

function deploy(){
    echo 
    echo "==== Deployment started ===="
    echo "Deploying the Black Hat Bash environment."
    echo "This process can take a few minutes to complete. Do not close this terminal session while it's running."
    echo "You may run \"tail -f $LOG\" from another terminal session to see the progress of the deployment."
    echo "Start Time: $(date "+%T")" >> $LOG
    
    sudo docker compose build --parallel &>> $LOG
    sudo docker compose up --detach &>> $LOG
    
    if status; then
        echo "OK: all containers appear to be running. Performing a couple of post provisioning steps..."  | tee -a $LOG
        sleep 10
        if check_post_actions &>> $LOG; then
            echo "OK: lab is up and provisioned." | tee -a $LOG
        else
            echo "Error: something went wrong during provisioning." | tee -a $LOG
        fi
    else
        echo "Error: not all containers are running. check the log file: $LOG"
    fi

    echo "End Time: $(date "+%T")" >> $LOG 
}

function teardown(){
    echo
    echo "==== Shutdown Started ====" | tee -a $LOG
    sudo docker compose down --volumes
    echo "OK: lab has shut down." 
}

function cleanup(){
    echo
    echo "==== Cleanup Started ====" 
    echo "Cleaning up the Black Hat Bash environment, this may take a few moments..."
    sudo docker compose down --volumes --rmi all &> /dev/null
    echo "OK: lab environment has been destroyed."
}

function rebuild(){
    cleanup
    deploy
}

case "$1" in
    deploy)
        deploy
    ;;
    teardown)
        teardown
    ;;
    cleanup)
        cleanup
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
        echo "Usage: ./$(basename "$0") deploy | teardown | rebuild | cleanup | status"
        echo
        echo "deploy   | build images and start containers"
        echo "teardown | stop containers"
        echo "rebuild  | rebuilds the lab from scratch"
        echo "cleanup  | stop containers and delete containers and images"
        echo "status   | check the status of the lab"
        exit 1
    ;;
esac
