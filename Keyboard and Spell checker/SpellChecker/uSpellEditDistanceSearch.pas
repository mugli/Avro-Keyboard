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

Unit uSpellEditDistanceSearch;

Interface
Uses sysutils,
     Math,
     WideStrings,
     uCustomDictionary;


Procedure SearchSuggestion(Const Source: WideString; Var SList: TWideStringList; Max_Tolerance: Integer);


/////////////////////////////////////////////
Procedure SearchSuggestion_Basic(Const Source: WideString; Var SList: TWideStringList; Max_Tolerance: Integer);
Function minimum(a, b, c: Integer): Integer;
Function EditDistance(s, t: WideString): Integer;



Implementation
Uses
     BanglaChars,
     uDBase,
     clsReversePhonetic,
     StrUtils,
     classes,
     JclAnsiStrings;

Procedure SearchSuggestion(Const Source: WideString; Var SList: TWideStringList; Max_Tolerance: Integer);
Var
     iLen, I, Dummy, J        : Integer;
     SearchingPart, IsSuffix, ListItem: WideString;
     TempList                 : TWideStringlist;
Begin
     iLen := Length(Source);
     If iLen <= 0 Then exit;

     SearchSuggestion_Basic(Source, SList, Max_Tolerance);

     If iLen < 2 Then exit;

     TempList := TWideStringlist.Create;
     TempList.Sorted := True;
     TempList.Duplicates := dupIgnore;

     For I := 2 To iLen Do Begin
          IsSuffix := MidStr(Source, I, iLen);
          SearchingPart := LeftStr(Source, iLen - Length(IsSuffix));

          //Valid suffix?
          If Suffix_Spell.Find(IsSuffix, Dummy) = True Then Begin
               TempList.Clear;
               SearchSuggestion_Basic(SearchingPart, TempList, Max_Tolerance);
               For J := 0 To TempList.Count - 1 Do Begin
                    ListItem := TempList[J];
                    If IsVowel(RightStr(ListItem, 1)) And (IsKar(LeftStr(IsSuffix, 1))) Then
                         SList.Add(ListItem + b_Y + IsSuffix)
                    Else Begin
                         If RightStr(ListItem, 1) = b_Khandatta Then
                              TempList.Add(MidStr(ListItem, 1, Length(ListItem) - 1) + b_T + IsSuffix)
                         Else If RightStr(ListItem, 1) = b_Anushar Then
                              TempList.Add(MidStr(ListItem, 1, Length(ListItem) - 1) + b_NGA + IsSuffix)
                         Else
                              SList.Add(ListItem + IsSuffix);
                    End;
               End;

               For J := 0 To TempList.Count - 1 Do
                    SList.Add(TempList[J]);
          End;
     End;

     TempList.Clear;
     FreeAndNil(TempList);

End;

Procedure SearchSuggestion_Basic(Const Source: WideString; Var SList: TWideStringList; Max_Tolerance: Integer);
Var
     Start                    : WideChar;
     I                        : Integer;
     WideData                 : WideString;

     Procedure SearchInDB(Var DB: TAnsiStringList);
     Var
          J                   : Integer;
     Begin
          For J := 0 To DB.Count - 1 Do Begin
               WideData := utf8decode(DB[J]);
               If EditDistance(Source, WideData) <= Max_Tolerance Then
                    SList.Add(WideData);
          End;
     End;

