.686     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 scanf           PROTO C :VARARG
 strcmp          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

.DATA
lpfmt	db	"%s", 0
  buf1   db  'Please enter the password:',0
  buf2   db  'OK!',0
  buf3   db  'Incorrect Password！',0
  PASSWORDHAVE   db  'U202015290',0
  PASSWORDGET   db  10 DUP(0),0
.CODE
main proc c 
   

   invoke printf,OFFSET buf1
 ;  invoke printf,offset lpFmt,OFFSET buf1
   invoke scanf,offset lpfmt,offset PASSWORDGET
   MOV  ECX,0
JUDGEONE:
    mov al, BYTE PTR PASSWORDGET[ecx]
    mov bl, BYTE PTR PASSWORDHAVE[ecx]
    cmp al, bl
    jne Not_equal
    add ecx, 1
    cmp ecx, 10
    jne JUDGEONE
    jmp Is_equal

Is_equal:
   invoke printf,offset buf2
   jmp Exit
Not_equal:
    invoke printf,offset buf3
    jmp Exit
Exit:
	invoke ExitProcess, 0
main endp
END