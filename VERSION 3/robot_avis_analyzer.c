/*
    robot_avis_analyzer.c
    PURPOSE:
        Semantic analysis of AVIS scripts:
            • Detect undefined controls
            • Detect missing window class
            • Detect missing title
            • Detect invalid numeric values
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char* read_file(const char* p) {
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

static void analyze(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[ANALYZER] FAILED: %s\n", path);
        return;
    }

    printf("[ANALYZER] %s\n", path);

    if (!strstr(content, "win.class."))
        printf("  error: missing window class\n");

    if (!strstr(content, "win.title."))
        printf("  error: missing window title\n");

    if (strstr(content, "ctrl.") && !strstr(content, "begin.control"))
        printf("  error: control commands outside control block\n");

    if (strstr(content, "win.width.") && strstr(content, "win.width.0"))
        printf("  error: window width cannot be zero\n");

    if (strstr(content, "win.height.") && strstr(content, "win.height.0"))
        printf("  error: window height cannot be zero\n");

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_analyzer <file.avis>\n");
        return 1;
    }

    analyze(argv[1]);
    return 0;
}
