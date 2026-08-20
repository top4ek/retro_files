Всем любителям Vectora посвящается!

;-------------------------------------------------------
; SPEAD  FORMAT UTILITY  09/11/1993
; помните что исходник содержит самомодифицируемый код
; компиляется M80
.8080
        ASEG
        ORG     100h
;
INCLUDE         DEFINE ;  ну это ясно
;
WORK            EQU     1000h           ; TRACK INFO здесь формируется траск
FAT_TABLE       EQU     WORK+1200h      ; FAT TABLE
MAP_BAD         EQU     WORK+3000h      ; MAP OF BAD SECTORS
MAP_BAD_BLOCK   EQU     MAP_BAD+3000h   ; MAP OF BAD BLOCKS
;
;       READ_AREA       EQU     3000h
STACK           SET     KON+256 ; зарезервировали место под стек
SECOND          EQU     WORK+51Eh+4BEh+4BEh+4Fh-1
THIRD           EQU     WORK+51Eh+4Fh-1
FOURTH          EQU     WORK+51Eh+4BEh+4BEh+4BEh+4Fh-1
FIVETH          EQU     WORK+51Eh+4BEh+4Fh-1
;
START:
        LDA     DMA ; проверяем запустили с параметрами
        ORA     A
        JZ      _QUIT
        LDA     DMA+2
        CPI     'A'
        JZ      MAIN
        CPI     'B'
        JZ      DRIVE_B
;
_QUIT:
        LXI     D,COPYWRITE ; без параметров
QUIT:
        CALL    OUTINFO
        RST     0
;
DRIVE_B:
        MVI     A,00110101b     ; 35h устанавливаем диск B
        STA     MOTORON+1
;
MAIN:
        LXI     SP,KON+128
        MVI     B,5
        LXI     H,DMA+3
MAIN_1:
        MOV     A,M       ; разгребаем коммандную строчку
        CPI     '/'
        INX     H
        JZ      MAIN_2
        DCR     B
        JNZ     MAIN_1
        JMP     FORMAT
;
PUT_RET:
        MVI     A,0C9h  ; RET а это модифицируем код
        STA     READ
        JMP     FORMAT
;
MAIN_2:
        MVI     B,5
MAIN_22:
        MOV     A,M
        CPI     'U'
        JZ      PUT_RET
        INX     H
        DCR     B
        JNZ     MAIN_22
;
FORMAT:
        LXI     H,MAP_BAD ; ну все поехали!
        SHLD    MAP_POS+1
        LXI     H,0             ; INIT ALL VAR
        SHLD    ERR_COUNT
        SHLD    TR_ERR
        MOV     A,H
        STA     SIDE_ERR
        STA     SEC_ERR
        STA     TRK_LOW+1
        STA     TRK_HIGH+1
        DCR     A
        STA     _SYS_AREA+1
;
        MVI     C,05h    ; NUMBERS OF SECTORS
        LXI     H,WORK
;
        MVI     A,4Eh    ; формируем в памяти траск
        MVI     E,50h
        CALL    PUT_BYTE
        XRA     A
        MVI     E,0Ch
        CALL    PUT_BYTE
        MVI     A,0F6h
        MVI     E,03h
        CALL    PUT_BYTE
        MVI     A,0FCh
        MVI     E,01h
        CALL    PUT_BYTE
;       50h+0Ch+03h+01h=60h - #96
MAIN1:
        MVI     A,4Eh
        MVI     E,14h
        CALL    PUT_BYTE
        MVI     A,4Eh
        MVI     E,14h
        CALL    PUT_BYTE
        MVI     A,4Eh
        MVI     E,14h
        CALL    PUT_BYTE
        XRA     A
        MVI     E,0Ch
        CALL    PUT_BYTE
        MVI     A,0F5h
        MVI     E,03h
        CALL    PUT_BYTE
        MVI     A,0FEh
        MVI     E,01h
        CALL    PUT_BYTE
