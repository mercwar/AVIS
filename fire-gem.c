/*******************************************************************************
 * TYPE: ENGINE | CLASS: FORGE-CORE | NAME: fire-gem.c
 * IDENTITY: VERSION 2.0 // WINDOWS_FORGE_CORE // HAHA!
 * ROLE: Scan FORGE, Strike to EXE, and Execute. No .sh, no .yml logic.
 *******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <direct.h>   // Required for _mkdir on Windows

#define FORGE_DIR   "VERSION 2/ASM/FORGE/OUT"
#define GEM_OUT     "VERSION 2/ASM/FIRE-GEM/OUT"
#define LOG_PATH    "VERSION 2/ASM/fire-gem.log"

// ------------------------------------------------------------
// LOGGING SYSTEM: DIRECT STREAM TO LOG_PATH
// ------------------------------------------------------------
void log_line(const char *text) {
    FILE *f = fopen(LOG_PATH, "a");
    if (!f) return;
    fprintf(f, "%s\n", text);
    printf("%s\n", text); // Also output to console for GitHub Action logs
    fclose(f);
}

// ------------------------------------------------------------
// FORGE COMMAND: CALLS GCC TO STRIKE BINARY
// ------------------------------------------------------------
void compile_c(const char *input, const char *output) {
    char cmd[1024];
    // Use quotes around paths to handle spaces in Windows
    sprintf(cmd, "gcc \"%s\" -o \"%s\"", input, output);
    system(cmd);
}

// ------------------------------------------------------------
// EXECUTION COMMAND: RUNS THE NEWLY FORGED EXE
// ------------------------------------------------------------
void run_bin(const char *path) {
    char cmd[1024];
    sprintf(cmd, "\"%s\"", path);
    system(cmd);
}

// ------------------------------------------------------------
// MASTER ENGINE
// ------------------------------------------------------------
int main(void) {
    // 1. SEAT THE VAULTS
    _mkdir("VERSION 2");
    _mkdir("VERSION 2/ASM");
    _mkdir("VERSION 2/ASM/FIRE-GEM");
    _mkdir(GEM_OUT);

    // 2. RESET LOG FOR NEW PULSE
    FILE *reset = fopen(LOG_PATH, "w");
    if (reset) {
        fprintf(reset, "[AVIS_V2] IDENTITY VERIFIED: FORGE START\n");
        fclose(reset);
    }

    // 3. OPEN THE FORGE FOR DISCOVERY
    DIR *d = opendir(FORGE_DIR);
    if (!d) {
        log_line("[AVIS_V2] ERROR: FORGE DIRECTORY NOT FOUND. SEATING EMPTY VAULT.");
        return 1;
    }

    struct dirent *ent;
    int found = 0;

    // 4. SCAN AND STRIKE LOOP
    while ((ent = readdir(d)) != NULL) {
        const char *name = ent->d_name;
        size_t len = strlen(name);

        // Filter: Target only .c files, skip directories
        if (len < 3 || strcmp(name + len - 2, ".c") != 0)
            continue;

        found = 1;
        char src[512], dst[512], outname[256];

        // Format paths
        snprintf(src, sizeof(src), "%s/%s", FORGE_DIR, name);
        snprintf(outname, sizeof(outname), "%.*s.exe", (int)(len - 2), name);
        snprintf(dst, sizeof(dst), "%s/%s", GEM_OUT, outname);

        // LOG AND STRIKE
        char msg[1024];
        sprintf(msg, "[AVIS_V2] FORGING: %s", name);
        log_line(msg);

        compile_c(src, dst);

        // EXECUTE THE STRIKE
        sprintf(msg, "[AVIS_V2] EXECUTING PULSE: %s", outname);
        log_line(msg);
        
        run_bin(dst);
    }

    closedir(d);

    if (!found) {
        log_line("[AVIS_V2] VAULT EMPTY: NO ASSETS DETECTED FOR FORGE.");
    } else {
        log_line("[AVIS_V2] FORGE CYCLE COMPLETE. [wm_macro_ack]");
    }

    return 0;
}
