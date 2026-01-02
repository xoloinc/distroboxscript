#!/bin/bash

# Default configuration
CONFIG_FILE="container.conf"
CONTAINER_NAME=""
IMAGE="ubuntu:24.04"
WORKSPACE_PATH="$HOME/ai-workspace"
OLLAMA_MODELS_DIR="/workspace/ollama/models"
ADDITIONAL_PACKAGES=""
ADDITIONAL_FLAGS="--userns=keep-id"

# Load configuration file if it exists
if [ -f "$CONFIG_FILE" ]; then
    echo "Loading configuration from $CONFIG_FILE"
    source "$CONFIG_FILE"
else
    echo "Warning: $CONFIG_FILE not found, using defaults"
    echo "Create one using: cp container.conf.example container.conf"
fi

# Allow command-line override of container name
if [ -n "$1" ]; then
    CONTAINER_NAME="$1"
fi

# Validate required settings
if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: CONTAINER_NAME is required"
    echo ""
    echo "Usage: ./setup-ai-container.sh [container-name]"
    echo ""
    echo "Either:"
    echo "  1. Set CONTAINER_NAME in container.conf, or"
    echo "  2. Provide container name as argument"
    echo ""
    echo "Example: ./setup-ai-container.sh my-ai-env"
    exit 1
fi

echo "================================"
echo "Container Configuration:"
echo "================================"
echo "Name: $CONTAINER_NAME"
echo "Image: $IMAGE"
echo "Workspace: $WORKSPACE_PATH"
echo "Ollama Models: $OLLAMA_MODELS_DIR"
echo "Additional Packages: ${ADDITIONAL_PACKAGES:-none}"
echo "================================"
echo ""

# Create container
echo "Creating container..."
distrobox create \
  --name "$CONTAINER_NAME" \
  --image "$IMAGE" \
  --volume "$WORKSPACE_PATH:/workspace" \
  --additional-flags "$ADDITIONAL_FLAGS"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create container"
    exit 1
fi

# Enter and install
echo "Installing packages and configuring environment..."
distrobox enter "$CONTAINER_NAME" -- bash -c "
set -e
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git python3-pip build-essential $ADDITIONAL_PACKAGES
curl -fsSL https://ollama.com/install.sh | sh
echo 'export OLLAMA_MODELS=$OLLAMA_MODELS_DIR' >> ~/.bashrc
mkdir -p $OLLAMA_MODELS_DIR
echo ''
echo 'Container ready! Run: distrobox enter $CONTAINER_NAME'
"

if [ $? -eq 0 ]; then
    echo ""
    echo "================================"
    echo "Setup completed successfully!"
    echo "================================"
    echo "Enter container: distrobox enter $CONTAINER_NAME"
else
    echo "Error: Setup failed"
    exit 1
fi
