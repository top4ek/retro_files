;Мона
;Original version for Atari XL - Jakub 'Ilmenit' Debski (2014)
;Версия для Вектора-06Ц - Иван Городецкий (2020)

		.org 0000h

start:
		ei
		hlt
		lxi b,colors
		mvi	a, 88h
		out	0
		lxi h,7F03h
		sphl
colorset1:
		mov a,l
		out	2
		ldax b
		out	0Ch
		rst 7\ rst 7
		inx b
		dcr l
		out	0Ch
		jp	colorset1

ClrScr:
		mov m,a
		inx h
		cmp h
		jnz	ClrScr

		mvi b,64
		mov l,c
OuterLoop:
		mvi a,11b
		ana b
		add a
		lxi d,ColorsSMC
		add e
		mov e,a
		ldax d
		sta SetClr1
		inx d
		ldax d
		sta SetClr2
		mvi a,0C9h
		out 3
		mov e,m
		inx h
		mov d,m
		inx h
		push h
		push d

		mov c,e		;x
		mov a,d
		cma
		mov e,a		;y
		mvi h,0
		mov l,b
		dad h\ dad h\ dad h\ dad h\ dad h
					;hl=len
					;e=y
					;c=x
					;b=part
InnerLoop:

rnd32:
		xthl
		dad h
rnd32high1:
		mvi a,0C8h
		adc a
		mov d,a
rnd32high2:
		mvi a,07Eh
		adc a
		jnc AfterRND32
		xri 004h\ push psw
		mvi a,0B7h\ xra l\ mov l,a
		sta dir+1
		mvi a,01Dh\ xra h\ mov h,a
		mvi a,0C1h\ xra d\ mov d,a
		pop psw
AfterRND32:
		sta rnd32high2+1
		mov a,d
		sta rnd32high1+1
		xthl
		push h

dir:
		mvi a,0
		ani 82h
		jz case00
		jpe case82
		jm case80
;case02:
		inr c			;x+=1
		.db 0FEh		;cpi
case82:
		dcr c			;x-=1
		.db 0FEh		;cpi
case00:
		dcr e			;y+=1
		.db 0FEh		;cpi
case80:
		inr e			;y-=1
		mvi a,7Fh
		ana e
		mov e,a
		cpi 32
		jc setpixel_end

; ---
; вход:
; C - X
; E - Y
;setpixel:
		mvi a,111b
		ana c
		mov l,a
		xra a
		stc
		rar
		dcr l
		jp $-2
		mov h,a
		cma
		mov l,a

		mvi a,01111000b
		ana c
		rrc
		rrc
		rrc
		adi 0E8h
		mov d,a
		ldax d
SetClr1:
		ora h
		stax d
		mvi a,-32
		add d
		mov d,a
		ldax d
SetClr2:
		ora h
		stax d
setpixel_end:
		pop h
		
		dcx h
		mov a,l
		ora h
		jnz InnerLoop
		pop h
		pop h
		dcr b
		jnz OuterLoop
colors:
		.db (1*64)+(6*8)+6,(0*64)+(4*8)+7,(0*64)+(3*8)+5,0


pic:
	.dw 0030Ah, 037BEh, 02F9Bh, 0072Bh, 00E3Ch, 0F59Bh, 08A91h, 01B0Bh
	.dw 00EBDh, 09378h, 0B83Eh, 0B05Ah, 070B5h, 00280h, 0D0B1h, 09CD2h
	.dw 02093h, 0209Ch, 03D11h, 026D6h, 0DF19h, 097F5h, 090A3h, 0A347h
	.dw 08AF7h, 00859h, 029ADh, 0A32Ch, 07DFCh, 00D7Dh, 0D57Ah, 03051h
	.dw 0D431h, 0542Bh, 0B242h, 0B114h, 08A96h, 02914h, 0B0F1h, 0532Ch
	.dw 00413h, 00A09h, 03EBBh, 0E916h, 01877h, 0B8E2h, 0AC72h, 080C7h
	.dw 05240h, 08D3Ch, 03EAFh, 0AD63h, 01E14h, 0B23Dh, 0238Fh, 0C07Bh
	.dw 0AF9Dh, 0312Eh, 096CEh, 025A7h, 09E37h, 02C44h, 02BB9h, 02139h
ColorsSMC:
	.db 0B4h,0B4h
	.db 0A5h,0A5h
	.db 0B4h,0A5h
	.db 0A5h,0B4h
	
	.db 0

	.end