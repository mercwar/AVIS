/*
    robot_avis_interpreter.c
    PURPOSE:
        Directly interpret AVIS scripts line-by-line.
        No compilation step required.

    NOTES:
        • Symbolic execution only.
        • LLMs may replace printf() with real behavior.
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

static void interpret_line(const char* line) {
    if (strstr(line, "AI.FIRE.START"))
        printf("[INTERPRETER] FIRE block start\n");

    else if (strstr(line, "AI.FIRE.END"))
        printf("[INTERPRETER] FIRE block end\n");

    else if (strstr(line, "begin.seed"))
        printf("[INTERPRETER] SEED loop start\n");

    else if (strstr(line, "end.seed"))
        printf("[INTERPRETER] SEED loop end\n");

    else if (strstr(line, "begin.spec."))
        printf("[INTERPRETER] SPEC block start: %s\n", line);

    else if (strstr(line, "end.spec"))
        printf("[INTERPRETER] SPEC block end\n");

    else if (strstr(line, "begin.control."))
        printf("[INTERPRETER] CONTROL block start: %s\n", line);

    else if (strstr(line, "end.control"))
        printf("[INTERPRETER] CONTROL block end\n");

    else if (strstr(line, "win.") || strstr(line, "ctrl.") || strstr(line, "menu."))
        printf("[INTERPRETER] COMMAND: %s\n", line);
}

static void interpret_avis(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[INTERPRETER] FAILED: %s\n", path);
        return;
    }

    char* line = strtok(content, "\n");
    while (line) {
        interpret_line(line);
        line = strtok(NULL, "\n");
    }

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_interpreter <file.avis>\n");
        return 1;
    }

    interpret_avis(argv[1]);
    return 0;
}
