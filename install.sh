#!/bin/sh
set -e
# Usage
# ==============================================================================
#
# To install the latest stable versions of Docker CLI, Docker Engine, and their
# dependencies:
#
# 1. download the script
#
#   $ curl -fsSL https://raw.githubusercontent.com/gbh-tech/setup-gbh-tools/main/install.sh -o setup-gbh-tools.sh
#
# 2. verify the script's content
#
#   $ cat setup-gbh-tools.sh
#
# 4. run the script either as root, or using sudo to perform the installation.
#
#   $ sudo sh setup-gbh-tools.sh --name envi --version v1.1.0
#
# Command-line options
# ==============================================================================
#
# --version <VERSION>
# Use the --version option to install a specific version, for example:
#
#   $ sudo sh setup-gbh-tool.sh --version 23.0
#
# --name <tool name>
#
# Name of the gbh-tool to install
#
#   $ sudo sh setup-gbh-tool.sh --name commenter
#
# ==============================================================================
usage() {
    echo "Usage: $0 --name <tool_name> --version <version>"
    exit 1
}

if [ "$#" -lt 4 ]; then
  usage
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    --name)
      TOOL_NAME="$2"
      shift 2
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter passed: $1"
      usage
      ;;
  esac
done

if [ -z "$TOOL_NAME" ] || [ -z "$VERSION" ]; then
  usage
fi

# Detect OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Map architecture to common binary names
case "$ARCH" in
  x86_64)
    ARCH="x86_64"
  ;;
  arm64 | aarch64)
    ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

URL="https://github.com/gbh-tech/${TOOL_NAME}/releases/download/${VERSION}/${TOOL_NAME}_${OS}_${ARCH}.tar.gz"

# Temporary directory to download and extract the tool
TMP_DIR=$(mktemp -d)

# Trap to clean up the temporary directory upon exit
trap "rm -rf $TMP_DIR" EXIT

echo "Downloading $TOOL_NAME version $VERSION for $OS-$ARCH..."
curl -s -L "$URL" | tar -xz -C "$TMP_DIR" || { echo "Failed to download or extract the tool."; exit 1; }

if [ ! -f "$TMP_DIR/$TOOL_NAME" ]; then
  echo "Error: $TOOL_NAME binary not found in the archive."
  exit 1
fi

chmod +x "$TMP_DIR/$TOOL_NAME"

echo "Installing $TOOL_NAME to /usr/local/bin..."
sudo mv "$TMP_DIR/$TOOL_NAME" /usr/local/bin/ || { echo "Failed to move the tool to /usr/local/bin."; exit 1; }

if command -v "$TOOL_NAME" &> /dev/null; then
  echo "$TOOL_NAME version $VERSION installed successfully!"
else
  echo "Error: $TOOL_NAME installation failed."
  exit 1
fi
