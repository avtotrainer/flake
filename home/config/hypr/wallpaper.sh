#!/usr/bin/env bash

# ლოგის ფაილის მისამართი
LOGFILE="$HOME/.cache/hypr/wallpaper.log"

# ლოგი სესიის თავში
echo "[$(date)] — ფონური სურათის შეცვლა დაწყებულია" >> "$LOGFILE"

# გადმოწერა
wget --max-redirect=3 -O /tmp/wall.jpg "https://picsum.photos/1920/1080?random=$(date +%s)" >> "$LOGFILE" 2>&1

# ფაილის ზომა
FILESIZE=$(stat -c%s /tmp/wall.jpg)
echo "[$(date)] გადმოწერილი ფაილის ზომა: $FILESIZE ბაიტი" >> "$LOGFILE"

# თუ ფაილი ნორმალურია, ვცვლით ფონს
if [ "$FILESIZE" -gt 50000 ]; then
    echo "[$(date)] ✔ ვცვლი ვოლპეიპერს..." >> "$LOGFILE"
    swww img /tmp/wall.jpg --transition-type grow --transition-step 60 >> "$LOGFILE" 2>&1
else
    echo "[$(date)] ❌ ფაილი არ ვარგა, გამოტოვებულია" >> "$LOGFILE"
fi

