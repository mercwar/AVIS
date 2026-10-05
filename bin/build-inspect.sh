/*
    avis_inspect.c — AVIS grammar inspector

    Build:
        ./build-inspect.sh

    Run:
        ./avis_inspect source.c
*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 4096

static char *trim(char *text)
{
    while (isspace((unsigned char)*text))
        text++;

    char *end = text + strlen(text);

    while (end > text && isspace((unsigned char)end[-1]))
        *--end = '\0';

    return text;
}

static void strip_comment_prefix(char *line)
{
    char *text = trim(line);

    if (strncmp(text, "//", 2) == 0)
        text = trim(text + 2);
    else if (strncmp(text, "/*", 2) == 0)
        text = trim(text + 2);
    else if (*text == '*')
        text = trim(text + 1);

    memmove(line, text, strlen(text) + 1);
}

static void inspect_expression(const char *expression)
{
    const char *cursor = expression;

    while (*cursor) {
        while (isspace((unsigned char)*cursor))
            cursor++;

        if (!*cursor)
            break;

        if (*cursor == '|') {
            printf("    ALTERNATIVE\n");
            cursor++;
            continue;
        }

        if (*cursor == '<') {
            const char *end = strchr(cursor, '>');

            if (end) {
                printf("    NONTERMINAL: %.*s\n",
                       (int)(end - cursor + 1),
                       cursor);
                cursor = end + 1;
                continue;
            }
        }

        if (*cursor == '"') {
            const char *end = strchr(cursor + 1, '"');

            if (end) {
                printf("    TERMINAL: %.*s\n",
                       (int)(end - cursor + 1),
                       cursor);
                cursor = end + 1;
                continue;
            }
        }

        const char *end = cursor;

        while (*end &&
               !isspace((unsigned char)*end) &&
               *end != '|') {
            end++;
        }

        printf("    TOKEN: %.*s\n",
               (int)(end - cursor),
               cursor);

        cursor = end;
    }
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s source.c\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *file = fopen(argv[1], "r");

    if (!file) {
        perror(argv[1]);
        return EXIT_FAILURE;
    }

    char line[MAX_LINE];
    unsigned line_number = 0;
    int inside_avis = 0;
    int found_avis = 0;

    while (fgets(line, sizeof(line), file)) {
        line_number++;

        if (!inside_avis && strstr(line, "AVIS")) {
            inside_avis = 1;
            found_avis = 1;
            continue;
        }

        if (!inside_avis)
            continue;

        strip_comment_prefix(line);

        if (strstr(line, "END AVIS") ||
            strstr(line, "AVIS END")) {
            inside_avis = 0;
            continue;
        }

        char *text = trim(line);

        if (*text == '\0')
            continue;

        char *separator = strstr(text, "::=");

        if (!separator)
            continue;

        *separator = '\0';

        char *name = trim(text);
        char *expression = trim(separator + 3);

        printf("RULE %s\n", name);
        printf("  SOURCE_LINE: %u\n", line_number);
        printf("  EXPRESSION: %s\n", expression);

        inspect_expression(expression);
        putchar('\n');
    }

    fclose(file);

    if (!found_avis) {
        fprintf(stderr, "error: no AVIS block found\n");
        return EXIT_FAILURE;
    }

    if (inside_avis) {
        fprintf(stderr, "error: unterminated AVIS block\n");
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
