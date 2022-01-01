%include "macro.asm"
%include "print.asm"

section .data
    text1 db "Hello, Welcome to my assembly program!",10,0
    text2 db "Please define how many fibonacci values you would like? (max 92)",10,0

section .bss
    prev_val resq 1
    val resq 1

    increment resd 1

section .text
    global _start

_setup:
    mov QWORD[prev_val], 0
    mov QWORD[val], 1

    mov rax, text1
    call _print

    mov rax, text2
    call _print

    call _get_val
    ret
    
_fibonacci:
    mov DWORD[increment], 0
    mov rax, QWORD[val]
    call _printRAX
_loop:
    mov rcx, 0
    addition QWORD[prev_val], QWORD[val]
    mov rcx, QWORD[val]
    mov QWORD[val], rbx
    mov QWORD[prev_val], rcx

    mov rax, QWORD[val]
    call _printRAX
    
    add DWORD[increment], 1
    cmp DWORD[increment], 92
    jne _loop
    ret

_start:
    call _setup
    call _fibonacci
    exit