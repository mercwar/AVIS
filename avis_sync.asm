; FILE: avis_sync.asm
; IDENTITY: VERSION 1 // GEMINI_CGI_SCROLL // HAHA!
; ROLE: AVIS Repository Pull/Push Synchronizer
; ENGINE: AVIS-2026 / AIFVS-MODE

section .data
    git_path    db "/usr/bin/git", 0
    
    ; Command Vectors
    arg_pull    db "pull", 0
    arg_add     db "add", 0
    arg_dot     db ".", 0
    arg_commit  db "commit", 0
    arg_m       db "-m", 0
    arg_msg     db "AVIS_AUTO_DISPATCH: VERSION 1", 0
    arg_push    db "push", 0

section .text
    global _start

_start:
    ; --- STEP 1: GIT PULL ---
    mov rdi, git_path
    ; argv array: ["git", "pull", NULL]
    push 0
    push arg_pull
    push git_path
    mov rsi, rsp        ; argv
    call execute_git

    ; --- STEP 2: GIT ADD . ---
    mov rdi, git_path
    push 0
    push arg_dot
    push arg_add
    push git_path
    mov rsi, rsp
    call execute_git

    ; --- STEP 3: GIT COMMIT ---
    mov rdi, git_path
    push 0
    push arg_msg
    push arg_m
    push arg_commit
    push git_path
    mov rsi, rsp
    call execute_git

    ; --- STEP 4: GIT PUSH ---
    mov rdi, git_path
    push 0
    push arg_push
    push git_path
    mov rsi, rsp
    call execute_git

    ; EXIT
    mov rax, 60
    xor rdi, rdi
    syscall

execute_git:
    mov rax, 59         ; sys_execve
    xor rdx, rdx        ; envp = NULL
    syscall
    ret