Begin
     If Length(Source) <= 0 Then exit;

     Start := Source[1];

     //Search for "Substitution", "Insertion"
     //"Deletion" errors
     If Start = b_A Then SearchInDB(W_A);
     If Start = b_AA Then SearchInDB(W_AA);
     If Start = b_I Then SearchInDB(W_I);
     If Start = b_II Then SearchInDB(W_II);
     If Start = b_U Then SearchInDB(W_U);
     If Start = b_UU Then SearchInDB(W_UU);
     If Start = b_RRI Then SearchInDB(W_RRI);
     If Start = b_E Then SearchInDB(W_E);
     If Start = b_OI Then SearchInDB(W_OI);
     If Start = b_O Then SearchInDB(W_O);
     If Start = b_OU Then SearchInDB(W_OU);


     If Start = b_B Then SearchInDB(W_B);
     If Start = b_BH Then SearchInDB(W_BH);
     If Start = b_C Then SearchInDB(W_C);
     If Start = b_CH Then SearchInDB(W_CH);
     If Start = b_D Then SearchInDB(W_D);
     If Start = b_Dh Then SearchInDB(W_Dh);
     If Start = b_DD Then SearchInDB(W_Dd);
     If Start = b_DDh Then SearchInDB(W_Ddh);
     If Start = b_G Then SearchInDB(W_G);
     If Start = b_Gh Then SearchInDB(W_Gh);
     If Start = b_H Then SearchInDB(W_H);
     If Start = b_J Then SearchInDB(W_J);
     If Start = b_Jh Then SearchInDB(W_Jh);
     If Start = b_K Then SearchInDB(W_K);
     If Start = b_Kh Then SearchInDB(W_Kh);
     If Start = b_L Then SearchInDB(W_L);
     If Start = b_M Then SearchInDB(W_M);
     If Start = b_N Then SearchInDB(W_N);
     If Start = b_NGA Then SearchInDB(W_NGA);
     If Start = b_NYA Then SearchInDB(W_NYA);
     If Start = b_Nn Then SearchInDB(W_Nn);
     If Start = b_P Then SearchInDB(W_P);
     If Start = b_Ph Then SearchInDB(W_Ph);
     If Start = b_R Then SearchInDB(W_R);
     If Start = b_Rr Then SearchInDB(W_Rr);
     If Start = b_Rrh Then SearchInDB(W_Rrh);
     If Start = b_S Then SearchInDB(W_S);
     If Start = b_Sh Then SearchInDB(W_Sh);
     If Start = b_Ss Then SearchInDB(W_Ss);
     If Start = b_T Then SearchInDB(W_T);
     If Start = b_Th Then SearchInDB(W_Th);
     If Start = b_Tt Then SearchInDB(W_Tt);
     If Start = b_Tth Then SearchInDB(W_Tth);
     If Start = b_Y Then SearchInDB(W_Y);
     If Start = b_Z Then SearchInDB(W_Z);
     If Start = b_Khandatta Then SearchInDB(W_Khandatta);


     //Search custom dictionary
     For I := 0 To SpellCustomDict.Count - 1 Do Begin
          WideData := utf8decode(SpellCustomDict[i]);
          If EditDistance(Source, WideData) <= Max_Tolerance Then
               SList.Add(WideData);
     End;

End;

Function minimum(a, b, c: Integer): Integer;
Var
     mi                       : Integer;
Begin
     mi := a;
     If (b < mi) Then
          mi := b;
     If (c < mi) Then
          mi := c;
     Result := mi;
End;

Function EditDistance(s, t: WideString): Integer;
Var
     d                        : Array Of Array Of Integer;
     n, m, i, j, costo        : Integer;
     s_i, t_j                 : Widechar;
Begin
     n := Length(s);
     m := Length(t);
     If (n = 0) Then Begin
          Result := m;
          Exit;
     End;
     If m = 0 Then Begin
          Result := n;
          Exit;
     End;
     setlength(d, n + 1, m + 1);
     For i := 0 To n Do
          d[i, 0] := i;
     For j := 0 To m Do
          d[0, j] := j;
     For i := 1 To n Do Begin
          s_i := s[i];
          For j := 1 To m Do Begin
               t_j := t[j];
               If s_i = t_j Then
                    costo := 0
               Else
                    costo := 1;
               d[i, j] := Minimum(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + costo);
          End;
     End;
     Result := d[n, m];
End;

End.

