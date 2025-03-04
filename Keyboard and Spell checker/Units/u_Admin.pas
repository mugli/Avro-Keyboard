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
{ COMPLETE TRANSFERING! }

Unit u_Admin;

Interface

Uses Windows,
  Registry;

Function IsElevated: Boolean;

// returns True if the currently logged Windows user has Administrator rights
Function IsAdmin: Boolean;

Function IsUAC: Boolean;

Implementation

Uses
  WindowsVersion;

Const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));

Const
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;

Const
  TokenElevationType = 18;
  TokenElevation = 20;
  TokenElevationTypeDefault = 1;
  TokenElevationTypeFull = 2;
  TokenElevationTypeLimited = 3;

Function IsUAC: Boolean;
Var
  Reg: TRegistry;
Begin
  Result := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKeyReadOnly
    ('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System');
  If Reg.ReadInteger('EnableLUA') = 1 Then
    Result := True;
  Reg.Free;
End;
{$HINTS Off}

Function IsElevated: Boolean;

  Function IsElevatedBasic: Boolean;
  Var
    token: Cardinal;
    ElevationType: Integer;
    // Elevation                : DWord;
    dwSize: Cardinal;
  Begin
    Result := False;

    If OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, token) Then
      Try
        If GetTokenInformation(token,
          TTokenInformationClass(TokenElevationType), @ElevationType,
          SizeOf(ElevationType), dwSize) Then
          { * If already elevated returns TokenElevationTypeFull.

            * If it can be elevated simply by showing the elevation request
            dialog it returns TokenElevationTypeLimited.

            * If running on a non-administrator account that needs to show
            the elevation dialog and enter an admin password,
            it returns TokenElevationTypeDefault. }
          Case ElevationType Of
            TokenElevationTypeDefault:
              Result := False;
            TokenElevationTypeFull:
              Result := True;
            TokenElevationTypeLimited:
              Result := False;
          Else
            Result := False;
          End
        Else
          Result := False;

        { If GetTokenInformation(token, TTokenInformationClass(TokenElevation), @Elevation, SizeOf(Elevation), dwSize) Then Begin
          If Elevation = 0 Then
          ShowMessage('token does NOT have elevate privs')
          Else
          ShowMessage('token has elevate privs');
          End
          Else
          Result := False; }
      Finally
        CloseHandle(token);
      End
    Else
      Result := False;
  End;

Begin
  If IsWinVistaOrLater Then
  Begin
    If IsUAC Then
    Begin
      If IsElevatedBasic Then
        Result := True
      Else
        Result := False;
    End
    Else
    Begin
      If IsAdmin Then
        Result := True
      Else
        Result := False;
    End;
  End
  Else
  Begin
    If IsAdmin Then
      Result := True
    Else
      Result := False;
  End;
End;
{$HINTS On}

Function IsAdmin: Boolean;
Var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  g: Integer;
  bSuccess: BOOL;
Begin
  Result := False;

  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  If Not bSuccess Then
  Begin
    If GetLastError = ERROR_NO_TOKEN Then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
        hAccessToken);
  End;

  If bSuccess Then
  Begin
    GetMem(ptgGroups, 1024);

    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, 1024,
      dwInfoBufferSize);

    CloseHandle(hAccessToken);

    If bSuccess Then
    Begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0,
        psidAdministrators);

      For g := 0 To ptgGroups.GroupCount - 1 Do
        If EqualSid(psidAdministrators, ptgGroups.Groups[g].Sid) Then
        Begin
          Result := True;
          Break;
        End;

      FreeSid(psidAdministrators);
    End;

    FreeMem(ptgGroups);
  End;
End;

End.
