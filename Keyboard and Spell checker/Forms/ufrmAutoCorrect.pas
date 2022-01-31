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

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

Unit ufrmAutoCorrect;

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
  uAutoCorrect,
  StdCtrls,
  ComCtrls,
  clsEnglishToBangla,
  uWindowHandlers,
  uFileFolderHandling,
  StrUtils,
  Generics.Collections;

Type
  TfrmAutoCorrect = Class(TForm)
    List: TListView;
    cmdSave: TButton;
    cmdCancel: TButton;
    CheckOnTop: TCheckBox;
    lblTotalEntries: TLabel;
    GroupBox1: TGroupBox;
    ReplaceT: TEdit;
    WithT: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    R1: TEdit;
    R2: TEdit;
    cmdClear: TButton;
    cmdDel: TButton;
    cmdAdd: TButton;
    cmdImport: TButton;
    OpenDialog1: TOpenDialog;
    Procedure FormCreate(Sender: TObject);
    Procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    Procedure ReplaceTChange(Sender: TObject);
    Procedure WithTChange(Sender: TObject);
    Procedure WithTKeyPress(Sender: TObject; Var Key: Char);
    Procedure ReplaceTKeyPress(Sender: TObject; Var Key: Char);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure cmdCancelClick(Sender: TObject);
    Procedure cmdClearClick(Sender: TObject);
    Procedure cmdDelClick(Sender: TObject);
    Procedure cmdAddClick(Sender: TObject);
    Procedure cmdSaveClick(Sender: TObject);
    Procedure CheckOnTopClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
    Procedure cmdImportClick(Sender: TObject);
  Private
    { Private declarations }
    Phonetic: TEnglishToBangla;
    Function FindListItem(Const SearchStr: String): TListItem;
    Procedure ButtonState;
    Function Save: Boolean;

  Public
    { Public declarations }
  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  End;

Var
  frmAutoCorrect: TfrmAutoCorrect;

Implementation

Uses
  ufrmConflict;

{$R *.dfm}

Const
  Show_Window_in_Taskbar = True;

  { =============================================================================== }

Procedure TfrmAutoCorrect.ButtonState;
Begin
  If (Trim(ReplaceT.text) <> '') And (Trim(WithT.text) <> '') Then
    cmdAdd.Enabled := True
  Else
    cmdAdd.Enabled := False;

  If (Trim(ReplaceT.text) <> '') Or (Trim(WithT.text) <> '') Then
    cmdClear.Enabled := True
  Else
    cmdClear.Enabled := False;

End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.CheckOnTopClick(Sender: TObject);
Begin
  If CheckOnTop.Checked Then
    TOPMOST(Self.Handle)
  Else
    NoTOPMOST(Self.Handle);
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.cmdAddClick(Sender: TObject);
Var
  thisItem: TListItem;
Begin
  ReplaceT.text := Trim(ReplaceT.text);
  WithT.text := Trim(WithT.text);

  If ReplaceT.text <> WithT.text Then
  Begin
    ReplaceT.text := Trim(Phonetic.CorrectCase(ReplaceT.text));
    WithT.text := Trim(Phonetic.CorrectCase(WithT.text));
  End;

  thisItem := Nil;
  thisItem := FindListItem(ReplaceT.text);

  If (thisItem = Nil) Then
  Begin
    thisItem := List.Items.Add;
    thisItem.Caption := ReplaceT.text;
    thisItem.SubItems.Add(WithT.text);
    List.Selected := Nil;
    List.Selected := thisItem;
    thisItem.MakeVisible(False);
  End
  Else
  Begin
    thisItem.Caption := ReplaceT.text;
    thisItem.SubItems[0] := WithT.text;
    List.Selected := Nil;
    List.Selected := thisItem;
    thisItem.MakeVisible(False);
  End;

  WithT.text := '';
  ReplaceT.text := '';
  cmdSave.Enabled := True;

  ReplaceT.SetFocus;

  lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);

End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.cmdCancelClick(Sender: TObject);
Var
  Msg: Integer;
