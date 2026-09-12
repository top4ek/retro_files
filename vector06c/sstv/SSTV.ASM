                ORG 1F00H
LF		EQU	0AH
ESC:		EQU	1BH
BASE:		EQU	120H
@INIT:		EQU	BASE
@KEY:		EQU	BASE+3
@INTAP:		EQU	BASE+6
@CONOUT: 	EQU	BASE+9
@OUTAP:		EQU	BASE+12
@LIST:		EQU	BASE+15
@CONIN:  	EQU	BASE+18
@DUMP:	 	EQU	BASE+21
@SPIC:		EQU	BASE+24
@INKEY:		EQU	BASE+27
@PLOT:		EQU	BASE+30
@LINE:		EQU	BASE+33
@CIRCLE:	EQU	BASE+36
@PCIRCLE:	EQU	BASE+39
@GET: 		EQU	BASE+42
@PUT:		EQU	BASE+45
@PAINT:		EQU	BASE+48
@PGET:		EQU	BASE+51
@COLOR:		EQU	BASE+54
@FON:		EQU	BASE+57
@BORD:		EQU	BASE+60
@SCROL:		EQU	BASE+63
@PLAY:		EQU	BASE+66
@FPLAY:		EQU	BASE+69
@PLOFF:		EQU	BASE+72
@TIME:		EQU	BASE+75
@MASC:		EQU	BASE+78
@EADD:		EQU	BASE+81
@ESUB:		EQU	BASE+84
@MULT:		EQU	BASE+87
@EDIVM:		EQU	BASE+90
@ESIGN:		EQU	BASE+93
@DECBIN:	EQU	BASE+96
@BINDEC:	EQU	BASE+99
@CMPHD:		EQU	BASE+102
@SCOLOR:	EQU	BASE+105
@SPLAN:		EQU	BASE+108
@SCONR:		EQU	BASE+111
@SLIST:		EQU	BASE+114
@LSCR:		EQU	BASE+117
 		LXI SP,7000H
		LXI D,OO                  
 		CALL @SCOLOR
		MVI A,255
		CALL @SCROL
		MVI A,15 
		LXI H,CLS
		CALL @SPIC
		CALL @SPLAN
                MVI A,6
		CALL @COLOR 
		MVI A,2

		MVI C,0
		MVI B,0 
		CALL @PLOT
		MVI A,2
		MVI C,255
		MVI B,255
		CALL @LINE
                XRA A   
		CALL @COLOR
		MVI A,2
		MVI C,4
		MVI B,4
		CALL @PLOT
		MVI A,2
		MVI C,251
		MVI B,251
		CALL @LINE
		MVI A,6
		CALL @COLOR

		MVI A,2
		MVI C,5
		MOV B,C
		CALL @PLOT
		MVI A,1
                MVI C,134
                MVI B,134
		CALL @LINE

		MVI A,2 
                MVI C,137
		MVI B,5
		CALL @PLOT
		MVI A,1
		MVI C,250 
                MVI B,134
		CALL @LINE
		MVI A,2
		MVI C,5
                MVI B,136
		CALL @PLOT
		MVI A,1
		MVI C,250
		MVI B,250
		CALL @LINE
PUT:		MVI A,1
		LXI H,6000H
                LXI B,150
		LXI D,40
		CALL @PUT
                LXI D,COL
		CALL @SCOLOR
		MVI A,0

		CALL @BORD
		CALL @FON
                MVI A,7
                CALL @COLOR
                MVI A,2
                MVI C,118
                MVI B,210
                CALL @PLOT
                MVI C,142 
                MVI B,226
                MVI A,1
                CALL @LINE
                MVI A,2
                MVI C,150
                MVI B,210
                CALL @PLOT
                MVI C,174
                MVI B,226
                MVI A,1     
                CALL @LINE
                MVI A,2
                MVI C,182
                MVI B,210
                CALL @PLOT
                MVI A,1
                MVI C,206
                MVI B,226
                CALL @LINE
                MVI A,2
                MVI C,214
                MVI B,210
                CALL @PLOT
                MVI A,1
                MVI C,238
                MVI B,226
                CALL @LINE
                MVI A,2
                CALL @COLOR
                MVI A,2

                MVI C,120
                MVI B,212
                CALL @PLOT
                MVI C,140 
                MVI B,224
                CALL @LINE
                MVI A,3
                CALL @COLOR
                MVI A,2
                MVI C,152
                MVI B,212
                CALL @PLOT
                MVI C,172
                MVI B,224
                CALL @LINE
                MVI A,1
                CALL @COLOR
                MVI A,2
                MVI C,184
                MVI B,212
                CALL @PLOT
                MVI C,204
                MVI B,224
                CALL @LINE
                MVI A,10
                CALL @COLOR
                MVI C,117
                MVI B,209
                MVI A,1
                CALL KW
                MVI A,2
                STA 13H
                MVI A,1
		CALL @COLOR

		LXI H,T5
		CALL @SPIC
		MVI A,7
		CALL @COLOR
		MVI A,2
		MVI C,12
		MVI B,226 
		CALL @PLOT
		CALL TM1
		MVI C,12
		MVI B,224
		CALL @PLOT
		CALL TM1
		MVI C,14
		MVI B,226
		CALL @PLOT
		CALL TM1
		MVI C,14
		MVI B,224
		CALL @PLOT
		CALL TM1
		MVI C,12
		MVI B,212
		CALL @PLOT
		CALL TM2
		MVI B,210
		MVI C,12
		CALL @PLOT
		CALL TM2
		MVI C,14    
  		MVI B,210
		CALL @PLOT
		CALL TM2
		MVI B,212
		MVI C,14
		CALL @PLOT
		CALL TM2
		MVI A,2
		MVI C,24
		MVI B,174
		CALL @PLOT
		CALL TM3
		MVI A,2
		MVI C,24
		MVI B,172
		CALL @PLOT
		CALL TM3
		MVI A,2
		MVI C,26
		MVI B,172

		CALL @PLOT
		CALL TM3
                MVI A,2		
		MVI C,26
		MVI B,174
		CALL @PLOT
		CALL TM3
		MVI A,2
		MVI C,19
		MVI B,151
		CALL @PLOT
 		CALL TM4
		MVI C,19
		MVI B,149
		CALL @PLOT
		CALL TM4
		MVI C,21
		MVI B,149
		CALL @PLOT
		CALL TM4
		MVI C,21
		MVI B,151
		CALL @PLOT
		CALL TM4
		JMP M3
TM1:		MVI A,3
		MVI C,2
		MVI B,1
		CALL @LINE
		LXI H,T1
		CALL @SPIC
		RET
TM2:		MVI A,3
		MVI C,2
		MVI B,1
		CALL @LINE
		LXI H,T2
		CALL @SPIC
		RET
