.model small
.stack
.data
    l1 db "EJEMPLO 2", 10, 13, "$"
    ;VARIABLES
    errorarch db 'ERROR AL ABRIR EL ARCHIVO', 10, 13, '$'
    archivo db 'salida.txt', 0
    cadena db ? ,"$"
    ;opcion db 2 dup('0')
    handle dw ?

.code
imprime macro texto
    mov ah, 09
    mov dx, offset texto
    int 21h
endm

crearf macro ruta
    mov ah, 3ch
    mov cx, 00h
    lea dx, ruta
    int 21h
endm

abrirF macro ruta, handle
    mov ah, 3dh
    mov al, 01h
    mov dx, offset ruta
    int 21h
    mov handle, ax
    jc errorarchivo
endm

escribirF macro texto, tam
    mov ah, 40h
    mov cx, tam
    mov dx, offset texto
    int 21h
endm

cerrarF macro
    mov ah, 3eh
    int 21h
endm

main proc
    mov ax, seg l1
    mov ds, ax
    ;limpiar pantalla
    mov ah, 00h
    mov al, 03h
    int 10h
    imprime l1
CrearA:
    crearf archivo
    cerrarF
Leer:
    mov ax, 00
    mov ah, 01h
    int 21h
    cmp al, 13
    mov si, 0
    jne Concatenar
    je Salircade
Concatenar:
    mov cadena[si], al
    mov cadena[si + 1], "$"
    inc si
    jmp Leer
Salircade:
    abrirF archivo, handle
    escribirF cadena, si
    cerrarF
    jmp Salir
errorarchivo:
    imprime errorarch
Salir:
    mov ax, 4c00h
    int 21h
main endp
end main