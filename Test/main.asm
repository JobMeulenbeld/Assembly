%include "macro.asm"
%include "print.asm"

section .data
    text1 db "Hello, Welcome to my assembly program!",10,0
    text2 db "Please define how many fibonacci values you would like? (max 93)",10,"(values below 10 like this: 03)",10,0
;------------------------------------------------------------------------------------------------------------------------------
section .bss
    prev_val resq 1
    val resq 1

    increment resd 1
;------------------------------------------------------------------------------------------------------------------------------
section .text
    global _start
;------------------------------------------------------------------------------------------------------------------------------
_setup:
    mov QWORD[prev_val], 0  ;Set the values for the first fibonacci sequence
    mov QWORD[val], 1       

    mov rax, text1  ;Print out the intro text
    call _print

    mov rax, text2  ;Print out more text
    call _print

    call _get_val   ;Get value from user
    ret
    
_fibonacci:
    mov DWORD[increment], 0 ;Set the amount of increments to 0 (like the I in a for-loop)
    mov rax, QWORD[val]
    call _printRAX
_loop:
    mov rcx, 0  ;Set register to 0
    addition QWORD[prev_val], QWORD[val] ;My own addition macro, it gets 2 values and adds them together. The result is stored in the RBX register
    mov rcx, QWORD[val] ;Store the current value
    mov QWORD[val], rbx ;Replace the old value with the new value
    mov QWORD[prev_val], rcx ;Get the current value and store it in the previous variable

    mov rax, QWORD[val] ;Put the new val in the RAX reg for printing
    call _printRAX
    
    mov rdx, [in_val]   ;Get the value from the user into the RDX register
    sub rdx, 1  ;Subtract one for allignment

    add DWORD[increment], 1 ;Increment the I in the loop
    cmp DWORD[increment], edx   ;Compare the I with the given value from the user
    jne _loop   ;If it has not reached the desired amount, go back in the loop
    ret

_start:
    call _setup
    call _fibonacci
    exit