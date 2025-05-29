{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../../ProjectDefines.inc}
{ COMPLETE! }

unit uWindowHandlers;

interface

uses
  Windows,
  Sysutils,
  Controls,
  Messages,
  Forms,
  Classes;

procedure TOPMOST(const xFormHwnd: HWND);
procedure NoTOPMOST(const xFormHwnd: HWND);
procedure MoveForm_Ex(const xFormHwnd: HWND; const Button: TMouseButton);
function IsFormLoaded(const xFormName: string): Boolean;
function IsFormVisible(const xFormName: string): Boolean;
procedure DisableCloseButton(const xFormHwnd: HWND);
function ForceForegroundWindow(HWND: THandle): Boolean;
procedure MakeNeverActiveWindow(const xFormHwnd: HWND);
function IsWindowTopMost(hWindow: HWND): Boolean;
procedure SetAsMainForm(aForm: TForm);
function GetWindowCaption(hWindow: HWND): string;
function GetWindowClassName(hWindow: HWND): string;
procedure SetElevationRequiredState(aControl: TWinControl; Required: Boolean);
/// //////////////////////////////////////////////
// Delphi specific
procedure CheckCreateForm(InstanceClass: TComponentClass; var xForm; const xFormName: string);

const
  BCM_FIRST     = $1600;
  BCM_SETSHIELD = BCM_FIRST + $000C;

implementation

{ =============================================================================== }

procedure SetElevationRequiredState(aControl: TWinControl; Required: Boolean);
var
  lRequired: Integer;

begin

  lRequired := Integer(Required);
  SendMessage(aControl.Handle, BCM_SETSHIELD, 0, lRequired);

end;

{ =============================================================================== }

function GetWindowClassName(hWindow: HWND): string;
var
  aName: array [0 .. 255] of Char;
begin
  GetClassName(hWindow, aName, 256);
  Result := string(aName);
end;

{ =============================================================================== }

function GetWindowCaption(hWindow: HWND): string;
var
  Len:   LongInt;
  Title: string;
begin
  Result := '';
  Len := GetWindowTextLength(hWindow) + 1;
  SetLength(Title, Len);
  GetWindowText(hWindow, PChar(Title), Len);
  Result := TrimRight(Title);
end;

{ =============================================================================== }

procedure SetAsMainForm(aForm: TForm);
var
  P: Pointer;
begin
  P := @Application.Mainform;
  Pointer(P^) := aForm;
end;

{ =============================================================================== }

procedure MakeNeverActiveWindow(const xFormHwnd: HWND);
begin
  SetWindowLong(xFormHwnd, GWL_EXSTYLE, GetWindowLong(xFormHwnd, GWL_EXSTYLE) or WS_EX_NOACTIVATE);
end;

{ =============================================================================== }
{$HINTS Off}

function ForceForegroundWindow(HWND: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID:       DWORD;
  timeout:            DWORD;
begin
  Result := False;

  // If IsIconic(hwnd) Then ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = HWND then
    Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and (Win32MinorVersion > 0)))) then
    begin

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadProcessID(HWND, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(HWND); // IE 5.5 related hack
        SetForegroundWindow(HWND);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = HWND);
      end;
      if not Result then
      begin
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
        BringWindowToTop(HWND); // IE 5.5 related hack
        SetForegroundWindow(HWND);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(HWND); // IE 5.5 related hack
      SetForegroundWindow(HWND);
    end;

    Result := (GetForegroundWindow = HWND);
  end;
end;
{$HINTS On}
{ =============================================================================== }
{$HINTS Off}

function IsWindowTopMost(hWindow: HWND): Boolean;
begin
  Result := False;
  Result := (GetWindowLong(hWindow, GWL_EXSTYLE) and WS_EX_TOPMOST) <> 0
end;
{$HINTS On}
{ =============================================================================== }

procedure DisableCloseButton(const xFormHwnd: HWND);
begin
  RemoveMenu(GetSystemMenu(xFormHwnd, False), SC_CLOSE, MF_BYCOMMAND);
end;

{ =============================================================================== }

procedure TOPMOST(const xFormHwnd: HWND);
begin
  SetWindowPos(xFormHwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

{ =============================================================================== }

procedure NoTOPMOST(const xFormHwnd: HWND);
begin
  SetWindowPos(xFormHwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

{ =============================================================================== }

procedure MoveForm_Ex(const xFormHwnd: HWND; const Button: TMouseButton);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(xFormHwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

{ =============================================================================== }

function IsFormLoaded(const xFormName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Screen.FormCount - 1 downto 0 do
    if (LowerCase(Screen.Forms[i].Name) = LowerCase(xFormName)) then
    begin
      Result := True;
      Break;
    end;
end;

{ =============================================================================== }

function IsFormVisible(const xFormName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Screen.FormCount - 1 downto 0 do
    if (LowerCase(Screen.Forms[i].Name) = LowerCase(xFormName)) then
    begin
      if Screen.Forms[i].Visible = True then
        Result := True;
      Break;
    end;
end;

{ =============================================================================== }

procedure CheckCreateForm(InstanceClass: TComponentClass; var xForm; const xFormName: string);
begin
  if not IsFormLoaded(xFormName) then
  begin
    Application.CreateForm(InstanceClass, xForm);

    // In order to keep Avro keaboard hidden
    // in taskbar
    ShowWindow(Application.Handle, SW_HIDE);
  end;
end;

end.
