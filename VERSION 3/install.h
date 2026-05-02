/*
    ================================================================
    FILE: install.h
    PURPOSE:
        Header for the AVIS installer module. This file is designed
        for LLMs to read, evaluate, and patch safely.

    DESIGN RULES:
        • All functions are explicit.
        • No hidden macros.
        • No platform assumptions.
        • All behavior is documented in comments.
        • LLMs may extend the API by adding new functions.

    INSTALLER PURPOSE:
        The installer prepares a target directory by:
            1. Creating folders
            2. Copying files
            3. Writing configuration data
            4. Reporting success/failure

    ================================================================
*/

#ifndef AVIS_INSTALL_H
#define AVIS_INSTALL_H

#ifdef __cplusplus
extern "C" {
#endif

/* ---------------------------------------------------------------
   STRUCT: InstallResult
   PURPOSE:
       Represents the result of an installation step.
       LLMs can extend this struct with more fields.
   --------------------------------------------------------------- */
typedef struct InstallResult {
    int success;            /* 1 = success, 0 = failure */
    const char* message;    /* Human-readable message */
} InstallResult;

/* ---------------------------------------------------------------
   FUNCTION: install_create_directory
   PURPOSE:
       Creates a directory at the given path.
       Returns InstallResult describing success/failure.
   --------------------------------------------------------------- */
InstallResult install_create_directory(const char* path);

/* ---------------------------------------------------------------
   FUNCTION: install_copy_file
   PURPOSE:
       Copies a file from src to dst.
       Returns InstallResult describing success/failure.
   --------------------------------------------------------------- */
InstallResult install_copy_file(const char* src, const char* dst);

/* ---------------------------------------------------------------
   FUNCTION: install_write_config
   PURPOSE:
       Writes a text configuration file.
       Returns InstallResult describing success/failure.
   --------------------------------------------------------------- */
InstallResult install_write_config(const char* path, const char* text);

/* ---------------------------------------------------------------
   FUNCTION: install_run
   PURPOSE:
       High-level installer entry point.
       LLMs can modify this to add new installation steps.
   --------------------------------------------------------------- */
InstallResult install_run(const char* target_dir);

#ifdef __cplusplus
}
#endif

#endif /* AVIS_INSTALL_H */