TM3:		MVI A,3
		MVI C,3
		MVI B,3
		CALL @LINE
		LXI H,T3
		CALL @SPIC
		RET
TM4:		MVI A,3
		MVI C,2
		MVI B,1
		CALL @LINE
		LXI H,T4
		CALL @SPIC
		RET
M3:		MVI A,0
		CALL @COLOR
		MVI A,2
		MVI B,150
		MVI C,20
		CALL @PLOT
		CALL TM4
		MVI A,2
		MVI B,173
		MVI C,25
		CALL @PLOT
		CALL TM3
		MVI A,2
		MVI B,211
		MVI C,13
		CALL @PLOT
		CALL TM2
		MVI A,0
		MVI B,225
		MVI C,13
		CALL @PLOT
		CALL TM1
		JMP N2
M1:             NOP        
OO:		DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
COL:            DB 0,225,255,87,62,134,56,63,0,197,22,192,2,152,82,173
CLS:		DB 1FH,0 
T1:		DB 'SLOW',0
T2:		DB 'SCAN',0
T3:		DB 'TV',0
T4:		DB 'EDITOR',0
T5:             DB 1BH,59H,20H+22,20H+26,'PIONEER SOFT',0 
T6:             DB 1BH,59H,20H+8,20H+26,'YES  NO',0
T7:             DB 1BH,59H,20H+6,20H+23,'RESET PICTURE',0
T8:		DB 1BH,59H,20H+6,20H+26,'LOAD',0
T9:		DB 1BH,59H,20H+8,20H+26,'SAVE',0
HELPTXT:	DB 1BH,59H,20H+5,20H+21,'CONTROL KEYS',0
HELPTXT1:	DB 1BH,59H,20H+1,20H+20,' 1    2     3    4 ',0
MUZ1B:		DB 'L32O2CD-D',00H
MUZ1D:		DB 'L32O3DD-C',00H
MUZ1H:		DB 'L32O5CD-D',00H
MUZH2:          DB 'L32O6CDCDCD',0
MUZD2:          DB 'L32O5DCDCDC',0
MUZB2:          DB 'L32O4CDCDCD',0
MUZLUP:		DB 'L4O3PPPFGACD8GG2EFGEDC',0
HELPXY:		DB 220,160,228,168,230,160,238,168,220,170,228,178
		DB 210,160,218,168,123,160,135,168,137,160,180,168
		DB 182,160,194,168,121,170,109,178,210,180,218,188
		DB 230,180,238,188
STX:		DB 0
STY:		DB 0
NWX:		DB 0
NWY:		DB 0
N2:		NOP    
		NOP
		NOP
		NOP
                MVI A,7
                CALL @SPLAN
		MVI A,6
		CALL @COLOR
		MVI B,40
                MVI C,150
		CALL KW 
		MVI H,32
		MVI L,24
INKEY:		CALL @INKEY
		CPI 08
		JZ LEWO1
		CPI 24
		JZ PRAWO1
		CPI 26 
		JZ NIZ1
		CPI 25  
		JZ WERH1
		CPI 32
		JZ PROB
                CPI 49
                CZ KLAW1
                CPI 50
                CZ KLAW2
                CPI 51
                CZ KLAW3
                CPI 52
                CZ KLAW4
		CPI 27
		JZ HELP
		JMP INKEY
PROB:		MVI A,0
		CALL KW
		NOP
		MOV A,B  
		CPI 40
		JZ KW1
		CPI 64
		JZ KW2
		CPI 88
		JZ KW3
KW1:		MOV A,C
                CPI 150
		JZ KW7
                CPI 182
		JZ KW8
                CPI 214
		JZ KW9
KW2:            MOV A,C 
                CPI 150
		JZ KW10
                CPI 182
		JZ KW11
                CPI 214
		JZ KW12
KW3:		MOV A,C
                CPI 150
		JZ KW13
                CPI 182
		JZ KW14
                CPI 214
		JZ KW15
KW7:		JMP TCHK 
KW8:            JMP CIRCLE
KW9:		JMP MAG		
KW10:           JMP PAINT
KW11:           JMP KWADRA
KW12:           JMP REZIN
KW13:           JMP LUPA
KW14:		JMP REDTXT
KW15:           JMP REZ

REDTXT:		NOP
		MVI B,115
		MVI C,9
		MVI A,1
		CALL KIDCUR
REDCC:		IN 1      
	 	ANI 20H
 		JNZ REDKEY
		CALL @INKEY
		CPI 33
		CZ KLAW1
		CPI 34
		CZ KLAW2
		CPI 35
		CZ KLAW3
		CPI 36
		CZ KLAW4
		JMP REDCC
REDKEY:		IN 1
		ANI 20H
		JZ REDCC
		CALL @INKEY
		CPI 25
		JZ REDUP
		CPI 26
		JZ REDDOWN
		CPI 8
		JZ REDLEFT
		CPI 24
		JZ REDRIGHT
		CPI 3
		JZ F1     
		CPI 32
		JZ REDPRO
		CPI 0FFH
		JZ REDKEY
		PUSH B  
		PUSH PSW
 		MVI A,3
		CALL @SPLAN
		LDA 13H 
		CALL @COLOR
		MVI A,2
		CALL @PLOT
		INR A  
		MVI B,2
		MOV C,B
		CALL @LINE
		POP PSW
		MOV C,A
		CALL @CONOUT
REDM1:  	POP B
		XRA A
		CALL KIDCUR
		MOV A,C
		CPI 111
		JNZ REDM2
		JMP REDM3 
REDM2:		ADI 17
		MOV C,A
REDM3:		MVI A,1
		CALL KIDCUR
		JMP REDKEY

REDPRO:		XRA A  
		CALL @COLOR
		ADI 3
		CALL @SPLAN
		INR A
		CALL @PLOT
		PUSH B
		MOV A,B
		ADI 16 
		MOV B,A
		MOV A,C
		ADI 16
		MOV C,A
		MVI A,2 
		CALL @LINE
		JMP REDM1

REDUP:		XRA A
		CALL KIDCUR
		MOV A,B
		CPI 115
		JZ REDKEY2
		ADI 18
		MOV B,A
		JMP REDKEY2
REDDOWN:	XRA A
		CALL KIDCUR
		MOV A,B
		CPI 7
		JZ REDKEY2
		SUI 18
		MOV B,A
		JMP REDKEY2
REDRIGHT:	XRA A
		CALL KIDCUR
		MOV A,C
		CPI 111
		JZ REDKEY2
		ADI 17
		MOV C,A
		JMP REDKEY2
REDLEFT:	XRA A
		CALL KIDCUR
		MOV A,C
		CPI 9
		JZ REDKEY2
		SUI 17
		MOV C,A
		JMP REDKEY2
