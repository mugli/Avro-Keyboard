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
		 Hashing in 'Hashing.pas',
		 HashTable in 'HashTable.pas',
		 Phonetic_RegExp_Constants_Spell in 'Phonetic_RegExp_Constants_Spell.pas',
		 uCustomDictionary in 'uCustomDictionary.pas',
		 uWindowHandlers in '..\Units\uWindowHandlers.pas',
		 uRegExPhoneticSearch_Spell in 'uRegExPhoneticSearch_Spell.pas',
		 uSimilarSort_Spell in 'uSimilarSort_Spell.pas',
		 uSpellEditDistanceSearch in 'uSpellEditDistanceSearch.pas',
		 uRegistrySettings in 'uRegistrySettings.pas',
		 ufrmAbout in 'ufrmAbout.pas' { frmAbout } ,
		 clsRegistry_XMLSetting in 'clsRegistry_XMLSetting.pas',
		 clsFileVersion in '..\Classes\clsFileVersion.pas',
		 ufrmSpellOptions in 'ufrmSpellOptions.pas' { frmSpellOptions } ,
		 ufrmSpellPopUp in 'ufrmSpellPopUp.pas' { frmSpellPopUp } ,
		 Forms,
		 Classes;

{$R *.res}

Var
		 Initialized: Boolean;

		 { =============================================================================== }

Function UnicodeDeNormalize(Const W: String): String;
Begin
		 Result := W;
		 Result := ReplaceStr(Result, b_B + b_Nukta, b_r);
		 Result := ReplaceStr(Result, b_Dd + b_Nukta, b_Rr);
		 Result := ReplaceStr(Result, b_Ddh + b_Nukta, b_Rrh);
		 Result := ReplaceStr(Result, b_Z + b_Nukta, b_Y);
End;

{ =============================================================================== }

function CanIgnoreByOption(W: String): Boolean;
var
  Spell_IgnoreNumbers, Spell_IgnoreAncient, Spell_IgnoreAssamese, Spell_IgnoreSingle: Boolean;
  theRegex: TRegex;
  SearchStr: string;

begin
  Result := False;

  Spell_IgnoreNumbers   := IgnoreNumber = 'YES';
  Spell_IgnoreAncient   := IgnoreAncient = 'YES';
  Spell_IgnoreAssamese  := IgnoreAssamese = 'YES';
  Spell_IgnoreSingle    := IgnoreSingle = 'YES';


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
    theRegex := TRegex.Create(SearchStr, [roCompiled]); // Use roUnicode for UTF-8
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
    SearchStr := '^.*[' + b_Vocalic_L + b_Vocalic_LL + b_Vocalic_RR + b_Vocalic_RR_Kar +
      b_Vocalic_L_Kar + b_Vocalic_LL_Kar + b_Avagraha + b_LengthMark + b_RupeeMark +
      b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 + b_CurrencyNumerator4 +
      b_CurrencyNumerator1LessThanDenominator + b_CurrencyDenominator16 + b_CurrencyEsshar +
      '].*$';
    theRegex := TRegex.Create(SearchStr, [roCompiled]);
    if theRegex.IsMatch(W) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

{ =============================================================================== }

Function SplitSuggestion(W: String): String;
Var
		 I, Len: Integer;
		 part1, part2: String;
Begin
		 Result := '';
		 Len := Length(W);
		 I := 0;
		 Repeat
					I := I + 1;
					part1 := LeftStr(W, I);
					part2 := MidStr(W, I + 1, Len);

					If (WordPresent(part1) = True) And (WordPresent(part2) = True) Then Begin
							 Result := part1 + ' ' + part2;
							 break;
					End;

		 Until I > Len;
End;

{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }

Procedure Avro_RegisterCallback(mCallback: TCallback); Stdcall;
Begin
		 Try
					Callback := mCallback;
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_InitSpell; Stdcall;
Begin
		 Try
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
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Function Avro_IsWordPresent(Wrd: PChar; Var SAction: Integer): LongBool; Stdcall;
Var
		 mWrd: String;
Begin

		 Result := False;
		 Try
					If Not Initialized Then Begin
							 exit;
					End;

					mWrd := UnicodeDeNormalize(Wrd);

					// SAction = 0 Default
					// SAction = 1 Ignored word
					// SAction = 2 Ignored by option

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
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Function Avro_WordPresentInChangeAll(Wrd: PChar): LongBool; Stdcall;
Var
		 mWrd: String;
Begin
		 Result := False;
		 Try
					mWrd := UnicodeDeNormalize(Wrd);
					Result := SpellChangeDict.ContainsKey(mWrd);
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_GetCorrection(Wrd: PChar); Stdcall;
Var
		 mWrd: String;
		 SplittedWord: String;
Begin
		 Try
					If Not Initialized Then Begin
							 exit;
					End;

					mWrd := UnicodeDeNormalize(Wrd);

					// SAction = 3 Change All
					If SpellChangeDict.ContainsKey(mWrd) Then Begin
							 Callback(PChar(mWrd), PChar((SpellChangeDict.Items[mWrd])), SA_ReplaceAll);
							 exit;
					End;

					PhoneticResult.Clear;
					FuzzyResult.Clear;
					OtherResult.Clear;

					// Bisharga to colon
					If RightStr(mWrd, 1) = b_bisharga Then Begin
							 If WordPresent(LeftStr(mWrd, Length(mWrd) - 1)) Then
										OtherResult.Add(LeftStr(mWrd, Length(mWrd) - 1) + ':');
					End
					Else Begin
							 // Phonetic errors
							 PhoneticSug.BuildSuggestion(mWrd, PhoneticResult);
							 // Suggestion from fuzzy search ("Substitution", "Insertion", "Deletion" errors)
							 SearchSuggestion(mWrd, FuzzyResult, 1);
					End;

					// Splitted suggestion  (Words Joined?)
					If (PhoneticResult.Count + FuzzyResult.Count) <= 0 Then Begin
							 SplittedWord := SplitSuggestion(mWrd);
							 If SplittedWord <> '' Then begin
										OtherResult.Add(SplittedWord);
                    OtherResult.Add(ReplaceStr(SplittedWord,' ', '-'));
               end;
					End;

					// Rest Transposition and OCR errors for next version
					{ TODO : transposition and OCR errors }

					frmSpellPopUp.Edit_NotFound.Text := mWrd;
					frmSpellPopUp.Show;
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_SetWordPosInScreen(xPoint, yPoint: Integer); Stdcall;
Begin
		 Try
					MoveToOptimumPos(xPoint, yPoint);
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_HideSpeller; Stdcall;
Begin
		 Try
					frmSpellPopUp.Hide;
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_ShowOptions; Stdcall;
Begin
		 Try
					LoadSettings;
					frmSpellOptions := TfrmSpellOptions.Create(Application);
					frmSpellOptions.Show;
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_ShowAbout; Stdcall;
Begin
		 Try
					frmAbout := TfrmAbout.Create(Application);
					frmAbout.Show;
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_ForgetChangeIgnore; Stdcall;
Begin
		 If Not Initialized Then
					exit;

		 Try
					SpellIgnoreDict.Clear;
					SpellChangeDict.Clear;
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
End;

{ =============================================================================== }

Procedure Avro_UnloadAll; Stdcall;
Begin
		 Try
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
		 Except
					On e: exception Do Begin
							 Application.MessageBox('Error occured on Avro spelling engine!', 'Error!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

					End;
		 End;
		 Initialized := False;
End;

{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }

Exports
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

Begin

End.
