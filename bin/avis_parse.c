/*
    avis_parse.c — AVIS grammar parser

    Converts AVIS rules into a simple in-memory rule list.

    Build:
        cc -std=c11 -Wall -Wextra -O2 avis_parse.c -o avis_parse

    Run:
        ./avis_parse source.c
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 4096
#define MAX_RULES 1024
#define MAX_NAME 256

typedef struct {
    char name[MAX_NAME];
    char expression[MAX_LINE];
    unsigned line;
} AvisRule;

static char *trim(char *text)
{
    while (*text == ' ' || *text == '\t' ||
           *text == '\r' || *text == '\n')
        text++;

    char *end = text + strlen(text);

    while (end > text &&
           (end[-1] == ' ' || end[-1] == '\t' ||
            end[-1] == '\r' || end[-1] == '\n'))
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

static int parse_file(FILE *file, AvisRule *rules, size_t *count)
{
    char line[MAX_LINE];
    unsigned line_number = 0;
    int inside = 0;
    int found = 0;

    while (fgets(line, sizeof(line), file)) {
        line_number++;

        if (!inside && strstr(line, "AVIS")) {
            inside = 1;
            found = 1;
            continue;
        }

        if (!inside)
            continue;

        strip_comment_prefix(line);

        if (strstr(line, "END AVIS") ||
            strstr(line, "AVIS END")) {
            inside = 0;
            continue;
        }

        char *text = trim(line);

        if (*text == '\0')
            continue;

        char *separator = strstr(text, "::=");

        if (!separator)
            continue;

        if (*count >= MAX_RULES) {
            fprintf(stderr, "error: rule limit exceeded\n");
            return -1;
        }

        *separator = '\0';

        char *name = trim(text);
        char *expression = trim(separator + 3);

        if (strlen(name) >= MAX_NAME ||
            strlen(expression) >= MAX_LINE) {
            fprintf(stderr, "error: rule too long at line %u\n",
                    line_number);
            return -1;
        }

        strcpy(rules[*count].name, name);
        strcpy(rules[*count].expression, expression);
        rules[*count].line = line_number;

        (*count)++;
    }

    if (!found) {
        fprintf(stderr, "error: no AVIS block found\n");
        return -1;
    }

    if (inside) {
        fprintf(stderr, "error: unterminated AVIS block\n");
        return -1;
    }

    return 0;
}

static void print_rule(const AvisRule *rule, size_t index)
{
    printf("RULE %zu\n", index + 1);
    printf("  NAME: %s\n", rule->name);
    printf("  LINE: %u\n", rule->line);
    printf("  BODY: %s\n", rule->expression);
    putchar('\n');
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

    AvisRule rules[MAX_RULES] = {0};
    size_t count = 0;

    int result = parse_file(file, rules, &count);
    fclose(file);

    if (result != 0)
        return EXIT_FAILURE;

    printf("AVIS parse complete\n");
    printf("RULE_COUNT: %zu\n\n", count);

    for (size_t i = 0; i < count; i++)
        print_rule(&rules[i], i);

    return EXIT_SUCCESS;
}
