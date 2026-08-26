(*
Это восстановленный из исполнимого файла код на языке Паскаль для игры,
которая называлась 'Зона' или 'Сталкер', файл игры назывался
STALK.SAV, PIKNIK.SAV или ZONA.SAV и предназначался для советских PDP11-
совместимых машин - таких как ДВК и УКНЦ.
Это игра в жанре рогалик (Rogue-like), бродилка по подземельям, по мотивам
повести Стругацких "Пикник на обочине".
Игра, по-видимому, создана в конце 1980-х, автор игры - неизвестный
программист из Ульяновска - первоначально программа писала копирайт:
*** (С)УЛЬЯНОВСК УЛПИ "ГОЛОГРАФИЯ"***
Данный исходник предназначается для Паскаля ДВК или OMSI PASCAL-1
и компилируется в исполнимый файл под системой RT-11 командами:
    PASCAL STALK1,STALK1=STALK1.PAS
    LINK/STACK:1000 STALK1,FRANDU,PASCAL
*)
{$S-} { no recursion, all static }
{$R-} { run-time range checking off }
{$L+} { generate listing }
{$P-} { no form feed between pages }
PROGRAM STALK;


const
    { IND indices }
    { 1 - Рейтинг, 2 - Энергия, 3 - Оружие, 4 - Защита, 5 - В банке денег }
    IRating = 1;
    IEnergy = 2;
    IWeapon = 3;
    IArmor = 4;
    IGold = 5;


    { quaff & 6
                 0 = sense objects
                 2 = refresh fatigue
                 4 = show map
                 6 = alcohol
      whistle & 6
                 4 = whistle
                 2 = dig -2..+2 around self
                 0 = teleport
                 6 = destroy all monsters?
      zap wand & 3
                 3 = fake
                 2 = show map (single use)
                 1 = golden orb owner teleports 3 levels up
                     otherwise, 3 levels down (single use)
                 0 = turn chasing beast into random junk
      read & 6
                 0 = remove curse
                 2 = funny joke
                 4 = find staircase
                 6 = find golden orb location at level 8
                 }
    SEEN = $40;
    NOTSEEN = $bf;
    CURSED = $20;
    CURSEDNOT = $df;

    SACKLO = 1;
    SACKHI = 6;

type
    TFlags = byte;
    TState = (SCont, SRestart, SQuit);

    TTile = record
        CH: char;
        FLAGS: TFlags;
    end;
    PTile = ^TTile;

    TLoc = record
        Y, X: integer;
    end;

    TMonster = record
        TILE: TTile;
        Y, X: integer;
    end;

var
    DUNGEON:integer; { Номер подземелья }
    STEPCTR:   integer;
    FLOOR:  integer; { Номер этажа }
    TGT:    TLoc;
    PLR:    TLoc;
    LOOK:   TLoc;
    PREV:   TLoc;

    TIRED:  integer; { Усталость }
    HARM:   integer; { Вредность }
    BCHARGE:integer; { Заряд батарей фонаря }
    DRUNK:  integer;

    SEED:   integer; { Число для генератора случайных чисел }
    TMPCHAR:  char;

    { 1 - Рейтинг, 2 - Энергия, 3 - Оружие, 4 - Защита, 5 - В банке денег }
    IND:    array[IRating..IGold] of integer; { Индикаторы справа: }
    PREVIND:array[IRating..IGold] of integer;

    MAP: array[0..8,1..16,1..32] of TTile;
    MPTR: PTile;
    TGTPTR: PTile;

    SACK: array [SACKLO..SACKHI] of TTile;
    MONSTERS: array [1..4] of TMonster;

    GAMEFLAGS: set of (DRAWSACK, FIGHTING, RING, LAMPON, HAVEORB);

EXTERNAL FUNCTION @BDOS(FUNC:INTEGER; PARM:WORD):INTEGER;

function RANDOM(A,B:integer):integer; {L01046}
var
    ans: integer;
begin
    SEED := (20077 * seed + 12345);

    ans := SEED & $7fff;
    if not ((A = 0) and (B = 32767)) then
        ans := A + ans mod (B - A + 1);

    RANDOM := ans;
end;

function READKEY: char;
begin
    READKEY := CHR(@BDOS(6,WRD($FD)));
end;

procedure READCHAR(var CH:char; toupper: boolean);
begin
    { MicroDOS 5: up, 24: down, 8: left, 4: right }
    CH := READKEY;
    case ORD(CH) of
    5:  CH := '8';{ стрелка вверх }
    24: CH := '2';{ стрелка вниз }
    8:  CH := '4';{ стрелка влево }
    4:  CH := '6';{ стрелка вправо }
    end;

    if (toupper) then { преобразуем в заглавные буквы }
        if (ORD(CH) >= ORD('a')) and (ORD(CH) <= ORD('z')) then
            CH := CHR(ORD(CH) + ORD('A') - ORD('a'));
end;

{ Поставить курсор на позицию (X*2,Y) }
procedure CURSORTO(Y, X:integer); {L01216}
begin
    WRITE(CHR(27), 'Y', CHR(32 + y), CHR(32 + x + x));
end;

procedure CLRSCR;
begin
    WRITE(CHR(27),'H',CHR(27),'J');
end;

procedure CLREOL;
begin
    WRITE(CHR(27),'K');
end;

procedure TERMCR;
var
    CH: char;
begin
    CH := CHR(@BDOS(2, WRD(13)));
end;

procedure WRITEAT(y, x: integer; c: char);
begin
    CURSORTO(y, x);
    WRITE(c);
end;

{ Очистка блока сообщений внизу экрана }
procedure CLEARMSG; {L01320}
var
    i: integer;
    dummy: integer;
begin
    CURSORTO(16,0);
    for i := 1 to 7 do begin
        dummy := @BDOS(2, WRD(10));
        CLREOL;
    end;
    CURSORTO(17,0);
end;

{ true if LOOK = (0,0) }
function LOOKATPLAYER: boolean;
begin
    LOOKATPLAYER := (LOOK.X = 0) and (LOOK.Y = 0);
end;

function INFIELD(Y, X: integer): boolean;
begin
    INFIELD := (Y in [2..15]) and (X in [2..31]);
end;

function WALL(c: char): boolean;
begin
    WALL := c in ['!', '-'];
end;

procedure USEITEM(item: PTile);
begin
    item^.CH := '.';
    GAMEFLAGS := GAMEFLAGS + [DRAWSACK];
end;

function NOTCURSED(var T: TTile): boolean;
begin
    NOTCURSED := (T.FLAGS & CURSED) = 0;
end;

{ показать один тайл и пометить его как увиденный }
procedure MAKESEEN(T: PTile);
begin
    T^.FLAGS := T^.FLAGS | SEEN;
