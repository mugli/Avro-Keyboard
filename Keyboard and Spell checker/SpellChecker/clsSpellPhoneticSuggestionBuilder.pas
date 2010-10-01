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

Unit clsSpellPhoneticSuggestionBuilder;

Interface
Uses
     BanglaChars,
     SysUtils,
     StrUtils,
     WideStrUtils,
     WideStrings,
     clsReversePhonetic,
     clsPhoneticRegExBuilder_Spell,
     uRegExPhoneticSearch_Spell,
     classes;

Type
     WideStringArray = Array Of WideString;

Type
     TPhoneticSpellSuggestion = Class
     Private
          FWord: WideString;
          { FSplittedWord: WideStringArray;}
          FReversePhonetic: TReversePhonetic;
          FEnglishToRegEx: TEnglishToRegEx;
          FResult: TWideStringList;

          {  Procedure SplitWord;}
          Procedure Search;
          Procedure AddSuffix(MainStr: String);
          { Procedure TempShowSlittedWord;}
          { Procedure AppendArray(Var V: WideStringArray; Const W: WideString);}

     Public
          Procedure BuildSuggestion(WrongWord: WideString; Var Suggestion: TWideStringList);
          Constructor Create;
          Destructor Destroy; Override;
     End;

Implementation

Uses uDBase;

{ TSpellSuggestion }
{
Procedure TSpellSuggestion.AppendArray(Var V: WideStringArray; Const W: WideString);
Var
     Len                      : Integer;
Begin
     Len := Length(V);
     SetLength(V, Len + 1);
     V[Len] := W;
End;
}

Procedure TPhoneticSpellSuggestion.Search;
Var
     rPhoneticText            : String;
Begin
     rPhoneticText := FReversePhonetic.Convert(FWord);

     FResult.Clear;
     AddSuffix(rPhoneticText);

End;

Procedure TPhoneticSpellSuggestion.AddSuffix(MainStr: String);
Var
     iLen, J, K               : Integer;
     isSuffix, WithoutSuffix  : String;
     B_Suffix                 : WideString;
     TempList                 : TWideStringList;
     ListOfPart               : TWideStringList;

     rPhoneticRegx            : utf8string;
Begin
     iLen := Length(MainStr);
     FResult.Sorted := True;
     FResult.Duplicates := dupIgnore;

     ListOfPart := TWideStringList.Create;
     ListOfPart.Sorted := True;
     ListOfPart.Duplicates := DupIgnore;

     TempList := TWideStringList.Create;
     TempList.Sorted := True;
     TempList.Duplicates := DupIgnore;

     rPhoneticRegx := FEnglishToRegEx.Convert(MainStr);
     SearchPhonetic_Spell(MainStr, rPhoneticRegx, TempList);


     If iLen >= 2 Then Begin
          For j := 2 To iLen Do Begin
               isSuffix := LowerCase(MidStr(MainStr, j, iLen));
               If Suffix.HasKey(isSuffix) Then Begin
                    B_Suffix := utf8decode(Suffix.Item[isSuffix]);
                    WithoutSuffix := leftstr(MainStr, Length(MainStr) - Length(isSuffix));

                    ListOfPart.Clear;
                    rPhoneticRegx := FEnglishToRegEx.Convert(WithoutSuffix);
                    SearchPhonetic_Spell(WithoutSuffix, rPhoneticRegx, ListOfPart);

                    For K := 0 To ListOfPart.Count - 1 Do Begin
                         If IsVowel(RightStr(ListOfPart[k], 1)) And (IsKar(LeftStr(B_Suffix, 1))) Then
                              TempList.Add(ListOfPart[k] + b_Y + B_Suffix)
                         Else Begin
                              If RightStr(ListOfPart[k], 1) = b_Khandatta Then
                                   TempList.Add(MidStr(ListOfPart[k], 1, Length(ListOfPart[k]) - 1) + b_T + B_Suffix)
                              Else If RightStr(ListOfPart[k], 1) = b_Anushar Then
                                   TempList.Add(MidStr(ListOfPart[k], 1, Length(ListOfPart[k]) - 1) + b_NGA + B_Suffix)
                              Else
                                   TempList.Add(ListOfPart[k] + B_Suffix);
                         End;
                    End;
               End;
          End;
     End;

     For J := 0 To TempList.Count - 1 Do Begin
          FResult.Add(TempList[J]);
     End;

     TempList.Clear;
     ListOfPart.Clear;
     FreeAndNil(TempList);
     FreeAndNil(ListOfPart);

End;

Procedure TPhoneticSpellSuggestion.BuildSuggestion(WrongWord: WideString;
     Var Suggestion: TWideStringList);
Begin
     FWord := Trim(WrongWord);
     Search;
     Suggestion.Assign(FResult);
     //SplitWord;
     //TempShowSlittedWord;
End;

Constructor TPhoneticSpellSuggestion.Create;
Begin
     Inherited Create;
     FReversePhonetic := TReversePhonetic.Create;
     FEnglishToRegEx := TEnglishToRegEx.Create;
     FResult := TWideStringList.Create;

     //FSplittedWord := Nil;
End;

Destructor TPhoneticSpellSuggestion.Destroy;
Begin
     // FSplittedWord := Nil;
     FreeAndNil(FReversePhonetic);
     FreeAndNil(FEnglishToRegEx);
     FResult.Clear;
     FreeAndNil(FResult);
     Inherited Destroy;
