; bresenham's line algorithm
; written by Leonardo Ono (ono.leo@gmail.com)
; 26/09/2017
; target os: DOS (.COM file extension)

start_graphic_mode:
	mov ax, 0a000h
	mov es, ax
	mov ah, 0
	mov al, 13h
	int 10h
	ret

; ax = x1
; bx = y1
; cx = x2
; dx = y2
; di = color index
draw_line:
		mov word [.x1], ax
		mov word [.y1], bx
		mov word [.x2], cx
		mov word [.y2], dx
		sub cx, ax ; CX -> dx = x2 - x1
		sub dx, bx ; DX -> dy = y2 - y1
		mov word [.dx], cx
		mov word [.dy], dx
		cmp cx, 0
		jl .dx_less
		
	.dx_greater:
		cmp dx, 0
		jge .dx_greater_dy_greater
		jl .dx_greater_dy_less
	.dx_less:
		cmp dx, 0
		jge .dx_less_dy_greater
		jl .dx_less_dy_less
		
	.dx_greater_dy_greater:
		mov ax, [.dx]
		mov bx, [.dy]
		mov [draw_line_quadrant.dx], ax
		mov [draw_line_quadrant.dy], bx
		mov ax, [.x1]
		mov bx, [.y1]
		mov cx, [.x2]
		mov dx, [.y2]
		mov si, 0 ; quadrant 0
		jmp .continue
	.dx_greater_dy_less:
		mov ax, [.dy]
		neg ax
		mov bx, [.dx]
		mov [draw_line_quadrant.dx], ax
		mov [draw_line_quadrant.dy], bx
		mov ax, [.y1]
		neg ax
		mov bx, [.x1]
		mov cx, [.y2]
		neg cx
		mov dx, [.x2]
		mov si, 3 ; quadrant 3
		jmp .continue
	.dx_less_dy_greater:
		mov ax, [.dy]
		mov bx, [.dx]
		neg bx
		mov [draw_line_quadrant.dx], ax
		mov [draw_line_quadrant.dy], bx
		mov ax, [.y1]
		mov bx, [.x1]
		neg bx
		mov cx, [.y2]
		mov dx, [.x2]
		neg dx
		mov si, 1 ; quadrant 1
		jmp .continue
	.dx_less_dy_less:
		mov ax, [.dx]
		neg ax
		mov bx, [.dy]
		neg bx
		mov [draw_line_quadrant.dx], ax
		mov [draw_line_quadrant.dy], bx
		mov ax, [.x1]
		neg ax
		mov bx, [.y1]
		neg bx
		mov cx, [.x2]
		neg cx
		mov dx, [.y2]
		neg dx
		mov si, 2 ; quadrant 2
		
	.continue:
		call draw_line_quadrant
		ret
		.x1 dw 0
		.y1 dw 0
		.x2 dw 0
		.y2 dw 0
		.dx dw 0
		.dy dw 0
		
; ax = x1
; bx = y1
; cx = x2
; dx = y2
; di = color index
; si = quadrant
draw_line_quadrant:
		add si, si
		push cx
		push dx
		mov cx, word [.dx] ; CX = dx
		mov dx, word [.dy] ; DX = dy
		cmp cx, dx
		jge .not_swap
	.swap:
		pop dx
		pop cx
		xchg ax, bx
		xchg cx, dx
		inc si
		jmp .continue
	.not_swap:
		pop dx
		pop cx
	.continue:
		call draw_line_octant
		ret
	.dx dw 0
	.dy dw 0
		
; ax = x1
; bx = y1
; cx = x2
; dx = y2
; di = color index
; si = octant
draw_line_octant:
		mov word [.x2], cx
		sub cx, ax
		sub dx, bx
		add dx, dx 
		mov word [.2dy], dx
		sub dx, cx ; dx = d = 2 * dy - dx
		add cx, cx
		mov word [.2dx], cx
		; bx = y = y1
		mov cx, ax ; cx = x
		mov ax, di
	.next_point:
		call pset_octant
		cmp dx, 0
		jle .d_less_or_equal
	.d_greater:
		add dx, word [.2dy]
		sub dx, word [.2dx]
		inc bx
		jmp .continue
	.d_less_or_equal:
		add dx, word [.2dy]
	.continue:
		inc cx
		cmp cx, word [.x2]
		jbe .next_point
		ret
		.x2 dw 0
		.2dx dw 0
		.2dy dw 0

; al = color index
; bx = row
; cx = col
; si = octant
pset_octant:
		push bx
		push cx
		cmp si, 0
		jz .octant_0
		cmp si, 1
		jz .octant_1
		cmp si, 2
		jz .octant_2
		cmp si, 3
		jz .octant_3
		cmp si, 4
		jz .octant_4
		cmp si, 5
		jz .octant_5
		cmp si, 6
		jz .octant_6
		cmp si, 7
		jz .octant_7
	.octant_0:
		; do nothing
		jmp .continue
	.octant_1:
		xchg bx, cx
		jmp .continue
	.octant_2:
		neg bx
		xchg bx, cx
		jmp .continue
	.octant_3:
		neg cx
		jmp .continue
	.octant_4:
		neg cx
		neg bx
		jmp .continue
	.octant_5:
		neg cx
		neg bx
		xchg bx, cx
		jmp .continue
	.octant_6:
		neg cx
		xchg bx, cx
		jmp .continue
	.octant_7:
		neg bx
	.continue:
		call pset
		pop cx
		pop bx
		ret
		
; al = color index
; bx = row
; cx = col
pset:
	pusha
	xor dx, dx
	push ax
	mov ax, 320
	mul bx
	add ax, cx
	mov bx, ax
	pop ax
	mov byte [es:bx], al
	popa
	ret

	
