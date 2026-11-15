---
name: «Построение графиков на ПК "Вектор"»
date: 1994-04
tags:
  - document
  - magazine
  - programming
authors:
  - filatov
---

Публикация из «Радиолюбитель» - 1994 - №4. - С.19.

О.ФИЛАТОВ, 220070, г.Минск

**ПОСТРОЕНИЕ ГРАФИКОВ НА ПК «ВЕКТОР»**

«Вектор-06Ц» позволяет выводить на экран монитора и принтер графики различных функций одной переменной.
Обладает широкими сервисными возможностями.

## Программа

Программа набрана со скана. Журнальный шрифт дает неоднозначности в отдельных знаках (`0`/`О`, `1`/`I`, `5`/`S`, `З`/`3`), поэтому явные ошибки распознавания исправлены по смыслу операторов Бейсика 2.5 (например, `PLOTS0` → `PLOT50`, `ВЕМ` → `REM`, `СОЗОВ` → `GOSUB`); странности оригинала сохранены как есть.
Строки 0 и 1 в оттиске начинаются с `RUN 20` и `RUN 32` - это прочтение по скану, проверенное увеличением.

```basic
0 RUN 20:REM*ПРОГРАММА ПОСТРОЕНИЯ ГРАФИ-
1 RUN 32:REM*КОВ. СОСТАВИЛ ФИЛАТОВ О.С.*
2 GOSUB 99:COLOR8:CLS:PLOT50,240:LINE6,2,BS:PRINT"МЕНЮ:":PRINT:PRINT
3 PRINT TAB(5)"З - ВЫВОД ЗНАЧЕНИЙ MIN И MAX ФУНКЦИИ"
4 PRINT TAB(5)"П - ПРОДОЛЖЕНИЕ РАБОТЫ"
5 PRINT TAB(5)"К - КОНЕЦ РАБОТЫ"
6 PRINT TAB(5)"Н - ЗАПУСК СНАЧАЛА"
7 PRINT TAB(5)"Ф - ВВОД НОВОЙ ФУНКЦИИ"
8 PRINT TAB(5)"Э - РЕЖИМ ВЫВОДА НА ЭКРАН":PRINT
9 PRINT TAB(5)"Т - ВЫБОР ТИПА ПРИНТЕРА"
10 PRINT TAB(5)"Р - РЕЖИМ ГРАФИКИ ПРИНТЕРА"
11 PRINT TAB(5)"Г - ВЫВОД ГРАФИКА НА ПРИНТЕР":PRINT
12 PRINT TAB(5)"Л - ВЫВОД ТАБЛИЦЫ ЗНАЧЕНИЙ F(X)"
13 PRINT TAB(9)"(ВЫХОД: F4,ЗАТЕМ ЛЮБАЯ КЛ.)":PRINT
14 PRINT TAB(5)"----------------------"
15 PRINT TAB(5)"ВК, ПРОБЕЛ - ВЫЗОВ МЕНЮ"
16 PRINT TAB(5)"ПОВТОРНОЕ НАЖАТИЕ - ВЫХОД ИЗ МЕНЮ"
17 GOSUB 100:GOSUB 76:IF A$="Ш" THEN CLS:GOSUB 95:GOTO 67
18 IF A$=" " OR AS=13 THEN CLS:GOSUB 95:GOTO 59
19 GOTO 62
20 CLS:COLOR7,0,0:GOSUB 95:GOSUB 92
21 SCREEN2,7:PLOT1,1:LINE9,254,BF:PLOT246,1:LINE254,254,BF:PLOT1,1:LINE254,9,BF:PLOT1,246:LINE254,254,BF
22 COLOR6:PLOT0,0:LINE255,255,B:PLOT10,10:LINE245,245,B:PLOT35,170:COLOR2
23 LINE5,5,6,BS:PRINT"ГРАФИК":PLOT35,45,2
24 LINE6,6,BS:PRINT"V 1.0":COLOR3
25 GOSUB 98:PLOT40,115,2:LINE4,4,BS:PRINT"******"
26 BEEP.2,0:PAUSE1:CLS
27 COLOR3:PLOT40,117,2:LINE1,3,BS:PRINT"БУДЕТЕ ВНОСИТЬ НОВУЮ ФУНКЦИЮ?":GOSUB 76:IF A$="Д" OR A$="D" THEN 31
28 IF A$<>"N" THEN 27
29 IF E=0 THEN 32
30 GOTO 34
31 CLS:COLOR7:PLOT10,220:LINE2,3,BS:PRINT"ПРОДОЛЖЕНИЕ -";:PLOT10,190:PRINT"GOTO 1":COLOR2:CUR0,10:EDIT 32
32 DEF FNY(X)=SIN(X)*SIN(X*.01)
33 N=255:E=1:DIM K(N)
34 CLS:COLOR2:PRINT TAB(5)"ВВЕДИТЕ ИНТЕРВАЛ ОТ 'A' ДО 'B':":CUR16,23:COLOR7:INPUT"",A,B
35 IF A>B THEN COLOR4:PRINT"'A' НЕ МОЖЕТ БЫТЬ БОЛЬШЕ, ЧЕМ 'B' !!!":PAUSE4:GOTO 34
36 IF A=B THEN COLOR4:PRINT"'A' НЕ МОЖЕТ БЫТЬ РАВНО 'B' !!":PAUSE4:GOTO 34
37 H=(B-A)/(N-1):Q=0
38 K(1)=FNY(A):MI=K(1):MA=MI:X=A
39 FOR I=1 TO N:IF X>-H AND X<H THEN Q=I
40 K(I)=FNY(X):X=X+H
41 IF K(I)>MA THEN MA=K(I)
42 IF K(I)<MI THEN MI=K(I)
43 NEXT:GOSUB 94:PRINT AT18,12"ВЫВОД"AT17,11"ГРАФИКА"
44 R=MA-MI:HX=1:HY=1
45 D=250/R:FOR I=0 TO N:K(I)=K(I)*D:NEXT
46 P=-MI*D:Y=P:Y1=Y:ST=3:COLOR4:CLS
47 IF P>250 THEN Y=250:HX=ST:HY=1
48 IF P<0 THEN Y=0:HX=ST:HY=1:Y1=0
49 IF A<0 AND B<0 THEN Q=255:HY=ST:HX=1
50 IF A>0 AND B>0 THEN Q=0:HY=ST:HX=1
51 IF A<0 AND B>0 THEN HY=1
52 IF HX=0 THEN HX=1
53 COLOR2:IF U=0 THEN FOR X=1 TO N:PLOTX,K(X)+P,1:NEXT:GOTO 55
54 FOR X=1 TO N:PLOTX,K(X)+P:LINEX,Y1:NEXT
55 COLOR4:FOR X=0 TO M STEP HX:PLOTX,Y1,1:NEXT
56 FOR Y=0 TO M STEP HY:PLOTQ,Y,1:NEXT
57 IF Q<3OR Q>252 AND Y1<3 OR Y1>252 THEN 59
58 LINE STEP-3,-3:PLOTQ,N:LINE STEP3,-3:PLOTN,Y1:LINE STEP-3,3:PLOTN,Y1:LINE STEP-3,-3
59 IF (PEEK(770) AND128)=0 THEN POKE770,128:ME=1:PAUSE1:GOTO 2
60 ME=0:GOSUB 76
61 IF A$=" " OR AS=13 THEN ME=1:GOTO 2
62 IF A$="Э" OR A$="\" THEN GOSUB 78:CLS:GOTO 53
63 IF A$="К" OR A$="K" THEN GOSUB 95:COLOR2:STOP
64 IF A$="Л" OR A$="L" THEN GOTO 73
65 IF A$="Т" OR A$="T" THEN GOSUB 88:CLS:GOTO 53
66 IF A$="Р" OR A$="R" THEN GOSUB 84:CLS:GOTO 53
67 IF A$="Г" OR A$="G" THEN GOSUB 102
68 IF A$="Н" OR A$="N" THEN RUN
69 IF A$="П" OR A$="P" THEN GOSUB 95:GOTO 27
70 IF A$="Ф" OR A$="F" THEN SCREEN2,15:CLS:GOSUB 95:GOTO 31
71 IF A$="З" OR A$="Z" THEN GOSUB 95:GOSUB 97
72 GOTO 59
73 IF ME=0 THEN GOSUB 99
74 CLS:GOSUB 99:GOSUB 101:COLOR8:X=A:FOR I=1 TO N:PRINT TAB(4)"F("X")="FNY(X):X=X+H:IF ASC(INKEY$)<>3 THEN NEXT
75 GOSUB 76:GOSUB 95:GOTO 60
76 A$=INKEY$:IF A$="" THEN 76
77 AS=ASC(A$):RETURN
78 GOSUB 94
79 PRINT AT11,12"Т - ВЫВОД ТОЧЕЧНЫЙ"AT11,11"Л - ВЫВОД ДИСКРЕТНЫЙ"
80 GOSUB 76:U=2:IF A$="Л" OR A$="D" THEN U=1
81 IF A$="Т" OR A$="T" THEN U=0
82 IF U=2 THEN 80
83 FOR I=11 TO 30:PRINT ATI,11+U" ";:PAUSE.05:NEXT:PAUSE1:GOTO 98
84 GOSUB 94
85 PRINT AT12,12"ГРАФИЧЕСКИЙ РЕЖИМ"AT15,11"НОМЕР : "
86 GOSUB 76:A=AS-48:IF A<0 OR A>7 THEN 86
87 PRINT AT23,11;A:GR=A:PAUSE1:GOTO 95
88 GOSUB 95:GOSUB 92:COLOR7:PLOT1,104:LINE254,155,BF:COLOR1:PLOT0,103:LINE255,156,B:COLOR5
89 PRINT AT10,13"ВЫБОР ТИПА ПРИНТЕРА:"AT5,12"0 - ТИП 'ROBOTRON-CM 6329'"AT5,11"1 - ТИП 'EPSON FX-85','RAVI-8010M'"
90 GOSUB 76:A=AS-48:IF A<0 OR A>1 THEN 90
91 FOR I=11 TO 38:PRINT ATI,11+A" ";:PAUSE.05:NEXT:SCREEN6,A:PAUSE1:GOTO 95
92 SCREEN3,&33,&CC,&33,&CC,&33,&CC,&33,&CC,
93 RETURN
94 GOSUB 95:GOSUB 92:COLOR7:PLOT50,104:LINE205,145,BF:COLOR1:PLOT49,103:LINE206,146,B:COLOR5:RETURN
95 IF ME=1 THEN CLS
96 SCREEN2,15:SCREEN0,0,0,197,34,197,6,22,173,152:GOSUB 100:RETURN
97 COLOR1:M$=" F(X)=":SCREEN2,1:PRINT AT0,24"MAX"M;MA;AT0,23"MIN"M;MI:RETURN
98 F=255:SCREEN3,F,F,F,F,F,F,F,F:RETURN
99 FOR I=0 TO 15:SCREEN0,I,0:NEXT:SCREEN2,8:RETURN
100 FOR I=8 TO 15:SCREEN0,I,173:NEXT:RETURN
101 FOR I=8 TO 15:SCREEN0,I,16:NEXT:RETURN
102 GOSUB 95:SCREEN7,GR:LPRINT:PRINT"ГРАФИЧЕСКИЙ РЕЖИМ"GR:LPRINT
103 IF ME=1 THEN 2
104 RETURN
```

