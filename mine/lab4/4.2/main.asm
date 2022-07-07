.686     
.model flat,stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 scanf           PROTO C :VARARG
 getchar         PROTO C :VARARG
 timeGetTime proto stdcall
 VirtualProtect  proto:dword,:dword,:dword,:dword
 getSF           PROTO :dword,:dword,:dword
 tolowf          PROTO
 tomidf          PROTO
 tohighf         PROTO
 printmidf       PROTO
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 includelib  Winmm.lib
 public lpfmt1,lpfmt2,s,LOWF,MIDF,HIGHF,lowf_pointer,midf_pointer,highf_pointer
.DATA
lpfmt1	db	"%d", 0
lpfmt2	db	"%s", 0
lpfmt3	db	"%s", 0
    buf1   db  'Please enter the password:',0
    buf2   db  'OK!',0
    buf3   db  'Incorrect！',0
    buf4   db  'Please enter the username:',0  
    buf5 db 'q',0
    buf6 db 'r',0


    OPTIONGET db ?
    USERNAMEHAVE   db  'zhuzicheng',0
    USERNAMEGET   db  10 DUP(0),0
    PASSWORDHAVE db  'z' XOR 'C','h' XOR 'C','u' XOR 'C','z' XOR 'C','i' XOR 'C','c' XOR 'C','h' XOR 'C','e' XOR 'C','n' XOR 'C','g' XOR 'C',0
    PASSWORDGET   db  10 DUP(0),0
    SAMPLES  STRUCT
        SAMID  DB 9 DUP(0)   ;每组数据的流水号
        SDA   DD  256809     ;状态信息a
        SDB   DD  -1023      ;状态信息b
        SDC   DD   1265      ;状态信息c
        SF    DD   0        ;处理结果f
    SAMPLES  ENDS           ;共25字节
    s SAMPLES 3 DUP(<>)
;    s1 SAMPLES<1,,,,>
;    s2 SAMPLES<2,,,,>
;    s3 SAMPLES<3,,,,>
;    s4 SAMPLES<4,,,,>
;    s5 SAMPLES<5,25,,,>
;    s6 SAMPLES<6,25680,,,>
	LOWF  SAMPLES 100 DUP(<>)
	MIDF  SAMPLES 100 DUP(<>)
	HIGHF SAMPLES 100 DUP(<>)

;    main_pointer dd 0
    lowf_pointer dd 0
    midf_pointer dd 0
    highf_pointer dd 0

    begin_time dd 0
    end_time dd 0
    spend_time dd 0

STRR DB  46H
LEN=$-STRR

oldprotect dd ?

.STACK 200
.CODE
mystrcmp macro v1,v2,v3,v4
local JUDGEONE,Is_equal,Not_equal,Exit
    push ecx
    mov ecx,v4
    lea esi,v1
    lea edi,v2
JUDGEONE:
    mov al,[esi]
    mov bl,[edi]
    cmp al, bl

    jne Not_equal
    inc esi
    inc edi
    loop JUDGEONE
    jmp Is_equal

Is_equal:
;   invoke printf,offset buf2
    mov eax,1
    mov v3,eax
   jmp Exit
Not_equal:
;    invoke printf,offset buf3
    mov eax,0
    mov v3,eax
    jmp Exit
Exit:
    pop ecx
    endm
main proc c 
    mov ecx,3
CHECK:
    push ecx
    invoke printf,OFFSET buf4
    invoke scanf,offset lpfmt2,offset USERNAMEGET
    pop ecx
;    lea esi,USERNAMEHAVE
;    lea edi,USERNAMEGET
    mystrcmp USERNAMEHAVE,USERNAMEGET,ebx,10
    cmp ebx,1
    jne CHECK1
    push ecx
    invoke printf,offset buf2

    invoke printf,OFFSET buf1
    invoke scanf,offset lpfmt2,offset PASSWORDGET 
     ;动态修改执行代码部分
	mov eax,len
	mov ebx,40H
	lea ecx,COPY_HERE
	invoke VirtualProtect,ecx,eax,ebx,offset oldprotect
	mov ecx,len
	mov edi,offset COPY_HERE
	mov esi,offset STRR

COPY_CODE:
	mov al,[esi]
	mov [edi],al
	inc esi
	inc edi
	loop COPY_CODE

    invoke timeGetTime
    mov begin_time,eax
    mov ecx,10
    lea esi,PASSWORDGET
PASSWORD_RETURN: 
    mov al,[esi]
    xor al,'C'
    mov [esi],al
COPY_HERE:
	db len dup(0)
;    inc esi
    loop PASSWORD_RETURN
    invoke timeGetTime
    mov end_time,eax
    sub eax,begin_time
    mov spend_time,eax
;    invoke printf,offset lpfmt1,spend_time
    sub eax,55
    jns MAIN_EXIT
    mystrcmp PASSWORDHAVE,PASSWORDGET,ebx,10
    pop ecx
    cmp ebx,1
    jne CHECK1
    invoke printf,offset buf2



Q_RETURN:
    LEA esi,s
    mov ecx,3
NEXT:
    invoke getSF,dword ptr [esi].SAMPLES.SDA,dword ptr [esi].SAMPLES.SDB,dword ptr [esi].SAMPLES.SDC
	mov [esi].SAMPLES.SF,eax
    push ecx
;	invoke printf,offset lpfmt,[esi].SAMPLES.SF
;    pop ecx
;    mov main_pointer,ecx
;    mov eax,100
    cmp eax, 100
    js TO_LOWF
    je TO_MIDF
    jns TO_HIGHF
RETURN:    
;    mov ecx,main_pointer
    pop ecx
    add esi,16
    loop NEXT
    invoke printmidf
OPTION_ERROR:
    invoke getchar
    invoke scanf,offset lpfmt3,offset OPTIONGET
    mystrcmp OPTIONGET,buf6,ebx,1
    cmp ebx,1
    je Q_RETURN

    mystrcmp OPTIONGET,buf5,ebx,1
    cmp ebx,0
    je OPTION_ERROR
    jmp MAIN_EXIT

CHECK1:
    push ecx
    invoke printf,offset buf3
    pop ecx
    dec ecx
    cmp ecx,0
    jne CHECK
    invoke ExitProcess, 0
TO_LOWF:
    call tolowf
    jmp RETURN



TO_MIDF:
    call tomidf
    jmp RETURN

TO_HIGHF:
    call tohighf
    jmp RETURN


MAIN_EXIT:

    invoke ExitProcess, 0
main endp

END
