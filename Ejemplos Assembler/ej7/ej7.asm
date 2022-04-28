include macros.asm
.model small
.stack
.data
    arreglotop db 10, 50, 45, 20, 80, 98, 25, 25, 30, 35
    auxarreglo db 10 dup(0)
    msg29           db  'INGRESE UNA VELOCIDAD (0-9)', 10, 13, '$'
    salto           db  10, 13, '$'
    msg30           db  'FORMA DE ORDENAR (1. ASCENDENTE, 2. DESCENDENTE)', 10, 13, '$'
    arregloba       db  10 dup(0)
    arreglobd       db  10 dup(0)
    arregloqa       db  10 dup(0)
    arregloqd       db  10 dup(0)
    usuarioleido    db  0
    auxusuario      db  10 dup('$')
    auxnivel1       db  0
    auxpuntuacion   db  0
    menortop        db  0
    cantidad        db  10
    puntuacionSt    db  4 dup('$')
    nivelSt         db  2 dup('$')
    numerosmos      db  60  dup('$')
    mayorbarra      db  0
    grosor          dw  0
    espacio         db  0
    espaciador      dw  0
    tiempo          dw  0
    espacio2        dw  0
    valor           db  20
    velocidad1      db  5
    ordenamiento    db 2 dup('$')
    tipo            db  0;1 ascendente, 2 descendente

.code
main proc
    mov ax, @data
    mov ds, ax
    copiararreglo arreglotop, auxarreglo
    DeterminarmayorB
    copiararreglo auxarreglo, arreglotop
    mov cl, 16
    sub cl, 5
    inc cl
    mov ax, 500
    mov bl, cl
    mul bl
    mov tiempo, ax
    HacerUltimasBarra arreglotop
fin:
    mov ah, 4ch
    xor al, al
    int 21h
main endp

GetChar proc
    xor ah, ah
    int 16h
    ret
GetChar endp

end main