REDKEY2:	MVI A,1
		CALL KIDCUR
		JMP REDKEY


MUZ4:           LXI D,MUZD2
                LXI B,MUZB2
                LXI H,MUZH2
                CALL @PLAY
                RET
KLAW1:
          PUSH B  
                PUSH D
                PUSH H
                PUSH PSW
                CALL MUZ4
                CALL STERW  
                MVI A,2
                STA 13H
                MVI A,1
                MVI C,117
                MVI B,209
                CALL KW
                POP PSW
                POP H
                POP D
                POP B
                RET      
KLAW2:          PUSH B
                PUSH D
                PUSH H
                PUSH PSW
                CALL MUZ4
                CALL STERW
                MVI A,3
                STA 13H
                MVI A,1
                MVI C,149
                MVI B,209
                CALL KW 
                POP PSW
                POP H
                POP D
                POP B
                RET        
KLAW3:          PUSH B
                PUSH D
                PUSH H
                PUSH PSW
                CALL MUZ4
                CALL STERW
                MVI A,1
                STA 13H
                MVI C,181
                MVI B,209
                CALL KW
                POP PSW
                POP H
                POP D
                POP B
                RET      
KLAW4:          PUSH B
                PUSH D
                PUSH H
                PUSH PSW
                CALL MUZ4
                CALL STERW
                MVI A,0
                STA 13H
                MVI A,1
                MVI C,213
                MVI B,209
                CALL KW
                POP PSW
                POP H
                POP D
                POP B
                RET      
STERW:          MVI A,15
                CALL @SPLAN
                MVI A,6
                CALL @COLOR
                MVI A,0
                MVI C,117
                MVI B,209
                CALL KW   
                MVI C,149
                MVI B,209
                CALL KW   
                MVI C,181
                MVI B,209
                CALL KW   
                MVI C,213
                MVI B,209
                CALL KW   
                RET
LEWO1:		CALL MUZ1
		MVI A,0
		CALL KW
		MOV A,C
		SUB H
		MOV C,A
                CPI 150
		CC LEWO3
		MVI A,1
		CALL KW
		JMP INKEY
PRAWO1:		CALL MUZ1
		MVI A,0
		CALL KW
		MOV A,C
		ADD H
		MOV C,A
                CPI 150+96
		CNC PRAWO3
		MVI A,1
		CALL KW
		JMP INKEY
NIZ1:		CALL MUZ1
		MVI A,0
		CALL KW
		MOV A,B
		SUB L
		MOV B,A
		CPI 40
		CC NIZ3
		MVI A,1
		CALL KW
		JMP INKEY
WERH1:		CALL MUZ1
		MVI A,0
		CALL KW
		MOV A,B
		ADD L
		MOV B,A
		CPI 40+72
		CNC WERH3
		MVI A,1
		CALL KW
		JMP INKEY
LEWO3:		MOV A,C
		ADD H
		MOV C,A
		RET
PRAWO3:		MOV A,C
		SUB H
		MOV C,A
		RET
NIZ3:		MOV A,B
		ADD L
		MOV B,A
		RET
WERH3:		MOV A,B
		SUB L
		MOV B,A
		RET
MUZ1:		PUSH PSW
		PUSH B
		PUSH D
		PUSH H
		LXI B,MUZ1B
		LXI D,MUZ1D
		LXI H,MUZ1H
		CALL @PLAY
		POP H
		POP D 
		POP B
		POP PSW
		RET
PAINT:		MVI A,7
		CALL @SPLAN
		MVI A,2
		CALL @COLOR
		MVI B,170
		MVI C,130
		MVI A,1
		CALL @PLOT
		CALL PAINTLIN
		MVI D,4
PAINT23:	MOV A,C
		ADI 20
		MOV C,A
		MVI A,1
		CALL @PLOT
		CALL PAINTLIN
		DCR D
		JNZ PAINT23
		MVI C,135
		MVI B,175
		CALL PAINT56
		MVI C,155
		MVI B,172
		CALL PAINT56
		MVI C,172
		MVI B,175
		CALL PAINT56
		MVI C,192
		MVI B,172
		CALL PAINT56
		MVI C,212
		MVI B,172
		MVI A,2
		CALL @PLOT
		MVI C,218
		MVI B,178
		CALL @LINE
		LXI H,135
		LXI D,175
		MVI A,9
		CALL @CIRCLE
PAINTKEY:	CALL @INKEY
		CPI 24
		JZ PAINTRIGHT
		CPI 8
		JZ PAINTLEFT
		CPI 32
		JZ PAINT48
		CPI 3
		JZ PAINTN2
		JMP PAINTKEY
PAINTN2:	CALL CLSKW
		JMP N2
PAINT48:	PUSH H
		CALL CLSKW
		CALL KARAN
		XRA A
		CALL CUR
		MVI A,7
		CALL @SPLAN
		LDA 13H
		CALL @COLOR
		MOV D,A
		MVI A,2
		CALL @PLOT
		CALL @PGET
		MOV E,A
		POP H
		MOV A,L
		MOV H,C
		MOV L,B
		CPI 135
		JZ PAINT81
		CPI 155
		JZ PAINT82
		CPI 175
		JZ PAINT83
		CPI 195
		JZ PAINT84
		CPI 215
		JZ PAINT85
PAINTRIGHT:	CALL PAINTCLS
		CALL PAINTMUZ
		MOV A,L
		CPI 215
		JZ PAINTRIGHT1
		ADI 20
		MOV L,A
		CALL PAINTCIRC
		JMP PAINTKEY
PAINTRIGHT1:	LXI H,135
		CALL PAINTCIRC
		JMP PAINTKEY
PAINTLEFT:	CALL PAINTCLS
		CALL PAINTMUZ
		MOV A,L
		CPI 135
		JZ PAINTLEFT1
		SUI 20
		MOV L,A
		CALL PAINTCIRC
		JMP PAINTKEY
PAINTLEFT1:	LXI H,215
		CALL PAINTCIRC
		JMP PAINTKEY
PAINTCIRC:	MVI A,9
		CALL @CIRCLE
		RET
PAINTCLS:	PUSH H
		PUSH D
		PUSH B
		MVI A,0
		CALL @COLOR
		LXI H,135
		CALL PAINTCIRC
		MVI C,4
PAINTCLC1:	MOV A,L
		ADI 20
		MOV L,A
		CALL PAINTCIRC
		DCR C
		JNZ PAINTCLC1
		MVI A,2
		CALL @COLOR
		POP B
		POP D
		POP H
		RET
PAINTMUZ:	PUSH H
		PUSH D
		PUSH B
		LXI H,0
		LXI D,0
		LXI B,MUZ1D
		CALL @PLAY
		POP B
		POP D
		POP H
		RET

