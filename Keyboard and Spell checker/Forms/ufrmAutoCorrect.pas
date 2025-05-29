{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit ufrmAutoCorrect;

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
  uAutoCorrect,
  StdCtrls,
  ComCtrls,
  clsEnglishToBangla,
  uWindowHandlers,
  uFileFolderHandling,
  StrUtils,
  Generics.Collections;

type
  TfrmAutoCorrect = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure ListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ReplaceTChange(Sender: TObject);
    procedure WithTChange(Sender: TObject);
    procedure WithTKeyPress(Sender: TObject; var Key: Char);
    procedure ReplaceTKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure cmdDelClick(Sender: TObject);
    procedure cmdAddClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure CheckOnTopClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmdImportClick(Sender: TObject);
    private
      { Private declarations }
      Phonetic: TEnglishToBangla;
      function FindListItem(const SearchStr: string): TListItem;
      procedure ButtonState;
      function Save: Boolean;

    public
      { Public declarations }
    protected
      procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmAutoCorrect: TfrmAutoCorrect;

implementation

uses
  ufrmConflict;

{$R *.dfm}

const
  Show_Window_in_Taskbar = True;

  { =============================================================================== }

procedure TfrmAutoCorrect.ButtonState;
begin
  if (Trim(ReplaceT.text) <> '') and (Trim(WithT.text) <> '') then
    cmdAdd.Enabled := True
  else
    cmdAdd.Enabled := False;

  if (Trim(ReplaceT.text) <> '') or (Trim(WithT.text) <> '') then
    cmdClear.Enabled := True
  else
    cmdClear.Enabled := False;

end;

{ =============================================================================== }

procedure TfrmAutoCorrect.CheckOnTopClick(Sender: TObject);
begin
  if CheckOnTop.Checked then
    TOPMOST(Self.Handle)
  else
    NoTOPMOST(Self.Handle);
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.cmdAddClick(Sender: TObject);
var
  thisItem: TListItem;
begin
  ReplaceT.text := Trim(ReplaceT.text);
  WithT.text := Trim(WithT.text);

  if ReplaceT.text <> WithT.text then
  begin
    ReplaceT.text := Trim(Phonetic.CorrectCase(ReplaceT.text));
    WithT.text := Trim(Phonetic.CorrectCase(WithT.text));
  end;

  thisItem := nil;
  thisItem := FindListItem(ReplaceT.text);

  if (thisItem = nil) then
  begin
    thisItem := List.Items.Add;
    thisItem.Caption := ReplaceT.text;
    thisItem.SubItems.Add(WithT.text);
    List.Selected := nil;
    List.Selected := thisItem;
    thisItem.MakeVisible(False);
  end
  else
  begin
    thisItem.Caption := ReplaceT.text;
    thisItem.SubItems[0] := WithT.text;
    List.Selected := nil;
    List.Selected := thisItem;
    thisItem.MakeVisible(False);
  end;

  WithT.text := '';
  ReplaceT.text := '';
  cmdSave.Enabled := True;

  ReplaceT.SetFocus;

  lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);

end;

{ =============================================================================== }

procedure TfrmAutoCorrect.cmdCancelClick(Sender: TObject);
var
  Msg: Integer;
begin
  if cmdSave.Enabled = True then
  begin
    Msg := Application.MessageBox('Save changes in the auto-correct dictionary?', 'Confirmation', MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON1 +
        MB_APPLMODAL);
    if Msg = ID_YES then
      Save();
    if Msg = ID_CANCEL then
      Exit;
  end;

  Self.Close;

end;

{ =============================================================================== }

procedure TfrmAutoCorrect.cmdClearClick(Sender: TObject);
begin
  ReplaceT.text := '';
  WithT.text := '';

  ReplaceT.SetFocus;
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.cmdDelClick(Sender: TObject);
var
  Msg: Integer;
