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

Unit ufrmSpellPopUp;

Interface

Uses
     Windows,
     Messages,
     SysUtils,
     Variants,
     Classes,
     Graphics,
     Controls,
     Forms,
     Dialogs,
     StdCtrls,
     TntStdCtrls,
     clsMemoParser,
     ComCtrls,
     clsSpellPhoneticSuggestionBuilder,
     widestrings;

Type
     TfrmSpellPopUp = Class(TForm)
          Label1: TLabel;
          Label2: TLabel;
          Edit_NotFound: TTntEdit;
          Edit_ChangeTo: TTntEdit;
          List: TTntListBox;
          Label3: TLabel;
          But_Cancel: TButton;
          But_Options: TButton;
          But_Ignore: TButton;
          But_IgnoreAll: TButton;
          But_AddToDict: TButton;
          But_Change: TButton;
          But_ChangeAll: TButton;
          CheckLessPreffered: TCheckBox;
          Procedure FormCreate(Sender: TObject);
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure But_ChangeClick(Sender: TObject);
          Procedure But_IgnoreClick(Sender: TObject);
          Procedure But_CancelClick(Sender: TObject);
          Procedure But_IgnoreAllClick(Sender: TObject);
          Procedure But_ChangeAllClick(Sender: TObject);
          Procedure But_AddToDictClick(Sender: TObject);
          Procedure Edit_ChangeToChange(Sender: TObject);
          Procedure ListClick(Sender: TObject);
          Procedure ListKeyUp(Sender: TObject; Var Key: Word; Shift: TShiftState);
          Procedure Edit_ChangeToKeyUp(Sender: TObject; Var Key: Word;
               Shift: TShiftState);
          Procedure ListDblClick(Sender: TObject);
          Procedure CheckLessPrefferedClick(Sender: TObject);
          Procedure But_OptionsClick(Sender: TObject);
     Private
          { Private declarations }
          MP: TMemoParser;
          PhoneticSug: TPhoneticSpellSuggestion;

          //Suggestions by various methods
          PhoneticResult: TWideStringList;
          FuzzyResult: TWideStringList;
          OtherResult: TWideStringList;
          DetermineZWNJ_ZWJ: WideString;

          Procedure ShowSuggestion(FullResult: Boolean);

          Function CanIgnoreByOption(W: WideString): Boolean;
          Function SplitSuggestion(w: widestring): WideString;
          Procedure MP_WordFound(CurrentWord: WideString);
          Procedure MP_CompleteParsing;
          Procedure Suggest;
          Function UnicodeDeNormalize(Const W: WideString): WideString;
          Procedure MP_TotalProgress(CurrentProgress: Integer);
     Public
          { Public declarations }
     End;

Var
     frmSpellPopUp            : TfrmSpellPopUp;

Implementation

{$R *.dfm}
Uses
     ufrmSpell,
     HashTable,
     uCustomDictionary,
     uSpellEditDistanceSearch,
     widestrutils,
     BanglaChars,
     uSimilarSort_Spell,
     PCRE,
     PCRE_DLL,
     StrUtils,
     uWindowHandlers,
     ufrmSpellOptions,
     uRegistrySettings,
     WindowsVersion,
     uDBase;

Procedure TfrmSpellPopUp.But_AddToDictClick(Sender: TObject);
Begin
     SpellCustomDict.Add(Edit_NotFound.Text);
     mp.BeginPursing;
End;

Procedure TfrmSpellPopUp.But_CancelClick(Sender: TObject);
Begin
     Mp.PausePursing;
     close;
End;

Procedure TfrmSpellPopUp.But_ChangeAllClick(Sender: TObject);
Begin
     mp.ReplaceCurrentWord(Edit_ChangeTo.Text, Edit_NotFound.Text);
     SpellChangeDict.Add(utf8encode(Edit_NotFound.Text), utf8encode(Edit_ChangeTo.Text));
     mp.BeginPursing;
End;

Procedure TfrmSpellPopUp.But_ChangeClick(Sender: TObject);
Begin
     mp.ReplaceCurrentWord(Edit_ChangeTo.Text, Edit_NotFound.Text);
     mp.BeginPursing;
End;

Procedure TfrmSpellPopUp.But_IgnoreAllClick(Sender: TObject);
Begin
     SpellIgnoreDict.Add(Edit_NotFound.Text);
     mp.BeginPursing;
End;

Procedure TfrmSpellPopUp.But_IgnoreClick(Sender: TObject);
Begin
     mp.BeginPursing;
End;

Procedure TfrmSpellPopUp.But_OptionsClick(Sender: TObject);
Begin
     CheckCreateForm(TfrmSpellOptions, frmSpellOptions, 'frmSpellOptions');
     frmSpellOptions.ShowModal;

     If FullSuggestion = 'YES' Then
          CheckLessPreffered.Checked := True
     Else
          CheckLessPreffered.Checked := False;
End;

Function TfrmSpellPopUp.CanIgnoreByOption(W: WideString): Boolean;
Var
     { DONE : Make these registry variable }
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

