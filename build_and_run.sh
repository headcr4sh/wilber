#!/bin/sh

set -e -u

# Build
flatpak-builder --user --install --sandbox --force-clean ./build/ ./com.cathive.Wilber.json

# Run
G_MESSAGES_DEBUG=all \
flatpak run --user com.cathive.Wilber
