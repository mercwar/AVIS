/*
    robot_avis_runtime.c
    PURPOSE:
        Build a runtime object model from AVIS structures.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct AvisControl {
    char id[64];
    char type[64];
    char text[256];
    int x, y, w, h;
} AvisControl;

typedef struct AvisWindow {
    char class_name[128];
    char proc_name[128];
    char title[256];
    int x, y, w, h;
    AvisControl* controls;
    int control_count;
} AvisWindow;

AvisWindow* create_window_model() {
    AvisWindow* w = malloc(sizeof(AvisWindow));
    memset(w, 0, sizeof(AvisWindow));

    strcpy(w->class_name, "MAINWIN");
    strcpy(w->proc_name, "MAINPROC");
    strcpy(w->title, "MAIN WINDOW");

    w->x = 200;
    w->y = 200;
    w->w = 600;
    w->h = 400;

    w->control_count = 1;
    w->controls = malloc(sizeof(AvisControl));
    strcpy(w->controls[0].id, "LBL1");
    strcpy(w->controls[0].type, "STATIC");
    strcpy(w->controls[0].text, "This is MAIN window");
    w->controls[0].x = 20;
    w->controls[0].y = 20;
    w->controls[0].w = 200;
    w->controls[0].h = 20;

    return w;
}

void dump_window(const AvisWindow* w) {
    printf("=== AVIS WINDOW MODEL ===\n");
    printf("Class: %s\n", w->class_name);
    printf("Proc:  %s\n", w->proc_name);
    printf("Title: %s\n", w->title);
    printf("Pos:   (%d, %d)\n", w->x, w->y);
    printf("Size:  %d x %d\n", w->w, w->h);

    printf("\nControls (%d):\n", w->control_count);
    for (int i = 0; i < w->control_count; ++i) {
        const AvisControl* c = &w->controls[i];
        printf("  [%s] %s \"%s\" (%d,%d,%d,%d)\n",
            c->id, c->type, c->text, c->x, c->y, c->w, c->h);
    }
}

int main(void) {
    AvisWindow* w = create_window_model();
    dump_window(w);
    free(w->controls);
    free(w);
    return 0;
}
