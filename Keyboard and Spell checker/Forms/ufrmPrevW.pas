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
		 Menus;

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
					Procedure ImgTitleBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
					Procedure lblCaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
					Procedure ImgTitleBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
					Procedure ImgTitleBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
					Procedure lblCaptionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
					Procedure lblCaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
					Procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
					Procedure ListClick(Sender: TObject);
		 Private
					{ Private declarations }
					FollowDict: TDictionary<HWND, TFollow>;
					FollowingCaretinThisWindow: Boolean;
					oldx, oldy, mf: Integer;
					MouseDown: Boolean;
					Function FindCaretPosWindow(Var Position: TPoint; Var HeightCaret: Integer): Integer;
					Function DecideFollowCaret(Var pX, pY: Integer; Var DontShow: Boolean): Boolean;
					Procedure moveMe;
					Procedure MoveWindow(MeLEFT, MeTOP, CaretHeight: Integer);
					Procedure UpdateWindowPosData(NoFUpdate: Boolean = True; Nofollow: Boolean = False);
					Procedure MoveForm(xx, yy: Integer);
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

Implementation

{$R *.dfm}

Uses
		 uWindowHandlers,
		 uTopBar,
		 uForm1,
		 BanglaChars;

Procedure TfrmPrevW.ButtonMouseEnter(Sender: TObject);
Begin
		 Button.Picture := ImgButtonOver.Picture;
End;

Procedure TfrmPrevW.ButtonMouseLeave(Sender: TObject);
Begin
		 Button.Picture := ImgButtonUp.Picture;
End;

Procedure TfrmPrevW.ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
		 PopupMenu.Popup(Self.Left + (Sender As TImage).Left, Self.Top + (Sender As TImage).Top + (Sender As TImage).Height);
End;

Procedure TfrmPrevW.CreateParams(Var Params: TCreateParams);
Begin
		 Inherited CreateParams(Params);
		 Params.ExStyle := Params.ExStyle Or WS_EX_TOPMOST Or WS_EX_NOACTIVATE or WS_EX_TOOLWINDOW;
		 Params.WndParent := GetDesktopwindow;
End;

Function TfrmPrevW.DecideFollowCaret(Var pX, pY: Integer; Var DontShow: Boolean): Boolean;
Var
		 hforewnd: HWND;
		 Follow: TFollow;
Begin


		 hforewnd := GetForegroundWindow;

		 If (hforewnd = 0) Or (hforewnd = Self.Handle) Then Begin // Bypass a nasty bug I have faced
					DontShow := True;
					Result := False;
					Exit;
		 End;

		 if not FollowDict.TryGetValue(hforewnd, Follow) then begin
					DontShow := False;
					Result := True;
					Exit;
		 End
		 Else Begin
					If not Follow.Following Then Begin
							 pX := Follow.PosX;
							 pY := Follow.PosY;
							 Result := False;
					End
					Else Begin
							 Result := True;
					End;
		 End;
End;

{$HINTS Off}

Function TfrmPrevW.FindCaretPosWindow(Var Position: TPoint; Var HeightCaret: Integer): Integer;
Var
		 hwndFG, hwndFoc: HWND;
		 TID, mID: DWORD;
		 Ret: Boolean;
		 RetInfo: TGUIThreadInfo;
Begin
		 // Initialize variables
		 RetInfo.cbSize := Sizeof(RetInfo);
		 Result := 0;
		 Ret := False;

		 Ret := GetGUIThreadInfo(GetWindowThreadProcessId(GetForegroundWindow(), Nil), RetInfo);
		 If Ret <> False Then
					HeightCaret := RetInfo.rcCaret.Top - RetInfo.rcCaret.Bottom;
		 hwndFG := GetForegroundWindow;
		 If (hwndFG <> 0) And (hwndFG <> Self.Handle) Then Begin
					TID := GetWindowThreadProcessId(hwndFG, Nil);
					mID := GetCurrentThreadid;
					If TID <> mID Then Begin
							 If AttachThreadInput(mID, TID, True) <> False Then Begin
										hwndFoc := GetFocus();
										If hwndFoc <> 0 Then Begin
												 If GetCaretPos(Position) <> False Then Begin
															Windows.ClientToScreen(hwndFoc, Position);
															Result := hwndFoc
												 End;
										End;
										AttachThreadInput(mID, TID, False);
										{ DONE : Experimental disable. Check carefully }
										ForceForegroundWindow(hwndFG);
										MakeNeverActiveWindow(Self.Handle);
							 End;
					End
					Else Begin
							 hwndFoc := GetFocus();
							 If hwndFoc <> 0 Then Begin
										If GetCaretPos(Position) <> False Then Begin
												 Windows.ClientToScreen(hwndFoc, Position);
												 Result := hwndFoc
										End;
							 End;
					End;
		 End;
