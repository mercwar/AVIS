# 💎 AVIS CORE V4 — LOCAL VERIFICATION TEST MANUAL

This document establishes the definitive testing suite to confirm that the **Mercwar/AVIS Ecosystem (Version 4)** executes with absolute path compliance, zero persistence exposure, and flawless subshell isolation. 

Follow these steps directly from any terminal prompt without changing directory contexts (`cd`).

---

## 🔬 Test Vector 1: Dynamic Configuration Verification
This test ensures that the system dynamically creates a clean, credential-free configuration map if it is missing from the core.

### ⚙️ Execution Hook (Absolute Path Routing)
```cmd
php.exe "AVIS-LOGIC-CORE/logic/v1/config_matrix_builder.php"
```

### 📋 Expected Telemetry Output
```text
[PROCESSOR] Initializing refined AVIS Core system mapping...
[MISSING_ASSET] Ephemeral configuration block absent. Generating clean baseline system payload...
[SUCCESS] Refined configuration blueprint successfully generated at: avis/core/v4/config.json
```

### 📑 Post-Validation Check
Verify that `avis/core/v4/config.json` exists and that `allow_db_persistence` is strictly set to `false`.

---

## 📥 Test Vector 2: Plaintext Transaction Queue Processing
This test verifies that the backend processor securely locking down files can parse, process, and update the merged multi-repository task lines.

### ⚙️ Execution Hook (Absolute Path Routing)
```cmd
php.exe "AVIS-LOGIC-CORE/logic/v1/processor.php"
```

### 📋 Expected Telemetry Output
```text
[PROCESSOR] Initializing unified multi-repo task sequence...
[PARSING] Scanning consolidated stream tokens:
[PROCESSING] Evaluating task token line: [2026-09-10T07:51:00-04:00] REPO_UPDATE_REQUEST: TARGET=Cyborg STATUS=PENDING ORIGIN=AVIS-LOGIC-CORE
[ROUTING] Broadcasting universal logic/v1 baseline configuration payload to repository container: Cyborg
[INTERPRETER] Invoking fire-lang parsing sequence for assistant token buffers targeting: Cyborg
[PROCESSING] Evaluating task token line: [2026-09-10T07:51:02-04:00] REPO_UPDATE_REQUEST: TARGET=NEXUS STATUS=PENDING ORIGIN=AVIS-LOGIC-CORE
[ROUTING] Broadcasting universal logic/v1 baseline configuration payload to repository container: NEXUS
[PROCESSING] Evaluating task token line: [2026-09-10T07:51:05-04:00] INVENTORY_INDEX_REQUEST: TARGET=robo-knight-inventory STATUS=PENDING ORIGIN=AI_CRAWLER
[ROUTING] Broadcasting universal logic/v1 baseline configuration payload to repository container: robo-knight-inventory
[COMMIT] Successfully processed and locked [3] ecosystem transactions.
[PIPELINE_COMPLETE] Synchronized updates processed across downstream matrices.
```

---

## 🛠️ Test Vector 3: MSVC Simultaneous Engine Compilation
This test forces full executable generation and code verification using parallel compilation tracks under Windows 11 MSVC.

### ⚙️ Execution Hook (Absolute Path Routing)
```cmd
call "avis/core/v4/compile_engines.bat"
```

### 📋 Expected Telemetry Output
```text
⚙️  [COMPILER_START] Initializing simultaneous engine compilation pass...
🔬 [AUDIT] Processing parallel compilation lines via absolute targeting paths...
💥 [BUILDING] Compiling AVIS-DATALAKE Storage Ledger Engine...
💥 [BUILDING] Compiling robo-knight-inventory Asset Discovery API...
💥 [BUILDING] Compiling Cyborg Runtime Package Deployer Integrator...

💎 [SUCCESS] All pure C engines concurrently compiled to absolute binary coordinates: avis/core/v4/bin
💎 [SUCCESS] 4-Core i5 hardware loops cleared. Pipeline runtime matrix is stable.
```

### 📑 Post-Validation Check
Ensure that the `avis/core/v4/bin/` folder contains the three newly generated executable binaries:
* `avis_datalake.exe`
* `robo_knight_inventory.exe`
* `cyborg_deployer.exe`

---

## 🏛️ Test Vector 4: Master Loop Orchestration
This test runs the end-to-end integration loop to confirm that hardware footprints remain stabilized and baseline variables are safe, concluding with full deployment archive generation.

### ⚙️ Execution Hook (Absolute Path Routing)
```cmd
call "avis/core/v4/orchestrator.bat"
```

### 📋 Expected Telemetry Output
The terminal should sequentially display Phase 1 through Phase 5 output blocks without path mutation errors, terminating cleanly with the system completion tokens:
```text
[PHASE 5] Triggering automated deployment batch utility to package system...
[PACKING] Target Output Archive Destination: avis/core/v4/packages/mercwar_release_v4.0.0.zip
[PHASE 5] ... (Native tar compression telemetry) ...

💎 [SUCCESS] Master loop orchestrator successfully executed all cross-repo phases.
💎 [SUCCESS] Systems fully compiled and bundled via absolute subshell architectures.
💎 [SUCCESS] 4-Core i5 / 16GB RAM resource tracks stabilized. Framework is secure.
```
