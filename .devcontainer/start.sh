#!/bin/bash
set -e

service ssh start 2>/dev/null || true

echo "[start] Wirtualny pulpit 800x600 (mniejszy = szybszy VNC)..."
Xvfb :1 -screen 0 800x600x16 +extension GLX -ac &
sleep 2

echo "[start] VNC (30fps cap, zlib compression)..."
x11vnc -display :1 -nopw -forever -shared -quiet -bg \
       -noxdamage -nocursorshape -rfbport 5900 \
       -framerate 30

echo "[start] noVNC port 6080..."
websockify --web=/usr/share/novnc/ --wrap-mode=ignore 6080 localhost:5900 &
sleep 1

echo ""
echo "════════════════════════════════════════"
echo "  Otwórz (lżejszy viewer):"
echo "  /vnc_lite.html?compression=9&quality=4"
echo "════════════════════════════════════════"
echo ""

# niższa rozdzielczość renderowania = mniej pracy dla CPU
exec python3 -m gfootball.play_game \
    --action_set=full \
    --render_resolution_x=800 \
    --render_resolution_y=600
