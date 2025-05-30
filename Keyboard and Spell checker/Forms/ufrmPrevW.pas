{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING EXCEPT MENU }

unit ufrmPrevW;

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
  GIFImg,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Dialogs,
  Buttons,
  Generics.Collections,
  StrUtils,
  Menus,
  OleAcc,
  DebugLog,
  System.Threading,
  System.SyncObjs;

type
  TfrmPrevW = class(TForm)
    Shape1: TShape;
    ImgTitleBar: TImage;
    imgPin: TImage;
    lblCaption: TLabel;
    Button: TImage;
    ImgButtonUp: TImage;
    ImgButtonOver: TImage;
    imgPinOpen: TImage;
    imgPinClose: TImage;
    lblPreview: TLabel;
    PopupMenu: TPopupMenu;
    ransparency1: TMenuItem;
    Notransparency1: TMenuItem;
    N101: TMenuItem;
    N201: TMenuItem;
    N301: TMenuItem;
    N401: TMenuItem;
    N501: TMenuItem;
    N601: TMenuItem;
    ShowPreviewWindow1: TMenuItem;
    ShowPreviewWindow2: TMenuItem;
    List: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure ButtonMouseEnter(Sender: TObject);
    procedure ButtonMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgPinClick(Sender: TObject);
    procedure ImgTitleBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lblCaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImgTitleBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgTitleBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblCaptionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblCaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListClick(Sender: TObject);
    private
      { Private declarations }

      // Globals
      PreviewWCurrentlyVisible: Boolean;
      MouseDown:                Boolean;

      function FindCaretPosWindow(out X, Y: Integer): Boolean;
      function GetCaretScreenPos_MSAA(out X, Y: Integer): Boolean;
      function GetCaretScreenPos_Raw(out X, Y: Integer): Boolean;
      procedure FindCaretAndMoveWindow();

      procedure InitPreviewWindowAtAppStart;
      procedure DelayedExecute(DelayMs: Integer; Proc: TThreadMethod);

      function ShouldShowWindow(): Boolean;
      function ShouldFollowCaret(hforewnd: HWND): Boolean;
      procedure ToggleFollowCaret();
      procedure TurnOffFollowingCaret();
      procedure RefreshPinIcon();

      procedure MoveWindow(X, Y: Integer);
    public
      { Public declarations }

      function IsPreviewVisible(): Boolean;
      procedure UpdatePreviewCaption(const EnglishT: string);

      procedure HidePreview;
      procedure ShowPreview;
      procedure UpdateListHeight;

      procedure SelectFirstItem;
      procedure SelectNItem(const ItemNumber: Integer);
      procedure SelectItem(const Item: string);
      procedure SelectNextItem;
      procedure SelectPrevItem;
    protected
      procedure CreateParams(var Params: TCreateParams); override;

  end;

var
  frmPrevW: TfrmPrevW;

implementation

{$R *.dfm}

uses
  uWindowHandlers,
  uTopBar,
  uForm1,
  BanglaChars,
  uRegistrySettings;

{ =============================================================================== }

// MSAA works with Chrome, Firefox etc.
function TfrmPrevW.GetCaretScreenPos_MSAA(out X, Y: Integer): Boolean;
var
  Acc:                                     IAccessible;
  VarChild:                                OleVariant;
  CaretX, CaretY, CaretWidth, CaretHeight: Integer;
  Handle:                                  HWND;
  CaretPos:                                TPoint;
  LocResult:                               HRESULT;
begin
  Result := False;
  X := -1;
  Y := -1;

  Handle := GetForegroundWindow;
  if (Handle = 0) or (Handle = self.Handle) then
  begin
    Log('Ignoring Handle in GetCaretScreenPos_MSAA. Handle = ', Handle);
    Exit;
  end;

  // Try to get the accessibility object
  if AccessibleObjectFromWindow(Handle, OBJID_CARET, IID_IAccessible, Acc) <> S_OK then
  begin
    Log('Error: failed to get accessibility object');
    Exit; // Return if we fail to get the caret object
  end;

  if Acc = nil then
  begin
    Log('Error: accessibility object is nil');
    Exit; // Ensure Acc is valid before accessing it
  end;

  VarChild := CHILDID_SELF; // Properly initialize VarChild

  LocResult := Acc.accLocation(CaretX, CaretY, CaretWidth, CaretHeight, VarChild);
  if (LocResult = S_OK) then
  begin
    X := CaretX;
    Y := CaretY + CaretHeight; // Move Y to bottom of caret
    Result := True;
  end
  else
    Log('Error: accLocation. LocResult = ', LocResult);
