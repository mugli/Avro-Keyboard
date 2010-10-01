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

{$INCLUDE ../../ProjectDefines.inc}

Unit ufrmSpell;

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
     Menus,
     StdCtrls,
     TntStdCtrls,
     ComCtrls,
     TntComCtrls;

Type
     TfrmSpell = Class(TForm)
          MainMenu1: TMainMenu;
          File1: TMenuItem;
          Edit1: TMenuItem;
          Spellcheck1: TMenuItem;
          Close1: TMenuItem;
          SelectAll1: TMenuItem;
          N1: TMenuItem;
          Cut1: TMenuItem;
          Copy1: TMenuItem;
          Paste1: TMenuItem;
          N2: TMenuItem;
          Clearall1: TMenuItem;
          Startspellchek1: TMenuItem;
          N3: TMenuItem;
          Spellcheckoptions1: TMenuItem;
          MEMO: TTntMemo;
          Progress: TProgressBar;
          New1: TMenuItem;
          Open1: TMenuItem;
          Save1: TMenuItem;
          Saveas1: TMenuItem;
          N4: TMenuItem;
          OpenDialog: TOpenDialog;
          SaveDialog: TSaveDialog;
          Format1: TMenuItem;
          WordWrap1: TMenuItem;
          Font1: TMenuItem;
          FontDialog: TFontDialog;
          N5: TMenuItem;
          Procedure Startspellchek1Click(Sender: TObject);
          Procedure FormCreate(Sender: TObject);
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
          Procedure Close1Click(Sender: TObject);
          Procedure Clearall1Click(Sender: TObject);
          Procedure Cut1Click(Sender: TObject);
          Procedure Copy1Click(Sender: TObject);
          Procedure Paste1Click(Sender: TObject);
          Procedure SelectAll1Click(Sender: TObject);
          Procedure MEMOChange(Sender: TObject);
          Procedure New1Click(Sender: TObject);
          Procedure Save1Click(Sender: TObject);
          Procedure Open1Click(Sender: TObject);
          Procedure Saveas1Click(Sender: TObject);
          Procedure WordWrap1Click(Sender: TObject);
          Procedure Font1Click(Sender: TObject);
          Procedure Spellcheckoptions1Click(Sender: TObject);
          Procedure N5Click(Sender: TObject);
          Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
     Private
          { Private declarations }

          //File handling
          fFileName: String;
          MemoChanged: Boolean;
          BOM_Unicode, BOM_UnicodeBE, BOM_UTF8: Boolean;
          Procedure OpenFile(Const fFile: String);
          Procedure SaveFile(Const fFile: String; bBOM_Unicode, bBOM_UnicodeBE, bBOM_UTF8: Boolean);
          Procedure ShowOpenDialog;
          Procedure ShowSaveDialog;

     Public
          { Public declarations }
          CheckingSpell: Boolean;
          {Procedure ClipboardCopyPaste;}
         { Procedure ShowMe;}
     Protected
          Procedure CreateParams(Var Params: TCreateParams); Override;
     End;

Var
     frmSpell                 : TfrmSpell;

Implementation

{$R *.dfm}
Uses
     ufrmSpellPopUp,
     uCustomDictionary,
     uDBase,
     HashTable,
     KeyboardFunctions,
     VirtualKeyCode,
     strutils,
     uRegistrySettings,
     uWindowHandlers,
     ufrmSpellOptions,
     ufrmAbout;

Const
     Show_Window_in_Taskbar   = True;


     {===============================================================================}

Procedure TfrmSpell.Clearall1Click(Sender: TObject);
Begin
     memo.SelectAll;
     memo.SetFocus;
     SendKey_Basic(VK_Back);
End;

{===============================================================================}

