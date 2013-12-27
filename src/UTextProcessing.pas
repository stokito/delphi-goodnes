unit UTextProcessing;

interface

uses
  SysUtils, Dialogs, Classes, StrUtils, Math;

type
  TArgs = set of Char;
  TSearchType = (stWholeWord, stMatchCase);
  TSearchTypes = set of TSearchType;

type
  TStrProc = procedure(var S: string; BeginPos, EndPos: Integer; const OpenSymbol, CloseSymbol: Char);

type
  TDir = (ToLeft, ToRight);

type
  TSpacePosition = (spNone, spBeforeAndAfter, spBefore, spAfter);
  TSpacePositionParam = record
    IdentStr: string;
    SearchTypes: TSearchTypes;
    SpacePosition: TSpacePosition;
  end;
  TSpacePositionParams = array of TSpacePositionParam;

function IsSpaceErrors(const S: string; const IdentStr: string;
  SpacePosition: TSpacePosition; SearchTypes: TSearchTypes = []): Boolean; overload;
function IsSpaceErrors(const S: string): Boolean; overload;

function CorrectSpaceErrors(const S: string): string; overload;
function CorrectSpaceErrors(const S: string; IdentStr: string;
  SearchTypes: TSearchTypes; SpacePosition: TSpacePosition): string; overload;

function CountGroupedSymb(S: string; Symb: Char; Position: Integer; Dir: TDir = ToRight): Integer;

function CountSymbol(C: Char; S: string): Integer;
procedure DelReiterativeSymb(var S: string; const Args: TArgs); overload;
procedure DelReiterativeSymb(var S: string; const Args: TArgs; var CursorPos: Integer); overload;
function PosNSymbLeft(InputString: string; Symbol: Char; N: Integer): Integer;
function PosNSymbRight(InputString: string; Symbol: Char; N: Integer): Integer;
function MyFindText(SearchStr: string; const Str: string; Options: TSearchTypes = [];
  StartPos: Integer = 1; Count: Integer = MaxInt): Integer;
function PosExFromRightSide(const SearchStr: string; const S: string; Offset: Integer = MaxInt): Integer;
function FindTextFromRightSide(SearchStr: string; const Str: string; Offset: Integer = MaxInt; Options: TSearchTypes = []): Integer;
function ReplaceChars(S: string; Chars: TArgs; ReplacedStr: string): string;
function ExceptString(S: string; const ExceptionsString: string): string;
function ExceptAllStrings(S: string; ExceptionsStrings: TStringList): string;
function ExceptAllStrings2(S: string; ExceptionsStrings: TStringList): string;

//������� similarity ���������� ����������� "���������" ���� �����.
function similarity(i: LongInt; a, b: string): Double; stdcall; external 'similar.dll';

const
  // ������� - �������������� ����
  WordDelimeters: set of char = [' ', #10, #13, #9, ',', '.', ';', '(', ')', '"',
    '!', '?', '@', ':', '{', '}', '[', ']'];

type
  TSetOfChar = set of Char;

