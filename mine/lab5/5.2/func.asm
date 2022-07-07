.686     
.model flat,stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
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