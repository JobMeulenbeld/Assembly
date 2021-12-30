SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

;%macro printDigit 1
;    mov rax, %1
;    call _printRAXDigit
;%endmacro

;%macro print 1
;    mov rax, %1
;    call _print
;%endmacro

;%macro printDigitSum 2
;    mov rax, %1
;    add rax, %2
;    call _printRAXDigit
;%endmacro

;%macro freeze 0
;    ;label will be unique every time its instantiated
;    %%loop:
;        jmp %%loop
;%endmacro