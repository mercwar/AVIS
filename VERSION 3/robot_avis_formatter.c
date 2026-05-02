/*
    robot_avis_formatter.c
    PURPOSE:
        Format .avis files into consistent EDU-style indentation.
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

static int write_file(const char* path, const char* text) {
    FILE* f = fopen(path, "wb");
    if (!f) return 0;
    fputs(text, f);
    fclose(f);
    return 1;
}

static void format_avis(const char* path) {
    char* in = read_file(path);
    if (!in) {
        printf("[FORMAT] FAILED: %s\n", path);
        return;
    }

    char* out = malloc(strlen(in) * 2 + 1);
    out[0] = 0;

    int indent = 0;
    char* line = strtok(in, "\n");

    while (line) {
        if (strstr(line, "end.") == line)
            indent--;

        for (int i = 0; i < indent; ++i)
            strcat(out, "    ");

        strcat(out, line);
        strcat(out, "\n");

        if (strstr(line, "begin.") == line)
            indent++;

        line = strtok(NULL, "\n");
    }

    write_file(path, out);
    printf("[FORMAT] %s formatted\n", path);

    free(in);
    free(out);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_formatter <file.avis>\n");
        return 1;
    }

    format_avis(argv[1]);
    return 0;
}
