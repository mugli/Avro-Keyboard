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


{$INCLUDE ../../ProjectDefines.inc}

{ COMPLETE! }

Unit uWindowHandlers;

Interface

Uses
  Windows,
  Sysutils,
  Controls,
  Messages,
  Forms,
  Classes;

Procedure TOPMOST(Const xFormHwnd: HWND);
Procedure NoTOPMOST(Const xFormHwnd: HWND);
Procedure MoveForm_Ex(Const xFormHwnd: HWND; Const Button: TMouseButton);
Function IsFormLoaded(Const xFormName: String): Boolean;
Function IsFormVisible(Const xFormName: String): Boolean;
Procedure DisableCloseButton(Const xFormHwnd: HWND);
Function ForceForegroundWindow(HWND: THandle): Boolean;
Procedure MakeNeverActiveWindow(Const xFormHwnd: HWND);
Function IsWindowTopMost(hWindow: HWND): Boolean;
Procedure SetAsMainForm(aForm: TForm);
Function GetWindowCaption(hWindow: HWND): String;
Function GetWindowClassName(hWindow: HWND): String;
Procedure SetElevationRequiredState(aControl: TWinControl; Required: Boolean);
/// //////////////////////////////////////////////
// Delphi specific
Procedure CheckCreateForm(InstanceClass: TComponentClass; Var xForm;
  Const xFormName: String);

Const
  BCM_FIRST = $1600;
  BCM_SETSHIELD = BCM_FIRST + $000C;

Implementation

{ =============================================================================== }

Procedure SetElevationRequiredState(aControl: TWinControl; Required: Boolean);
Var
  lRequired: Integer;

Begin

  lRequired := Integer(Required);
  SendMessage(aControl.Handle, BCM_SETSHIELD, 0, lRequired);

End;

{ =============================================================================== }

Function GetWindowClassName(hWindow: HWND): String;
Var
  aName: Array [0 .. 255] Of Char;
Begin
  GetClassName(hWindow, aName, 256);
  Result := String(aName);
End;

{ =============================================================================== }

Function GetWindowCaption(hWindow: HWND): String;
Var
  Len: LongInt;
  Title: String;
Begin
  Result := '';
  Len := GetWindowTextLength(hWindow) + 1;
  SetLength(Title, Len);
  GetWindowText(hWindow, PChar(Title), Len);
  Result := TrimRight(Title);
End;

{ =============================================================================== }

Procedure SetAsMainForm(aForm: TForm);
Var
  P: Pointer;
Begin
  P := @Application.Mainform;
  Pointer(P^) := aForm;
End;

{ =============================================================================== }

Procedure MakeNeverActiveWindow(Const xFormHwnd: HWND);
Begin
  SetWindowLong(xFormHwnd, GWL_EXSTYLE, GetWindowLong(xFormHwnd, GWL_EXSTYLE) Or
    WS_EX_NOACTIVATE);
End;

{ =============================================================================== }
{$HINTS Off}

Function ForceForegroundWindow(HWND: THandle): Boolean;
Const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
Var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
Begin
  Result := False;

  // If IsIconic(hwnd) Then ShowWindow(hwnd, SW_RESTORE);

  If GetForegroundWindow = HWND Then
    Result := True
  Else
  Begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    If ((Win32Platform = VER_PLATFORM_WIN32_NT) And (Win32MajorVersion > 4)) Or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) And
      ((Win32MajorVersion > 4) Or ((Win32MajorVersion = 4) And
      (Win32MinorVersion > 0)))) Then
    Begin

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, Nil);
      ThisThreadID := GetWindowThreadProcessID(HWND, Nil);
      If AttachThreadInput(ThisThreadID, ForegroundThreadID, True) Then
      Begin
        BringWindowToTop(HWND); // IE 5.5 related hack
        SetForegroundWindow(HWND);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = HWND);
      End;
      If Not Result Then
      Begin
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(HWND); // IE 5.5 related hack
        SetForegroundWindow(HWND);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout),
          SPIF_SENDCHANGE);
      End;
    End
    Else
    Begin
      BringWindowToTop(HWND); // IE 5.5 related hack
      SetForegroundWindow(HWND);
    End;

    Result := (GetForegroundWindow = HWND);
  End;
End;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

Function IsWindowTopMost(hWindow: HWND): Boolean;
Begin
  Result := False;
  Result := (GetWindowLong(hWindow, GWL_EXSTYLE) And WS_EX_TOPMOST) <> 0
End;
{$HINTS On}
{ =============================================================================== }

Procedure DisableCloseButton(Const xFormHwnd: HWND);
Begin
  RemoveMenu(GetSystemMenu(xFormHwnd, False), SC_CLOSE, MF_BYCOMMAND);
End;

{ =============================================================================== }

Procedure TOPMOST(Const xFormHwnd: HWND);
Begin
  SetWindowPos(xFormHwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or
    SWP_NOACTIVATE);
End;

{ =============================================================================== }

Procedure NoTOPMOST(Const xFormHwnd: HWND);
Begin
  SetWindowPos(xFormHwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or
    SWP_NOSIZE Or SWP_NOACTIVATE);
End;

{ =============================================================================== }

Procedure MoveForm_Ex(Const xFormHwnd: HWND; Const Button: TMouseButton);
Begin
  If Button = mbLeft Then
  Begin
    ReleaseCapture;
    SendMessage(xFormHwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  End;
End;

{ =============================================================================== }

Function IsFormLoaded(Const xFormName: String): Boolean;
Var
  i: Integer;
Begin
  Result := False;
  For i := Screen.FormCount - 1 Downto 0 Do
    If (LowerCase(Screen.Forms[i].Name) = LowerCase(xFormName)) Then
    Begin
      Result := True;
      Break;
    End;
End;

{ =============================================================================== }

Function IsFormVisible(Const xFormName: String): Boolean;
Var
  i: Integer;
Begin
  Result := False;
  For i := Screen.FormCount - 1 Downto 0 Do
    If (LowerCase(Screen.Forms[i].Name) = LowerCase(xFormName)) Then
    Begin
      If Screen.Forms[i].Visible = True Then
        Result := True;
      Break;
    End;
End;

{ =============================================================================== }

Procedure CheckCreateForm(InstanceClass: TComponentClass; Var xForm;
  Const xFormName: String);
Begin
  If Not IsFormLoaded(xFormName) Then
  Begin
    Application.CreateForm(InstanceClass, xForm);

    // In order to keep Avro keaboard hidden
    // in taskbar
    ShowWindow(Application.Handle, SW_HIDE);
  End;
End;

End.
