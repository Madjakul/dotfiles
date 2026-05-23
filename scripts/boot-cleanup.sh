#!/usr/bin/env bash
# scripts/boot-cleanup.sh
# Run before every apt upgrade to free /boot space.
# Removes old kernel packages, rebuilds initramfs for current kernel only.
# Usage: sudo bash boot-cleanup.sh

set -euo pipefail

CURRENT=$(uname -r)
echo "=== Running kernel: $CURRENT ==="
echo

# 1. Purge old kernel packages (everything except the running kernel)
echo "--- Purging old kernel packages ---"
OLD_PKGS=$(
    dpkg --list 'linux-image-*' 'linux-headers-*' 'linux-modules-*' 'linux-modules-extra-*' |
        awk '/^ii/ {print $2}' |
        grep -v "$CURRENT" |
        grep -v "linux-image-generic" || true
)

if [ -n "$OLD_PKGS" ]; then
    apt-get purge -y $OLD_PKGS
else
    echo "No old kernel packages found."
fi

# 2. Autoremove catches any leftover dependencies
apt-get autoremove --purge -y

# 3. Rebuild initrd for current kernel only
echo "--- Rebuilding initrd ---"
update-initramfs -u -k "$CURRENT"

# 4. Refresh GRUB
update-grub

# 5. Report
echo
echo "=== /boot usage after cleanup ==="
df -h /boot
echo
echo "=== Files in /boot ==="
ls -lh /boot/initrd.img-* /boot/vmlinuz-* 2>/dev/null