end;

procedure REVEAL(y, x: integer);
var
    T: PTile;
begin
    T := ADDR(MAP[FLOOR, y, x]);
    WRITEAT(y, x, T^.CH);
    MAKESEEN(T);
end;

{ печатаем область вокруг игрока и самого игрока }
procedure DRWAROUND;
var
  i, j, y, x: integer;
  range: integer;
  p: PTile;
  c: char;
begin
    if LAMPON in GAMEFLAGS then
        range := 1
    else
        range := 0;

    for j := -range to range do begin
        for i := -range to range do begin
            y := PLR.Y + j;
            x := PLR.X + i;
            p := ADDR(MAP[FLOOR, y, x]);
            MAKESEEN(p);
            if (i | j) = 0 then
                c := '@'
            else if (p^.CH = '^') and ((p^.FLAGS & 6) <> 4) then
                { тайный студень }
                c := '.'
            else
                c := p^.CH;
            WRITEAT(y, x, c);
        end;
    end;
end;

{ Поиск предметов в рюкзаке }
function INVGET(A, B: char; var ITEM: PTile): boolean;
var
    i: integer;
begin
    ITEM := nil;
    INVGET := FALSE;
    for i := SACKLO to SACKHI do with SACK[i] do
        if (CH = A) or (CH = B) then begin
            ITEM := ADDR(SACK[i]);
            INVGET := TRUE;
            EXIT;
        end;
end;

procedure SACKRESET(randomize: boolean);
var
    i: integer;
begin
    for i := SACKLO to SACKHI do begin
        SACK[i].CH := '.';
        if randomize then
          SACK[i].FLAGS := RANDOM(0,8191) & CURSEDNOT;
    end;
end;

 { выводим содержимое рюкзака }
procedure DRWRUKSAK;
var
    i: integer;
begin
    if DRAWSACK in GAMEFLAGS then begin
        CURSORTO(10,33);
        for i := SACKLO to SACKHI do
            WRITE(SACK[i].CH:2);

        GAMEFLAGS := GAMEFLAGS - [DRAWSACK];
    end;
end;

procedure LIFTCURSE;
var
    i: integer;
begin
    for i := SACKLO to SACKHI do
        SACK[i].FLAGS := SACK[i].FLAGS & CURSEDNOT;

    WRITELN('"APCHXYZZYURR!!!"... Заклятие снято');
end;

{ переложить вещи в рюкзаке }
procedure CMDPACK;
var
    i: integer;
    tmp: TTile;
begin
    tmp := SACK[SACKHI];
    for i := SACKLO to SACKHI do
        SACK[SACKHI + 1 - i] := SACK[SACKHI - i];

    SACK[1] := tmp;
    GAMEFLAGS := GAMEFLAGS + [DRAWSACK];
    WRITELN('Перестройка в рюкзаке');
end;

procedure NELZYA;
begin
    WRITELN(' Н е л ь з я ! ! !');
end;

{ wake up a monster, sometimes }
{ the original used to overwrite shared globals used in the outside loop }
procedure WAKEUPMONSTER(LY, LX:integer);
var
    p: PTile;
    i: integer;
    found: integer;
begin
    p := ADDR(MAP[FLOOR,LY,LX]);
    WRITELN('З в е р ь !');

    { monster in REM sleep? }
    if (p^.FLAGS & 4) <> 0 then begin
        found := 0;
        for i := 1 to 3 do
            with MONSTERS[i] do begin
                if TILE.CH = p^.CH then
                    EXIT; { такой уже есть, ничего не делаем }
                if (TILE.CH = ' ') and (found = 0) then
                    found := i; { запомнили первый свободный слот }
            end;

        { так в оригинале. новый монстр заменяет третьего }
        if found = 0 then found := 3;

        with MONSTERS[found] do begin
            TILE := p^;
            Y := LY;
            X := LX;
        end;
    end;
end;

procedure ZAKLYATIE;
begin
    WRITELN('На этой штуке заклятие');
end;

{ выводим значения индикаторов }
procedure DRWINDVAL;
var
    i: integer;
    val: integer;
begin
    for i:=IRating to IGold do begin
        val := IND[i];
        if val <> PREVIND[i] then begin
            PREVIND[i] := val;
            CURSORTO(i,37);
            WRITE(val:3, ' ');
        end;
    end;

    CURSORTO(7,37);
    WRITE(HARM:3); { Вредность }
end;

{ update pointers to player location }
procedure MOVEPLAYER(y, x: integer);
begin
    PLR.Y := y;
    PLR.X := x;
    MPTR := ADDR(MAP[FLOOR, PLR.Y, PLR.X]);
end;

{ update pointers to target location }
procedure UPDTGTPTR;
begin
    TGTPTR := ADDR(MAP[FLOOR,TGT.Y,TGT.X]);
end;

{ возвращает TRUE если надо перерисовать уровень }
function CLIMB(A: char): boolean;
var
    i: integer;
begin
    CLIMB := FALSE;
    if MPTR^.CH = '%' then begin { Мы стоим на лестнице? }
        WIPEMONSTERS;
        if (A = '.') and (FLOOR <> 0) then begin
            FLOOR := FLOOR - 1; { Этаж вверх }
            IND[IEnergy] := IND[IEnergy] - 2; { Энергия минус 2 }
            IND[IRating] := IND[IRating] + 1;
            CLIMB := TRUE;
        end else if FLOOR <> 8 then begin
            FLOOR := FLOOR + 1;
            IND[IRating] := IND[IRating] + 3;
            CLIMB := TRUE;
        end;

        MOVEPLAYER(PLR.Y,PLR.X); { no change in X,Y but update pointer }
        UPDTGTPTR;
    end else begin { не на лестнице }
        WRITELN(' Без лестницы?'); {L04140}
    end;
end;

{ Параметр: 'J' - обновить экран; '.' - вверх; '5' - вниз }
procedure REFRESH(A:char);
var
    q, p: integer;
    pm: PTile;
begin
    { пометить все как грязное }
    GAMEFLAGS := GAMEFLAGS + [DRAWSACK];
    for q := IRating to IGold do
        PREVIND[q] := -1;

    if (A <> 'J') and not CLIMB(A) then EXIT;

    CLRSCR;
    WRITE('    Подземелье ');
    WRITE(DUNGEON); { Номер подземелья }
    CURSORTO(1,33); WRITE('Рейтинг');
    CURSORTO(2,33); WRITE('Энергия');
    CURSORTO(3,33); WRITE('Оружие');
    CURSORTO(4,33); WRITE('Защита');
    CURSORTO(5,33); WRITE('В банке');
    CURSORTO(7, 32);WRITE(' Вредность');
    CURSORTO(9, 33);WRITE('Рюкзак:');

    DRWINDVAL;
    DRWRUKSAK;

    for q:=1 to 16 do begin { выводим текущее поле }
        for p:=1 to 32 do begin
            pm := ADDR(MAP[FLOOR,q,p]);
            if (pm^.FLAGS & SEEN) <> 0 then
                WRITEAT(q, p, pm^.CH);
        end;
    end;
    CLEARMSG;
