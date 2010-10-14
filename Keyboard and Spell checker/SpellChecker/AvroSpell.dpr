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

Library AvroSpell;


Uses
     SysUtils,
     Classes,
     Windows,
     widestrings,
     widestrutils,
     StrUtils,
     Controls,
     Forms,
     BanglaChars In '..\Units\BanglaChars.pas',
     clsPhoneticRegExBuilder_Spell In 'clsPhoneticRegExBuilder_Spell.pas',
     clsReversePhonetic In 'clsReversePhonetic.pas',
     clsSpellPhoneticSuggestionBuilder In 'clsSpellPhoneticSuggestionBuilder.pas',
     Hashing In 'Hashing.pas',
     HashTable In 'HashTable.pas',
     Phonetic_RegExp_Constants_Spell In 'Phonetic_RegExp_Constants_Spell.pas',
     uCustomDictionary In 'uCustomDictionary.pas',
     ufrmSpellOptions In 'ufrmSpellOptions.pas' {frmSpellOptions},
     ufrmSpellPopUp In 'ufrmSpellPopUp.pas' {frmSpellPopUp},
     uRegExPhoneticSearch_Spell In 'uRegExPhoneticSearch_Spell.pas',
     uSimilarSort_Spell In 'uSimilarSort_Spell.pas',
     uSpellEditDistanceSearch In 'uSpellEditDistanceSearch.pas',
     PCRE In '..\Units\PCRE.pas',
     pcre_dll In '..\Units\pcre_dll.pas',
     cDictionaries In '..\Units\cDictionaries.pas',
     cUtils In '..\Units\cUtils.pas',
     cTypes In '..\Units\cTypes.pas',
     cArrays In '..\Units\cArrays.pas',
     cStrings In '..\Units\cStrings.pas',
     uFileFolderHandling In '..\Units\uFileFolderHandling.pas',
     uDBase In '..\Units\uDBase.pas',
     uRegistrySettings In 'uRegistrySettings.pas',
     nativexml In '..\Units\nativexml.pas',
     ufrmAbout In 'ufrmAbout.pas' {frmAbout},
     clsRegistry_XMLSetting In 'clsRegistry_XMLSetting.pas',
     clsFileVersion In '..\Classes\clsFileVersion.pas',
     uWindowHandlers In '..\Units\uWindowHandlers.pas';

{$R *.res}



Var
     Initialized              : Boolean;



     {===============================================================================}

Function UnicodeDeNormalize(Const W: WideString): WideString;
Begin
     Result := W;
     Result := widestrutils.WideReplaceStr(Result, b_B + b_Nukta, b_r);
     Result := widestrutils.WideReplaceStr(Result, b_Dd + b_Nukta, b_Rr);
     Result := widestrutils.WideReplaceStr(Result, b_Ddh + b_Nukta, b_Rrh);
     Result := widestrutils.WideReplaceStr(Result, b_Z + b_Nukta, b_Y);
End;

{===============================================================================}

Function CanIgnoreByOption(W: WideString): Boolean;
Var
     Spell_IgnoreNumbers, Spell_IgnoreAncient, Spell_IgnoreAssamese, Spell_IgnoreSingle: Boolean;

     theRegex                 : IRegex;
     theMatch                 : IMatch;
     theLocale                : ansistring;
     RegExOpt                 : TRegMatchOptions;
     RegExCompileOptions      : TRegCompileOptions;

     SearchStr                : AnsiString;
     AnsiW                    : AnsiString;
