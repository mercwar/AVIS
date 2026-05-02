/*
    robot_avis_schema_extractor.c
    PURPOSE:
        Extract AVIS structural schema from EDU files.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char* read_file(const char* path) {
    FILE* f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* buf = malloc(size + 1);
    fread(buf, 1, size, f);
    buf[size] = '\0';
    fclose(f);
    return buf;
}

static void extract_schema(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[SCHEMA] FAILED: %s\n", path);
        return;
    }

    printf("[SCHEMA] Extracting from %s\n", path);

    if (strstr(content, "AI.FIRE.START"))
        printf("  rule: FIRE block required\n");

    if (strstr(content, "begin.seed"))
        printf("  rule: SEED loop required\n");

    if (strstr(content, "begin.spec."))
        printf("  rule: SPEC block required\n");

    if (strstr(content, "begin.control"))
        printf("  rule: CONTROL block optional\n");

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_schema_extractor <EDU file>\n");
        return 1;
    }

    extract_schema(argv[1]);
    return 0;
}
