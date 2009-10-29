[ORG 0]
    jmp 07C0h:start

start:
    ; Update the segment registers. Why?
    mov ax, cs
    mov ds, ax
    mov es, ax

reset:
    mov ax, 0 ; clear ah and al
    mov dl, 0x80; select first HD
    int 13h
    jc reset

load_boot:
    ; Why put this in ax first?
    mov ax, 1000h       ; ES:BX = 1000:0000
    mov es, ax          ;
    mov bx, 0           ;

    mov ah, 2           ; Load disk data (to ES:BX)
    mov al, 1           ; Load 1 sectors
    mov ch, 0           ; Cylinder=0
    mov cl, 2           ; Sector=2 (does that start at 1?)
    mov dh, 0           ; Head=0
    mov dl, 80h         ; Drive=first HD
    int 13h             ; Read!
    jc load_boot        

    jmp 1000h:0000



times 510-($-$$) db 0   ; Fill the file with 0's
dw 0AA55h
