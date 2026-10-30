; ROM-DUMPER
; @Тимошенко Александр (Tim0xA)
; 2009-10-20
; использована процедура выгрузки файла в формате ROM из "Байт" №8
	.ORG	8000H
	MVI	A,88H
	OUT	0
	MVI	A,0C9H
	STA	38H
	DI
; ожидание нажатия клавиши РУС
KEY:	IN	01
	ANI	80H
	JNZ	KEY
; поехали...
ZAP:	LXI	H,SHAPKA
	LXI	SP,9300H
	PUSH	B
	PUSH	D
	PUSH	H
	MVI	E,0
	MVI	B,1BH	; 27
ZAP1:	MOV	A,M
	ADD	E
	MOV	E,A
	INX	H
	DCR	B
	JNZ	ZAP1
	MOV	B,M
	INX	H
	ADD	M
	MOV	E,A
	MOV	C,M
	INX	H
	MOV	D,M
	MOV	A,B
	ADD	D
	DCX	H
	DCX	H
	MOV	M,A
	ADD	E
	STA	M1
; преамбула
	MVI	H,4
; 25 нулей
ZAP4:	MVI	L,19H
ZAP2:	XRA	A
	CALL	BYTE
	DCR	L
	JNZ	ZAP2
; 25 кодов 55H
	MVI	L,19H
ZAP3:	MVI	A,55H
	CALL	BYTE
	DCR	L
	JNZ	ZAP3
	DCR	H
	JNZ	ZAP4
	POP	H
; вывод блоков
	;PUSH	B
	MOV	D,B
	MVI	E,0
ZAP5:	MVI	B,80H		; счетчик подблоков
	CALL	BLOK
	MVI	E,0
	MVI	B,88H
	CALL	BLOK
	INR	D
	DCR	C		; счетчик блоков
	JNZ	ZAP5
	;POP	B
; вывод данных завершен
;	EI
ZAP6:	JMP	ZAP6
;  вывод блока
BLOK:	PUSH	B
	PUSH	H
	PUSH	D
	MVI	D,10H		; 16 нулей
	XRA	A
	CALL	NBYTE
	MVI	D,4		; 4 байта 55H
	MVI	A,55H
	CALL	NBYTE
	MVI	A,0E6H		; 1 байт E6H
	CALL	BYTE
	XRA	A		; 4 нуля
	MVI	D,4
	CALL	NBYTE
	MVI	D,1DH		; 30 байт заголовка блока
BLOK1:	MOV	A,M
	CALL	BYTE
	INX	H
	DCR	D
	JNZ	BLOK1
	MOV	A,C		;
	CALL	BYTE
	LDA	M1
	ADD	C
	CALL	BYTE
	STA	M2
	POP	D
	MVI	H,8
BLOK3:	MVI	L,20H
	PUSH	D
	XRA	A
	MVI	D,4
	CALL	NBYTE
	POP	D
	MVI	A,0E6H
	CALL	BYTE
	LDA	M2
	ADD	B
	MOV	C,A
	MOV	A,B
	CALL	BYTE
	LDA	M2
	CALL	BYTE
BLOK2:	LDAX	D
	INR	E
	CALL	BYTE
	ADD	C
	MOV	C,A
	DCR	L
	JNZ	BLOK2
	MOV	A,C
	CALL	BYTE
	INR	B
	DCR	H
	JNZ	BLOK3
	POP	H
	POP	B
	RET
; вывод нескольких байтов
NBYTE:	CALL	BYTE
	DCR	D
	JNZ	NBYTE
	RET
; вывод байта
BYTE:	PUSH	B
	PUSH	D
	PUSH	PSW
	MOV	D,A
	;MVI	A,0
	;ANI	0EH
	;MOV	E,A
	MVI	C,8
BYTE1:	MOV	A,D
	RLC
	MOV	D,A
	MVI	A,1
	XRA	D
	ANI	01
	;ORA	E
	OUT	1
	CALL	ZAD
	MVI	A,0
	XRA	D
	ANI	1
	;ORA	E
	OUT	1
	CALL	ZAD
	DCR	C
	JNZ	BYTE1
	POP	PSW
	POP	D
	POP	B
	RET
; задержка
ZAD:	PUSH	PSW
	LDA	CONZAP
	MOV	B,A
	POP	PSW
ZAD1:	DCR	B
	JNZ	ZAD1
	RET
; данные
SHAPKA:	.DB	"NODISC00030591COPYV4 COM",0		; 25 байт
	.DB	00H,00H,00H,08H,00H
;		         |   |   |
;		         |   |   +---- смещение в блоках
;		         |   |
;		         |   +-------- число блоков
;		         |
;		         +------------ начальный блок
M1:	.DB	0
M2:	.DB	0
CONZAP:	.DB	30H
	.END
