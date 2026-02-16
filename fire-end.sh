#!/bin/bash
# FILE: fire-end.sh
# IDENTITY: VERSION 2 // FIRE-END // CVBGOD
# ROLE: Final Sitemap Generation, Log Aggregation, and Git Dispatch

echo "AVIS: Fire-End Engaged. Sealing VERSION 2 Identity..."

# 1. EXECUTE SITEMAP LOGIC
# Generates robots.txt for the "little google bot" to stop snoozing
if [ -f "./SITEMAP.SH" ]; then
    echo "AVIS: Generating robots.txt via SITEMAP.SH..."
    chmod +x SITEMAP.SH
    ./SITEMAP.SH > robots.txt
    echo "wm_macro_ack: robots.txt seated."
else
    echo "AVIS_WARNING: SITEMAP.SH missing. robots.txt not updated."
fi

# 2. AGGREGATE RUN LOGS
# Ensure all background logs from fire-run are captured for the Audit Surface
git add *.log 2>/dev/null || echo "No new logs found."

# 3. MASTER GIT DISPATCH
echo "AVIS: Initiating Final Server Sync..."

git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

# Stage all artifacts: robots.txt, sitemap.xml, foraged binaries, and logs
git add .

# Check for changes before committing to avoid exit 128
if ! git diff --staged --quiet; then
    git commit -m "AVIS_V2: Fire-Chain Closed [FIRE END] [HAHA!]"
    
    # Rebase ensures the push succeeds even if files changed in-between
    git pull --rebase origin main
    git push origin main
    echo "wm_macro_ack: Dispatch Successful. System Locked."
else
    echo "AVIS: No identity changes detected. Dispatch bypassed."
fi

# 4. SYSTEM EXIT
echo "AVIS: System offline. Handshake TERMINATED."
exit 0
