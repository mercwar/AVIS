/*
    robot_avis_packager.c
    PURPOSE:
        Bundle AVIS + EDU + schema into a single .avisbundle file.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char* read(const char* p) {
    FILE* f = fopen(p, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long s = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* b = malloc(s + 1);
    fread(b, 1, s, f);
    b[s] = '\0';
    fclose(f);
    return b;
}

static void pack(const char* avis, const char* edu, const char* schema, const char* out) {
    char* a = read(avis);
    char* e = read(edu);
    char* s = read(schema);

    if (!a || !e || !s) {
        printf("[PACKAGER] FAILED to read input files\n");
        return;
    }

    FILE* f = fopen(out, "wb");
    if (!f) {
        printf("[PACKAGER] FAILED to write bundle\n");
        return;
    }

    fprintf(f, "=== AVIS ===\n%s\n", a);
    fprintf(f, "=== EDU ===\n%s\n", e);
    fprintf(f, "=== SCHEMA ===\n%s\n", s);

    fclose(f);

    printf("[PACKAGER] Created bundle: %s\n", out);

    free(a);
    free(e);
    free(s);
}

int main(int argc, char** argv) {
    if (argc != 5) {
        printf("Usage: robot_avis_packager <file.avis> <file.EDU.avis> <schema.json> <output.avisbundle>\n");
        return 1;
    }

    pack(argv[1], argv[2], argv[3], argv[4]);
    return 0;
}
