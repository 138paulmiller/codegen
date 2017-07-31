call getint
mov DWORD PTR [i], EAX
call getint
mov DWORD PTR [j], EAX
_while:
mov EAX, DWORD PTR [i]
mov EBX, DWORD PTR [j]
cmp EAX, EBX
jne _end_while
_if:
mov EAX, DWORD PTR [i]
mov EBX, DWORD PTR [j]
cmp EAX, EBX
jg _if_true
mov EAX, DWORD PTR [j]
sub EAX, DWORD PTR [i]
mov DWORD PTR [j], EAX
jmp _end_if
_if_true:
mov EAX, DWORD PTR [i]
sub EAX, DWORD PTR [j]
mov DWORD PTR [i], EAX
_end_if:
jmp _while
_end_while:
push DWORD PTR [i]
call putint
