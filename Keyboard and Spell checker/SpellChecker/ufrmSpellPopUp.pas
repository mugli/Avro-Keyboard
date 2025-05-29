{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit ufrmSpellPopUp;

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
  StdCtrls,
  ComCtrls,
  clsSpellPhoneticSuggestionBuilder;

type
  TfrmSpellPopUp = class(TForm)
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
    List: TListBox;
    Edit_NotFound: TEdit;
    Edit_ChangeTo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure But_ChangeClick(Sender: TObject);
    procedure But_IgnoreClick(Sender: TObject);
    procedure But_CancelClick(Sender: TObject);
    procedure But_IgnoreAllClick(Sender: TObject);
    procedure But_ChangeAllClick(Sender: TObject);
    procedure But_AddToDictClick(Sender: TObject);
    procedure Edit_ChangeToChange(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure ListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit_ChangeToKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListDblClick(Sender: TObject);
    procedure CheckLessPrefferedClick(Sender: TObject);
    procedure But_OptionsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    private
      { Private declarations }

    public
      { Public declarations }
      procedure ShowSuggestion(FullResult: Boolean);
  end;

type
  TCallback = procedure(Wrd: PChar; CWrd: PChar; SAction: Integer); stdcall;

var
  Callback: TCallback;

var
  frmSpellPopUp: TfrmSpellPopUp;

  // Suggestions by various methods
  PhoneticSug:    TPhoneticSpellSuggestion;
  PhoneticResult: TStringList;
  FuzzyResult:    TStringList;
  OtherResult:    TStringList;

  DetermineZWNJ_ZWJ: string;
  //
  WordNotFound, WordSelected: string;

const
  SA_Default: Integer         = 0;
  SA_Ignore: Integer          = 1;
  SA_Cancel: Integer          = -1;
  SA_IgnoredByOption: Integer = 2;
  SA_ReplaceAll: Integer      = 3;

procedure MoveToOptimumPos(T_X, T_Y: Integer);

implementation

{$R *.dfm}

uses
  uCustomDictionary,
  BanglaChars,
  uSimilarSort_Spell,
  StrUtils,
  ufrmSpellOptions,
  uRegistrySettings,
  uWindowHandlers;

procedure MoveToOptimumPos(T_X, T_Y: Integer);

  function ValidPosition(f_Point: TPoint): Boolean;
  var
    hTaskBar:                  THandle;
    RTaskBar, RDummy, RWindow: TRect;
  begin
    result := False;

    // Get taskbar rectangle
    hTaskBar := FindWindow('Shell_TrayWnd', nil);
    GetWindowRect(hTaskBar, RTaskBar);

    // Get window rectangle with proposed position
    RWindow.Top := f_Point.Y;
    RWindow.Left := f_Point.X;
    RWindow.Right := RWindow.Left + frmSpellPopUp.Width;
    RWindow.Bottom := RWindow.Top + frmSpellPopUp.Height;

    if IntersectRect(RDummy, RWindow, RTaskBar) then
      exit;

    if (f_Point.X < 0) or (f_Point.Y < 0) then
      exit;

    if (RWindow.Right > Screen.Width) or (RWindow.Bottom > Screen.Height) then
      exit;

    result := True;
  end;

const
  MinDistance: Integer = 20;
  WordWidth: Integer   = 50;
  WordHeight: Integer  = 50;
var
  RWord, RWindow, RDummy:                                 TRect;
  Intersect:                                              Boolean;
  PossiblePOS1, PossiblePOS2, PossiblePOS3, PossiblePOS4: TPoint;
begin
  if (T_X < 0) or (T_Y < 0) then
    exit;

  // Check whether current position of Window hides the text
  RWord.Left := T_X - MinDistance;
  RWord.Top := T_Y - MinDistance;
  RWord.Right := T_X + WordWidth + MinDistance;
  RWord.Bottom := T_Y + WordHeight + MinDistance;

  RWindow.Left := frmSpellPopUp.Left;
  RWindow.Top := frmSpellPopUp.Top;
  RWindow.Right := RWindow.Left + frmSpellPopUp.Width;
  RWindow.Bottom := RWindow.Top + frmSpellPopUp.Height;

  Intersect := IntersectRect(RDummy, RWindow, RWord);

  if not Intersect then
    exit;


  // So, current position of Window hides the text, time to move it

  // Calculate possible positions
  PossiblePOS1.X := T_X;
  PossiblePOS1.Y := T_Y - MinDistance - frmSpellPopUp.Height;

  PossiblePOS2.X := T_X;
  PossiblePOS2.Y := T_Y + MinDistance;

  PossiblePOS3.X := T_X - MinDistance - frmSpellPopUp.Width;
  PossiblePOS3.Y := T_Y;

  PossiblePOS4.X := T_X + MinDistance;
  PossiblePOS4.Y := T_Y;

  if ValidPosition(PossiblePOS1) then
  begin
    frmSpellPopUp.Left := PossiblePOS1.X;
    frmSpellPopUp.Top := PossiblePOS1.Y;
    exit;
  end;

  if ValidPosition(PossiblePOS2) then
  begin
    frmSpellPopUp.Left := PossiblePOS2.X;
    frmSpellPopUp.Top := PossiblePOS2.Y;
    exit;
  end;

  if ValidPosition(PossiblePOS3) then
  begin
    frmSpellPopUp.Left := PossiblePOS3.X;
    frmSpellPopUp.Top := PossiblePOS3.Y;
    exit;
  end;

  if ValidPosition(PossiblePOS4) then
  begin
    frmSpellPopUp.Left := PossiblePOS4.X;
    frmSpellPopUp.Top := PossiblePOS4.Y;
    exit;
  end;
end;

procedure TfrmSpellPopUp.But_AddToDictClick(Sender: TObject);
begin
  WordNotFound := Edit_NotFound.Text;
  WordSelected := '';
  SpellCustomDict.Add(WordNotFound);
  Self.Hide;
  Callback(PChar(WordNotFound), PChar(WordSelected), SA_Ignore);
end;

procedure TfrmSpellPopUp.But_CancelClick(Sender: TObject);
begin
  WordNotFound := '';
  WordSelected := '';
  Self.Hide;
  Callback(PChar(WordNotFound), PChar(WordSelected), SA_Cancel);
end;

procedure TfrmSpellPopUp.But_ChangeAllClick(Sender: TObject);
begin
  WordNotFound := Edit_NotFound.Text;
  WordSelected := Edit_ChangeTo.Text;
  SpellChangeDict.AddOrSetValue(WordNotFound, WordSelected);
  Self.Hide;
  Callback(PChar(WordNotFound), PChar(WordSelected), SA_ReplaceAll);
end;

procedure TfrmSpellPopUp.But_ChangeClick(Sender: TObject);
begin
  WordNotFound := Edit_NotFound.Text;
  WordSelected := Edit_ChangeTo.Text;
  Self.Hide;
  Callback(PChar(WordNotFound), PChar(WordSelected), SA_Default);
end;

procedure TfrmSpellPopUp.But_IgnoreAllClick(Sender: TObject);
begin
  WordNotFound := Edit_NotFound.Text;
  WordSelected := '';
  SpellIgnoreDict.Add(WordNotFound);
  Self.Hide;
  Callback(PChar(WordNotFound), PChar(WordSelected), SA_Ignore);
end;

procedure TfrmSpellPopUp.But_IgnoreClick(Sender: TObject);
begin
  WordNotFound := Edit_NotFound.Text;
  WordSelected := '';
  Self.Hide;
  Callback(PChar(WordNotFound), PChar(WordSelected), SA_Ignore);
end;

procedure TfrmSpellPopUp.But_OptionsClick(Sender: TObject);
begin
  frmSpellOptions := TfrmSpellOptions.Create(Application);
  frmSpellOptions.ShowModal;

  if FullSuggestion = 'YES' then
    CheckLessPreffered.Checked := True
  else
    CheckLessPreffered.Checked := False;
end;

procedure TfrmSpellPopUp.CheckLessPrefferedClick(Sender: TObject);
begin
  if CheckLessPreffered.Checked then
  begin
    ShowSuggestion(True);
    FullSuggestion := 'YES';
  end
  else
  begin
    ShowSuggestion(False);
    FullSuggestion := 'NO';
  end;
end;

procedure TfrmSpellPopUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmSpellPopUp := nil;
end;

procedure TfrmSpellPopUp.FormCreate(Sender: TObject);
begin
  DetermineZWNJ_ZWJ := ZWJ;

  TOPMOST(Self.Handle);
end;

procedure TfrmSpellPopUp.FormShow(Sender: TObject);
begin
  Self.Caption := 'Avro Spell Checker';

  if FullSuggestion = 'YES' then
  begin
    CheckLessPreffered.Checked := True;
    ShowSuggestion(True);
  end
  else
  begin
    CheckLessPreffered.Checked := False;
    ShowSuggestion(False)
  end;

  List.ItemIndex := 0;
  List.SetFocus;
  ListClick(nil);
end;

procedure TfrmSpellPopUp.ListClick(Sender: TObject);
begin
  if List.ItemIndex < 0 then
    exit;

  if List.Items[List.ItemIndex] = 'More...' then
    ShowSuggestion(True)
  else if List.Items[List.ItemIndex] = 'No Suggestion' then
    // Do nothing
  else
    Edit_ChangeTo.Text := List.Items[List.ItemIndex];
end;

procedure TfrmSpellPopUp.ListDblClick(Sender: TObject);
begin
  if List.Items[List.ItemIndex] = 'No Suggestion' then
    exit;
  But_ChangeClick(nil);
end;

procedure TfrmSpellPopUp.ListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ListClick(nil);

  if Key = 13 then
    if But_Change.Enabled then
      But_ChangeClick(nil);
end;

procedure TfrmSpellPopUp.ShowSuggestion(FullResult: Boolean);

  function Fix_ZWNJ_ZWJ(inp: string): string;
  begin
    // result := ReplaceStr(inp, b_R + ZWNJ + b_Hasanta + b_Z,
    // b_R + DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
    result := inp;
  end;

var
  TempList:   TStringList;
  I:          Integer;
  MoreNumber: Integer;
begin

  TempList := TStringList.Create;
  TempList.Sorted := True;
  TempList.Duplicates := dupIgnore;

  Edit_ChangeTo.Text := '';
  List.Clear;

  if FullResult = True then
  begin
    if PhoneticResult.Count > 0 then
    begin
      for I := 0 to PhoneticResult.Count - 1 do
        TempList.Add(PhoneticResult[I]);
    end;

    if FuzzyResult.Count > 0 then
    begin
      for I := 0 to FuzzyResult.Count - 1 do
        TempList.Add(FuzzyResult[I]);
    end;

    if OtherResult.Count > 0 then
    begin
      for I := 0 to OtherResult.Count - 1 do
        TempList.Add(OtherResult[I]);
    end;

    if TempList.Count > 0 then
    begin
      SimilarSort(Edit_NotFound.Text, TempList);
      for I := 0 to TempList.Count - 1 do
        List.Items.Add(Fix_ZWNJ_ZWJ(TempList[I]));
    end
    else
      List.Items.Add('No Suggestion');
  end
  else
  begin
    if PhoneticResult.Count > 0 then
    begin
      for I := 0 to PhoneticResult.Count - 1 do
        TempList.Add(PhoneticResult[I]);
    end;

    if OtherResult.Count > 0 then
    begin
      for I := 0 to OtherResult.Count - 1 do
        TempList.Add(OtherResult[I]);
    end;

    if TempList.Count <= 0 then
    begin
      if FuzzyResult.Count > 0 then
      begin
        for I := 0 to FuzzyResult.Count - 1 do
          TempList.Add(Fix_ZWNJ_ZWJ(FuzzyResult[I]));
      end;
      if TempList.Count > 0 then
      begin
        SimilarSort(Edit_NotFound.Text, TempList);
        for I := 0 to TempList.Count - 1 do
          List.Items.Add(Fix_ZWNJ_ZWJ(TempList[I]));
      end
      else
        List.Items.Add('No Suggestion');
    end
    else
    begin
      if TempList.Count > 0 then
      begin
        SimilarSort(Edit_NotFound.Text, TempList);
        for I := 0 to TempList.Count - 1 do
          List.Items.Add(Fix_ZWNJ_ZWJ(TempList[I]));

        MoreNumber := TempList.Count;
        { SimilarSort resets dupIgnore property, set that again }
        TempList.Sorted := True;
        TempList.Duplicates := dupIgnore;
        if FuzzyResult.Count > 0 then
        begin
          for I := 0 to FuzzyResult.Count - 1 do
            TempList.Add(FuzzyResult[I]);
        end;
        if TempList.Count > MoreNumber then
          List.Items.Add('More...');
      end
      else
        List.Items.Add('No Suggestion');
    end;
  end;

  TempList.Clear;
  FreeAndNil(TempList);
end;

procedure TfrmSpellPopUp.Edit_ChangeToChange(Sender: TObject);
begin
  if Edit_ChangeTo.Text = '' then
  begin
    But_Change.Enabled := False;
    But_ChangeAll.Enabled := False;
  end
  else
  begin
    But_Change.Enabled := True;
    But_ChangeAll.Enabled := True;
  end;
end;

procedure TfrmSpellPopUp.Edit_ChangeToKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
    if But_Change.Enabled then
      But_ChangeClick(nil);
end;

initialization

frmSpellPopUp := nil;

end.