end;

{ =============================================================================== }

// Fallback: Raw Caret Position, works with classic win32 applications
function TfrmPrevW.GetCaretScreenPos_Raw(out X, Y: Integer): Boolean;
var
  ThreadID:      DWORD;
  GUIInfo:       TGUIThreadInfo;
  CaretPos:      TPoint;
  ForegroundWnd: HWND;
begin
  Result := False;
  X := -1;
  Y := -1;

  // Get the foreground window
  ForegroundWnd := GetForegroundWindow;
  if (ForegroundWnd = 0) or (ForegroundWnd = self.Handle) then
    Exit;

  // Initialize GUI thread info
  FillChar(GUIInfo, SizeOf(GUIInfo), 0);
  GUIInfo.cbSize := SizeOf(GUIInfo);

  // Get the GUI thread info of the foreground window
  ThreadID := GetWindowThreadProcessId(ForegroundWnd, nil);
  if (ThreadID = 0) or (not GetGUIThreadInfo(ThreadID, GUIInfo)) then
    Exit;

  // Check if there is a caret
  if GUIInfo.hwndCaret = 0 then
    Exit;

  // Get caret position (relative to the client area)
  CaretPos.X := GUIInfo.rcCaret.Left;
  CaretPos.Y := GUIInfo.rcCaret.Bottom;

  // Convert to screen coordinates
  if Windows.ClientToScreen(GUIInfo.hwndCaret, CaretPos) then
  begin
    X := CaretPos.X;
    Y := CaretPos.Y;
    Result := True;
  end;
end;

{ =============================================================================== }

function TfrmPrevW.FindCaretPosWindow(out X, Y: Integer): Boolean;
begin
  if GetCaretScreenPos_MSAA(X, Y) then
  begin
    Result := True;
    Log('Caret found using MSAA. X = ' + IntToStr(X) + ', Y = ' + IntToStr(Y));
  end
  else if GetCaretScreenPos_Raw(X, Y) then
  begin
    Result := True;
    Log('Caret found using Raw. X = ' + IntToStr(X) + ', Y = ' + IntToStr(Y));
  end;

end;

{ =============================================================================== }

procedure TfrmPrevW.MoveWindow(X, Y: Integer);
begin
  self.Top := Y;
  self.Left := X;
end;

{ =============================================================================== }

function TfrmPrevW.ShouldFollowCaret(hforewnd: HWND): Boolean;
begin
  // No need to follow if the preview is turned off in settings
  if not(ShowPrevWindow = 'YES') then
  begin
    Result := False;
    Exit;
  end;

  if (hforewnd = 0) or (hforewnd = self.Handle) then
  begin
    Result := False;
    Exit;
  end;

  if FollowCaretByDefault = 'YES' then
    Result := True
  else
    Result := False;
end;

{ =============================================================================== }

function TfrmPrevW.ShouldShowWindow(): Boolean;
begin
  if ShowPrevWindow = 'YES' then
    Result := True
  else
    Result := False;
end;

{ =============================================================================== }

procedure TfrmPrevW.FindCaretAndMoveWindow();
var
  Handle:     HWND;
  X, Y:       Integer;
  FoundCaret: Boolean;
begin
  Handle := GetForegroundWindow;
  if ShouldFollowCaret(Handle) then
  begin
    FoundCaret := FindCaretPosWindow(X, Y);

    if FoundCaret then
      MoveWindow(X, Y);
  end;

  if ShouldShowWindow then
    ShowPreview;
end;
{ =============================================================================== }

procedure TfrmPrevW.UpdatePreviewCaption(const EnglishT: string);
var
  Handle:     HWND;
  X, Y:       Integer;
  FoundCaret: Boolean;
begin
  lblPreview.Caption := EnglishT;

  // User typed something, update window position if we are following caret
  DelayedExecute(20, FindCaretAndMoveWindow);
end;

{ =============================================================================== }

procedure TfrmPrevW.RefreshPinIcon();
begin
  if FollowCaretByDefault = 'YES' then
    imgPin.Picture := imgPinClose.Picture
  else
    imgPin.Picture := imgPinOpen.Picture;
end;

{ =============================================================================== }