PAINT56:	MVI A,1
		CALL @PLOT
		MOV A,C
		ADI 3
		MOV C,A
		MOV A,B
		ADI 3
		MOV B,A
		MVI A,2
		CALL @LINE
		RET
PAINT85:        NOP
		MVI A,04
		STA PAINT1
		MVI A,0CH
		STA PAINT4
		CALL PAINT0
		MOV B,L
		MOV C,H
		MVI A,0CH
		STA PAINT1
		MVI A,04
		STA PAINT4
		CALL PAINT0
		MOV B,L
		MOV C,H
		MVI A,05
		STA PAINT1
		MVI A,0CH
		STA PAINT4
		CALL PAINT0
		MOV B,L
		MOV C,H
		MVI A,0CH
		STA PAINT1
		MVI A,05
		STA PAINT4
		CALL PAINT0
		MOV B,L
		MOV C,H
		MVI A,5
		STA PAINT1
		MVI A,0DH
		STA PAINT4
		CALL PAINT0
		MOV C,H
		MOV B,L
		MVI A,0DH
		STA PAINT1
		MVI A,5
		STA PAINT4
		CALL PAINT0
		MOV B,L
		MOV C,H
		MVI A,4
		STA PAINT1
		MVI A,0DH
		STA PAINT4
		CALL PAINT0
		MOV C,H
		MOV B,L
		MVI A,0DH
		STA PAINT1
		MVI A,4
		STA PAINT4
		CALL PAINT0
		JMP PAINT
PAINT81:	MVI A,4
		STA PAINT1
		MVI A,0CH
		STA PAINT4
		CALL PAINT0
		MOV C,H
		MOV B,L
		MVI A,0CH
		STA PAINT1
		MVI A,4
		STA PAINT4
		CALL PAINT0
		JMP PAINT
PAINT82:	MVI A,5H
		STA PAINT1
		MVI A,0CH
		STA PAINT4
		CALL PAINT0
		MOV C,H
		MOV B,L
		MVI A,0CH
		STA PAINT1
		MVI A,5H
		STA PAINT4
		CALL PAINT0
		JMP PAINT
PAINT83:	MVI A,4
		STA PAINT1
		MVI A,0DH
		STA PAINT4
		CALL PAINT0
		MOV C,H
		MOV B,L
		MVI A,0DH
		STA PAINT1
		MVI A,4
		STA PAINT4
		CALL PAINT0
		JMP PAINT
PAINT84:	MVI A,0DH
		STA PAINT1
		MVI A,5
		STA PAINT4
		CALL PAINT0
		MOV C,H
		MOV B,L
		MVI A,5
		STA PAINT1
		MVI A,0DH
		STA PAINT4
		CALL PAINT0
		JMP PAINT
PAINT0:		PUSH B
		MVI A,1
		CALL @PLOT
PAINT1:		INR B
		MVI A,2
		CALL @PLOT
		CALL @PGET
		CMP D
		JZ PAINT8
		SUB E
		JNZ PAINT2
PAINT8:		MVI A,1
		CALL @PLOT
		JMP PAINT1
PAINT2:		POP B
PAINT4:		INR C
		PUSH B
		MVI A,2
		CALL @PLOT
		CALL @PGET
		CMP D
		JZ PAINT9
		SUB E
		JNZ PAINT3
PAINT9:		MVI A,1
		CALL @PLOT
                JMP PAINT1
PAINT3:		POP B
		RET
PAINTLIN:	PUSH B
		MOV A,B
		ADI 10
		MOV B,A
		MOV A,C
		ADI 10
		MOV C,A
		MVI A,1
		CALL @LINE
		POP B
		RET
TCHK:		CALL KARAN
M44:            XRA A  
		CALL CUR
		MOV A,B
		STA STY
		STA NWY
		MOV A,C

		STA STX
		STA NWX
		MVI A,3
		STA 22H
		CALL KEY
		CALL LORP  
                XRA A  
		STA 22H
		MVI A,1
		CALL CUR
		CALL KEY
		JMP M44
LORP:		PUSH B
                MVI A,0100B
                CALL @SPLAN
                MVI A,4 
		CALL @COLOR
		LDA STY
		MOV B,A
		LDA STX
		MOV C,A
		MVI A,0
		CALL @PLOT
		POP B
		XRA A
		CALL @LINE
		NOP
		PUSH B
		NOP      
		MVI A,0011B
		CALL @SPLAN
                LDA 13H
		CALL @COLOR
		LDA STY
		MOV B,A
		LDA STX
		MOV C,A
		MVI A,1
		CALL @PLOT
		POP B   
		MVI A,0
		CALL @LINE
		RET
LUPA:           MVI A,4
                CALL @SPLAN
                CALL @COLOR
                MVI D,8
                MVI B,50
                MOV C,B
                MVI A,1
                CALL @PLOT
                MVI B,50+32
                MVI C,50+32
                CALL @LINE
                MVI A,50
                STA STY
                STA STX
                ADI 32
                STA NWY
                STA NWX
                MVI A,6
                STA 22H
LUPA133:        CALL KEY
		MVI A,0
		CALL @COLOR
		MVI A,2
		MVI C,5
		MOV B,C
		CALL @PLOT
		MVI A,1
		MVI B,134
		MOV C,B
		CALL @LINE
		LXI H,MUZLUP
		LXI D,0
		LXI B,0
		CALL @PLAY
                MVI A,4
                CALL @SPLAN
                LDA STY
                MOV B,A
                LDA STX
                MOV C,A
                XRA A
                CALL @PLOT
                LDA NWX
                MOV C,A
                LDA NWY
                MOV B,A
                MVI A,1
                CALL @LINE
                MVI A,3
                CALL @SPLAN
                MVI B,6

                MOV C,B
                MVI A,2
                CALL @PLOT
                MVI B,128
                MVI C,128
                LXI D,4500H
                LXI H,6500H
                CALL @GET
                MVI A,3
                CALL @SPLAN
                LXI H,4000H
                MVI D,32
                MOV E,D
                LDA STY

                MOV B,A
                LDA STX
                MOV C,A
PGET1:          MVI A,2
                CALL @PLOT
                CALL @PGET
                MOV M,A
                INX H
                INR C
                DCR D
                JNZ PGET1
                MVI D,32
                INR B
                LDA STX
                MOV C,A
                DCR E
                JNZ PGET1
                MVI A,3
                CALL @SPLAN
                XRA A
                CALL @COLOR
                MVI B,6
                MOV C,B
                MVI A,2
                CALL @PLOT
                MVI C,133
                MOV B,C
                MVI A,2
                CALL @LINE
                MVI D,32

                MOV E,D
                LXI H,4000H
                MVI B,6
