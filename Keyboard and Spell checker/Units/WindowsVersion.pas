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
{ COMPLETE TRANSFERING }

unit WindowsVersion;

interface

uses
  Windows,
  Sysutils;

function GetOSVersionInfo(var Info: TOSVersionInfoEx): Boolean;

function IsWin2000: Boolean;
function IsWin2000Plus: Boolean;
function IsWin2000OrLater: Boolean;
function IsWin2003Server: Boolean;
function IsWinNT4: Boolean;
function IsWinNT4OrLater: Boolean;
function IsWinVista: Boolean;
function IsWinVistaOrLater: Boolean;
function IsWinXP: Boolean;
function IsWinXPSP2: Boolean;
function IsWinXPSP2Plus: Boolean;
function IsWinXPSP3Plus: Boolean;

implementation

{$HINTS Off}

function GetOSVersionInfo(var Info: TOSVersionInfoEx): Boolean;
begin
  Result := False;
  FillChar(Info, SizeOf(TOSVersionInfoEx), 0);
  Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
  if (not Result) then
  begin
    FillChar(Info, SizeOf(TOSVersionInfoEx), 0);
    Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
    Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
    if (not Result) then
      Info.dwOSVersionInfoSize := 0;
  end;
end;

function IsWin2000: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and ((osv.dwMajorVersion = 5) and (osv.dwMinorVersion = 0)) and (osv.dwBuildNumber >= 2195);
  end
  else
    Result := False;
end;

function IsWin2000OrLater: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and (osv.dwMajorVersion >= 5);
  end
  else
    Result := False;
end;

function IsWin2000Plus: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and (osv.dwMajorVersion = 5);
  end
  else
    Result := False;

end;

function IsWin2003Server: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and ((osv.dwMajorVersion = 5) and (osv.dwMinorVersion = 2)) and (osv.dwBuildNumber = 3790);
  end
  else
    Result := False;

end;

function IsWinNT4: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and ((osv.dwMajorVersion = 4) and (osv.dwMinorVersion = 0)) and (osv.dwBuildNumber >= 1381);
  end
  else
    Result := False;
end;

function IsWinNT4OrLater: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and (osv.dwMajorVersion >= 4);
  end
  else
    Result := False;

end;

function IsWinVista: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and (osv.dwMajorVersion = 6);
  end
  else
    Result := False;

end;

function IsWinVistaOrLater: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and (osv.dwMajorVersion >= 6);
  end
  else
    Result := False;

end;

function IsWinXP: Boolean;
var
  osv: TOSVersionInfo;
begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osv) then
  begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) and ((osv.dwMajorVersion = 5) and (osv.dwMinorVersion = 1)) and (osv.dwBuildNumber >= 2600);
  end
  else
    Result := False;
end;

function IsWinXPSP2: Boolean;
var
  osv: TOSVersionInfoEx;
begin

  Result := False;
  if IsWinXP then
  begin
    if GetOSVersionInfo(osv) then
    begin
      if pos(osv.szCSDVersion, 'Service Pack 2') > 0 then
        Result := True;
    end;
  end;
end;

function IsWinXPSP2Plus: Boolean;
var
  osv: TOSVersionInfoEx;
begin

  Result := False;
  if IsWinXP then
  begin
    if GetOSVersionInfo(osv) then
    begin
      if pos(osv.szCSDVersion, 'Service Pack 2') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, ('Service Pack 3')) > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 4') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 5') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 6') > 0 then
        Result := True;
    end;
  end;
end;

function IsWinXPSP3Plus: Boolean;
var
  osv: TOSVersionInfoEx;
begin

  Result := False;
  if IsWinXP then
  begin
    if GetOSVersionInfo(osv) then
    begin
      if pos(osv.szCSDVersion, 'Service Pack 3') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 4') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 5') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 6') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 7') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 8') > 0 then
        Result := True
      else if pos(osv.szCSDVersion, 'Service Pack 9') > 0 then
        Result := True;
    end;
  end;
end;
{$HINTS On}

end.
