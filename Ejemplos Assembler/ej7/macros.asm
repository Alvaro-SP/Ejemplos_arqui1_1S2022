HacerUltimasBarra macro arreglo
    pushearreg

    ;convertirtopString
    determinargrosor grosor, espacio, cantidad, espaciador
    pusheararr arreglo
    mov ax, 013h
    int 10h
    mov ax, 0A000h
    mov ds, ax
    ;imprimirnummos numerosmos, 16h, 01h
    poppeararr arreglo
    dibujar cantidad, espacio2, arreglo
    call GetChar
    mov ax, 0003h
    int 10h
    poppearreg
endm

poppearreg macro
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
endm

dibujar macro cantidad, espacio, arreglo
    LOCAL e1, fin
    xor cx, cx
    e1:
        cmp cl, cantidad
        je fin
        push cx
        mov si, cx
        xor ax, ax
        mov al, arreglo[si]
        mov valor, al
        push ax
        buscarcolor
        hacerbar espacio, valor, mayorbarra
        pop ax
        pop cx
        inc cx
        jmp e1
    fin:
endm

hacerbar macro espacio, valor, max
    LOCAL e1, fin 
    xor cx, cx
    determinaralto valor, max
    e1:
        cmp cx, grosor
        je fin
        push cx
        mov ax, 170;posicion y
        mov bx, ax
        sub bl, valor
        xor bh, bh
        mov si, bx
        mov bx, 30
        add bx, espacio
        add bx, cx
        rellenarbarra
        pop cx
        inc cl
        jmp e1
    fin:
        mov ax, espaciador
        add espacio, ax

endm

determinaralto macro valor, max
    xor ax, ax
    mov al, valor
    mov bl, 100;alto maximo
    mul bl
    mov bl, max
    div bl
    mov valor, al
endm

buscarcolor macro 
    LOCAL e1, e2, e3, e4, fin
    cmp valor, 1
    jb fin
    cmp valor, 20
    ja e1
    mov dl, 4
    jmp fin
    e1:
        cmp valor, 40
        ja e2
        mov dl, 1
        jmp fin
    e2:
        cmp valor, 60
        ja e3
        mov dl, 44
        jmp fin
    e3:
        cmp valor, 80
        ja e4
        mov dl, 2
        jmp fin
    e4:
        cmp valor, 99
        ja fin
        mov dl, 15
        jmp fin
    fin:
endm

popArreglo macro arreglo
    LOCAL INICIO, FIN
    xor si, si
    xor cx, cx
    mov cl, cantidad
    mov si, cx
    dec si
    INICIO:
        cmp si, 0
        jl FIN
        pop ax
        mov arreglo[si], al
        dec si
        jmp INICIO
    FIN:
endm

pushar macro arreglo
    LOCAL INICIO, FIN
    xor si, si
    xor cx, cx
    mov cl, cantidad
    INICIO:
        xor ax, ax
        cmp si, cx
        je FIN
        mov al, arreglo[si]
        push ax
        inc si
        jmp INICIO
    FIN:
endm

rellenarbarra macro
    LOCAL e1, fin
    mov cx, si
    e1:
        cmp cx, ax
        je fin
        mov di, cx
        push ax
        push dx
        mov ax, 320
        mul di
        mov di, ax
        pop dx
        pop ax
        mov [di+bx], dl
        inc cx
        jmp e1
    fin:
endm

convertirpuntuacion macro puntuacion
    local e0, e1, e2, fin
    xor si, si
    xor bx, bx
    xor ah, ah
    xor ax, ax
    mov al, puntuacion
    mov bl, 100
    div bl
    add al, 48
    mov puntuacionSt[si], al
    mov al, ah
    inc si
    xor ah, ah
    xor bx, bx
    mov bl, 10
    div bl
    add al, 48
    mov puntuacionSt[si], al
    inc si
    add ah, 48
    mov puntuacionSt[si], ah
    inc si
    mov puntuacionSt[si], '$'
endm

limpiarpuntuacion macro
    local e1
    mov cx, 4
    xor si, si
    e1:
        mov puntuacionSt[si], '$'
        loop e1
endm