LUP7:           MVI C,6
LUP5:           MOV A,M
                CALL @COLOR
                MVI A,1
                CALL KIDR
                INX H
                MOV A,C
                ADI 4
                MOV C,A
                DCR D
                JNZ LUP5
                MOV A,B
                ADI 4
                MOV B,A
                MVI D,32
                DCR E
                JNZ LUP7
                MVI B,5
                MOV C,B
                MVI A,1
                CALL KIDCUR
LUPAKEY:        IN 1
		ANI 20H
		JZ LUPCC
		CALL @INKEY
                CPI 25
                JZ LUPUP
                CPI 26
                JZ LUPDOWN
                CPI 24
                JZ LUPRIGHT
                CPI 8
                JZ LUPLEFT
                CPI 3
                JZ LUPF4
                CPI 32
                CZ LUPPROB1
                CPI 49
                CZ KLAW1
                CPI 50
                CZ KLAW2
                CPI 51
                CZ KLAW3
                CPI 52
                CZ KLAW4
                JMP LUPAKEY
LUPCC:		IN 1
		ANI 20H
 		JNZ LUPAKEY
 		CALL LUPPROB1
		CALL @INKEY
		CPI 25
		JZ LUPUP
		CPI 26
		JZ LUPDOWN
		CPI 24
		JZ LUPRIGHT
		CPI 8
		JZ LUPLEFT   
		JMP LUPCC  

LUPUP:          MOV A,B
                CPI 129
                JZ LUPAKEY
                XRA A
                CALL KIDCUR 
                MOV A,B
                ADI 4
                MOV B,A
                MVI A,1
                CALL KIDCUR 
                JMP LUPAKEY
LUPDOWN:        MOV A,B
                CPI 5
                JZ LUPAKEY
                XRA A
                CALL KIDCUR 
                MOV A,B
                SUI 4
                MOV B,A
                MVI A,1
                CALL KIDCUR 
                JMP LUPAKEY
LUPRIGHT:       MOV A,C
                CPI 129
                JZ LUPAKEY
                XRA A
                CALL KIDCUR 
                MOV A,C
                ADI 4
                MOV C,A
                MVI A,1
                CALL KIDCUR 
                JMP LUPAKEY
LUPLEFT:        MOV A,C
                CPI 5
                JZ LUPAKEY
                XRA A
                CALL KIDCUR 
                MOV A,C
                SUI 4
                MOV C,A
                MVI A,1
                CALL KIDCUR 
                JMP LUPAKEY
LUPF4:          JMP LUPAEND
LUPPROB1:       LDA 13H
                CALL @COLOR
                MVI A,3
                CALL @SPLAN
                INR C
                INR B
                MVI A,1
                CALL KIDR
                DCR C
                DCR B
                RET
LUPAEND:        XRA A  
		CALL KIDCUR
		MVI A,3
                CALL @SPLAN
                MVI D,32
                MOV E,D
                LXI H,4000H
                MVI B,6
LUP8:           MVI C,6
LUP9:           MVI A,2
                CALL @PLOT
                CALL @PGET
                MOV M,A
                INX H
                MOV A,C
                ADI 4
                MOV C,A
                DCR D
                JNZ LUP9
                MOV A,B
                ADI 4
                MOV B,A
                MVI D,32
                DCR E
                JNZ LUP8
                LXI B,6
                LXI D,6
                LXI H,4500H
                MVI A,2
                CALL @PUT
                LXI H,4000H
                MVI D,32
                MOV E,D
                LDA STY
                MOV B,A
LUP14:          LDA STX
                MOV C,A
LUP13:          MOV A,M
                CALL @COLOR
                MVI A,1
                CALL @PLOT
                INX H
                INR C
                DCR D
                JNZ LUP13
                MVI D,32
                INR B
                DCR E
                JNZ LUP14
		MVI A,4
		CALL @COLOR
		CALL @SPLAN
		LDA STX
		MOV C,A
		LDA STY 
		MOV B,A
		MVI A,2
		CALL @PLOT
		LDA NWX
		MOV C,A
		LDA NWY
		MOV B,A
		MVI A,1
		CALL @LINE
		MVI D,8
		MVI A,6
		PUSH B
		CALL @COLOR
		MVI A,2
		MVI B,5
		MOV C,B
		CALL @PLOT
		DCR A
		MVI C,134
		MOV B,C
		CALL @LINE
		POP B
                JMP LUPA133

KIDCUR:         PUSH B
                PUSH PSW
                MVI A,4
                CALL @SPLAN
                CALL @COLOR
	        POP PSW
                CALL @PLOT
                MVI A,1
                MOV A,C
                ADI 4
                MOV C,A
                MOV A,B
                ADI 4
                MOV B,A
                MVI A,1
                CALL @LINE
                POP B
                RET
KIDR:           INR C
                CALL @PLOT
                INR C
                CALL @PLOT
                INR B
                CALL @PLOT
                INR B
                CALL @PLOT
                DCR C
                CALL @PLOT
                DCR C
                CALL @PLOT
                DCR B
                CALL @PLOT
                INR C
                CALL @PLOT
                DCR B
                DCR C
                CALL @PLOT
                RET
KWADRA:         MVI A,4
                CALL @SPLAN
                CALL @COLOR
                MVI D,8
                MVI B,50
                MVI C,50
                MVI A,1
                CALL @PLOT
                MVI B,55
                MVI C,55
                CALL @LINE
                MVI A,50
                STA STX
                STA STY
                ADI 5
                STA NWX
                STA NWY

                MVI A,8
                STA 22H
                CALL KEY
                MVI A,4
                CALL @SPLAN
                CALL @COLOR
                LDA STX
                MOV C,A
                LDA STY
                MOV B,A
                XRA A
                CALL @PLOT
                LDA NWX
                MOV C,A
                LDA NWY
                MOV B,A
                MVI A,1
                CALL @LINE
                MVI A,3
                CALL @SPLAN
                LDA 13H
                CALL @COLOR
                LDA STX
                MOV C,A
                LDA STY
                MOV B,A
                MVI A,1
                CALL @PLOT
                LDA NWX
                MOV C,A
                LDA NWY
                MOV B,A
                MVI A,1
                CALL @LINE
                JMP N2
REZ:            MVI A,4
                CALL @SPLAN
                CALL @COLOR
                MVI D,8
                MVI B,30
                MOV C,B
                MVI A,1
                CALL @PLOT
                MVI B,37
                MOV C,B
                CALL @LINE
                MVI A,30
                STA STY
                STA STX
                ADI 7
                STA NWY
                STA NWX
                MVI A,8
                STA 22H
REZ1:           CALL KEY
                MVI A,3
                CALL @SPLAN
                LDA 13H
                CALL @COLOR
                LDA STX
                MOV C,A
                LDA STY
                MOV B,A
                MVI A,1
                CALL @PLOT
                LDA NWX
                MOV C,A
                LDA NWY
                MOV B,A
                MVI A,2
                CALL @LINE
                JMP REZ1
