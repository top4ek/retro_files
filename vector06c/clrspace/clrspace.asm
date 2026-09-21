        ; PAL Colour Bars
	; And full BGR(2:3:3) colourspace
	; of Vector-06c
	;
	; Assemble with the Pretty i8080 Assembler
	;
	; Author: Viacheslav Slavinsky
	;
	; This code is Public Domain
	;
        .binfile clrspace.rom
        .nodump


dlines equ 128
dlist equ $4000
dlend equ dlist+dlines*8*3
ddata equ dlist+$2000
ddend equ ddata+dlines*8*2


	.org $100
clrscr:
	di
	lxi h, $8000
cs1:	xra a
	out $10
	mov m, a
	inx h
	ora h
	jnz cs1

	lxi sp, $100

	; draw pal colourbars
	; 8 bars (4 columns each), 128 lines high
	; easy colours $e000=R, $c000=G, $a000=B
	;
	; white
	lxi d, $e000
	lxi b, 256*4*0+256
	call palbar
	lxi d, $c000
	lxi b, 256*4*0+256
	call palbar
	lxi d, $a000
	lxi b, 256*4*0+256
	call palbar

	; yellow
	lxi d, $e000
	lxi b, 256*4*1+256
	call palbar
	lxi d, $c000
	lxi b, 256*4*1+256
	call palbar

	; cyan
	lxi d, $c000
	lxi b, 256*4*2+256
	call palbar
	lxi d, $a000
	lxi b, 256*4*2+256
	call palbar

	; green
	lxi d, $c000
	lxi b, 256*4*3+256
	call palbar

	; magenta
	lxi d, $e000
	lxi b, 256*4*4+256
	call palbar
	lxi d, $a000
	lxi b, 256*4*4+256
	call palbar

	; red
	lxi d, $e000
	lxi b, 256*4*5+256
	call palbar

	; blue
	lxi d, $a000
	lxi b, 256*4*6+256
	call palbar
	
	; black ;)

	jmp  part2
palbar:
	lxi h, 0
	dad sp
	shld savedsp
	xchg
	dad b
	sphl
	mvi b, $ff
	mov c, b
	mvi e, 4
barpo:	mvi d, 64
barpu:	push b
	dcr d
	jnz barpu
	lxi h, 128+256
	dad sp
	sphl
	dcr e
	jnz barpo
	lhld savedsp
	sphl
	ret
savedsp: dw 0

blit:
	shld gdstld+1
	xchg 
	shld gsrcld+1
	lxi h, 0
	dad sp
	shld savedsp

gsrcld:	lxi sp, 0
gdstld:	lxi h, 0
	;mvi b, $4
	
gorra:	
	pop d
	dcr l
	mov m, e
	dcr l
	mov m, d
	jnz gorra
	inr h
	mov l, c
	dcr b
	jnz gorra
	lhld savedsp
	sphl
	ret

part2:
	lxi h, $8080      ; destination
	lxi d, tits_0
	lxi b, $0880
	call blit	
	
	; make palette
	; start with colour in a=0
	; Blue spins each cycle (they be columns) 
	; R increments every 4 B
	; G increments every 4 R
	lxi h, sintbl
	lxi d, rgysorted
	xra a
       mov b, a
palea:
	mov m, a
	adi $40 ; add 1 to blue, overflow to R
	;adc b
	jnc paleb
	xchg
	inx h
	mov a, m
	xchg
paleb:
	inr l
	jnz palea
	
	; prepare display list
	;
	; one "poxel"
	; pop psw
	; out $c
	; == db $f1,$d3,$0c
	; 3 bytes, 24 cycles; 8 poxels per scanline exactly
	lxi h, dlines
	lxi b, $0cd3
	lxi d, $f100
	lxi sp, dlend+1 ; that's a ret
	mvi a, $c9
	push psw
	inx sp
pox1:
	lxi b, $00db ; dummy in instruction
	lxi d, $f100
	push b
	push d
	inx sp
	push b
	push d
	inx sp
	push b
	push d
	inx sp

	lxi b, $0cd3
	lxi d, $f100
	push b
	push d
	inx sp
	push b
	push d
	inx sp
	push b
	push d
	inx sp
	push b
	push d
	inx sp
	push b
	push d
	inx sp
	

	dcx h
	mov a, h
	ora l
	jnz pox1

	; a == 0
	sta dactr
	lxi b, $00fc 
dalup:
	; prepare actual poxel data
	lxi sp, ddend
	lxi d, dlines*8
dafi:
	lxi h, dactr
	mov a, m
	ani $4
	jz daclip

	lxi h, sintbl
	dad b
	mov a, m
	push psw
	jmp dafi00
daclip:
	xra a
	push psw
dafi00:
	inr c
	
	;
	lxi h, dactr
	inr m
	mov a, m
	ani $0f
	jnz dafi2
	mov a, c
	sbi 4		; -4, advance to next colourline
	mov c, a
	jmp dafi3
dafi2:
	mov a, m
	ani $7
	jnz dafi3
	mov a, c
	sbi 8		; -8, stay at the current colourline
	mov c, a
dafi3:
	dcx d
	mov a, d
	ora e
	jnz dafi
	
	mvi a, $c3
	sta $38

intreturn:
	xra a
	out $c
	lxi sp, $100
	lxi h, plasmaint
	shld $39	
puuup:
	ei
	hlt

