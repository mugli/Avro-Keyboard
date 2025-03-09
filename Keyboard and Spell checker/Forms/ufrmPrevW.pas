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
{ COMPLETE TRANSFERING EXCEPT MENU }

Unit ufrmPrevW;

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
  GIFImg,
  ExtCtrls,
  StdCtrls,
  Buttons,
  Generics.Collections,
  StrUtils,
  Menus,
  UIAutomationClient_TLB,
  ComObj,
  ActiveX,
  OleAcc,
  DebugLog;

type
  TFollow = record
    Following: Boolean;
    PosX: Integer;
    PosY: Integer;
  end;

Type
  TfrmPrevW = Class(TForm)
    Shape1: TShape;
    ImgTitleBar: TImage;
    imgPin: TImage;
    lblCaption: TLabel;
    Button: TImage;
    ImgButtonUp: TImage;
    ImgButtonOver: TImage;
    imgPinOpen: TImage;
    imgPinClose: TImage;
    FocusSolver: TTimer;
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
    Procedure FormCreate(Sender: TObject);
    Procedure ButtonMouseEnter(Sender: TObject);
    Procedure ButtonMouseLeave(Sender: TObject);
    Procedure FocusSolverTimer(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure imgPinClick(Sender: TObject);
    Procedure ImgTitleBarMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    Procedure lblCaptionMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    Procedure ImgTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ImgTitleBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure lblCaptionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure lblCaptionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure ListClick(Sender: TObject);
  Private
    { Private declarations }
    FollowDict: TDictionary<HWND, TFollow>;
    FollowingCaretinThisWindow: Boolean;
    oldx, oldy, mf: Integer;
    MouseDown: Boolean;
    Function FindCaretPosWindow(out X, Y: Integer): Boolean;
    Function DecideFollowCaret(Var pX, pY: Integer;
      Var DontShow: Boolean): Boolean;
    Procedure moveMe;
    Procedure MoveWindow(X, Y: Integer);
    Procedure UpdateWindowPosData(NoFUpdate: Boolean = True;
      Nofollow: Boolean = False);
    Procedure MoveForm(xx, yy: Integer);

    function GetCaretScreenPos_UIA(out X, Y: Integer): Boolean;
    function GetCaretScreenPos_MSAA(out X, Y: Integer): Boolean;
    function GetCaretScreenPos_Raw(out X, Y: Integer): Boolean;
  Public
    { Public declarations }
    PreviewWVisible: Boolean;
    Procedure UpdateMe(Const EnglishT: String);
    Procedure MakeMeHide;
    Procedure ShowHideList;
    Procedure SelectFirstItem;
    Procedure SelectNItem(Const ItemNumber: Integer);
    Procedure SelectItem(Const Item: String);
    Procedure SelectNextItem;
    Procedure SelectPrevItem;
  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;

  End;

Var
  frmPrevW: TfrmPrevW;

const
  UIA_TextPatternId: Integer = 10014;
  // Manually define missing constant for UI automation type

Implementation

{$R *.dfm}

Uses
  uWindowHandlers,
  uTopBar,
  uForm1,
  BanglaChars;

{ =============================================================================== }

// UIA as first/prefered method to find caret position
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
  if Failed(CoCreateInstance(CLASS_CUIAutomation, nil, CLSCTX_INPROC_SERVER,
    IID_IUIAutomation, UIAutomation)) then
  begin
    Log('Error: Failed to initialize UIAutomation');
    Exit;
  end;

  // Get the focused UI element
  if Failed(UIAutomation.GetFocusedElement(FocusedElement)) or
    (FocusedElement = nil) then
  begin
    Log('Error: No focused element found');
    Exit;
  end;

  // Check if the element supports TextPattern
  if Failed(FocusedElement.GetCurrentPattern(UIA_TextPatternId,
    IUnknown(TextPattern))) or (TextPattern = nil) then
  begin
    Log('Error: Element does not support TextPattern');
    Exit;
  end;

  // Try getting the selection range
  if Failed(TextPattern.GetSelection(TextRanges)) or (TextRanges = nil) then
  begin
    // Fallback: Try getting the full document range instead
    if Failed(TextPattern.Get_DocumentRange(TextRange)) or (TextRange = nil)
    then
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

// Try MSAA if UIA fails
function TfrmPrevW.GetCaretScreenPos_MSAA(out X, Y: Integer): Boolean;
var
  Acc: IAccessible;
  VarChild: OleVariant;
  CaretX, CaretY, CaretWidth, CaretHeight: Integer;
  Handle: HWND;
  CaretPos: TPoint;
begin
  Result := False;
  X := -1;
  Y := -1;

  Handle := GetForegroundWindow;
  if (Handle = 0) or (Handle = self.Handle) then
    Exit;

  // Try to get the accessibility object
  if AccessibleObjectFromWindow(Handle, OBJID_CARET, IID_IAccessible, Acc) <> S_OK
  then
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

  if (Acc.accLocation(CaretX, CaretY, CaretWidth, CaretHeight, VarChild) = S_OK)
  then
  begin
    X := CaretX;
    Y := CaretY + CaretHeight; // Move Y to bottom of caret
    Result := True;
  end;
end;

{ =============================================================================== }

// Final Fallback: Raw Caret Position
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

Function TfrmPrevW.FindCaretPosWindow(out X, Y: Integer): Boolean;
Begin
  Result := False;
  X := -1;
  Y := -1;

  GetCaretScreenPos_UIA(X, Y);
  if (X > 0) and (Y > 0) then
  begin
    Result := True;
    Exit;
  end;

  GetCaretScreenPos_MSAA(X, Y);
  if (X > 0) and (Y > 0) then
  begin
    Result := True;
    Exit;
  end;

  GetCaretScreenPos_Raw(X, Y);
  if (X > 0) and (Y > 0) then
  begin
    Result := True;
    Exit;
  end;
End;

{ =============================================================================== }

Procedure TfrmPrevW.moveMe;
Var
  X, Y: Integer;
  caretFound: Boolean;
  MeTOP, MeLEFT: Integer;
  DontShow: Boolean;
Begin
  // Initialization
  DontShow := False;

  If DecideFollowCaret(MeLEFT, MeTOP, DontShow) = False Then
  Begin
    If DontShow = False Then
      MoveWindow(MeLEFT, MeTOP);
  End
  Else
  Begin
    If DontShow = False Then
    Begin
      caretFound := FindCaretPosWindow(X, Y);
      If caretFound Then
        MoveWindow(X, Y);
    End;
  End;

End;

{ =============================================================================== }

Procedure TfrmPrevW.MoveWindow(X, Y: Integer);
Var
  ScrW, ScrH: Integer;
Begin
  ScrW := Screen.Width;
  ScrH := Screen.Height;

  // Check Y pos
  If Y + self.Height > ScrH Then
    Y := Y - self.Height;

  // Check X pos
  If X < 0 Then
    X := 0
  Else If X + self.Width > ScrW Then
    X := ScrW - self.Width;

  self.Top := Y;
  self.Left := X;
  UpdateWindowPosData(True);
End;

{ =============================================================================== }

Function TfrmPrevW.DecideFollowCaret(Var pX, pY: Integer;
  Var DontShow: Boolean): Boolean;
Var
  hforewnd: HWND;
  Follow: TFollow;
Begin

  hforewnd := GetForegroundWindow;

  If (hforewnd = 0) Or (hforewnd = self.Handle) Then
  Begin
    DontShow := True;
    Result := False;
    Exit;
  End;

  if not FollowDict.TryGetValue(hforewnd, Follow) then
  begin
    DontShow := False;
    Result := True;
    Exit;
  End
  Else
  Begin
    If not Follow.Following Then
    Begin
      pX := Follow.PosX;
      pY := Follow.PosY;
      Result := False;
    End
    Else
    Begin
      Result := True;
    End;
  End;
End;

{ =============================================================================== }

Procedure TfrmPrevW.FocusSolverTimer(Sender: TObject);
Var
  hforewnd: HWND;
  TID, mID: DWORD;
  WndCaption, WndClass: String;
Begin
  hforewnd := GetForegroundWindow;
  If (hforewnd = 0) Or (hforewnd = self.Handle) Then
    Exit;
  TID := GetWindowThreadProcessId(hforewnd, Nil);
  mID := GetCurrentThreadid;
  If TID = mID Then
    Exit;

//  WndCaption := Trim(GetWindowCaption(hforewnd));
//  WndClass := Trim(GetWindowClassName(hforewnd));
//
//  If WndCaption = '' Then
//    Exit;
//  If ContainsText(WndCaption, 'Start Menu') Then
//    Exit;
//  If ContainsText(WndCaption, 'Program Manager') Then
//    Exit;
//  If ContainsText(WndClass, 'Progman') Then
//    Exit;
//  If ContainsText(WndClass, 'Shell_TrayWnd') Then
//    Exit;
//  If ContainsText(WndClass, 'Dv2ControlHost') Then
//    Exit;

  self.Show;
  FollowingCaretinThisWindow := True;
  moveMe;
  self.AlphaBlendValue := 255;
  self.AlphaBlendValue := 0;
  Application.ProcessMessages;
  FocusSolver.Enabled := False;
End;

{ =============================================================================== }

Procedure TfrmPrevW.MoveForm(xx, yy: Integer);
Var
  moveleft, movetop: Integer;
Begin
  moveleft := self.Left + xx - oldx;
  movetop := self.Top + yy - oldy;

  If MouseDown Then
  Begin
    If mf = 0 Then
    Begin
      If (self.Left <> moveleft) Or (self.Top <> movetop) Then
      Begin
        self.Left := moveleft;
        self.Top := movetop;
        UpdateWindowPosData(False, True);
      End;
      mf := 1;
    End
    Else
      mf := 0;
  End;
  oldx := xx;
  oldy := yy;

End;

{ =============================================================================== }

Procedure TfrmPrevW.ButtonMouseEnter(Sender: TObject);
Begin
  Button.Picture := ImgButtonOver.Picture;
End;

{ =============================================================================== }

Procedure TfrmPrevW.ButtonMouseLeave(Sender: TObject);
Begin
  Button.Picture := ImgButtonUp.Picture;
End;

{ =============================================================================== }

Procedure TfrmPrevW.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  PopupMenu.Popup(self.Left + (Sender As TImage).Left,
    self.Top + (Sender As TImage).Top + (Sender As TImage).Height);
End;

{ =============================================================================== }

Procedure TfrmPrevW.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle Or WS_EX_TOPMOST Or WS_EX_NOACTIVATE or
    WS_EX_TOOLWINDOW;
  Params.WndParent := GetDesktopwindow;
End;

{ =============================================================================== }

Procedure TfrmPrevW.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  Action := caFree;
  FreeAndNil(FollowDict);
  frmPrevW := Nil;
End;

{ =============================================================================== }

Procedure TfrmPrevW.FormCreate(Sender: TObject);
Begin
  Shape1.Top := 0;
  Shape1.Left := 0;

  ShowHideList;

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

  FollowDict := TDictionary<HWND, TFollow>.Create;

  oldx := 0;
  oldy := 0;
  mf := 0;
  MouseDown := False;

  FocusSolver.Enabled := True;
  PreviewWVisible := False;

End;

{ =============================================================================== }

Procedure TfrmPrevW.imgPinClick(Sender: TObject);
Begin
  If FollowingCaretinThisWindow = True Then
    UpdateWindowPosData(False, True)
  Else
    UpdateWindowPosData(False, False);
End;

{ =============================================================================== }

Procedure TfrmPrevW.ImgTitleBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  MouseDown := True;
End;

{ =============================================================================== }

Procedure TfrmPrevW.ImgTitleBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
Begin
  MoveForm(X, Y);
End;

{ =============================================================================== }

Procedure TfrmPrevW.ImgTitleBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  MouseDown := False;
End;

{ =============================================================================== }

Procedure TfrmPrevW.lblCaptionMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  MouseDown := True;
End;

{ =============================================================================== }

Procedure TfrmPrevW.lblCaptionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
Begin
  MoveForm(X, Y);
End;

{ =============================================================================== }

Procedure TfrmPrevW.lblCaptionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  MouseDown := False;
End;

{ =============================================================================== }

Procedure TfrmPrevW.ListClick(Sender: TObject);
Begin
  AvroMainForm1.KeyLayout.SelectCandidate(List.Items[List.ItemIndex]);
End;

{ =============================================================================== }

Procedure TfrmPrevW.MakeMeHide;
Begin
  self.AlphaBlendValue := 0;
  PreviewWVisible := False;
End;

{ =============================================================================== }

Procedure TfrmPrevW.SelectFirstItem;
Begin
  List.ItemIndex := 0;
  ListClick(Nil);
End;

{ =============================================================================== }

Procedure TfrmPrevW.SelectItem(Const Item: String);

  Function EscapeSpecialCharacters(Const inputT: String): String;
  Var
    T: String;
  Begin
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

  End;

Var
  I, J: Integer;
Begin

  J := -1;
  For I := 0 To List.Count - 1 Do
  Begin
    If EscapeSpecialCharacters(List.Items[I]) = Item Then
    Begin
      List.ItemIndex := I;
      J := I;
      break;
    End;
  End;

  If J < 0 Then
    List.ItemIndex := 0;

  ListClick(Nil);
End;

{ =============================================================================== }

Procedure TfrmPrevW.SelectNextItem;
Var
  I: Integer;
  Total: Integer;
Begin
  I := List.ItemIndex;
  If I < 0 Then
    I := 0;
  Total := List.Count - 1;
  I := I + 1;
  If I <= Total Then
    List.ItemIndex := I
  Else If I > Total Then
    List.ItemIndex := 0;
  ListClick(Nil);
End;

{ =============================================================================== }

Procedure TfrmPrevW.SelectNItem(Const ItemNumber: Integer);
Begin
  If ItemNumber <= List.Count - 1 Then
    List.ItemIndex := ItemNumber
  Else
    List.ItemIndex := 0;
  ListClick(Nil);
End;

{ =============================================================================== }

Procedure TfrmPrevW.SelectPrevItem;
Var
  I: Integer;
  Total: Integer;
Begin
  I := List.ItemIndex;
  If I < 0 Then
    I := 0;
  Total := List.Count - 1;
  I := I - 1;
  If I < 0 Then
    List.ItemIndex := Total
  Else
    List.ItemIndex := I;
  ListClick(Nil);
End;

{ =============================================================================== }

Procedure TfrmPrevW.ShowHideList;
Begin
  If List.Items.Count > 1 Then
  Begin
    If List.Items.Count < 8 Then
      List.Height := (List.Items.Count + 1) * List.ItemHeight
    Else
      List.Height := 8 * List.ItemHeight;
    Shape1.Height := List.Top + List.Height + 1;
    Height := Shape1.Height;
  End
  Else
  Begin
    Shape1.Height := List.Top - Shape1.Top;
    Height := Shape1.Height;
  End;

End;

{ =============================================================================== }

Procedure TfrmPrevW.UpdateMe(Const EnglishT: String);
Begin
  lblPreview.Caption := EnglishT;

  TopMost(frmPrevW.Handle);
  moveMe;
  self.AlphaBlendValue := 255;
  PreviewWVisible := True;
  Application.ProcessMessages;
End;

{ =============================================================================== }

Procedure TfrmPrevW.UpdateWindowPosData(NoFUpdate, Nofollow: Boolean);
Var
  hforewnd: HWND;
  PosX, PosY: Integer;
  Follow, NewFollow: TFollow;
Begin
  hforewnd := GetForegroundWindow;
  If (hforewnd = 0) Or (hforewnd = self.Handle) Then
    Exit;
  PosX := self.Left;
  PosY := self.Top;

  { ==========================================
    Structure
    F:0:0   or  N:0:0
    F=Follow Caret
    N=Don't Follow Caret
    0:0= POSX:POSY
    '========================================== }

  if not FollowDict.TryGetValue(hforewnd, Follow) then
  begin
    NewFollow.Following := True;
    NewFollow.PosX := PosX;
    NewFollow.PosY := PosY;
    FollowDict.AddOrSetValue(hforewnd, NewFollow);
  end
  Else
  Begin
    If NoFUpdate Then
    Begin
      NewFollow.Following := Follow.Following;
      NewFollow.PosX := PosX;
      NewFollow.PosY := PosY;
      FollowDict.AddOrSetValue(hforewnd, NewFollow);
    End
    Else
    Begin
      NewFollow.Following := not Nofollow;
      NewFollow.PosX := PosX;
      NewFollow.PosY := PosY;
      FollowDict.AddOrSetValue(hforewnd, NewFollow);
    End;
  End;

  If FollowDict.Items[hforewnd].Following Then
  Begin
    imgPin.Picture := imgPinClose.Picture;
    FollowingCaretinThisWindow := True;
  End
  Else
  Begin
    imgPin.Picture := imgPinOpen.Picture;
    FollowingCaretinThisWindow := False;
  End;

End;

{ =============================================================================== }

End.