Begin
     Result := False;
     AnsiW := utf8encode(w);

     If IgnoreNumber = 'YES' Then
          Spell_IgnoreNumbers := True
     Else
          Spell_IgnoreNumbers := False;

     If IgnoreAncient = 'YES' Then
          Spell_IgnoreAncient := True
     Else
          Spell_IgnoreAncient := False;

     If IgnoreAssamese = 'YES' Then
          Spell_IgnoreAssamese := True
     Else
          Spell_IgnoreAssamese := False;

     If IgnoreSingle = 'YES' Then
          Spell_IgnoreSingle := True
     Else
          Spell_IgnoreSingle := False;


     RegExOpt := [];
     theLocale := 'C';
     RegExCompileOptions := DecodeRegCompileOptions({PCRE_CASELESS Or}PCRE_UTF8);

     If Spell_IgnoreSingle Then Begin
          If Length(W) < 2 Then Begin
               Result := True;
               exit;
          End;
     End;

     If Spell_IgnoreNumbers Then Begin
          SearchStr := utf8encode('^.*[' + b_0 + b_1 + b_2 + b_3 + b_4 + b_5 + b_6 + b_7 + b_8 + b_9 + '].*$');
          theRegex := Pcre.RegexCreate(SearchStr, RegExCompileOptions, theLocale);
          theMatch := theRegex.Match(AnsiW, RegExOpt);
          If theMatch.Success Then Begin
               Result := True;
               exit;
          End;
     End;

     If Spell_IgnoreAssamese Then Begin
          SearchStr := utf8encode('^.*[' + AssamRa + AssamVa + '].*$');
          theRegex := Pcre.RegexCreate(SearchStr, RegExCompileOptions, theLocale);
          theMatch := theRegex.Match(AnsiW, RegExOpt);
          If theMatch.Success Then Begin
               Result := True;
               exit;
          End;
     End;

     If Spell_IgnoreAncient Then Begin
          SearchStr := utf8encode('^.*[' + b_Vocalic_L + b_Vocalic_LL + b_Vocalic_RR + b_Vocalic_RR_Kar + b_Vocalic_L_Kar + b_Vocalic_LL_Kar + b_Avagraha + b_LengthMark + b_RupeeMark + b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 + b_CurrencyNumerator4 + b_CurrencyNumerator1LessThanDenominator + b_CurrencyDenominator16 + b_CurrencyEsshar + '].*$');
          theRegex := Pcre.RegexCreate(SearchStr, RegExCompileOptions, theLocale);
          theMatch := theRegex.Match(AnsiW, RegExOpt);
          If theMatch.Success Then Begin
               Result := True;
               exit;
          End;
     End;
End;

{===============================================================================}

Function SplitSuggestion(w: widestring): WideString;
Var
     I, Len                   : Integer;
     part1, part2             : widestring;
Begin
     Result := '';
     Len := Length(w);
     I := 0;
     Repeat
          i := i + 1;
          part1 := LeftStr(w, i);
          part2 := MidStr(w, i + 1, len);

          If (WordPresent(part1) = true) And (WordPresent(part2) = true) Then Begin
               Result := part1 + ' ' + part2;
               break;
          End;


     Until i > len;
End;

{===============================================================================}
{===============================================================================}
{===============================================================================}
{===============================================================================}

Procedure RegisterCallback(mCallback: TCallback); Stdcall;
Begin
     Callback := mCallback;
End;

{===============================================================================}

Procedure InitSpell; Stdcall;
Begin
     LoadWordDatabase;
     LoadSettings;
     InitSpellCustomDict;
     PhoneticSug := TPhoneticSpellSuggestion.Create;
     PhoneticResult := TWideStringList.Create;
     FuzzyResult := TWideStringList.Create;
     OtherResult := TWideStringList.Create;
     DetermineZWNJ_ZWJ := ZWJ;
     frmSpellPopUp := TfrmSpellPopUp.Create(Nil);
     Initialized := True;
End;

{===============================================================================}

Function IsWordPresent(Wrd: PWideChar; Var SAction: Integer): Boolean; Stdcall;
Var
     mWrd                     : WideString;
Begin

     If Not Initialized Then Begin
          Result := False;
          exit;
     End;

     mWrd := UnicodeDeNormalize(Wrd);

     //SAction = 0 Default
     //SAction = 1 Ignored word
     //SAction = 2 Ignored by option

     If CanIgnoreByOption(mWrd) = True Then Begin
          SAction := SA_IgnoredByOption;
          Result := True;
          exit;
     End;

     If WordPresentInIgnoreDict(mWrd) Then Begin
          SAction := SA_Ignore;
          Result := True;
          exit;
     End;

     If WordPresent(mWrd) Or WordPresentInCustomDict(mWrd) Then Begin
          SAction := SA_Default;
          Result := True;
          exit;
     End;

     Result := False;