KW:             NOP
		PUSH PSW
		PUSH B
		DCR B
		DCR C

		CALL @PLOT
		MOV A,B
		ADI 20
		MOV B,A
		MOV A,C
		ADI 28
		MOV C,A
		MVI A,1
		CALL @LINE
		POP B
		POP PSW
		RET
CIRCLE:         MVI A,4
                CALL @SPLAN
                CALL @COLOR
                LXI H,60
                LXI D,60
                MVI A,60
                STA STY
                STA STX
                MOV B,A
                MOV C,A
                MVI A,5
                STA 22H
                MVI A,2
                STA 12H
                CALL @CIRCLE
                MVI D,8
                CALL KEY
CIRCUST:        MVI A,4
                CALL @SPLAN
                MVI A,0
                CALL @COLOR
                LDA STX
                MOV L,A
                LDA STY
                MOV E,A
                MVI H,0
                MOV D,H
                LDA 12H
                CALL @CIRCLE
                MVI A,3
                CALL @SPLAN
                LDA 13H
                CALL @COLOR
                LDA 12H
                CALL @CIRCLE
                JMP N2
CIRC:           MVI A,4
                CALL @SPLAN
                MVI A,0
                CALL @COLOR
                MOV A,D
                STA 6H
                LDA STX
                MOV L,A
                LDA STY
                MOV E,A
                MVI H,0
                MOV D,H
                LDA 12H
                CALL @CIRCLE
                MVI A,4
                CALL @COLOR
                POP B
                LDA 12H
                MOV H,A
                MOV A,B
                SUB H
                CPI 5
                JC CIRCN
                JZ CIRCN
                MOV A,B
                ADD H
                CPI 134
                JNC CIRCW
                MOV A,C
                SUB H
                CPI 8
                JC CIRCP
                JZ CIRCP
                MOV A,C
                ADD H
                CPI 128
                JNC CIRCL
CIRC1:          MOV L,C
                MOV E,B
                MVI H,0
                MOV D,H
                LDA 12H

                CALL @CIRCLE
                MOV A,L
                STA STX
                MOV A,E
                STA STY
                LDA 6H
                MOV D,A
                POP PSW
                RET
CIRCN:          LDA 6H
                ADD B
                MOV B,A
                JMP CIRC1
CIRCW:          LDA 6H
                MOV H,A
                MOV A,B
                SUB H
                MOV B,A
                JMP CIRC1
CIRCP:          LDA 6H
                ADD C
                MOV C,A
                JMP CIRC1
CIRCL:          LDA 6H
                MOV H,A
                MOV A,C
                SUB H
                MOV C,A
                JMP CIRC1
CIRC5:          CALL @INKEY
                CPI 25
                CZ  UPCIRC
                CPI 26
                CZ  DOWNCIRC
                CPI 9
                JZ KLTAB
                CPI 32
                JZ PROBCIRC
                CPI 49
                CZ KLAW1
                CPI 50
                CZ KLAW2
                CPI 51
                CZ KLAW3
                CPI 52
                CZ KLAW4
                CPI 3
                JZ F1
                JMP CIRC5
UPCIRC:         CALL RADCLS
                LDA 12H
                INR A
                STA 12H
                JMP RADNAR
DOWNCIRC:       CALL RADCLS
                LDA 12H
                DCR A
                STA 12H
                JMP RADNAR
KLTAB:          MVI D,8
                JMP KEY
PROBCIRC:       JMP CIRCUST
RADCLS:         MVI A,4
                CALL @SPLAN
                MVI A,0
                CALL @COLOR
                LDA STX
                MOV L,A
                LDA STY
                MOV E,A
                MVI H,0
                MOV D,H
                LDA 12H
                CALL @CIRCLE
                RET
RADNAR:         MVI A,4
                CALL @COLOR
                LDA STX
                MOV L,A
                LDA STY
                MOV E,A
                LDA 12H
                MOV D,A
                MOV A,E
                SUB D
                CPI 5
                JC RADN
                JZ RADN
                MOV A,E
                ADD D
                CPI 134

                JNC RADW
                MOV A,L
                SUB D
                CPI 8
                JC RADP
                JZ RADP
                MOV A,L
                ADD D
                CPI 128
                JNC RADL
RADNAR3:        MVI H,0
                MOV D,H

                LDA 12H
                CALL @CIRCLE
                JMP CIRC5
RADN:           DCR D
                MOV A,D
                STA 12H
                JMP RADNAR3
RADW:           DCR D
                MOV A,D
                STA 12H
                JMP RADNAR3
RADP:           DCR D
                MOV A,D
                STA 12H
                JMP RADNAR3
RADL:           DCR D
                MOV A,D
                STA 12H
                JMP RADNAR3
KARAN:          MVI A,1
                STA 22H
                MVI B,30
		MVI C,30
                MVI A,1
		MVI D,8
		CALL CUR
KEY:		CALL @INKEY
		CPI 0FFH
		JZ KEY
		CPI 00
		JZ KEY
		CPI 25
		JZ WWERH
		CPI 26
		JZ WNIZ
		CPI 08
		JZ WLEWO
		CPI 24
		JZ WPRAWO
		CPI 10
		CZ PC
		CPI 03
		JZ F1
		CPI 32
		JZ PROBEL
                CPI 49
                CZ KLAW1
                CPI 50
                CZ KLAW2
                CPI 51
                CZ KLAW3
                CPI 52
                CZ KLAW4
                CPI 09
                JZ TAB
		JMP KEY
PC:		MOV A,D
		CPI 8
		JZ PC1
		MOV A,D
		CPI 1
		JZ PC8
PC8:		MVI D,8
		RET     
PC1:		MVI D,1
		RET    
F1:             NOP
                MVI A,4
                CALL @SPLAN
                XRA A
                CALL @COLOR
                MVI B,6
                MOV C,B
                CALL @PLOT
                MVI C,133
                MOV B,C
                MVI A,2
                CALL @LINE
		MVI A,1111B
		CALL @SPLAN
		JMP N2
TAB:            LDA 22H
                CPI 4
                JZ TAB1  
                LDA 22H
                CPI 8
                JZ TAB1
                CPI 5
                JZ CIRC5
                JMP KEY
TAB1:           LDA 22H
                CPI 8
                JZ TAB2
                LDA 22H
                CPI 4
                MVI A,8
                STA 22H
                JMP KEY
TAB2:           MVI A,4
                STA 22H
                JMP KEY
PROBEL:		RET
WWERH: 		MVI A,0
		CALL CUR
		MOV A,B
		ADD D
		MOV B,A
                CPI 134
		CNC WER
		MVI A,1
		CALL CUR
		JMP KEY
WER:		MOV A,B
		SUB D
		MOV B,A
		RET 
