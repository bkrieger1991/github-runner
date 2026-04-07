#!/bin/bash
set -e

# If TOKEN_FILE is set, read content into TOKEN
if [ -n "$TOKEN_FILE" ]; then
    if [ -f "$TOKEN_FILE" ]; then
        export TOKEN=$(cat "$TOKEN_FILE")
        echo "Token successfully loaded from $TOKEN_FILE."
    else
        echo "Error: TOKEN_FILE is set ($TOKEN_FILE), but the file does not exist."
        exit 1
    fi
fi

# Check if the token is now available
if [ -z "$TOKEN" ]; then
    echo "Error: no token set. Please set TOKEN or TOKEN_FILE environment variable."
    exit 1
fi

# Runner configuration and start
# We use --unattended and pass the parameters
./config.sh --url "${REPO_URL}" --token "${TOKEN}" --name "${RUNNER_NAME:-docker-runner}" --unattended --replace

# Start the runner and keep the container running
./run.sh