;       TRACK              60h+14h+14h+14h+0Ch+03h+01h=0ACh - #172
        XRA     A
        MVI     E,1h             ; 0ADh
        CALL    PUT_BYTE
;       SIDE
        XRA     A
        MVI     E,1h            ; 0AEh
        CALL    PUT_BYTE
;       SECTOR
        MVI     A,01h
        MVI     E,01h           ; 0AFh
        CALL    PUT_BYTE
;       LONG   SECTOR
        MVI     A,3      ; 1024 bytes
        MVI     E,01h           ; 0B0h
        CALL    PUT_BYTE
        MVI     A,0F7h
        MVI     E,01h           ; 0B1h
        CALL    PUT_BYTE
        MVI     A,4Eh
        MVI     E,16h           ; C7h
        CALL    PUT_BYTE
        XRA     A
        MVI     E,0Ch           ; D3h
        CALL    PUT_BYTE
        MVI     A,0F5h
        MVI     E,03h           ; D6h
        CALL    PUT_BYTE
        MVI     A,0FBh
        MVI     E,01h           ; D7h
        CALL    PUT_BYTE
        MVI     A,0E5h
        LXI     D,1024          ; 4D7h
        CALL    PUTBYTE
        MVI     A,0F7h
        MVI     E,01h           ; 4D8h
        CALL    PUT_BYTE
        MVI     A,4Eh
        MVI     E,14h           ; 4ECh
        CALL    PUT_BYTE
        MVI     A,4Eh
        MVI     E,14h           ; 500h
        CALL    PUT_BYTE
        MVI     A,4Eh
        MVI     E,1Eh           ; 51Eh
        CALL    PUT_BYTE
        DCR     C
        JNZ     MAIN1
;
        MVI     A,4Eh
        LXI     D,05DEh
        CALL    PUTBYTE
;
        MVI     A,02h
        STA     SECOND
        INR     A       ;       MVI     A,03h
        STA     THIRD
        INR     A       ;       MVI     A,04h
        STA     FOURTH
        INR     A       ;       MVI     A,05h
        STA     FIVETH

;       COMPLITE  FORMIR TRACK

        LXI     D,WARN  ; ну все пишем на диск
        CALL    OUTINFO
        MVI     C,06h   ; WAIT PRESS ANY KEY
        MVI     E,0FDh
        CALL    BDOS
;
        CALL    MOTORON
        CALL    SET_TR0 ; установили траск 0
        LXI     D,FORM
        CALL    OUTINFO
;
FTR1:
        CALL    FTRACK
        MVI     A,1
FTR2:
        PUSH    PSW     ;  проверяем что потом записали
        OUT     FDC_SE  ; SET SECTOR
;       LXI     D,READ_AREA
        CALL    READ    ; READ SECTOR
        POP     PSW
        INR     A
        CPI     6
        JNZ     FTR2
;
        LDA     WORK+0ADh  ; SIDE  ; меняем сторону
        XRI     1               ; CHANGE SIDE
        STA     WORK+0ADh  ; SIDE
        STA     WORK+51Eh+4Eh-1
        STA     WORK+51Eh+4BEh+4Eh-1
        STA     WORK+51Eh+4BEh+4BEh+4Eh-1
        STA     WORK+51Eh+4BEh+4BEh+4BEh+4Eh-1
;
        CALL    CHANGE  ; CHANGE SIDE DRIVE
;
; RESET Z IF SIDE WAS CHANGED FROM 1 TO 0

        JZ      FTR1
;
        CALL    INR_TRK     ; следующий траск
        CALL    PRN_TRK
;
        LDA     WORK+0ACh   ; TRACK
        INR     A
        STA     WORK+0ACh   ; TRACK
        STA     WORK+51Eh+4Dh-1
        STA     WORK+51Eh+4BEh+4Dh-1
        STA     WORK+51Eh+4BEh+4BEh+4Dh-1
        STA     WORK+51Eh+4BEh+4BEh+4BEh+4Dh-1
        CPI     84
        JNZ     FTR1