procedure TfrmPrevW.ToggleFollowCaret();
begin
  if FollowCaretByDefault = 'YES' then
    FollowCaretByDefault := 'NO'
  else
    FollowCaretByDefault := 'YES';

  RefreshPinIcon();
end;

{ =============================================================================== }

procedure TfrmPrevW.TurnOffFollowingCaret();
begin
  FollowCaretByDefault := 'NO';
  RefreshPinIcon();
end;

{ =============================================================================== }

procedure TfrmPrevW.DelayedExecute(DelayMs: Integer; Proc: TThreadMethod);
begin
  TThread.ForceQueue(nil, Proc, DelayMs);
end;

{ =============================================================================== }

procedure TfrmPrevW.InitPreviewWindowAtAppStart();
var
  hforewnd:             HWND;
  TID, mID:             DWORD;
  WndCaption, WndClass: string;
begin
  self.Show;
  self.AlphaBlendValue := 255;
  self.AlphaBlendValue := 0;
  Application.ProcessMessages;
end;

{ =============================================================================== }

procedure TfrmPrevW.ButtonMouseEnter(Sender: TObject);
begin
  Button.Picture := ImgButtonOver.Picture;
end;

{ =============================================================================== }

procedure TfrmPrevW.ButtonMouseLeave(Sender: TObject);
begin
  Button.Picture := ImgButtonUp.Picture;
end;

{ =============================================================================== }

procedure TfrmPrevW.ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PopupMenu.Popup(self.Left + (Sender as TImage).Left, self.Top + (Sender as TImage).Top + (Sender as TImage).Height);
end;

{ =============================================================================== }

procedure TfrmPrevW.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST or WS_EX_NOACTIVATE or WS_EX_TOOLWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

{ =============================================================================== }

procedure TfrmPrevW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmPrevW := nil;
end;

{ =============================================================================== }

procedure TfrmPrevW.FormCreate(Sender: TObject);
begin
  Shape1.Top := 0;
  Shape1.Left := 0;

  UpdateListHeight;

  Height := Shape1.Height;
  Width := Shape1.Width;

  ImgTitleBar.Top := Shape1.Top + 1;
  ImgTitleBar.Left := Shape1.Left + 1;
  ImgTitleBar.Width := Shape1.Width - 2;

  Button.Top := ImgTitleBar.Top + 4;
  Button.Left := ImgTitleBar.Left + 4;

  lblCaption.Top := Button.Top;
  lblCaption.Left := Button.Left + Button.Width + 4;

  imgPin.Top := Button.Top;
  imgPin.Left := Width - 30;

  lblPreview.Top := ImgTitleBar.Top + ImgTitleBar.Height + 2;
  lblPreview.Left := ImgTitleBar.Left + 4;
  lblPreview.Caption := '';

  MouseDown := False;
  RefreshPinIcon();
  DelayedExecute(200, InitPreviewWindowAtAppStart);
  HidePreview;
end;

{ =============================================================================== }

procedure TfrmPrevW.imgPinClick(Sender: TObject);
begin
  ToggleFollowCaret;
end;

{ =============================================================================== }

procedure TfrmPrevW.ImgTitleBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := True;
end;

{ =============================================================================== }

procedure TfrmPrevW.ImgTitleBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if MouseDown then
  begin
    MoveWindow(self.Left + X, self.Top + Y);

    TurnOffFollowingCaret;
  end;
end;

{ =============================================================================== }

procedure TfrmPrevW.ImgTitleBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := False;
end;

{ =============================================================================== }

procedure TfrmPrevW.lblCaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := True;
end;

{ =============================================================================== }

procedure TfrmPrevW.lblCaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if MouseDown then
  begin
    MoveWindow(self.Left + X, self.Top + Y);

    TurnOffFollowingCaret;
  end;
end;

{ =============================================================================== }

procedure TfrmPrevW.lblCaptionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := False;
end;

{ =============================================================================== }

procedure TfrmPrevW.ListClick(Sender: TObject);
begin
  AvroMainForm1.KeyLayout.SelectCandidate(List.Items[List.ItemIndex]);
end;

{ =============================================================================== }

function TfrmPrevW.IsPreviewVisible: Boolean;
begin
  Result := PreviewWCurrentlyVisible;
end;

{ =============================================================================== }

procedure TfrmPrevW.ShowPreview;
begin
  TopMost(frmPrevW.Handle);
  self.AlphaBlendValue := 255;
  PreviewWCurrentlyVisible := True;
  Application.ProcessMessages;