Begin
  If cmdSave.Enabled = True Then
  Begin
    Msg := Application.MessageBox
      ('Save changes in the auto-correct dictionary?', 'Confirmation',
      MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
    If Msg = ID_YES Then
      Save();
    If Msg = ID_CANCEL Then
      Exit;
  End;

  Self.Close;

End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.cmdClearClick(Sender: TObject);
Begin
  ReplaceT.text := '';
  WithT.text := '';

  ReplaceT.SetFocus;
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.cmdDelClick(Sender: TObject);
Var
  Msg: Integer;
Begin
  If Not(List.Selected = Nil) Then
  Begin
    Msg := Application.MessageBox(PChar('Delete ' + List.Selected.Caption +
      ' = ' + List.Selected.SubItems[0] + '?'), 'Auto correct',
      MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_APPLMODAL);
    If Msg = ID_NO Then
      Exit;

    List.Items.Delete(List.Selected.Index);
    ReplaceT.text := '';
    WithT.text := '';
    cmdSave.Enabled := True;
  End
  Else
  Begin
    Application.MessageBox('No item is selected in the list!', 'Auto correct',
      MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
  End;
  lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.cmdImportClick(Sender: TObject);

{$HINTS Off}
  Function LoadIDict(Path: String;
    Var idict: TDictionary<String, String>): Boolean;
  Var
    List: TStringList;
    I, P: Integer;
    FirstPart, SecondPart: String;
  Begin
    result := False;
    Try
      Try
        List := TStringList.Create;
        List.LoadFromFile(Path);

        For I := 0 To List.Count - 1 Do
        Begin
          If (LeftStr(Trim(List[I]), 1) <> '/') And (Trim(List[I]) <> '') Then
          Begin
            P := Pos(' ', Trim(List[I]));
            FirstPart := LeftStr(Trim(List[I]), P - 1);
            SecondPart := MidStr(Trim(List[I]), P + 1, Length(Trim(List[I])));
            idict.AddOrSetValue(FirstPart, SecondPart);
          End;
        End;
        result := True;
      Except
        On E: Exception Do
        Begin
          Application.MessageBox
            (PChar('Cannot import auto-correct dictionary!'), 'Avro Keyboard',
            MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          result := False;
        End;
      End;
    Finally
      FreeAndNil(List);
    End;

  End;

{$HINTS On}

{ =============================================================================== }
Var
  idict: TDictionary<String, String>;
  S: String;
  Rs, Ws: String;
  thisItem: TListItem;
  ResultModal: Integer;
  DictItem: String;
Begin
  If OpenDialog1.Execute(Self.Handle) Then
  Begin
    idict := TDictionary<String, String>.Create;

    If LoadIDict(OpenDialog1.FileName, idict) = False Then
      Exit;

    For S in idict.Keys Do
    Begin

      Rs := S;
      Ws := idict.Items[S];

      If dict.TryGetValue(Rs, DictItem) Then
      Begin
        // There may be a conflict
        If DictItem <> Ws Then
        Begin
          // Conflict!! items are not same
          // CheckCreateForm(TfrmConflict, frmConflict, 'frmConflict');
          Application.CreateForm(TfrmConflict, frmConflict);
          frmConflict.EditR.text := Rs;
          frmConflict.EditR_P.text := Phonetic.Convert(Rs);
          frmConflict.EditWC.text := DictItem;
          frmConflict.EditWC_P.text := Phonetic.Convert(DictItem);
          frmConflict.EditWI.text := Ws;
          If Rs <> Ws Then
            frmConflict.EditWI_P.text := Phonetic.Convert(Ws)
          Else
            frmConflict.EditWI_P.text := Ws;

          ResultModal := frmConflict.ShowModal;

          If ResultModal = mrCancel Then
          Begin
            // Keep current, do nothing
          End
          Else If ResultModal = mrOk Then
          Begin
            // Update current with imported
            thisItem := Nil;
            thisItem := FindListItem(Rs);

            thisItem.Caption := Rs;
            thisItem.SubItems[0] := Ws;
          End;
        End;
      End
      Else
      Begin
        // No conflict, new item->import this
        thisItem := List.Items.Add;
        thisItem.Caption := Rs;
        thisItem.SubItems.Add(Ws);
      End;
    End;
    WithT.text := '';
    ReplaceT.text := '';
    cmdSave.Enabled := True;

    ReplaceT.SetFocus;

    lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);
  End;
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.cmdSaveClick(Sender: TObject);
Begin
  If Save = True Then
  Begin
    cmdSave.Enabled := False;
    ReplaceT.SetFocus;
  End;
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  With Params Do
  Begin
    If Show_Window_in_Taskbar Then
    Begin
      ExStyle := ExStyle Or WS_EX_APPWINDOW And Not WS_EX_TOOLWINDOW;
      WndParent := GetDesktopwindow;
    End
    Else If Not Show_Window_in_Taskbar Then
    Begin
      ExStyle := ExStyle And Not WS_EX_APPWINDOW;
    End;
  End;
End;

{ =============================================================================== }

Function TfrmAutoCorrect.FindListItem(Const SearchStr: String): TListItem;
Var
  thisItem: TListItem;
  Found: Boolean;
  InIndex: Integer;
Begin
  InIndex := 0;

  thisItem := Nil;
  Found := False;

  Repeat
    thisItem := List.FindCaption(InIndex, SearchStr, False, True, False);

    If Not(thisItem = Nil) Then
    Begin
      // Make it case sensitive
      If thisItem.Caption <> SearchStr Then
        // Find again
        InIndex := thisItem.Index + 1
      Else
        Found := True;
    End;
  Until ((Found = True) Or (thisItem = Nil));

  result := thisItem;

End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  FreeAndNil(Phonetic);

  Action := caFree;

  frmAutoCorrect := Nil;
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.FormCreate(Sender: TObject);
Var
  S: String;
  thisItem: TListItem;
Begin
  Phonetic := TEnglishToBangla.Create;
  Phonetic.AutoCorrectEnabled := False;

  List.Items.BeginUpdate;
  For S in dict.Keys Do
  Begin
    thisItem := List.Items.Add;
    thisItem.Caption := S;
    thisItem.SubItems.Add(dict.Items[S]);
  End;
  List.SortType := stText;
  List.Items.EndUpdate;

  lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);

  DisableCloseButton(Self.Handle);
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If (Key = VK_F4) And (ssAlt In Shift) Then
    Key := 0;
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.ListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
Begin
  ReplaceT.text := Item.Caption;
  ReplaceT.SelStart := Length(ReplaceT.text);
  WithT.text := Item.SubItems[0];
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.ReplaceTChange(Sender: TObject);
Var
  thisItem: TListItem;
Begin
  thisItem := Nil;
  thisItem := FindListItem(ReplaceT.text);

  If (thisItem = Nil) Then
  Begin
    WithT.text := '';
  End
  Else
  Begin
    List.Selected := Nil;
    List.Selected := thisItem;
    thisItem.MakeVisible(False);
    WithT.text := thisItem.SubItems[0];
  End;

  ReplaceT.text := StringReplace(ReplaceT.text, ' ', '',
    [rfReplaceAll, rfIgnoreCase]);
  ButtonState();
  R1.text := Phonetic.Convert(ReplaceT.text);

  If ReplaceT.text = '' Then
    R1.text := '';

End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.ReplaceTKeyPress(Sender: TObject; Var Key: Char);
Begin
  If Key = #32 Then
    Key := #0;
  If Key = #13 Then
    Key := #0;
End;

{$HINTS Off}
{ =============================================================================== }

Function TfrmAutoCorrect.Save: Boolean;
Var
  T: TStringList;
  I: Integer;
  Path: String;
Begin
  result := False;
  T := TStringList.Create;

  T.BeginUpdate;
  With T Do
  Begin
    Add('/ **************************************');
    Add('/ Avro Phonetic Autocorrect dictionary');
    Add('/ Copyright (c) OmicronLab. All rights reserved.');
    Add('/ Web: http://www.omicronlab.com/');
    Add('/');
    Add('/ Warning: DO NOT EDIT THIS FILE MANUALLY');
    Add('/ **************************************');

    For I := 0 To List.Items.Count - 1 Do
    Begin
      Add(List.Items.Item[I].Caption + ' ' + List.Items.Item[I].SubItems[0]);
    End;
  End;
  T.EndUpdate;

  Try
    Path := GetAvroDataDir + 'autodict.dct';
    T.SaveToFile(Path);
    DestroyDict;
    InitDict;
    LoadDict;
    result := True;
  Except
    On E: Exception Do
    Begin
      Application.MessageBox(PChar('Cannot save to dictionary!' + #10 + '' + #10
        + '-> Make sure the disk is not write protected, or' + #10 + '-> ' +
        Path + ' file is not ''Read Only'', or' + #10 +
        '-> You have necessary account privilege to modify content.' + #10 + ''
        + #10 + 'Please ask your System Administrator or contact' + #10 +
        'OmicronLab (http://www.omicronlab.com/forum/) to solve of this problem.'),
        'Auto correct', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      result := False;
    End;
  End;

  T.Free;

End;

{$HINTS On}
{ =============================================================================== }

Procedure TfrmAutoCorrect.WithTChange(Sender: TObject);
Begin
  ButtonState;
  If WithT.text = ReplaceT.text Then
    R2.text := WithT.text
  Else
    R2.text := Phonetic.Convert(WithT.text);

  If WithT.text = '' Then
    R2.text := '';
End;

{ =============================================================================== }

Procedure TfrmAutoCorrect.WithTKeyPress(Sender: TObject; Var Key: Char);
Begin
  If Key = #13 Then
    Key := #0;
End;

{ =============================================================================== }

End.
