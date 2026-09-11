/*
    robot_avis_docs.c
    PURPOSE:
        Generate documentation from AVIS scripts.
        Output is plain text for LLM consumption.
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

static void generate_docs(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[DOCS] FAILED: %s\n", path);
        return;
    }

    printf("=== AVIS DOCUMENTATION: %s ===\n\n", path);

    char* line = strtok(content, "\n");
    while (line) {
        if (strstr(line, "begin.spec."))
            printf("SPEC BLOCK: %s\n", line);

        else if (strstr(line, "begin.control."))
            printf("CONTROL BLOCK: %s\n", line);

        else if (strstr(line, "win.") || strstr(line, "ctrl.") || strstr(line, "menu."))
            printf("COMMAND: %s\n", line);

        line = strtok(NULL, "\n");
    }

    printf("\n=== END DOCUMENTATION ===\n");

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_docs <file.avis>\n");
        return 1;
    }

    generate_docs(argv[1]);
    return 0;
}
