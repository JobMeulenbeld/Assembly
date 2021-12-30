%include "macro.asm"
%include "print_val.asm"
%include "print.asm"

section .data
        text db "Whats up fool!",10,0
        text2 db "How are you doing?",10,0

section .text
    global _start

_start:
    ;printDigit 3
    ;printDigitSum 3,6
    ;print text
    ;print text2
    mov rax, 123
    call _printRAX
    exit