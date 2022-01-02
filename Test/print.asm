section .data
    txt1 db "Wrong value, please enter a new one:",10,0
    txt2 db "Value above 93, please enter a new one:",10,0
;------------------------------------------------------------------------------------------------------------------------------
section .bss
    digitSpace resb 100
    digitSpacePos resb 8

    input resb 3
    in_val resd 1
;------------------------------------------------------------------------------------------------------------------------------
section .text
;------------------------------------------------------------------------------------------------------------------------------

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

    ;Setup the syscall for reading
    mov rax, 0  
    mov rdi, 0
    mov rsi, input
    mov rdx, 3
    syscall

    mov rbx, input  ;Get the input into the RBX register

    mov cl, [rbx]   ;Mov the first character into the CL register
    sub cl, 48      ;Subtract 48 to get the correct value
    
    cmp cl, 0       ;Compare to see if the first value is lower than 0
    jl _wrong_val   ;If not go into the wrong value segment

    cmp cl, 9       ;Compare to see if the first value is higher than 9
    jg _wrong_val   ;If not go into the wrong value segment

    mov rax, 10     ;Setup the RAX to 10 for multiplication of the first digit
    mul cl          ;Multiply the RAX with the CL register (our value)
    push rax        ;Push the value to the stack

    inc rbx         ;Increment RBX to get the next character

    mov cl, [rbx]   ;Mov the second character to the CL register
    sub cl, 48      ;Subtract 48 to get the correct value
    
    cmp cl, 0       ;Compare to see if the second value is lower than 0
    jl _wrong_val   ;If not go into the wrong value segment

    cmp cl, 9       ;Compare to see if the second value is higher than 9
    jg _wrong_val   ;If not go into the wrong value segment

    pop rbx         ;Get the first value back from the stack and put it in the RBX register
    add bl, cl      ;Add the second value to the first value

    cmp rbx, 93     ;Compare the total value to see if it is not higher than 93
    jg _too_big     ;If it is higher, jump to the too big segment

    mov [in_val], rbx   ;Store the complete value into the variable: in_val

    ret

_wrong_val:
    mov rax, txt1   ;Print out the wrong value text
    call _print
    jmp _get_val    ;Go back into the get val loop

_too_big:
    mov rax, txt2   ;Print out that the number is too big
    call _print 
    jmp _get_val    ;Go back into the get val loop

;Input: rax as pointer to string
;Output: print string at rax
_print:
    push rax    ;Push the message to the stack
    mov rbx, 0  ;Set the RBX register to 0
_printLoop:
    inc rax     ;Go to the next char in the RAX register
    inc rbx     ;Increment RBX
    mov cl, [rax]   ;Get the char out of the RAX into the CL register
    cmp cl, 0   ;See if it is the end of the message with the null character
    jne _printLoop ;If not then there is more to print, so we go back into the print loop

    ;Setup the syscall for writing
    mov rax, 1  
    mov rdi, 1
    pop rsi     ;Get the message out of the stack
    mov rdx, rbx    ;Use the RBX register to count the amount of bytes to print
    syscall
    ret