end;

{ =============================================================================== }

procedure TfrmPrevW.HidePreview;
begin
  self.AlphaBlendValue := 0;
  PreviewWCurrentlyVisible := False;
end;

{ =============================================================================== }

procedure TfrmPrevW.SelectFirstItem;
begin
  List.ItemIndex := 0;
  ListClick(nil);
end;

{ =============================================================================== }

procedure TfrmPrevW.SelectItem(const Item: string);

  function EscapeSpecialCharacters(const inputT: string): string;
  var
    T: string;
  begin
    T := inputT;
    T := ReplaceStr(T, '\', '');
    T := ReplaceStr(T, '|', '');
    T := ReplaceStr(T, '(', '');
    T := ReplaceStr(T, ')', '');
    T := ReplaceStr(T, '[', '');
    T := ReplaceStr(T, ']', '');
    T := ReplaceStr(T, '{', '');
    T := ReplaceStr(T, '}', '');
    T := ReplaceStr(T, '^', '');
    T := ReplaceStr(T, '$', '');
    T := ReplaceStr(T, '*', '');
    T := ReplaceStr(T, '+', '');
    T := ReplaceStr(T, '?', '');
    T := ReplaceStr(T, '.', '');

    // Additional characters
    T := ReplaceStr(T, '~', '');
    T := ReplaceStr(T, '!', '');
    T := ReplaceStr(T, '@', '');
    T := ReplaceStr(T, '#', '');
    T := ReplaceStr(T, '%', '');
    T := ReplaceStr(T, '&', '');
    T := ReplaceStr(T, '-', '');
    T := ReplaceStr(T, '_', '');
    T := ReplaceStr(T, '=', '');
    T := ReplaceStr(T, #39, '');
    T := ReplaceStr(T, '"', '');
    T := ReplaceStr(T, ';', '');
    T := ReplaceStr(T, '<', '');
    T := ReplaceStr(T, '>', '');
    T := ReplaceStr(T, '/', '');
    T := ReplaceStr(T, '\', '');
    T := ReplaceStr(T, ',', '');
    T := ReplaceStr(T, ':', '');
    T := ReplaceStr(T, '`', '');
    T := ReplaceStr(T, b_Taka, '');
    T := ReplaceStr(T, b_Dari, '');

    Result := T;

  end;

var
  I, J: Integer;
begin

  J := -1;
  for I := 0 to List.Count - 1 do
  begin
    if EscapeSpecialCharacters(List.Items[I]) = Item then
    begin
      List.ItemIndex := I;
      J := I;
      break;
    end;
  end;

  if J < 0 then
    List.ItemIndex := 0;

  ListClick(nil);
end;

{ =============================================================================== }

procedure TfrmPrevW.SelectNextItem;
var
  I:     Integer;
  Total: Integer;
begin
  I := List.ItemIndex;
  if I < 0 then
    I := 0;
  Total := List.Count - 1;
  I := I + 1;
  if I <= Total then
    List.ItemIndex := I
  else if I > Total then
    List.ItemIndex := 0;
  ListClick(nil);
end;

{ =============================================================================== }

procedure TfrmPrevW.SelectNItem(const ItemNumber: Integer);
begin
  if ItemNumber <= List.Count - 1 then
    List.ItemIndex := ItemNumber
  else
    List.ItemIndex := 0;
  ListClick(nil);
end;

{ =============================================================================== }

procedure TfrmPrevW.SelectPrevItem;
var
  I:     Integer;
  Total: Integer;
begin
  I := List.ItemIndex;
  if I < 0 then
    I := 0;
  Total := List.Count - 1;
  I := I - 1;
  if I < 0 then
    List.ItemIndex := Total
  else
    List.ItemIndex := I;
  ListClick(nil);
end;

{ =============================================================================== }

procedure TfrmPrevW.UpdateListHeight;
begin
  if List.Items.Count > 1 then
  begin
    if List.Items.Count < 8 then
      List.Height := (List.Items.Count + 1) * List.ItemHeight
    else
      List.Height := 8 * List.ItemHeight;
    Shape1.Height := List.Top + List.Height + 1;
    Height := Shape1.Height;
  end
  else
  begin
    Shape1.Height := List.Top - Shape1.Top;
    Height := Shape1.Height;
  end;

end;

end.
