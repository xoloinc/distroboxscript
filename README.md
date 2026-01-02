# Distrobox AI Container Setup

Automated script for creating Ubuntu-based Distrobox containers optimized for AI development with Ollama.

## Overview

This script creates a containerized development environment with:
- Ubuntu 24.04 base image
- Shared workspace volume for persistent data
- Ollama AI model runner pre-installed
- Essential development tools

## Prerequisites

- Distrobox installed on your system
- Podman or Docker as the container backend

## Quick Start

1. **Create configuration file:**
   ```bash
   cp container.conf.example container.conf
   ```

2. **Edit configuration** (optional):
   ```bash
   nano container.conf
   ```

3. **Run the script:**
   ```bash
   ./setup-ai-container.sh
   ```

## Usage

The script can be used in two ways:

### Method 1: Using Configuration File (Recommended)

```bash
# Create and edit your config file
cp container.conf.example container.conf
nano container.conf

# Run with config file settings
./setup-ai-container.sh
```

### Method 2: Command-Line Override

```bash
# Override container name from command line
./setup-ai-container.sh my-custom-name
```

The command-line argument will override the `CONTAINER_NAME` in the config file.

## What Gets Installed

The script automatically installs:
- **System updates** - Latest package updates
- **curl** - Command-line tool for transferring data
- **git** - Version control system
- **python3-pip** - Python package manager
- **build-essential** - Compilation tools (gcc, g++, make)
- **Ollama** - AI model runner for running large language models locally

## Configuration

All settings are defined in `container.conf`. Copy `container.conf.example` to get started.

### Available Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `CONTAINER_NAME` | Name of the container (required) | `my-ai-env` |
| `IMAGE` | Base container image | `ubuntu:24.04` |
| `WORKSPACE_PATH` | Host directory to mount | `~/ai-workspace` |
| `OLLAMA_MODELS_DIR` | Ollama models location in container | `/workspace/ollama/models` |
| `ADDITIONAL_PACKAGES` | Extra packages to install | _(empty)_ |
| `ADDITIONAL_FLAGS` | Extra distrobox create flags | `--userns=keep-id` |

### Example Configuration

```bash
# container.conf
CONTAINER_NAME="my-ai-env"
IMAGE="ubuntu:24.04"
WORKSPACE_PATH="$HOME/ai-workspace"
OLLAMA_MODELS_DIR="/workspace/ollama/models"
ADDITIONAL_PACKAGES="vim neovim tmux"
ADDITIONAL_FLAGS="--userns=keep-id"
```

### Workspace Volume

The container mounts your specified workspace directory to `/workspace` inside the container, providing:
- Persistent storage across container rebuilds
- Shared access to AI models and project files
- Ollama models stored at the configured location

## Entering the Container

After creation, enter your container with:

```bash
distrobox enter <container-name>
```

## Technical Details

- **User namespace**: Uses `--userns=keep-id` to maintain user ID consistency
- **Base image**: Ubuntu 24.04
- **Ollama installation**: Uses official installation script from ollama.com
