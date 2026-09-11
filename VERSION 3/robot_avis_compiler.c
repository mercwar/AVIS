/*
    robot_avis_compiler.c
    PURPOSE:
        Convert AVIS scripts into C structs.
        This is the foundation for a real AVIS engine.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char class_name[128];
    char proc_name[128];
    char style[256];
    char cursor[64];
    char brush[64];
    char icon[64];
} AvisWindowReg;

typedef struct {
    char title[256];
    int x, y, w, h;
    int show;
    int center;
} AvisWindowCreate;

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

static void compile_avis(const char* path) {
    char* content = read_file(path);
    if (!content) {
        printf("[COMPILER] FAILED: %s\n", path);
        return;
    }

    AvisWindowReg reg = {0};
    AvisWindowCreate create = {0};

    char* line = strtok(content, "\n");

    while (line) {
        if (strstr(line, "win.class."))
            sscanf(line, "win.class.%127s", reg.class_name);

        if (strstr(line, "win.proc."))
            sscanf(line, "win.proc.%127s", reg.proc_name);

        if (strstr(line, "win.style."))
            sscanf(line, "win.style.%255[^\n]", reg.style);

        if (strstr(line, "win.cursor."))
            sscanf(line, "win.cursor.%63s", reg.cursor);

        if (strstr(line, "win.brush."))
            sscanf(line, "win.brush.%63s", reg.brush);

        if (strstr(line, "win.icon."))
            sscanf(line, "win.icon.%63s", reg.icon);

        if (strstr(line, "win.title."))
            sscanf(line, "win.title.\"%255[^\"]\"", create.title);

        if (strstr(line, "win.pos.x."))
            sscanf(line, "win.pos.x.%d", &create.x);

        if (strstr(line, "win.pos.y."))
            sscanf(line, "win.pos.y.%d", &create.y);

        if (strstr(line, "win.width."))
            sscanf(line, "win.width.%d", &create.w);

        if (strstr(line, "win.height."))
            sscanf(line, "win.height.%d", &create.h);

        if (strstr(line, "win.show."))
            sscanf(line, "win.show.%d", &create.show);

        if (strstr(line, "win.center."))
            sscanf(line, "win.center.%d", &create.center);

        line = strtok(NULL, "\n");
    }

    printf("[COMPILER] Window Registration:\n");
    printf("  class  = %s\n", reg.class_name);
    printf("  proc   = %s\n", reg.proc_name);
    printf("  style  = %s\n", reg.style);
    printf("  cursor = %s\n", reg.cursor);
    printf("  brush  = %s\n", reg.brush);
    printf("  icon   = %s\n", reg.icon);

    printf("\n[COMPILER] Window Creation:\n");
    printf("  title  = %s\n", create.title);
    printf("  pos    = (%d, %d)\n", create.x, create.y);
    printf("  size   = %d x %d\n", create.w, create.h);
    printf("  show   = %d\n", create.show);
    printf("  center = %d\n", create.center);

    free(content);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: robot_avis_compiler <file.avis>\n");
        return 1;
    }

    compile_avis(argv[1]);
    return 0;
}
