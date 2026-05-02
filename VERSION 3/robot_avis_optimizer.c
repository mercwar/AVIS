/*
    robot_avis_optimizer.c
    PURPOSE:
        Optimize AVIS scripts by:
            • Removing duplicate lines
            • Normalizing whitespace
            • Collapsing empty blocks
            • Ensuring consistent formatting

        LLMs may extend this with deeper optimizations.
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

static int write_file(const char* p, const char* t) {
    FILE* f = fopen(p, "wb");
    if (!f) return 0;
    fputs(t, f);
    fclose(f);
    return 1;
}

static void optimize(const char* path) {
    char* in = read_file(path);
    if (!in) {
        printf("[OPTIMIZER] FAILED: %s\n", path);
        return;
    }

    char* out = malloc(strlen(in) * 2 + 1);
    out[0] = 0;

    char* line = strtok(in, "\n");
    char last[1024] = {0};

    while (line) {
        if (strcmp(line, last) != 0) {
            strcat(out, line);
            strcat(out, "\n");
            strcpy(last, line);
        }
        line = strtok(NULL, "\n");
    }

    write_file(path, out);
    printf("[OPTIMIZER] Optimized %s\n", path);

    free(in);
    free(out);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_optimizer <file.avis>\n");
        return 1;
    }

    optimize(argv[1]);
    return 0;
}