Procedure TfrmSpellPopUp.CheckLessPrefferedClick(Sender: TObject);
Begin
     If CheckLessPreffered.Checked Then Begin
          ShowSuggestion(True);
          FullSuggestion := 'YES';
     End
     Else Begin
          ShowSuggestion(False);
          FullSuggestion := 'NO';
     End;
End;

Procedure TfrmSpellPopUp.MP_WordFound(CurrentWord: WideString);
Begin
     CurrentWord := UnicodeDeNormalize(CurrentWord);

     If CanIgnoreByOption(CurrentWord) = True Then exit;

     If (WordPresent(CurrentWord) = False) And
          (WordPresentInCustomDict(CurrentWord) = False) And
          (WordPresentInIgnoreDict(CurrentWord) = False) Then Begin

          If SpellChangeDict.HasKey(utf8encode(CurrentWord)) Then
               mp.ReplaceCurrentWord(utf8decode(SpellChangeDict.Item[utf8encode(CurrentWord)]), Edit_NotFound.Text)
          Else Begin
               Mp.PausePursing;
               Edit_NotFound.Text := CurrentWord;
               mp.SelectWord;
               Suggest;
          End;

     End;
End;

Procedure TfrmSpellPopUp.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     FreeAndNil(MP);
     FreeAndNil(PhoneticSug);
     PhoneticResult.Clear;
     FreeAndNil(PhoneticResult);
     FuzzyResult.Clear;
     FreeAndNil(FuzzyResult);
     OtherResult.Create;
     FreeAndNil(OtherResult);

     Action := caFree;
     frmSpellPopUp := Nil;
End;

Procedure TfrmSpellPopUp.FormCreate(Sender: TObject);
Begin
     MP := TMemoParser.Create;
     PhoneticSug := TPhoneticSpellSuggestion.Create;
     PhoneticResult := TWideStringList.Create;
     FuzzyResult := TWideStringList.Create;
     OtherResult := TWideStringList.Create;
     Mp.OnTotalProgress := MP_TotalProgress;
     mp.OnWordFound := MP_WordFound;
     mp.OnCompleteParsing := MP_CompleteParsing;

     If FullSuggestion = 'YES' Then
          CheckLessPreffered.Checked := True
     Else
          CheckLessPreffered.Checked := False;

    // If IsWinVistaOrLater Then
          DetermineZWNJ_ZWJ := ZWJ ;
    // Else
     //     DetermineZWNJ_ZWJ := ZWNJ;


     mp.BeginPursing;
End;

Procedure TfrmSpellPopUp.ListClick(Sender: TObject);
Begin
     If List.Items[List.ItemIndex] = 'More...' Then
          ShowSuggestion(True)
     Else If List.Items[List.ItemIndex] = 'No Suggestion' Then
          //Do nothing
     Else
          Edit_ChangeTo.Text := List.Items[List.ItemIndex];
End;

Procedure TfrmSpellPopUp.ListDblClick(Sender: TObject);
Begin
     If List.Items[List.ItemIndex] = 'No Suggestion' Then exit;
     But_ChangeClick(Nil);
End;

Procedure TfrmSpellPopUp.ListKeyUp(Sender: TObject; Var Key: Word;
     Shift: TShiftState);
Begin
     ListClick(Nil);

     If Key = 13 Then
          If But_Change.Enabled Then
               But_ChangeClick(Nil);
End;