;
        LXI     H,ERR_COUNT+1   ; GET NUMBER OF BAD SECTORS
        CALL    ADD_30H
        DCX     H
        CALL    ADD_30H
        LXI     D,NUMB_ERR      ; ** BAD SECTORS ON THIS DISK
        CALL    OUTINFO
;
        CALL    FIX             ; FIXING BAD SECTORS
;
        LXI     D,OK
        CALL    OUTINFO
        MVI     C,01h
        CALL    BDOS    ; IN SYMBOL
        CPI     'Y'
        JZ      FORMAT
        CPI     'y'
        JZ      FORMAT
;
        CALL    MOTORON ; все установим траск 0 выход
        CALL    SET_TR0
        RST     0
;
ADD_30H:
        MOV     A,M
        ADI     30h
        MOV     M,A
        RET
;
;******************************************************
;       FIX SUB PROG
;*****************************************************
FIX:
        LXI     B,MAP_BAD       ; BEGIN OF  MAP BAD
        LHLD    MAP_POS+1       ; END   OF
        CALL    CMP_BC_HL
        RZ                      ; NO ERROR
        CALL    BEGIN_FIX
        CALL    PREP_TAB
        JMP     REWRITE_FAT
;
;****************************************************
;       REWRITE FAT SUB PROG
;
;***************************************************
REWRITE_FAT:

        RET
;
;***************************************************
;       PREPPARE TABLE SUB PROG
;       IN:     HL - END OF MAP OF BAD BLOCKS
;
;**************************************************
PREP_TAB:
        MVI     D,0
        LXI     B,MAP_BAD_BLOCK ; START OF MAP OF BAD BLOCKS
PREP_AGAIN:
        CALL    CMP_BC_HL
        RZ                      ; OVER IF =
;       START PREPARING TABLE
        MOV     A,D
        ORA     A
        JNZ     SKIP_PREP
;
        PUSH    H
        PUSH    D
        LXI     H,NAME_FILE
PREP_:
        LXI     D,FAT_TABLE     ; CORECTABLE !
        LXI     B,32
        CALL    LDIR
        POP     D
        POP     H
        MVI     D,8
SKIP_PREP:

        RET
;
;******************************************************
;       LDIR SUB PROG
;       IN:     HL - FROM
;               DE - WHERE
;               BC - NUMBER
;******************************************************
LDIR:
        MOV     A,M
        STAX    D
        INX     H
        INX     D
        DCX     B
        MOV     A,B
        ORA     C
        JNZ     LDIR
        RET
;****************************************************
;       COMPARE HL & BC SUB PROG
;       IN:     BC,HL
;       OUT:    Z IF EQU
;***************************************************
CMP_BC_HL:
        MOV     A,H
        CMP     B
        RNZ
        MOV     A,L
        CMP     C
        RET
;
BEGIN_FIX:
        LXI     D,FIX_INFO
        CALL    OUTINFO
;
        LXI     B,MAP_BAD       ; START OF BAD
        LXI     D,MAP_BAD_BLOCK ; START OF MAP BAD BLOCK
;
NEXT_FIX:
        PUSH    D
        CALL    CALK
        POP     D
        MOV     A,H
        STAX    D
        INX     D       ; SAVE BAD BLOCK TO (DE)
        MOV     A,L
        STAX    D
        INX     D
;
CHECK_FIX:
        LHLD    MAP_POS+1       ; END OF MAP
        CALL    CMP_BC_HL
        JNZ     NEXT_FIX
        XCHG
        SHLD    END_MAP_
        RET
