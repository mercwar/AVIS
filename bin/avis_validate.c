/*
    avis_validate.c

    Build:
        cc -std=c11 -Wall -Wextra -O2 avis_validate.c -o avis-validate

    Run:
        ./avis-validate source.c
*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_RULES 2048
#define MAX_LINE 4096
#define MAX_NAME 256

typedef struct {
    char name[MAX_NAME];
    char expression[MAX_LINE];
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

static void strip_comment_prefix(char *line)
{
    char *p = trim(line);

    if (strncmp(p, "//", 2) == 0)
        p = trim(p + 2);
    else if (strncmp(p, "/*", 2) == 0)
        p = trim(p + 2);
    else if (*p == '*')
        p = trim(p + 1);

    memmove(line, p, strlen(p) + 1);
}

static int parse_rule(char *line, Rule *rule, unsigned line_number)
{
    char *separator = strstr(line, "::=");

    if (!separator)
        return 0;

    *separator = '\0';

    char *name = trim(line);
    char *expression = trim(separator + 3);

    if (*name == '\0' || *expression == '\0')
        return -1;

    if (strlen(name) >= MAX_NAME || strlen(expression) >= MAX_LINE)
        return -1;

    strcpy(rule->name, name);
    strcpy(rule->expression, expression);
    rule->line = line_number;

    return 1;
}

static int is_defined(const Rule *rules, size_t count, const char *name)
{
    for (size_t i = 0; i < count; i++) {
        if (strcmp(rules[i].name, name) == 0)
            return 1;
    }

    return 0;
}

static int duplicate_rule(const Rule *rules, size_t count, const char *name)
{
    size_t occurrences = 0;

    for (size_t i = 0; i < count; i++) {
        if (strcmp(rules[i].name, name) == 0)
            occurrences++;
    }

    return occurrences > 1;
}

static int load_rules(FILE *file, Rule *rules, size_t *count)
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

        if (strstr(line, "END AVIS") || strstr(line, "AVIS END")) {
            inside = 0;
            continue;
        }

        char *text = trim(line);

        if (*text == '\0')
            continue;

        if (*count >= MAX_RULES) {
            fprintf(stderr, "error: too many AVIS rules\n");
            return -1;
        }

        int result = parse_rule(text, &rules[*count], line_number);

        if (result == 1) {
            (*count)++;
        } else if (result == -1) {
            fprintf(stderr,
                    "error: invalid rule at source line %u\n",
                    line_number);
            return -1;
        }
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

static int validate_references(const Rule *rules, size_t count)
{
    int errors = 0;

    for (size_t i = 0; i < count; i++) {
        if (duplicate_rule(rules, count, rules[i].name)) {
            fprintf(stderr,
                    "error: duplicate rule '%s' at line %u\n",
                    rules[i].name,
                    rules[i].line);
            errors++;
        }

        const char *p = rules[i].expression;

        while ((p = strchr(p, '<')) != NULL) {
            const char *end = strchr(p, '>');

            if (!end)
                break;

            size_t length = (size_t)(end - p - 1);

            if (length > 0 && length < MAX_NAME) {
                char referenced[MAX_NAME];

                memcpy(referenced, p + 1, length);
                referenced[length] = '\0';

                char wrapped[MAX_NAME + 2];
                snprintf(wrapped, sizeof(wrapped), "<%s>", referenced);

                if (!is_defined(rules, count, wrapped)) {
                    fprintf(stderr,
                            "error: rule '%s' references undefined "
                            "nonterminal %s\n",
                            rules[i].name,
                            wrapped);
                    errors++;
                }
            }

            p = end + 1;
        }
    }

    return errors;
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

    Rule rules[MAX_RULES] = {0};
    size_t count = 0;

    if (load_rules(file, rules, &count) != 0) {
        fclose(file);
        return EXIT_FAILURE;
    }

    fclose(file);

    int errors = validate_references(rules, count);

    if (errors != 0) {
        fprintf(stderr,
                "AVIS validation failed: %d error(s)\n",
                errors);
        return EXIT_FAILURE;
    }

    printf("AVIS validation passed\n");
    printf("Rules checked: %zu\n", count);

    return EXIT_SUCCESS;
}
