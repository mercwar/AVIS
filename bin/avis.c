/*
    avis.c — minimal AVIS comment-wrapper reader

    Supported wrapper forms:

        /* AVIS
           <document> ::= <header> <body>
           <header>   ::= "hello"
        END AVIS *\/

    or:

        // AVIS
        // <document> ::= <header> <body>
        // END AVIS

    Build:
        cc -std=c11 -Wall -Wextra -O2 avis.c -o avis

    Run:
        ./avis source.c
*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 4096
#define MAX_RULES 2048

typedef struct {
    char *name;
    char *expression;
    unsigned line;
} Rule;

static char *trim(char *s)
{
    while (isspace((unsigned char)*s))
        s++;

    char *end = s + strlen(s);

    while (end > s && isspace((unsigned char)end[-1]))
        *--end = '\0';

    return s;
}

static int is_avis_start(const char *line)
{
    return strstr(line, "AVIS") != NULL;
}

static int is_avis_end(const char *line)
{
    return strstr(line, "END AVIS") != NULL ||
           strstr(line, "AVIS END") != NULL;
}

static void remove_comment_markers(char *line)
{
    char *p = trim(line);

    if (strncmp(p, "//", 2) == 0) {
        p += 2;
        p = trim(p);
        memmove(line, p, strlen(p) + 1);
        return;
    }

    if (strncmp(p, "*", 1) == 0) {
        p += 1;
        p = trim(p);
        memmove(line, p, strlen(p) + 1);
        return;
    }

    if (strncmp(p, "/*", 2) == 0) {
        p += 2;
        p = trim(p);
        memmove(line, p, strlen(p) + 1);
        return;
    }

    if (strncmp(p, "*/", 2) == 0) {
        p += 2;
        p = trim(p);
        memmove(line, p, strlen(p) + 1);
    }
}

static int parse_rule(char *line, Rule *rule, unsigned line_number)
{
    char *separator = strstr(line, "::=");

    if (separator == NULL)
        separator = strstr(line, ":=");

    if (separator == NULL)
        return 0;

    char *name = line;
    char *expression = separator + 3;

    if (separator[1] == '=' && separator[2] != '=')
        expression = separator + 2;

    *separator = '\0';

    name = trim(name);
    expression = trim(expression);

    if (*name == '\0' || *expression == '\0')
        return -1;

    rule->name = malloc(strlen(name) + 1);
    rule->expression = malloc(strlen(expression) + 1);

    if (!rule->name || !rule->expression) {
        fprintf(stderr, "memory allocation failed\n");
        exit(EXIT_FAILURE);
    }

    strcpy(rule->name, name);
    strcpy(rule->expression, expression);
    rule->line = line_number;

    return 1;
}

static void free_rules(Rule *rules, size_t count)
{
    for (size_t i = 0; i < count; i++) {
        free(rules[i].name);
        free(rules[i].expression);
    }
}

static int read_avis(FILE *file, Rule *rules, size_t *rule_count)
{
    char line[MAX_LINE];
    unsigned line_number = 0;
    int inside = 0;
    int found = 0;

    while (fgets(line, sizeof(line), file)) {
        line_number++;

        if (!inside && is_avis_start(line)) {
            inside = 1;
            found = 1;
            continue;
        }

        if (!inside)
            continue;

        remove_comment_markers(line);

        if (is_avis_end(line)) {
            inside = 0;
            continue;
        }

        char *text = trim(line);

        if (*text == '\0')
            continue;

        if (*rule_count >= MAX_RULES) {
            fprintf(stderr, "too many AVIS rules\n");
            return -1;
        }

        int result = parse_rule(text, &rules[*rule_count], line_number);

        if (result == 1) {
            (*rule_count)++;
        } else if (result == -1) {
            fprintf(stderr,
                    "invalid AVIS rule at line %u: %s\n",
                    line_number,
                    text);
            return -1;
        }
    }

    if (inside) {
        fprintf(stderr, "unterminated AVIS block\n");
        return -1;
    }

    if (!found) {
        fprintf(stderr, "no AVIS block found\n");
        return -1;
    }

    return 0;
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s source-file\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *file = fopen(argv[1], "rb");

    if (!file) {
        perror(argv[1]);
        return EXIT_FAILURE;
    }

    Rule rules[MAX_RULES] = {0};
    size_t rule_count = 0;

    int status = read_avis(file, rules, &rule_count);
    fclose(file);

    if (status != 0) {
        free_rules(rules, rule_count);
        return EXIT_FAILURE;
    }

    printf("AVIS grammar loaded successfully\n");
    printf("Rules: %zu\n\n", rule_count);

    for (size_t i = 0; i < rule_count; i++) {
        printf("%4u  %s ::= %s\n",
               rules[i].line,
               rules[i].name,
               rules[i].expression);
    }

    free_rules(rules, rule_count);
    return EXIT_SUCCESS;
}