Procedure TfrmSpellPopUp.MP_CompleteParsing;
Begin
     Application.MessageBox('Spelling check is complete.', 'Avro Bangla Spell Checker', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
     close;
End;

Procedure TfrmSpellPopUp.MP_TotalProgress(CurrentProgress: Integer);
Begin
     frmSpell.Progress.Position := CurrentProgress;
     Application.ProcessMessages;
End;

Procedure TfrmSpellPopUp.ShowSuggestion(FullResult: Boolean);

     Function Fix_ZWNJ_ZWJ(inp: WideString): WideString;
     Var
          retVal              : WideString;
     Begin
          retVal := WideReplaceStr(inp, b_R + ZWNJ + b_Hasanta + b_Z,
               b_r + DetermineZWNJ_ZWJ + b_Hasanta + b_Z);

          {retVal := WideReplaceStr(inp, b_R + ZWJ + b_Hasanta + b_Z,
               b_r + DetermineZWNJ_ZWJ + b_Hasanta + b_Z);  }

          Result := retVal;
     End;

Var
     TempList                 : TWideStringList;
     I                        : Integer;
     MoreNumber               : Integer;
Begin


     TempList := TWideStringList.Create;
     TempList.Sorted := True;
     TempList.Duplicates := dupIgnore;

     Edit_ChangeTo.Text := '';
     List.Clear;

     If FullResult = True Then Begin
          If PhoneticResult.Count > 0 Then Begin
               For I := 0 To PhoneticResult.Count - 1 Do
                    TempList.Add(PhoneticResult[i]);
          End;

          If FuzzyResult.Count > 0 Then Begin
               For I := 0 To FuzzyResult.Count - 1 Do
                    TempList.Add(FuzzyResult[i]);
          End;

          If OtherResult.Count > 0 Then Begin
               For I := 0 To OtherResult.Count - 1 Do
                    TempList.Add(OtherResult[i]);
          End;

          If TempList.Count > 0 Then Begin
               SimilarSort(Edit_NotFound.Text, TempList);
               For I := 0 To TempList.Count - 1 Do
                    list.Items.Add(Fix_ZWNJ_ZWJ(TempList[i]));
          End
          Else
               list.Items.Add('No Suggestion');
     End
     Else Begin
          If PhoneticResult.Count > 0 Then Begin
               For I := 0 To PhoneticResult.Count - 1 Do
                    TempList.Add(PhoneticResult[i]);
          End;

          If OtherResult.Count > 0 Then Begin
               For I := 0 To OtherResult.Count - 1 Do
                    TempList.Add(OtherResult[i]);
          End;


          If TempList.Count <= 0 Then Begin
               If FuzzyResult.Count > 0 Then Begin
                    For I := 0 To FuzzyResult.Count - 1 Do
                         TempList.Add(Fix_ZWNJ_ZWJ(FuzzyResult[i]));
               End;
               If TempList.Count > 0 Then Begin
                    SimilarSort(Edit_NotFound.Text, TempList);
                    For I := 0 To TempList.Count - 1 Do
                         list.Items.Add(Fix_ZWNJ_ZWJ(TempList[i]));
               End
               Else
                    list.Items.Add('No Suggestion');
          End
          Else Begin
               If TempList.Count > 0 Then Begin
                    SimilarSort(Edit_NotFound.Text, TempList);
                    For I := 0 To TempList.Count - 1 Do
                         list.Items.Add(Fix_ZWNJ_ZWJ(TempList[i]));

                    MoreNumber := TempList.Count;
                    If FuzzyResult.Count > 0 Then Begin
                         For I := 0 To FuzzyResult.Count - 1 Do
                              TempList.Add(FuzzyResult[i]);
                    End;
                    If TempList.Count > MoreNumber Then list.Items.Add('More...');
               End
               Else
                    list.Items.Add('No Suggestion');
          End;
     End;


     TempList.Clear;
     FreeAndNil(TempList);
End;

Function TfrmSpellPopUp.SplitSuggestion(w: widestring): WideString;
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

Procedure TfrmSpellPopUp.Suggest;
Var
     SplittedWord             : WideString;
Begin
     PhoneticResult.Clear;
     FuzzyResult.Clear;
     OtherResult.Clear;

     //Bisharga to colon
     If RightStr(Edit_NotFound.Text, 1) = b_bisharga Then Begin
          If WordPresent(LeftStr(Edit_NotFound.Text, Length(Edit_NotFound.Text) - 1)) Then
               OtherResult.Add(LeftStr(Edit_NotFound.Text, Length(Edit_NotFound.Text) - 1) + ':');
     End
     Else Begin
          //Phonetic errors
          PhoneticSug.BuildSuggestion(Edit_NotFound.Text, PhoneticResult);
          //Suggestion from fuzzy search ("Substitution", "Insertion", "Deletion" errors)
          SearchSuggestion(Edit_NotFound.Text, FuzzyResult, 1);
     End;

     //Splitted suggestion  (Words Joined?)
     If (PhoneticResult.Count + FuzzyResult.Count) <= 0 Then Begin
          SplittedWord := SplitSuggestion(Edit_NotFound.Text);
          If SplittedWord <> '' Then
               OtherResult.Add(SplittedWord);
     End;


     //Rest Transposition and OCR errors for next version
     { TODO : transposition and OCR errors}

     If CheckLessPreffered.Checked Then
          ShowSuggestion(True)
     Else
          ShowSuggestion(False);

     If List.Count > 0 Then Begin
          List.ItemIndex := 0;
          ListClick(Nil);
     End;
End;

Function TfrmSpellPopUp.UnicodeDeNormalize(Const W: WideString): WideString;
Begin
     Result := W;
     Result := widestrutils.WideReplaceStr(Result, b_B + b_Nukta, b_r);
     Result := widestrutils.WideReplaceStr(Result, b_Dd + b_Nukta, b_Rr);
     Result := widestrutils.WideReplaceStr(Result, b_Ddh + b_Nukta, b_Rrh);
     Result := widestrutils.WideReplaceStr(Result, b_Z + b_Nukta, b_Y);
End;

Procedure TfrmSpellPopUp.Edit_ChangeToChange(Sender: TObject);
Begin
     If Edit_ChangeTo.Text = '' Then Begin
          But_Change.Enabled := False;
          But_ChangeAll.Enabled := False;
     End
     Else Begin
          But_Change.Enabled := True;
          But_ChangeAll.Enabled := True;
     End;
End;

Procedure TfrmSpellPopUp.Edit_ChangeToKeyUp(Sender: TObject; Var Key: Word;
     Shift: TShiftState);
Begin
     If Key = 13 Then
          If But_Change.Enabled Then
               But_ChangeClick(Nil);
End;



End.

