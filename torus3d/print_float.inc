
; in:
;	bx = variable
print_float:
		pusha
		
		fld qword [.v100]
		fld qword [bx]
		fmul st1
		fbstp [.bcd]
		ffree st0

		mov dl, 1 ; still zero
		
		mov cx, 10
		mov bx, 9
	.next:
		mov al, [.bcd + bx]
		shr al, 4
		call .check_still_zero
		call .print_digit

		mov al, [.bcd + bx]
		and al, 0fh
		call .check_still_zero
		call .print_digit
		
		dec bx
		dec cx
		
		cmp cx, 1
		jnz .check_has_next
	
		mov al, '.'
		call print_char
	
	.check_has_next:
		cmp cx, 0
		jnz .next
		
		popa
		ret
	.check_still_zero:
		cmp al, 0
		jz .check_still_zero_ret
		mov dl, 0 ; first non zero digit
	.check_still_zero_ret:
		ret
	.print_digit:
		cmp dl, 1
		jz .print_digit_ret
		;mov al, [bcd + bx]
		;and al, 0fh
		add al, '0'
		call print_char
	.print_digit_ret:
		ret
	.v100:	dq 100.0
	.bcd:	dt 0.0
		
		
; in: al = char
print_char:
		mov ah, 0eh
		;mov al, 41h
		int 10h
		ret
