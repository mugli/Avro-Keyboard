{
  =============================================================================
  *****************************************************************************
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  https://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is Avro Keyboard 5.

  The Initial Developer of the Original Code is
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING EXCEPT MENU }

unit ufrmPrevW;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GIFImg, ExtCtrls, StdCtrls, Buttons, Generics.Collections, StrUtils,
  Menus, UIAutomationClient_TLB, ComObj, ActiveX, OleAcc, DebugLog,
  System.Threading, System.SyncObjs;

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
    CaretTracker: TTimer;
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
    procedure CaretTrackerTimer(Sender: TObject);
  private
    { Private declarations }

    // Globals
    PreviewWCurrentlyVisible: Boolean;
    MouseDown: Boolean;

    // For debouncing FindCaretPosWindow
    FLastCaretCheckTime: DWORD;
    FCachedCaretX, FCachedCaretY: Integer;
    FCachedCaretResult: Boolean;
    FWorkerRunning: Integer; // Acts like atomic boolean (0 = no, 1 = yes)
    function FindCaretPosWindow(out X, Y: Integer): Boolean;

    function GetCaretScreenPos_UIA(out X, Y: Integer): Boolean;
    function GetCaretScreenPos_MSAA(out X, Y: Integer): Boolean;
    function GetCaretScreenPos_Raw(out X, Y: Integer): Boolean;

    procedure InitPreviewWindowAtAppStart;
    procedure DelayedExecute(DelayMs: Integer; Proc: TThreadMethod);

    function ShouldShowWindow(): Boolean;
    function ShouldFollowCaret(hforewnd: HWND): Boolean;
    procedure ToggleFollowCaret();
    procedure TurnOffFollowingCaret();

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

const
  UIA_TextPatternId: Integer = 10014;
  // Manually define missing constant for UI automation type

  DEBOUNCE_INTERVAL_MS = 100;

implementation

{$R *.dfm}

uses
  uWindowHandlers, uTopBar, uForm1, BanglaChars, uRegistrySettings;

{ =============================================================================== }

// UIA as first/prefered method to find caret position, works with modern Windows applications (like the new Notepad)
function TfrmPrevW.GetCaretScreenPos_UIA(out X, Y: Integer): Boolean;
var
  UIAutomation: IUIAutomation;
  FocusedElement: IUIAutomationElement;
  TextPattern: IUIAutomationTextPattern;
  TextRanges: IUIAutomationTextRangeArray;
  TextRange: IUIAutomationTextRange;
  Rects: PSafeArray;
  Bounds: array of Double;
  LBound, UBound, I: LongInt;
  RangeCount: SYSINT;
begin
  Result := False;
  X := -1;
  Y := -1;

  // Initialize UI Automation
  if Failed(CoCreateInstance(CLASS_CUIAutomation, nil, CLSCTX_INPROC_SERVER, IID_IUIAutomation, UIAutomation)) then
  begin
    Log('Error: Failed to initialize UIAutomation');
    Exit;
  end;

  // Get the focused UI element
  if Failed(UIAutomation.GetFocusedElement(FocusedElement)) or (FocusedElement = nil) then
  begin
    Log('Error: No focused element found');
    Exit;
  end;

  // Check if the element supports TextPattern
  if Failed(FocusedElement.GetCurrentPattern(UIA_TextPatternId, IUnknown(TextPattern))) or (TextPattern = nil) then
  begin
    Log('Error: Element does not support TextPattern');
    Exit;
  end;

  // Try getting the selection range
  if Failed(TextPattern.GetSelection(TextRanges)) or (TextRanges = nil) then
  begin
    // Fallback: Try getting the full document range instead
    if Failed(TextPattern.Get_DocumentRange(TextRange)) or (TextRange = nil) then
    begin
      Log('Error: No text selection or document range found');
      Exit;
    end;
  end
  else
  begin
    // Get the number of text ranges
    if Failed(TextRanges.Get_Length(RangeCount)) or (RangeCount = 0) then
    begin
      Log('Error: No text range found');
      Exit;
    end;

    // Get first text range
    if (RangeCount > 0) then
    begin
      if Failed(TextRanges.GetElement(0, TextRange)) or (TextRange = nil) then
      begin
        Log('Error: Failed to retrieve first text range');
        Exit;
      end;
    end;
  end;

  // Get bounding rectangle
  if Succeeded(TextRange.GetBoundingRectangles(Rects)) and (Rects <> nil) then
  begin
    SafeArrayGetLBound(Rects, 1, LBound);
    SafeArrayGetUBound(Rects, 1, UBound);
    if UBound >= LBound then
    begin
      SetLength(Bounds, (UBound - LBound) + 1);
      for I := LBound to UBound do
        SafeArrayGetElement(Rects, I, Bounds[I]);

      // Get the first bounding box (caret position)
      if Length(Bounds) >= 4 then // Ensure we have enough data
      begin
        X := Round(Bounds[0]); // Left position
        Y := Round(Bounds[1] + Bounds[3]); // Top + Height = Bottom position
        Result := True;
        Exit;
      end;
    end;
    SafeArrayDestroy(Rects);
  end;

  // If we reached here, it means bounding rectangles failed
  Log('Error: No bounding rectangle found');
