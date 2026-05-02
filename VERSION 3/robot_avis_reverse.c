/*
    robot_avis_reverse.c
    PURPOSE:
        Convert C window structs back into AVIS syntax.
*/

#include <stdio.h>
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

int main(void) {
    AvisWindowReg reg = {
        "MAINWIN",
        "MAINPROC",
        "OVERLAPPEDWINDOW",
        "ARROW",
        "WINDOW",
        "MAIN"
    };

    AvisWindowCreate create = {
        "MAIN WINDOW",
        200, 200,
        600, 400,
        1, 0
    };

    printf("AI.FIRE.START\n\n");

    printf("    begin.seed\n");
    printf("        begin.spec.CWIN.REG\n");
    printf("            win.class.%s\n", reg.class_name);
    printf("            win.proc.%s\n", reg.proc_name);
    printf("            win.style.%s\n", reg.style);
    printf("            win.cursor.%s\n", reg.cursor);
    printf("            win.brush.%s\n", reg.brush);
    printf("            win.icon.%s\n", reg.icon);
    printf("        end.spec\n");
    printf("    end.seed\n\n");

    printf("    begin.spec.CWIN.CREATE\n");
    printf("        win.create.%s\n", reg.class_name);
    printf("        win.title.\"%s\"\n", create.title);
    printf("        win.pos.x.%d\n", create.x);
    printf("        win.pos.y.%d\n", create.y);
    printf("        win.width.%d\n", create.w);
    printf("        win.height.%d\n", create.h);
    printf("        win.show.%d\n", create.show);
    printf("        win.center.%d\n", create.center);
    printf("    end.spec\n\n");

    printf("AI.FIRE.END\n");

    return 0;
}
