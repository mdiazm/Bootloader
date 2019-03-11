BITS 16
ORG 7C00h

CLI; Desactivo las interrupciones para evitar una caída del sistema.

BOOT: 
	MOV AX, 0x2401;
	INT 15h; Activo la línea A20 para acceder a posiciones de memoria de más de 1Mb

	MOV AX, 0x3
	INT 10h; Activo el modo texto para la pantalla.

	MOV [disco], DL; Cuando se carga el bootloader, la BIOS almacena en DL el número de disco

	; Cargo en RAM el bootloader de segunda etapa
	MOV AH, 0x2; Servicio de la BIOS para leer de disco.
	MOV AL, 1; Sectores a leer.
	MOV CH, 0; Identificador del cilindro.
	MOV DH, 0; Identificador del cabezal.
	MOV CL, 2; Identificador del sector a leer.
	MOV DL, [disco]; Vuelvo a mover a DL el número de disco por si la bios modificó los registros.
	MOV BX, target; Almaceno en BX el desplazamiento del segmento de datos.
	INT 13h; Llamo al servicio de la BIOS para leer de disco.

	LGDT [gdt_pointer]; Cargo la tabla de GDT, necesaria para cambiar al modo protegido.
	MOV EAX, CR0; Leo el estado del registro CR0 de la CPU.
	OR EAX, 0x1; Activo el modo protegido.
	MOV CR0, EAX; Vuelvo a escribir en el registro de la CPU el nuevo estado (modo protegido).

	MOV AX, DATA; Inicializo todos los registros con la dirección del segmento de datos.
	MOV DS, AX
	MOV ES, AX
	MOV FS, AX
	MOV GS, AX
	MOV SS, AX
	JMP CODE:BOOT_2ETAPA

gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start
disco:
	db 0x0

CODE equ gdt_code - gdt_start; Defino el segmento de código
DATA equ gdt_data - gdt_start; Defino el segmento de datos

times 510 - ($-$$) db 0
dw 0xaa55

target:
BITS 32; Ahora, el modo protegido está activo y tengo acceso a los registros y direcciones de 32 bits.

hola: db "Saludo desde el bootloader de segunda etapa en modo protegido, escriba algo: ", 0

BOOT_2ETAPA:
	MOV ESI, hola; Cargo en el registro SI la dirección de la cadena a imprimir.
	MOV EBX, 0xb8000; Dirección de la memoria de vídeo.

LOOP: 
	LODSB
	OR AL, AL
	JZ LOOP_KB; Intento leer del teclado.
	OR EAX, 0x0F00; Máscara para imprimir blanco sobre negro.
	MOV WORD [EBX], AX; Muevo el caracter que está en AX a la posición de memoria que apunta EBX.
	ADD EBX,2; Muevo el puntero para no sobreescribir la posición de memoria (2 bytes, 1 para el formato y otro contiene el ASCII)
	JMP LOOP

LOOP_KB: 
	IN AL, 64h
	TEST AL,1
	JZ LOOP_KB

	IN AL, 60h
	MOV AH, AL

	IN AL, 61h
	OR AL, 80h
	OUT 61h, AL
	AND AL, 7Fh
	OUT 61h, AL

	CMP AH, 1
	JZ HALT
	TEST AH, 80h; Evento de liberación de tecla?
	JNZ LOOP_KB

	MOV AL, AH; Muevo el caracter a los bits menos significativos del registro AX.

	CMP AL, 10h; Q
	JZ Q
	CMP AL, 11h; W
	JZ W
	CMP AL, 12h; E
	JZ E
	CMP AL, 13h; R
	JZ R
	CMP AL, 14h; T
	JZ T
	CMP AL, 15h; Y
	JZ Y
	CMP AL, 16h; U
	JZ U
	CMP AL, 17h; I
	JZ I
	CMP AL, 18h; O
	JZ O
	CMP AL, 19h; P
	JZ P
	CMP AL, 10h; Q
	JZ Q
	CMP AL, 10h; Q
	JZ Q
	CMP AL, 10h; Q
	JZ Q
	CMP AL, 10h; Q
	JZ Q
	CMP AL, 10h; Q
	JZ Q
	CMP AL, 10h; Q
	JZ Q
	CMP AL, 10h; Q
	JZ Q
	CMP AL, 10h; Q
	JZ Q

	
PRINT:
	AND EAX, 0x00FF; Se suprime el formato y se deja solo el scancode
	OR EAX, 0x0F00; Se aplica una máscara para el formato. Blanco sobre negro
	MOV WORD [EBX], AX; Imprimo el caracter en la memoria de vídeo
	ADD EBX,2; Desplazamiento
	JMP LOOP_KB

HALT: 
	HLT

Q:
	MOV AL, 51h
	JMP PRINT
W:
	MOV AL, 57h
	JMP PRINT
E:
	MOV AL, 45h
	JMP PRINT
R:
	MOV AL, 52h
	JMP PRINT
T:
	MOV AL, 54h
	JMP PRINT
Y:
	MOV AL, 59h
	JMP PRINT
U:
	MOV AL, 55h
	JMP PRINT
I:
	MOV AL, 49h
	JMP PRINT
O:
	MOV AL, 4Fh
	JMP PRINT
P:
	MOV AL, 50h
	JMP PRINT
A:
	MOV AL, 41h
	JMP PRINT
S:
	MOV AL, 53h
	JMP PRINT
D:
	MOV AL, 44h
	JMP PRINT
F:
	MOV AL, 46h
	JMP PRINT
G:
	MOV AL, 47h
	JMP PRINT
H:
	MOV AL, 48h
	JMP PRINT
J:
	MOV AL, 4Ah
	JMP PRINT
K:
	MOV AL, 4Bh
	JMP PRINT
L:
	MOV AL, 4Ch
	JMP PRINT
Z:
	MOV AL, 5Ah
	JMP PRINT
X:
	MOV AL, 58h
	JMP PRINT
C:
	MOV AL, 43h
	JMP PRINT
V:
	MOV AL, 56h
	JMP PRINT
B:
	MOV AL, 42h
	JMP PRINT
N:
	MOV AL, 4Eh
	JMP PRINT
M:
	MOV AL, 4Dh
	JMP PRINT



times 1024 - ($-$$) db 0; Relleno con 0s hasta completar el segundo sector.