(*
Procedure TfrmSpell.ClipboardCopyPaste;
//Var
 //    Mem                      : TMemoryStream;
  //   MyChanged                : Boolean;
Begin
     If CheckingSpell Then exit;

     //    Mem := TMemoryStream.Create;
     //    SaveClipboard(Mem);
     //    Sleep(25);
     //    Application.ProcessMessages;
    { Try
          clipboard.Open;
          clipboard.Clear;
          clipboard.Close;
          Sleep(100);
          Application.ProcessMessages;
 {    Except
          On e: exception Do Begin
               //Nothing
          End;
     End;}



//     SendInput_Down(VK_Control);
     SendInput_Down(C_KEY);
     SendInput_UP(C_KEY);
     //     SendInput_UP(VK_Control);
     Sleep(100);
     Application.ProcessMessages;


     //   MyChanged := MemoChanged;
     MemoChanged := False;
     Memo.PasteFromClipboard;


     //    LoadClipboard(Mem);
     //    FreeAndNil(Mem);

     ShowMe;

     If MemoChanged = False Then
          Paste1Click(Nil);


     //  MemoChanged := MyChanged;
End;
 *)

{===============================================================================}

Procedure TfrmSpell.Close1Click(Sender: TObject);
Begin
     Close;
End;

{===============================================================================}

Procedure TfrmSpell.Copy1Click(Sender: TObject);
Begin
     Memo.SetFocus;
     SendInput_Down(VK_Control);
     SendInput_Down(C_KEY);
     SendInput_UP(C_KEY);
     SendInput_UP(VK_Control);
End;

{===============================================================================}

Procedure TfrmSpell.CreateParams(Var Params: TCreateParams);
Begin
     Inherited CreateParams(Params);
     With Params Do Begin
          If Show_Window_in_Taskbar Then Begin
               ExStyle := ExStyle Or WS_EX_APPWINDOW And Not WS_EX_TOOLWINDOW;
               WndParent := GetDesktopwindow;
          End
          Else If Not Show_Window_in_Taskbar Then Begin
               ExStyle := ExStyle And Not WS_EX_APPWINDOW;
          End;
     End;
End;

{===============================================================================}

Procedure TfrmSpell.Cut1Click(Sender: TObject);
Begin
     Memo.SetFocus;
     SendInput_Down(VK_Control);
     SendInput_Down(X_KEY);
     SendInput_UP(X_KEY);
     SendInput_UP(VK_Control);
End;

{===============================================================================}

Procedure TfrmSpell.Font1Click(Sender: TObject);
Begin
     FontDialog.Font.Name := AvroPadFontName;
     FontDialog.Font.Size := StrToInt(AvroPadFontSize);

     If FontDialog.Execute Then Begin
          Memo.Font := FontDialog.Font;
          AvroPadFontName := FontDialog.Font.Name;
          AvroPadFontSize := IntToStr(FontDialog.Font.Size);
     End;
End;

{===============================================================================}

Procedure TfrmSpell.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     AvroPadHeight := IntToStr(Self.Height);
     AvroPadWidth := IntToStr(Self.Width);
     AvroPadTop := IntToStr(Self.Top);
     AvroPadLeft := IntToStr(Self.Left);
     If self.WindowState = wsMaximized Then
          AvroPadState := 'MAXIMIZED'
     Else
          AvroPadState := 'NORMAL';

     SaveSettings;


     SaveSpellCustomDict;
     UnloadWordDatabase;
     Action := caFree;
     frmSpell := Nil;
End;

Procedure TfrmSpell.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
     MSG                      : Integer;
Begin
     If Not ((Length(Memo.Text) <= 0) And (fFileName = '')) Then Begin
          If (MemoChanged = True) Then Begin
               MSG := Application.MessageBox('The text in the current file has changed.' + #10 + '' + #10 + 'Do you want to save the changes first?', 'Avro Pad', MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
               If MSG = ID_YES Then Begin
                    Save1Click(Nil);
                    If MemoChanged = False Then
                         CanClose := True
                    Else
                         CanClose := False;
               End
               Else If MSG = ID_NO Then Begin
                    CanClose := True;
               End
               Else
                    CanClose := False;
          End
          Else Begin
               CanClose := True;
          End;
     End
     Else
          CanClose := True;
End;

{===============================================================================}

Procedure TfrmSpell.FormCreate(Sender: TObject);
Begin
     InitSpellCustomDict;
     CheckingSpell := False;
     New1Click(Nil);

     LoadSettings;

     Self.Height := StrToInt(AvroPadHeight);
     Self.Width := StrToInt(AvroPadWidth);
     Self.Top := StrToInt(AvroPadTop);
     Self.Left := StrToInt(AvroPadLeft);

     If AvroPadState = 'MAXIMIZED' Then
          self.WindowState := wsMaximized
     Else
          Self.WindowState := wsNormal;

     Memo.Font.Name := AvroPadFontName;
     Memo.Font.Size := StrToInt(AvroPadFontSize);

     If AvroPadWrap = 'YES' Then Begin
          Memo.WordWrap := True;
          Memo.ScrollBars := ssVertical;
     End
     Else Begin
          Memo.WordWrap := False;
          Memo.ScrollBars := ssBoth;
     End;

     Self.Show;
     ForceForegroundWindow(handle);


End;

{===============================================================================}

Procedure TfrmSpell.MEMOChange(Sender: TObject);
Begin
     MemoChanged := True;
End;

{===============================================================================}

Procedure TfrmSpell.N5Click(Sender: TObject);
Begin
     Application.CreateForm(TfrmAbout, frmAbout);
     frmAbout.ShowModal;
End;

{===============================================================================}

Procedure TfrmSpell.New1Click(Sender: TObject);
Var
     MSG                      : Integer;
Begin
     //ShowMe;

     If ((Length(Memo.Text) <= 0) And (fFileName = '')) Then Begin
          fFileName := '';
          MemoChanged := False;
          BOM_Unicode := False;
          BOM_UnicodeBE := False;
          BOM_UTF8 := False;
          Memo.Clear;
          Self.Caption := 'Untitled - Avro Pad';
     End
     Else Begin
          If (MemoChanged = True) Then Begin
               MSG := Application.MessageBox('The text in the current file has changed.' + #10 + '' + #10 + 'Do you want to save the changes first?', 'Avro Pad', MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
               If MSG = ID_YES Then Begin
                    Save1Click(Nil);
               End
               Else If MSG = ID_NO Then Begin
                    fFileName := '';
                    MemoChanged := False;
                    BOM_Unicode := False;
                    BOM_UnicodeBE := False;
                    BOM_UTF8 := False;
                    Memo.Clear;
                    Self.Caption := 'Untitled - Avro Pad';
               End
               Else
                    Exit;
          End
          Else Begin
               fFileName := '';
               MemoChanged := False;
               BOM_Unicode := False;
               BOM_UnicodeBE := False;
               BOM_UTF8 := False;
               Memo.Clear;
               Self.Caption := 'Untitled - Avro Pad';
          End;
     End;
End;

{===============================================================================}

Procedure TfrmSpell.Open1Click(Sender: TObject);
Var
     MSG                      : Integer;
Begin
     If ((Length(Memo.Text) <= 0) And (fFileName = '')) Then Begin
          ShowOpenDialog;
     End
     Else Begin
          If (MemoChanged = True) Then Begin
               MSG := Application.MessageBox('The text in the current file has changed.' + #10 + '' + #10 + 'Do you want to save the changes first?', 'Avro Pad', MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
               If MSG = ID_YES Then Begin
                    Save1Click(Nil);
                    If MemoChanged = False Then ShowOpenDialog;
               End
               Else If MSG = ID_NO Then Begin
                    ShowOpenDialog;
               End
               Else
                    Exit;
          End
          Else Begin
               ShowOpenDialog;
          End;
     End;
End;

{===============================================================================}

Procedure TfrmSpell.OpenFile(Const fFile: String);
Var
     fs                       : TFileStream;
Begin
     Try
          BOM_Unicode := False;
          BOM_UnicodeBE := False;
          BOM_UTF8 := False;
          fs := TFileStream.Create(fFile, fmOpenRead);
          Memo.Lines.LoadFromStream_BOM_Return(fs, True, BOM_Unicode, BOM_UnicodeBE, BOM_UTF8);
          FreeAndNil(fs);
          MemoChanged := False;
          fFileName := fFile;
          Self.Caption := ExtractFileName(fFile) + ' - Avro Pad';
     Except
          On e: exception Do Begin
               Application.MessageBox(PChar('Error opening specified file:' + #10 + fFile), 'Avro Pad', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          End;
     End;
End;

{===============================================================================}

Procedure TfrmSpell.Paste1Click(Sender: TObject);
Begin
     Memo.SetFocus;
     SendInput_Down(VK_Control);
     SendInput_Down(V_KEY);
     SendInput_UP(V_KEY);
     SendInput_UP(VK_Control);
End;

{===============================================================================}

Procedure TfrmSpell.Save1Click(Sender: TObject);
Begin
     If fFileName = '' Then
          ShowSaveDialog
     Else
          SaveFile(fFileName, BOM_Unicode, BOM_UnicodeBE, BOM_UTF8);

End;

{===============================================================================}

Procedure TfrmSpell.Saveas1Click(Sender: TObject);
Begin
     ShowSaveDialog;
End;

{===============================================================================}

Procedure TfrmSpell.SaveFile(Const fFile: String; bBOM_Unicode, bBOM_UnicodeBE,
     bBOM_UTF8: Boolean);
Var
     fs                       : TFileStream;
Begin
     Try
          fs := TFileStream.Create(fFile, fmCreate);
          If bBOM_Unicode Or bBOM_UnicodeBE Or bBOM_UTF8 Then
               Memo.Lines.SaveToStream_BOM_Specify(fs, True, bBOM_Unicode, bBOM_UnicodeBE, bBOM_UTF8)
          Else
               Memo.Lines.SaveToStream_BOM_Specify(fs, True, True, False, False);
          FreeAndNil(fs);
          fFileName := fFile;
          MemoChanged := False;
          Self.Caption := ExtractFileName(fFile) + ' - Avro Pad';
     Except
          On e: exception Do Begin
               Application.MessageBox('Error occured while saving file!', 'Avro Pad', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          End;
     End;
End;

{===============================================================================}

Procedure TfrmSpell.SelectAll1Click(Sender: TObject);
Begin
     Memo.SelectAll;
End;

{===============================================================================}

{
Procedure TfrmSpell.ShowMe;
Begin
     Self.Show;
     Self.Update;
     Application.ProcessMessages;
     SetForegroundWindow(self.Handle);
     //
     // Restore and repaint
     //

     If IsIconic(self.Handle) Then
          ShowWindow(self.Handle, SW_RESTORE)
     Else
          ShowWindow(self.Handle, SW_SHOW);
     Self.Activate;
     Application.ProcessMessages;
End;
 }

 {===============================================================================}

Procedure TfrmSpell.ShowOpenDialog;
Begin

     OpenDialog.InitialDir := LastDirectory;
     Opendialog.Files.Clear;
     Opendialog.FileName := '';
     If OpenDialog.Execute() Then Begin
          OpenFile(OpenDialog.FileName);
          LastDirectory := ExtractFilepATH(OpenDialog.FileName);
     End;
End;

{===============================================================================}

Procedure TfrmSpell.ShowSaveDialog;
Begin
     SaveDialog.InitialDir := LastDirectory;
     SaveDialog.Files.Clear;
     SaveDialog.FileName := '';

     If BOM_Unicode Then
          SaveDialog.FilterIndex := 1
     Else If BOM_UnicodeBE Then
          SaveDialog.FilterIndex := 2
     Else If BOM_UTF8 Then
          SaveDialog.FilterIndex := 3
     Else
          SaveDialog.FilterIndex := 1;

     BOM_Unicode := False;
     BOM_UnicodeBE := False;
     BOM_UTF8 := False;


     If SaveDialog.Execute() Then Begin
          If SaveDialog.FilterIndex = 1 Then
               BOM_Unicode := True
          Else If SaveDialog.FilterIndex = 2 Then
               BOM_UnicodeBE := True
          Else If SaveDialog.FilterIndex = 3 Then
               BOM_UTF8 := True
          Else
               BOM_Unicode := True;

          LastDirectory := ExtractFilepATH(SaveDialog.FileName);

          SaveFile(SaveDialog.FileName, BOM_Unicode, BOM_UnicodeBE, BOM_UTF8);
     End;
End;

{===============================================================================}

Procedure TfrmSpell.Spellcheckoptions1Click(Sender: TObject);
Begin
     CheckCreateForm(TfrmSpellOptions, frmSpellOptions, 'frmSpellOptions');
     frmSpellOptions.ShowModal;
End;

{===============================================================================}

Procedure TfrmSpell.Startspellchek1Click(Sender: TObject);
Begin
     CheckingSpell := True;

     Progress.Visible := True;
     Memo.ReadOnly := True;
     Application.CreateForm(TfrmSpellPopUp, frmSpellPopUp);
     Try
          frmSpellPopUp.ShowModal;
     Except
          On E: Exception Do Begin
               //Nothing
          End;
     End;
     Progress.Position := 0;
     Progress.Visible := False;
     Memo.ReadOnly := False;

     CheckingSpell := False;
End;

{===============================================================================}

Procedure TfrmSpell.WordWrap1Click(Sender: TObject);
Begin
     WordWrap1.Checked := Not WordWrap1.Checked;

     If WordWrap1.Checked Then Begin
          Memo.WordWrap := True;
          Memo.ScrollBars := ssVertical;
          AvroPadWrap := 'YES';
     End
     Else Begin
          Memo.WordWrap := False;
          Memo.ScrollBars := ssBoth;
          AvroPadWrap := 'NO';
     End;
End;

{===============================================================================}

End.

