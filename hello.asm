section .data
        digit db 0,10
        text db "Whats up fool!",10,0
        text2 db "How are you doing?",10,0

section .text
    global _start

_printRAXDigit:
    add rax, 48
    mov [digit], al
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 2
    syscall
    ret


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

    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
    ret


_start:

    mov rax, 6
    mov rbx, 3
    div rbx
    call _printRAXDigit


    mov rax, text
    call _print

    mov rax, text2
    call _print


    mov rax, 60
    mov rdi, 0
    syscall