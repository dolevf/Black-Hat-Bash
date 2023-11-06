#!/bin/bash

set -o pipefail
source provision.sh

CHOICE="${1}"
LOG="/var/log/lab-install.log"

if [[ -n "${DEBUG}" ]] && [[ "${DEBUG}" = "true" ]]; then
  LOG=/dev/stderr
fi

if [[ "$(id -u)" -ne 0 ]]; then
    echo "Error: Please run using sudo permissions."
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo "Docker service appears to not be running. Use the service command to start it manually."
    echo "$ sudo service docker start"
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "Docker Compose is not installed. Did you follow the Docker Compose setup instructions?"
    echo "https://github.com/dolevf/Black-Hat-Bash/tree/master/lab#install-docker"
    exit 1
fi


if [[ ! -f "${LOG}" ]]; then
    touch "${LOG}"
    chown "${SUDO_USER}:${SUDO_USER}" "${LOG}"
fi

wait() {
    local pid
    local counter
    local spinner

    pid=$1    
    counter=1
    spinner="/-\|"
    
    echo -n "$2"
    echo -n " "
    while ps -p "${pid}" &> /dev/null; do 
        printf "\b${spinner:counter++%${#spinner}:1}"
        sleep 0.5
    done
    echo
}

images_built(){
    local total_expected_containers
    local total_built_images

    total_expected_containers="$(grep -c container_name docker-compose.yml)"
    total_built_images="$(docker images | grep -c lab-)"
    
    if [[ "${total_built_images}" -eq "${total_expected_containers}" ]]; then
        return 0
    else
        return 1
    fi
}

status(){
    local total_expected_containers
    local actual_running_containers

    total_expected_containers="$(grep -c container_name docker-compose.yml)"
    actual_running_containers="$(docker ps | grep -c lab-)"

    if [[ "${actual_running_containers}" -ne "${total_expected_containers}" ]]; then
        return 1
    else
        return 0
    fi
}

deploy(){
    echo 
    echo "==== Deployment Started ===="

    if ! images_built; then
        echo "This process can take a few minutes to complete."
        echo "Start Time: $(date "+%T")" >> $LOG
        
        if [[ -z "${DEBUG}" ]]; then
            echo "You may run \"tail -f $LOG\" from another terminal session to see the progress of the deployment."
        fi
        
        docker build -f machines/Dockerfile-base -t lab_base . &>> $LOG
        docker compose build --parallel &>> $LOG &
        wait "$!" "Deploying the lab..."
        docker compose up --detach &>> $LOG
        
        if status; then
            echo "OK: all containers appear to be running. Performing a couple of post provisioning steps..."  | tee -a $LOG
            sleep 25
            if check_post_actions &>> $LOG; then
                echo "OK: Lab is up and provisioned." | tee -a $LOG
            else
                echo "Error: something went wrong during provisioning." | tee -a $LOG
            fi
        else
            echo "Error: not all containers are running. check the log file: $LOG"
        fi
    else
        docker compose up --detach &>> $LOG
        sleep 5
        if status; then
            echo "Lab is up."
        else
            echo "Lab is down. Try rebuilding the lab again."
        fi
    fi
    echo "End Time: $(date "+%T")" >> $LOG
}

teardown(){
    echo
    echo "==== Shutdown Started ====" | tee -a $LOG
    docker compose down --volumes
    echo "OK: lab has shut down." 
}

clean(){
    echo
    echo "==== Cleanup Started ====" 
    docker compose down --volumes --rmi all &> /dev/null &
    wait "$!" "Shutting down the lab..."
    
    docker system prune -a --volumes -f &> /dev/null &
    wait "$!" "Cleaning up..."
    
    [[ -f "${LOG}" ]] && > "${LOG}"
    echo "OK: lab environment has been destroyed."
}

rebuild(){
    clean
    deploy
}

case "${CHOICE}" in
    deploy)
        deploy
    ;;
    teardown)
        teardown
    ;;
    clean)
        clean
    ;;
    rebuild)
        rebuild
    ;;
    status)
        if status; then
            echo "Lab is up."
        else
            echo "Lab is down."
            exit 1
        fi
    ;;
    *)
        echo "Usage: ./$(basename "$0") deploy | teardown | rebuild | clean | status"
    ;;
esac
