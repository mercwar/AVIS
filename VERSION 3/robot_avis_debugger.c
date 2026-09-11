/*
    robot_avis_debugger.c
    PURPOSE:
        Step-through debugger for AVIS scripts.
        Robots and LLMs can extend breakpoints, watches, etc.
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

static void debug_line(const char* line, int step) {
    printf("[STEP %d] %s\n", step, line);
    printf("Press ENTER to continue...");
    getchar();
}

static void debug_avis(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[DEBUG] FAILED: %s\n", path);
        return;
    }

    int step = 1;
    char* line = strtok(content, "\n");

    while (line) {
        debug_line(line, step++);
        line = strtok(NULL, "\n");
    }

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_debugger <file.avis>\n");
        return 1;
    }

    debug_avis(argv[1]);
    return 0;
}
