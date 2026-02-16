#!/bin/bash
/*******************************************************************************
 *                           AVIS.ARTIFACT HEADER
 * TYPE: LAW
 * CLASS: DISPATCHER
 * NAME: fire-end.sh
 * VERSION: 2.00
 * IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
 *******************************************************************************/

# 1. CALL SITE GENERATOR
if [ -f "./fire-site.sh" ]; then
    chmod +x fire-site.sh
    ./fire-site.sh
    echo "wm_macro_ack: fire-site triggered."
else
    echo "AVIS_ERROR: fire-site.sh not found."
fi

# 2. CONFIGURE BOT IDENTITY
# Standardized GitHub Actions bot credentials for proper attribution
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

# 3. DISPATCH TO ORIGIN
git add .

# Only commit and push if there are actual changes
if ! git diff --staged --quiet; then
    git commit -m "AVIS: Identity VERSION 1 Verified [HAHA!]"
    
    # 4. REBASE & PUSH
    # Uses rebase with 'ours' strategy to ensure your changes win in conflicts
    git pull --rebase -X ours origin main
    git push origin main
    echo "wm_macro_ack: GIT DISPATCH SUCCESSFUL."
else
    echo "AVIS: No changes detected. Dispatch idle."
fi

exit 0