WNIZ: 		MVI A,0
		CALL CUR
		MOV A,B
		SUB D
		MOV B,A

                CPI 5  
                CC NIZ  
                CZ NIZ  
                CM NIZ
		MVI A,1
		CALL CUR
		JMP KEY
NIZ:		MOV A,B
		ADD D
		MOV B,A
		RET
WPRAWO: 	MVI A,0
		CALL CUR
 		MOV A,C
		ADD D
		MOV C,A
                CPI 129
		CNC PRAW
		MVI A,1
		CALL CUR
		JMP KEY
PRAW:		MOV A,C
		SUB D
		MOV C,A
		RET
WLEWO: 		MVI A,0
              	CALL CUR
		MOV A,C
		SUB D
		MOV C,A
                CPI 8  
		CC LEW  
		CZ LEW
		MVI A,1
		CALL CUR
		JMP KEY
LEW:		MOV A,C
		ADD D
		MOV C,A
		RET
K1:		PUSH PSW
		MVI A,4 
		CALL @COLOR
                MVI A,0100B
		CALL @SPLAN
		POP PSW
		CALL @PLOT
		DCR B
		CALL @PLOT
		DCR B
		CALL @PLOT
		DCR B
		CALL @PLOT
		DCR B
		CALL @PLOT
		INR C
		CALL @PLOT
		INR B
		CALL @PLOT
		INR B
		INR C
		CALL @PLOT
		INR B
		INR C
		CALL @PLOT   
		INR C
		CALL @PLOT
		INR B
		CALL @PLOT
   		DCR C
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR C
		CALL @PLOT

		DCR C
		CALL @PLOT
		MVI A,0011B
		CALL @SPLAN
		RET
K2:		PUSH PSW
		MVI A,4 
 		CALL @COLOR
                MVI A,0100B
		CALL @SPLAN
		POP PSW
		CALL @PLOT
   		INR C
		CALL @PLOT
		INR C
		CALL @PLOT
		INR C
		CALL @PLOT
		INR C
		CALL @PLOT
		INR B
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR C
		INR B
		CALL @PLOT
		DCR C
		INR B
		CALL @PLOT
		INR B
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR B
		CALL @PLOT
		DCR B
		CALL @PLOT
		DCR B
		CALL @PLOT
		DCR B
		MVI A,0011B
		CALL @SPLAN
		RET
K3:		PUSH PSW
		MVI A,4 
		CALL @COLOR
                MVI A,0100B
		CALL @SPLAN
		POP PSW
		CALL @PLOT
		INR B
		CALL @PLOT
		INR B
		CALL @PLOT
		INR B
		CALL @PLOT
		INR B
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR B
		CALL @PLOT
		DCR C
		DCR B
		CALL @PLOT
		DCR C
 		DCR B
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR B
		CALL @PLOT
		INR C
		CALL @PLOT
		INR C
		CALL @PLOT
		INR C
		CALL @PLOT
		INR C
		MVI A,0011B
		CALL @SPLAN
		RET
K4:		PUSH PSW
		MVI A,4 
		CALL @COLOR
                MVI A,0100B
		CALL @SPLAN
		POP PSW
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR C
		CALL @PLOT
		DCR B
		CALL @PLOT
		INR C
		CALL @PLOT
		DCR B
		INR C
		CALL @PLOT
		DCR B
		INR C
		CALL @PLOT
		DCR B
		CALL @PLOT
  		INR C
		CALL @PLOT
		INR B
		CALL @PLOT
		INR B

		CALL @PLOT
		INR B
		CALL @PLOT
		INR B
		MVI A,0011B
		CALL @SPLAN
		RET
CUR:		PUSH PSW
		PUSH B
		LDA 22H
		CPI 3
		JZ LINE1
                CPI 4

                JZ PREAM
                CPI 8
                JZ PEKWA
                CPI 6
                JZ PEKWA
                CPI 5
                JZ CIRC
		MOV A,C
		CPI 71
		JNC KUR2
		MOV A,B
		CPI 71
		JNC KUR4
		POP B
		POP PSW
		CALL K2
		RET
KUR2:		MOV A,B
		CPI 71
		JNC KUR3
		POP B
		POP PSW
		CALL K3
		RET
KUR3:		POP B  
		POP PSW
		CALL K4
		RET
KUR4:		POP B
		POP PSW
		CALL K1
		RET
LINE1:          MVI A,0100B
      		CALL @SPLAN
      		LDA STY
		MOV B,A
		LDA STX
		MOV C,A
		MVI A,0
		CALL @PLOT
		LDA NWY
		MOV B,A
		LDA NWX
		MOV C,A
		MVI A,0
		CALL @LINE
                LDA STX
		MOV C,A
		LDA STY
		MOV B,A
		MVI A,1
		CALL @PLOT
		POP B
		MVI A,0
		CALL @LINE
		MOV A,C
		STA NWX
		MOV A,B
		STA NWY
		POP PSW
		MVI A,0011
		CALL @SPLAN
		RET
PREAM:          MVI A,0100B
                CALL @SPLAN
                CALL @COLOR
                LDA STY
                MOV B,A
                LDA STX
                MOV C,A
                XRA A
                CALL @PLOT
                LDA NWY
                MOV B,A
                LDA NWX
                MOV C,A
                MVI A,1
                CALL @LINE
                LDA STX
                MOV C,A
                LDA STY
                MOV B,A
                MVI A,1
                CALL @PLOT
                POP B
                MVI A,1
                CALL @LINE
                MOV A,C
                STA NWX
                MOV A,B
                STA NWY
                POP PSW
                MVI A,3
                CALL @SPLAN
                RET

PEKWA:          MVI A,0100B
                CALL @SPLAN
                CALL @COLOR
                LDA STX
                MOV C,A
                LDA STY
                MOV B,A
                MVI A,0
                CALL @PLOT
                LDA NWX
                MOV C,A
                LDA NWY
                MOV B,A
                MVI A,1
                CALL @LINE
                POP B
                PUSH B
                LDA NWY
                SUB B
                MOV B,A
                JP NER1
                LDA NWX
                SUB C 
                MOV C,A
                JP NER2
                LDA STX
                SUB C
                MOV C,A
                LDA STY
                SUB B
                MOV B,A
                JMP NERW
NER2:           LDA STX
                SUB C
                MOV C,A
                LDA STY
                SUB B
                MOV B,A
                JMP NERW
NER1:           LDA NWX
                SUB C
                MOV C,A
                JP NER3
                LDA STX
                SUB C
                MOV C,A
                LDA STY
                SUB B
                MOV B,A
                JMP NERW
NER3:           LDA STX
                SUB C
                MOV C,A
                LDA STY
                SUB B

                MOV B,A
NERW:           NOP
                MOV A,C
                CPI 8
                JC KENGL
                JZ KENGL
                MOV A,C
                CPI 134
                JNC KENGP
                MOV A,C
