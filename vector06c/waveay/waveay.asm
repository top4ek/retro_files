;
;	Данная программа предназначена для проигрывания WAV-файлов компьютера
; IBM на ПК "Вектор-06Ц". В качестве звукового устройства используется	плата
; музыкального контроллера "Sound-Tracker" (м/с AY-3-8910).
;
;	Форматы проигрываемых файлов:
;		PCM, 8 бит, моно, 8000 Гц, (8 кГц), 7 кб/сек.
;		PCM, 8 бит, моно, 11025 Гц, (11 кГц) 10 кб/сек.
;
;	Автор будет признателен за предложения и замечания по этой программе.
;		Мой адрес:
;				313771, Украина, Харьковская обл.,
;					Балаклейский р-н, пос. Червоный Донец,
;						ул. Октябрьская 1-Б, кв. 20.
;				Демидов Станислав Владимирович.
;
	JMP	RUN
;
P8	SET	0015FH	; Пауза между полубайтами для 8000 Гц.
P11	SET	0010DH	; Пауза между полубайтами для 11025 Гц.
;
	DB	' Центр "Тень-День". Август, 1998 год. '
;
LOADT:	DB	01BH,05BH,01FH
	DB	'Загрузка файла...'
	DB	00AH,00DH
	DB	'$'
;
RUN:
;
; Проверка расширения у файла.
;
	LDA	00065H
	CPI	'W'
	JNZ	OPIS
	LDA	00066H
	CPI	'A'
	JNZ	OPIS
	LDA	00067H
	CPI	'V'
	JZ	NORMA
;
OPIS:
	MVI	A,'$'
	STA	IZ
;
	MVI	C,009H
	LXI	D,KOI8
	CALL	5
;
	MVI	C,009H
	LXI	D,PCM1
	CALL	5
;
	MVI	C,009H
	LXI	D,TEXTOP
	CALL	5
;
	RST	0
;
TEXTOP: DB 00AH,00DH,00AH,00DH
	DB '	Форматы проигрываемых файлов:'
	DB 00AH,00DH
	DB '		PCM, 8 бит, моно, 8000 Гц, (8 кГц), 7 кб/сек.'
	DB 00AH,00DH
	DB '		PCM, 8 бит, моно, 11025 Гц, (11 кГц) 10 кб/сек.'
	DB 00AH,00DH,00AH,00DH
	DB '	Формат командной строки: WAVEAY имя файла.WAV'
	DB	00AH,00DH
	DB	'$'
;
KOI8:	DB	01BH,05BH,'$'
;
; Очистка буфера.
;
NORMA:
	LXI	H,0005CH+13
	CALL	CLSBUF
;
	MVI	C,9
	LXI	D,LOADT
	CALL	5
;
; Загрузка файла.
;
	MVI	C,032H
	LXI	D,ADSC
	CALL	00005H
;
	ANA	A
	CZ	IZKON
;
; Проверь - 8 бит, да или нет.
;
	LDA	DATA+022H
	CPI	008H
	JNZ	NOFORMAT
;
; Поиск начала файла.
;
	LXI	H,DATA+1
ISK2:
	DCX	H
ISK1:
	MOV	A,H
	ANA	A
	JM	NOFORMAT
;
	MVI	A,'d'
	CMP	M
	INX	H
	JNZ	ISK1
;
	MVI	A,'a'
	CMP	M
	INX	H
	JNZ	ISK2
;
	MVI	A,'t'
	CMP	M
	INX	H
	JNZ	ISK2
;
	MVI	A,'a'
	CMP	M
	INX	H
	JNZ	ISK2
;
	DCX	H
;
; Устанавливаем конец файла.
;
	XCHG
	LHLD	DATA+4
	SHLD	TEMP1	; Адрес конца файла.
	XCHG
	SHLD	TEMP2	; Адрес начала файла.
;
; Определяем файл - моно или стерео.
; Если стерео - выход из программы.
;
	LDA	DATA+016H
	CPI	1
	JNZ	NOFORMAT	; Выход, файл стерео.
;
;	Определяем формат файла.
;	Работаем только с форматами:
;		PCM, 8 бит, моно, 8000 Гц, (8 кГц), 7 кб/сек.
;		PCM, 8 бит, моно, 11025 Гц, (11 кГц) 10 кб/сек.
;
	LHLD	DATA+018H
;
	MOV	A,L
	CPI	040H
	JNZ	GO1
	MOV	A,H
	CPI	01FH
	JZ	PCM8	; Переход, формат: 8000 Гц.
GO1:
	MOV	A,L
	CPI	011H
	JNZ	NOFORMAT
	MOV	A,H
	CPI	02BH
	JNZ	NOFORMAT	; Формат не обрабатывается.
;
; Установка паузы для формата:
;		PCM, 8 бит, моно, 11025 Гц, (11 кГц) 10 кб/сек.
;
	MVI	C,009H
	LXI	D,PCM1
	CALL	5	; Выв. сообщ.
;
	CALL	PNAME
