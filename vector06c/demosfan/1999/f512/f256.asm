PIXBEG:  EQU 02H
CX:      EQU 400H
SI:      EQU 402H

         ORG 100H
         DI             ; инициализация
         XRA A          ;
         OUT 0          ;
         OUT 1          ;
         OUT 2          ;
         OUT 10H        ;
         CMA            ;
         OUT 3          ;
         LXI H,38H      ; прерываний у нас
         MVI M,0C9H     ; не будет как класса
         EI             ;
         DB 76H         ; STAS глючит в этом месте :-(
         MVI D,0FH      ; очистим таблицу цветов
M15:     MOV A,D        ;
         OUT 2          ;
         XRA A          ;
         OUT 12         ; надо бы побольше,
         OUT 12         ; но жалко :-)
         OUT 12         ;
         OUT 12         ;
         OUT 12         ;
         DCR D          ;
         JP M15         ;
         LXI H,8000H    ; рутина
CLS:     MVI M,0        ;
         INX H          ;
         MOV A,H        ;
         ORA L          ;
         JNZ CLS        ;
         MVI M,0C3H     ;
         LXI H,0100H    ;
         SHLD 1         ;
         SPHL           ;
         MVI H,PIXBEG   ; создаем табличку (512 байт),
         MVI A,80H      ; по которой будет рисоваться
         PUSH PSW       ; точка на экране
         MVI B,32       ;
MAK2:    MVI C,8        ;
MAK1:    MOV M,A        ;
         INX H          ;
         DCR C          ;
         JNZ MAK1       ;
         INR A          ;
         DCR B          ;
         JNZ MAK2       ;
         POP PSW        ;
MAK3:    MOV M,A        ;
         INX H          ;
         RRC            ;
         DCR B          ;
         JNZ MAK3       ;
         EI             ;
         DB 76H         ;
         MVI A,8        ; математический цвет
         OUT 2          ; плоскость 8000h
         MVI A,0F0H     ; физический цвет
         OUT 12         ; опять жаба душит :-)
         OUT 12         ;
         OUT 12         ;
         OUT 12         ;
         OUT 12         ;
         XRA A          ; это чтобы проблем с бордюром не было
         OUT 2          ;
M1:      LXI D,3        ; нам нужно случайное число
         CALL GETRND    ; в диапазоне 0..2
         DCR E          ;
         LXI D,256      ; сам алгоритм элементарный
         LHLD CX        ; но тут уже оптимизация пошла...
         JZ M3          ;
         JP M2          ;
         PUSH H         ;
         LHLD SI        ;
         DAD D          ;
         SHLD SI        ;
         POP H          ;
         LXI B,-128     ;
         DAD B          ;
M2:      DAD D          ;
M3:      MOV A,H        ;
         ORA A          ;
         RAR            ;
         MOV H,A        ;
         MOV A,L        ;
         RAR            ;
         MOV L,A        ;
         SHLD CX        ;
         MOV C,L        ;
         LHLD SI        ;
         MOV A,H        ;
         ORA A          ;
         RAR            ;
         MOV H,A        ;
         MOV A,L        ;
         RAR            ;
         MOV L,A        ;
         SHLD SI        ;
         MVI B,PIXBEG   ; самая быстрая процедурка рисования
         LDAX B         ; точки (c) не мой
         MOV H,A        ;
         INR B          ;
         LDAX B         ;
         ORA M          ;
         MOV M,A        ;
         JMP M1         ;
; датчик случайных чисел
; -> DE - максимальное значение
; <- DE - псевдослучайное число
GETRND:  PUSH D         ;
         LXI B,1999H    ; seed
         LXI D,6255H    ; k1
         CALL MUL16     ;
         LXI D,3619H    ; k2
         DAD D          ;
         SHLD GETRND+2  ;
         XCHG           ;
         POP B          ;
; Умножение 16-битных чисел в регистрах
; -> BC - множимое
; -> DE - множитель
; <- DE-HL - результат
MUL16:   LXI H,0        ; подготовить младшую часть произведения
         MVI A,16       ; образовать счетчик бит
M05:     XCHG           ; множитель в HL, произведение в DE
         DAD H          ; сдвинуть множитель влево
M04:     XCHG           ; множитель в DE, произведение в HL
         JNC M06        ; бит множителя равен нулю
         DAD B          ; прибавить множимое
         JNC M06        ; переноса в старшую часть нет
         INX D          ; передать 1 в младший бит множителя
M06:     DCR A          ; декремент счетчика бит
         RZ             ; умножение закончено
         DAD H          ; сдвинуть младшую часть произведения
         JNC M05        ; переноса нет
         XCHG           ; множитель в HL, произведение в DE
         DAD H          ; сдвинуть множитель влево
         INX H          ; передать 1 в младший бит множителя
         JMP M04        ; повторить умножение
         DB 'coded by FANSoft for DemosFan-99'