end;

procedure WALK(DY,DX:integer);
begin
    { Если не стенка }
    if not WALL(MAP[FLOOR, PLR.Y + DY,PLR.X + DX].CH) then
        MOVEPLAYER(PLR.Y + DY, PLR.X + DX)
    else
        NELZYA;
end;

{ place an item A at random position }
procedure RANDPLACE(A:char);
begin
    with MAP[FLOOR, RANDOM(2,15), RANDOM(2,31)] do begin
        CH := A;
        FLAGS := RANDOM(0,32767) & NOTSEEN;
    end;
end;


procedure FILLTILE(X: PTile; N: integer; c: char; flg: byte);
var
  i: integer;
begin
    for i := 1 to N do with X^ do begin
        CH := c;
        FLAGS := flg;
        X := X + SIZEOF(PTile);
    end;
end;

{ Начало игры, или рестарт на следующем подземелье }

{ create level outlines, fill floor with flags except cursed }
procedure RSTRT_A;
var
    x, y, z: integer;
    lflags: integer;
begin
    CLRSCR;
    CURSORTO(10,1);

    { NB: the original does not initialize border flags }
    for z := 0 to 8 do begin
        lflags := RANDOM(0,88) & CURSEDNOT;
        FILLTILE(ADDR(MAP[z,1,1]), 32, '-', lflags);
        FILLTILE(ADDR(MAP[z,16,1]), 32, '-', lflags);
        for y:=2 to 15 do begin
            FILLTILE(ADDR(MAP[z,y,1]), 32, '.', lflags);
            MAP[z,y,1].CH := '!';   { стенка слева }
            MAP[z,y,32].CH := '!';  { стенка справа }
        end;
    end;
end;

{ create horizontal walls on maze levels }
procedure RSTRT_B;
var
  x, y, z: integer;
  left, right: integer;
begin
    for z:=1 to 8 do begin { цикл по этажам }
        y:=RANDOM(2,7);
        while y < 16 do begin
            left:=2;
            right:=RANDOM(1,7);
            while right < 32 do begin
                for x:=left to right do begin
                    MAP[z,y,x].CH := '-';
                end;
                left:=RANDOM(1,5)+right;
                right:=RANDOM(3,10)+right;
            end;
            y:=RANDOM(0,7)+y;
        end;
    end;
end;

{ create vertical walls on maze levels }
procedure RSTRT_C;
var
    x, y, z: integer;
    top, bottom: integer;
begin
    for z := 1 to 8 do begin { цикл по этажам }
        x:=RANDOM(2,7);
        while x < 32 do begin
            top := 2;
            bottom := RANDOM(1,7);
            while bottom < 16 do begin
                for y:=top to bottom do
                    with MAP[z,y,x] do if CH = '.' then
                        CH := '!'
                    else
                        CH := '#';
                top := RANDOM(1,5)+bottom;
                bottom := RANDOM(2,7)+bottom;
            end;
            x := RANDOM(2,5)+x;
        end;
    end;
end;

{ place random items }
procedure RSTRT_D;
var
    i, j: integer;
begin
    for i:=1 to DUNGEON do begin
        for j:=32 to 127 do begin
            FLOOR:=RANDOM(0,8);
            RANDPLACE(CHR(j));
        end;
    end;
end;

procedure RSTRT_E;
var
    z: integer;
begin
    { place mandatory items }
    for z:=0 to 8 do begin
        FLOOR := z;
        RANDPLACE('^'); { witches jelly }
        RANDPLACE('*'); { gold }
        RANDPLACE('%'); { staircase }
    end;

    FLOOR:=8;
    RANDPLACE('%');     { staircase }
    RANDPLACE(',');     { golden orb }

    if DUNGEON = 1 then begin
        SACKRESET(true);
        SACK[1].CH := ']';
        SACK[2].CH := '(';
        SACK[3].CH := '<';

        for z := IRating to IGold do
        begin
            PREVIND[z] := -1;
            IND[z] := 0; { Очищаем индикаторы }
        end;

        { Инициализация переменных }
        IND[IEnergy]:=25; { Энергия }
        DRUNK:=0;
        BCHARGE:=400; { Заряд батарей }
        TIRED:=0;     { Усталость = 0 }
        GAMEFLAGS := GAMEFLAGS + [DRAWSACK] - [LAMPON,RING,FIGHTING];
    end;

    GAMEFLAGS := GAMEFLAGS - [HAVEORB];
    WIPEMONSTERS;
end;

procedure RESTART;
begin
    RSTRT_A;
    WRITELN('   Для подсказки нажимайте "H" ');
    RSTRT_B;
    TERMCR;
    WRITE('     Темный  коридор ...     ');
    RSTRT_C;
    TERMCR;
    WRITE('     С к е л е т ы . . .   ');
    RSTRT_D;
    TERMCR;
    WRITE(' a-a-a-a-a-a-a-a-a-a-a-a-a . . . . . . .');
    RSTRT_E;

    FLOOR := 0; { Этаж = 0 }
    REFRESH('J');
    CLEARMSG;
    WRITE('Прогнивший пол провалился...');
    STEPCTR := 0;
    PREV.Y := 1; { Позиция Y игрока }
    PREV.X := 1; { Позиция X игрока }
    MOVEPLAYER(2, 2);
    HARM := 1;
end;

{ step on, or pass by a monster
  passing by may wake it up
  stepping on it is a combat situation.

  LOOK.Y, LOOK.X -- cell relative to player position (-1..1)
  TGT.Y,TGT.X, TGTPTR -- absolute lookat position

  LOOK.Y,LOOK.X = (0,0) means TGT points to player position (see LOOKAROUND)

  }
procedure DOMONSTER;
var
    i: integer;
    my, mx: integer;
