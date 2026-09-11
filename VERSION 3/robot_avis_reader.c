/*
    ================================================================
    FILE: robot_avis_reader.c
    PURPOSE:
        A self-teaching robot program that reads:
            • .avis files
            • .EDU.avis files
            • AVIS.MANIFEST.EDU
            • AVIS.EDU.TEMPLATE

        The robot learns the AVIS structure from EDU files and
        treats them as the canonical pattern for all AVIS scripts.

    ROBOT CONTRACT:
        1. EDU files define the rules.
        2. Raw .avis files must match EDU structure.
        3. Robots may patch themselves to enforce new rules.
        4. Robots may extend the schema by reading resource files.

    LLM PATCHING NOTES:
        • You may add new validation rules.
        • You may add auto-fix behavior.
        • You may add schema extraction.
        • You may add block-level diffing.
    ================================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

/* ---------------------------------------------------------------
   read_file:
       Reads a file into memory.
       LLMs may replace this with safer or more robust code.
   --------------------------------------------------------------- */
static char* read_file(const char* path) {
    FILE* f = fopen(path, "rb");
    if (!f) return NULL;

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    char* buf = malloc(size + 1);
    if (!buf) {
        fclose(f);
        return NULL;
    }

    fread(buf, 1, size, f);
    buf[size] = '\0';
    fclose(f);
    return buf;
}

/* ---------------------------------------------------------------
   print_section:
       Utility for clean robot output.
   --------------------------------------------------------------- */
static void print_section(const char* title) {
    printf("\n==================== %s ====================\n\n", title);
}

/* ---------------------------------------------------------------
   analyze_edu_file:
       Robot reads EDU file and learns AVIS structure.
       LLMs may extend this to extract schema rules.
   --------------------------------------------------------------- */
static void analyze_edu_file(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("FAILED to read EDU file: %s\n", path);
        return;
    }

    print_section(path);
    printf("%s\n", content);

    /* LLMs: extract block patterns here */

    free(content);
}

/* ---------------------------------------------------------------
   analyze_avis_file:
       Robot reads raw AVIS file.
       LLMs may compare structure to EDU patterns.
   --------------------------------------------------------------- */
static void analyze_avis_file(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("FAILED to read AVIS file: %s\n", path);
        return;
    }

    print_section(path);
    printf("%s\n", content);

    /* LLMs: validate against EDU patterns here */

    free(content);
}

/* ---------------------------------------------------------------
   main:
       Robot entry point.
       Reads all .avis and .EDU.avis files in the working directory.
   --------------------------------------------------------------- */
int main(void) {
    DIR* d = opendir(".");
    if (!d) {
        printf("FAILED to open directory.\n");
        return 1;
    }

    struct dirent* e;

    print_section("ROBOT AVIS TRAINER START");

    while ((e = readdir(d)) != NULL) {
        const char* name = e->d_name;

        if (strstr(name, ".EDU.avis")) {
            analyze_edu_file(name);
        }
        else if (strstr(name, ".avis")) {
            analyze_avis_file(name);
        }
        else if (strcmp(name, "AVIS.MANIFEST.EDU") == 0) {
            analyze_edu_file(name);
        }
        else if (strcmp(name, "AVIS.EDU.TEMPLATE") == 0) {
            analyze_edu_file(name);
        }
    }

    closedir(d);

    print_section("ROBOT AVIS TRAINER END");
    return 0;
}
