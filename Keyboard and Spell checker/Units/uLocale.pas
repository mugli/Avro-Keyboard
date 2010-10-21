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

Unit uLocale;

Interface
Uses
     Windows,
     SysUtils,
     Messages;

Const
     LANG_EN_US               : String = '00000409';
     LANG_BN_IN               : String = '00000445';
     LANG_BN_BD               : String = '00000845';
     LANG_Assamese            : String = '0000044D';
     INPUTLANGCHANGE_SYSCHARSET: Integer = $1;



Procedure ChangeLocaleToBangla(Const TopWnd: HWND);
Procedure ChangeLocalToAny(Const TargetWin:HWND; FullLocaleMsg: Cardinal);
Function GetForeignLocale(Const TargetWin: HWND): Cardinal;
Procedure InstallLocale;
Function IsBangladeshLocaleInstalled: Boolean;
Function IsAssameseLocaleInstalled: Boolean;



Implementation
Uses
     clsRegistry_XMLSetting,
     uRegistrySettings,
     WindowsVersion;


{$HINTS Off}
{===============================================================================}

Function IsAssameseLocaleInstalled: Boolean;
Var
     Reg                      : TMyRegistry;
Begin
     Result := False;
     Reg := TMyRegistry.create;
     Reg.RootKey := HKEY_LOCAL_MACHINE;

     If Reg.KeyExists('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\0000044D') And
          Reg.KeyExists('SYSTEM\ControlSet001\Control\Keyboard Layouts\0000044D') And
          Reg.KeyExists('SYSTEM\ControlSet002\Control\Keyboard Layouts\0000044D') Then
          Result := True
     Else
          Result := False;

     Reg.Free;
End;
{$HINTS On}

{===============================================================================}

{$HINTS Off}

Function IsBangladeshLocaleInstalled: Boolean;
Var
     Reg                      : TMyRegistry;
Begin
     Result := False;
     Reg := TMyRegistry.create;
     Reg.RootKey := HKEY_LOCAL_MACHINE;

     If Reg.KeyExists('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\00000845') And
          Reg.KeyExists('SYSTEM\ControlSet001\Control\Keyboard Layouts\00000845') And
          Reg.KeyExists('SYSTEM\ControlSet002\Control\Keyboard Layouts\00000845') Then
          Result := True
     Else
          Result := False;

     Reg.Free;
End;
{$HINTS On}

{===============================================================================}

Procedure InstallLocale;
Var
     Reg                      : TMyRegistry;
     LayoutDisplayName        : String;
     LayoutFile               : String;
     LayoutText               : String;