begin
  if not(List.Selected = nil) then
  begin
    Msg := Application.MessageBox(PChar('Delete ' + List.Selected.Caption + ' = ' + List.Selected.SubItems[0] + '?'), 'Auto correct',
      MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_APPLMODAL);
    if Msg = ID_NO then
      Exit;

    List.Items.Delete(List.Selected.Index);
    ReplaceT.text := '';
    WithT.text := '';
    cmdSave.Enabled := True;
  end
  else
  begin
    Application.MessageBox('No item is selected in the list!', 'Auto correct', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
  end;
  lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.cmdImportClick(Sender: TObject);

{$HINTS Off}
  function LoadIDict(Path: string; var idict: TDictionary<string, string>): Boolean;
  var
    List:                  TStringList;
    I, P:                  Integer;
    FirstPart, SecondPart: string;
  begin
    result := False;
    try
      try
        List := TStringList.Create;
        List.LoadFromFile(Path);

        for I := 0 to List.Count - 1 do
        begin
          if (LeftStr(Trim(List[I]), 1) <> '/') and (Trim(List[I]) <> '') then
          begin
            P := Pos(' ', Trim(List[I]));
            FirstPart := LeftStr(Trim(List[I]), P - 1);
            SecondPart := MidStr(Trim(List[I]), P + 1, Length(Trim(List[I])));
            idict.AddOrSetValue(FirstPart, SecondPart);
          end;
        end;
        result := True;
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar('Cannot import auto-correct dictionary!'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          result := False;
        end;
      end;
    finally
      FreeAndNil(List);
    end;

  end;

{$HINTS On}

{ =============================================================================== }
var
  idict:       TDictionary<string, string>;
  S:           string;
  Rs, Ws:      string;
  thisItem:    TListItem;
  ResultModal: Integer;
  DictItem:    string;
begin
  if OpenDialog1.Execute(Self.Handle) then
  begin
    idict := TDictionary<string, string>.Create;

    if LoadIDict(OpenDialog1.FileName, idict) = False then
      Exit;

    for S in idict.Keys do
    begin

      Rs := S;
      Ws := idict.Items[S];

      if dict.TryGetValue(Rs, DictItem) then
      begin
        // There may be a conflict
        if DictItem <> Ws then
        begin
          // Conflict!! items are not same
          // CheckCreateForm(TfrmConflict, frmConflict, 'frmConflict');
          Application.CreateForm(TfrmConflict, frmConflict);
          frmConflict.EditR.text := Rs;
          frmConflict.EditR_P.text := Phonetic.Convert(Rs);
          frmConflict.EditWC.text := DictItem;
          frmConflict.EditWC_P.text := Phonetic.Convert(DictItem);
          frmConflict.EditWI.text := Ws;
          if Rs <> Ws then
            frmConflict.EditWI_P.text := Phonetic.Convert(Ws)
          else
            frmConflict.EditWI_P.text := Ws;

          ResultModal := frmConflict.ShowModal;

          if ResultModal = mrCancel then
          begin
            // Keep current, do nothing
          end
          else if ResultModal = mrOk then
          begin
            // Update current with imported
            thisItem := nil;
            thisItem := FindListItem(Rs);

            thisItem.Caption := Rs;
            thisItem.SubItems[0] := Ws;
          end;
        end;
      end
      else
      begin
        // No conflict, new item->import this
        thisItem := List.Items.Add;
        thisItem.Caption := Rs;
        thisItem.SubItems.Add(Ws);
      end;
    end;
    WithT.text := '';
    ReplaceT.text := '';
    cmdSave.Enabled := True;

    ReplaceT.SetFocus;

    lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);
  end;
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.cmdSaveClick(Sender: TObject);
begin
  if Save = True then
  begin
    cmdSave.Enabled := False;
    ReplaceT.SetFocus;
  end;
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.CreateParams(var Params: TCreateParams);
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

function TfrmAutoCorrect.FindListItem(const SearchStr: string): TListItem;
var
  thisItem: TListItem;
  Found:    Boolean;
  InIndex:  Integer;
begin
  InIndex := 0;

  thisItem := nil;
  Found := False;

  repeat
    thisItem := List.FindCaption(InIndex, SearchStr, False, True, False);

    if not(thisItem = nil) then
    begin
      // Make it case sensitive
      if thisItem.Caption <> SearchStr then
        // Find again
        InIndex := thisItem.Index + 1
      else
        Found := True;
    end;
  until ((Found = True) or (thisItem = nil));

  result := thisItem;

end;

{ =============================================================================== }

procedure TfrmAutoCorrect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(Phonetic);

  Action := caFree;

  frmAutoCorrect := nil;
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.FormCreate(Sender: TObject);
var
  S:        string;
  thisItem: TListItem;
begin
  Phonetic := TEnglishToBangla.Create;
  Phonetic.AutoCorrectEnabled := False;

  List.Items.BeginUpdate;
  for S in dict.Keys do
  begin
    thisItem := List.Items.Add;
    thisItem.Caption := S;
    thisItem.SubItems.Add(dict.Items[S]);
  end;
  List.SortType := stText;
  List.Items.EndUpdate;

  lblTotalEntries.Caption := 'Total entries : ' + IntToStr(List.Items.Count);

  DisableCloseButton(Self.Handle);
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key := 0;
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.ListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  ReplaceT.text := Item.Caption;
  ReplaceT.SelStart := Length(ReplaceT.text);
  WithT.text := Item.SubItems[0];
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.ReplaceTChange(Sender: TObject);
var
  thisItem: TListItem;
begin
  thisItem := nil;
  thisItem := FindListItem(ReplaceT.text);

  if (thisItem = nil) then
  begin
    WithT.text := '';
  end
  else
  begin
    List.Selected := nil;
    List.Selected := thisItem;
    thisItem.MakeVisible(False);
    WithT.text := thisItem.SubItems[0];
  end;

  ReplaceT.text := StringReplace(ReplaceT.text, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  ButtonState();
  R1.text := Phonetic.Convert(ReplaceT.text);

  if ReplaceT.text = '' then
    R1.text := '';

end;

{ =============================================================================== }

procedure TfrmAutoCorrect.ReplaceTKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #32 then
    Key := #0;
  if Key = #13 then
    Key := #0;
end;

{$HINTS Off}
{ =============================================================================== }

function TfrmAutoCorrect.Save: Boolean;
var
  T:    TStringList;
  I:    Integer;
  Path: string;
begin
  result := False;
  T := TStringList.Create;

  T.BeginUpdate;
  with T do
  begin
    Add('/ **************************************');
    Add('/ Avro Phonetic Autocorrect dictionary');
    Add('/ Copyright (c) OmicronLab. All rights reserved.');
    Add('/ Web: https://www.omicronlab.com/');
    Add('/');
    Add('/ Warning: DO NOT EDIT THIS FILE MANUALLY');
    Add('/ **************************************');

    for I := 0 to List.Items.Count - 1 do
    begin
      Add(List.Items.Item[I].Caption + ' ' + List.Items.Item[I].SubItems[0]);
    end;
  end;
  T.EndUpdate;

  try
    Path := GetAvroDataDir + 'autodict.dct';
    T.SaveToFile(Path);
    DestroyDict;
    InitDict;
    LoadDict;
    result := True;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Cannot save to dictionary!' + #10 + '' + #10 + '-> Make sure the disk is not write protected, or' + #10 + '-> ' + Path +
            ' file is not ''Read Only'', or' + #10 + '-> You have necessary account privilege to modify content.'), 'Auto correct',
        MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      result := False;
    end;
  end;

  T.Free;

end;

{$HINTS On}
{ =============================================================================== }

procedure TfrmAutoCorrect.WithTChange(Sender: TObject);
begin
  ButtonState;
  if WithT.text = ReplaceT.text then
    R2.text := WithT.text
  else
    R2.text := Phonetic.Convert(WithT.text);

  if WithT.text = '' then
    R2.text := '';
end;

{ =============================================================================== }

procedure TfrmAutoCorrect.WithTKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Key := #0;
end;

{ =============================================================================== }

end.
