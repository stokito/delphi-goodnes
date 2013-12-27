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
    Text := '����';
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
    1: Text := Text + '��� ';
    2: Text := Text + '������ ';
    3: Text := Text + '������ ';
    4: Text := Text + '��������� ';
    5: Text := Text + '������� ';
    6: Text := Text + '�������� ';
    7: Text := Text + '������� ';
    8: Text := Text + '��������� ';
    9: Text := Text + '��������� ';
  end;

  if (R1 <= 19) and (R1 >= 11) then
  begin
    Last := R1;
    case R1 of
      0: Text := Text + '';
      11: Text := Text + '�����������';
      12: Text := Text + '����������';
      13: Text := Text + '����������';
      14: Text := Text + '������������';
      15: Text := Text + '����������';
      16: Text := Text + '�����������';
      17: Text := Text + '����������';
      18: Text := Text + '�������������';
      19: Text := Text + '������������';
    end;
    Exit;
  end
  else
  begin
    case i2 of
      1: Text := Text + '������ ';
      2: Text := Text + '�������� ';
      3: Text := Text + '�������� ';
      4: Text := Text + '����� ';
      5: Text := Text + '��������� ';
      6: Text := Text + '���������� ';
      7: Text := Text + '��������� ';
      8: Text := Text + '����������� ';
      9: Text := Text + '��������� ';
    end;
  end;

  if (i3 = 1) and B then
    Text := Text + '����';
  if (i3 = 1) and not B then
    Text := Text + '���a';
  if (i3 = 2) and B then
    Text := Text + '���';
  if (i3 = 2) and not B then
    Text := Text + '���';
  case i3 of
    3: Text := Text + '���';
    4: Text := Text + '������';
    5: Text := Text + '����';
    6: Text := Text + '�����';
    7: Text := Text + '����';
    8: Text := Text + '������';
    9: Text := Text + '������';
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
      S1 := S1 + ' ���������� '
    else if Lasts = 1 then
      S1 := S1 + ' �������� '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' ��������� ';
    Text := Text + S1;
  end;

  if j4 <> 0 then
  begin
    S1 := I2S(j4, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' ���������� '
    else if Lasts = 1 then
      S1 := S1 + ' �������� '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' ��������� ';
    Text := Text + S1;
  end;

  if j3 <> 0 then
  begin
    S1 := I2S(j3, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' ��������� '
    else if Lasts = 1 then
      S1 := S1 + ' ������� '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' �������� ';
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
      S1 := S1 + ' ����� '
    else if Lasts = 1 then
      S1 := S1 + ' ������ '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' ������ ';
    Text := Text + S1;
  end;

  if j1 <> 0 then
  begin
    S1 := I2S(j1, Lasts, True);
    Text := Text + S1;
  end;
  case Lasts of
    1: strcur := ' ������ ';
    2..4: strcur := ' ������ ';
    0, 5..19: strcur := ' ������ ';
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
// ����� �������� �� ���������� �����
var
  i1, i2, i3, R1, R2: Integer;
begin
  if I = 0 then
  begin
    Text := '����';
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
    1: Text := Text + '��� ';
    2: Text := Text + '��i��i ';
    3: Text := Text + '������ ';
    4: Text := Text + '��������� ';
    5: Text := Text + '�''����� ';
    6: Text := Text + '�i����� ';
    7: Text := Text + '�i���� ';
    8: Text := Text + '�i�i���� ';
    9: Text := Text + '���''����� ';
  end;

  if (R1 <= 19) and (R1 >= 11) then
  begin
    Last := R1;
    case R1 of
      0: Text := Text + '';
      11: Text := Text + '����������';
      12: Text := Text + '����������';
      13: Text := Text + '����������';
      14: Text := Text + '������������';
      15: Text := Text + '�''���������';
      16: Text := Text + '�i���������';
      17: Text := Text + '�i��������';
      18: Text := Text + '�i�i��������';
      19: Text := Text + '���''���������';
    end;
    Exit;
  end
  else
  begin
    case i2 of
      1: Text := Text + '������ ';
      2: Text := Text + '�������� ';
      3: Text := Text + '�������� ';
      4: Text := Text + '����� ';
      5: Text := Text + '�''������� ';
      6: Text := Text + '�i������� ';
      7: Text := Text + '�i������ ';
      8: Text := Text + '�i�i������ ';
      9: Text := Text + '���''������ ';
    end;
  end;

  if (i3 = 1) and B then
    Text := Text + '����';
  if (i3 = 1) and not B then
    Text := Text + '���a';
  if (i3 = 2) and B then
    Text := Text + '���';
  if (i3 = 2) and not B then
    Text := Text + '��i';
  case i3 of
    3: Text := Text + '���';
    4: Text := Text + '������';
    5: Text := Text + '�''���';
    6: Text := Text + '�i���';
    7: Text := Text + '�i�';
    8: Text := Text + '�i�i�';
    9: Text := Text + '���''���';
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
      S1 := S1 + ' ��������i� '
    else if Lasts = 1 then
      S1 := S1 + ' �������� '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' ��������� ';
    Text := Text + S1;
  end;

  if j4 <> 0 then
  begin
    S1 := I2SU(j4, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' �i��i���i� '
    else if Lasts = 1 then
      S1 := S1 + ' �i��i��� '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' �i��i���� ';
    Text := Text + S1;
  end;

  if j3 <> 0 then
  begin
    S1 := I2SU(j3, Lasts, True);
    if (Lasts = 0) or ((Lasts >= 5) and (Lasts <= 9)) or ((Lasts >= 11) and (Lasts <= 19)) then
      S1 := S1 + ' �i��i��i� '
    else if Lasts = 1 then
      S1 := S1 + ' �i��i�� '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' �i��i��� ';
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
      S1 := S1 + ' ����� '
    else if Lasts = 1 then
      S1 := S1 + ' ������ '
    else if (Lasts >= 2) and (Lasts <= 4) then
      S1 := S1 + ' �����i ';
    Text := Text + S1;
  end;

  if j1 <> 0 then
  begin
    S1 := I2SU(j1, Lasts, True);
    Text := Text + S1;
  end;

  case Lasts of
    1: strcur := ' ������ ';
    2..4: strcur := ' �����i ';
    0, 5..19: strcur := ' ������� ';
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
    1: MN := '�i���';
    2: MN := '������';
    3: MN := '�������';
    4: MN := '��i���';
    5: MN := '������';
    6: MN := '������';
    7: MN := '�����';
    8: MN := '������';
    9: MN := '�������';
    10: MN := '������';
    11: MN := '���������';
    12: MN := '������';
  end;
  Result := IntToStr(D) + ' ' + MN + ' ' + IntTostr(Y) + ' �.';
end;
{***********************************************}

end.
