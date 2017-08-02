SECTION .text
global main
main:
call getint
mov DWORD [i], EAX
call getint
mov DWORD [j], EAX
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
call putint
