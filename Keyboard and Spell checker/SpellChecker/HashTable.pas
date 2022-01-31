{
  =============================================================================
  *****************************************************************************
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is Avro Keyboard 5.

  The Initial Developer of the Original Code is
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (http://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

Unit HashTable;

Interface

Uses

  Hashing,
  BanglaChars,
  classes,
  uDbase;

Function WordPresent(Const Wrd: String): Boolean;

Type
  TCompareResult = (crLess, // <
    crEqual, // =
    crGreater, // >
    crUndefined);
  TCompareResultSet = Set Of TCompareResult;

Procedure BuildOneHashTable(Var SourceArray: TStringList;
  Var HArray: HashArray);
Function DictionaryRehashSize(Const Count: Integer): Integer;
Function Append(Var V: LongIntArray; Const R: LongInt): Integer;
Function StrPCompare(Const A, B: PAnsiChar; Const Len: Integer): TCompareResult;
Function StrEqual(Const A, B: AnsiString): Boolean;

Function WordPresent_Basic(Const Wrd: String): Boolean;

Const
  AverageHashChainSize = 4;

Implementation

Uses
  StrUtils,
  SysUtils;

Function WordPresent(Const Wrd: String): Boolean;
Var
  iLen, I, Dummy: Integer;
  SearchingPart, IsSuffix: String;
Begin
  Result := False;
  iLen := Length(Wrd);
  If iLen <= 0 Then
    exit;

  If WordPresent_Basic(Wrd) Then
  Begin
    Result := True;
    exit;
  End;

  If iLen < 2 Then
    exit;

  For I := 2 To iLen Do
  Begin
    IsSuffix := MidStr(Wrd, I, iLen);
    SearchingPart := LeftStr(Wrd, iLen - Length(IsSuffix));

    // Valid suffix?
    If Suffix_Spell.Find(IsSuffix, Dummy) = True Then
    Begin

      If WordPresent_Basic(SearchingPart) Then
      Begin
        Result := True;
        exit;
      End;

      If RightStr(SearchingPart, 1) = b_T Then
      Begin
        SearchingPart := MidStr(SearchingPart, 1, Length(SearchingPart) - 1) +
          b_Khandatta;
        If WordPresent_Basic(SearchingPart) Then
        Begin
          Result := True;
          exit;
        End;
      End;

      If RightStr(SearchingPart, 1) = b_NGA Then
      Begin
        SearchingPart := MidStr(SearchingPart, 1, Length(SearchingPart) - 1) +
          b_Anushar;
        If WordPresent_Basic(SearchingPart) Then
        Begin
          Result := True;
          exit;
        End;
      End;

    End;
  End;

End;

Function WordPresent_Basic(Const Wrd: String): Boolean;

  Function SearchWord(Var SourceArray: TStringList;
    Var HArray: HashArray): Boolean;
  Var
    H, I, J, L: Integer;
    Key: AnsiString;
  Begin
    Result := False;
    L := Length(HArray);
    If L > 0 Then
    Begin
      Key := utf8encode(Wrd);
      H := HashStr(Key, L);
      For I := 0 To Length(HArray[H]) - 1 Do
      Begin
        J := HArray[H, I];
        If StrEqual(Key, SourceArray[J]) Then
        Begin
          Result := True;
          break;
        End;
      End;
    End;
  End;

Var
  FirstChar: Char;
Begin
  Result := False;

  If Length(Wrd) <= 0 Then
    exit;
  FirstChar := Wrd[1];

  If FirstChar = b_A Then
  Begin
    Result := SearchWord(W_A, W_Hash_A);
    exit;
  End;
  If FirstChar = b_AA Then
  Begin
    Result := SearchWord(W_AA, W_Hash_AA);
    exit;
  End;
  If FirstChar = b_I Then
  Begin
    Result := SearchWord(W_I, W_Hash_I);
    exit;
  End;
  If FirstChar = b_II Then
  Begin
    Result := SearchWord(W_II, W_Hash_II);
    exit;
  End;
  If FirstChar = b_U Then
  Begin
    Result := SearchWord(W_U, W_Hash_U);
    exit;
  End;
  If FirstChar = b_UU Then
  Begin
    Result := SearchWord(W_UU, W_Hash_UU);
    exit;
  End;
  If FirstChar = b_RRI Then
  Begin
    Result := SearchWord(W_RRI, W_Hash_RRI);
    exit;
  End;
  If FirstChar = b_E Then
  Begin
    Result := SearchWord(W_E, W_Hash_E);
    exit;
  End;
  If FirstChar = b_OI Then
  Begin
    Result := SearchWord(W_OI, W_Hash_OI);
    exit;
  End;
  If FirstChar = b_O Then
  Begin
    Result := SearchWord(W_O, W_Hash_O);
    exit;
  End;
  If FirstChar = b_OU Then
  Begin
    Result := SearchWord(W_OU, W_Hash_OU);
    exit;
  End;

  If FirstChar = b_B Then
  Begin
    Result := SearchWord(W_B, W_Hash_B);
    exit;
  End;
  If FirstChar = b_BH Then
  Begin
    Result := SearchWord(W_BH, W_Hash_BH);
    exit;
  End;
  If FirstChar = b_C Then
  Begin
    Result := SearchWord(W_C, W_Hash_C);
    exit;
  End;
  If FirstChar = b_CH Then
  Begin
    Result := SearchWord(W_CH, W_Hash_CH);
    exit;
  End;
  If FirstChar = b_D Then
  Begin
    Result := SearchWord(W_D, W_Hash_D);
    exit;
  End;
  If FirstChar = b_Dh Then
  Begin
    Result := SearchWord(W_Dh, W_Hash_Dh);
    exit;
  End;
  If FirstChar = b_DD Then
  Begin
    Result := SearchWord(W_DD, W_Hash_Dd);
    exit;
  End;
  If FirstChar = b_DDh Then
  Begin
    Result := SearchWord(W_DDh, W_Hash_DDh);
    exit;
  End;
  If FirstChar = b_G Then
  Begin
    Result := SearchWord(W_G, W_Hash_G);
    exit;
  End;
  If FirstChar = b_Gh Then
  Begin
    Result := SearchWord(W_Gh, W_Hash_Gh);
    exit;
  End;
  If FirstChar = b_H Then
  Begin
    Result := SearchWord(W_H, W_Hash_H);
    exit;
  End;
  If FirstChar = b_J Then
  Begin
    Result := SearchWord(W_J, W_Hash_J);
    exit;
  End;
  If FirstChar = b_Jh Then
  Begin
    Result := SearchWord(W_Jh, W_Hash_Jh);
    exit;
  End;
  If FirstChar = b_K Then
  Begin
    Result := SearchWord(W_K, W_Hash_K);
    exit;
  End;
  If FirstChar = b_Kh Then
  Begin
    Result := SearchWord(W_Kh, W_Hash_Kh);
    exit;
  End;
  If FirstChar = b_L Then
  Begin
    Result := SearchWord(W_L, W_Hash_L);
    exit;
  End;
  If FirstChar = b_M Then
  Begin
    Result := SearchWord(W_M, W_Hash_M);
    exit;
  End;
  If FirstChar = b_N Then
  Begin
    Result := SearchWord(W_N, W_Hash_N);
    exit;
  End;
  If FirstChar = b_NGA Then
  Begin
    Result := SearchWord(W_NGA, W_Hash_NGA);
    exit;
  End;
  If FirstChar = b_NYA Then
  Begin
    Result := SearchWord(W_NYA, W_Hash_NYA);
    exit;
  End;
  If FirstChar = b_Nn Then
  Begin
    Result := SearchWord(W_Nn, W_Hash_Nn);
    exit;
  End;
  If FirstChar = b_P Then
  Begin
    Result := SearchWord(W_P, W_Hash_P);
    exit;
  End;
  If FirstChar = b_Ph Then
  Begin
    Result := SearchWord(W_Ph, W_Hash_Ph);
    exit;
  End;
  If FirstChar = b_R Then
  Begin
    Result := SearchWord(W_R, W_Hash_R);
    exit;
  End;
  If FirstChar = b_RR Then
  Begin
    Result := SearchWord(W_RR, W_Hash_RR);
    exit;
  End;
  If FirstChar = b_RRH Then
  Begin
    Result := SearchWord(W_RRH, W_Hash_RRH);
    exit;
  End;
  If FirstChar = b_S Then
  Begin
    Result := SearchWord(W_S, W_Hash_S);
    exit;
  End;
  If FirstChar = b_Sh Then
  Begin
    Result := SearchWord(W_Sh, W_Hash_Sh);
    exit;
  End;
  If FirstChar = b_Ss Then
  Begin
    Result := SearchWord(W_Ss, W_Hash_Ss);
    exit;
  End;
  If FirstChar = b_T Then
  Begin
    Result := SearchWord(W_T, W_Hash_T);
    exit;
  End;
  If FirstChar = b_Tt Then
  Begin
    Result := SearchWord(W_Tt, W_Hash_Tt);
    exit;
  End;
  If FirstChar = b_Tth Then
  Begin
    Result := SearchWord(W_TTh, W_Hash_Tth);
    exit;
  End;
  If FirstChar = b_Th Then
  Begin
    Result := SearchWord(W_Th, W_Hash_Th);
    exit;
  End;
  If FirstChar = b_Y Then
  Begin
    Result := SearchWord(W_Y, W_Hash_Y);
    exit;
  End;
  If FirstChar = b_Z Then
  Begin
    Result := SearchWord(W_Z, W_Hash_Z);
    exit;
  End;
  If FirstChar = b_Khandatta Then
  Begin
    Result := SearchWord(W_Khandatta, W_Hash_Khandatta);
    exit;
  End;

End;

Function DictionaryRehashSize(Const Count: Integer): Integer;
Var
  L: Integer;
Begin
  L := Count Div AverageHashChainSize; // Number of slots
  If L <= 16 Then // Rehash in powers of 16
    Result := 16
  Else If L <= 256 Then
    Result := 256
  Else If L <= 4096 Then
    Result := 4096
  Else If L <= 65536 Then
    Result := 65536
  Else If L <= 1048576 Then
    Result := 1048576
  Else If L <= 16777216 Then
    Result := 16777216
  Else
    Result := 268435456;
End;

Procedure BuildOneHashTable(Var SourceArray: TStringList;
  Var HArray: HashArray);
Var
  I, C, L: Integer;
Begin
  // C := Length(SourceArray);
  C := SourceArray.Count;
  L := DictionaryRehashSize(C);
  HArray := Nil;
  SetLength(HArray, L);
  For I := 0 To C - 1 Do
    Append(HArray[HashStr(SourceArray[I], L)], I);
End;

Function Append(Var V: LongIntArray; Const R: LongInt): Integer;
Begin
  Result := Length(V);
  SetLength(V, Result + 1);
  V[Result] := R;
End;

Function StrEqual(Const A, B: AnsiString): Boolean;
Var
  L1, L2: Integer;
Begin
  L1 := Length(A);
  L2 := Length(B);
  Result := L1 = L2;
  If Not Result Or (L1 = 0) Then
    exit;
  If Pointer(A) = Pointer(B) Then
    exit;

  Result := StrPCompare(Pointer(A), Pointer(B), L1) = crEqual;

End;

Function StrPCompare(Const A, B: PAnsiChar; Const Len: Integer): TCompareResult;
Var
  P, Q: PAnsiChar;
  I: Integer;
Begin
  P := A;
  Q := B;
  If Len <= 0 Then
  Begin
    Result := crUndefined;
    exit;
  End;
  For I := 1 To Len Do
    If P^ = Q^ Then
    Begin
      Inc(P);
      Inc(Q);
    End
    Else
    Begin
      If Ord(P^) < Ord(Q^) Then
        Result := crLess
      Else
        Result := crGreater;
      exit;
    End;
  Result := crEqual;
End;

End.
