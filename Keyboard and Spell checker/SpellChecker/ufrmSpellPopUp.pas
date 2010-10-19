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
     ComCtrls,
     clsSpellPhoneticSuggestionBuilder,
     widestrings;

Type
     TfrmSpellPopUp = Class(TForm)
          Label1: TLabel;
          Label2: TLabel;
          Label3: TLabel;
          But_Cancel: TButton;
          But_Options: TButton;
          But_Ignore: TButton;
          But_IgnoreAll: TButton;
          But_AddToDict: TButton;
          But_Change: TButton;
          But_ChangeAll: TButton;
          CheckLessPreffered: TCheckBox;
          List: TTNTListBox;
          Edit_NotFound: TTNTEdit;
          Edit_ChangeTo: TTNTEdit;
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
          Procedure FormShow(Sender: TObject);
     Private
          { Private declarations }


     Public
          { Public declarations }
          Procedure ShowSuggestion(FullResult: Boolean);
     End;

Type
     TCallback = Procedure(Wrd: PWideChar; CWrd: PWideChar; SAction: Integer); stdcall;

Var
     Callback                 : TCallback;

Var
     frmSpellPopUp            : TfrmSpellPopUp;
     //Suggestions by various methods
     PhoneticSug              : TPhoneticSpellSuggestion;
     PhoneticResult           : TWideStringList;
     FuzzyResult              : TWideStringList;
     OtherResult              : TWideStringList;

     DetermineZWNJ_ZWJ        : WideString;
     //
     WordNotFound, WordSelected: WideString;

Const
     SA_Default               : Integer = 0;
     SA_Ignore                : Integer = 1;
     SA_Cancel                : Integer = -1;
     SA_IgnoredByOption       : Integer = 2;
     SA_ReplaceAll            : Integer = 3;

Procedure MoveToOptimumPos(T_X, T_Y: Integer);


Implementation

{$R *.dfm}
Uses
     uCustomDictionary,
     widestrutils,
     BanglaChars,
     uSimilarSort_Spell,
     StrUtils,
     ufrmSpellOptions,
     uRegistrySettings,
     uWindowHandlers;


Procedure MoveToOptimumPos(T_X, T_Y: Integer);

     Function ValidPosition(f_Point: TPoint): Boolean;
     Var
          hTaskBar            : THandle;
          RTaskBar, RDummy, RWindow: TRect;
     Begin
          result := False;

          //Get taskbar rectangle
          hTaskbar := FindWindow('Shell_TrayWnd', Nil);
          GetWindowRect(hTaskBar, RTaskBar);

          //Get window rectangle with proposed position
          RWindow.Top := f_Point.Y;
          RWindow.Left := f_Point.X;
          RWindow.Right := RWindow.Left + frmSpellPopUp.Width;
          RWindow.Bottom := RWindow.Top + frmSpellPopUp.Height;

          If IntersectRect(RDummy, RWindow, RTaskBar) Then
               exit;

          If (f_Point.X < 0) Or (f_Point.y < 0) Then
               exit;

          If (RWindow.Right > Screen.Width) Or (RWindow.Bottom > Screen.Height) Then
               exit;

          result := True;
     End;

Const
     MinDistance              : Integer = 20;
     WordWidth                : Integer = 50;
     WordHeight               : Integer = 50;
Var
     RWord, RWindow, RDummy   : TRect;
     Intersect                : Boolean;
     PossiblePOS1, PossiblePOS2, PossiblePOS3, PossiblePOS4: TPoint;
Begin
     If (T_X < 0) Or (T_Y < 0) Then
          exit;

     If Not assigned(frmSpellPopUp) Then
          exit;


     //Check whether current position of Window hides the text
     RWord.Left := T_X - MinDistance;
     RWord.Top := T_Y - MinDistance;
     RWord.Right := T_X + WordWidth + MinDistance;
     RWord.Bottom := T_Y + WordHeight + MinDistance;

     RWindow.Left := frmSpellPopUp.Left;
     RWindow.Top := frmSpellPopUp.Top;
     RWindow.Right := RWindow.Left + frmSpellPopUp.Width;
     RWindow.Bottom := RWindow.Top + frmSpellPopUp.Height;

     Intersect := IntersectRect(RDummy, RWindow, RWord);


     If Not Intersect Then
          exit;


     //So, current position of Window hides the text, time to move it

     //Calculate possible positions
     PossiblePOS1.X := T_X;
     PossiblePOS1.Y := T_Y - MinDistance - frmSpellPopUp.Height;

     PossiblePOS2.X := T_X;
     PossiblePOS2.Y := T_Y + MinDistance;

     PossiblePOS3.X := T_X - MinDistance - frmSpellPopUp.Width;
     PossiblePOS3.Y := T_Y;

     PossiblePOS4.X := T_X + MinDistance;
     PossiblePOS4.Y := T_Y;

     If ValidPosition(PossiblePOS1) Then Begin
          frmSpellPopUp.Left := PossiblePOS1.X;
          frmSpellPopUp.Top := PossiblePOS1.Y;
          exit;
     End;

     If ValidPosition(PossiblePOS2) Then Begin
          frmSpellPopUp.Left := PossiblePOS2.X;
          frmSpellPopUp.Top := PossiblePOS2.Y;
          exit;
     End;

     If ValidPosition(PossiblePOS3) Then Begin
          frmSpellPopUp.Left := PossiblePOS3.X;
          frmSpellPopUp.Top := PossiblePOS3.Y;
          exit;
     End;

     If ValidPosition(PossiblePOS4) Then Begin
          frmSpellPopUp.Left := PossiblePOS4.X;
          frmSpellPopUp.Top := PossiblePOS4.Y;
          exit;
     End;