;
END_MAP_:       DW      0  ; END MAP OF BAD BLOCKS
;
;**********************************************************
;       CALK SUB PROG
;       IN:     BC - NOW POINTER ON BAD TRACK, SIDE, SECTOR
;       OUT:    HL - NUMBER OF BAD BLOCK
;               BC - POINTER ON NEXT TRACK, SIDE, SECTOR
;**********************************************************
CALK:
        LDAX    B
        INX     B       ; GET TRACK
        SUI     04h
        JM      SYSTEM_AREA
        MVI     D,0
        MOV     E,A
        MOV     H,D
        MOV     L,E     ; HL=DE
        DAD     H       ; x2
        DAD     H       ; x2  = 4
        DAD     D       ; +1  = 5
;
        LDAX    B       ; GET SIDE
        INX     B
        ORA     A
        LDAX    B       ; GET SECTOR
        INX     B
        JZ      _SIDE_0
;       ====== SIDE 1 =======
        MVI     E,4
        CPI     03h     ; ADD 4 IF SECTOR = 4,5
        JC      EXIT_CALK
        DCR     E
        CPI     01h     ; ADD 3 IF SECTOR = 2,3
        JC      EXIT_CALK
        DCR     E       ; ADD 2 IF SECTOR = 1
EXIT_CALK:
        DAD     D
        RET
;       ======= SIDE 0 ========
_SIDE_0:
        MVI     E,2
        CPI     04h     ; ADD 2 IF SECTOR = 5
        JC      EXIT_CALK
        DCR     E
        CPI     02h     ; ADD 1 IF SECTOR = 3,4
        JC      EXIT_CALK
        DCR     E       ; NOTHING !
        JMP     EXIT_CALK
;
SYSTEM_AREA:
        INX     B
        INX     B
;
        POP     H       ; CLEAR STACK
        POP     D
        LXI     H,CHECK_FIX
        PUSH    H
;
_SYS_AREA:
        MVI     A,0FFh  ; CHANGEABLE !
        ORA     A
        RZ
        XRA     A
        STA     _SYS_AREA+1
        PUSH    D
        PUSH    B
        LXI     D,NOT_BOOT
        CALL    OUTINFO
        POP     B
        POP     D
        RET
;
;********************************************************
;       PRINT PROGRESS SUB PROG
;
;*******************************************************
PRN_TRK:
        LDA     TRK_LOW+1
        ANI     1
        RNZ
        MVI     E,'Б'
        MVI     C,2
        JMP     BDOS
;
;*********************************************
;       PUT_BYTE SUB PROG
;       IN:     A - FULLER
;               DE - NUMBER OF REPETION
;       OUT:    [NONE]
;**********************************************
PUT_BYTE:
        MVI     D,0
PUTBYTE:
        PUSH    PSW
PUT?:
        POP     PSW
        MOV     M,A
        INX     H
        DCX     D
        PUSH    PSW
        MOV     A,D
        ORA     E
        JNZ     PUT?
        POP     PSW
        RET
;
;       FORMAT_TRACK
;
FTRACK:
        CALL    @MOTOR
        LXI     H,WORK
        DI
        LXI     D,8102h
        MVI     A,0F4h  ;       WRITE TRACK
        OUT     FDC_C
F0:
        IN      FDC_C
        RRC
        JNC     F0
F1:
        IN      FDC_C
        ANA     E
        JZ      F1
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F1
        INR     H
F2:
        IN      FDC_C
        ANA     E
        JZ      F2
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F2
        INR     H
F3:
        IN      FDC_C
        ANA     E
        JZ      F3
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F3
        INR     H
F4:
        IN      FDC_C
        ANA     E
        JZ      F4
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F4
        INR     H
F5:
        IN      FDC_C
        ANA     E
        JZ      F5
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F5
        INR     H
F6:
        IN      FDC_C
        ANA     E
        JZ      F6
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F6
        INR     H
F7:
        IN      FDC_C
        ANA     E
        JZ      F7
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F7
        INR     H
F8:
        IN      FDC_C
        ANA     E
        JZ      F8
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F8
        INR     H
F9:
        IN      FDC_C
        ANA     E
        JZ      F9
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F9
        INR     H
F10:
        IN      FDC_C
        ANA     E
        JZ      F10
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F10
        INR     H
