ORG 0000h
  cli
	mov esi,hello
	mov ah, 0eh

loop:
	lodsb
	or al,al
	jz halt
  INT 10h
	jmp loop

halt:
	hlt

hello: db "Hello more than 512 bytes world!!",0
