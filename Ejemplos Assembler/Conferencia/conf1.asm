%macro MacroDibujar 1
	mov di,ax
	mov si,%1
	cld			;limpiar nuestras banderas
	
	mov cx,12
	rep movsb  	;  rep (repeat while equal)
					; The MOVSB instruction The MOVSB (move string, byte) instruction 
					;La instrucción MOVSB La instrucción MOVSB (mover cadena, byte) 
					;obtiene el byte en la dirección SI, lo almacena en la dirección 
					;DI y luego incrementa o disminuye los registros SI y DI en uno.
	
%endmacro

%macro MacroMoverObstaculo 1
	mov ax,obstaculos[si]
	cmp ax,184
	ja %%resetear
	inc ax
	inc ax
	inc ax
	inc ax
	jmp %%fin
%%resetear:
	mov ax,0
%%fin:
	mov obstaculos[si],ax
		
%endmacro
;=======================================================================================================
org 100h
section .text

inicio:

inicioVid:
	mov ax,13h				; modo grafico VGA
	int 10h					; interrupcion modo video
	
	mov ax, 0A000h
	mov es,ax
	
mainLoop:
	call HiloDibujar
	
	call HasKey		;hay tecla
	jz mainLoop		;no hay tecla saltar al loop
	
	call GetCh		; si hay tecla, leer cual es
	
	cmp al,20h		; si se presiono la barra espaciadora?
	jne LO1			; si no, comprobar si la tecla presionada fue para moverse
	
finProg:
	mov ax,3h				; modo video -> modo texto
	int 10h
	
	mov ax,04c00h			;salir
	int 21h					;fin programa

LO1:
	cmp al,'d'
	je MovDerecha
	
	cmp al,'a'
	je MovIzquierda
	
	jmp mainLoop

; Si llega aqui es mov a derecha
MovDerecha:
	mov cx,3 		; cantidad de veces el mov
	LoopDer:
		xor ax,ax
		mov ax,[coordCarroX]
		add ax,5	; el numero de posiciones del mov
		mov [coordCarroX],ax
		push cx
		call HiloDibujar
		pop cx
	loop LoopDer
	
	jmp mainLoop
	
; Si llega aqui es mov a izq
MovIzquierda:
		mov cx,3 		; cantidad de veces el mov
	LoopIzq:
		xor ax,ax
		mov ax,[coordCarroX]
		sub ax,5	; el numero de posiciones del mov
		mov [coordCarroX],ax
		push cx
		call HiloDibujar
		pop cx
	loop LoopIzq
	
	jmp mainLoop
	
;=======================================================================================================
HiloDibujar:
	call ClearScreen
	
	mov bx,[coordCarroY]
	mov ax,[coordCarroX]
	call DibujarCarro
	
	call DibujarCalle
	
	xor bx,bx
	xor ax,ax
	mov cx,5
	xor si,si

DibujarObstaculos:
	push cx
	
	cmp si,0
	jz PrimerObstaculoVect
	
	mov di,si
SegundoObstaculoVect:
	cmp si,2
	jnz TercerObstaculoVect
	
	mov bx,obstaculos[si]
	cmp bx,0
	ja next2
	
	dec di
	dec di
	
	mov bx,obstaculos[di]
	cmp bx,54
	jb finObstaculos
	
	next2:
		mov ax,55
		mov [coordXObstaculos],ax
		jmp ContinuarMovObstaculo	
		
TercerObstaculoVect:
	cmp si,4
	jnz CuartoObstaculoVect
	
	mov bx,obstaculos[si]
	cmp bx,0
	ja next3
	
	dec di
	dec di
	
	mov bx,obstaculos[di]
	cmp bx,80
	jb finObstaculos
	
	next3:
		mov ax,70
		mov [coordXObstaculos],ax
		jmp ContinuarMovObstaculo	

CuartoObstaculoVect:
	cmp si,6
	jnz QuintoObstaculoVect
	
	mov bx,obstaculos[si]
	cmp bx,0
	ja next4
	
	dec di
	dec di
	
	mov bx,obstaculos[di]
	cmp bx,64
	jb finObstaculos
	
	next4:
		mov ax,65
		mov [coordXObstaculos],ax
		jmp ContinuarMovObstaculo	
QuintoObstaculoVect:
	cmp si,8
	jnz ContinuarMovObstaculo
	
	mov bx,obstaculos[si]
	cmp bx,0
	ja next5
	
	dec di
	dec di
	
	mov bx,obstaculos[di]
	cmp bx,25
	jb finObstaculos
	
	next5:
		mov ax,30
		mov [coordXObstaculos],ax
		jmp ContinuarMovObstaculo		
		
PrimerObstaculoVect:
	mov ax,25
	mov [coordXObstaculos],ax
	
ContinuarMovObstaculo:
	MacroMoverObstaculo	 si
	
	cmp si,10
	jz finObstaculos
	;---------
	mov bx,obstaculos[si]
	xor ax,ax
	mov ax,[coordXObstaculos]
	push si
	call DibujarCarro
	pop si
finObstaculos:
	inc si
	inc si
	pop cx
	dec cx
	cmp cx,0
	jnz near DibujarObstaculos	
	
	;----------------------
	call VSync
	call VSync
	
	mov cx, 0000h		; tiempo delay
	mov dx,0ffffh		;tiempo delay
	call Delay
	
	ret
	
ClearScreen:
	mov ah,0h
	mov al,13h
	int 10h
	
	ret
;======================================================================

    ;wait for vsync ( retraso vertical ) 
