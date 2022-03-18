.model small
.stack 500h
.data
    holamundo db "hola mundo",10,13, "$"
    holamundo2 db "hola mundo 2", 10, 13, "$"
.code
imprime macro texto
    mov ah, 09
    mov dx, offset texto
    int 21h
endm

main proc
    mov ax, seg holamundo
    mov ds, ax
    imprime holamundo
    imprime holamundo2
    mov ax, 4c00h
    int 21h
main endp
end main