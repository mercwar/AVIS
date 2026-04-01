// AVIS-ARTIFACT
// FILE: fire-gem.c
// PURPOSE: FIRE-GEM V2 — compile ASM files using gcc and run them
// AUTHOR: Demon

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/stat.h>

#define FORGE_DIR   "VERSION 2/ASM/FORGE/OUT"
#define GEM_OUT     "VERSION 2/ASM/FIRE-GEM/OUT"
#define LOG_PATH    "VERSION 2/ASM/fire-gem.log"

// ------------------------------------------------------------
// LOG FUNCTION
// ------------------------------------------------------------
void log_line(const char *text) {
    FILE *f = fopen(LOG_PATH, "a");
    if (!f) return;
    fprintf(f, "%s\n", text);
    fclose(f);
}

// ------------------------------------------------------------
// GCC COMPILE FUNCTION
// ------------------------------------------------------------
// gcc <input.asm> -o <output.bin>
int compile_asm(const char *input, const char *output) {
    pid_t pid = fork();
    if (pid == 0) {
        execl("/usr/bin/gcc", "gcc", input, "-o", output, NULL);
        exit(1);
    }
    int status = 0;
    waitpid(pid, &status, 0);
    return status;
}

// ------------------------------------------------------------
// RUN EXECUTABLE
// ------------------------------------------------------------
void run_bin(const char *path) {
    pid_t pid = fork();
    if (pid == 0) {
        execl(path, path, NULL);
        exit(1);
    }
    waitpid(pid, NULL, 0);
}

// ------------------------------------------------------------
// MAIN FORGE ENGINE
// ------------------------------------------------------------
int main(void) {
    mkdir(GEM_OUT, 0777);

    // reset log
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

    struct dirent *ent;
    while ((ent = readdir(d)) != NULL) {
        const char *name = ent->d_name;
        size_t len = strlen(name);

        if (len < 5 || strcmp(name + len - 4, ".asm") != 0)
            continue;

        char src[512], dst[512];
        snprintf(src, sizeof(src), "%s/%s", FORGE_DIR, name);

        // output name: replace .asm with .bin
        char outname[256];
        snprintf(outname, sizeof(outname), "%.*s.bin", (int)(len - 4), name);

        snprintf(dst, sizeof(dst), "%s/%s", GEM_OUT, outname);

        char msg[512];
        snprintf(msg, sizeof(msg), "[AVIS_V2] COMPILING: %s -> %s", src, dst);
        log_line(msg);

        compile_asm(src, dst);

        snprintf(msg, sizeof(msg), "[AVIS_V2] EXECUTING: %s", dst);
        log_line(msg);

        run_bin(dst);
    }

    closedir(d);
    return 0;
}
