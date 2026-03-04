[bits 32]
[org 0x1000]
;                                     General Config
main:
    mov edx, 0xb8000
    
    
;                                    All includes
__init:
    call get_key
    cmp al, 0
    je __init

    ;cmp al, 0x0a
    ;je .next_line

    cmp al, 0x08
    je .handle_back_space


    mov [edx], al
    mov [edx + 1], byte 0x0f
    add edx, 2
    jmp __init
.handle_next_line:
    pusha

    popa
    ret
.handle_back_space:
    call back_space
    jmp __init
back_space:
    cmp edx, 0xb8000
    je .done
    sub edx, 2
    mov [edx], ' '
    mov [edx + 1], byte 0x0f
.done:
    ret

%include "include/print.asm"
%include "include/key.asm"

;                                     Data

scan_map:
    db 0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', ')', '=', 0x08
    db 0x09, 'a', 'z', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '^', '$', 0x0a
    db 0, 'q', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', '%', '*', 0
    db '<', 'w', 'x', 'c', 'v', 'b', 'n', ',', ';', ':', '!', 0
    db '*', 0, ' '
    times 128 db 0
