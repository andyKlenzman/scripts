#!/bin/bash

BASE="/Users/andyklenzman/Desktop/GetAir/testwand-firmwares-20260312"

FW1_NAME="G2LF-2.0.3.1143-KERMI-VK"
FW1_BOOT="$BASE/G2LF-2.0.3.1143/G2LF-2.0.3.1143-KERMI-VK/G2LF-2.0.3.1143-KERMI-VK-boot-1.5.0.hex"
FW1_APP="$BASE/G2LF-2.0.3.1143/G2LF-2.0.3.1143-KERMI-VK/G2LF-2.0.3.1143-KERMI-VK.hex"

FW2_NAME="G2LF-2.0.4.1255-KERMI-VK"
FW2_BOOT="$BASE/G2LF-2.0.4.1255/G2LF-2.0.4.1255-KERMI-VK/G2LF-2.0.4.1255-KERMI-VK-boot-1.5.0.hex"
FW2_APP="$BASE/G2LF-2.0.4.1255/G2LF-2.0.4.1255-KERMI-VK/G2LF-2.0.4.1255-KERMI-VK.hex"

echo ""
echo "=== JLink Firmware Flasher ==="
echo ""
echo "  [1] $FW1_NAME"
echo "  [2] $FW2_NAME"
echo ""
read -rp "Select (1-2): " selection

case "$selection" in
    1) NAME="$FW1_NAME"; BOOT="$FW1_BOOT"; APP="$FW1_APP" ;;
    2) NAME="$FW2_NAME"; BOOT="$FW2_BOOT"; APP="$FW2_APP" ;;
    *) echo "Invalid selection. Aborting."; exit 1 ;;
esac

if [ ! -f "$BOOT" ]; then
    echo "Error: Boot HEX not found: $BOOT"
    exit 1
fi
if [ ! -f "$APP" ]; then
    echo "Error: App HEX not found: $APP"
    exit 1
fi

echo ""
echo "Flashing: $NAME"
echo ""

CMD_FILE=$(mktemp /tmp/jlink_cmd_XXXXXX.jlink)

cat > "$CMD_FILE" <<EOF
device EFM32GG12B130F512
si SWD
speed 4000
connect

r
halt
erase
loadfile $BOOT
loadfile $APP

r
g
exit
EOF

JLinkExe -CommandFile "$CMD_FILE"
EXIT_CODE=$?

rm -f "$CMD_FILE"

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "Flash complete."
else
    echo "JLink exited with code $EXIT_CODE."
fi

exit $EXIT_CODE
