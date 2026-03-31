#!/bin/bash
# /*******************************************************************************
#  * TYPE: SERVICE | CLASS: MOD-ENGINE | NAME: fire-mod.sh
#  * ROLE: Seat permissions for the /sh/ and /avis/ directories.
#  *******************************************************************************/

echo "[AVIS] MOD_SERVICE: Seating Permissions..."

# 1. CORE PERMISSIONS
chmod +x ./sh/*.sh
mkdir -p ./avis/
mkdir -p ./logs/

# 2. SEAT ANY EXISTING ARTIFACTS
if [ -d "./fire-gem/artifacts" ]; then
    find ./fire-gem/artifacts -type f -name "*.sh" -exec chmod +x {} \;
fi

echo "FIRE-MOD: System permissions seated. [EXIT]"
