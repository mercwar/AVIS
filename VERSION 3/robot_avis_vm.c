/*
    robot_avis_vm.c
    PURPOSE:
        Execute AVIS scripts using a tiny VM with symbolic opcodes.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    OP_FIRE_START,
    OP_FIRE_END,
    OP_SEED_BEGIN,
    OP_SEED_END,
    OP_SPEC_BEGIN,
    OP_SPEC_END,
    OP_CONTROL_BEGIN,
    OP_CONTROL_END,
    OP_COMMAND
} AvisOpcode;

typedef struct {
    AvisOpcode op;
    char text[256];
} AvisInstruction;

static AvisInstruction make(AvisOpcode op, const char* text) {
    AvisInstruction i;
    i.op = op;
    strncpy(i.text, text, 255);
    return i;
}

static void vm_exec(const AvisInstruction* inst) {
    switch (inst->op) {
        case OP_FIRE_START:   printf("[VM] FIRE START\n"); break;
        case OP_FIRE_END:     printf("[VM] FIRE END\n"); break;
        case OP_SEED_BEGIN:   printf("[VM] SEED BEGIN\n"); break;
        case OP_SEED_END:     printf("[VM] SEED END\n"); break;
        case OP_SPEC_BEGIN:   printf("[VM] SPEC BEGIN: %s\n", inst->text); break;
        case OP_SPEC_END:     printf("[VM] SPEC END\n"); break;
        case OP_CONTROL_BEGIN:printf("[VM] CONTROL BEGIN: %s\n", inst->text); break;
        case OP_CONTROL_END:  printf("[VM] CONTROL END\n"); break;
        case OP_COMMAND:      printf("[VM] CMD: %s\n", inst->text); break;
    }
}

int main(void) {
    AvisInstruction program[] = {
        make(OP_FIRE_START, ""),
        make(OP_SEED_BEGIN, ""),
        make(OP_SPEC_BEGIN, "CWIN.REG"),
        make(OP_COMMAND, "win.class.MAINWIN"),
        make(OP_SPEC_END, ""),
        make(OP_SEED_END, ""),
        make(OP_FIRE_END, "")
    };

    int count = sizeof(program) / sizeof(program[0]);
    for (int i = 0; i < count; ++i)
        vm_exec(&program[i]);

    return 0;
}
