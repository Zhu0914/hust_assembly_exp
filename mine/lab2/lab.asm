.686     
.model flat,c
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 scanf           PROTO C :VARARG
 clock           PROTO
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

.DATA
lpfmt	db	"%d", 0
    SAMPLES  STRUCT
        SAMID  DB 9 DUP(0)   ;每组数据的流水号
        SDA   DD  256809     ;状态信息a
        SDB   DD  -1023      ;状态信息b
        SDC   DD   1265      ;状态信息c
        SF    DD   0        ;处理结果f
    SAMPLES  ENDS           ;共25字节
    s SAMPLES 100 DUP(<>)
;    s1 SAMPLES<1,,,,>
;    s2 SAMPLES<2,,,,>
;    s3 SAMPLES<3,,,,>
;    s4 SAMPLES<4,,,,>
;    s5 SAMPLES<5,25,,,>
;    s6 SAMPLES<6,25680,,,>
	LOWF  SAMPLES 100 DUP(<>)
	MIDF  SAMPLES 100 DUP(<>)
	HIGHF SAMPLES 100 DUP(<>)

    main_pointer dd 0
    lowf_pointer dd 0
    midf_pointer dd 0
    highf_pointer dd 0

    begin_time dd 0
    end_time dd 0
    spend_time dd 0
.STACK 200
.CODE
main proc c 
	invoke clock
    mov begin_time,eax
    mov ecx,1000
_TEST:
    push ecx
    LEA esi,s
    mov ecx,100
NEXT:
    mov eax,[esi].SAMPLES.SDA
	imul eax,5
;    add eax,[esi].SAMPLES.SDA
	add eax,[esi].SAMPLES.SDB
	sub eax,[esi].SAMPLES.SDC
	add eax,100
	shr eax,7
	mov [esi].SAMPLES.SF,eax
    push ecx
;	invoke printf,offset lpfmt,[esi].SAMPLES.SF
;    pop ecx
;    mov main_pointer,ecx
    cmp eax, 100
    js TOLOWF
    je TOMIDF
    jns TOHIGHF
RETURN:    
;    mov ecx,main_pointer
    pop ecx
    add esi,16
    loop NEXT
    
    xor eax,eax
    mov lowf_pointer,eax
    mov midf_pointer,eax
    mov highf_pointer,eax
    pop ecx
    loop _TEST
    invoke clock
    mov end_time,eax
    sub eax,begin_time
    mov spend_time,eax
    invoke printf,offset lpfmt,spend_time
    invoke ExitProcess, 0
TOLOWF:
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
    jmp RETURN

TOMIDF:
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
    add midf_pointer,25
    jmp RETURN

TOHIGHF:
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
    add highf_pointer,25
    jmp RETURN
main endp

strcpy proc
;    PUSH esi
;   PUSH edi
    PUSH ecx

    mov ecx, 9

LP:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jnz LP

    POP ecx
;    POP edi
;    POP esi

    ret
strcpy endp
END