begin
    if LOOKATPLAYER then begin
        { MPTR == TGTPTR here }
        if (MPTR^.FLAGS & 6) = 0 then begin
            { enable wakeup flag on a prodded monster }
            MPTR^.FLAGS := MPTR^.FLAGS | 6;
            WRITELN('Ну, сейчас он вам покажет...')
        end else if (MPTR^.FLAGS & 6) = 2 then begin
            { убегающий зверь }
            my := RANDOM(-1,1) + PLR.Y;
            mx := RANDOM(-1,1) + PLR.X;
            if not WALL(MAP[FLOOR, my, mx].CH) then begin
                MAP[FLOOR, my, mx] := MPTR^;
                MPTR^.CH := '.';
            end;
        end else if not (RING in GAMEFLAGS) then begin {L15100}
            if not (FIGHTING in GAMEFLAGS) then begin {L15120}
                if IND[IArmor] > 1 then {L15140}
                    IND[IArmor] := IND[IArmor] - RANDOM(2, 15)
                else
                    IND[IEnergy] := IND[IEnergy] - RANDOM(2, 15); { Энергия уменьшается }
                WRITELN(CHR(7), 'Защищайтесь же!!!');
            end else begin
                IND[IWeapon] := IND[IWeapon] - RANDOM(2, 11);
                IND[IArmor] := IND[IArmor] - 2;
                GAMEFLAGS := GAMEFLAGS - [FIGHTING];
                WRITELN(CHR(7), 'Готов!');
                IND[IRating] := IND[IRating] + 10;
                if IND[IArmor] < 0 then begin
                    IND[IEnergy] := IND[IEnergy] + IND[IArmor];
                    IND[IArmor] := 0;
                end;
                if IND[IWeapon] < 0 then begin
                    IND[IRating] := IND[IRating] + IND[IWeapon];
                    IND[IWeapon] := 0;
                end;
                i := 1;
                while (MONSTERS[i].TILE.CH <> MPTR^.CH) and (i < 4) do
                    i := i + 1;
                MONSTERS[i].TILE.CH := ' ';
                MPTR^.CH := 'm'; { Дохлая крыса }
            end;
        end;
    end
    else
        WAKEUPMONSTER(TGT.Y, TGT.X);
end;

procedure BLKHOLE;
begin
    WRITELN('Черная дыра');
    if LOOKATPLAYER then begin
        if HAVEORB in GAMEFLAGS then begin
            if FLOOR > 0 then
                FLOOR:=FLOOR-1; { Этаж вниз }
        end else begin
            if FLOOR < 8 then
                FLOOR:=FLOOR+1; { Этаж вверх }
        end;
        IND[IEnergy]:=IND[IEnergy]-3; { Энергия минус 3 }
        HARM:=HARM + 7; { Вредность увеличиваем на 7 }
        REFRESH('J');
        WRITELN('Ой, как больно!...');
    end;
end;

procedure JELLY;
begin
    if LOOKATPLAYER then begin
        { 0,0 = player location, TGTPTR == MPTR }
        WRITELN('Ведьмин студень!');
        IND[IEnergy]:=IND[IEnergy]-RANDOM(3,15);
        HARM:=HARM + RANDOM(0,5);
        TGTPTR^.FLAGS := 4;
    end;
end;

procedure MANGE;
begin
    WRITELN('Комариная плешь');
    MOVEPLAYER(TGT.Y, TGT.X);
    if HAVEORB in GAMEFLAGS then
        MPTR^.CH := '.';
end;

procedure FOOD;
var
    taste: integer;
begin
    if LOOKATPLAYER then begin
        taste:=RANDOM(-7,7);
        IND[IEnergy]:=IND[IEnergy]+taste;
        if taste > 0 then begin
            WRITELN('Недурственно!');
            MPTR^.CH := 'z';    { Следы пикника. }
        end else begin
            WRITELN('Тьфу...');
            MPTR^.CH := 'y';    { Что-то очень мерзкое }
        end;
    end else begin
        WRITELN('Свертoк. съедим?');
    end;
end;

procedure GHOST;
var
    item: PTile;
begin
    WRITE('Призрак.');
    if INVGET('.', '.', item) then begin
        HARM := HARM + 1;
        item^.CH := '@';
    end;
end;

