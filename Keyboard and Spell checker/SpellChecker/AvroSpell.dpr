{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

library AvroSpell;

uses
  SysUtils,
  Windows,
  StrUtils,
  System.RegularExpressions,
  BanglaChars in '..\Units\BanglaChars.pas',
  clsPhoneticRegExBuilder_Spell in 'clsPhoneticRegExBuilder_Spell.pas',
  clsReversePhonetic in 'clsReversePhonetic.pas',
  uFileFolderHandling in '..\Units\uFileFolderHandling.pas',
  uDBase in '..\Units\uDBase.pas',
  clsSpellPhoneticSuggestionBuilder in 'clsSpellPhoneticSuggestionBuilder.pas',
  HashTable in 'HashTable.pas',
  Phonetic_RegExp_Constants_Spell in 'Phonetic_RegExp_Constants_Spell.pas',
  uCustomDictionary in 'uCustomDictionary.pas',
  uWindowHandlers in '..\Units\uWindowHandlers.pas',
  uRegExPhoneticSearch_Spell in 'uRegExPhoneticSearch_Spell.pas',
  uSimilarSort_Spell in 'uSimilarSort_Spell.pas',
  uSpellEditDistanceSearch in 'uSpellEditDistanceSearch.pas',
  uRegistrySettings in 'uRegistrySettings.pas',
  ufrmAbout in 'ufrmAbout.pas' {frmAbout} ,
  clsRegistry_XMLSetting in 'clsRegistry_XMLSetting.pas',
  clsFileVersion in '..\Classes\clsFileVersion.pas',
  ufrmSpellOptions in 'ufrmSpellOptions.pas' {frmSpellOptions} ,
  ufrmSpellPopUp in 'ufrmSpellPopUp.pas' {frmSpellPopUp} ,
  Forms,
  Classes;

{$R *.res}

var
  Initialized: Boolean;

  { =============================================================================== }

function UnicodeDeNormalize(const W: string): string;
begin
  Result := W;
  Result := ReplaceStr(Result, b_B + b_Nukta, b_r);
  Result := ReplaceStr(Result, b_Dd + b_Nukta, b_Rr);
  Result := ReplaceStr(Result, b_Ddh + b_Nukta, b_Rrh);
  Result := ReplaceStr(Result, b_Z + b_Nukta, b_Y);
end;

{ =============================================================================== }

function CanIgnoreByOption(W: string): Boolean;
var
  Spell_IgnoreNumbers, Spell_IgnoreAncient, Spell_IgnoreAssamese, Spell_IgnoreSingle: Boolean;
  theRegex:                                                                           TRegex;
  SearchStr:                                                                          string;

begin
  Result := False;

  Spell_IgnoreNumbers := IgnoreNumber = 'YES';
  Spell_IgnoreAncient := IgnoreAncient = 'YES';
  Spell_IgnoreAssamese := IgnoreAssamese = 'YES';
  Spell_IgnoreSingle := IgnoreSingle = 'YES';

  if Spell_IgnoreSingle then
  begin
    if Length(W) < 2 then
    begin
      Result := True;
      Exit;
    end;
  end;

  if Spell_IgnoreNumbers then
  begin
    SearchStr := '^.*[' + b_0 + b_1 + b_2 + b_3 + b_4 + b_5 + b_6 + b_7 + b_8 + b_9 + '].*$';
    theRegex := TRegex.Create(SearchStr, [roCompiled]);
    // Use roUnicode for UTF-8
    if theRegex.IsMatch(W) then
    begin
      Result := True;
      Exit;
    end;
  end;

  if Spell_IgnoreAssamese then
  begin
    SearchStr := '^.*[' + AssamRa + AssamVa + '].*$';
    theRegex := TRegex.Create(SearchStr, [roCompiled]);
    if theRegex.IsMatch(W) then
    begin
      Result := True;
      Exit;
    end;
  end;

  if Spell_IgnoreAncient then
  begin
    SearchStr := '^.*[' + b_Vocalic_L + b_Vocalic_LL + b_Vocalic_RR + b_Vocalic_RR_Kar + b_Vocalic_L_Kar + b_Vocalic_LL_Kar + b_Avagraha + b_LengthMark +
      b_RupeeMark + b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 + b_CurrencyNumerator4 + b_CurrencyNumerator1LessThanDenominator +
      b_CurrencyDenominator16 + b_CurrencyEsshar + '].*$';
    theRegex := TRegex.Create(SearchStr, [roCompiled]);
    if theRegex.IsMatch(W) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

{ =============================================================================== }

function SplitSuggestion(W: string): string;
var
  I, Len:       Integer;
  part1, part2: string;
begin
  Result := '';
  Len := Length(W);
  I := 0;
  repeat
    I := I + 1;
    part1 := LeftStr(W, I);
    part2 := MidStr(W, I + 1, Len);

    if (WordPresent(part1) = True) and (WordPresent(part2) = True) then
    begin
      Result := part1 + ' ' + part2;
      break;
    end;

  until I > Len;
end;

{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }

procedure Avro_RegisterCallback(mCallback: TCallback); stdcall;
begin
  try
    Callback := mCallback;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_InitSpell; stdcall;
begin
  try
    LoadWordDatabase;
    LoadSettings;
    InitSpellCustomDict;
    PhoneticSug := TPhoneticSpellSuggestion.Create;
    PhoneticResult := TStringList.Create;
    FuzzyResult := TStringList.Create;
    OtherResult := TStringList.Create;
    DetermineZWNJ_ZWJ := ZWJ;

    frmSpellPopUp := TfrmSpellPopUp.Create(Application);

    Initialized := True;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

function Avro_IsWordPresent(Wrd: PChar; var SAction: Integer): LongBool; stdcall;
var
  mWrd: string;
begin

  Result := False;
  try
    if not Initialized then
    begin
      Exit;
    end;

    mWrd := UnicodeDeNormalize(Wrd);

    // SAction = 0 Default
    // SAction = 1 Ignored word
    // SAction = 2 Ignored by option

    if CanIgnoreByOption(mWrd) = True then
    begin
      SAction := SA_IgnoredByOption;
      Result := True;
      Exit;
    end;

    if WordPresentInIgnoreDict(mWrd) then
    begin
      SAction := SA_Ignore;
      Result := True;
      Exit;
    end;

    if WordPresent(mWrd) or WordPresentInCustomDict(mWrd) then
    begin
      SAction := SA_Default;
      Result := True;
      Exit;
    end;

    Result := False;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

function Avro_WordPresentInChangeAll(Wrd: PChar): LongBool; stdcall;
var
  mWrd: string;
begin
  Result := False;
  try
    mWrd := UnicodeDeNormalize(Wrd);
    Result := SpellChangeDict.ContainsKey(mWrd);
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_GetCorrection(Wrd: PChar); stdcall;
var
  mWrd:         string;
  SplittedWord: string;
begin
  try
    if not Initialized then
    begin
      Exit;
    end;

    mWrd := UnicodeDeNormalize(Wrd);

    // SAction = 3 Change All
    if SpellChangeDict.ContainsKey(mWrd) then
    begin
      Callback(PChar(mWrd), PChar((SpellChangeDict.Items[mWrd])), SA_ReplaceAll);
      Exit;
    end;

    PhoneticResult.Clear;
    FuzzyResult.Clear;
    OtherResult.Clear;

    // Bisharga to colon
    if RightStr(mWrd, 1) = b_bisharga then
    begin
      if WordPresent(LeftStr(mWrd, Length(mWrd) - 1)) then
        OtherResult.Add(LeftStr(mWrd, Length(mWrd) - 1) + ':');
    end
    else
    begin
      // Phonetic errors
      PhoneticSug.BuildSuggestion(mWrd, PhoneticResult);
      // Suggestion from fuzzy search ("Substitution", "Insertion", "Deletion" errors)
      SearchSuggestion(mWrd, FuzzyResult, 1);
    end;

    // Splitted suggestion  (Words Joined?)
    if (PhoneticResult.Count + FuzzyResult.Count) <= 0 then
    begin
      SplittedWord := SplitSuggestion(mWrd);
      if SplittedWord <> '' then
      begin
        OtherResult.Add(SplittedWord);
        OtherResult.Add(ReplaceStr(SplittedWord, ' ', '-'));
      end;
    end;

    // Rest Transposition and OCR errors for next version
    { TODO : transposition and OCR errors }

    frmSpellPopUp.Edit_NotFound.Text := mWrd;
    frmSpellPopUp.Show;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_SetWordPosInScreen(xPoint, yPoint: Integer); stdcall;
begin
  try
    MoveToOptimumPos(xPoint, yPoint);
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_HideSpeller; stdcall;
begin
  try
    frmSpellPopUp.Hide;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_ShowOptions; stdcall;
begin
  try
    LoadSettings;
    frmSpellOptions := TfrmSpellOptions.Create(Application);
    frmSpellOptions.Show;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_ShowAbout; stdcall;
begin
  try
    frmAbout := TfrmAbout.Create(Application);
    frmAbout.Show;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_ForgetChangeIgnore; stdcall;
begin
  if not Initialized then
    Exit;

  try
    SpellIgnoreDict.Clear;
    SpellChangeDict.Clear;
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
end;

{ =============================================================================== }

procedure Avro_UnloadAll; stdcall;
begin
  try
    frmSpellPopUp.Close;

    SaveSettings;

    SaveSpellCustomDict;
    UnloadWordDatabase;

    FreeAndNil(PhoneticSug);
    PhoneticResult.Clear;
    FreeAndNil(PhoneticResult);
    FuzzyResult.Clear;
    FreeAndNil(FuzzyResult);
    OtherResult.Clear;
    FreeAndNil(OtherResult);
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

    end;
  end;
  Initialized := False;
end;

{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }

exports
  Avro_InitSpell,
  Avro_RegisterCallback,
  Avro_IsWordPresent,
  Avro_WordPresentInChangeAll,
  Avro_GetCorrection,
  Avro_SetWordPosInScreen,
  Avro_HideSpeller,
  Avro_ShowOptions,
  Avro_ShowAbout,
  Avro_ForgetChangeIgnore,
  Avro_UnloadAll;

begin

end.