F11:
        IN      FDC_C
        ANA     E
        JZ      F11
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F11
        INR     H
F12:
        IN      FDC_C
        ANA     E
        JZ      F12
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F12
        INR     H
F13:
        IN      FDC_C
        ANA     E
        JZ      F13
        MOV     A,M
        OUT     FDC_d
        INR     L
        JNZ     F13
        INR     H
F14:
        IN      FDC_C
        ANA     E
        JZ      F14
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F14
        INR     H
F15:
        IN      FDC_C
        ANA     E
        JZ      F15
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F15
        INR     H
F16:
        IN      FDC_C
        ANA     E
        JZ      F16
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F16
        INR     H
F17:
        IN      FDC_C
        ANA     E
        JZ      F17
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F17
        INR     H
F18:
        IN      FDC_C
        ANA     E
        JZ      F18
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F18
        INR     H
F19:
        IN      FDC_C
        ANA     E
        JZ      F19
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F19
        INR     H
F20:
        IN      FDC_C
        ANA     E
        JZ      F20
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F20
        INR     H
F21:
        IN      FDC_C
        ANA     E
        JZ      F21
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F21
        INR     H
F22:
        IN      FDC_C
        ANA     E
        JZ      F22
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F22
        INR     H
F23:
        IN      FDC_C
        ANA     E
        JZ      F23
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F23
        INR     H
F24:
        IN      FDC_C
        ANA     E
        JZ      F24
        MOV     A,M
        OUT     FDC_D
        INR     L
        JNZ     F24
        INR     H
F25:
        IN      FDC_C
        XRA     D
        JZ      F25
        RRC
        MOV     A,M
        OUT     FDC_D
        INX     H
        JNC     F25
        IN      FDC_C
        ANI     0DDh
        PUSH    PSW
        LDA     MOTORON+1
        OUT     CONT
        POP     PSW
        EI
        RET
;**************************************
;       MOTOR ON SUBPORG
;       [NONE]
;*************************************
; модифицируемый код
MOTORON:
        MVI     A,SIDE0 ; 34-SIDE 0, 30 - SIDE 1
        OUT     CONT
        IN      FDC_C
        RLC             ; DISK READY ?
        RNC     ; YES
        JMP     MOTORON
;******************************************
;       CHANGE SIDE  SUBPRG
;       [NONE]
;******************************************
CHANGE:
        LDA     MOTORON+1
        XRI     04H
        STA     MOTORON+1
        ANI     4
;       MVI     C,01H   ; SECTOR=1
        RET
;*************************************
;       READ    SECTOR
;       [DE]- WHERE THE DATA'L BE READ
;*************************************
; модифицируемый код
READ:
        DI
        LXI     H,CNTRL
        PUSH    H
        CALL    MOTORON
        MVI     A,R_DATA
        OUT     FDC_C
READ_:
        IN      FDC_C
        RRC
        JNC     READ_
READ1:
        LDA     MOTORON+1
        OUT     CONT
_READ:
        IN      FDC_S
        RRC
        RNC             ; END OF SECTOR
        RRC
        JNC     _READ   ; DATA READY ?
        IN      FDC_D
;       STAX    D
;       INX     D
        JMP     READ1
;
CNTRL:
        IN      FDC_S
        ANI     0DDh
        EI
        RZ
;
;       SECTOR BAD WAS DETECTED
; ======= TRACK, SIDE SECTOR ============
;
MAP_POS:
        LXI     H,MAP_BAD       ; CHANGEABLE !
;
        LDA     WORK+0ACh       ; PUT TRACK
        MOV     M,A
        INX     H
        LDA     TRK_HIGH+1
        ADI     30h
        STA     TR_ERR
        LDA     TRK_LOW+1
        ADI     30h
        STA     TR_ERR+1
;
        LDA     WORK+0ADh  ; PUT SIDE
        MOV     M,A
        INX     H
        ADI     30h
        STA     SIDE_ERR
