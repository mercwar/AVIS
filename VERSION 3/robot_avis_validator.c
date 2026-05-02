/*
    robot_avis_autofix.c
    PURPOSE:
        Auto-fix missing AVIS structural elements.
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

static int write_file(const char* path, const char* text) {
    FILE* f = fopen(path, "wb");
    if (!f) return 0;
    fputs(text, f);
    fclose(f);
    return 1;
}

static int contains(const char* text, const char* needle) {
    return text && needle && strstr(text, needle) != NULL;
}

static void autofix_avis(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[AUTOFIX] FAILED: %s\n", path);
        return;
    }

    int modified = 0;
    size_t len = strlen(content);
    char* out = NULL;

    if (!contains(content, "AI.FIRE.START")) {
        const char* prefix = "AI.FIRE.START\n\n";
        out = malloc(strlen(prefix) + len + 1);
        strcpy(out, prefix);
        strcat(out, content);
        free(content);
        content = out;
        len = strlen(content);
        modified = 1;
        printf("[AUTOFIX] %s: added AI.FIRE.START\n", path);
    }

    if (!contains(content, "AI.FIRE.END")) {
        const char* suffix = "\n\nAI.FIRE.END\n";
        out = malloc(len + strlen(suffix) + 1);
        strcpy(out, content);
        strcat(out, suffix);
        free(content);
        content = out;
        len = strlen(content);
        modified = 1;
        printf("[AUTOFIX] %s: added AI.FIRE.END\n", path);
    }

    if (modified) {
        if (write_file(path, content))
            printf("[AUTOFIX] %s: fixed\n", path);
        else
            printf("[AUTOFIX] %s: FAILED to write\n", path);
    } else {
        printf("[AUTOFIX] %s: no changes needed\n", path);
    }

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_autofix <file.avis> [...]\n");
        return 1;
    }

    for (int i = 1; i < argc; ++i)
        autofix_avis(argv[i]);

    return 0;
}
