unit Int2txt;

interface

procedure Int2Str(I: Integer; var Text: string; var Last: Integer; B: Boolean);
function I2S(i: Integer; var Last: Integer; B: Boolean): string;
function Num2str(D: Double; Rub, Kop: string): string;
procedure Int2StrU(I: Integer; var Text: string; var Last: Integer; B: Boolean);
function I2SU(i: Integer; var Last: Integer; B: Boolean): string;
function Num2strU(D: Double; Rub, Kop: string): string;
function DateStr(Dat: TDateTime): string;

implementation

uses
  SysUtils, WinProcs;

procedure Int2Str(I: Integer; var Text: string; var Last: Integer; B: Boolean);
var
  i1, i2, i3, R1, R2: Integer;
begin
  if I = 0 then
  begin
    Text := 'ноль';
    Exit;
  end;
  Text := '';
  Last := 0;
  i1 := i div 100;
  R1 := i - i1 * 100;
  i2 := R1 div 10;
  R2 := R1 - i2 * 10;
  i3 := R2;
  Last := R2;
  case I1 of
    0: Text := Text + '';
    1: Text := Text + 'сто ';
    2: Text := Text + 'двести ';
    3: Text := Text + 'триста ';
    4: Text := Text + 'четыреста ';
    5: Text := Text + 'п€тьсот ';
    6: Text := Text + 'шестьсот ';
    7: Text := Text + 'семьсот ';
    8: Text := Text + 'восемьсот ';
    9: Text := Text + 'дев€тьсот ';
  end;

  if (R1 <= 19) and (R1 >= 11) then
  begin
    Last := R1;
    case R1 of
      0: Text := Text + '';
      11: Text := Text + 'одиннадцать';
      12: Text := Text + 'двенадцать';
      13: Text := Text + 'тринадцать';
      14: Text := Text + 'четырнадцать';
      15: Text := Text + 'п€тнадцать';
      16: Text := Text + 'шестнадцать';
      17: Text := Text + 'семнадцать';
      18: Text := Text + 'восемьнадцать';
      19: Text := Text + 'дев€тнадцать';
    end;
    Exit;
  end
  else
  begin
    case i2 of
      1: Text := Text + 'дес€ть ';
      2: Text := Text + 'двадцать ';
      3: Text := Text + 'тридцать ';
      4: Text := Text + 'сорок ';
      5: Text := Text + 'п€тьдес€т ';
      6: Text := Text + 'шестьдес€т ';
      7: Text := Text + 'семьдес€т ';
      8: Text := Text + 'восемьдес€т ';
      9: Text := Text + 'дев€носто ';
    end;
  end;

  if (i3 = 1) and B then
    Text := Text + 'один';
  if (i3 = 1) and not B then
    Text := Text + 'однa';
  if (i3 = 2) and B then
    Text := Text + 'два';
  if (i3 = 2) and not B then
    Text := Text + 'две';
  case i3 of
    3: Text := Text + 'три';
    4: Text := Text + 'четыре';
    5: Text := Text + 'п€ть';
    6: Text := Text + 'шесть';
    7: Text := Text + 'семь';
    8: Text := Text + 'восемь';
    9: Text := Text + 'дев€ть';
  end;
end;
{***********************************************}

function I2S(i: Integer; var Last: Integer; B: Boolean): string;
var
  S: string;
begin
  Int2str(i, S, Last, B);
  I2S := S;
end;
{***********************************************}

function Num2Str(D: Double; Rub, Kop: string): string;
var //i, j, k : Longint;
  Code: Integer;
  j1, j2, j3, j4, j5, Lasts: Integer;
  Res, S, S1, Text: string;
  C: array[0..250] of Char;
  StrCur: string;
