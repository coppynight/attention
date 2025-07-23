#!/usr/bin/env bash
# Setup script for Codex environment
# Installs Swift toolchain and other dependencies on Ubuntu

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or via sudo" >&2
  exit 1
fi

apt-get update
apt-get install -y build-essential clang libcurl4-openssl-dev libssl-dev libicu-dev git pkg-config

# install Swift 6.1.2 if not present
if ! command -v swift >/dev/null 2>&1; then
  SWIFT_URL="https://download.swift.org/swift-6.1.2-release/ubuntu20.04/swift-6.1.2-RELEASE/swift-6.1.2-RELEASE-ubuntu20.04.tar.gz"
  curl -L "$SWIFT_URL" -o swift.tar.gz
  tar -xzf swift.tar.gz
  mv swift-6.1.2-RELEASE-ubuntu20.04 /opt/swift
  ln -s /opt/swift/usr/bin/swift /usr/local/bin/swift
  rm swift.tar.gz
fi

echo "Swift development environment installed."
echo "Note: building iOS apps requires Xcode on macOS."