limpiarnumerosmos macro buffer
    LOCAL INICIO, FIN
    xor bx, bx
    INICIO:
        mov buffer[bx], '$'
        inc bx
        cmp bx, 60
        je FIN
        jmp INICIO
    FIN:
endm

copiararreglo macro fuente, destino
    LOCAL INICIO, FIN
    xor si, si
    xor bx, bx
    INICIO:
        mov bl, cantidad
        cmp si, bx
        je FIN
        mov al, fuente[si]
        mov destino[si], al
        inc si
        jmp INICIO
    FIN:
endm

DeterminarmayorB macro
    LOCAL ordenar, verificar, resetar, fin, menor
    xor si, si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov dl, cantidad
    ordenar:
        mov al, arreglotop[si]
        mov bl, arreglotop[si + 1]
        cmp ax, bx
        jl menor
        inc si
        inc cx
        cmp cx, dx
        jne ordenar
        mov cx, 0
        mov si, 0
        jmp verificar
    menor:
        mov arreglotop[si], bl
        mov arreglotop[si + 1], al
        inc si
        inc cx
        cmp dx, cx
        jne ordenar
        mov cx, 0
        mov si, 0
        jmp verificar
    verificar:
        mov al, arreglotop[si]
        mov bl, arreglotop[si + 1]
        cmp al, bl
        jl resetar
        inc si
        inc cx
        cmp cx, dx
        jne verificar
        jmp fin
    resetar:
        mov si, 0
        mov cx, 0
        jmp ordenar
    fin:
        xor ax, ax
        mov al, arreglotop[0]
        mov mayorbarra, al
endm

insertarNumero macro cadena
    LOCAL INICIO, FIN, SIGUIENTE
    xor si, si
    xor di, di
    INICIO: 
        cmp si, 60
        je FIN
        mov al, numerosmos[si]
        cmp al, 36
        je SIGUIENTE
        inc si
        jmp INICIO
    SIGUIENTE:
        mov al, cadena[di]
        cmp al, 36
        je FIN
        cmp di, 4
        je FIN
        mov numerosmos[si], al
        inc di
        inc si
        jmp SIGUIENTE
    FIN:
        mov numerosmos[si], 32
endm

poppeararr macro arreglo
    pop tiempo
    pop ax
    mov cantidad, al
    pop espaciador
    pop grosor
    pop ax
    mov mayorbarra, al
    popArreglo arreglo
endm

pushearreg macro
    push ax
    push bx
    push cx
    push dx
    push si
    push di
endm

convertirtopString macro 
    local e1, fin
    mov cx, 10
    push bx
    push dx
    xor bx, bx
    mov dl, cantidad
    xor dh, dh
    limpiarnumerosmos numerosmos
    xor bx, bx
    e1:
        push bx
        push cx
        cmp arreglotop[bx], 0
        je fin
        cmp bx, dx
        je fin
        limpiarpuntuacion
        mov al, arreglotop[bx]
        mov auxpuntuacion, al
        convertirpuntuacion auxpuntuacion
        insertarNumero puntuacionSt
        pop cx
        pop bx
        inc bx
        dec cx
        jne e1
    fin:
        pop dx
        pop bx
endm

determinargrosor macro grosor, espacio, cantidad, espaciador
    mov ax, 200;ancho maximo de las barras
    xor bx, bx
    mov bl, cantidad
    xor bh, bh
    div bl
    xor dx, dx
    mov dl, al
    mov espaciador, dx
    xor ah, ah
    mov bl, 25;espacio entre barras
    mul bl
    mov bl, 100
    div bl
    mov espacio, al
    mov bx, espaciador
    sub bl, espacio
    mov grosor, bx;grosor = espaciodelabarraconespacio - espacio
endm

pusheararr macro arreglo
    pushar arreglo
    xor ax, ax
    mov al, mayorbarra
    push ax
    push grosor
    push espaciador
    xor ax, ax
    mov al, cantidad
    push ax
    push tiempo
endm

imprimirnummos macro cadena, fila, columna
    push ds
    push dx
    xor dx, dx
    mov ah, 02h
    mov bx, 0
    mov dh, fila
    mov dl, columna
    int 10h
    mov ax, @data
    mov ds, ax
    mov ah, 09
    mov dx, offset cadena
    int 21h
    pop dx
    pop ds
endm