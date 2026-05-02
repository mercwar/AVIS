/*
    robot_avis_language_server.c
    PURPOSE:
        Minimal AVIS language server for syntax checking and hints.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int contains(const char* t, const char* n) {
    return t && n && strstr(t, n) != NULL;
}

static void analyze(const char* text) {
    if (!contains(text, "AI.FIRE.START"))
        printf("LSP: missing FIRE START\n");

    if (!contains(text, "AI.FIRE.END"))
        printf("LSP: missing FIRE END\n");

    if (!contains(text, "begin.seed"))
        printf("LSP: missing SEED block\n");

    if (!contains(text, "begin.spec."))
        printf("LSP: missing SPEC block\n");

    if (contains(text, "ctrl.") && !contains(text, "begin.control"))
        printf("LSP: control commands outside CONTROL block\n");
}

int main(void) {
    char buffer[4096];

    printf("AVIS LSP READY\n");

    while (fgets(buffer, sizeof(buffer), stdin)) {
        analyze(buffer);
    }

    return 0;
}
