%include "macro.asm"

;Input: rax as pointer to string
;Output: print string at rax
_print:
    push rax
    mov rbx, 0
_printLoop:
    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _printLoop

    mov rax, SYS_WRITE
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
    ret