Begin
     Reg := TMyRegistry.create;
     Reg.RootKey := HKEY_LOCAL_MACHINE;

     //====================================================================
     //Install Bangla BD
     If Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\00000845', True) = True Then Begin
          LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla BD');
          LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
          LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla BD');

          REG.WriteString('Layout Display Name', LayoutDisplayName);
          REG.WriteString('Layout File', LayoutFile);
          REG.WriteString('Layout Text', LayoutText);
     End;
     Reg.CloseKey;

     Reg.RootKey := HKEY_LOCAL_MACHINE;
     If Reg.OpenKey('SYSTEM\ControlSet001\Control\Keyboard Layouts\00000845', True) = True Then Begin
          LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla BD');
          LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
          LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla BD');

          REG.WriteString('Layout Display Name', LayoutDisplayName);
          REG.WriteString('Layout File', LayoutFile);
          REG.WriteString('Layout Text', LayoutText);
     End;
     Reg.CloseKey;

     Reg.RootKey := HKEY_LOCAL_MACHINE;
     If Reg.OpenKey('SYSTEM\ControlSet002\Control\Keyboard Layouts\00000845', True) = True Then Begin
          LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla BD');
          LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
          LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla BD');

          REG.WriteString('Layout Display Name', LayoutDisplayName);
          REG.WriteString('Layout File', LayoutFile);
          REG.WriteString('Layout Text', LayoutText);
     End;
     Reg.CloseKey;



     //====================================================================' +
     //Install Assamese
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     If Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\0000044D', True) = True Then Begin
          LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Assamese');
          LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
          LayoutText := Reg.ReadStringDef('Layout Text', 'Assamese');

          REG.WriteString('Layout Display Name', LayoutDisplayName);
          REG.WriteString('Layout File', LayoutFile);
          REG.WriteString('Layout Text', LayoutText);
     End;
     Reg.CloseKey;

     Reg.RootKey := HKEY_LOCAL_MACHINE;
     If Reg.OpenKey('SYSTEM\ControlSet001\Control\Keyboard Layouts\0000044D', True) = True Then Begin
          LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Assamese');
          LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
          LayoutText := Reg.ReadStringDef('Layout Text', 'Assamese');

          REG.WriteString('Layout Display Name', LayoutDisplayName);
          REG.WriteString('Layout File', LayoutFile);
          REG.WriteString('Layout Text', LayoutText);
     End;
     Reg.CloseKey;

     Reg.RootKey := HKEY_LOCAL_MACHINE;
     If Reg.OpenKey('SYSTEM\ControlSet002\Control\Keyboard Layouts\0000044D', True) = True Then Begin
          LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Assamese');
          LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
          LayoutText := Reg.ReadStringDef('Layout Text', 'Assamese');

          REG.WriteString('Layout Display Name', LayoutDisplayName);
          REG.WriteString('Layout File', LayoutFile);
          REG.WriteString('Layout Text', LayoutText);
     End;
     Reg.CloseKey;

     {====================================================================
Install Bangla - India
Present in WinXp Sp2 or later
So, don't install on these platforms}
     If (Not IsWinXPSP2Plus) Or IsWinVistaOrLater Then Begin
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          If Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\00000445', True) = True Then Begin
               LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla IN');
               LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
               LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla IN');

               REG.WriteString('Layout Display Name', LayoutDisplayName);
               REG.WriteString('Layout File', LayoutFile);
               REG.WriteString('Layout Text', LayoutText);
          End;
          Reg.CloseKey;

          Reg.RootKey := HKEY_LOCAL_MACHINE;
          If Reg.OpenKey('SYSTEM\ControlSet001\Control\Keyboard Layouts\00000445', True) = True Then Begin
               LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla IN');
               LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
               LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla IN');

               REG.WriteString('Layout Display Name', LayoutDisplayName);
               REG.WriteString('Layout File', LayoutFile);
               REG.WriteString('Layout Text', LayoutText);
          End;
          Reg.CloseKey;

          Reg.RootKey := HKEY_LOCAL_MACHINE;
          If Reg.OpenKey('SYSTEM\ControlSet002\Control\Keyboard Layouts\00000445', True) = True Then Begin
               LayoutDisplayName := Reg.ReadStringDef('Layout Display Name', 'Bangla IN');
               LayoutFile := Reg.ReadStringDef('Layout File', 'KBDUS.DLL');
               LayoutText := Reg.ReadStringDef('Layout Text', 'Bangla IN');

               REG.WriteString('Layout Display Name', LayoutDisplayName);
               REG.WriteString('Layout File', LayoutFile);
               REG.WriteString('Layout Text', LayoutText);
          End;
          Reg.CloseKey;
     End;


     Reg.Free;
End;

{===============================================================================}

Procedure ChangeLocaleToBangla(Const TopWnd: HWND);
Var
     Local_ID                 : Integer;
     ParentHandle             : HWND;
     BanglaLocale             : String;
Begin

     If PrefferedLocale = 'BANGLADESH' Then
          BanglaLocale := LANG_BN_BD
     Else If PrefferedLocale = 'INDIA' Then
          BanglaLocale := LANG_BN_IN
     Else If PrefferedLocale = 'ASSAMESE' Then
          BanglaLocale := LANG_Assamese
     Else
          BanglaLocale := LANG_BN_IN;

     { DONE :
Extensive test needed here:
Till Vista, KLF_ACTIVATE works ok
From Windows 7, it always makes long delay to change locale.
'KLF_ACTIVATE OR KLF_NOTELLSHELL' failed, too
Possible workaround- using KLF_NOTELLSHELL }
     Local_ID := LoadKeyboardLayout(PChar(BanglaLocale), KLF_NOTELLSHELL);
     PostMessage(TopWnd, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, Local_ID);
     PostMessage(TopWnd, WM_INPUTLANGCHANGE, 0, Local_ID);

     {Request sent. Sometimes this request is not processed if foreground window
     is a child window like message box or file open/save dialog.
     In this case, we have to send the request to parent}

          //Get the parent
     ParentHandle := GetParent(TopWnd);
     If IsWindow(ParentHandle) Then Begin
          PostMessage(ParentHandle, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, Local_ID);
          PostMessage(ParentHandle, WM_INPUTLANGCHANGE, 0, Local_ID);
     End;

     {Keyboard Locale Changed in foreign app, now set my locale to English}
     LoadKeyboardLayout(PChar(LANG_EN_US), KLF_ACTIVATE);
End;

{===============================================================================}

Procedure ChangeLocalToAny(Const TargetWin:HWND; FullLocaleMsg: Cardinal);
Var
     ParentHandle             : HWND;
Begin
     PostMessage(TargetWin, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, FullLocaleMsg);
     PostMessage(TargetWin, WM_INPUTLANGCHANGE, 0, FullLocaleMsg);

     {Request sent. Sometimes this request is not processed if foreground window
     is a child window like message box or file open/save dialog.
     In this case, we have to send the request to parent}

          //Get the parent
     ParentHandle := GetParent(TargetWin);
     If IsWindow(ParentHandle) Then Begin
          PostMessage(ParentHandle, WM_INPUTLANGCHANGEREQUEST, INPUTLANGCHANGE_SYSCHARSET, FullLocaleMsg);
          PostMessage(ParentHandle, WM_INPUTLANGCHANGE, 0, FullLocaleMsg);
     End;
End;

{===============================================================================}

Function GetForeignLocale(Const TargetWin: HWND): Cardinal;
Var
     TID                      : Integer;
Begin
     TID := GetWindowThreadProcessId(TargetWin, Nil);
     Result := GetKeyboardLayout(TID);
End;

{===============================================================================}

End.

