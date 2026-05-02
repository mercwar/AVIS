/*
    robot_avis_linter.c
    PURPOSE:
        Emit warnings for AVIS structural issues.
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

static void lint_avis(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[LINT] FAILED: %s\n", path);
        return;
    }

    printf("[LINT] %s\n", path);

    if (!contains(content, "AVIS.FVS.2026"))
        printf("  warning: missing AVIS.FVS.2026 header\n");

    if (!contains(content, "begin.seed"))
        printf("  warning: missing begin.seed\n");

    if (!contains(content, "begin.spec."))
        printf("  warning: missing begin.spec.<MODULE>.<FUNCTION>\n");

    if (contains(content, "win.style.") && !strstr(content, "|"))
        printf("  note: win.style present without combined flags\n");

    if (!contains(content, "begin.control") && contains(content, "ctrl."))
        printf("  warning: ctrl.* used without control block\n");

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_linter <file.avis> [...]\n");
        return 1;
    }

    for (int i = 1; i < argc; ++i)
        lint_avis(argv[i]);

    return 0;
}
