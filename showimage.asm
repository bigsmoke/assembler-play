segment .data

segment .text

start:
    ; Update the segment registers
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; Set VGA video mode (320x200px, 256 colors)
    mov ah, 0
    mov al, 0x13
    int 10h

load_image_to_mem:
    ; Why put this in ax first?
    mov ax, 2000h       ; ES:BX = 2000:0000
    mov es, ax          ;
    mov bx, 0
    mov ds, ax          ; Set the datasegment to this segment, so that future reads will use this segment
    mov ah, 2           ; Load disk data (to ES:BX)
    mov al, 128         ; Load 128 sectors, 64 kbyte
    mov ch, 0           ; Cylinder=0
    mov cl, 11          ; Sector
    mov dh, 0           ; Head=0
    mov dl, 80h         ; Drive=first HD
    int 13h             ; Read!
    jz error

    mov ah, 0x0c ; write pixel
    mov cx, 0 ; x
    mov dx, 199 ; y
    ;mov bx, 438h ; If I use pixel_pointer, it doesn't start at the right place, it seems
    mov bx, 110h ; If I use pixel_pointer, it doesn't start at the right place, it seems
    mov al, [bx]

draw_next_pixel:
    cmp cx, 320
    jz goto_next_line

    int 10h
    inc bx
    mov al, [bx]

    inc cx ; x pos
    jmp draw_next_pixel

goto_next_line:
    cmp dx, 0
    jz hang

    dec dx ; y pos. Because BMP's are bottom-up, it starts at the bottom and then decreases.
    mov cx, 0
    jmp draw_next_pixel

error:
    mov ah, 9
    mov al, 'E'
    mov bx, 7
    mov cx, 10
    int 10h


hang:                   ; Hang!
    jmp hang

; Without this, it won't boot for some reason.
; This and the bootloader are exactly 10 sectors +2 bytes long.
times 4608-($-$$) db 0

; vim: set ts=4 sw=4 expandtab:
