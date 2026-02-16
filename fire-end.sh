#!/bin/bash
/*******************************************************************************
 *                           AVIS.ARTIFACT HEADER
 * TYPE: LAW
 * CLASS: DISPATCHER
 * NAME: fire-end.sh
 * VERSION: 3.00
 * IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
 *******************************************************************************/

# 1. CALL SITE GENERATOR (robots.txt / sitemap)
if [ -f "./fire-site.sh" ]; then
    chmod +x fire-site.sh
    ./fire-site.sh
    echo "wm_macro_ack: fire-site triggered."
elif [ -f "./SITEMAP.SH" ]; then
    chmod +x SITEMAP.SH
    ./SITEMAP.SH > robots.txt
    echo "wm_macro_ack: SITEMAP fallback triggered."
else
    echo "AVIS_ERROR: Site generator not found."
fi

# 2. CONFIGURE BOT IDENTITY
# Using official GitHub Actions bot ID for Audit Surface attribution
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

# 3. STAGE ARTIFACTS
# Capture all generated .log files from fire-run and binaries from forge
git add *.log 2>/dev/null
git add *_bin 2>/dev/null
git add robots.txt sitemap.xml 2>/dev/null
git add .

# 4. DISPATCH TO ORIGIN
# Only commit and push if the robotic state has shifted
if ! git diff --staged --quiet; then
    git commit -m "AVIS_V3: Joe Tron Pulse - Identity Verified [HAHA!]"
    
    # 5. REBASE & PUSH
    # Strategy 'ours' prevents merge conflicts from local/remote desync
    git pull --rebase -X ours origin main
    git push origin main
    echo "wm_macro_ack: GIT DISPATCH SUCCESSFUL."
else
    echo "AVIS: No changes detected in the robotic stack. Dispatch idle."
fi

exit 0
