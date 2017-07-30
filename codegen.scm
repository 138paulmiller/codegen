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

;ast data
(define ast
'(program
  (
  	(assign (var i int) (call (func getint void int) ()))
   	(assign (var j int) (call (func getint void int) ()))
   	(while (neq (var i int) (var j int))
    	((if (gt (var i int) (var j int))
         	((assign (var i int) (minus (var i int) (var j int))))
         	((assign (var j int) (minus (var j int) (var i int))))))
    )
   	(call (func putint int void) ((var i int))))))


;code gen functions

(define program 
	(lambda (root)
		; root is (body)
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
		(display "mov ")
		(var   ( cdar root))
		(displayln ", EAX")
		))


(define if
	(lambda (root)
		;first eval expression
		(displayln "_if:")
		(expr   ( car root))
		; jump to end if zero
		(displayln "jz _end_if")
		;get the first of the remaining list
		(body  ( cadr root))
		(displayln "_end_if:")
))

(define while
	(lambda (root)
		(displayln "_while:")
		(expr   ( car root))
		(displayln "jz _end_while")
		;get the first of the remaining list
		(body  ( cadr root))
		(displayln "_end_while:")))


(define expr
	(lambda (root)
		((eval (car root) ns) (cdr root))
	))


(define call
	(lambda (root)
		;push operands onto stack
		(displayln "call")
		(displayln root)

		))


(define var
	(lambda (root)
		(cond ((eq? (cadr root) 'int)
					(display "DWORD"))
				((eq? (cadr root) 'long)
					(display "QWORD"))
		)
		(display " PTR [" )
		(display (car root))
		(display "]" )

		))

;----------------------OPERATORS----------------
(define eq
	(lambda (root)
		(display "cmp")
		(expr (car root))
		(display ",") ;comapre ebx with other
		(expr (cdr root))))
		(display "\n")

(define neq
	(lambda (root)
		(display "mov EBX, ") ;move firs expression into ebx
		(expr (car root))
		(display "\nneg EBX\n") ;neg ebx, then compare
		(display "cmp EBX,") ;comapre ebx with other
		(expr (cadr root))
		(display "\n")
		))


(define gt
	(lambda (root)
		(display "TODO GT")
		(displayln root)))


(define lt
	(lambda (root)
		(display "TODO LT")
		(displayln root)))


(define plus
	(lambda (root)
		(display "TODO PLUS")
		(displayln root)))

(define minus
	(lambda (root)
		(display "TODO MINUS")
		(displayln root)))


;------------------------AST EVAL----------------
; AST is (id (root))
; Evaluate id on the root 
((eval (car ast) ns) (cdr ast))