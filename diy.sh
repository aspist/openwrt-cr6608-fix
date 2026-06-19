#!/bin/bash
# =========================================================
# Custom build script for CR6608 with MT7530 ARL fix
# This runs before the build to apply custom patches
# =========================================================
set -e

echo "=== Applying MT7530 ARL fix patch ==="

# Copy the MT7530 ARL fix patch into the ramips target patch directory
# This patch adds port_fast_age and fixes the AGE_CNT aging bug
# Patches are in the repo root (checked out to GITHUB_WORKSPACE)
PATCH_FILE="$GITHUB_WORKSPACE/patches/999-mt7530-arl-fix.patch"
PATCH_DIR="target/linux/ramips/patches-6.12"

if [ -f "$PATCH_FILE" ]; then
    cp "$PATCH_FILE" "$PATCH_DIR/"
    echo "Copied MT7530 ARL fix to $PATCH_DIR/"
else
    echo "ERROR: Patch file not found at $PATCH_FILE"
    exit 1
fi

echo "=== Patch applied successfully ==="
