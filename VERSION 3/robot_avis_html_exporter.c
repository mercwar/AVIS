/*
    robot_avis_html_exporter.c
    PURPOSE:
        Convert AVIS scripts into HTML for GitHub Pages.
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

static void export_html(const char* in_path, const char* out_path) {
    char* content = read_file(in_path);
    if (!content) {
        printf("[HTML] FAILED: %s\n", in_path);
        return;
    }

    FILE* out = fopen(out_path, "wb");
    if (!out) {
        printf("[HTML] FAILED to write: %s\n", out_path);
        free(content);
        return;
    }

    fprintf(out, "<html><body><pre>\n");
    fprintf(out, "%s", content);
    fprintf(out, "</pre></body></html>\n");

    fclose(out);
    free(content);

    printf("[HTML] Exported %s -> %s\n", in_path, out_path);
}

int main(int argc, char** argv) {
    if (argc != 3) {
        printf("Usage: robot_avis_html_exporter <input.avis> <output.html>\n");
        return 1;
    }

    export_html(argv[1], argv[2]);
    return 0;
}
