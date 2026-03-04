[org 0x7c00]
KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp

call load_kernel

call switch_to_pm


jmp $

%include "gdt.asm"
%include "switch_to_pm.asm"

[bits 16]
load_kernel:
    mov ah, 0x02            ; Fonction de lecture BIOS
    mov al, 15              ; Nombre de secteurs à lire (ton kernel)
    mov ch, 0               ; Cylindre 0
    mov dh, 0               ; Tête 0
    mov cl, 2               ; Secteur 2 (le kernel est juste après le boot)
    mov dl, [BOOT_DRIVE]    ; Le lecteur (0x00 pour disquette)
    mov bx, KERNEL_OFFSET   ; On charge à 0x1000
    int 0x13                ; Appel BIOS
    
    jc disk_error           ; Si ça rate, on affiche 'E'
    ret

disk_error:
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    jmp $
[bits 32]
BEGIN_PM:
    call KERNEL_OFFSET
    jmp $



BOOT_DRIVE db 0
times 510-($-$$) db 0
dw 0xaa55 