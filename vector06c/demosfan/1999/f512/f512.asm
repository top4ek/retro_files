CX:      EQU 1000H
SI:      EQU 1002H

         ORG 100H
         DI
         XRA A
         OUT 0
         OUT 1
         OUT 2
         OUT 10H
         CMA
         OUT 3
         LXI H,38H
         MVI M,0C9H
         LXI H,8000H
CLS:     MVI M,0
         INX H
         MOV A,H
         ORA L
         JNZ CLS
         MVI M,0C3H
         INR H
         SHLD 1
         SPHL
         EI
         DB 76H
         MVI B,15
FGF:     MOV A,B
         OUT 2
         MVI A,0F0H
         OUT 12
         OUT 12
         OUT 12
         OUT 12
         OUT 12
         OUT 12
         DCR B
         JNZ FGF
         XRA A
         OUT 2
         MVI A,10H
         OUT 2
M1:      LXI D,3
         CALL GETRND
         DCR E
         LHLD CX
         JZ M3
         JP M2
         PUSH H
         LHLD SI
         LXI D,256
         DAD D
         SHLD SI
         POP H
         LXI B,-256
         DAD B
M2:      LXI D,512
         DAD D
M3:      MOV A,H
         ORA A
         RAR
         MOV H,A
         MOV A,L
         RAR
         MOV L,A
         SHLD CX
         MOV B,H
         MOV C,L
         LHLD SI
         MOV A,H
         ORA A
         RAR
         MOV H,A
         MOV A,L
         RAR
         MOV L,A
         SHLD SI
PSET:    MOV A,B
         RAR
         MOV A,C
         RAR
         MOV E,A
         LXI B,0A000H
         JC  MM1
         LXI B,0C000H
MM1:     DAD B
         RRC
         RRC
         RRC
         ANI 1FH
MM2:     JZ SBIT
         INR H
         DCR A
         JMP MM2
SBIT:    MOV A,E
         ANI 7
         MOV E,A
         MVI A,80H
SBIT1:   DCR E
         JM SLCT
         ORA A
         RAR
         JMP SBIT1
SLCT:    ORA M
         MOV M,A
         JMP M1
GETRND:  PUSH D
         LXI B,1999H
         LXI D,6255H
         CALL MUL16
         LXI D,3619H
         DAD D
         SHLD GETRND+2
         XCHG
         POP B
MUL16:   LXI H,0
         MVI A,16
M05:     XCHG
         DAD H
M04:     XCHG
         JNC M06
         DAD B
         JNC M06
         INX D
M06:     DCR A
         RZ
         DAD H
         JNC M05
         XCHG
         DAD H
         INX H
         JMP M04
         DB 'coded by FANSoft for DemosFan-99'
