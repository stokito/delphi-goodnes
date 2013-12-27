unit UArifmetic;

interface

uses
  Variants;

function Roundery(T: Extended; Ro: Extended): Extended;
function ValueInArrray(Value: Integer; A: array of Integer): Boolean;
function VarToIntDef(const V: Variant; ADefault: Integer): Integer;
function VarToFloatDef(const V: Variant; ADefault: Extended): Extended;

implementation

function Roundery(T: Extended; Ro: Extended): Extended;
(*         Округление
 Roundery(2.43, 0.05) = 2.45
 Roundery(2.42, 0.05) = 2.40 *)
begin
  Result := Ro * Round((T + 0.01 * Ro) / Ro);
end;

function ValueInArrray(Value: Integer; A: array of Integer): Boolean;
// Проверяет находится ли в массиве елемент с таким же значением
var
  i: Integer;
begin
  Result := False;
  for i := 0 to High(A) do
  begin
    Result := Value = A[i];
    if Result then
      Break;
  end;
end;

function VarToIntDef(const V: Variant; ADefault: Integer): Integer;
begin
  if not VarIsNull(V) then
    Result := V
  else
    Result := ADefault;
end;

function VarToFloatDef(const V: Variant; ADefault: Extended): Extended;
begin
  if not VarIsNull(V) then
    Result := V
  else
    Result := ADefault;
end;

end.
