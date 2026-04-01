// AVIS-ARTIFACT
// FILE: fire-gem.c
// PURPOSE: FIRE-GEM V2 — Windows version (compile + run C files)
// AUTHOR: Demon

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

#define FORGE_DIR   "VERSION 2/ASM/FORGE/OUT"
#define GEM_OUT     "VERSION 2/ASM/FIRE-GEM/OUT"
#define LOG_PATH    "VERSION 2/ASM/fire-gem.log"

void log_line(const char *text) {
    FILE *f = fopen(LOG_PATH, "a");
    if (!f) return;
    fprintf(f, "%s\n", text);
    fclose(f);
}

void compile_c(const char *input, const char *output) {
    char cmd[512];
    sprintf(cmd, "gcc \"%s\" -o \"%s\"", input, output);
    system(cmd);
}

void run_bin(const char *path) {
    char cmd[512];
    sprintf(cmd, "\"%s\"", path);
    system(cmd);
}

int main(void) {
    mkdir(GEM_OUT);

    FILE *reset = fopen(LOG_PATH, "w");
    if (reset) {
        fprintf(reset, "[AVIS_V2] LOG START\n");
        fclose(reset);
    }

    DIR *d = opendir(FORGE_DIR);
    if (!d) {
        log_line("[AVIS_V2] ERROR: Cannot open FORGE directory");
        return 1;
    }

    int found = 0;
    struct dirent *ent;

    while ((ent = readdir(d)) != NULL) {
        const char *name = ent->d_name;
        size_t len = strlen(name);

        if (len < 3 || strcmp(name + len - 2, ".c") != 0)
            continue;

        found = 1;

        char src[512], dst[512];
        snprintf(src, sizeof(src), "%s/%s", FORGE_DIR, name);

        char outname[256];
        snprintf(outname, sizeof(outname), "%.*s.exe", (int)(len - 2), name);

        snprintf(dst, sizeof(dst), "%s/%s", GEM_OUT, outname);

        char msg[512];
        sprintf(msg, "[AVIS_V2] COMPILING: %s -> %s", src, dst);
        log_line(msg);

        compile_c(src, dst);

        sprintf(msg, "[AVIS_V2] EXECUTING: %s", dst);
        log_line(msg);

        run_bin(dst);
    }

    closedir(d);

    if (!found) {
        log_line("[AVIS_V2] FORGE DIRECTORY EMPTY — NOTHING TO COMPILE, NOTHING TO RUN");
    }

    return 0;
}
