.model small
.stack
.data
    l1              db  'EJEMPLO 5', 10, 13, '$'
    l2              db  'SE PULSO F1', 10, 13, '$'
    l3              db  'SE PULSO F2', 10, 13, '$'
    l4              db  'SE PULSO HOME', 10, 13, '$'
    user            db  'oscar','$'
    ;coordenadas nave
    xnave           dw  0
    ynave           dw  0
    ;marco
    lineamarco      db  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24 
    lineamarco1     db  24, 24
    ;nave
    naveFila1       db  00, 00, 00, 00, 00, 39, 00, 00, 00, 00, 00
    naveFila2       db  00, 00, 00, 00, 00, 15, 00, 00, 00, 00, 00
    naveFila3       db  00, 00, 39, 00, 15, 11, 15, 00, 39,	00, 00
    naveFila4       db  00, 15, 15, 15, 15, 11, 15, 15, 15, 15, 00
    naveFila5       db  15, 15, 15, 15, 15,	11,	15,	15,	15,	15,	15
    naveFila6       db  15, 15, 15, 15, 15,	11,	15,	15,	15,	15,	15
    ;disparo
    disparoFila1    db  12
    disparoFila2    db  29
    disparoFila3    db  29
    disparoFila4    db  45
    ;coordenadas disparo
    xdis            dw  0
    ydis            dw  0
    contador        dw  0
.code

imprimir macro texto
    mov dx, offset texto
    mov ah, 09h
    int 21h
endm

limpiarpantallag proc
;vuelve a entrar en el modo video
    mov ah, 0
    mov al, 13h
    int 10h
    ret
limpiarpantallag endp

auxdiblinea macro vector, tam
;se le mueve a di en la posicion en la que se empezara a dibujar
;esta macro sirve para dibujar una linea
    mov di, ax
    mov si, offset vector
    mov cx, tam
    rep movsb
endm

dibujarnave macro
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    auxdiblinea naveFila1, 11
    add ax, 320
    auxdiblinea naveFila2, 11
    add ax, 320
    auxdiblinea naveFila3, 11
    add ax, 320
    auxdiblinea naveFila4, 11
    add ax, 320
    auxdiblinea naveFila5, 11
    add ax, 320
    auxdiblinea naveFila6, 11
endm

dibujardis macro
;macro para dibujar el disparo por primera vez
    push cx
    xor cx, cx
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    pop cx
    auxdiblinea disparoFila1, 1
    add ax, 320
    auxdiblinea disparoFila2, 1
    add ax, 320
    auxdiblinea disparoFila3, 1
    add ax, 320
    auxdiblinea disparoFila4, 1
endm

redibujardis macro
;macro que sirve para ir moviendo el disparo hacia arriba
    local e1, salir, quitardisparo, salir1
    ;aqui valida que haya un disparo 
    cmp ydis, 0
    je salir
    ;cada vez que se repinta 5 veces la pantalla va a subir el disparo 1 pixel
    inc contador
    cmp contador, 5
    je e1
    e1:
    sub ax, 1
    mov ydis, ax
    dibujardis
    mov contador, 0
    salir:
    cmp ydis, 22
    je quitardisparo
    jne salir1
    quitardisparo:
    mov ydis, 0
    mov xdis, 0
    salir1:
endm

imprimirnombre macro
    local e1, e2
    mov dl, 0
    e1:
    ;posicion del cursor
        mov ah, 02h
        ;dh fila
        mov dh, 0
        ;dl columna
        mov dl, dl
        int 10h
        mov dx, offset user
        mov ah, 09h
        int 21h
    e2:
endm

dibujarmarco macro
    local e1, e2, e3, e4, e5
    ;convertir las coordenadas x y y para la lineazalizacion 
    ;se multiplican por 320 que es el ancho de la matriz la posicion en y
    mov cx, 320
    mul cx
    ;al resultado se le suma la posicion en x
    add ax, bx
    mov di, ax
    e1:
        ;comienza a dibujar el marco desde arriba
        auxdiblinea lineamarco, 20;0
        add ax, 20;
        auxdiblinea lineamarco, 20;20
        add ax, 20 ; ax = 20 + 20
        auxdiblinea lineamarco, 20;40
        add ax, 20
        auxdiblinea lineamarco, 20;60
        add ax, 20
        auxdiblinea lineamarco, 20;80
        add ax, 20
        auxdiblinea lineamarco, 20;100
        add ax, 20
        auxdiblinea lineamarco, 20;120
        add ax, 20
        auxdiblinea lineamarco, 20;140
        add ax, 20
        auxdiblinea lineamarco, 20;160
        add ax, 20
        auxdiblinea lineamarco, 20;180
        ;segunda linea marco
        add ax, 140; ax=320
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 340
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 360
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 380
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 400
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 420
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 440
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 460
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 480
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 500
        auxdiblinea lineamarco, 20
        ;empieza a dibujar lado izquierdo
        add ax, 140
        ;ax = 640
        auxdiblinea lineamarco1, 2
        push ax
        ;se guarda ax con 640
        xor si, si
    e2:
        push si
        ;se le suman 320 para llegar a la siguiente linea
        add ax, 320
        ;se dibuja la linea vertical de la izquierda
        auxdiblinea lineamarco1, 2
        pop si
    e3:
        inc si
        cmp si, 170
        jne e2
    
        pop ax
        ;ax = 640
        add ax, 198
        ;se le suman 198 porque toda la linea tiene una longitud de 200
        ;se dibuja la linea vertical de la derecha
        auxdiblinea lineamarco1, 2
        xor si, si
    e4:
        push si
        add ax, 320
        auxdiblinea lineamarco1, 2
        pop si
    e5:
        ;se dibujan las dos lineas del marco de abajo
        inc si
        cmp si, 170
        jne e4
        sub ax, 198
        ;se le restan 198 para regresar al inicio de la posicion en x
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 140
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
endm