End;

{===============================================================================}

Function WordPresentInChangeAll(Wrd: PWideChar): Boolean; Stdcall;
Var
     mWrd                     : WideString;
Begin
     mWrd := UnicodeDeNormalize(Wrd);
     Result := SpellChangeDict.HasKey(utf8encode(mWrd));
End;

{===============================================================================}

Procedure GetCorrection(Wrd: PWideChar); Stdcall;
Var
     mWrd                     : WideString;
     SplittedWord             : WideString;
Begin

     If Not Initialized Then Begin
          exit;
     End;

     mWrd := UnicodeDeNormalize(Wrd);

     //SAction = 3 Change All
     If SpellChangeDict.HasKey(utf8encode(mWrd)) Then Begin
          Callback(PWideChar(mWrd), PWideChar(utf8decode(SpellChangeDict.Item[utf8encode(mWrd)])), SA_ReplaceAll);
          exit;
     End;

     PhoneticResult.Clear;
     FuzzyResult.Clear;
     OtherResult.Clear;

     //Bisharga to colon
     If RightStr(mWrd, 1) = b_bisharga Then Begin
          If WordPresent(LeftStr(mWrd, Length(mWrd) - 1)) Then
               OtherResult.Add(LeftStr(mWrd, Length(mWrd) - 1) + ':');
     End
     Else Begin
          //Phonetic errors
          PhoneticSug.BuildSuggestion(mWrd, PhoneticResult);
          //Suggestion from fuzzy search ("Substitution", "Insertion", "Deletion" errors)
          SearchSuggestion(mWrd, FuzzyResult, 1);
     End;

     //Splitted suggestion  (Words Joined?)
     If (PhoneticResult.Count + FuzzyResult.Count) <= 0 Then Begin
          SplittedWord := SplitSuggestion(mWrd);
          If SplittedWord <> '' Then
               OtherResult.Add(SplittedWord);
     End;

     //Rest Transposition and OCR errors for next version
     { TODO : transposition and OCR errors}


     frmSpellPopUp.Edit_NotFound.Text := mWrd;
     frmSpellPopUp.Show;
End;

{===============================================================================}

Procedure SetWordPosInScreen(xPoint, yPoint: Integer); Stdcall;
Begin
     MoveToOptimumPos(xPoint, yPoint);
End;

{===============================================================================}

Procedure HideSpeller; Stdcall;
Begin
     frmSpellPopUp.Hide;
End;

{===============================================================================}

Procedure ShowOptions; Stdcall;
Begin
     LoadSettings;
     frmSpellOptions := TfrmSpellOptions.Create(Nil);
     frmSpellOptions.Show;
End;

{===============================================================================}

Procedure ShowAbout; Stdcall;
Begin
     frmAbout := TfrmAbout.Create(Nil);
     frmAbout.Show;
End;

{===============================================================================}

Procedure ForgetChangeIgnore; Stdcall;
Begin
     If Not Initialized Then exit;

     Try
          SpellIgnoreDict.Clear;
          SpellChangeDict.Clear;
     Except
          //
     End;
End;

{===============================================================================}

Procedure UnloadAll; Stdcall;
Begin
     Try
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

          frmSpellPopUp.Close;
     Except
          //
     End;
     Initialized := False;
End;

{===============================================================================}
{===============================================================================}
{===============================================================================}
{===============================================================================}


Exports
     InitSpell,
     IsWordPresent,
     RegisterCallback,
     WordPresentInChangeAll,
     GetCorrection,
     SetWordPosInScreen,
     HideSpeller,
     ShowOptions,
     ShowAbout,
     ForgetChangeIgnore,
     UnloadAll;
Begin

End.