End;


Procedure TfrmSpellPopUp.But_AddToDictClick(Sender: TObject);
Begin
     WordNotFound := Edit_NotFound.Text;
     WordSelected := '';
     SpellCustomDict.Add(WordNotFound);
     Self.Close;
     callback(PWideChar(WordNotFound), PWideChar(WordSelected), SA_Ignore);
End;

Procedure TfrmSpellPopUp.But_CancelClick(Sender: TObject);
Begin
     WordNotFound := '';
     WordSelected := '';
     Self.Close;
     callback(PWideChar(WordNotFound), PWideChar(WordSelected), SA_Cancel);
End;

Procedure TfrmSpellPopUp.But_ChangeAllClick(Sender: TObject);
Begin
     WordNotFound := Edit_NotFound.Text;
     WordSelected := Edit_ChangeTo.Text;
     SpellChangeDict.Add(utf8encode(WordNotFound), utf8encode(WordSelected));
     Self.Close;
     callback(PWideChar(WordNotFound), PWideChar(WordSelected), SA_ReplaceAll);
End;

Procedure TfrmSpellPopUp.But_ChangeClick(Sender: TObject);
Begin
     WordNotFound := Edit_NotFound.Text;
     WordSelected := Edit_ChangeTo.Text;
     Self.Close;
     callback(PWideChar(WordNotFound), PWideChar(WordSelected), SA_Default);
End;

Procedure TfrmSpellPopUp.But_IgnoreAllClick(Sender: TObject);
Begin
     WordNotFound := Edit_NotFound.Text;
     WordSelected := '';
     SpellIgnoreDict.Add(WordNotFound);
     Self.Close;
     callback(PWideChar(WordNotFound), PWideChar(WordSelected), SA_Ignore);
End;

Procedure TfrmSpellPopUp.But_IgnoreClick(Sender: TObject);
Begin
     WordNotFound := Edit_NotFound.Text;
     WordSelected := '';
     Self.Close;
     callback(PWideChar(WordNotFound), PWideChar(WordSelected), SA_Ignore);
End;

Procedure TfrmSpellPopUp.But_OptionsClick(Sender: TObject);
Begin
     frmSpellOptions := TfrmSpellOptions.Create(Nil);
     frmSpellOptions.ShowModal;

     If FullSuggestion = 'YES' Then
          CheckLessPreffered.Checked := True
     Else
          CheckLessPreffered.Checked := False;
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

Procedure TfrmSpellPopUp.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     Action := caFree;
     frmSpellPopUp := Nil;
End;

Procedure TfrmSpellPopUp.FormCreate(Sender: TObject);
Begin
     DetermineZWNJ_ZWJ := ZWJ;

     TOPMOST(self.Handle);
End;

Procedure TfrmSpellPopUp.FormShow(Sender: TObject);
Begin
     self.Caption := 'Avro Spell Checker';

     If FullSuggestion = 'YES' Then Begin
          CheckLessPreffered.Checked := True;
          ShowSuggestion(True);
     End
     Else Begin
          CheckLessPreffered.Checked := False;
          ShowSuggestion(False)
     End;

     List.ItemIndex := 0;
     List.SetFocus;
     ListClick(Nil);
End;

Procedure TfrmSpellPopUp.ListClick(Sender: TObject);
Begin
     If List.ItemIndex < 0 Then exit;

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

Procedure TfrmSpellPopUp.ShowSuggestion(FullResult: Boolean);

     Function Fix_ZWNJ_ZWJ(inp: WideString): WideString;
     Var
          retVal              : WideString;
     Begin
          retVal := WideReplaceStr(inp, b_R + ZWNJ + b_Hasanta + b_Z,
               b_r + DetermineZWNJ_ZWJ + b_Hasanta + b_Z);

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
                    {SimilarSort resets dupIgnore property, set that again}
                    TempList.Sorted := True;
                    TempList.Duplicates := dupIgnore;
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

Initialization
     frmSpellPopUp := Nil;
End.

