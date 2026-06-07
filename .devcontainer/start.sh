#!/bin/bash
set -e

echo "[start] Uruchamianie wirtualnego pulpitu..."
Xvfb :1 -screen 0 1280x720x24 +extension GLX -ac &
sleep 2

echo "[start] Uruchamianie VNC..."
x11vnc -display :1 -nopw -forever -shared -quiet -bg

echo "[start] Uruchamianie noVNC na porcie 6080..."
websockify --web=/usr/share/novnc/ --wrap-mode=ignore 6080 localhost:5900 &
sleep 1

echo ""
echo "════════════════════════════════════════"
echo "  Otwórz w przeglądarce:"
echo "  http://localhost:6080/vnc.html"
echo "════════════════════════════════════════"
echo ""

exec python3 -m gfootball.play_game --action_set=full
