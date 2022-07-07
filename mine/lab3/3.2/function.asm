.686     
.model flat,stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 scanf           PROTO C :VARARG
 ;public getsf 
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

     SAMPLES  STRUCT
        SAMID  DB 9 DUP(0)   ;每组数据的流水号
        SDA   DD  256809     ;状态信息a
        SDB   DD  -1023      ;状态信息b
        SDC   DD   1265      ;状态信息c
        SF    DD   0        ;处理结果f
    SAMPLES  ENDS           ;共25字节
 ;extern lpfmt1:byte,lpfmt2:byte,
 extern s:SAMPLES,LOWF:SAMPLES,MIDF:SAMPLES,HIGHF:SAMPLES,s_pointer:dword,lowf_pointer:dword,midf_pointer:dword,highf_pointer:dword,F:dword
 .DATA
    buf7 db 'SAMID: %s SDA: %d SDB: %d SDC: %d SF: %d',0

 .CODE

getsf   PROC stdcall aget:dword,bget:dword,cget:dword
    mov eax,aget
	imul eax,5

	add eax,bget
	sub eax,cget
	add eax,100
	shr eax,7
    mov F,eax
    ret
getsf endp

tolowf PROC stdcall
    lea esi,s
    add esi,s_pointer
    lea edi,LOWF
    add edi,lowf_pointer
    mov ebx, [esi].SAMPLES.SDA
    mov [edi].SAMPLES.SDA, ebx
;    add edi,4
    mov ebx, [esi].SAMPLES.SDB
    mov [edi].SAMPLES.SDB, ebx
;    add edi,4
    mov ebx, [esi].SAMPLES.SDC
    mov [edi].SAMPLES.SDC, ebx
;    add edi,4
    mov [edi].SAMPLES.SF, eax
;    add edi,4
;    mov ecx,9
;    rep movsb
;    call strcpy
    PUSH ecx

    mov ecx, 9

LP1:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jnz LP1

    POP ecx
    add lowf_pointer,25
    add s_pointer,25
    ret
tolowf endp
tomidf PROC stdcall
    lea esi,s
    add esi,s_pointer
lea edi,MIDF
    add edi,midf_pointer
    mov ebx, [esi].SAMPLES.SDA
    mov [edi].SAMPLES.SDA, ebx
;    add edi,4
    mov ebx, [esi].SAMPLES.SDB
    mov [edi].SAMPLES.SDB, ebx
;    add edi,4
    mov ebx, [esi].SAMPLES.SDC
    mov [edi].SAMPLES.SDC, ebx
;    add edi,4
    mov [edi].SAMPLES.SF, eax
;    add edi,4
;    mov ecx,9
;    rep movsb
;   mov midf_pointer,edi
;    call strcpy
    PUSH ecx

    mov ecx, 9

LP2:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jnz LP2

    POP ecx
    add s_pointer,25
    add midf_pointer,25
    ret
tomidf endp
tohighf PROC stdcall
        lea esi,s
    add esi,s_pointer
    lea edi,HIGHF
    add edi,highf_pointer
    mov ebx, [esi].SAMPLES.SDA
    mov [edi].SAMPLES.SDA, ebx
;    add edi,4
    mov ebx, [esi].SAMPLES.SDB
    mov [edi].SAMPLES.SDB, ebx
;    add edi,4
    mov ebx, [esi].SAMPLES.SDC
    mov [edi].SAMPLES.SDC, ebx
;    add edi,4
    mov [edi].SAMPLES.SF, eax
;    add edi,4
;    mov ecx,9
;    rep movsb
;    call strcpy
    PUSH ecx

    mov ecx, 9

LP3:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jnz LP3

    POP ecx
    add s_pointer,25
    add highf_pointer,25
    ret
tohighf endp

printmidf proc
    push ecx
    push eax
    push esi
    mov eax,midf_pointer
    cmp eax,0
    je OUT_printmidf

    mov ecx,eax
    mov eax,0
    lea esi,MIDF
LP_printmidf:
    push ecx
    push eax
    invoke printf,addr buf7,word ptr [esi].SAMPLES.SAMID,word ptr [esi].SAMPLES.SDA,word ptr [esi].SAMPLES.SDB,word ptr [esi].SAMPLES.SDC,word ptr [esi].SAMPLES.SF
    pop eax
    pop ecx
    add esi,25
    add eax,25
    cmp eax,ecx
    jne LP_printmidf
OUT_printmidf:
    pop esi
    pop eax
    pop ecx
    ret
printmidf endp
end