KENGL1:         STA STX
                MOV A,B
                CPI 5
                JC KENGN
                JZ KENGN
                MOV A,B
                CPI 129
                JNC KENGW
                MOV A,B
KENGN1:         STA STY
                MVI A,1
                CALL @PLOT
                POP B
KENG:           MVI A,1
                CALL @LINE
                MOV A,B
                STA NWY
                MOV A,C
                STA NWX
                MVI A,3
                CALL @SPLAN
                POP PSW
                RET
KENGL:          MOV A,C
                ADD D
                MOV C,A
                STA STX
                MVI A,1
                CALL @PLOT
                POP B
                MOV A,C
                ADD D
                MOV C,A
                JMP KENG
KENGN:          MOV A,B
                ADD D

                MOV B,A
                STA STY
                MVI A,1
                CALL @PLOT
                POP B

                MOV A,B
                ADD D
                MOV B,A
                JMP KENG
KENGP:          MOV A,C
                SUB D
                MOV C,A
                STA STX
                MVI A,1
                CALL @PLOT
                POP B
                MOV A,C
                SUB D
                MOV C,A
                JMP KENG
KENGW:          MOV A,B
                SUB D
                MOV B,A
                STA STY
                MVI A,1
                CALL @PLOT
                POP B
                MOV A,B
                SUB D
                MOV B,A
                JMP KENG
REZIN:		NOP
		MVI A,7							
		CALL @SPLAN
		CALL CLSKW
                MVI A,2
                CALL @COLOR
		MVI A,3
		STA 7FDH
		LXI H,T7               
		CALL @SPIC               
		LXI H,T6
		CALL @SPIC
 		CALL GOL
		MVI A,0B6H
		OUT 8
		LXI H,0
NEGER:		MOV A,L
	        OUT 9
		MOV A,H
		CPI 155
		JZ PAR
		OUT 9
		INX H
		JMP NEGER
PAR:		MVI A,0B6H
		OUT 8
 	        MVI A,0
                CALL @COLOR
                MVI A,2
                MVI C,6
                MVI B,6
                CALL @PLOT
                MVI C,133
                MOV B,C
                MVI A,2
                CALL @LINE
GOLNO:		CALL CLSKW
                JMP N2
CLSKW:          MVI A,0
                CALL @COLOR
                MVI A,2
                MVI C,123
                MVI B,203
                CALL @PLOT

                MVI A,2
                MVI C,246
                MVI B,158
                CALL @LINE
                RET
GOL:		MVI B,163
		MVI C,155
		MVI A,1
		CALL @PLOT
		CALL GOL4
GOL111:		CALL @INKEY
		CPI 24
		JZ GOL22
		CPI 32
		RZ
		JMP GOL111
GOL2:		MVI B,163
		MVI C,182
		MVI A,1
		CALL @PLOT
		CALL GOL4
GOL222:		CALL @INKEY
		CPI 8
		JZ GOL11 
		CPI 32
		JZ GOLNO
		JMP GOL222
GOL11:		XRA A 
		CALL @PLOT
		CALL GOL4
		LXI B,MUZ1D
		LXI D,0
		LXI H,0
		CALL @PLAY
		JMP GOL
GOL22:		XRA A
		CALL @PLOT
		CALL GOL4
		LXI B,MUZ1D
		LXI D,0
		LXI H,0
		CALL @PLAY
		JMP GOL2
GOL4:		PUSH B

		MOV A,B
		ADI 12
		MOV B,A
		MOV A,C
		ADI 22
		MOV C,A
		MVI A,1
		CALL @LINE
		POP B
		RET
HELP:		XRA A
		CALL KW
		MVI A,2
		CALL @COLOR
		MVI A,3
		STA 7FDH
		LXI H,HELPTXT
		CALL @SPIC
		LXI H,HELPTXT1
		CALL @SPIC
		MVI D,1
		CALL HELP2
HELP4:		CALL @KEY
		CPI 0FFH
		JZ HELP3
		JMP HELP4
HELP3:		MVI D,0
		CALL HELP2
		MVI A,0
		CALL @COLOR
		LXI H,HELPTXT
		CALL @SPIC
		LXI H,HELPTXT1
		CALL @SPIC
		JMP N2
HELP2:		MVI E,10
		LXI H,HELPXY
HELP5:		MOV A,M
		MOV C,A
		INX H
		MOV A,M
		ADI 5
		MOV B,A
		INX H
		MOV A,D
		CALL @PLOT
		MOV A,M
		MOV C,A
		INX H
		MOV A,M
		ADI 5
		MOV B,A
		INX H
		MVI A,1
		CALL @LINE
		DCR E
		JNZ HELP5
		RET

MAG:		NOP  
		CALL CLSKW
		MVI A,2
		CALL @COLOR
		MVI C,140
		MVI B,158
		MVI A,1
		CALL @PLOT
		MVI C,200
		MVI B,200
		MVI A,1
		CALL @LINE
		MVI A,3
		STA 7FDH
		LXI H,T9
		CALL @SPIC
		LXI H,T8
		CALL @SPIC

LOG1:		MVI B,182
		MVI C,153
		MVI A,1
		CALL @PLOT
		CALL LOG4
LOG33:		CALL @INKEY
		CPI 26
		JZ LOG2
		CPI 32
		JZ LOG8
		JMP LOG33
LOG55:		MVI B,162
		MVI C,153
		MVI A,1
		CALL @PLOT
		CALL LOG4
LOG66:		CALL @INKEY
		CPI 25
		JZ LOG3
		CPI 32
		JZ LOG8
		JMP LOG66
LOG2:		XRA A
		MVI B,182
		MVI C,153
		CALL @PLOT
		CALL LOG4
		LXI H,MUZ1D
		LXI B,0
		LXI D,0
		CALL @PLAY
		JMP LOG55
LOG3:		XRA A
		MVI B,162
		MVI C,153
		CALL @PLOT
		CALL LOG4
		LXI H,MUZ1D
		LXI B,0
		LXI D,0
		CALL @PLAY
		JMP LOG1
LOG4:		PUSH B
		MOV A,B
		ADI 14
		MOV B,A
		MOV A,C
		ADI 33
		MOV C,A
		MVI A,1
		CALL @LINE
		POP B
		RET
LOG8:		CALL CLSKW
		JMP N2
                LXI H,8106H
		CALL OUT1 	
		LXI H,0A106H
		CALL OUT1
		JMP N2

OUT1:		LXI D,126 
		MVI A,15 
OUT3:		MVI B,129
OUT2:		MOV C,M
		CALL @OUTAP
		INX H
		DCR B
		JNZ OUT2 
 		DAD D
		DCR A
		JNZ OUT3
		RET    


     




