{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit HashTable;

interface

uses
  BanglaChars,
  classes,
  uDbase,
  System.SysUtils,
  System.Generics.Collections,
  StrUtils;

function WordPresent(const Wrd: string): Boolean;

procedure BuildOneHashTable(var SourceArray: TStringList; var dict: TDictionary<string, Boolean>);

function WordPresent_Basic(const Wrd: string): Boolean;

implementation

function WordPresent(const Wrd: string): Boolean;
var
  iLen, I, Dummy:          Integer;
  SearchingPart, IsSuffix: string;
begin
  Result := False;
  iLen := Length(Wrd);
  if iLen <= 0 then
    exit;

  if WordPresent_Basic(Wrd) then
  begin
    Result := True;
    exit;
  end;

  if iLen < 2 then
    exit;

  for I := 2 to iLen do
  begin
    IsSuffix := MidStr(Wrd, I, iLen);
    SearchingPart := LeftStr(Wrd, iLen - Length(IsSuffix));

    // Valid suffix?
    if Suffix_Spell.Find(IsSuffix, Dummy) = True then
    begin

      if WordPresent_Basic(SearchingPart) then
      begin
        Result := True;
        exit;
      end;

      if RightStr(SearchingPart, 1) = b_T then
      begin
        SearchingPart := MidStr(SearchingPart, 1, Length(SearchingPart) - 1) + b_Khandatta;
        if WordPresent_Basic(SearchingPart) then
        begin
          Result := True;
          exit;
        end;
      end;

      if RightStr(SearchingPart, 1) = b_NGA then
      begin
        SearchingPart := MidStr(SearchingPart, 1, Length(SearchingPart) - 1) + b_Anushar;
        if WordPresent_Basic(SearchingPart) then
        begin
          Result := True;
          exit;
        end;
      end;

    end;
  end;

end;

function WordPresent_Basic(const Wrd: string): Boolean;

  function SearchWord(var dict: TDictionary<string, Boolean>): Boolean;
  begin
    Result := dict.ContainsKey(Wrd)
  end;

var
  FirstChar: Char;
begin
  Result := False;

  if Length(Wrd) <= 0 then
    exit;
  FirstChar := Wrd[1];

  if FirstChar = b_A then
  begin
    Result := SearchWord(W_Hash_A);
    exit;
  end;
  if FirstChar = b_AA then
  begin
    Result := SearchWord(W_Hash_AA);
    exit;
  end;
  if FirstChar = b_I then
  begin
    Result := SearchWord(W_Hash_I);
    exit;
  end;
  if FirstChar = b_II then
  begin
    Result := SearchWord(W_Hash_II);
    exit;
  end;
  if FirstChar = b_U then
  begin
    Result := SearchWord(W_Hash_U);
    exit;
  end;
  if FirstChar = b_UU then
  begin
    Result := SearchWord(W_Hash_UU);
    exit;
  end;
  if FirstChar = b_RRI then
  begin
    Result := SearchWord(W_Hash_RRI);
    exit;
  end;
  if FirstChar = b_E then
  begin
    Result := SearchWord(W_Hash_E);
    exit;
  end;
  if FirstChar = b_OI then
  begin
    Result := SearchWord(W_Hash_OI);
    exit;
  end;
  if FirstChar = b_O then
  begin
    Result := SearchWord(W_Hash_O);
    exit;
  end;
  if FirstChar = b_OU then
  begin
    Result := SearchWord(W_Hash_OU);
    exit;
  end;

  if FirstChar = b_B then
  begin
    Result := SearchWord(W_Hash_B);
    exit;
  end;
  if FirstChar = b_BH then
  begin
    Result := SearchWord(W_Hash_BH);
    exit;
  end;
  if FirstChar = b_C then
  begin
    Result := SearchWord(W_Hash_C);
    exit;
  end;
  if FirstChar = b_CH then
  begin
    Result := SearchWord(W_Hash_CH);
    exit;
  end;
  if FirstChar = b_D then
  begin
    Result := SearchWord(W_Hash_D);
    exit;
  end;
  if FirstChar = b_Dh then
  begin
    Result := SearchWord(W_Hash_Dh);
    exit;
  end;
  if FirstChar = b_DD then
  begin
    Result := SearchWord(W_Hash_Dd);
    exit;
  end;
  if FirstChar = b_DDh then
  begin
    Result := SearchWord(W_Hash_DDh);
    exit;
  end;
  if FirstChar = b_G then
  begin
    Result := SearchWord(W_Hash_G);
    exit;
  end;
  if FirstChar = b_Gh then
  begin
    Result := SearchWord(W_Hash_Gh);
    exit;
  end;
  if FirstChar = b_H then
  begin
    Result := SearchWord(W_Hash_H);
    exit;
  end;
  if FirstChar = b_J then
  begin
    Result := SearchWord(W_Hash_J);
    exit;
  end;
  if FirstChar = b_Jh then
  begin
    Result := SearchWord(W_Hash_Jh);
    exit;
  end;
  if FirstChar = b_K then
  begin
    Result := SearchWord(W_Hash_K);
    exit;
  end;
  if FirstChar = b_Kh then
  begin
    Result := SearchWord(W_Hash_Kh);
    exit;
  end;
  if FirstChar = b_L then
  begin
    Result := SearchWord(W_Hash_L);
    exit;
  end;
  if FirstChar = b_M then
  begin
    Result := SearchWord(W_Hash_M);
    exit;
  end;
  if FirstChar = b_N then
  begin
    Result := SearchWord(W_Hash_N);
    exit;
  end;
  if FirstChar = b_NGA then
  begin
    Result := SearchWord(W_Hash_NGA);
    exit;
  end;
  if FirstChar = b_NYA then
  begin
    Result := SearchWord(W_Hash_NYA);
    exit;
  end;
  if FirstChar = b_Nn then
  begin
    Result := SearchWord(W_Hash_Nn);
    exit;
  end;
  if FirstChar = b_P then
  begin
    Result := SearchWord(W_Hash_P);
    exit;
  end;
  if FirstChar = b_Ph then
  begin
    Result := SearchWord(W_Hash_Ph);
    exit;
  end;
  if FirstChar = b_R then
  begin
    Result := SearchWord(W_Hash_R);
    exit;
  end;
  if FirstChar = b_RR then
  begin
    Result := SearchWord(W_Hash_RR);
    exit;
  end;
  if FirstChar = b_RRH then
  begin
    Result := SearchWord(W_Hash_RRH);
    exit;
  end;
  if FirstChar = b_S then
  begin
    Result := SearchWord(W_Hash_S);
    exit;
  end;
  if FirstChar = b_Sh then
  begin
    Result := SearchWord(W_Hash_Sh);
    exit;
  end;
  if FirstChar = b_Ss then
  begin
    Result := SearchWord(W_Hash_Ss);
    exit;
  end;
  if FirstChar = b_T then
  begin
    Result := SearchWord(W_Hash_T);
    exit;
  end;
  if FirstChar = b_Tt then
  begin
    Result := SearchWord(W_Hash_Tt);
    exit;
  end;
  if FirstChar = b_Tth then
  begin
    Result := SearchWord(W_Hash_Tth);
    exit;
  end;
  if FirstChar = b_Th then
  begin
    Result := SearchWord(W_Hash_Th);
    exit;
  end;
  if FirstChar = b_Y then
  begin
    Result := SearchWord(W_Hash_Y);
    exit;
  end;
  if FirstChar = b_Z then
  begin
    Result := SearchWord(W_Hash_Z);
    exit;
  end;
  if FirstChar = b_Khandatta then
  begin
    Result := SearchWord(W_Hash_Khandatta);
    exit;
  end;

end;

procedure BuildOneHashTable(var SourceArray: TStringList; var dict: TDictionary<string, Boolean>);
var
  I, C: Integer;
begin
  C := SourceArray.Count;
  dict := TDictionary<string, Boolean>.Create;
  dict.Capacity := C;

  for I := 0 to C - 1 do
    dict.Add(SourceArray[I], True);
end;

end.
