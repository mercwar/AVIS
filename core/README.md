## 📂 System Directory Structure: avis/core/
```
avis/
└── core/
    ├── README.md               # 💎 System-embedded technical blueprint for AVIS Core
    └── v4/
        ├── manifest.json       # 📑 Machine-readable ecosystem dependency schema
        └── queue/
            ├── task.queue      # 📥 Flat line-by-line task processing system
            └── lock.file       # 🔒 Transactional system write-lock
```
------------------------------
## 📑 Code Layout: avis/core/README.md

# 🧠 AVIS CORE MATRIX — VERSION 4.0.0
Welcome to the internal processing core of the system environment. This directory acts as the central **Deterministic Execution Plane** for our entire distributed codebase. 

By operating out of a unified path layer, this matrix eliminates the need for arbitrary command-line directory changes (`cd`) when executing runtime actions.
## ⚡ Ecosystem Core Mapping
```
┌───────────────────┐
│ AVIS CORE │
│ (This Matrix) │
└─────────┬─────────┘
│
┌───────────────────────┼───────────────────────┐
▼ ▼ ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ AVIS-LOGIC-CORE │ │ AVIS-DATALAKE │ │ robo-knight-* │
│ (PHP Engine V1) │ │ (Pure-C Lake) │ │ (Asset Factory) │
└─────────────────┘ └─────────────────┘ └─────────────────┘

```
## ⚙️ Architectural Layering

* 📥 **v4/queue/task.queue**: The sequential transaction line. Actions are written as plain-text vectors. This allows language models and autonomous crawlers to read and append actions without token or parsing overhead.
* 📑 **v4/manifest.json**: The universal dictionary mapping structural paths and downstream asset boundaries directly to their system footprints.
* 🔒 **v4/queue/lock.file**: The atomic engine lock file preventing file mutation collisions during high-throughput repository iterations.

## 🛡️ Integration Directives

1. **Zero Database Footprint**: No external persistent socket parameters or local configurations may host plain-text credential files inside this tree.
2. **Absolute Path Targeting**: Any server module or tool communicating with `avis/core/` must target scripts explicitly by file location attributes, completely ignoring terminal context changes.
3. **LLM Awareness**: All manifest fields are strictly declared flat to maximize crawling processing accuracy.

------------------------------
## 📑 Code Layout: avis/core/v4/manifest.json
```
{
  "system_identity": "AVIS_CORE",
  "version": "4.0.0",
  "operational_mode": "strict_absolute_paths",
  "manifest_rules": {
    "allow_db_strings": false,
    "require_explicit_directories": true
  },
  "subsystem_endpoints": {
    "backend_processor": "AVIS-LOGIC-CORE/logic/v1",
    "storage_sink": "AVIS-DATALAKE",
    "asset_warehouse": "robo-knight-inventory"
  }
}
```
------------------------------
## 📥 Sample State: avis/core/v4/queue/task.queue
```
[2026-09-10T07:55:00-04:00] PIPELINE_INIT: VERSION=4.0.0 STATUS=ACTIVE SOURCE=AVIS_CORE
[2026-09-10T07:55:12-04:00] DOWNSTREAM_HOOK: REPO=Cyborg TARGET=logic/v1 STATUS=PENDING
[2026-09-10T07:55:15-04:00] DOWNSTREAM_HOOK: REPO=NEXUS TARGET=logic/v1 STATUS=PENDING
[2026-09-10T07:55:18-04:00] DOWNSTREAM_HOOK: REPO=Sentinel TARGET=logic/v1 STATUS=PENDING
```
------------------------------
With the avis/core/ Version 4 layout and its internal README fully built out, what should we build next?

* Move to AVIS-LOGIC-CORE to write the backend engine logic that processes this line-by-line text queue?
* Write out the C-based structures for AVIS-DATALAKE that will store transactions popped from this queue?


