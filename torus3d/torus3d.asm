; wireframe 3d torus 8086/87 (using 13h graphic mode)
; written by Leonardo Ono (ono.leo@gmail.com)
; 28/09/2017
; target os: DOS (.COM file extension)
; use: nasm cube3d.asm -o cube3d.com -f bin

	bits 16
	org 100h

start:
		finit
		call start_graphic_mode

	.main_loop:
		call reset

		mov si, deg3
		mov bx, angle_x
		call inc_angle

		mov si, deg5
		mov bx, angle_y
		call inc_angle

		mov si, deg1
		mov bx, angle_z
		call inc_angle

		call rotate_x
		call rotate_y
		call rotate_z

		call update_cube_z

		mov ax, 0
		mov bx, 0
		mov cx, -250
		add cx, [cube_z]
		call translate
		
		call do_perspective

		mov di, 15
		call draw_cube

		mov ah, 1
		int 16h
		jz .no_key
		jmp exit_process
	.no_key:
		mov si, 1
		call sleep2
		
		mov di, 0
		call draw_cube ; clear screen
		
		jmp .main_loop	

;sleep:
;		pusha
;		mov cx, 00h
;		mov dx, 08480h
;		mov al, 0
;		mov ah, 86h
;		int 15h
;		popa
;		ret

; in:
;	si = number of 55.56 ms to wait
sleep2:
		mov ah, 0
		int 1ah
		mov bx, dx
	.wait:
		mov ah, 0
		int 1ah
		sub dx, bx
		cmp dx, si
		jl .wait
		ret

exit_process:
		mov ah, 4ch
		int 21h

		%include "print_float.inc"
		%include "graphic.inc"

; restore all local space vertices to world space		
reset:
		mov cx, [vertices_count]
		mov di, 0
	.next_vertex:
		fld qword [vertices_local + point.x + di]
		fstp qword [vertices_world + point.x + di]
		fld qword [vertices_local + point.y + di]
		fstp qword [vertices_world + point.y + di]
		fld qword [vertices_local + point.z + di]
		fstp qword [vertices_world + point.z + di]
		add di, point.size
		loop .next_vertex
		ret

; ax = x		
; bx = y
; cx = z		
translate:
		mov word [.tx], ax
		mov word [.ty], bx
		mov word [.tz], cx
		mov cx, [vertices_count]
		mov di, 0
	.next_vertex:
		fild word [.tx]
		fld qword [vertices_world + point.x + di]
		fadd st1
		fstp qword [vertices_world + point.x + di]
		ffree st0

		fild word [.ty]
		fld qword [vertices_world + point.y + di]
		fadd st1
		fstp qword [vertices_world + point.y + di]
		ffree st0

		fild word [.tz]
		fld qword [vertices_world + point.z + di]
		fadd st1
		fstp qword [vertices_world + point.z + di]
		ffree st0
		
		add di, point.size
		loop .next_vertex
		ret
		.tx dw 0
		.ty dw 0
		.tz dw 0

; si = x axis
; di = y axis
; ax = angle inc
; TODO: direction of rotation may not be correct
rotate_axis:
		mov cx, [vertices_count]
		mov bx, 0

	.next_vertex:
		fld qword [vertices_world + si + bx]
		fld qword [vertices_world + di + bx]
		
		push bx
		mov bx, ax
		fld qword [bx] 
		fcos
		fld qword [bx] 
		fsin
		pop bx
		
		fld st2
		fmul st1

		fld st4
		fmul st3
		fsub st1

		fstp qword [vertices_world + si + bx]
		
		fld st3
		fmul st3

		fld st5
		fmul st3
		fadd

		fstp qword [vertices_world + di + bx]

		ffree st0
		ffree st1
		ffree st2
		ffree st3
		ffree st4
		ffree st5

		add bx, point.size
		loop .next_vertex
		ret
		
rotate_x:
		mov ax, angle_x
		mov si, point.z
		mov di, point.y
		call rotate_axis
		ret

rotate_y:
		mov ax, angle_y
		mov si, point.z
		mov di, point.x
		call rotate_axis
		ret

rotate_z:
		mov ax, angle_z
		mov si, point.x
		mov di, point.y
		call rotate_axis
		ret

do_perspective:
		mov cx, [vertices_count]
		mov di, 0
		mov si, 0
	.next_vertex:
		fld qword [vertices_world + point.z + di] ; st2
		fld qword [screen_distance] ; st1

		fld qword [vertices_world + point.x + di] ; st0
		fdiv st2
		fmul st1
		fistp word [vertices_screen + screen.x + si]
		
		fld qword [vertices_world + point.y + di] ; st0
		fdiv st2
		fmul st1
		fistp word [vertices_screen + screen.y + si]
		
		ffree st0
		ffree st1
		
		add di, point.size
		add si, screen.size
		loop .next_vertex
		ret

; in: di = color index
draw_cube:
		mov cx, [edges_count]
		mov si, 0 ; edge index
	.next_edge:
		push cx
		push si
		push di

		mov ax, si
		xor dx, dx
		mov cx, edge.size
		mul cx
		mov di, ax
		mov bl, [edges + di + edge.p1] ; edge p1
		mov bh, [edges + di + edge.p2] ; edge p2

		mov ax, screen.size
		mov ch, 0
		mov cl, bl
		xor dx, dx
		mul cx
		mov di, ax
		mov si, [vertices_screen + di + screen.x]
		mov [.x1], si
		mov si, [vertices_screen + di + screen.y]
		mov [.y1], si

		mov ax, screen.size
		mov ch, 0
		mov cl, bh
		xor dx, dx
		mul cx
		mov di, ax
		mov si, [vertices_screen + di + screen.x]
		mov [.x2], si
		mov si, [vertices_screen + di + screen.y]
		mov [.y2], si

		pop di
		mov ax, [.x1]
		mov bx, [.y1]
		mov cx, [.x2]
		mov dx, [.y2]
		add ax, 160
		add bx, 100
		add cx, 160
		add dx, 100
		call draw_line

		pop si
		pop cx
		inc si
		loop .next_edge
		ret		
	.x1	dw 0
	.y1	dw 0
	.x2	dw 0
	.y2	dw 0

; in:
;	bx = angle dest
;	si = incrementation
inc_angle:
		fld qword [si]
		fld qword [bx]
		fadd
		fstp qword [bx]
		ffree st0
		ret

update_cube_z:
		fld qword [angle_x]
		fsin
		fld qword [v25]
		fmul
		fistp word [cube_z]
		ffree st0
		ret

data:
		struc point
			.x	resq 1
			.y	resq 1
			.z	resq 1
			.size:
		endstruc

		struc screen
			.x	resw 1
			.y	resw 1
			.size:
		endstruc

		struc edge
			.p1	resb 1
			.p2	resb 1
			.size:
		endstruc

		deg1    dq 0.0174533
		deg3    dq 0.0523599
		deg5	dq 0.0872665

		v25		dq 25.0		
	
		cube_z	dw 0
		
		angle_x dq 0.0
		angle_y dq 0.0
		angle_z dq 0.0

		screen_distance	dq -150.0

		; --- torus data ---
		
		%include "torus.inc"