End;

{$HINTS On}

Procedure TfrmPrevW.FocusSolverTimer(Sender: TObject);
Var
		 hforewnd: HWND;
		 TID, mID: DWORD;
		 WndCaption, WndClass: String;
Begin
		 hforewnd := GetForegroundWindow;
		 If (hforewnd = 0) Or (hforewnd = Self.Handle) Then
					Exit;
		 TID := GetWindowThreadProcessId(hforewnd, Nil);
		 mID := GetCurrentThreadid;
		 If TID = mID Then
					Exit;

		 WndCaption := Trim(GetWindowCaption(hforewnd));
		 WndClass := Trim(GetWindowClassName(hforewnd));

		 If WndCaption = '' Then
					Exit;
		 If ContainsText(WndCaption, 'Start Menu') Then
					Exit;
		 If ContainsText(WndCaption, 'Program Manager') Then
					Exit;
		 If ContainsText(WndClass, 'Progman') Then
					Exit;
		 If ContainsText(WndClass, 'Shell_TrayWnd') Then
					Exit;
		 If ContainsText(WndClass, 'Dv2ControlHost') Then
					Exit;

		 Self.Show;
		 FollowingCaretinThisWindow := True;
		 moveMe;
		 Self.AlphaBlendValue := 255;
		 Self.AlphaBlendValue := 0;
		 Application.ProcessMessages;
		 FocusSolver.Enabled := False;

End;

Procedure TfrmPrevW.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
		 Action := caFree;
		 FreeAndNil(FollowDict);
		 frmPrevW := Nil;
End;

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

Procedure TfrmPrevW.imgPinClick(Sender: TObject);
Begin
		 If FollowingCaretinThisWindow = True Then
					UpdateWindowPosData(False, True)
		 Else
					UpdateWindowPosData(False, False);
End;


Procedure TfrmPrevW.ImgTitleBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
		 MouseDown := True;
End;

Procedure TfrmPrevW.ImgTitleBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Begin
		 MoveForm(X, Y);
End;



Procedure TfrmPrevW.ImgTitleBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
		 MouseDown := False;
End;

Procedure TfrmPrevW.lblCaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
		 MouseDown := True;
End;

Procedure TfrmPrevW.lblCaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Begin
		 MoveForm(X, Y);
End;

Procedure TfrmPrevW.lblCaptionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
		 MouseDown := False;
End;

Procedure TfrmPrevW.ListClick(Sender: TObject);
Begin
		 AvroMainForm1.KeyLayout.SelectCandidate(List.Items[List.ItemIndex]);
End;

Procedure TfrmPrevW.MakeMeHide;
Begin
		 Self.AlphaBlendValue := 0;
		 PreviewWVisible := False;
End;

Procedure TfrmPrevW.MoveForm(xx, yy: Integer);
Var
		 moveleft, movetop: Integer;
Begin
		 moveleft := Self.Left + xx - oldx;
		 movetop := Self.Top + yy - oldy;

		 If MouseDown Then Begin
					If mf = 0 Then Begin
							 If (Self.Left <> moveleft) Or (Self.Top <> movetop) Then Begin
										Self.Left := moveleft;
										Self.Top := movetop;
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

Procedure TfrmPrevW.moveMe;
Var
		 pos: TPoint;
		 R: Integer;
		 Height: Integer;
		 MeTOP, MeLEFT: Integer;
		 DontShow: Boolean;
Begin
		 // Initialization
		 DontShow := False;


		 If DecideFollowCaret(MeLEFT, MeTOP, DontShow) = False Then Begin

					If DontShow = False Then
							 MoveWindow(MeLEFT, MeTOP, 0);
		 End
		 Else Begin
					If DontShow = False Then Begin
							 R := FindCaretPosWindow(pos, Height);
							 Height := -1 * Height;
							 MeLEFT := pos.X;
							 MeTOP := pos.Y + Height + 10; { DONE : check this value. Adjust distance from caret }
							 If R <> 0 Then
										MoveWindow(MeLEFT, MeTOP, Height);
					End;
		 End;

