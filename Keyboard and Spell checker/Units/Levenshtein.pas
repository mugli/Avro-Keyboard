// Copied from http://www.merriampark.com/lddelphi.htm

unit Levenshtein;

interface

uses sysutils, Math;

function minimum(a, b, c: Integer): Integer;

function LD(s, t: String): Integer;

implementation

function minimum(a, b, c: Integer): Integer;
var
  mi: Integer;
begin
  mi := a;
  if (b < mi) then
    mi := b;
  if (c < mi) then
    mi := c;
  Result := mi;
end;

function LD(s, t: String): Integer;
var
  d: array of array of Integer;
  n, m, i, j, costo: Integer;
  s_i, t_j: Char;
begin
  n := Length(s);
  m := Length(t);
  if (n = 0) then
  begin
    Result := m;
    Exit;
  end;
  if m = 0 then
  begin
    Result := n;
    Exit;
  end;
  setlength(d, n + 1, m + 1);
  for i := 0 to n do
    d[i, 0] := i;
  for j := 0 to m do
    d[0, j] := j;
  for i := 1 to n do
  begin
    s_i := s[i];
    for j := 1 to m do
    begin
      t_j := t[j];
      if s_i = t_j then
        costo := 0
      else
        costo := 1;
      d[i, j] := minimum(d[i - 1][j] + 1, d[i][j - 1] + 1,
        d[i - 1][j - 1] + costo);
    end;
  end;
  Result := d[n, m];
end;

end.