;
	MVI	C,009H
	LXI	D,PCM3
	CALL	5	; Выв. сообщ.
;
	MVI	C,009H
	LXI	D,PCM4
	CALL	5	; Выв. сообщ.
;
	LXI	B,P11
	JMP	PORT
;
PCM1:	DB	01FH,00AH,00DH
	DB	'Утилита проигрывания WAV-файлов. Версия 1.0.'
	DB	00AH,00DH
	DB	'	(С) Центр "Тень".  Август, 1998 год.'
IZ:	DB	00AH,00DH,00AH,00DH
	DB	'Проигрывается файл: '
	DB	'$'
PCM2:
	DB	00AH,00DH
	DB	'	Формат: PCM, 8 бит, моно, 8000 Гц. (7 кб/сек.).'
	DB	00AH,00DH
	DB	'$'
PCM3:
	DB	00AH,00DH
	DB	'	Формат: PCM, 8 бит, моно, 11025 Гц. (10 кб/сек.).'
	DB	00AH,00DH
	DB	'$'
PCM4:
	DB	00AH,00DH
	DB	'	Идет проигрывание через м/с AY-3-8910 (4 бита)...'
	DB	00AH,00DH
	DB	'$'
;
TEMP1:	DS	2	; Адрес конца WAV файла.
TEMP2:	DS	2	; Адрес начала WAV файла.
;
; Установка паузы для формата:
;		PCM, 8 бит, моно, 8000 Гц, (8 кГц), 7 кб/сек.
;
PCM8:
	MVI	C,009H
	LXI	D,PCM1
	CALL	5
;
	CALL	PNAME
;
	MVI	C,009H
	LXI	D,PCM2
	CALL	5
;
	MVI	C,009H
	LXI	D,PCM4
	CALL	5
;
	LXI	B,P8	; Пауза.
PORT:
	DI
;
; Настройка AY-3-8910.
;
SS:	MVI	A,007H
	OUT	015H
	MVI	A,11111111B
	OUT	014H
;
	LHLD	TEMP1
	XCHG
	LHLD	TEMP2
;
	LDA	BOL
	ANA	A
	JNZ	KANALB
;
	LHLD	KADDR
	XCHG
	LHLD	TEMP2
;
; Воспроизведение через м/с AY-3-8910.
;
KANALB:
	MVI	A,009H
	OUT	015H	; Выбираем канал B.
;
FON1:
	INX	H
	MOV	A,M
	RRC
	RRC
	RRC
	RRC
	ANI	00001111B
	OUT	014H		; Выдаем в AY, только старший полубайт.
;
; Пауза, привязка к таймеру (ВИ53).
; Таймер тактируется частотой 1.5 мГц.
;
	MVI	A,00110100B
	OUT	008H
;
	MOV	A,C
	OUT	00BH
	MOV	A,B
	OUT	00BH
;
	MVI	A,00000100B
	OUT	008H
PAUSE1:
	IN	00BH
	ANA	A
	JNZ	PAUSE1
;
; Опрос клавиши "УС", если нажата - выход в ДОС.
;
	IN	001H
	ANI	01000000B
	JZ	EXIT		; Проигрывание прервано по клавиши "УС".
;
; Проверяем, весь файл проигран.
;
	MOV	A,H
	CMP	D
	JNZ	FON1
;
	MOV	A,L
	CMP	E
	JNZ	FON1
;
; Все !!!
;
EXIT:	RST	0
;
; Выв. сообщ.: данный формат не обрабатывается.
;
NOFORMAT:
	MVI	C,009H
	LXI	D,NTEXT
	CALL	5
;
	RST	0
;
NTEXT:	DB	01FH,00AH,00DH
	DB	'Данный формат не обрабатывается !'
	DB	00AH,00DH
	DB	'$'
;
; Данные для загрузки WAV файла.
;
ADSC:	DB	129
	DW	EXDSC
EXDSC:	DB	0
	DW	0005CH
ADREND: DW	DATA		; Начальный адрес загрузки.
KADDR:	DW	0B000H		; Конечный адрес загрузки.
;
; П/п вывода имени файла на экран.
;
PNAME:
	LXI	H,0005DH
	MVI	B,008H
PR1:
	MOV	E,M
	MVI	A,' '
	CMP	E
	JZ	SPACE
;
	PUSH	H
	PUSH	B
	MVI	C,002H
	CALL	5
	POP	B
	POP	H
;
	INR	L
	DCR	B
	JNZ	PR1
;
SPACE:
	MVI	E,'.'
	MVI	C,002H
	CALL	5
;
	LXI	H,0005DH+8
;
	REPT	3
	PUSH	H
	MOV	E,M
	MVI	C,002H
	CALL	5
	POP	H
	INR	L
	ENDM
;
	RET
;
; Очистка буфера.
;
CLSBUF:
	MVI	A,23
PURGE:	MVI	M,0
	INX	H
	DCR	A
	JNZ	PURGE
	RET
;
IZKON:
	XRA	A
	STA	BOL
	RET
;
BOL:	DB	0FFH
;
DATA:
	END
