/*
    robot_avis_validator.c
    PURPOSE:
        Validate .avis files against AVIS structural rules.
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
    if (!buf) { fclose(f); return NULL; }
    fread(buf, 1, size, f);
    buf[size] = '\0';
    fclose(f);
    return buf;
}

static int contains(const char* text, const char* needle) {
    return text && needle && strstr(text, needle) != NULL;
}

static void validate_avis(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[VALIDATOR] FAILED: %s\n", path);
        return;
    }

    int ok = 1;

    if (!contains(content, "AI.FIRE.START")) {
        printf("[VALIDATOR] %s: missing AI.FIRE.START\n", path);
        ok = 0;
    }
    if (!contains(content, "AI.FIRE.END")) {
        printf("[VALIDATOR] %s: missing AI.FIRE.END\n", path);
        ok = 0;
    }
    if (!contains(content, "begin.seed")) {
        printf("[VALIDATOR] %s: missing begin.seed\n", path);
        ok = 0;
    }
    if (!contains(content, "end.seed")) {
        printf("[VALIDATOR] %s: missing end.seed\n", path);
        ok = 0;
    }
    if (!contains(content, "begin.spec.")) {
        printf("[VALIDATOR] %s: missing begin.spec.<MODULE>.<FUNCTION>\n", path);
        ok = 0;
    }
    if (!contains(content, "end.spec")) {
        printf("[VALIDATOR] %s: missing end.spec\n", path);
        ok = 0;
    }

    if (ok)
        printf("[VALIDATOR] %s: OK\n", path);

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_validator <file.avis> [...]\n");
        return 1;
    }

    for (int i = 1; i < argc; ++i)
        validate_avis(argv[i]);

    return 0;
}
