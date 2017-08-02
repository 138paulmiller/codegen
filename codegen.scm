#lang scheme 

; 	PROG 	::= program BODY
;	BODY 	::= STMT BODY 
;			| epsilon
;	STMT	::= ASSIGN | WHILE | IF | CALL
;	ASSIGN  ::= assign VAR EXPR
;	WHILE   ::= while EXPR BODY
;	IF   	::= if EXPR BODY
;   EXPR 	::= op EXPR EXPR
;			| CALL
;			| VAR
;			| literal
;	CALL    ::= call FUNC_DEF PARAM
;   VAR     ::= var id type
;   FUNC_DEF::= func id TYPES return_type
;   TYPES   ::= type TYPES 
;			| epsilon
;	PARAMS  ::= EXPR PARAMS 
;			| epsilon 

;Create a namespace anchor and bind it to the current namespace
; allows eval to use defines functions below
(define-namespace-anchor ns-anchor)
(define ns (namespace-anchor->namespace ns-anchor))
(delete-file "gen.asm")
(define out (open-output-file "gen.asm"))
;ast data
(define ast
'(program
  (
  	(assign (var i int) (call (func getint void int) ()))
   	(assign (var j int) (call (func getint void int) ()))
   	(while (neq (var i int) (var j int))
    	((if (gt (var i int) (var j int))
         	((assign (var i int) (minus (var i int) (var j int))))
         	((assign (var j int) (minus (var j int) (var i int))))
         ))
    )
   	(call (func putint int void) ((var i int))))))


;code gen functions
(define program 
	(lambda (root)
		; root is (body)
		(displayln "SECTION .text" out)
		(displayln "global main" out)
		(displayln "main:" out)
		(body (car root))))

(define body 
	(lambda (root)
		;root is (stmt body)
		(cond ((pair? root)
				; stmt is car root
				(stmt (car root))
					; body is cdr root
				(body (cdr root))))))

(define stmt 
	(lambda (root)
		; root is (id (root))
		;Evaluate id on root 
		; finds function with name "id" and passes (root) as an argument 
		((eval (car root) ns) (cdr root))))


(define assign
	(lambda (root)
		;eval expr first and load 
		(expr  ( cadr root))
		;assume value loaded into EAX
		(display "mov " out)
		(var   ( cdar root))
		(displayln ", EAX" out)
		))


(define if
	(lambda (root)
		;first eval expression
		(expr   ( car root))
		; jump to true label, else false 
		(displayln "_if_true" out)
		;get the first of the remaining list
		(body  (caddr root))
		(displayln "jmp _end_if" out)
		(displayln "_if_true:" out)
		(body (cadr root))
		(displayln "_end_if:" out)
		
))

(define while
	(lambda (root)
		(displayln "_while:" out)
		(expr   ( car root))
		(displayln "_while_true" out)
		;if it falls thru cmp
		(displayln "jmp _end_while" out)
		(displayln "_while_true:" out)
		;get the first of the remaining list
		(body  ( cadr root))
		(displayln "jmp _while" out)
		(displayln "_end_while:" out)))


(define expr
	(lambda (root)
		((eval (car root) ns) (cdr root))))


(define call
	(lambda (root)
		;push params onto stack
		(params (cadr root))
		(display "call " out)
		(displayln (cadar root) out)))

(define params 
	(lambda (root)
		(cond ((pair? root) 
			(display "push " out)
			(expr (car root))
			(newline out)
			(params (cdr root)))))) 

(define var
	(lambda (root)
		(cond ((eq? (cadr root) 'int)
					(display "DWORD" out))
				((eq? (cadr root) 'long)
					(display "QWORD" out)))
		(display " ["  out)
		(display (car root) out)
		(display "]" out)))

;----------------------OPERATORS----------------
(define eq
	(lambda (root)
		(display "mov EAX, " out)
		(expr (car root))
		(newline	out)
		(display "mov EBX, " out)
		(expr (cadr root))
		(newline	out)
		(displayln "cmp EAX, EBX" out) ;comapre ebx with other
		(display "je " out)
))

(define neq
	(lambda (root)
		(display "mov EAX, " out)
		(expr (car root))
		(newline	out)
		(display "mov EBX, " out)
		(expr (cadr root))
		(newline	out)
		(displayln "cmp EAX, EBX" out) ;comapre ebx with other
		(display "jne " out)))

(define gt
	(lambda (root)
		(display "mov EAX, " out)
		(expr (car root))
		(newline	out)
		(display "mov EBX, " out)
		(expr (cadr root))
		(newline	out)
		(displayln "cmp EAX, EBX" out) ;comapre ebx with other
		(display "jg " out)))


(define lt
	(lambda (root)
		(display "mov EAX, " out)
		(expr (car root))
		(newline	out)
		(display "mov EBX, " out)
		(expr (cadr root))
		(newline	out)
		(displayln "cmp EAX, EBX" out) ;comapre ebx with other
		(display "jl " out)))

(define plus
	(lambda (root)
		(display "mov EAX, " out)
		(expr (car root))
		(newline out)
		(display "add EAX, " out)
		(displayln (cdr root) out)
		(newline out)))

(define minus
	(lambda (root)
		(display "mov EAX, " out)
		(expr (car root))
		(newline out)
		(display "sub EAX, " out)
		(expr (cadr root))
		(newline out)))


;------------------------AST EVAL----------------
; AST is (id (root))
; Evaluate id on the root 
((eval (car ast) ns) (cdr ast))
(close-output-port out)