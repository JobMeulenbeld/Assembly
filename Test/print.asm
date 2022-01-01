section .data
    txt1 db "Wrong value, please enter a new one:",10,0

section .bss
    digitSpace resb 100
    digitSpacePos resb 8

    input resb 2
    in_val resd 1
section .text

_printRAX:
    ;Because we start backwards, the first thing we do is store the pointer to our variable in the rcx register
    ;We will store the values backwards, this way we can read out the values in the proper order since its
    ;a stack.
    ;Now we add a newline character to the register rbx and store it into the first index of our variable
    ;We increment rcx to go to the next index and then we move the pointer stored in rcx into the position variable
    ;This way we keep track where we are in the variable.
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx

_printRAXLoop:
    mov rdx, 0 ;set to 0 to prevent issues with div
    mov rbx, 10 ;set value which will be used in div
    div rbx ;divide RAX with RBX(10)
            ;RDX will now hold the remainder of the value
    push rax ;Store the new value on the stack
    add rdx, 48 ;add 48 to display a number as a character according to ascii

    mov rcx, [digitSpacePos]
    mov [rcx], dl ;dl is the 8-bit representation of rdx (where the remainder is stored)
    inc rcx
    mov [digitSpacePos], rcx ;We increment the digitposition to store the next value

    pop rax ;Get the value of the division out of the stack
    cmp rax, 0 ;If the value is equal to 0, the loop is done
    jne _printRAXLoop

_printRAXLoop2:
    mov rcx, [digitSpacePos] ;We get the position of the index where the first value is stored

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx ;Display the character by printing it with a syscall
    mov rdx, 1
    syscall

    mov rcx, [digitSpacePos] ;We once again get the position of the stored value
    dec rcx ;This time we decrement the pointer stored in rcx because our values are stored backwards
    mov [digitSpacePos], rcx ;We now store the pointer of next character to print in the position variable

    cmp rcx, digitSpace ;We compare if the digit space position is equal to the beginning of the string
    jge _printRAXLoop2 ;If not, we go back into the loop since there is more to print
    ret ;Return to the program

_get_val:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 2
    syscall

    mov rbx, input
    mov rcx, [input]
    sub rcx, 48

    push rcx
    mov rax, rcx
    call _printRAX
    pop rcx

    cmp rcx, 0
    jl _wrong_val

    cmp rcx, 9
    jg _wrong_val

    mov rax, 10
    mul rcx

    inc rbx
    mov [input], rbx

    mov rdx, [input]
    sub rdx, 48

    mov rax, rdx
    call _print

    cmp rdx, 0
    jle _wrong_val

    cmp rdx, 9
    jg _wrong_val

    add rcx, rdx

    mov [in_val], rcx
    mov rax, [in_val]
    call _printRAX

    ret

_wrong_val:
    mov rax, txt1
    call _print
    jmp _get_val

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