;
        IN      FDC_SE  ; PUT SECTOR
        MOV     M,A
        ADI     30h
        STA     SEC_ERR
;
        INX     H               ; SAVE REAL POSITION
        SHLD    MAP_POS+1
;
        LXI     H,ERR_COUNT+1
        INR     M
        CPI     0Ah
        JNZ     SKP_INR
        MVI     M,0
        DCX     H
        INR     M
SKP_INR:
        LXI     D,MES_ERR
        JMP     OUTINFO
;
;****************************************
;       SET TRACK 00
;       [NONE]
;****************************************
SET_TR0:
        XRA     A
        OUT     FDC_C
        XRA     A
SETTR1:
        DCR     A
        JNZ     SETTR1
SETTR2:
        LDA     MOTORON+1
        OUT     CONT
        IN      FDC_S
        RRC
        JC      SETTR2
        ANI     00100000b
        RZ
        LXI     D,WRT_PRT
        JMP     QUIT
;
INR_TRK:
                CALL    MOTORON
                MVI     A,58h
                OUT     FDC_C
                XRA     A
INR1:
                DCR     A
                JNZ     INR1
INR2:
                LDA     MOTORON+1
                OUT     CONT
                IN      FDC_C
                RRC
                JC      INR2
TRK_LOW:
                MVI     A,0
                INR     A
                CPI     10
                STA     TRK_LOW+1
                RNZ
                XRA     A
                STA     TRK_LOW+1
TRK_HIGH:
                MVI     A,0
                INR     A
                STA     TRK_HIGH+1
                RET
;
@MOTOR:
                LDA     MOTORON+1
                OUT     CONT
MOTOR1:
                IN      FDC_C
                RLC
                JNC     INT
                LDA     MOTORON+1
                OUT     CONT
                CALL    LOOP
                JMP     MOTOR1
;
LOOP:
                MVI     A,50h
LOOP1:
                CALL    LOOP2
                DCR     B
                JNZ     LOOP1
                RET
;
INT:
                MVI     A,0D8h
                OUT     FDC_C
LOOP2:
                XRA     A
LOOP3:
                DCR     A
                JNZ     LOOP3
                RET
;
OUTINFO:
                MVI     C,09h
                JMP     BDOS
;
COPYWRITE:
        DB      10,13,' Spead Format utility ',10,13
        DB      ' Copyright (C) 1992, by Max  ',10,13
        DB      ' SF DRIVE_NAME:[/option] ',10,13
        DB      '       Option: U - unchecking information ',10,13,24h
;
MES_ERR:
        DB      10,13,' TRACK '
TR_ERR:
        DB      0,0,' SIDE '
SIDE_ERR:
        DB      0,' SECTOR '
SEC_ERR:
        DB      0,10,13,24h
;
WARN:
        DB      10,13,'         WARNING  ! ',10,13
        DB      ' ALL INFORMATION WILL BE DESTROIED ! ',10,13
        DB      ' INSERT DISK AND PRESS ANY KEY ',10,13,24h
;
FORM:
        DB      10,13,' FORMATING  PROCESS ',24h
;
WRT_PRT:
        DB      10,13,' DISK WRITE PROTECTED !',10,13,24h
;
OK:
        DB      10,13,' FORMAT COMPLITE ',10,13
        DB      ' FORMAT ANOTHER (Y/N) ? ',24h
;
NUMB_ERR:
        DB      10,13
ERR_COUNT:      DB      0,0,' BAD SECTOR(s) ON THIS DISK',10,13,24h
;
FIX_INFO:
                DB      10,13,' WAIT PLEASE - FIXING BAD BLOCKS',10,13,24h
;
NOT_BOOT:       DB      10,13,' THIS DISK CAN NOT BE BOOTABLE ',10,13,24h
;
NOT_DIR:        DB      10,13,' DIR SECTORS BAD ',10,13,24h
;
NAME_ERR_FILE:
                DB      16,'BAD_SECTOR!',0,0,0,0
                DB      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;
KON:
        END

