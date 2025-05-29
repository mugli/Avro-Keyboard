{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit clsSpellPhoneticSuggestionBuilder;

interface

uses
  BanglaChars,
  SysUtils,
  StrUtils,
  clsReversePhonetic,
  clsPhoneticRegExBuilder_Spell,
  uRegExPhoneticSearch_Spell,
  classes;

type
  TPhoneticSpellSuggestion = class
    private
      FWord:            string;
      FReversePhonetic: TReversePhonetic;
      FEnglishToRegEx:  TEnglishToRegEx;
      FResult:          TStringList;

      procedure Search;
      procedure AddSuffix(MainStr: string);

    public
      procedure BuildSuggestion(WrongWord: string; var Suggestion: TStringList);
      constructor Create;
      destructor Destroy; override;
  end;

implementation

uses
  uDBase;

procedure TPhoneticSpellSuggestion.Search;
var
  rPhoneticText: string;
begin
  rPhoneticText := FReversePhonetic.Convert(FWord);

  FResult.Clear;
  AddSuffix(rPhoneticText);
end;

procedure TPhoneticSpellSuggestion.AddSuffix(MainStr: string);
var
  iLen, J, K:              Integer;
  isSuffix, WithoutSuffix: string;
  B_Suffix:                string;
  TempList:                TStringList;
  ListOfPart:              TStringList;

  rPhoneticRegx: string;
begin
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

  if iLen >= 2 then
  begin
    for J := 2 to iLen do
    begin
      isSuffix := LowerCase(MidStr(MainStr, J, iLen));
      if Suffix.TryGetValue(isSuffix, B_Suffix) then
      begin
        WithoutSuffix := leftstr(MainStr, Length(MainStr) - Length(isSuffix));

        ListOfPart.Clear;
        rPhoneticRegx := FEnglishToRegEx.Convert(WithoutSuffix);
        SearchPhonetic_Spell(WithoutSuffix, rPhoneticRegx, ListOfPart);

        for K := 0 to ListOfPart.Count - 1 do
        begin
          if IsVowel(RightStr(ListOfPart[K], 1)) and (IsKar(leftstr(B_Suffix, 1))) then
            TempList.Add(ListOfPart[K] + b_Y + B_Suffix)
          else
          begin
            if RightStr(ListOfPart[K], 1) = b_Khandatta then
              TempList.Add(MidStr(ListOfPart[K], 1, Length(ListOfPart[K]) - 1) + b_T + B_Suffix)
            else if RightStr(ListOfPart[K], 1) = b_Anushar then
              TempList.Add(MidStr(ListOfPart[K], 1, Length(ListOfPart[K]) - 1) + b_NGA + B_Suffix)
            else
              TempList.Add(ListOfPart[K] + B_Suffix);
          end;
        end;
      end;
    end;
  end;

  for J := 0 to TempList.Count - 1 do
  begin
    FResult.Add(TempList[J]);
  end;

  TempList.Clear;
  ListOfPart.Clear;
  FreeAndNil(TempList);
  FreeAndNil(ListOfPart);

end;

procedure TPhoneticSpellSuggestion.BuildSuggestion(WrongWord: string; var Suggestion: TStringList);
begin
  FWord := Trim(WrongWord);
  Search;
  Suggestion.Assign(FResult);
end;

constructor TPhoneticSpellSuggestion.Create;
begin
  inherited Create;
  FReversePhonetic := TReversePhonetic.Create;
  FEnglishToRegEx := TEnglishToRegEx.Create;
  FResult := TStringList.Create;
end;

destructor TPhoneticSpellSuggestion.Destroy;
begin
  // FSplittedWord := Nil;
  FreeAndNil(FReversePhonetic);
  FreeAndNil(FEnglishToRegEx);
  FResult.Clear;
  FreeAndNil(FResult);
  inherited Destroy;
end;

end.