procedure DESCRIBE;
begin
    case TGTPTR^.CH of
    '%':  WRITE('Лестница.');
    '*':  WRITE('Золото.');
    ',':  begin
              if FLOOR = 8 then begin
                  WRITE('Золотой шар!!!');
                  GAMEFLAGS := GAMEFLAGS + [HAVEORB];
              end else
                  WRITE('Волшебная кирка.');
          end;
    '$','+': WRITELN('Бутылка с надписью "Drink me!"');
    ' ':  BLKHOLE;
    '=':  WRITE('Кольцо.');
    '^':  JELLY;
    '#':  if LOOKATPLAYER then begin
             if RANDOM(1,2) = 1 then
                 MPTR^.CH := '!'
             else
                 MPTR^.CH := '-';
          end;
    '(',')': WRITE('Доспехи.');
    '[',']': WRITE('Оружие.');
    '?':     WRITE('Свисток.');
    ':',';': WRITE('Еда!!!');
    '\','/': WRITE('"ВП".');
    '<','>': WRITE('Батареи.');
    '"','''': MANGE;
    '&':    WRITE('Папирус.');
    'C','H','J','T':
          begin
              WRITE(CHR(7)); { bell }
              WRITELN('Холодная, скользкая рука схватила вас за ногу ...');
              IND[IEnergy]:=IND[IEnergy]-RANDOM(2,8); { Энергия уменьшается }
              TGTPTR^.CH := '.';
          end;
    'D','E','F','G','I','K','L','M','N','O','P','Q','R','S','U','V','W','X','Y','Z':
          DOMONSTER;
    '0','2','3','4','5','6','7','8','9','{','}':
          FOOD;
    '!','-','.':; { Стенки и пустая клетка } {L16046}
    'b':  WRITELN('Надпись "Здесь был Вася"(здесь Вася и остался)'); {L16046}
    'c':  WRITE('Груда камней.');
    'd':  WRITELN('Метла бабы яги (сломана)');
    'e':  WRITE('Череп.');
    'f':  WRITELN('Полуистлевший скелет');
    'g':  WRITELN('Сгоревшая плата процессора М2');
    'h':  WRITELN('Кусочек Ноева ковчега');
    'i':  WRITELN('Записка:" Авторы желают вам вернуться живым..."');
    'j':  WRITE('Черный ящик.');
    'k':  WRITELN('Лужа машинного масла');
    'l':  WRITELN('Дистрибут ОС "Holographyx V07" для ЭВМ PDP-12');
    'm':  WRITE('Дохлая крыса.');
    'n':  WRITE('Зуда.');
    'o':  WRITE('Пустышка.');
    'p':  WRITE('Куча сепулек.');
    'r':  WRITELN('Надпись "Здесь вы и останетесь!"');
    's':  WRITELN('Указатель: "Как, вы еще живы? ==> 158 М."');
    't':  WRITELN('Зачитанный журнал "Илектроникс энд уайрлесс уорлд(Радио)"');
    'u':  WRITELN('Журнал "Juzhnye Dewochky" за 21 апреля 1999 года');
    'v':  WRITE('Артефакт.');
    'w':  WRITELN('Надпись "Здесь-то мы его и съели"');
    'x':  WRITELN('Надпись "Привет Сивому"');
    'y':  WRITELN('Что-то очень мерзкое');
    'z':  WRITE('Следы пикника.');
    'q':  WRITELN('Останки предыдущего путешест...');
    '~':  WRITE('Черт-те что.');
    '1','A','B': WRITELN('Бродячий торговый автомат');
    '|':  WRITELN('Пережаренный зелюк.'); { Осциллограф "ИО-4Б" }
    '`':  WRITELN('Мышелот (в собственном соку)');
    '@':  GHOST;
    else begin {L17302}
            if LOOKATPLAYER then with MPTR^ do begin
                CH := CHR(RANDOM(32,126));
                FLAGS := RANDOM(1,8191);
            end else
                WRITELN('Мешок с надписью "Take me!"');
         end
    end; { case of }
end;

{ показать и обработать события в окрестности игрока }
procedure LOOKAROUND;
var
  y, x: integer;
begin
    for y := -1 to 1 do begin
        for x := -1 to 1 do begin
            LOOK.Y:=y;
            LOOK.X:=x;
            TGT.Y := PLR.Y + y; { новый Y }
            TGT.X := PLR.X + x; { новый X }
            UPDTGTPTR;    { update TGTPTR }
            DESCRIBE;
        end;
    end;
end;

{ хелп } {L34046}
procedure CMDHALP;
begin
    CLRSCR;
    WRITELN('Ладно, я кое-что подскажу. Итак: здесь творится черт знает что,');
    WRITELN('но на восьмом уровне лежит золотой шар. Только достав его, Вы');
    WRITELN('сможете выйти из подземелья, придя на то же место, откуда вы вышли');
    WRITELN('вначале. Своим глазам не всегда стоит доверять!');
    WRITELN(' Вы можете использовать команды:');
    WRITELN('A - Купить (на золото)');
    WRITELN('B - Заменить батареи');
    WRITELN('D - Выбросить предмет');
    WRITELN('E - Поесть');
    WRITELN('F - Приготовиться к сражению');
    WRITELN('H - HELP (этот текст)');
    WRITELN('I - Надеть кольцо');
    WRITELN('J - Обновить экран');
    WRITELN('K - Сломать стенку (киркой)');
    WRITELN('L - Включить фонарь');
    WRITELN('M - Приготовить оружие');
    WRITELN('N - Клавиша "Идет начальник" (отбой тревоги - "P")');
    WRITELN('O - Выключить фонарь');
    WRITELN('P - Надеть доспехи');
    WRITELN('Q - Пить');
    WRITELN('R - Читать папирус');
    WRITELN('S - Свистнуть');
    WRITELN('T - Взять предмет, на котором стоишь');
    WRITE('U - Вызвать джинна (только в безнадежном случае!)...    Дальше? ');
    READCHAR(TMPCHAR, FALSE);
    if TMPCHAR = CHR(13) then begin
        READCHAR(TMPCHAR, FALSE);
    end;
    WRITELN('');
    WRITELN('V - Снять кольцо');
    WRITELN('W - Взмахнуть волшебной палочкой');
    WRITELN('X - Закончить');
    WRITELN('Y - Зажарить убегающего зверя');
    WRITELN('Z - Перевести деньги в банк на счет пещеры.');
    WRITELN('/ - Переложить вещи в рюкзаке');
    WRITELN('   П Е Р Е Д В И Ж Е Н И Е:');
    WRITELN('');
    WRITELN('    7 8 9');
    WRITELN('    4   6   - Движение по уровню');
    WRITELN('    1 2 3');
    WRITELN('5 - Вниз по лестнице');
    WRITELN('. - Вверх по лестнице');
    WRITELN('0 - Отдыхать.');
    WRITELN('');
    WRITELN('Использовать можно лишь вещи, лежащие в рюкзаке.');
    WRITELN('Примечание:');
    WRITELN('    Волшебная кирка вынесет вас из "комариной плеши" при ударе ей вниз.');
    WRITELN('');
    WRITE('Ну, что, пойдем дальше? ');
    READCHAR(TMPCHAR, TRUE);
    if TMPCHAR = CHR(13) then begin
        READCHAR(TMPCHAR, TRUE);
    end;
    REFRESH('J'); { Обновить экран }
    IND[IRating]:=IND[IRating] - 2; { Рейтинг }
end;

{ показать объекты на карте, но не весь пол }
procedure SHOWOBJS;
var
    x, y: integer;
begin
    for y:=2 to 15 do begin {L21734}
        for x:=2 to 31 do begin
            if MAP[FLOOR,y,x].CH <> '.' then
                REVEAL(y,x);
        end;
    end;
end;

procedure FUNNYMAP;
var
    x, y: integer;
    tmp: char;
begin
    { print funny map }
    for y:=2 to 15 do begin
        for x:=2 to 31 do begin
            tmp := MAP[FLOOR, y, x].CH;
            if tmp <> '.' then begin
                if not (tmp in ['!','#','-']) then
                    tmp := CHR(RANDOM(ORD('!'),ORD('~')));
                WRITEAT(y, x, tmp);
            end;
        end;
    end;
end;

{ заглотить зелье }
procedure CMDQUAFF;
var
    y: integer;
    item: PTile;
begin { пить }
    if INVGET('$', '+', item) then begin
        USEITEM(item);
        HARM:=HARM - 1;
        case item^.FLAGS & 6 of
        0:  begin
                FUNNYMAP;
                CLEARMSG;
            end;
        2:  begin
                IND[IEnergy]:=IND[IEnergy]+20; { выпил }
                TIRED:=0;
                WRITELN('Чувствуете прилив сил?'); {L21654}
            end;
        4:  begin
                SHOWOBJS;
                CLEARMSG;
            end;
        6:  begin
                DRUNK:=20; {L22404}
                WRITELN('Напился - сдай стеклотару!!!!');
            end;
        end;
    end else
        WRITELN('Пить нечего');
end;

procedure WIPEMONSTERS;
var
    i: integer;
begin
    for i := 1 to 4 do
      MONSTERS[i].TILE.CH := ' ';
end;

{ свистнуть }
procedure CMDSIFFLER;
var
    y, x: integer;
    item: PTile;
    pc: ^char;
begin
    { Ищем в рюкзаке свисток }
    if INVGET('?', '?', item) then begin
        case item^.FLAGS & 6 of
        4:  WRITE(CHR(7)); { bell }
        2:  begin
                for y := -2 to 2 do begin
                    for x := -2 to 2 do begin
                        if INFIELD(PLR.Y + y, PLR.X + x) then
                            MAP[FLOOR,PLR.Y + y,PLR.X + x].CH := ' ';
                    end;
                end;
                USEITEM(item);
            end;
        0:  begin
                WRITELN('Б А М - М - М ! ! !');
                MOVEPLAYER(RANDOM(2,15), RANDOM(2,31));
            end;
        6:  begin
                WRITELN('Уничтожение зверя');
                WIPEMONSTERS;
                for y := -1 to 1 do
                    for x := -1 to 1 do begin
                        pc := ADDR(MAP[FLOOR, PLR.Y + y, PLR.X + x].CH);
                        if pc^ in ['A'..'Z'] then pc^ := '*';
                    end;
            end;
        end;
    end else
        WRITELN('Однако, свисток нужен');
end;

{ выбросить предмет }
procedure CMDDROP;
var
    item: PTile;
begin
    WRITE('Что выбросить? ');
    READCHAR(TMPCHAR, FALSE);
    CLEARMSG;
    if (TMPCHAR <> '.') and INVGET(TMPCHAR, TMPCHAR, item) then begin
        if NOTCURSED(item^) then begin
            { из плеши нельзя выбраться выбросив в нее барахло }
            if not (MPTR^.CH in ['"','''']) then
                MPTR^ := item^;
            HARM := HARM - 1;
            USEITEM(item);
        end else
            ZAKLYATIE;
    end else
        WRITELN('Нету');
