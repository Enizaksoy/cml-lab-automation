#!/bin/bash
#
# Batch Configuration Script for CML Lab Devices
# Configures all devices in the VXLAN_MANUAL topology
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SCRIPT="$SCRIPT_DIR/config_device.exp"

# Check if expect script exists
if [[ ! -f "$CONFIG_SCRIPT" ]]; then
    echo "ERROR: config_device.exp not found in $SCRIPT_DIR"
    exit 1
fi

# Make script executable
chmod +x "$CONFIG_SCRIPT"

echo "============================================"
echo "  CML Lab Bulk Configuration"
echo "============================================"
echo ""

# Device mapping: device_name -> ip_address
declare -A DEVICES=(
    ["Super-Spine-1"]="192.168.30.118"
    ["Super-Spine-2"]="192.168.30.119"
    ["Spine-1"]="192.168.30.110"
    ["Spine-2"]="192.168.30.111"
    ["Spine-3"]="192.168.30.112"
    ["Spine-4"]="192.168.30.113"
    ["Leaf-1"]="192.168.30.114"
    ["Leaf-2"]="192.168.30.115"
    ["Leaf-3"]="192.168.30.116"
    ["Leaf-4"]="192.168.30.117"
)

# Counter for progress
TOTAL=${#DEVICES[@]}
CURRENT=0
SUCCESS=0
FAILED=0

# Configure each device
for DEVICE in "${!DEVICES[@]}"; do
    ((CURRENT++))
    IP="${DEVICES[$DEVICE]}"

    echo ""
    echo "[$CURRENT/$TOTAL] Configuring $DEVICE ($IP)..."
    echo "--------------------------------------------"

    if expect "$CONFIG_SCRIPT" "$DEVICE" "$IP"; then
        ((SUCCESS++))
        echo "SUCCESS: $DEVICE configured"
    else
        ((FAILED++))
        echo "FAILED: $DEVICE configuration error"
    fi

    # Brief pause between devices
    sleep 3
done

echo ""
echo "============================================"
echo "  Configuration Summary"
echo "============================================"
echo "  Total devices:  $TOTAL"
echo "  Successful:     $SUCCESS"
echo "  Failed:         $FAILED"
echo "============================================"

# Verify SSH access
echo ""
echo "Verifying SSH access to configured devices..."
echo ""

for DEVICE in "${!DEVICES[@]}"; do
    IP="${DEVICES[$DEVICE]}"
    if timeout 5 bash -c "echo > /dev/tcp/$IP/22" 2>/dev/null; then
        echo "  [OK] $DEVICE ($IP) - SSH port open"
    else
        echo "  [--] $DEVICE ($IP) - SSH port not responding"
    fi
done

echo ""
echo "Done! You can now SSH to devices using:"
echo "  ssh admin@<device-ip>"
echo ""
