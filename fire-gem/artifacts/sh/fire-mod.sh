#!/bin/bash
# /*******************************************************************************
#  * TYPE: SERVICE | CLASS: MOD-ENGINE | NAME: fire-mod.sh
#  * IDENTITY: VERSION 4.4 // V2_PATH_AUTHORITY // HAHA!
#  * ROLE: Seat Version 2 Vaults and Global Permissions.
#  *******************************************************************************/

echo "[AVIS] MOD_SERVICE: Initializing Version 2 Path Authority..."

# 1. SEAT SYSTEM DIRECTORIES (In Root)
mkdir -p ./avis/
mkdir -p ./logs/

# 2. SEAT VERSION 2 VAULT (The Rebuild Target)
mkdir -p ./fire-gem/artifacts/json/cbord/reg/v2/
mkdir -p ./fire-gem/artifacts/json/reg/
mkdir -p ./fire-gem/artifacts/json/asm/v2/

# 3. SEAT SH PERMISSIONS
# Explicitly targets the /sh/ directory for execution seating
if [ -d "./fire-gem/artifacts/sh/" ]; then
    chmod +x ./fire-gem/artifacts/sh/*.sh 2>/dev/null
    echo "BASH: [ACK] Worker scripts in ./fire-gem/artifacts/sh/ seated."
fi

# 4. GLOBAL PERMISSION LOCK
# Ensures all .sh in the current context are executable
chmod +x ./*.sh 2>/dev/null

echo "FIRE-MOD: Version 2 architecture seated. [EXIT]"
exit 0
