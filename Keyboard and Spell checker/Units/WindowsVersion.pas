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


{$INCLUDE ../../ProjectDefines.inc}

{ COMPLETE TRANSFERING }

Unit WindowsVersion;

Interface

Uses
  Windows,
  Sysutils;

Function GetOSVersionInfo(Var Info: TOSVersionInfoEx): Boolean;

Function IsWin2000: Boolean;
Function IsWin2000Plus: Boolean;
Function IsWin2000OrLater: Boolean;
Function IsWin2003Server: Boolean;
Function IsWinNT4: Boolean;
Function IsWinNT4OrLater: Boolean;
Function IsWinVista: Boolean;
Function IsWinVistaOrLater: Boolean;
Function IsWinXP: Boolean;
Function IsWinXPSP2: Boolean;
Function IsWinXPSP2Plus: Boolean;
Function IsWinXPSP3Plus: Boolean;

Implementation

{$HINTS Off}

Function GetOSVersionInfo(Var Info: TOSVersionInfoEx): Boolean;
Begin
  Result := False;
  FillChar(Info, SizeOf(TOSVersionInfoEx), 0);
  Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
  If (Not Result) Then
  Begin
    FillChar(Info, SizeOf(TOSVersionInfoEx), 0);
    Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
    Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
    If (Not Result) Then
      Info.dwOSVersionInfoSize := 0;
  End;
End;

Function IsWin2000: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      ((osv.dwMajorVersion = 5) And (osv.dwMinorVersion = 0)) And
      (osv.dwBuildNumber >= 2195);
  End
  Else
    Result := False;
End;

Function IsWin2000OrLater: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      (osv.dwMajorVersion >= 5);
  End
  Else
    Result := False;
End;

Function IsWin2000Plus: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      (osv.dwMajorVersion = 5);
  End
  Else
    Result := False;

End;

Function IsWin2003Server: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      ((osv.dwMajorVersion = 5) And (osv.dwMinorVersion = 2)) And
      (osv.dwBuildNumber = 3790);
  End
  Else
    Result := False;

End;

Function IsWinNT4: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      ((osv.dwMajorVersion = 4) And (osv.dwMinorVersion = 0)) And
      (osv.dwBuildNumber >= 1381);
  End
  Else
    Result := False;
End;

Function IsWinNT4OrLater: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      (osv.dwMajorVersion >= 4);
  End
  Else
    Result := False;

End;

Function IsWinVista: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);

  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      (osv.dwMajorVersion = 6);
  End
  Else
    Result := False;

End;

Function IsWinVistaOrLater: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      (osv.dwMajorVersion >= 6);
  End
  Else
    Result := False;

End;

Function IsWinXP: Boolean;
Var
  osv: TOSVersionInfo;
Begin
  Result := False;
  osv.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  If GetVersionEx(osv) Then
  Begin
    Result := (osv.dwPlatformID = VER_PLATFORM_WIN32_NT) And
      ((osv.dwMajorVersion = 5) And (osv.dwMinorVersion = 1)) And
      (osv.dwBuildNumber >= 2600);
  End
  Else
    Result := False;
End;

Function IsWinXPSP2: Boolean;
Var
  osv: TOSVersionInfoEx;
Begin

  Result := False;
  If IsWinXP Then
  Begin
    If GetOSVersionInfo(osv) Then
    Begin
      If pos(osv.szCSDVersion, 'Service Pack 2') > 0 Then
        Result := True;
    End;
  End;
End;

Function IsWinXPSP2Plus: Boolean;
Var
  osv: TOSVersionInfoEx;
Begin

  Result := False;
  If IsWinXP Then
  Begin
    If GetOSVersionInfo(osv) Then
    Begin
      If pos(osv.szCSDVersion, 'Service Pack 2') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, ('Service Pack 3')) > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 4') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 5') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 6') > 0 Then
        Result := True;
    End;
  End;
End;

Function IsWinXPSP3Plus: Boolean;
Var
  osv: TOSVersionInfoEx;
Begin

  Result := False;
  If IsWinXP Then
  Begin
    If GetOSVersionInfo(osv) Then
    Begin
      If pos(osv.szCSDVersion, 'Service Pack 3') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 4') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 5') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 6') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 7') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 8') > 0 Then
        Result := True
      Else If pos(osv.szCSDVersion, 'Service Pack 9') > 0 Then
        Result := True;
    End;
  End;
End;
{$HINTS On}

End.
