reset  equ 00h
ltint0 equ 03h ; tratador da int externa 0
ltint1 equ 13h ; tratador da int externa 1
state  equ 20h ; estado de interrupção
	
	
org reset ;PC=0
jmp inicio ;inicio real, pula ints

org ltint0
mov state, #1h
reti

org ltint1
cpl ex0 ; inverte habilitação da int0
clr ie0 ; ignora int0
reti

start:  
		mov ie,#10000101b ; habilita ints
		setb it0; borda de descida
		setb it1
		mov state,#0h
		mov r0,#state
		mov dptr,#tabela
		mov r1,#0
volta:
		cjne @r0,#1,volta
		mov state,#0h
		mov a,r1
		movc a,@a+dptr
		mov p1,a
		inc r1
		cjne r1,#16,volta
		jmp $
			
tabela: 
		db 'Microcontrolador'
end