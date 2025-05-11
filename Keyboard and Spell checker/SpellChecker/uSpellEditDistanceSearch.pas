{
  =============================================================================
  *****************************************************************************
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  https://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is Avro Keyboard 5.

  The Initial Developer of the Original Code is
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

unit uSpellEditDistanceSearch;

interface

uses
  sysutils,
  Math,
  Classes,
  uCustomDictionary;

procedure SearchSuggestion(const Source: string; var SList: TStringList; Max_Tolerance: Integer);

/// //////////////////////////////////////////
procedure SearchSuggestion_Basic(const Source: string; var SList: TStringList; Max_Tolerance: Integer);
function minimum(a, b, c: Integer): Integer;
function EditDistance(s, t: string): Integer;

implementation

uses
  BanglaChars,
  uDBase,
  clsReversePhonetic,
  StrUtils;

procedure SearchSuggestion(const Source: string; var SList: TStringList; Max_Tolerance: Integer);
var
  iLen, I, Dummy, J:                 Integer;
  SearchingPart, IsSuffix, ListItem: string;
  TempList:                          TStringList;
begin
  iLen := Length(Source);
  if iLen <= 0 then
    exit;

  SearchSuggestion_Basic(Source, SList, Max_Tolerance);

  if iLen < 2 then
    exit;

  TempList := TStringList.Create;
  TempList.Sorted := True;
  TempList.Duplicates := dupIgnore;

  for I := 2 to iLen do
  begin
    IsSuffix := MidStr(Source, I, iLen);
    SearchingPart := LeftStr(Source, iLen - Length(IsSuffix));

    // Valid suffix?
    if Suffix_Spell.Find(IsSuffix, Dummy) = True then
    begin
      TempList.Clear;
      SearchSuggestion_Basic(SearchingPart, TempList, Max_Tolerance);
      for J := 0 to TempList.Count - 1 do
      begin
        ListItem := TempList[J];
        if IsVowel(RightStr(ListItem, 1)) and (IsKar(LeftStr(IsSuffix, 1))) then
          SList.Add(ListItem + b_Y + IsSuffix)
        else
        begin
          if RightStr(ListItem, 1) = b_Khandatta then
            TempList.Add(MidStr(ListItem, 1, Length(ListItem) - 1) + b_T + IsSuffix)
          else if RightStr(ListItem, 1) = b_Anushar then
            TempList.Add(MidStr(ListItem, 1, Length(ListItem) - 1) + b_NGA + IsSuffix)
          else
            SList.Add(ListItem + IsSuffix);
        end;
      end;

      for J := 0 to TempList.Count - 1 do
        SList.Add(TempList[J]);
    end;
  end;

  TempList.Clear;
  FreeAndNil(TempList);

end;

procedure SearchSuggestion_Basic(const Source: string; var SList: TStringList; Max_Tolerance: Integer);
var
  Start:      Char;
  I:          Integer;
  StringData: string;

  procedure SearchInDB(var DB: TStringList);
  var
    J: Integer;
  begin
    for J := 0 to DB.Count - 1 do
    begin
      StringData := DB[J];
      if EditDistance(Source, StringData) <= Max_Tolerance then
        SList.Add(StringData);
    end;
  end;

begin
  if Length(Source) <= 0 then
    exit;

  Start := Source[1];

  // Search for "Substitution", "Insertion"
  // "Deletion" errors
  if Start = b_A then
    SearchInDB(W_A);
  if Start = b_AA then
    SearchInDB(W_AA);
  if Start = b_I then
    SearchInDB(W_I);
  if Start = b_II then
    SearchInDB(W_II);
  if Start = b_U then
    SearchInDB(W_U);
  if Start = b_UU then
    SearchInDB(W_UU);
  if Start = b_RRI then
    SearchInDB(W_RRI);
  if Start = b_E then
    SearchInDB(W_E);
  if Start = b_OI then
    SearchInDB(W_OI);
  if Start = b_O then
    SearchInDB(W_O);
  if Start = b_OU then
    SearchInDB(W_OU);

  if Start = b_B then
    SearchInDB(W_B);
  if Start = b_BH then
    SearchInDB(W_BH);
  if Start = b_C then
    SearchInDB(W_C);
  if Start = b_CH then
    SearchInDB(W_CH);
  if Start = b_D then
    SearchInDB(W_D);
  if Start = b_Dh then
    SearchInDB(W_Dh);
  if Start = b_DD then
    SearchInDB(W_Dd);
  if Start = b_DDh then
    SearchInDB(W_Ddh);
  if Start = b_G then
    SearchInDB(W_G);
  if Start = b_Gh then
    SearchInDB(W_Gh);
  if Start = b_H then
    SearchInDB(W_H);
  if Start = b_J then
    SearchInDB(W_J);
  if Start = b_Jh then
    SearchInDB(W_Jh);
  if Start = b_K then
    SearchInDB(W_K);
  if Start = b_Kh then
    SearchInDB(W_Kh);
  if Start = b_L then
    SearchInDB(W_L);
  if Start = b_M then
    SearchInDB(W_M);
  if Start = b_N then
    SearchInDB(W_N);
  if Start = b_NGA then
    SearchInDB(W_NGA);
  if Start = b_NYA then
    SearchInDB(W_NYA);
  if Start = b_Nn then
    SearchInDB(W_Nn);
  if Start = b_P then
    SearchInDB(W_P);
  if Start = b_Ph then
    SearchInDB(W_Ph);
  if Start = b_R then
    SearchInDB(W_R);
  if Start = b_Rr then
    SearchInDB(W_Rr);
  if Start = b_Rrh then
    SearchInDB(W_Rrh);
  if Start = b_S then
    SearchInDB(W_S);
  if Start = b_Sh then
    SearchInDB(W_Sh);
  if Start = b_Ss then
    SearchInDB(W_Ss);
  if Start = b_T then
    SearchInDB(W_T);
  if Start = b_Th then
    SearchInDB(W_Th);
  if Start = b_Tt then
    SearchInDB(W_Tt);
  if Start = b_Tth then
    SearchInDB(W_Tth);
  if Start = b_Y then
    SearchInDB(W_Y);
  if Start = b_Z then
    SearchInDB(W_Z);
  if Start = b_Khandatta then
    SearchInDB(W_Khandatta);

  // Search custom dictionary
  for I := 0 to SpellCustomDict.Count - 1 do
  begin
    if EditDistance(Source, SpellCustomDict[I]) <= Max_Tolerance then
      SList.Add(StringData);
  end;

end;

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

function EditDistance(s, t: string): Integer;
var
  d:                 array of array of Integer;
  n, m, I, J, costo: Integer;
  s_i, t_j:          Char;
begin
  n := Length(s);
  m := Length(t);
  if (n = 0) then
  begin
    Result := m;
    exit;
  end;
  if m = 0 then
  begin
    Result := n;
    exit;
  end;
  setlength(d, n + 1, m + 1);
  for I := 0 to n do
    d[I, 0] := I;
  for J := 0 to m do
    d[0, J] := J;
  for I := 1 to n do
  begin
    s_i := s[I];
    for J := 1 to m do
    begin
      t_j := t[J];
      if s_i = t_j then
        costo := 0
      else
        costo := 1;
      d[I, J] := minimum(d[I - 1][J] + 1, d[I][J - 1] + 1, d[I - 1][J - 1] + costo);
    end;
  end;
  Result := d[n, m];
end;

end.
