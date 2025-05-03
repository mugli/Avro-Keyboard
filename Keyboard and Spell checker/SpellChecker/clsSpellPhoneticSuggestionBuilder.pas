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

Unit clsSpellPhoneticSuggestionBuilder;

Interface

Uses
  BanglaChars,
  SysUtils,
  StrUtils,
  clsReversePhonetic,
  clsPhoneticRegExBuilder_Spell,
  uRegExPhoneticSearch_Spell,
  classes;

Type
  StringArray = Array Of String;

Type
  TPhoneticSpellSuggestion = Class
  Private
    FWord: String;
    FReversePhonetic: TReversePhonetic;
    FEnglishToRegEx: TEnglishToRegEx;
    FResult: TStringList;

    Procedure Search;
    Procedure AddSuffix(MainStr: String);

  Public
    Procedure BuildSuggestion(WrongWord: String; Var Suggestion: TStringList);
    Constructor Create;
    Destructor Destroy; Override;
  End;

Implementation

Uses uDBase;

Procedure TPhoneticSpellSuggestion.Search;
Var
  rPhoneticText: String;
Begin
  rPhoneticText := FReversePhonetic.Convert(FWord);

  FResult.Clear;
  AddSuffix(rPhoneticText);

End;

Procedure TPhoneticSpellSuggestion.AddSuffix(MainStr: String);
Var
  iLen, J, K: Integer;
  isSuffix, WithoutSuffix: String;
  B_Suffix: String;
  TempList: TStringList;
  ListOfPart: TStringList;

  rPhoneticRegx: String;
Begin
  iLen := Length(MainStr);
  FResult.Sorted := True;
  FResult.Duplicates := dupIgnore;

  ListOfPart := TStringList.Create;
  ListOfPart.Sorted := True;
  ListOfPart.Duplicates := dupIgnore;

  TempList := TStringList.Create;
  TempList.Sorted := True;
  TempList.Duplicates := dupIgnore;

  rPhoneticRegx := FEnglishToRegEx.Convert(MainStr);
  SearchPhonetic_Spell(MainStr, rPhoneticRegx, TempList);

  If iLen >= 2 Then
  Begin
    For J := 2 To iLen Do
    Begin
      isSuffix := LowerCase(MidStr(MainStr, J, iLen));
      If Suffix.TryGetValue(isSuffix, B_Suffix) Then
      Begin
        WithoutSuffix := leftstr(MainStr, Length(MainStr) - Length(isSuffix));

        ListOfPart.Clear;
        rPhoneticRegx := FEnglishToRegEx.Convert(WithoutSuffix);
        SearchPhonetic_Spell(WithoutSuffix, rPhoneticRegx, ListOfPart);

        For K := 0 To ListOfPart.Count - 1 Do
        Begin
          If IsVowel(RightStr(ListOfPart[K], 1)) And
            (IsKar(leftstr(B_Suffix, 1))) Then
            TempList.Add(ListOfPart[K] + b_Y + B_Suffix)
          Else
          Begin
            If RightStr(ListOfPart[K], 1) = b_Khandatta Then
              TempList.Add(MidStr(ListOfPart[K], 1, Length(ListOfPart[K]) - 1) +
                b_T + B_Suffix)
            Else If RightStr(ListOfPart[K], 1) = b_Anushar Then
              TempList.Add(MidStr(ListOfPart[K], 1, Length(ListOfPart[K]) - 1) +
                b_NGA + B_Suffix)
            Else
              TempList.Add(ListOfPart[K] + B_Suffix);
          End;
        End;
      End;
    End;
  End;

  For J := 0 To TempList.Count - 1 Do
  Begin
    FResult.Add(TempList[J]);
  End;

  TempList.Clear;
  ListOfPart.Clear;
  FreeAndNil(TempList);
  FreeAndNil(ListOfPart);

End;

Procedure TPhoneticSpellSuggestion.BuildSuggestion(WrongWord: String;
  Var Suggestion: TStringList);
Begin
  FWord := Trim(WrongWord);
  Search;
  Suggestion.Assign(FResult);
End;

Constructor TPhoneticSpellSuggestion.Create;
Begin
  Inherited Create;
  FReversePhonetic := TReversePhonetic.Create;
  FEnglishToRegEx := TEnglishToRegEx.Create;
  FResult := TStringList.Create;
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

End.
