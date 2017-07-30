TODO CALL
((func getint void int) ())
mov DWORD PTR [i], EAX
TODO CALL
((func getint void int) ())
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
TODO MINUS((var j int) (var i int))
mov DWORD PTR [j], EAX
jmp _end_if
_if_true:
TODO MINUS((var i int) (var j int))
mov DWORD PTR [i], EAX
_end_if:
jmp _while
_end_while:
TODO CALL
((func putint int void) ((var i int)))
