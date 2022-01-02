
;A macro for exiting the program
%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

;A macro for adding 2 values together
%macro addition 2
    mov rbx, 0
    add rbx, %1
    add rbx, %2
%endmacro