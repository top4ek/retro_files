;Пример быстрого программирования палитры ПК Вектор-06Ц
;Используется один out 0Ch на каждый цвет
;Версия 2.1
;28.01.2018
;Иван Городецкий
;проверка на реале 06Ц - Вячеслав Славинский

		.org 100h

start:		di
		xra	a
		out	10h
		mvi	a, 0C3h		;jmp
		sta	0
		lxi	h, start
		shld	1
		mvi	a, 0C9h		;ret
		sta	38h

		lxi	sp, 100h

		ei
		hlt
		call	colorblack

		lxi	h, colors+15
		call	colorset

		call	cls

		lxi	h,0E2F8h
		mvi	a,1
FillScr:
		call	PrintNums
		inr	h
		inr	h		
		inr	a
		cpi	16
		jnz	FillScr
		
neverend:
		jmp	neverend



cls:
		xra	a
		lxi	h, 8000h
cls1:		mov	m,a
		inx	h
		cmp	h
		jnz	cls1
		ret

colorset:
		ei
		hlt
;3 (с учетом ret)
		push	psw
		push	h
;4 nop
		nop
		nop
		nop
		nop
		mvi	a, 88h
		out	0


		mvi	a,15
		out	2
		mov	a,m

		out	0Ch
;4 nop
		nop
		nop
		nop
		nop
;34
		mvi	a,14
		out	2
		dcx	h
		mov	a,m
;43
		nop\ nop\ nop \ nop \ nop \ nop
;1
		out	0Ch
;4
		mvi	a,13
		out	2
		dcx	h
		mov	a,m
;13
		out	0Ch
;16
		mvi	a,12
		out	2
		dcx	h
		mov	a,m
;25
		out	0Ch
;28
		mvi	a,11
		out	2
		dcx	h
		mov	a,m
;37
		xthl
		xthl
;1
		out	0Ch
;4
		mvi	a,10
		out	2
		dcx	h
		mov	a,m
;13
		out	0Ch
;16
		mvi	a,9
		out	2
		dcx	h
		mov	a,m
;25
		out	0Ch
;28
		mvi	a,8
		out	2
		dcx	h
		mov	a,m
;37
		xthl
		xthl
;1
		out	0Ch
;4
		mvi	a,7
		out	2
		dcx	h
		mov	a,m
;13
		out	0Ch
;16
		mvi	a,6
		out	2
		dcx	h
		mov	a,m
;25
		out	0Ch
;28
		mvi	a,5
		out	2
		dcx	h
		mov	a,m
;37
		xthl
		xthl
;1
		out	0Ch
;4
		mvi	a,4
		out	2
		dcx	h
		mov	a,m
;13
		out	0Ch
;16
		mvi	a,3
		out	2
		dcx	h
		mov	a,m
;25
		out	0Ch
;28
		mvi	a,2
		out	2
		dcx	h
		mov	a,m
;37
		xthl
		xthl
;1
		out	0Ch
;4
		mvi	a,1
		out	2
		dcx	h
		mov	a,m
;13
		out	0Ch
;16
		xra	a
		out	2
		dcx	h
		mov	a,m
;24
		out	0Ch
;27

		mvi	a,255
		out	3
		pop	h
		pop	psw
		ret


;A-код (0-31)
;С-цвет (0-15)
;HL-куда (E000-FFFF)
;Выводит на очищеный фон
PutSym:
		push	psw
		push	b
		push	d
		push	h
		add	a
		add	a
		add	a
		lxi	d,FONT
		add	e
		mov	e,a
		mvi	a,0
		adc	d
		mov	d,a
		mov	a,c
		rrc
		cc	PutSym2c
		lxi	b,-8192
		dad	b
		rrc
		cc	PutSym2c
		dad	b
		rrc
		cc	PutSym2c
		dad	b
		rrc
		cc	PutSym2c
		pop	h
		pop	d
		pop	b
		pop	psw
		ret

PutSym2c:
		push	psw
		push	d
		push	h
		ldax d\ mov m,a\ inx d\ inr l
		ldax d\ mov m,a\ inx d\ inr l
		ldax d\ mov m,a\ inx d\ inr l
		ldax d\ mov m,a\ inx d\ inr l
		ldax d\ mov m,a\ inx d\ inr l
		ldax d\ mov m,a\ inx d\ inr l
		ldax d\ mov m,a\ inx d\ inr l
		ldax d\ mov m,a
		pop	h
		pop	d
		pop	psw
		ret		

PrintNums:
		push	psw
		push	b
		push	d
		push	h
		mvi	d,32
		mov	c,a
Row:
		mvi	e,2
		push	h
Col:
		call	PutSym
		inr	h
		dcr	e
		jnz	Col
		pop	h
		dcr	l\ dcr l\ dcr l\ dcr l\ dcr l\ dcr l\ dcr l\ dcr l
		dcr	d
		jnz	Row
		pop	h
		pop	d
		pop	b
		pop	psw
		ret


colorblack:
		mvi	a, 88h
		out	0
		mvi	c, 15
colorset1:
		mov	a, c
		out	2
		xra	a
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
		ret


#define Red 4
#define Green 32
#define Blue 128
#define IRed 6
#define IGreen 48
#define IBlue 192

colors:
		.db 0,Red,Green,Green+Red,Blue,Blue+Red,Blue+Green,Blue+Green+Red
		.db 255,IRed,IGreen,IGreen+IRed,IBlue,IBlue+IRed,IBlue+IGreen,IBlue+IGreen+IRed



FONT:
	.DB 00,3Ch,66h,66h,66h,66h,3Ch,0
	.DB 00,3Ch,18h,18h,18h,78h,38h,0
	.DB 00,7Eh,30h,18h,0Ch,6Ch,38h,0
	.DB 00,3Ch,66h,06h,1Ch,06h,7Eh,0
	.DB 00,06h,06h,06h,7Eh,36h,1Eh,0
	.DB 00,3Ch,66h,06h,7Ch,60h,7Eh,0
	.DB 00,3Ch,66h,66h,7Ch,60h,3Ch,0
	.DB 00,30h,30h,30h,18h,0Ch,3Eh,0
	.DB 00,3Ch,66h,66h,3Ch,66h,3Ch,0
	.DB 00,3Ch,06h,06h,3Eh,66h,3Ch,0
	.DB 00,66h,66h,7Eh,66h,66h,3Eh,0
	.DB 00,7Ch,66h,66h,7Ch,66h,7Ch,0
	.DB 00,3Ch,66h,60h,60h,66h,3Ch,0
	.DB 00,7Ch,66h,66h,66h,66h,7Ch,0
	.DB 00,7Eh,60h,60h,78h,60h,7Eh,0
	.DB 00,60h,60h,60h,78h,60h,7Eh,0

		.end