End;

Procedure TfrmPrevW.MoveWindow(MeLEFT, MeTOP, CaretHeight: Integer);
Var
		 ScrW, ScrH: Integer;
Begin
		 ScrW := Screen.Width;
		 ScrH := Screen.Height;

		 // Check Y pos
		 If MeTOP + Self.Height > ScrH Then
					MeTOP := MeTOP - 20 - Self.Height - CaretHeight; { DONE : check this value. Adjust distance from below }

		 // Check X pos
		 If MeLEFT < 0 Then
					MeLEFT := 0
		 Else If MeLEFT + Self.Width > ScrW Then
					MeLEFT := ScrW - Self.Width;

		 Self.Top := MeTOP;
		 Self.Left := MeLEFT;
		 UpdateWindowPosData(True);
End;

Procedure TfrmPrevW.SelectFirstItem;
Begin
		 List.ItemIndex := 0;
		 ListClick(Nil);
End;

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
		 For I := 0 To List.Count - 1 Do Begin
					If EscapeSpecialCharacters(List.Items[I]) = Item Then Begin
							 List.ItemIndex := I;
							 J := I;
							 break;
					End;
		 End;

		 If J < 0 Then
					List.ItemIndex := 0;

		 ListClick(Nil);
End;

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



Procedure TfrmPrevW.SelectNItem(Const ItemNumber: Integer);
Begin
		 If ItemNumber <= List.Count - 1 Then
					List.ItemIndex := ItemNumber
		 Else
					List.ItemIndex := 0;
		 ListClick(Nil);
End;

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

Procedure TfrmPrevW.ShowHideList;
Begin
		 If List.Items.Count > 1 Then Begin
					If List.Items.Count < 8 Then
							 List.Height := (List.Items.Count + 1) * List.ItemHeight
					Else
							 List.Height := 8 * List.ItemHeight;
					Shape1.Height := List.Top + List.Height + 1;
					Height := Shape1.Height;
		 End
		 Else Begin
					Shape1.Height := List.Top - Shape1.Top;
					Height := Shape1.Height;
		 End;

End;

Procedure TfrmPrevW.UpdateMe(Const EnglishT: String);
Begin
		 lblPreview.Caption := EnglishT;

		 TopMost(frmPrevW.Handle);
		 moveMe;
		 Self.AlphaBlendValue := 255;
		 PreviewWVisible := True;
		 Application.ProcessMessages;
End;

Procedure TfrmPrevW.UpdateWindowPosData(NoFUpdate, Nofollow: Boolean);
Var
		 hforewnd: HWND;
		 PosX, PosY: Integer;
		 Follow, NewFollow: TFollow;
Begin
		 hforewnd := GetForegroundWindow;
		 If (hforewnd = 0) Or (hforewnd = Self.Handle) Then
					Exit;
		 PosX := Self.Left;
		 PosY := Self.Top;

		 { ==========================================
			 Structure
			 F:0:0   or  N:0:0
			 F=Follow Caret
			 N=Don't Follow Caret
			 0:0= POSX:POSY
			 '========================================== }

		 if not FollowDict.TryGetValue(hforewnd, Follow) then begin
					NewFollow.Following := True;
					NewFollow.PosX := PosX;
					NewFollow.PosY := PosY;
					FollowDict.AddOrSetValue(hforewnd, NewFollow);
		 end
		 Else Begin
					If NoFUpdate Then Begin
							 NewFollow.Following := Follow.Following;
							 NewFollow.PosX := PosX;
							 NewFollow.PosY := PosY;
							 FollowDict.AddOrSetValue(hforewnd, NewFollow);
					End
					Else Begin
							 NewFollow.Following := not Nofollow;
							 NewFollow.PosX := PosX;
							 NewFollow.PosY := PosY;
							 FollowDict.AddOrSetValue(hforewnd, NewFollow);
					End;
		 End;

		 If FollowDict.Items[hforewnd].Following Then Begin
					imgPin.Picture := imgPinClose.Picture;
					FollowingCaretinThisWindow := True;
		 End
		 Else Begin
					imgPin.Picture := imgPinOpen.Picture;
					FollowingCaretinThisWindow := False;
		 End;


End;

End.