VSync:
	mov dx,03dah
	Waitnotvsync:	;wait to be out of vertical sync
	in al,dx
	and al,08h
	jnz Waitnotvsync
	
	waitvsync:	;wait until vertical sync begins
	in al,dx
	and al,08h
	jz waitvsync
	
	ret

;======================================================================
    ; Esta funcion recibe un numero de 32 bits , pero en dos partes
    ; de 16 bits c/u cx y dx. CX en la parte alta y DX en la parte baja
    ; Esta funcion causa retardos de un micro segundo = 1/1 000 000	
	
Delay:
	mov ah,86h
	int 15h
	
	ret
	
;============================================================================
	;bx= coordenada y
    ;ax= coordenada x
	;cl= color
	
	; y*320 + x = (x,y)
	;10 * 320 + 100 = 3300

DibujarCarro:
	mov cx,bx
	shl cx,8
	shl bx,6
	
	add bx,cx	;bx = 320*y
	add ax,bx	; sumar x
	
	MacroDibujar carFila0
	
	add ax,320
	MacroDibujar carFila1
	
	add ax,320
	MacroDibujar carFila2
	
	add ax,320
	MacroDibujar carFila3
	
	add ax,320
	MacroDibujar carFila4
	
	add ax,320
	MacroDibujar carFila5
	
	add ax,320
	MacroDibujar carFila6
	
	add ax,320
	MacroDibujar carFila7
	
	add ax,320
	MacroDibujar carFila8
	
	add ax,320
	MacroDibujar carFila9
	
	add ax,320
	MacroDibujar carFila10
	
	add ax,320
	MacroDibujar carFila11
	
	add ax,320
	MacroDibujar carFila12
	
	add ax,320
	MacroDibujar carFila13
	
	add ax,320
	MacroDibujar carFila14
	
	add ax,320
	MacroDibujar carFila15
	
	ret
;============================================================================
DibujarCalle:
	mov cx,9 			;numero de repeticiones para dibujar calle
	mov bx,[coordCalleY]
	
	InitLoopCalle:
		sub bx,22
		push cx
		
		push bx
		mov ax,[coordCalleIzqX]
		call DibujarPedazoCalle
		
		pop bx
		push bx
		
		mov ax,[coordCalleDerechaX]
		call DibujarPedazoCalle
		
		pop bx
		pop cx
		loop InitLoopCalle
	ret

;============================================================================
    ;bx= coordenada y
    ;ax= coordenada x
    ;cl= color
DibujarPedazoCalle:		    
    mov cx, bx 
    shl cx,8
    shl bx,6
   
    add bx,cx    ;bx=y*320      
    add ax,bx    ;sumar x
   
    ;mov di, ax          
    MacroDibujar calleFila0
   
    add ax,320
    MacroDibujar calleFila1  
    
    add ax,320
    MacroDibujar calleFila2  
	
	add ax,320
    MacroDibujar calleFila3  
	
	add ax,320
    MacroDibujar calleFila4  
	
	add ax,320
    MacroDibujar calleFila5  
	
	add ax,320
    MacroDibujar calleFila6  
	
	add ax,320
    MacroDibujar calleFila7  
	
	add ax,320
    MacroDibujar calleFila8  
	
	add ax,320
    MacroDibujar calleFila9  
	
	add ax,320
    MacroDibujar calleFila10  
	
	add ax,320
    MacroDibujar calleFila11  
    ret	

		
;=======================================================================================================
	; funcion HasKey
    ; hay una tecla presionada en espera?
    ; zf = 0 => Hay tecla esperando 
    ; zf = 1 => No hay tecla en espera  
HasKey:
	push ax
	
	mov ah,01h	;funcion 1
	int 16h		;interrupcion de la bios para el teclado	
	
	pop ax
	
	ret		
;======================================================================
    ; funcion GetCh
    ; ascii tecla presionada
    ; Salida en al codigo ascii sin eco, via BIOS
GetCh:
	xor ah,ah		; funcion 0
	int 16h			; interrupcion de la bios para el teclado	
	
	ret
	
;=======================================================================================================
section .data
	carFila0   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila1   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila2   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila3   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila4   DB 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	carFila5   DB 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	carFila6   DB 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	carFila7   DB 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	carFila8   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila9   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila10  DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila11  DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	carFila12  DB 15, 15, 15, 15, 0 , 0 , 0 , 0 , 15, 15, 15, 15
	carFila13  DB 15, 15, 15, 15, 0 , 0 , 0 , 0 , 15, 15, 15, 15
	carFila14  DB 15, 15, 15, 15, 0 , 0 , 0 , 0 , 15, 15, 15, 15
	carFila15  DB 15, 15, 15, 15, 0 , 0 , 0 , 0 , 15, 15, 15, 15
	
	coordCarroX DW 35			;posicion del carro en X	
	coordCarroY DW 124			; posicion del carro en Y
	
	obstaculos  DW 5 dup(0)
	coordXObstaculos DW 0
;=======================================================================================================
	calleFila0   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila1   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila2   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila3   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila4   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila5   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila6   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila7   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila8   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila9   DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila10  DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	calleFila11  DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 0 , 0 , 0 , 0 
	
	coordCalleIzqX DW 5			; posicion X calle izquierda
	coordCalleDerechaX DW 90	; posicion X calle derecha
	
	
	coordCalleY DW 210			; posicion inicial calle en Y
	
;=======================================================================================================
 section .stack 1024h
	stacktop: