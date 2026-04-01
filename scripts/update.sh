#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

mkdir -p m3u epg logs

echo "[$(date -u +"%Y-%m-%d %H:%M:%S UTC")] Starte Update..." | tee logs/update.log

# --------------------------------------------------
# 1) M3U-Dateien schreiben / aktualisieren
# --------------------------------------------------

cat > m3u/public_hd.m3u <<'EOF'
#EXTM3U

#EXTINF:-1 tvg-id="daserste.de" group-title="ÖR",Das Erste HD
https://mcdn.daserste.de/daserste/de/master.m3u8

#EXTINF:-1 tvg-id="zdf.de" group-title="ÖR",ZDF HD
https://zdf-hls-15.akamaized.net/hls/live/2016498/de/high/master.m3u8

#EXTINF:-1 tvg-id="arte.de" group-title="ÖR",ARTE HD
https://artelive-lh.akamaihd.net/i/artelive_de@393592/master.m3u8
EOF

cat > m3u/private_free.m3u <<'EOF'
#EXTM3U

#EXTINF:-1 tvg-id="dw.de" group-title="Privat/Frei",DW Deutsch
https://dwamdstream102.akamaized.net/hls/live/2015525/dwstream102/master.m3u8
EOF

cat > m3u/fast_de.m3u <<'EOF'
#EXTM3U

#EXTINF:-1 group-title="FAST",FAST Demo Kanal
https://example.com/demo-fast.m3u8
EOF

# --------------------------------------------------
# 2) Externe EPG laden
# --------------------------------------------------
# Du kannst die URL später austauschen

EPG_URL="https://epgshare01.online/epgshare01/epg_ripper_DE1.xml.gz"

curl -L --fail --silent --show-error \
  "$EPG_URL" \
  -o epg/epg.xml.gz

# Optional entpacken, falls du eine XML-Datei zusätzlich willst
gunzip -c epg/epg.xml.gz > epg/epg.xml

# --------------------------------------------------
# 3) Zeitstempel schreiben
# --------------------------------------------------

date -u +"%Y-%m-%d %H:%M:%S UTC" > logs/last_update.txt

echo "[$(date -u +"%Y-%m-%d %H:%M:%S UTC")] Update abgeschlossen." | tee -a logs/update.log