end;

{ =============================================================================== }

// Try MSAA if UIA fails, works with Chrome, Firefox etc. A little bit slower UIA
function TfrmPrevW.GetCaretScreenPos_MSAA(out X, Y: Integer): Boolean;
var
  Acc: IAccessible;
  VarChild: OleVariant;
  CaretX, CaretY, CaretWidth, CaretHeight: Integer;
  Handle: HWND;
  CaretPos: TPoint;
  LocResult: HRESULT;
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

// Final Fallback: Raw Caret Position, works with classic win32 applications (classic Notepad)
function TfrmPrevW.GetCaretScreenPos_Raw(out X, Y: Integer): Boolean;
var
  ThreadID: DWORD;
  GUIInfo: TGUIThreadInfo;
  CaretPos: TPoint;
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
var
  NowTime: DWORD;
begin
  // Debounce if called frequently
  NowTime := GetTickCount;
  if (NowTime - FLastCaretCheckTime < DEBOUNCE_INTERVAL_MS) then
  begin
    X := FCachedCaretX;
    Y := FCachedCaretY;
    Result := FCachedCaretResult;
    Exit;
  end;

  FLastCaretCheckTime := NowTime;

  // Launch async update, but don't wait for it
  if TInterlocked.CompareExchange(Integer(FWorkerRunning), 1, 0) = 0 then
  begin
    TTask.Run(
      procedure
      var
        XTmp, YTmp: Integer;
        Success: Boolean;
      begin
        try
          XTmp := -1;
          YTmp := -1;
          Success := False;

          if GetCaretScreenPos_UIA(XTmp, YTmp) then
            Success := True
          else if GetCaretScreenPos_MSAA(XTmp, YTmp) then
            Success := True
          else if GetCaretScreenPos_Raw(XTmp, YTmp) then
            Success := True;

          FCachedCaretX := XTmp;
          FCachedCaretY := YTmp;
          FCachedCaretResult := Success;
        finally
          TInterlocked.Exchange(Integer(FWorkerRunning), 0);
        end;
      end);
  end;

  X := FCachedCaretX;
  Y := FCachedCaretY;
  Result := FCachedCaretResult;
end;

{ =============================================================================== }

procedure TfrmPrevW.MoveWindow(X, Y: Integer);
var
  ScrW, ScrH: Integer;
begin
  ScrW := Screen.Width;
  ScrH := Screen.Height;

  // Check Y pos
  if Y + self.Height > ScrH then
    Y := Y - self.Height;

  // Check X pos
  if X < 0 then
    X := 0
  else if X + self.Width > ScrW then
    X := ScrW - self.Width;

  self.Top := Y;
  self.Left := X;
end;

{ =============================================================================== }

function TfrmPrevW.ShouldFollowCaret(hforewnd: HWND): Boolean;
begin
  // No need to follow if the preview is turned off in settings
  if not (ShowPrevWindow = 'YES') then
  begin
    Result := False;
    exit;
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

procedure TfrmPrevW.UpdatePreviewCaption(const EnglishT: string);
var
  Handle: HWND;
  X, Y: Integer;
  FoundCaret: Boolean;
begin
  lblPreview.Caption := EnglishT;

  // User typed something, update window position if we are following caret
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

procedure TfrmPrevW.ToggleFollowCaret();
begin
  if FollowCaretByDefault = 'YES' then
    FollowCaretByDefault := 'NO'
  else
    FollowCaretByDefault := 'YES';

  if FollowCaretByDefault = 'YES' then
    imgPin.Picture := imgPinClose.Picture
  else
    imgPin.Picture := imgPinOpen.Picture;
end;

{ =============================================================================== }

procedure TfrmPrevW.TurnOffFollowingCaret();
begin
  FollowCaretByDefault := 'NO';
  imgPin.Picture := imgPinOpen.Picture;
end;

{ =============================================================================== }

procedure TfrmPrevW.DelayedExecute(DelayMs: Integer; Proc: TThreadMethod);
begin
  TThread.ForceQueue(nil, Proc, DelayMs);
end;

{ =============================================================================== }

procedure TfrmPrevW.InitPreviewWindowAtAppStart();
var
  hforewnd: HWND;
  TID, mID: DWORD;
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

// Hack: GetCaretScreenPos_UIA doesn't work without the timer calling it frequently
procedure TfrmPrevW.CaretTrackerTimer(Sender: TObject);
var
  X, Y: Integer;
begin
  if PreviewWCurrentlyVisible and (FollowCaretByDefault = 'YES') then
    GetCaretScreenPos_UIA(X, Y);
end;

procedure TfrmPrevW.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST or WS_EX_NOACTIVATE or WS_EX_TOOLWINDOW;
  Params.WndParent := GetDesktopwindow;
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
    MoveWindow(Self.Left + X, Self.Top + Y);

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
    MoveWindow(Self.Left + X, Self.Top + Y);

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

procedure TfrmPrevW.ShowPreview;
begin
  TopMost(frmPrevW.Handle);
  self.AlphaBlendValue := 255;
  PreviewWCurrentlyVisible := True;
  Application.ProcessMessages;
end;

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
  I: Integer;
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
  I: Integer;
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