GetChar proc
;lee un caracter
    xor ah, ah
    int 16h
    ret
GetChar endp

VSync proc
;metodo de sincronizacion vertical de la pantalla
    mov dx, 03dah
    WaitNotVSync:
        in al, dx
        and al, 08h
        jnz WaitNotVSync
    WaitVSync:
        in al, dx
        and al, 08h
        jz WaitVSync
    ret
VSync endp

Delay proc
;metodo para agregar un delay en microsegundos para refrescar la pantalla
;los microsegundos se toman como cx:dx
    mov cx, 00001h
    mov dx, 0000h
    mov ah, 86h
    int 15h
    ret
Delay endp

HasKey proc
;verifica si se ha pulsado una tecla
    push ax
    mov ah, 01h
    int 16h
    pop ax
    ret
HasKey endp

main proc
    mov ax, @data
	mov ds,ax
    mov ax, 0h
    mov ah, 0h
    int 16h
    ;verifica si la tecla pulsada es f1
    cmp ax, 3b00h
    je imprimirf1
    ;verifica si la tecla pulsada es f2
    cmp ax, 3c00h
    je imprimirf2
    ;verifica si la tecla pulsada es home
    cmp ax, 4700h
    je imprimirhome
    jmp salir
imprimirhome:
    imprimir l4
    xor si, si
    ;entra en modo grafico
    ;ah = 0
    ;al = 13h
    ;Resolucion 320x200 con 256 colores
    mov ax, 13h
    int 10h
    ;offset de la memoria de video importante
    mov ax, 0A000h
    mov es, ax
    ;coordenadas donde empezara a dibujar la nave
    mov xnave, 150
    mov ynave, 185
inicioj:
    call limpiarpantallag
    ;se guardan los valores de los registros ax y bx ya que se modificaran 
    push ax
    push bx
    imprimirnombre
    mov ax, 20 ;y
    mov bx, 50 ;x
    dibujarmarco
    mov ax, ynave ;coordenada y de la nave
    mov bx, xnave ; coordenada x de la nave
    dibujarnave
    mov ax, ydis ; coordenada y del disparo
    mov bx, xdis ; coordenada x del disparo
    redibujardis ; manda a llamar la macro para redibujar el disparo
    ;se sacan los valores de ax y bx
    pop bx
    pop ax
    ;se llaman los metodos para la sincronizacion de la pantalla
    ;esto se usa para que no titile tanto la pantalla
    call VSync
    call VSync
    call Delay; jugar con los valores del delay para que no titile tanto la pantalla
    call HasKey;este procedimiento verifica que se haya pulsado una tecla, si no regresa al inicio del juego a repintar la pantalla
    jz inicioj
    call GetChar;verifica la tecla que pulso
    cmp al, 20h;tecla de espacio
    je finj
    cmp al, 76h;v minuscula para disparar
    je disparar
    cmp ax, 4b00h;flecha de la izquierda
    je moverizq
    cmp ax, 4d00h;flecha de la derecha
    je moverder
    jmp inicioj;vuelve al inicio del juevo para repintar la pantalla
disparar:
    cmp ydis, 0;verifica que no haya disparo
    je disparar1;si no hay se va a la etiqueta que dibuja el disparo
    jmp inicioj ; si hay vuelve al inicio del juego para repintar la pantalla
disparar1:
;guarda los valores de ax y bx en la pila
    push ax
    push bx
    ;limpia los valores de ax y bx
    xor ax, ax
    xor bx, bx
    mov ax, xnave
    add ax, 5h
    mov xdis, ax; usamos la coordenada de x de la nave y se le suman 5 para correrlo 5 pixeles
    mov ax, ynave
    sub ax, 5
    mov ydis, ax; usamos la coordenada y de la nave y se le restan 5 para que este 5 pixeles arriba 
    mov ax, ydis
    mov bx, xdis
    dibujardis
    pop bx
    pop ax
    jmp inicioj
moverizq:
    push ax
    mov ax, xnave; movemos la posicion de la nave al registro ax
    cmp ax, 52;comparamos si se puede mover a la izquierda, teniendo en cuenta que la coordenada x donde empieza el marco es la 50
    ;se le suman los dos pixeles de la linea vertical
    je inicioj;si es igual regresa al inicio del juego
    dec ax;si no es igual le resta 1 al valor de ax
    mov xnave, ax; se vuelve a asignar este valor a la coordena x de la nave
    pop ax
    jmp inicioj;se regresa a repintar el juego con la nueva posicion de x
moverder:
    push ax
    mov ax, xnave
    cmp ax, 237;se compara si se puede mover aun a la derecha, teniendo en cuenta que se empezo en la 50 y termino en la 250, a esto
    ;se le restan los 2 de la linea vertical quedando en 248, y aun se le debe restar los 11 del ancho de la nave dejando el resultado como 237
    je inicioj
    inc ax; si no es igual se incrementa el registro ax
    mov xnave, ax; se regresa a asignar el valor a la coordenada x de la nave
    pop ax
    jmp inicioj;se regresa a repintar el juego con la nueva posicion de x
finj:
    ;regresa el control de la pantalla a modo texto
    mov ax, 3h
    int 10h
    jmp salir
imprimirf1:
    imprimir l2
    jmp salir
imprimirf2:
    imprimir l3
salir:
    mov ah, 4ch
	xor al,al
	int 21h
main endp
end main