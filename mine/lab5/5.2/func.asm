.686     
.model flat,stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
 printf          PROTO C :VARARG
 scanf           PROTO C :VARARG
 ;public getsf 
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 .STACK 200
 .CODE
memorycopy	PROC stdcall dst:dword,src:dword,len:dword
	pusha
	mov esi,src
	mov edi,dst
	mov ecx,len
	cld
	rep movsb
	popa
	ret
memorycopy endp
END