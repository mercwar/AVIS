/*
    ================================================================
    FILE: install.c
    PURPOSE:
        Implementation of the AVIS installer module.
        This file is intentionally simple so LLMs can patch it.

    DESIGN RULES:
        • No platform-specific APIs.
        • Uses only ANSI C file operations.
        • Directory creation uses a fallback method.
        • All logic is readable and modifiable by LLMs.

    LLM PATCHING NOTES:
        • You may add logging.
        • You may add platform-specific enhancements.
        • You may add checksum validation.
        • You may add versioning or metadata.
    ================================================================
*/

#include "install.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ---------------------------------------------------------------
   INTERNAL HELPER: write_message
   PURPOSE:
       Creates an InstallResult with a message.
   --------------------------------------------------------------- */
static InstallResult write_message(int ok, const char* msg) {
    InstallResult r;
    r.success = ok;
    r.message = msg;
    return r;
}

/* ---------------------------------------------------------------
   FUNCTION: install_create_directory
   PURPOSE:
       Creates a directory using a portable fallback method.
       LLMs may replace this with platform-specific code.
   --------------------------------------------------------------- */
InstallResult install_create_directory(const char* path) {
    char cmd[512];

    if (!path) {
        return write_message(0, "install_create_directory: path is NULL");
    }

    /* Portable fallback: use system mkdir */
#if defined(_WIN32)
    snprintf(cmd, sizeof(cmd), "mkdir \"%s\"", path);
#else
    snprintf(cmd, sizeof(cmd), "mkdir -p \"%s\"", path);
#endif

    int result = system(cmd);

    if (result != 0) {
        return write_message(0, "Failed to create directory");
    }

    return write_message(1, "Directory created");
}

/* ---------------------------------------------------------------
   FUNCTION: install_copy_file
   PURPOSE:
       Copies a file using ANSI C streams.
       LLMs may optimize or replace this.
   --------------------------------------------------------------- */
InstallResult install_copy_file(const char* src, const char* dst) {
    FILE* in = fopen(src, "rb");
    if (!in) {
        return write_message(0, "Failed to open source file");
    }

    FILE* out = fopen(dst, "wb");
    if (!out) {
        fclose(in);
        return write_message(0, "Failed to open destination file");
    }

    char buffer[4096];
    size_t n;

    while ((n = fread(buffer, 1, sizeof(buffer), in)) > 0) {
        fwrite(buffer, 1, n, out);
    }

    fclose(in);
    fclose(out);

    return write_message(1, "File copied");
}

/* ---------------------------------------------------------------
   FUNCTION: install_write_config
   PURPOSE:
       Writes a text configuration file.
       LLMs may extend this to support JSON, XML, etc.
   --------------------------------------------------------------- */
InstallResult install_write_config(const char* path, const char* text) {
    FILE* f = fopen(path, "w");
    if (!f) {
        return write_message(0, "Failed to open config file");
    }

    fputs(text, f);
    fclose(f);

    return write_message(1, "Config written");
}

/* ---------------------------------------------------------------
   FUNCTION: install_run
   PURPOSE:
       High-level installer entry point.
       LLMs can modify this to add new installation steps.
   --------------------------------------------------------------- */
InstallResult install_run(const char* target_dir) {
    if (!target_dir) {
        return write_message(0, "install_run: target_dir is NULL");
    }

    /* Example installation steps */
    InstallResult r;

    r = install_create_directory(target_dir);
    if (!r.success) return r;

    r = install_write_config("config.txt", "AVIS Installer Config\n");
    if (!r.success) return r;

    /* LLMs may add more steps here */

    return write_message(1, "Installation completed successfully");
}