## Примечания к расшифровке

- В строке 14 в оттиске напечатана линейка из дефисов; число дефисов не воспроизводится.
- В строке 21 координаты сохранены как в оттиске (`LINE9,254`, `LINE254,9`, `PLOT1,246`), хотя рисунок рамки по ним несимметричен - вероятна неточность журнального набора.
- В строках 55, 56, 58 используются имена `M`, `N`, `Y1`; значение `M` в тексте программы не присваивается (в оттиске именно `M`), `N` задано в строке 33.
- В строке 38 `MA=MI:X=A` - в журнальном шрифте `MI` и `X` легко спутать с другими знаками; прочтение проверено по смыслу (дальше используется `X`).
- В строке 39 `Q=I` прочитано по смыслу (в оттиске последний знак похож и на `1`) - `Q` задает положение оси ординат в пикселях.
- В строке 74 фрагмент `"F("X")="` набран в оттиске слитно и прочитан по смыслу оператора `PRINT`.
- Код клавиши хранится в числовой переменной `AS` (строки 77, 86, 90): именно она сравнивается с кодом 13 (ВК) в строках 18 и 61. Переменная `A` - граница интервала из строки 34, поэтому в строках 86 и 90 из `AS` получают `A` для проверки диапазона и вывода.
- В строке 91 первый предел цикла в оттиске читается неоднозначно (`FOR I=11 TO 38`).