end;

{ поесть }
procedure CMDEAT;
var
    item: PTile;
begin
    if INVGET(':', ';', item) then begin
        IND[IEnergy] := IND[IEnergy] + 18; { Энергия }
        USEITEM(item);
        HARM := HARM - 1;
        WRITELN('Спасибо!');
    end else
        WRITELN('Еды нет');
end;

{ взять предмет, на котором стоишь }
procedure CMDTAKE;
var
    item: PTile;
begin
    { Ищем место в рюкзаке }
    if INVGET('.', '.', item) then begin
        if MPTR^.CH in ['"',''''] then
            NELZYA { Комариную плешь брать нельзя }
        else begin
            WRITELN('Берем');
            HARM := HARM + 1;
            item^ := MPTR^;
            MPTR^.CH := '.';
            GAMEFLAGS := GAMEFLAGS + [DRAWSACK];
        end;
    end else
        WRITELN('Рюкзак полон');
end;

{ перевести деньги в банк на счёт пещеры } {L23010}
procedure CMDWIRE;
var
    item: PTile;
begin
    if INVGET('*', '*', item) then begin
        IND[IRating] := IND[IRating] + 1;
        HARM := HARM - 1;
        USEITEM(item);
        IND[IGold] := IND[IGold] + RANDOM(10, 70);
        WRITELN('Там!');
    end else
        WRITELN('Где золото-тo?');
end;

{ надеть доспехи }
procedure CMDWEAR;
var
    item: PTile;
begin
    if INVGET(')', '(', item) then begin
        if NOTCURSED(item^) then begin
            USEITEM(item);
            IND[IArmor] := IND[IArmor] + 11;
            WRITELN('Доспехи надеты');
        end else
            ZAKLYATIE;
    end else
        WRITELN('Нету');
end;

procedure SHOWMAP;
var
    x, y: integer;
begin
    for x := 2 to 31 do
        for y := 2 to 15 do
            REVEAL(y, x);
end;

{ взмахнуть волшебной палочкой }
procedure CMDZAP;
var
    item: PTile;
    i: integer;
begin
    if INVGET('/', '\', item) then begin
        case item^.FLAGS & 3 of
        3:  WRITELN('Выпустили до госприемки...');
        2:  begin
                SHOWMAP;
                USEITEM(item);
                CLEARMSG;
                WRITELN('"Да будет свет..."');
            end;
        1:  begin
                if HAVEORB in GAMEFLAGS then begin
                    FLOOR := FLOOR - 3;
                    if FLOOR < 0 then FLOOR := 0;
                end else begin
                    FLOOR := FLOOR+3;
                    if FLOOR > 8 then FLOOR := 8;
                end;
                USEITEM(item);
                REFRESH('J');
                WRITELN('Пока Вы летели сквозь этажи, "ВП" потерялась');
                HARM := HARM - 1;
            end;
        0:  begin
                WRITELN('Превращение догоняющего зверя');
                for i := 1 to 3 do with MONSTERS[i] do
                    if TILE.CH <> ' ' then begin
                        TILE.CH := ' ';
                        MAP[FLOOR,Y,X].CH := CHR(RANDOM(ord('$'),ord('?')));
                    end;
            end;
        end;
    end else
        WRITELN('Махать-то нечем !');
end;

{ включить фонарь }
procedure CMDLANTERN(on: boolean);
begin
    if on then begin
        if BCHARGE > 0 then begin
            GAMEFLAGS := GAMEFLAGS + [LAMPON];
            WRITELN('Фонарь включен');
        end else
            WRITELN('Батареи сели.Надо было экономить ... ');
    end
    else begin { выключить фонарь }
        GAMEFLAGS := GAMEFLAGS - [LAMPON];
        WRITELN('Фонарь выключен');
    end;
end;

procedure LOCATE(L: integer; WHAT: char; var Y, X: integer);
var
    mx, my: integer;
begin
    Y := -1;
    X := -1;

    for my := 2 to 15 do
        for mx := 2 to 31 do
            if MAP[L, my, mx].CH = WHAT then
            begin
                Y := my;
                X := mx;
                EXIT;
            end;
end;

procedure LOCATESTAIRS;
var
    mx, my: integer;
begin
    LOCATE(FLOOR, '%', my, mx);
    WRITELN('Лестница -', my:4, mx:4);
end;

procedure LOCATEORB;
var
    mx, my: integer;
begin
    LOCATE(8, ',', my, mx);
    if my = -1 then
        WRITELN('Золотой шар украден!')
    else
        WRITELN('Золотой шар - 8', my:4, mx:4);
end;

{ читать папирус }
procedure CMDREAD;
var
    item: PTile;
begin
    if INVGET('&', '&', item) then
        case item^.FLAGS & 6 of
        0:  LIFTCURSE;
        2:  WRITELN('Надпись гласит: "Сам дурак"');
        4:  LOCATESTAIRS;
        6:  LOCATEORB;
        end
    else
        WRITELN('А читать-то и нечего');
end;

{ сломать стенку киркой }
procedure CMDDIG;
var
    mx, my: integer;
    item: PTile;
begin
    if INVGET(',', ',', item) then begin
        WRITE('Направление? ');
        READCHAR(TMPCHAR, FALSE);
        CLEARMSG;
        my := PLR.Y;
        mx := PLR.X;
        case TMPCHAR of
        '1':  begin my := PLR.Y + 1; mx := PLR.X - 1; end;
        '2':  my := PLR.Y + 1;
        '3':  begin my := PLR.Y + 1; mx := PLR.X + 1; end;
        '4':  mx := PLR.X - 1;
        '5':  MPTR^.CH := ' ';
        '6':  mx := PLR.X + 1;
        '7':  begin my := PLR.Y - 1; mx := PLR.X - 1; end;
        '8':  my := PLR.Y - 1;
        '9':  begin my := PLR.Y - 1; mx := PLR.X + 1; end;
        '.':  if FLOOR > 0 then begin
                  MAP[FLOOR-1,PLR.Y,PLR.X].CH := ' ';
                  WRITELN('Кусок свода обрушился и раскололся о вашу глупую голову');
              end;
        else
            NELZYA
        end;

        if INFIELD(my, mx) and WALL(MAP[FLOOR,my,mx].CH) then begin
            MAP[FLOOR,my,mx].CH := 'c';
            IND[IEnergy] := IND[IEnergy] - 1;
        end else
            WRITELN('Ну, чего размахался?');
    end
    else
        WRITELN('А стенку вы будете лбом прошибать?..');
end;

{ вызвать джинна }
procedure CMDGENIE;
var
    i: integer;
    z: integer;
begin
    if not (HAVEORB in GAMEFLAGS) then begin
        WRITELN('Что, влип? ладно, попробую тебя  перенести');
        WRITELN('отсюда. только дороговато это встанет...');
        WRITE('Ты готов? ');
        READCHAR(TMPCHAR, TRUE);
        if TMPCHAR <> 'N' then begin
            for i := IRating to IGold do
                IND[i] := IND[i] - RANDOM(0,15);

            SACKRESET(false); { clear sack, do not change item flags }

            z := RANDOM(0, 8);
            if z > FLOOR then
                z := FLOOR;
            FLOOR := z;
            MOVEPLAYER(RANDOM(2,15), RANDOM(2,31));
            REFRESH('J'); { Обновить экран }
        end;
    end else
        WRITELN('Джинн в отгуле');
end;

{ купить (на золото) }
procedure CMDBUY;
var
    item: PTile;
begin
    if MPTR^.CH in ['1','A','B'] then begin
        if IND[IGold] > 0 then begin  { В банке есть деньги? }
            WRITE('Чего изволите?');
            READCHAR(TMPCHAR, FALSE);
            if INVGET('.', '.', item) then begin
                item^.CH := TMPCHAR;
                item^.FLAGS := RANDOM(1, 8191) & CURSEDNOT;
                IND[IGold] := IND[IGold] - RANDOM(10, 250);
                TERMCR;
                WRITELN('П о л у ч и т е !');
                MPTR^.CH := 'k';
            end;
        end else
            WRITELN('Подаю только по пятницам!');
    end else
        WRITELN('Подойди ближе к автомату!');
end;

{ заменить батареи }
procedure CMDBATT;
var
    item: PTile;
begin
    if INVGET('<', '>', item) then begin
        if NOTCURSED(item^) then begin
            USEITEM(item);
            HARM := HARM - 1;
            BCHARGE := 400;
            WRITELN('Батареи заменены');
        end else
            ZAKLYATIE;
    end else
        WRITELN('Батарей нет');
end;

procedure CMDRING(on: boolean);
var
    item: PTile;
begin
    if on then begin { надеть кольцо }
        if INVGET('=', '=', item) then begin
            if NOTCURSED(item^) then begin
                USEITEM(item);
                WRITELN('Силовое поле включено!');
                GAMEFLAGS := GAMEFLAGS + [RING];
            end else
                ZAKLYATIE;
        end else
            WRITELN('Нету');
    end
    else begin { снять кольцо }
        if RING in GAMEFLAGS then begin
            if INVGET('.', '.', item) then begin
                item^.CH := '=';
                item^.FLAGS := CURSED;
                GAMEFLAGS := GAMEFLAGS - [RING] + [DRAWSACK];
            end else
                WRITELN('Рюкзак полон');
        end else
            WRITELN('Кольца нет');
    end;
end;

{ приготовить оружие }
procedure CMDWIELD;
var
    item: PTile;
begin
    if INVGET('[', ']', item) then begin
        if NOTCURSED(item^) then begin
            USEITEM(item);
            IND[IWeapon] := IND[IWeapon] + 15;
            WRITELN('Оружие приготовлено');
        end else
            ZAKLYATIE;
    end else
        WRITELN('Нету!');
end;

{ зажарить убегающего зверя }
{ NB: бродячие торговые автоматы A и B, если их флаги соответствуют,
      тоже можно зажарить }
procedure CMDCOOK;
begin
    if ((MPTR^.FLAGS & 6) = 2) and (MPTR^.CH in ['A'..'Z']) then
        MPTR^.CH := ':' { Зверь становится едой }
    else
        NELZYA;
end;

{ преследование игрока монстрами }
procedure MONSTCHASE;
var
    i: integer;
    newx, newy: integer;
begin
    for i := 1 to 4 do with MONSTERS[i] do begin
        if (TILE.CH <> ' ') and ((Y <> PLR.Y) or (X <> PLR.X)) then begin
            newy := Y;
            newx := X;

            if PLR.Y > Y then
                newy := Y + 1
            else if PLR.Y < Y then
                newy := Y - 1;

            if PLR.X > X then
                newx := X + 1
            else if PLR.X < X then
                newx := X - 1;

            { зверь расшибается об стенку }
            if WALL(MAP[FLOOR,newy,newx].CH) and ((TILE.FLAGS & 6) = 4) then
                TILE.CH := ' '
            else begin
                { зверь все сносит на своем пути }
                MAP[FLOOR, Y, X].CH := '.';
                WRITEAT(Y, X, '.');
                WRITEAT(newy, newx, TILE.CH);
                MAP[FLOOR, newy, newx] := TILE;
                Y := newy;
                X := newx;
                CURSORTO(18, 0);
                CLREOL;
            end;
        end;
    end;
end;

function CHKENERGY: boolean;
begin
    CHKENERGY := TRUE;
    if IND[IEnergy] < 0 then begin { Умер от недостатка Энергии }
        WRITE(' Вот Вы и стали', RANDOM(10,1000):4, '-ой жертвой этого подземелья.');
        CHKENERGY := FALSE; { ded x_X }
    end;
end;

function CHKEXIT: integer;
begin
    CHKEXIT := 0;
    if (FLOOR = 0) and (HAVEORB in GAMEFLAGS) and
        (PLR.Y = 2) and (PLR.X = 2) then begin

        if IND[IGold] >= 0 then begin { В банке есть деньги? }
            WRITELN('Как, Вы вернулись?! Ну и ну !!!');
            WRITE('А дальше пойдете? ');
            READCHAR(TMPCHAR, TRUE);
            if TMPCHAR = 'Y' then begin
                DUNGEON := DUNGEON + 1; { следующее подземелье }
                IND[IRating] := IND[IRating] + 50; { Рейтинг }
                CHKEXIT := 1; { Рестарт игры }
            end
            else
                CHKEXIT := 2; { Выходим из игрового цикла }
        end else
            WRITELN('А расплачиваться кто будет?');
    end;
end;

{ Расчёт счёта игрока }
procedure ENDSCORE;
var
    score: integer;
begin
    score := IND[IRating] + ((IND[IEnergy] + IND[IWeapon] + IND[IArmor] +
        IND[IGold] div 5) div 3);
    WRITELN('Ваш счет -', score:5);
end;

procedure DRUNKWALK;
var
    y, x: integer;
begin
    if DRUNK > 0 then begin
        y := PLR.Y + RANDOM(-1, 1);
        x := PLR.X + RANDOM(-1, 1);
        if INFIELD(y, x) then begin
            MOVEPLAYER(y, x);
            DRUNK := DRUNK - 1;
        end;
    end;
end;

procedure HANDLECMD(var STATE: TState);
begin
    case TMPCHAR of
    '1': WALK(1,-1);   { влево-вниз }
    '2': WALK(1,0);    { вниз }
    '3': WALK(1,1);    { вправо-вниз }
    '4': WALK(0,-1);   { влево }
    '5': REFRESH('5'); { вниз по лестнице }
    '6': WALK(0,1);    { вправо }
    '7': WALK(-1,-1);  { влево-вверх }
    '8': WALK(-1,0);   { вверх }
    '9': WALK(-1,1);   { вправо-вверх }
    '0': TIRED := 0;   { отдохнуть }
    '.': REFRESH('.'); { вверх по лестнице }
    'Q': CMDQUAFF;
    'D': CMDDROP;
    'Z': CMDWIRE;
    'S': CMDSIFFLER;
    'E': CMDEAT;
    'T': CMDTAKE;
    'P': CMDWEAR;
    'L': CMDLANTERN(true);
    'O': CMDLANTERN(false);
    'W': CMDZAP;
    '/','?': CMDPACK;
    'F':begin { приготовиться к сражению }
            GAMEFLAGS := GAMEFLAGS + [FIGHTING];
            WRITELN('У-р-р-р-а-a ! ! !');
        end;
    'N':begin { идёт начальник }
            { игнорируем }
        end;
    'X':begin { закончить }
            WRITE('Закончить изволите? ');
            READCHAR(TMPCHAR, TRUE);
            if TMPCHAR in ['D','Y'] then begin
                WRITELN('А ведь предупреждали...');
                STATE := SQuit;
            end;
        end;
    'M': CMDWIELD;
    'B': CMDBATT;
    'J': REFRESH('J'); { обновить экран }
    'R': CMDREAD;
    'I': CMDRING(true);
    'V': CMDRING(false);
    'A': CMDBUY;
    'K': CMDDIG;
    'Y': CMDCOOK;
    'H': CMDHALP;
    'U': CMDGENIE;
    else
        WRITELN('Что-что?')
    end;
end;

procedure GAMELOOP;
var
    state: TState;
begin
    WRITELN(' ^_^_^_^  __ С Т А Л К Е Р __       ');
    WRITE('загадайте число. может быть, оно вам пригодится... там... ');
    READLN(SEED);{ Ввод числа, которое "может быть пригодится там" }
    DUNGEON := 1; { Подземелье = 1 }

    repeat
        state := SCont;
        RESTART;

        (* MAP[0,5,4].FLAGS := 2; 42: жарить торговый автомат *)

        { Начало игрового цикла }
        while state = SCont do begin
            { обработать все, что под игроком и вокруг:
              LOOKAROUND -> DESCRIBE -> (BLKHOLE,JELLY,MANGE,DOMONSTER,FOOD,*)
            }
            LOOKAROUND;

            { нарисовать окрестность игрока и самого игрока }
            DRWAROUND;

            { восстановить предыдущую позицию }
            if (PREV.Y <> PLR.Y) or (PREV.X <> PLR.X) then
                WRITEAT(PREV.Y, PREV.X, MAP[FLOOR, PREV.Y, PREV.X].CH);
            PREV := PLR;

            CURSORTO(1,0);
            WRITE(FLOOR:3);

            { изобразить индикаторы }
            DRWINDVAL;

            { изобразить рюкзак }
            DRWRUKSAK;

            { Ввод символа - команда игрока }
            CURSORTO(0,0);
            READCHAR(TMPCHAR, TRUE);
            CLEARMSG;
            HANDLECMD(state);

            if state = SQuit then
                EXIT;

            DRUNKWALK;

            STEPCTR := STEPCTR + ((IND[IWeapon] + IND[IArmor]) div 10);
            if STEPCTR > 200 then begin
                STEPCTR := 0;
                IND[IRating] := IND[IRating] + 1;
                IND[IEnergy] := IND[IEnergy] - 1;
            end;

            if IND[IEnergy] < 5 then
                WRITELN('Силы на исходе');

            if IND[IEnergy] > 50 then IND[IEnergy]:=50;

            if LAMPON in GAMEFLAGS then begin
                BCHARGE := BCHARGE - 1; { Уменьшаем заряд батарей }
                if (BCHARGE > 1) and (BCHARGE < 10) then
                    WRITELN('Фонарь гаснет');

                if BCHARGE = 1 then begin
                    IND[IRating] := IND[IRating] - 1;
                    GAMEFLAGS := GAMEFLAGS - [LAMPON]; { Фонарь не горит }
                    BCHARGE:=0; { Заряд батарей }
                end;
            end;

            TIRED := TIRED + HARM;
            if TIRED > 200 then
                WRITELN('Отдохнуть-бы');
            if TIRED > 215 then begin { Слишком устал }
                IND[IEnergy] := IND[IEnergy] - 3;
                TIRED:=50;
            end;

            MONSTCHASE;

            if not CHKENERGY then
                state := SQuit
            else
            case CHKEXIT of
                1: state := SRestart;
                2: state := SQuit;
            end;
        end;
    until state = SQuit;
end;

(*
procedure TETS;
var
    x, y: integer;
begin
    RSTRT_A;

    WRITELN;
    for y := 1 to 16 do begin
        for x := 1 to 32 do begin
            WRITE(MAP[0,y,x].CH:2);
        end;
        WRITELN;
    end;

    INLINE($76);
end;

procedure TEST;
var i: integer;
begin
    for i := 0 to 20 do WRITELN(RANDOM(-1,1));
end;
*)

BEGIN
    GAMELOOP;
    ENDSCORE;
END.
