{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit u_Admin;

interface

uses
  Windows,
  Registry;

function IsElevated: Boolean;

// returns True if the currently logged Windows user has Administrator rights
function IsAdmin: Boolean;

function IsUAC: Boolean;

implementation

uses
  WindowsVersion;

const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));

const
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS     = $00000220;

const
  TokenElevationType        = 18;
  TokenElevation            = 20;
  TokenElevationTypeDefault = 1;
  TokenElevationTypeFull    = 2;
  TokenElevationTypeLimited = 3;

function IsUAC: Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System');
  if Reg.ReadInteger('EnableLUA') = 1 then
    Result := True;
  Reg.Free;
end;
{$HINTS Off}

function IsElevated: Boolean;

  function IsElevatedBasic: Boolean;
  var
    token:         THandle;
    ElevationType: Integer;
    // Elevation                : DWord;
    dwSize: Cardinal;
  begin
    Result := False;

    if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, token) then
      try
        if GetTokenInformation(token, TTokenInformationClass(TokenElevationType), @ElevationType, SizeOf(ElevationType), dwSize) then
          { * If already elevated returns TokenElevationTypeFull.

            * If it can be elevated simply by showing the elevation request
            dialog it returns TokenElevationTypeLimited.

            * If running on a non-administrator account that needs to show
            the elevation dialog and enter an admin password,
            it returns TokenElevationTypeDefault. }
          case ElevationType of
            TokenElevationTypeDefault:
              Result := False;
            TokenElevationTypeFull:
              Result := True;
            TokenElevationTypeLimited:
              Result := False;
            else
              Result := False;
          end
        else
          Result := False;

        { If GetTokenInformation(token, TTokenInformationClass(TokenElevation), @Elevation, SizeOf(Elevation), dwSize) Then Begin
          If Elevation = 0 Then
          ShowMessage('token does NOT have elevate privs')
          Else
          ShowMessage('token has elevate privs');
          End
          Else
          Result := False; }
      finally
        CloseHandle(token);
      end
    else
      Result := False;
  end;

begin
  if IsWinVistaOrLater then
  begin
    if IsUAC then
    begin
      if IsElevatedBasic then
        Result := True
      else
        Result := False;
    end
    else
    begin
      if IsAdmin then
        Result := True
      else
        Result := False;
    end;
  end
  else
  begin
    if IsAdmin then
      Result := True
    else
      Result := False;
  end;
end;
{$HINTS On}

function IsAdmin: Boolean;
var
  hAccessToken:       THandle;
  ptgGroups:          PTokenGroups;
  dwInfoBufferSize:   DWORD;
  psidAdministrators: PSID;
  g:                  Integer;
  bSuccess:           BOOL;
begin
  Result := False;

  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken);
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken);
  end;

  if bSuccess then
  begin
    GetMem(ptgGroups, 1024);

    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, 1024, dwInfoBufferSize);

    CloseHandle(hAccessToken);

    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdministrators);

      for g := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[g].Sid) then
        begin
          Result := True;
          Break;
        end;

      FreeSid(psidAdministrators);
    end;

    FreeMem(ptgGroups);
  end;
end;

end.