End;
{
Procedure TSpellSuggestion.SplitWord;
Var
     Len, iPos                : Integer;
     WC, SplitPart            : WideString;
     /////////////////////////////////

     Function NextT: WideString;
     Var
          I                   : Integer;
     Begin
          i := ipos + 1;
          If i > Len Then Begin
               Result := '';
               exit;
          End;
          Result := FWord[i];
     End;
     ////////////////////////////////

     Function PrevT: WideString;
     Var
          i                   : Integer;
     Begin
          i := ipos - 1;
          If i < 1 Then Begin
               Result := '';
               Exit;
          End;
          Result := FWord[i];
     End;
     ////////////////////////////////

     Function NextTEx(iLength: Integer; skipstart: Integer = 0): WideString;
     Begin
          If iLength < 1 Then iLength := 1;
          NextTEx := MidStr(FWord, ipos + skipstart + 1, iLength);
     End;
     ////////////////////////////////

     Function PrevTEx(Const Position: Integer): WideString;
     Var
          i                   : integer;
     Begin
          i := ipos - Position;
          If i < 1 Then Begin
               Result := '';
               Exit;
          End;
          Result := FWord[i];
     End;
     ///////////////////////////////

     Procedure SeperateReph;
     Var
          tempArray           : WideStringArray;
          ArrayItem           : WideString;
          I                   : Integer;
          RephFound           : Boolean;
     Begin
          tempArray := Nil;
          RephFound := False;
          For I := Low(FSplittedWord) To High(FSplittedWord) Do Begin
               ArrayItem := FSplittedWord[I];
               If (LeftStr(ArrayItem, 2) = b_R + b_Hasanta) And (Length(ArrayItem) > 2) Then Begin
                    //Reph Found
                    AppendArray(tempArray, b_R + b_Hasanta); //Reph
                    AppendArray(tempArray, MidStr(ArrayItem, 3, Length(ArrayItem))); //Rest of reph
                    RephFound := True;
               End
               Else
                    AppendArray(tempArray, ArrayItem);
          End;

          If RephFound Then Begin
               FSplittedWord := Nil;
               SetLength(FSplittedWord, Length(tempArray));

               For I := Low(tempArray) To High(tempArray) Do
                    FSplittedWord[i] := tempArray[i];
          End;
     End;
     //////////////////////////////

     Procedure SeperateZfola;
     Var
          tempArray           : WideStringArray;
          ArrayItem           : WideString;
          I                   : Integer;
          ZfolaFound          : Boolean;
     Begin
          tempArray := Nil;
          ZfolaFound := False;
          For I := Low(FSplittedWord) To High(FSplittedWord) Do Begin
               ArrayItem := FSplittedWord[I];
               If (RightStr(ArrayItem, 2) = b_hasanta + b_Z) And (Length(ArrayItem) > 2) Then Begin
                    ZfolaFound := True;
                    AppendArray(tempArray, LeftStr(ArrayItem, Length(ArrayItem) - 2));
                    AppendArray(tempArray, b_hasanta + b_Z); //Z-Fola
               End
               Else
                    AppendArray(tempArray, ArrayItem);
          End;

          If ZfolaFound Then Begin
               FSplittedWord := Nil;
               SetLength(FSplittedWord, Length(tempArray));

               For I := Low(tempArray) To High(tempArray) Do
                    FSplittedWord[i] := tempArray[i];
          End;
     End;

     //////////////////////////////

Begin
     FSplittedWord := Nil;
     Len := Length(FWord);
     If Len <= 0 Then exit;
     iPos := 1;
     SplitPart := '';
     Repeat
          WC := FWord[iPos];
          SplitPart := SplitPart + WC;
          If WC <> b_Hasanta Then Begin
               If (NextT <> b_hasanta) And (PrevT <> b_Hasanta) Then Begin //Individual Letters
                    AppendArray(FSplittedWord, SplitPart);
                    SplitPart := '';
                    inc(iPos);
               End
               Else If (NextT = b_hasanta) And (PrevT <> b_Hasanta) Then Begin //Begining of Juktakkhor
                    inc(iPos);
               End
               Else If (NextT <> b_hasanta) And (PrevT = b_Hasanta) Then Begin //End  of Juktakkhor
                    AppendArray(FSplittedWord, SplitPart);
                    SplitPart := '';
                    inc(iPos);
               End
               Else If (NextT = b_hasanta) And (PrevT = b_Hasanta) Then Begin //Inside Juktakkhar
                    inc(iPos);
               End;
          End
          Else Begin
               If NextT <> '' Then
                    inc(iPos)
               Else Begin               //ending hasanta
                    AppendArray(FSplittedWord, SplitPart);
                    SplitPart := '';
                    inc(iPos);
               End;
          End;
     Until iPos > Len;
     SeperateReph;
     SeperateZfola;

End;

Procedure TSpellSuggestion.TempShowSlittedWord;
Var
     I                        : integer;
Begin
     form1.Memo.Clear;
     If Length(FSplittedWord) <= 0 Then exit;

     For i := Low(FSplittedWord) To High(FSplittedWord) Do Begin
          form1.Memo.Lines.Add(FSplittedWord[i]);
     End;

End;
}
End.

