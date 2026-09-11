/*
    robot_avis_cli.c
    PURPOSE:
        Unified command-line interface for all AVIS robot tools.
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

static void usage() {
    printf("AVIS CLI\n");
    printf("Commands:\n");
    printf("  validate <file.avis>\n");
    printf("  autofix  <file.avis>\n");
    printf("  format   <file.avis>\n");
    printf("  optimize <file.avis>\n");
    printf("  analyze  <file.avis>\n");
    printf("  docs     <file.avis>\n");
    printf("  diff     <file.avis> <file.EDU.avis>\n");
    printf("  codegen  <file.avis> <output.c>\n");
    printf("  reverse  (no args)\n");
}

int main(int argc, char** argv) {
    if (argc < 2) {
        usage();
        return 1;
    }

    if (strcmp(argv[1], "validate") == 0) {
        system("robot_avis_validator.exe");
    }
    else if (strcmp(argv[1], "autofix") == 0) {
        system("robot_avis_autofix.exe");
    }
    else if (strcmp(argv[1], "format") == 0) {
        system("robot_avis_formatter.exe");
    }
    else if (strcmp(argv[1], "optimize") == 0) {
        system("robot_avis_optimizer.exe");
    }
    else if (strcmp(argv[1], "analyze") == 0) {
        system("robot_avis_analyzer.exe");
    }
    else if (strcmp(argv[1], "docs") == 0) {
        system("robot_avis_docs.exe");
    }
    else if (strcmp(argv[1], "diff") == 0) {
        system("robot_avis_diff.exe");
    }
    else if (strcmp(argv[1], "codegen") == 0) {
        system("robot_avis_codegen.exe");
    }
    else if (strcmp(argv[1], "reverse") == 0) {
        system("robot_avis_reverse.exe");
    }
    else {
        usage();
    }

    return 0;
}