;white    1     1     1
;yellow   1     1     0
;cyan     0     1     1
;green    0     1     0
;magenta  1     0     1
;red      1     0     0
;blue     0     0     1
;black    0     0     0 

palpal: ; @75%
	;db $00, $07, $38, $3f, $c0, $c7, $f8, $ff
	db $00, $05, $28, $2d, $80, $84, $a0, $a4

plasmaint:

	nop
	nop
	nop
	nop
	nop
	nop

	mvi a, 8
	out $2
	mvi a, $ff
	out $c

	; program palette for pal colourbarnik
	lxi h, palpal+7
	mvi b, 7
pallup:	mov a, b
	out $2
	mov a, m
	out $c
	out $c
	dcx h
	out $c
	out $c
	dcr b
	out $c
	out $c
	nop
	out $c
	jp pallup

	;mvi a, 1
	;out 02
	;xra a
	;out $0c
	;out 02
	mvi l, $bd
	xthl
	xthl
	xthl
	xthl
	push psw
	pop psw

pivw:	xthl
	xthl
	xthl
	xthl
	xthl
	xthl
	dcr l
	jnz pivw
	
	lxi h, intreturn
	lxi sp, ddend+2
	push h
	lxi sp, ddata
	jmp dlist

; tits or gtfo
tits_columns equ 8
tits_rows    equ 128
; layer 0
tits_0:
db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,0f7h,0f6h,0f7h,0f6h,0f5h,0f6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0edh,0edh,0e9h,0e5h,0edh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,087h,093h,093h,086h,092h,092h,087h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0fch,0f8h,0f0h,0f0h,0e0h,0e1h,0e1h,0e1h,0e1h,0e1h,0e1h,0f0h,0f0h,0f0h,0f8h,0f8h,0f8h,0fch,0fch,0feh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,
db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fdh,0f3h,0efh,063h,0adh,02dh,0adh,033h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e3h,0edh,0e3h,0edh,0e3h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,032h,051h,013h,071h,012h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,083h,00h,00h,03ch,07eh,0e7h,0c3h,083h,08fh,08eh,0c0h,0e0h,0f8h,0ffh,0ffh,0ffh,07fh,07fh,07fh,03fh,01fh,01fh,0fh,07h,083h,0c0h,0e0h,0f8h,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,
db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,08bh,0abh,0aah,0a9h,06bh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,08ch,07bh,078h,07bh,08ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,084h,0c9h,0c9h,0c9h,0cch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh,03fh,01fh,01fh,01fh,01fh,01fh,03eh,03eh,07eh,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0feh,0feh,0feh,0ffh,0ffh,03fh,01fh,01h,00h,0e0h,0feh,0ffh,0ffh,0feh,0fch,0fch,0feh,0ffh,0fch,0feh,0ffh,
db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,057h,057h,057h,056h,043h,0fbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,07fh,0ffh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c7h,04bh,04bh,04ah,0c7h,0cfh,0cfh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0f8h,0f0h,0e0h,0c1h,083h,07h,0fh,0fh,01fh,01fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,03fh,01fh,01fh,0fh,07h,07h,081h,0c0h,0e0h,00h,00h,00h,0c0h,0ffh,033h,093h,0f3h,033h,093h,098h,03ch,0ffh,
db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0feh,03eh,0deh,01eh,0deh,01eh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,058h,05bh,058h,05bh,08h,0efh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,03eh,09eh,012h,09eh,01fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,00h,00h,00h,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0f0h,0e0h,0c7h,0cfh,08fh,09fh,08fh,08fh,083h,0c0h,0c0h,0f0h,0fch,0ffh,0ffh,0ffh,0ffh,03fh,0fh,01fh,07fh,0fch,0ffh,031h,024h,024h,024h,024h,064h,0f1h,0ffh,
db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,049h,049h,049h,018h,079h,079h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e6h,05bh,0c3h,05fh,0e3h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,049h,048h,049h,049h,049h,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh,0fh,03h,00h,0c0h,0f0h,0fch,0feh,0ffh,0ffh,07fh,01fh,0fh,07h,087h,0c3h,0c3h,0c3h,083h,07h,07h,0fh,01fh,07fh,0ffh,0feh,0fch,0f8h,0f0h,0e0h,080h,00h,00h,0ffh,0cch,0d9h,0f9h,0f9h,0f9h,0f9h,0fch,0ffh,
db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,067h,027h,027h,027h,027h,027h,020h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,033h,07dh,071h,06dh,071h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,0ffh,069h,029h,029h,029h,060h,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,03fh,01fh,0fh,0fh,087h,087h,0c7h,0c3h,0c3h,0e3h,0e3h,0e3h,0e3h,0e3h,0c3h,0c3h,0c7h,087h,08fh,0fh,01fh,01fh,03fh,07fh,03fh,01fh,0fh,07h,0ffh,071h,024h,024h,030h,03ch,024h,071h,0ffh,
db 080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,


rgysorted: db , 0, 1, 2, 9, 3, 10, 4, 11, 5, 18, 12, 6, 19, 13, 7, 20, 14, 27, 21, 15, 28, 22, 29, 23, 36, 30, 37, 31, 38, 45, 39, 46, 47, 54, 55, 63, 62, 61, 60, 53, 59, 52, 58, 51, 57, 44, 50, 56, 43, 49, 42, 48, 35, 41, 34, 40, 33, 26, 32, 25, 24, 17, 16, 8


dactr:	equ .
sintbl	equ $1000