begin
  Str(D: 18: 2, Res);
  S := copy(Res, 1, 3);
  Val(S, j5, Code);
  S := copy(Res, 4, 3);
  Val(S, j4, Code);
  S := copy(Res, 7, 3);
  Val(S, j3, Code);
  S := copy(Res, 10, 3);
  Val(S, j2, Code);
  S := copy(Res, 13, 3);
  Val(S, j1, Code);

  Text := '';
  if j5 <> 0 then
  begin
    S1 := I2S(j5, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' триллионов '
    else if Lasts = 1 then
      S1 := S1 + ' триллион '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' триллиона ';
    Text := Text + S1;
  end;

  if j4 <> 0 then
  begin
    S1 := I2S(j4, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' миллиардов '
    else if Lasts = 1 then
      S1 := S1 + ' миллиард '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' миллиарда ';
    Text := Text + S1;
  end;

  if j3 <> 0 then
  begin
    S1 := I2S(j3, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' миллионов '
    else if Lasts = 1 then
      S1 := S1 + ' миллион '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' миллиона ';
    Text := Text + S1;
  end;

  if j2 <> 0 then
  begin
    Str(j2: 3, Res);
    if ((Res[3] = '1') or (Res[3] = '2')) then
      S1 := I2S(j2, Lasts, False)
    else
      S1 := I2S(j2, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' тыс€ч '
    else if Lasts = 1 then
      S1 := S1 + ' тыс€ча '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' тыс€чи ';
    Text := Text + S1;
  end;

  if j1 <> 0 then
  begin
    S1 := I2S(j1, Lasts, True);
    Text := Text + S1;
  end;
  case Lasts of
    1: strcur := ' гривна ';
    2..4: strcur := ' гривны ';
    0, 5..19: strcur := ' гривен ';
  end; {case}
  Text := Text + strcur;
  Res := Text;

  j1 := Round(100 * Frac(D));
  Text := Text + IntTostr(J1);
  Res := Text + Kop;
  StrPCopy(C, Res);
  AnsiUpperBuff(C, 1);
  Res := StrPas(C);
  Num2str := Res;
end;

procedure Int2StrU(I: Integer; var Text: string; var Last: Integer; B: Boolean);
// —умма прописью на украинском €зыке
var
  i1, i2, i3, R1, R2: Integer;
begin
  if I = 0 then
  begin
    Text := 'нуль';
    Exit;
  end;
  Text := '';
  Last := 0;
  i1 := i div 100;
  R1 := i - i1 * 100;
  i2 := R1 div 10;
  R2 := R1 - i2 * 10;
  i3 := R2;
  Last := R2;
  case I1 of
    0: Text := Text + '';
    1: Text := Text + 'сто ';
    2: Text := Text + 'двiстi ';
    3: Text := Text + 'триста ';
    4: Text := Text + 'чотириста ';
    5: Text := Text + 'п''€тсот ';
    6: Text := Text + 'шiстсот ';
    7: Text := Text + 'сiмсот ';
    8: Text := Text + 'вiсiмсот ';
    9: Text := Text + 'дев''€тсот ';
  end;

  if (R1 <= 19) and (R1 >= 11) then
  begin
    Last := R1;
    case R1 of
      0: Text := Text + '';
      11: Text := Text + 'одинадц€ть';
      12: Text := Text + 'дванадц€ть';
      13: Text := Text + 'тринадц€ть';
      14: Text := Text + 'чотирнадц€ть';
      15: Text := Text + 'п''€тнадц€ть';
      16: Text := Text + 'шiстнадц€ть';
      17: Text := Text + 'сiмнадц€ть';
      18: Text := Text + 'вiсiмнадц€ть';
      19: Text := Text + 'дев''€тнадц€ть';
    end;
    Exit;
  end
  else
  begin
    case i2 of
      1: Text := Text + 'дес€ть ';
      2: Text := Text + 'двадц€ть ';
      3: Text := Text + 'тридц€ть ';
      4: Text := Text + 'сорок ';
      5: Text := Text + 'п''€тдес€т ';
      6: Text := Text + 'шiстдес€т ';
      7: Text := Text + 'сiмдес€т ';
      8: Text := Text + 'вiсiмдес€т ';
      9: Text := Text + 'дев''€носто ';
    end;
  end;

  if (i3 = 1) and B then
    Text := Text + 'одна';
  if (i3 = 1) and not B then
    Text := Text + 'однa';
  if (i3 = 2) and B then
    Text := Text + 'два';
  if (i3 = 2) and not B then
    Text := Text + 'двi';
  case i3 of
    3: Text := Text + 'три';
    4: Text := Text + 'чотири';
    5: Text := Text + 'п''€ть';
    6: Text := Text + 'шiсть';
    7: Text := Text + 'сiм';
    8: Text := Text + 'вiсiм';
    9: Text := Text + 'дев''€ть';
  end;
end;
{***********************************************}

function I2SU(i: Integer; var Last: Integer; B: Boolean): string;
var
  S: string;
begin
  Int2strU(i, S, Last, B);
  I2SU := S;
end;
{***********************************************}

function Num2strU(D: Double; Rub, Kop: string): string;

var //i, j, k : Longint;
  Code: Integer;
var
  j1, j2, j3, j4, j5, Lasts: Integer;
var
  Res, S, S1, Text: string;
var
  C: array[0..250] of Char;
var
  StrCur: string;
begin
  Str(D: 18: 2, Res);
  S := copy(Res, 1, 3);
  Val(S, j5, Code);
  S := copy(Res, 4, 3);
  Val(S, j4, Code);
  S := copy(Res, 7, 3);
  Val(S, j3, Code);
  S := copy(Res, 10, 3);
  Val(S, j2, Code);
  S := copy(Res, 13, 3);
  Val(S, j1, Code);

  Text := '';
  if j5 <> 0 then
  begin
    S1 := I2SU(j5, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' трильйонiв '
    else if Lasts = 1 then
      S1 := S1 + ' трильйон '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' трильйони ';
    Text := Text + S1;
  end;

  if j4 <> 0 then
  begin
    S1 := I2SU(j4, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' мiллiардiв '
    else if Lasts = 1 then
      S1 := S1 + ' мiллiард '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' мiллiарди ';
    Text := Text + S1;
  end;

  if j3 <> 0 then
  begin
    S1 := I2SU(j3, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' мiллiонiв '
    else if Lasts = 1 then
      S1 := S1 + ' мiллiон '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' мiллiони ';
    Text := Text + S1;
  end;

  if j2 <> 0 then
  begin
    Str(j2: 3, Res);
    if ((Res[3] = '1') or (Res[3] = '2')) then
      S1 := I2SU(j2, Lasts, False)
    else
      S1 := I2SU(j2, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' тис€ч '
    else if Lasts = 1 then
      S1 := S1 + ' тис€ча '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' тис€чi ';
    Text := Text + S1;
  end;

  if j1 <> 0 then
  begin
    S1 := I2SU(j1, Lasts, True);
    Text := Text + S1;
  end;

  case Lasts of
    1: strcur := ' гривн€ ';
    2..4: strcur := ' гривнi ';
    0, 5..19: strcur := ' гривень ';
  end; {case}
  Text := Text + strcur;
  Res := Text;

  j1 := Round(100 * Frac(D));
  Text := Text + IntTostr(J1);
  Res := Text + Kop;
  StrPCopy(C, Res);
  AnsiUpperBuff(C, 1);
  Res := StrPas(C);
  Num2strU := Res;
end;

function DateStr(Dat: TDateTime): string;
var
  Y, M, D: Word;
  MN: string;
begin
  DecodeDate(Dat, Y, M, D);
  case M of
    1: MN := 'сiчн€';
    2: MN := 'лютого';
    3: MN := 'березн€';
    4: MN := 'квiтн€';
    5: MN := 'травн€';
    6: MN := 'червн€';
    7: MN := 'липн€';
    8: MN := 'серпн€';
    9: MN := 'вересн€';
    10: MN := 'жовтн€';
    11: MN := 'листопада';
    12: MN := 'грудн€';
  end;
  Result := IntToStr(D) + ' ' + MN + ' ' + IntTostr(Y) + ' р.';
end;
{***********************************************}

end.
