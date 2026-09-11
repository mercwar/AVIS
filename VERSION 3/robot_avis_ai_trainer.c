/*
    robot_avis_ai_trainer.c
    PURPOSE:
        Feed AVIS EDU patterns into an LLM-friendly output stream.
        This is the "training" interface for AI systems.
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

static void train_on_file(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[TRAIN] FAILED: %s\n", path);
        return;
    }

    printf("=== TRAINING INPUT: %s ===\n", path);
    printf("%s\n", content);
    printf("=== END TRAINING INPUT ===\n\n");

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_ai_trainer <EDU files...>\n");
        return 1;
    }

    for (int i = 1; i < argc; ++i)
        train_on_file(argv[i]);

    return 0;
}
