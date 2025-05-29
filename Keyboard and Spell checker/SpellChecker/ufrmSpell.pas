{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../../ProjectDefines.inc}
unit ufrmSpell;

interface

uses
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
  ComCtrls,
  clsMemoParser,
  Vcl.AppEvnts;

const
  UNICODE_BOM         = Char($FEFF);
  UNICODE_BOM_SWAPPED = Char($FFFE);
  UTF8_BOM            = AnsiString(#$EF#$BB#$BF);

type
  TUnicodeStreamCharSet = (csAnsi, csUnicode, csUnicodeSwapped, csUtf8);

  TfrmSpell = class(TForm)
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
    MEMO: TMemo;
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
    AppEvents: TApplicationEvents;
    procedure Startspellchek1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Close1Click(Sender: TObject);
    procedure Clearall1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure MEMOChange(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure WordWrap1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Spellcheckoptions1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);
    private
      { Private declarations }

      // File handling
      fFileName:                            string;
      MemoChanged:                          Boolean;
      BOM_Unicode, BOM_UnicodeBE, BOM_UTF8: Boolean;
      procedure OpenFile(const fFile: string);
      procedure SaveFile(const fFile: string; bBOM_Unicode, bBOM_UnicodeBE, bBOM_UTF8: Boolean);
      procedure ShowOpenDialog;
      procedure ShowSaveDialog;

      function AutoDetectCharacterSet(Stream: TStream): TUnicodeStreamCharSet;
      procedure StrSwapByteOrder(Str: PChar);
      procedure LoadFromStream_BOM_Return(Stream: TStream; WithBOM: Boolean; var BOM_Unicode, BOM_UnicodeBE, BOM_UTF8: Boolean);
      procedure SaveToStream_BOM_Specify(Stream: TStream; WithBOM: Boolean; BOM_Unicode, BOM_UnicodeBE, BOM_UTF8: Boolean);

      procedure HandleThemes;

      { MemoParser events }
      procedure MP_WordFound(CurrentWord: string);
      procedure MP_CompleteParsing;
      procedure MP_PositionConflict;
      procedure MP_TotalProgress(CurrentProgress: Integer);
    public
      { Public declarations }
      MP:            TMemoParser;
      CheckingSpell: Boolean;
      { Procedure ClipboardCopyPaste; }
      { Procedure ShowMe; }
    protected
      procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmSpell: TfrmSpell;

  /// ////////////////////////////////////////////////////////////////////////////////
  // AvroSpell.dll functions
  /// ////////////////////////////////////////////////////////////////////////////////

procedure Avro_InitSpell; stdcall; external 'AvroSpell.dll' name 'Avro_InitSpell';

procedure Avro_RegisterCallback(mCallback: Pointer); stdcall; external 'AvroSpell.dll' name 'Avro_RegisterCallback';

function Avro_IsWordPresent(Wrd: PChar; var SAction: Integer): LongBool; stdcall; external 'AvroSpell.dll' name 'Avro_IsWordPresent';

function Avro_WordPresentInChangeAll(Wrd: PChar): LongBool; stdcall; external 'AvroSpell.dll' name 'Avro_WordPresentInChangeAll';

procedure Avro_GetCorrection(Wrd: PChar); stdcall; external 'AvroSpell.dll' name 'Avro_GetCorrection';

procedure Avro_SetWordPosInScreen(xPoint, yPoint: Integer); stdcall; external 'AvroSpell.dll' name 'Avro_SetWordPosInScreen';

procedure Avro_HideSpeller; stdcall; external 'AvroSpell.dll' name 'Avro_HideSpeller';

procedure Avro_ShowOptions; stdcall; external 'AvroSpell.dll' name 'Avro_ShowOptions';

procedure Avro_ShowAbout; stdcall; external 'AvroSpell.dll' name 'Avro_ShowAbout';

procedure Avro_ForgetChangeIgnore; stdcall; external 'AvroSpell.dll' name 'Avro_ForgetChangeIgnore';

procedure Avro_UnloadAll; stdcall; external 'AvroSpell.dll' name 'Avro_UnloadAll';
/// ////////////////////////////////////////////////////////////////////////////////

procedure Callback(Wrd: PChar; CWrd: PChar; SAction: Integer); stdcall;

implementation

{$R *.dfm}

uses
  KeyboardFunctions,
  VirtualKeyCode,
  strutils,
  uRegistrySettings,
  uWindowHandlers,
  WindowsDarkMode;

const
  Show_Window_in_Taskbar = True;

const
  SA_Default: Integer         = 0;
  SA_Ignore: Integer          = 1;
  SA_Cancel: Integer          = -1;
  SA_IgnoredByOption: Integer = 2;
  SA_ReplaceAll: Integer      = 3;

procedure Callback(Wrd: PChar; CWrd: PChar; SAction: Integer); stdcall;
begin
  if SAction = SA_Cancel then
  begin { User clicked cancel }
    Avro_ForgetChangeIgnore;
    frmSpell.Progress.Visible := False;
    frmSpell.CheckingSpell := False;
    Exit;
  end
  else if (SAction = SA_Default) or (SAction = SA_ReplaceAll) then
  begin
    frmSpell.MP.ReplaceCurrentWord(CWrd, Wrd);
  end;
  frmSpell.MP.BeginPursing;
end;

{ =============================================================================== }

procedure TfrmSpell.MP_WordFound(CurrentWord: string);
var
  DummySAction: Integer;
  PT:           TPoint;
begin
  if not Avro_IsWordPresent(PChar(CurrentWord), DummySAction) then
  begin

    if Avro_WordPresentInChangeAll(PChar(CurrentWord)) then
      Avro_GetCorrection(PChar(CurrentWord))
    else
    begin
      Avro_GetCorrection(PChar(CurrentWord));
      MP.SelectWord;
      MEMO.SetFocus;
      GetCaretPos(PT);
      PT := MEMO.ClientToScreen(PT);
      Avro_SetWordPosInScreen(PT.X, PT.Y);
    end;
  end
  else
    MP.BeginPursing;
end;

{ =============================================================================== }

procedure TfrmSpell.Clearall1Click(Sender: TObject);
begin
  MEMO.SelectAll;
  MEMO.SetFocus;
  SendKey_Basic(VK_Back);
end;

{ =============================================================================== }

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

{ =============================================================================== }

procedure TfrmSpell.Close1Click(Sender: TObject);
begin
  Close;
end;

{ =============================================================================== }

procedure TfrmSpell.Copy1Click(Sender: TObject);
begin
  MEMO.SetFocus;
  SendInput_Down(VK_Control);
  SendInput_Down(C_KEY);
  SendInput_UP(C_KEY);
  SendInput_UP(VK_Control);
end;

{ =============================================================================== }

procedure TfrmSpell.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle or WS_EX_APPWINDOW and not WS_EX_TOOLWINDOW;
      WndParent := GetDesktopwindow;
    end
    else if not Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle and not WS_EX_APPWINDOW;
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.Cut1Click(Sender: TObject);
begin
  MEMO.SetFocus;
  SendInput_Down(VK_Control);
  SendInput_Down(X_KEY);
  SendInput_UP(X_KEY);
  SendInput_UP(VK_Control);
end;

{ =============================================================================== }

procedure TfrmSpell.Font1Click(Sender: TObject);
begin
  FontDialog.Font.Name := AvroPadFontName;
  FontDialog.Font.Size := StrToInt(AvroPadFontSize);

  if FontDialog.Execute then
  begin
    MEMO.Font := FontDialog.Font;
    AvroPadFontName := FontDialog.Font.Name;
    AvroPadFontSize := IntToStr(FontDialog.Font.Size);
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AvroPadHeight := IntToStr(Self.Height);
  AvroPadWidth := IntToStr(Self.Width);
  AvroPadTop := IntToStr(Self.Top);
  AvroPadLeft := IntToStr(Self.Left);
  if Self.WindowState = wsMaximized then
    AvroPadState := 'MAXIMIZED'
  else
    AvroPadState := 'NORMAL';

  SaveSettings;
  FreeAndNil(MP);

  Avro_UnloadAll;

  Action := caFree;
  frmSpell := nil;
end;

procedure TfrmSpell.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  MSG: Integer;
begin
  if not((Length(MEMO.Text) <= 0) and (fFileName = '')) then
  begin
    if (MemoChanged = True) then
    begin
      MSG := Application.MessageBox('The text in the current file has changed.' + #10 + '' + #10 + 'Do you want to save the changes first?', 'Avro Pad',
        MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
      if MSG = ID_YES then
      begin
        Save1Click(nil);
        if MemoChanged = False then
          CanClose := True
        else
          CanClose := False;
      end
      else if MSG = ID_NO then
      begin
        CanClose := True;
      end
      else
        CanClose := False;
    end
    else
    begin
      CanClose := True;
    end;
  end
  else
    CanClose := True;
end;

{ =============================================================================== }

procedure TfrmSpell.FormCreate(Sender: TObject);
begin
  HandleThemes;

  CheckingSpell := False;
  New1Click(nil);
  Avro_InitSpell;
  Avro_RegisterCallback(@Callback);
  LoadSettings;

  Self.Height := StrToInt(AvroPadHeight);
  Self.Width := StrToInt(AvroPadWidth);
  Self.Top := StrToInt(AvroPadTop);
  Self.Left := StrToInt(AvroPadLeft);

  if AvroPadState = 'MAXIMIZED' then
    Self.WindowState := wsMaximized
  else
    Self.WindowState := wsNormal;

  MEMO.Font.Name := AvroPadFontName;
  MEMO.Font.Size := StrToInt(AvroPadFontSize);

  if AvroPadWrap = 'YES' then
  begin
    MEMO.WordWrap := True;
    MEMO.ScrollBars := ssVertical;
  end
  else
  begin
    MEMO.WordWrap := False;
    MEMO.ScrollBars := ssBoth;
  end;

  Self.Show;
  ForceForegroundWindow(handle);

  MP := TMemoParser.Create;
  MP.OnTotalProgress := MP_TotalProgress;
  MP.OnWordFound := MP_WordFound;
  MP.OnCompleteParsing := MP_CompleteParsing;
  MP.OnPositionConflict := MP_PositionConflict;
end;

{ =============================================================================== }

procedure TfrmSpell.MEMOChange(Sender: TObject);
begin
  MemoChanged := True;
end;

{ =============================================================================== }

procedure TfrmSpell.MP_CompleteParsing;
begin
  Application.MessageBox('Spelling check is complete.', 'Avro Bangla Spell Checker', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
  Avro_ForgetChangeIgnore;
  Progress.Visible := False;
  CheckingSpell := False;
end;

{ =============================================================================== }

procedure TfrmSpell.MP_PositionConflict;
begin
  Avro_HideSpeller;

  Application.MessageBox('Document has been modified above the current spell checking position.' + #10 + '' + #10 + '' + #10 +
      'Avro Pad will resume spell checking from the beginning.', 'Avro Pad', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);

  MP.ResetAll;
  CheckingSpell := False;
  Startspellchek1Click(nil);
end;

{ =============================================================================== }

procedure TfrmSpell.MP_TotalProgress(CurrentProgress: Integer);
begin
  Progress.Position := CurrentProgress;
  Application.ProcessMessages;
end;

{ =============================================================================== }

procedure TfrmSpell.N5Click(Sender: TObject);
begin
  Avro_ShowAbout;
end;

{ =============================================================================== }

procedure TfrmSpell.New1Click(Sender: TObject);
var
  MSG: Integer;
begin
  // ShowMe;

  if ((Length(MEMO.Text) <= 0) and (fFileName = '')) then
  begin
    fFileName := '';
    MemoChanged := False;
    BOM_Unicode := False;
    BOM_UnicodeBE := False;
    BOM_UTF8 := False;
    MEMO.Clear;
    Self.Caption := 'Untitled - Avro Pad';
  end
  else
  begin
    if (MemoChanged = True) then
    begin
      MSG := Application.MessageBox('The text in the current file has changed.' + #10 + '' + #10 + 'Do you want to save the changes first?', 'Avro Pad',
        MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
      if MSG = ID_YES then
      begin
        Save1Click(nil);
      end
      else if MSG = ID_NO then
      begin
        fFileName := '';
        MemoChanged := False;
        BOM_Unicode := False;
        BOM_UnicodeBE := False;
        BOM_UTF8 := False;
        MEMO.Clear;
        Self.Caption := 'Untitled - Avro Pad';
      end
      else
        Exit;
    end
    else
    begin
      fFileName := '';
      MemoChanged := False;
      BOM_Unicode := False;
      BOM_UnicodeBE := False;
      BOM_UTF8 := False;
      MEMO.Clear;
      Self.Caption := 'Untitled - Avro Pad';
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.Open1Click(Sender: TObject);
var
  MSG: Integer;
begin
  if ((Length(MEMO.Text) <= 0) and (fFileName = '')) then
  begin
    ShowOpenDialog;
  end
  else
  begin
    if (MemoChanged = True) then
    begin
      MSG := Application.MessageBox('The text in the current file has changed.' + #10 + '' + #10 + 'Do you want to save the changes first?', 'Avro Pad',
        MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
      if MSG = ID_YES then
      begin
        Save1Click(nil);
        if MemoChanged = False then
          ShowOpenDialog;
      end
      else if MSG = ID_NO then
      begin
        ShowOpenDialog;
      end
      else
        Exit;
    end
    else
    begin
      ShowOpenDialog;
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.OpenFile(const fFile: string);
var
  fs: TFileStream;
begin
  try
    BOM_Unicode := False;
    BOM_UnicodeBE := False;
    BOM_UTF8 := False;
    fs := TFileStream.Create(fFile, fmOpenRead);
    LoadFromStream_BOM_Return(fs, True, BOM_Unicode, BOM_UnicodeBE, BOM_UTF8);
    FreeAndNil(fs);
    MemoChanged := False;
    fFileName := fFile;
    Self.Caption := ExtractFileName(fFile) + ' - Avro Pad';
  except
    on e: exception do
    begin
      Application.MessageBox(PChar('Error opening specified file:' + #10 + fFile), 'Avro Pad', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.Paste1Click(Sender: TObject);
begin
  MEMO.SetFocus;
  SendInput_Down(VK_Control);
  SendInput_Down(V_KEY);
  SendInput_UP(V_KEY);
  SendInput_UP(VK_Control);
end;

{ =============================================================================== }

procedure TfrmSpell.Save1Click(Sender: TObject);
begin
  if fFileName = '' then
    ShowSaveDialog
  else
    SaveFile(fFileName, BOM_Unicode, BOM_UnicodeBE, BOM_UTF8);

end;

{ =============================================================================== }

procedure TfrmSpell.Saveas1Click(Sender: TObject);
begin
  ShowSaveDialog;
end;

{ =============================================================================== }

procedure TfrmSpell.SaveFile(const fFile: string; bBOM_Unicode, bBOM_UnicodeBE, bBOM_UTF8: Boolean);
var
  fs: TFileStream;
begin
  try
    fs := TFileStream.Create(fFile, fmCreate);
    if bBOM_Unicode or bBOM_UnicodeBE or bBOM_UTF8 then
      SaveToStream_BOM_Specify(fs, True, bBOM_Unicode, bBOM_UnicodeBE, bBOM_UTF8)
    else
      SaveToStream_BOM_Specify(fs, True, True, False, False);
    FreeAndNil(fs);
    fFileName := fFile;
    MemoChanged := False;
    Self.Caption := ExtractFileName(fFile) + ' - Avro Pad';
  except
    on e: exception do
    begin
      Application.MessageBox('Error occured while saving file!', 'Avro Pad', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.SelectAll1Click(Sender: TObject);
begin
  MEMO.SelectAll;
end;

{ =============================================================================== }

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

{ =============================================================================== }

procedure TfrmSpell.ShowOpenDialog;
begin

  OpenDialog.InitialDir := LastDirectory;
  OpenDialog.Files.Clear;
  OpenDialog.FileName := '';
  if OpenDialog.Execute() then
  begin
    OpenFile(OpenDialog.FileName);
    LastDirectory := ExtractFilepATH(OpenDialog.FileName);
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.ShowSaveDialog;
begin
  SaveDialog.InitialDir := LastDirectory;
  SaveDialog.Files.Clear;
  SaveDialog.FileName := '';

  if BOM_Unicode then
    SaveDialog.FilterIndex := 1
  else if BOM_UnicodeBE then
    SaveDialog.FilterIndex := 2
  else if BOM_UTF8 then
    SaveDialog.FilterIndex := 3
  else
    SaveDialog.FilterIndex := 1;

  BOM_Unicode := False;
  BOM_UnicodeBE := False;
  BOM_UTF8 := False;

  if SaveDialog.Execute() then
  begin
    if SaveDialog.FilterIndex = 1 then
      BOM_Unicode := True
    else if SaveDialog.FilterIndex = 2 then
      BOM_UnicodeBE := True
    else if SaveDialog.FilterIndex = 3 then
      BOM_UTF8 := True
    else
      BOM_Unicode := True;

    LastDirectory := ExtractFilepATH(SaveDialog.FileName);

    SaveFile(SaveDialog.FileName, BOM_Unicode, BOM_UnicodeBE, BOM_UTF8);
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.Spellcheckoptions1Click(Sender: TObject);
begin
  Avro_ShowOptions;
end;

{ =============================================================================== }

procedure TfrmSpell.Startspellchek1Click(Sender: TObject);
begin
  if CheckingSpell then
    Exit;

  CheckingSpell := True;

  Progress.Visible := True;
  Progress.Position := 0;
  MP.ResetAll;
  MP.BeginPursing;
end;

{ =============================================================================== }

procedure TfrmSpell.WordWrap1Click(Sender: TObject);
begin
  WordWrap1.Checked := not WordWrap1.Checked;

  if WordWrap1.Checked then
  begin
    MEMO.WordWrap := True;
    MEMO.ScrollBars := ssVertical;
    AvroPadWrap := 'YES';
  end
  else
  begin
    MEMO.WordWrap := False;
    MEMO.ScrollBars := ssBoth;
    AvroPadWrap := 'NO';
  end;
end;

{ =============================================================================== }

procedure TfrmSpell.AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);
begin
  if SameText('ImmersiveColorSet', string(Section)) then
    HandleThemes;
end;

function TfrmSpell.AutoDetectCharacterSet(Stream: TStream): TUnicodeStreamCharSet;
var
  ByteOrderMark: Char;
  BytesRead:     Integer;
  Utf8Test:      array [0 .. 2] of AnsiChar;
begin
  // Byte Order Mark
  ByteOrderMark := #0;
  if (Stream.Size - Stream.Position) >= SizeOf(ByteOrderMark) then
  begin
    BytesRead := Stream.Read(ByteOrderMark, SizeOf(ByteOrderMark));
    if (ByteOrderMark <> UNICODE_BOM) and (ByteOrderMark <> UNICODE_BOM_SWAPPED) then
    begin
      ByteOrderMark := #0;
      Stream.Seek(-BytesRead, soFromCurrent);
      if (Stream.Size - Stream.Position) >= Length(Utf8Test) * SizeOf(AnsiChar) then
      begin
        BytesRead := Stream.Read(Utf8Test[0], Length(Utf8Test) * SizeOf(AnsiChar));
        if Utf8Test <> UTF8_BOM then
          Stream.Seek(-BytesRead, soFromCurrent);
      end;
    end;
  end;
  // Test Byte Order Mark
  if ByteOrderMark = UNICODE_BOM then
    Result := csUnicode
  else if ByteOrderMark = UNICODE_BOM_SWAPPED then
    Result := csUnicodeSwapped
  else if Utf8Test = UTF8_BOM then
    Result := csUtf8
  else
    Result := csAnsi;
end;

procedure TfrmSpell.LoadFromStream_BOM_Return(Stream: TStream; WithBOM: Boolean; var BOM_Unicode, BOM_UnicodeBE, BOM_UTF8: Boolean);
var
  DataLeft:      Integer;
  StreamCharSet: TUnicodeStreamCharSet;
  SW:            string;
  SA:            AnsiString;
begin

  if WithBOM then
    StreamCharSet := AutoDetectCharacterSet(Stream)
  else
    StreamCharSet := csUnicode;

  if StreamCharSet = csUnicode then
    BOM_Unicode := True
  else if StreamCharSet = csUnicodeSwapped then
    BOM_UnicodeBE := True
  else if StreamCharSet = csUtf8 then
    BOM_UTF8 := True;

  DataLeft := Stream.Size - Stream.Position;
  if (StreamCharSet in [csUnicode, csUnicodeSwapped]) then
  begin
    // BOM indicates Unicode text stream
    if DataLeft < SizeOf(Char) then
      SW := ''
    else
    begin
      SetLength(SW, DataLeft div SizeOf(Char));
      Stream.Read(PChar(SW)^, DataLeft);
      if StreamCharSet = csUnicodeSwapped then
        StrSwapByteOrder(PChar(SW));
    end;
    MEMO.Lines.SetText(PChar(SW));
  end
  else if StreamCharSet = csUtf8 then
  begin
    // BOM indicates UTF-8 text stream
    SetLength(SA, DataLeft div SizeOf(AnsiChar));
    Stream.Read(PAnsiChar(SA)^, DataLeft);
    MEMO.Lines.SetText(PChar(UTF8ToString(SA)));
  end
  else
  begin
    // without byte order mark it is assumed that we are loading ANSI text
    SetLength(SA, DataLeft div SizeOf(AnsiChar));
    Stream.Read(PAnsiChar(SA)^, DataLeft);
    MEMO.Lines.SetText(PChar(string(SA)));
  end;

end;

procedure TfrmSpell.HandleThemes;
begin
  SetAppropriateThemeMode('Windows10 Dark', 'Windows10');
end;

procedure TfrmSpell.SaveToStream_BOM_Specify(Stream: TStream; WithBOM, BOM_Unicode, BOM_UnicodeBE, BOM_UTF8: Boolean);
var
  SW:  string;
  UT:  utf8string;
  BOM: Char;
begin
  if WithBOM then
  begin
    if BOM_Unicode then
    begin
      BOM := UNICODE_BOM;
      Stream.WriteBuffer(BOM, SizeOf(Char));
      SW := MEMO.Lines.GetText;
      Stream.WriteBuffer(PChar(SW)^, Length(SW) * SizeOf(Char));
    end
    else if BOM_UTF8 then
    begin
      Stream.WriteBuffer(UTF8_BOM, Length(UTF8_BOM) * SizeOf(AnsiChar));
      UT := utf8encode(MEMO.Lines.GetText);
      Stream.WriteBuffer(PAnsiChar(UT)^, Length(UT) * SizeOf(AnsiChar));
    end
    else if BOM_UnicodeBE then
    begin
      BOM := UNICODE_BOM_SWAPPED;
      Stream.WriteBuffer(BOM, SizeOf(Char));
      SW := MEMO.Lines.GetText;
      StrSwapByteOrder(PChar(SW));
      Stream.WriteBuffer(PChar(SW)^, Length(SW) * SizeOf(Char));
    end
    else
    begin
      BOM := UNICODE_BOM;
      Stream.WriteBuffer(BOM, SizeOf(Char));
      SW := MEMO.Lines.GetText;
      Stream.WriteBuffer(PChar(SW)^, Length(SW) * SizeOf(Char));
    end;
  end
  else
  begin
    SW := MEMO.Lines.GetText;
    Stream.WriteBuffer(PChar(SW)^, Length(SW) * SizeOf(Char));
  end;
end;

procedure TfrmSpell.StrSwapByteOrder(Str: PChar);
var
  P: PWord;
begin
  P := PWord(Str);
  while (P^ <> 0) do
  begin
    P^ := MakeWord(HiByte(P^), LoByte(P^));
    Inc(P);
  end;
end;

end.
