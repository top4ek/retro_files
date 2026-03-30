;Иван Городецкий, 28.07.2018

		.org 100h

		di
		xra	a
		out	10h
		lxi	sp,100h
		mvi	a,0C3h
		sta	0
		lxi	h,Restart
		shld	1

		call	Cls
		mvi	a,0C9h
		sta	38h
		ei
		hlt
		lxi	h, colors+15
colorset:
		mvi	a, 88h
		out	0
		mvi	c, 15
colorset1:	mov	a, c
		out	2
		mov	a, m
		out	0Ch
		dcx	h
		out	0Ch
		out	0Ch
		dcr	c
		out	0Ch
		out	0Ch
		out	0Ch
		jp	colorset1
		mvi	a,255
		out	3


Restart:
		mvi b,20h
		call ChkMem
		lxi h,Template
		lxi d,Txt20+8
		call ldir0

		mvi b,40h
		call ChkMem
		lxi h,Template
		lxi d,Txt40+8
		call ldir0

		mvi b,60h
		call ChkMem
		lxi h,Template
		lxi d,Txt60+8
		call ldir0

		mvi b,80h
		call ChkMem
		lxi h,Template
		lxi d,Txt80+8
		call ldir0

		mvi b,0A0h
		call ChkMem
		lxi h,Template
		lxi d,TxtA0+8
		call ldir0

		mvi b,0C0h
		call ChkMem
		lxi h,Template
		lxi d,TxtC0+8
		call ldir0

		mvi b,0E0h
		call ChkMem
		lxi h,Template
		lxi d,TxtE0+8
		call ldir0

		xra a
		out 10h
		lxi	h,Txt20
		lxi	d,0E1E0h
		mvi c,7
loop1:
		push d
		call	PrintText
		pop d
		mvi a,-8
		add e
		mov e,a
		dcr c
		jnz loop1

neverend:
		jmp	neverend		

ChkMem:
		call FillMem
		inr b
		call FillMem
		inr b
		call FillMem
		inr b
		call FillMem
		push b
		mvi b,0
		call FillMem
		pop b
		
		
		call ChkMemE0FF
		mvi a,'+'
		jz ChkMem_1
		mvi a,'-'
ChkMem_1:
		sta Template+14
		call ChkMemA0DF
		mvi a,'+'
		jz ChkMem_2
		mvi a,'-'
ChkMem_2:
		sta Template+13
		call ChkMem809F
		mvi a,'+'
		jz ChkMem_3
		mvi a,'-'
ChkMem_3:
		sta Template+12

		dcr b
		
		call ChkMemE0FF
		mvi a,'+'
		jz ChkMem_4
		mvi a,'-'
ChkMem_4:
		sta Template+10
		call ChkMemA0DF
		mvi a,'+'
		jz ChkMem_5
		mvi a,'-'
ChkMem_5:
		sta Template+9
		call ChkMem809F
		mvi a,'+'
		jz ChkMem_6
		mvi a,'-'
ChkMem_6:
		sta Template+8
		
		dcr b
		
		call ChkMemE0FF
		mvi a,'+'
		jz ChkMem_7
		mvi a,'-'
ChkMem_7:
		sta Template+6
		call ChkMemA0DF
		mvi a,'+'
		jz ChkMem_8
		mvi a,'-'
ChkMem_8:
		sta Template+5
		call ChkMem809F
		mvi a,'+'
		jz ChkMem_9
		mvi a,'-'
ChkMem_9:
		sta Template+4


		dcr b
		
		call ChkMemE0FF
		mvi a,'+'
		jz ChkMem_10
		mvi a,'-'
ChkMem_10:
		sta Template+2
		call ChkMemA0DF
		mvi a,'+'
		jz ChkMem_11
		mvi a,'-'
ChkMem_11:
		sta Template+1
		call ChkMem809F
		mvi a,'+'
		jz ChkMem_12
		mvi a,'-'
ChkMem_12:
		sta Template+0
		ret

ChkMem809F:
		mov a,b
		out 10h
		lxi h,8000h
		lxi d,8192
		jmp ChkMemLoop

ChkMemA0DF:
		mov a,b
		out 10h
		lxi h,0A000h
		lxi d,16384
		jmp ChkMemLoop

ChkMemE0FF:
		mov a,b
		out 10h
		lxi h,0E000h
		lxi d,8192

ChkMemLoop:
		mov a,m
		cmp b
		rnz
		inx h
		dcx d
		mov a,e
		ora d
		jnz ChkMemLoop
		ret


FillMem:
		mov a,b
		out 10h
		xra a
		lxi h,8000h
FillMem1:
		mov m,b
		inx h
		cmp h
		jnz FillMem1
		ret

;??? - 8000-9FFF,A000-DFFF,E000-FFFF
Txt20	.db "20-23 - ???:???:???:???",0
Txt40	.db "40-43 - ???:???:???:???",0
Txt60	.db "60-63 - ???:???:???:???",0
Txt80	.db "80-83 - ???:???:???:???",0
TxtA0	.db "A0-A3 - ???:???:???:???",0
TxtC0	.db "C0-C3 - ???:???:???:???",0
TxtE0	.db "E0-E3 - ???:???:???:???",0
Template .db "???:???:???:???",0

ldir0:
		mov a,m
		ora a
		rz
		stax d
		inx h
		inx d
		jmp ldir0

PrintText:
PrintTextLoop:
		mov	a,m
		ora	a
		inx	h
		jz	PrintTextExit
		call	PrintChar
		inr	d
		jmp	PrintTextLoop
PrintTextExit:
		ret

PrintChar:
		push	d
		push	h
		push	b
		mov	l,	a
		mvi	h,	0
		dad		h
		dad		h
		dad		h
		lxi	b,	Font-256
		dad		b
		mvi	b,	8
loopchar:
		mov	a,	m
		inx		h
		stax		d
		dcr		e
		dcr		b
		jnz		loopchar
		pop		b
		pop		h
		pop		d
		ret

Cls:
		lxi	h,0E000h
		xra	a
ClrScr:
		mov	m,a
		inx	h
		cmp	h
		jnz	ClrScr
		ret

#define col 173

colors:
		.db 0,col,0,col,0,col,0,col,0,col,0,col,0,col,0,col

Font:

		.end