function ScatterStringToWords(Str: string; Delimeters: TSetOfChar = [' ', #13, #10]): TStringList; overload;
procedure ScatterStringToWords(Str: string; out WordsList: TStringList; Delimeters: TSetOfChar = [' ', #13, #10]); overload;
function IsKeysInString(KeysList: TStringList; const Str: string): Boolean;

var
  DefaultSpacePositionParams: TSpacePositionParams;

implementation


function IsSpaceErrors(const S: string; const IdentStr: string;
  SpacePosition: TSpacePosition; SearchTypes: TSearchTypes = []): Boolean; overload;
var
  CorrectedString: string;
begin
  CorrectedString := CorrectSpaceErrors(S, IdentStr, SearchTypes, SpacePosition);

  if CorrectedString = S then
    Result := False
  else
    Result := True;
end;

function IsSpaceErrors(const S: string): Boolean; overload;
var
  CorrectedString: string;
begin
  CorrectedString := CorrectSpaceErrors(S);

  if CorrectedString = S then
    Result := False
  else
    Result := True;
end;

function CorrectSpaceErrors(const S: string): string; overload;
var
  BeginPos, EndPos: Integer;
  InsertSpacePositions, DeleteSpacePositions: array of Integer;
  IdentStr: string;
  SearchTypes: TSearchTypes;
  SpacePosition: TSpacePosition;
  i: Integer;

  procedure InsertSpace(Position: Integer);
  var
    NewIndex: Integer;
  begin
    NewIndex := Length(InsertSpacePositions);
    SetLength(InsertSpacePositions, NewIndex + 1);
    InsertSpacePositions[NewIndex] := Position;
  end;

  procedure DeleteSpace(Position: Integer);
  var
    NewIndex: Integer;
  begin
    NewIndex := Length(DeleteSpacePositions);
    SetLength(DeleteSpacePositions, NewIndex + 1);
    DeleteSpacePositions[NewIndex] := Position;
  end;

  procedure DeleteSpacesBeforeAndAfter(BeginPos, EndPos: Integer);
  var
    j: Integer;
  begin
    for j := CountGroupedSymb(Result, ' ', BeginPos - 1, ToLeft) downto 1 do  // L������ �� ������ ������ ������v �� ����� ������
      DeleteSpace(BeginPos - j);
    for j := 1 to CountGroupedSymb(Result, ' ', EndPos + 1) do // L������ �� ������ ������ ������v ����� ����� ������
      DeleteSpace(EndPos + j);
  end;

  function IndexPosititonInArray(Position: Integer; ArrayOfPositions: array of Integer): Integer;
  var
    j: Integer;
  begin
    Result := -1;
    for j := Length(ArrayOfPositions) - 1 downto 0 do
      if ArrayOfPositions[j] = Position then
      begin
        Result := j;
        Break;
      end;
  end;

begin
  Result := S;

  if Length(S) < 2 then
    Exit;

  for i := 0 to Length(DefaultSpacePositionParams) - 1 do
  begin
    BeginPos := MaxInt;
    IdentStr := DefaultSpacePositionParams[i].IdentStr;
    SearchTypes := DefaultSpacePositionParams[i].SearchTypes;
    SpacePosition := DefaultSpacePositionParams[i].SpacePosition;
    while FindTextFromRightSide(IdentStr, Result, BeginPos - 1, SearchTypes) <> 0 do
    begin
      BeginPos := FindTextFromRightSide(IdentStr, Result, BeginPos - 1, SearchTypes);
      EndPos := BeginPos + Length(IdentStr) - 1;
      DeleteSpacesBeforeAndAfter(BeginPos, EndPos);
      case SpacePosition of
        spNone: ; // �� ������� ��� ��� �������� �����
        spBeforeAndAfter:
          begin
            InsertSpace(BeginPos);
            InsertSpace(EndPos + 1);
          end;
        spBefore: InsertSpace(BeginPos);
        spAfter: InsertSpace(EndPos + 1);
      end;
    end;
  end;

  for i := Length(Result) downto 1 do
  begin
    if IndexPosititonInArray(i, DeleteSpacePositions) <> -1 then
      Delete(Result, DeleteSpacePositions[IndexPosititonInArray(i, DeleteSpacePositions)], 1);
    if IndexPosititonInArray(i, InsertSpacePositions) <> -1 then
      Insert(' ', Result, InsertSpacePositions[IndexPosititonInArray(i, InsertSpacePositions)]);
  end;
end;

function CorrectSpaceErrors(const S: string; IdentStr: string;
  SearchTypes: TSearchTypes; SpacePosition: TSpacePosition): string; overload;
var
  BeginPos, EndPos: Integer;
  InsertSpacePositions, DeleteSpacePositions: array of Integer;
  i: Integer;

  procedure InsertSpace(Position: Integer);
  var
    NewIndex: Integer;
  begin
    NewIndex := Length(InsertSpacePositions);
    SetLength(InsertSpacePositions, NewIndex + 1);
    InsertSpacePositions[NewIndex] := Position;
  end;

  procedure DeleteSpace(Position: Integer);
  var
    NewIndex: Integer;
  begin
    NewIndex := Length(DeleteSpacePositions);
    SetLength(DeleteSpacePositions, NewIndex + 1);
    DeleteSpacePositions[NewIndex] := Position;
  end;

  procedure DeleteSpacesBeforeAndAfter(BeginPos, EndPos: Integer);
  var
    j: Integer;
  begin
    for j := CountGroupedSymb(Result, ' ', BeginPos - 1, ToLeft) downto 1 do  // L������ �� ������ ������ ������v �� ����� ������
      DeleteSpace(BeginPos - j);
    for j := 1 to CountGroupedSymb(Result, ' ', EndPos + 1) do // L������ �� ������ ������ ������v ����� ����� ������
      DeleteSpace(EndPos + j);
  end;

  function IndexPosititonInArray(Position: Integer; ArrayOfPositions: array of Integer): Integer;
  var
    j: Integer;
  begin
    Result := -1;
    for j := Length(ArrayOfPositions) - 1 downto 0 do
      if ArrayOfPositions[j] = Position then
      begin
        Result := j;
        Break;
      end;
  end;

begin
  Result := S;

  if Length(S) < 2 then
    Exit;

  BeginPos := MaxInt;
  while FindTextFromRightSide(IdentStr, Result, BeginPos - 1, SearchTypes) <> 0 do
  begin
    BeginPos := FindTextFromRightSide(IdentStr, Result, BeginPos - 1, SearchTypes);
    EndPos := BeginPos + Length(IdentStr) - 1;
    DeleteSpacesBeforeAndAfter(BeginPos, EndPos);
    case SpacePosition of
      spNone: ; // �� ������� ��� ��� �������� �����
      spBeforeAndAfter:
        begin
          InsertSpace(BeginPos);
          InsertSpace(EndPos + 1);
        end;
      spBefore: InsertSpace(BeginPos);
      spAfter: InsertSpace(EndPos + 1);
    end;
  end;

  for i := Length(Result) downto 1 do
  begin
    if IndexPosititonInArray(i, DeleteSpacePositions) <> -1 then
      Delete(Result, DeleteSpacePositions[IndexPosititonInArray(i, DeleteSpacePositions)], 1);
    if IndexPosititonInArray(i, InsertSpacePositions) <> -1 then
      Insert(' ', Result, InsertSpacePositions[IndexPosititonInArray(i, InsertSpacePositions)]);
  end;
end;

function CountGroupedSymb(S: string; Symb: Char; Position: Integer; Dir: TDir = ToRight): Integer;
var
  i: Integer;
  Step: Integer;
begin
  if Dir = ToRight then
    Step := 1
  else
    Step := -1;

  Result := 0;
  i := Position;
  while (i >= 1) and (i <= Length(S)) and (S[i] = Symb) do
  begin
     Inc(Result);
     i := i + Step;
  end;
end;

function CountSymbol(C: Char; S: string): Integer;
// ���������� ������� � ������
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(S) do
    if S[i] = C then
      Inc(Result);
end;

procedure DelReiterativeSymb(var S: string; const Args: TArgs); overload;
// �������� ������������� �������� (������ ���������� ��������...) "���  ������,,," "��� ������"
var
  i : Integer;
begin
  i := 2;
  while i <= Length(S) do
    if (S[i] in Args) and (S[i] = S[i - 1]) then
      Delete(S, i, 1)
    else
      Inc(i);
end;

procedure DelReiterativeSymb(var S: string; const Args: TArgs; var CursorPos: Integer); overload;
// �������� ������������� �������� (������ ���������� ��������...) "���  ������,,," "��� ������"
var
  i : Integer;
begin
  i := 2;
  while i <= Length(S) do
    if (S[i] in Args) and (S[i] = S[i - 1]) then
    begin
      if CursorPos >= i then
        Dec(CursorPos);
      Delete(S, i, 1);
    end
    else
      Inc(i);
end;

function PosNSymbLeft(InputString: string; Symbol: Char; N: Integer): Integer;
// ������� N ������� �����
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(InputString) do
  begin
    if InputString[i] = Symbol then
      if N = 1 then
      begin
        Result := i;
        Exit;
      end
      else
        Dec(N);
  end;
end;

function PosNSymbRight(InputString: string; Symbol: Char; N: Integer): Integer;
// ������� N ������� ������
var
  i: Integer;
begin
  Result := 0;
  for i := Length(InputString) downto 1 do
  begin
    if InputString[i] = Symbol then
      if N = 1 then
      begin
        Result := i;
        Exit;
      end
      else
        Dec(N);
  end;
end;

function MyFindText(SearchStr: string; const Str: string; Options: TSearchTypes = [];
  StartPos: Integer = 1; Count: Integer = MaxInt): Integer;
// 2004 �������� �� 20.07.2006 ����������� ���������� (� 21.09.2006 �������� � ���������� ��������)
var
  EndPos: Integer;
  BeginPos: Integer;
  S: string;
begin
  if StartPos < 1 then
    StartPos := 1;
  S := Copy(Str, StartPos, Count);

  if not (stMatchCase in Options) then
  begin
    S := LowerCase(S);
    SearchStr := LowerCase(SearchStr);
  end;

  Result := 0;
  if stWholeWord in Options then
  begin
    EndPos := 0;
    while PosEx(SearchStr, S, EndPos + 1) <> 0 do
    begin
      BeginPos := PosEx(SearchStr, S, EndPos + 1);
      EndPos := BeginPos + Length(SearchStr) - 1;
      if ((BeginPos <= 1) xor (S[BeginPos - 1] in WordDelimeters))
        and ((EndPos >= Length(S)) xor (S[EndPos + 1] in WordDelimeters))
        then
      begin
        Result := BeginPos;
        Break;
      end;
    end;
  end
  else
    Result := Pos(SearchStr, S);
  if Result <> 0 then
    Result := StartPos + Result - 1;
end;

function PosExFromRightSide(const SearchStr: string; const S: string; Offset: Integer = MaxInt): Integer;
var
  LenSearchStr: Integer; // ����� ������� ���������
  PosSearchStr: Integer; // "�����������������" ������� ������� ���������
  i: Integer;
  IsMath: Boolean; // ����������
begin
  LenSearchStr := Length(SearchStr);

  if Offset > Length(S) then
    Offset := Length(S);

  if LenSearchStr > Offset then //
  begin
    Result := 0;
    Exit;
  end;

  PosSearchStr := Offset - LenSearchStr + 1;

  IsMath := False;
  while (PosSearchStr >= 1) and not IsMath do
  begin
    Dec(PosSearchStr);
    for i := 1 to LenSearchStr do
      if S[PosSearchStr + i] = SearchStr[i] then
        IsMath := True
      else
      begin
        IsMath := False;
        Break;
      end;
  end;

  if IsMath then
    Result := PosSearchStr + 1
  else
    Result := 0;
end;

function FindTextFromRightSide(SearchStr: string; const Str: string;
  Offset: Integer = MaxInt; Options: TSearchTypes = []): Integer;
// 2006
var
  EndPos: Integer;
  BeginPos: Integer;
  S: string;
begin
  if not (stMatchCase in Options) then
  begin
    S := Copy(LowerCase(Str), 1, Offset);
    SearchStr := LowerCase(SearchStr);
  end;

  Result := 0;
  if stWholeWord in Options then
  begin
    BeginPos := MaxInt;
    while PosExFromRightSide(SearchStr, S, BeginPos - 1) <> 0 do
    begin
      BeginPos := PosExFromRightSide(SearchStr, S, BeginPos - 1);
      EndPos := BeginPos + Length(SearchStr) - 1;
      if ((BeginPos <= 1) xor (S[BeginPos - 1] in WordDelimeters))
        and ((EndPos >= Length(S)) xor (S[EndPos + 1] in WordDelimeters)) then
      begin
        Result := BeginPos;
        Break;
      end;
    end;
  end
  else
    Result := PosExFromRightSide(SearchStr, S);
end;

function ReplaceChars(S: string; Chars: TArgs; ReplacedStr: string): string;
// �������� ��� ������� Chars �� ������ ReplacedStr
// ���� ReplacedStr ������ '' �� �������� ��������
var
  i: Integer;
begin
  i := 1;
  while i <= Length(S) do
  begin
    if S[i] in Chars then
    begin
      Delete(S, i, 1);
      Insert(ReplacedStr, S, i);
      i := i + Length(ReplacedStr);
    end
    else
      Inc(i);
  end;
  Result := S;
end;

function ExceptString(S: string; const ExceptionsString: string): string;
// ��������� �� S ������ ExceptionsString
var
  PosExceptionStr: Integer;
begin
  Result := S;
  PosExceptionStr := MyFindText(ExceptionsString, Result, [stWholeWord]);
  while PosExceptionStr <> 0 do
  begin
    Result := Copy(Result, 1, PosExceptionStr - 1) + Copy(Result, PosExceptionStr + Length(ExceptionsString), MaxInt);
    PosExceptionStr := MyFindText(ExceptionsString, Result, [stWholeWord]);
  end;
end;

function ExceptAllStrings(S: string; ExceptionsStrings: TStringList): string;
// ��������� �� ������ S ��� ������ �� ExceptionsStrings
var
  Row: Integer;
begin
  Result := S;
  for Row := 1 to ExceptionsStrings.Count - 1 do
    Result := ExceptString(Result, ExceptionsStrings[Row]);
end;

function ExceptAllStrings2(S: string; ExceptionsStrings: TStringList): string;
// ��������� �� ������ S ��� ������ �� ExceptionsStrings
var
  Row: Integer;
begin
  Result := S;
  for Row := 1 to ExceptionsStrings.Count - 1 do
    Result := StringReplace(Result, ExceptionsStrings[Row], '', [rfReplaceAll, rfIgnoreCase]);
end;

procedure ScatterStringToWords(Str: string; out WordsList: TStringList; Delimeters: TSetOfChar = [' ', #13, #10]);
// ��������� ������ (Str) �� ������ ���� (WordsList). � �������� ������������ ������.
var
  i: Integer;
  Word: string; // "�����"
  LengthWord: Integer; // ����� "�����"
  LengthStr: Integer;  // ����� ���� "������"
begin
  Str := Trim(Str); // ������� ������ ������� � "������"
  if Str = '' then  // ���� "������" ����� �� � ���� � ��� ���
    Exit;

  WordsList.Clear; // � "������ ����" ��� ����� ���� ������, ������ ��� �� ��� ���������� �� ���
  // ����� Trim � �������� ��� "������" �� ����� �� ����� ����� ��� � ����� ����� �� ������ ������ �������
  Word := Str[1]; // ������ ������ �������� �� ������, ������ ����� ��� ������ � "�����"
  LengthWord := 1;
  LengthStr := Length(Str);
  SetLength(Word, LengthStr); // �������� ������ ��� "�����" � �������. �������� "�����" �� ����� ���� ������ ����� "������", ��� ��� ���������
  // �������� ������� "������" �� ������� �������, ������ ��� ������ ������ �� ��� ������ � "�����"
  for i := 2 to LengthStr do
    if not (Str[i] in Delimeters) then // ���� ��� �� ������ ���������� ��� � �����
    begin
      Inc(LengthWord);
      Word[LengthWord] := Str[i]
    end
    else
      if not (Str[i - 1] in Delimeters) then
      begin
        // �� �������� ��� "�����" ������ � �������, ������ ��� �� ����� ����� ����� ��� �����.
        // ������ ����� �� ������ � ������������� � "�����".
        SetLength(Word, LengthWord);
        // ���������� "�����" � ������ ����
        WordsList.Append(Word);
        // �� ������ ���������� ��������� "�����"
        LengthWord := 0;
        // �������� ������ ��� ����� � �������.
        // ��� ���� �� ��� ������� �� ������ i �������� "������" ��� �����.
        SetLength(Word, LengthStr - i);
      end;
  // ����������� "�����"
  SetLength(Word, LengthWord);
  // ���������� "�����" � ������ ����
  WordsList.Append(Word);
end;

function ScatterStringToWords(Str: string; Delimeters: TSetOfChar = [' ', #13, #10]): TStringList;
// ��������� ������ �� �����
begin
  Result := TStringList.Create;
  ScatterStringToWords(Str, Result);
end;

function IsKeysInString(KeysList: TStringList; const Str: string): Boolean;
// �������� ���������� ������: ��� �������� ����� ���� � ������
var
  i: Integer;
begin
  for i := 0 to KeysList.Count - 1 do
    if Pos(KeysList[i], Str) = 0 then
    // ���� ���� ���� � �������� �����������
    begin
      Result := False;
      Exit;
    end;
  Result := True;
end;

initialization
  SetLength(DefaultSpacePositionParams, 6);
  DefaultSpacePositionParams[0].IdentStr := ',';
  DefaultSpacePositionParams[0].SearchTypes := [];
  DefaultSpacePositionParams[0].SpacePosition := spAfter;
  DefaultSpacePositionParams[1].IdentStr := '.';
  DefaultSpacePositionParams[1].SearchTypes := [];
  DefaultSpacePositionParams[1].SpacePosition := spAfter;
  DefaultSpacePositionParams[2].IdentStr := ')';
  DefaultSpacePositionParams[2].SearchTypes := [];
  DefaultSpacePositionParams[2].SpacePosition := spAfter;
  DefaultSpacePositionParams[3].IdentStr := '(';
  DefaultSpacePositionParams[3].SearchTypes := [];
  DefaultSpacePositionParams[3].SpacePosition := spBefore;
  DefaultSpacePositionParams[4].IdentStr := '''';
  DefaultSpacePositionParams[4].SearchTypes := [];
  DefaultSpacePositionParams[4].SpacePosition := spNone;
  DefaultSpacePositionParams[5].IdentStr := '-';
  DefaultSpacePositionParams[5].SearchTypes := [];
  DefaultSpacePositionParams[5].SpacePosition := spNone;

finalization
  DefaultSpacePositionParams := nil;
end.

