global main
extern printf

SECTION .data
i: dd 30
j: dd 20
fmt: db "GCD: %d",0

SECTION .text
main:
push    ebp		; set up stack frame
mov     ebp,esp

;gen section
_while:
mov EAX, DWORD [i]
mov EBX, DWORD [j]
cmp EAX, EBX
jne _while_true
jmp _end_while
_while_true:
mov EAX, DWORD [i]
mov EBX, DWORD [j]
cmp EAX, EBX
jg _if_true
mov EAX, DWORD [j]
sub EAX, DWORD [i]
mov DWORD [j], EAX
jmp _end_if
_if_true:
mov EAX, DWORD [i]
sub EAX, DWORD [j]
mov DWORD [i], EAX
_end_if:
jmp _while
_end_while:
push DWORD [i]
;end gen

push    DWORD fmt	
call    printf	
add     esp, 8		; pop stack 3 push times 4 bytes

mov     esp, ebp	; takedown stack frame
pop     ebp		; same as "leave" op

mov	eax,0		;  normal,