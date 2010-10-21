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

{COMPLETE TRANSFERING!}

Unit clsLayout;

Interface

Uses
     classes,
     sysutils,
     StrUtils,
     clsAvroPhonetic,
     clsGenericLayoutModern,
     clsGenericLayoutOld,
     Forms,
     Windows;


//--------------------------------------------------------------
//Enumarated types
Type
     enumMode = (SysDefault, Bangla);



Type
     //Event types
     //--------------------------------------------------------------
     TKeyboardModeChanged = Procedure(CurrentMode: enumMode) Of Object;
     TWordTrackingLost = Procedure Of Object; //Special for Avro phonetic
     TKeyboardLayoutChanged = Procedure(CurrentKeyboardLayout: String) Of Object;
     THookSet = Procedure Of Object;
     THookSettingFailed = Procedure Of Object;
     //--------------------------------------------------------------


Type
     //Skeleton of TLayout class
     //--------------------------------------------------------------
     TLayout = Class
     Private
          AvroPhonetic: TAvroPhonetic;
          GenericModernFixed: TGenericLayoutModern;
          GenericOldFixed: TGenericLayoutOld;

          k_Layout: String;
          k_Mode: enumMode;

          //--------------------------------------------------------------
          //Event types
          FKeyboardModeChanged: TKeyboardModeChanged;
          FWordTrackingLost: TWordTrackingLost;
          FKeyboardLayoutChanged: TKeyboardLayoutChanged;
          FHookSet: THookSet;
          FHookSettingFailed: THookSettingFailed;
          //--------------------------------------------------------------


          Procedure SetAutoCorrectEnabled(Const Value: Boolean);
          Function GetAutoCorrectEnabled: Boolean;
          Procedure SetCurrentKeyboardLayout(Value: String);
          Function GetCurrentKeyboardLayout: String;
          Procedure SetKeyboardMode(Const Value: enumMode);
          Function GetKeyboardMode: enumMode;
     Public
          Constructor Create;           //Initializer
          Destructor Destroy; Override; //Destructor

          Function ProcessVKeyDown(Const KeyCode: Integer; Var Block: Boolean): String;
          Procedure ProcessVKeyUP(Const KeyCode: Integer; Var Block: Boolean);
          Procedure ResetDeadKey;
          Procedure ToggleMode;
          Procedure BanglaMode;
          Procedure SysMode;
          Procedure SelectCandidate(Const Item: String); //For Phonetic

          //Published
              //--------------------------------------------------------------
             // event properties
          Property OnKeyboardModeChanged: TKeyboardModeChanged
               Read FKeyboardModeChanged Write FKeyboardModeChanged;
          Property OnWordTrackingLost: TWordTrackingLost
               Read FWordTrackingLost Write FWordTrackingLost;
          Property OnKeyboardLayoutChanged: TKeyboardLayoutChanged
               Read FKeyboardLayoutChanged Write FKeyboardLayoutChanged;
          Property OnHookSet: THookSet
               Read FHookSet Write FHookSet;
          Property OnHookSettingFailed: THookSettingFailed
               Read FHookSettingFailed Write FHookSettingFailed;
          //--------------------------------------------------------------


          Property AutoCorrectEnabled: Boolean
               Read GetAutoCorrectEnabled Write SetAutoCorrectEnabled;
          Property CurrentKeyboardLayout: String
               Read GetCurrentKeyboardLayout Write SetCurrentKeyboardLayout;
          Property KeyboardMode: enumMode
               Read GetKeyboardMode Write SetKeyboardMode;


     End;


Implementation

Uses
     KeyboardHook,
     KeyboardLayoutLoader,
     uRegistrySettings;

{ TLayout }

{===============================================================================}

Procedure TLayout.BanglaMode;
Begin
     Self.KeyboardMode := bangla;
End;

{===============================================================================}

Constructor TLayout.Create;
Var
     RetVal                   : Integer;
Begin
     Inherited;
     RetVal := Sethook;

     If RetVal > 0 Then Begin
          If Assigned(FHookSet) Then FHookSet;
     End
     Else Begin
          If Assigned(FHookSettingFailed) Then FHookSettingFailed;
     End;

     AvroPhonetic := TAvroPhonetic.Create;
     GenericModernFixed := TGenericLayoutModern.Create;
     GenericOldFixed := TGenericLayoutOld.Create;

     Self.KeyboardMode := SysDefault;
     k_Layout := 'avrophonetic*';
End;

{===============================================================================}

Destructor TLayout.Destroy;
Begin

     Removehook;

     FreeAndNil(AvroPhonetic);
     FreeAndNil(GenericModernFixed);
     FreeAndNil(GenericOldFixed);
     Inherited;
End;

{===============================================================================}

Function TLayout.GetAutoCorrectEnabled: Boolean;
Begin
     Result := AvroPhonetic.AutoCorrectEnabled;
End;

{===============================================================================}

Function TLayout.GetCurrentKeyboardLayout: String;
Begin
     Result := k_Layout;
End;

{===============================================================================}

Function TLayout.GetKeyboardMode: enumMode;
Begin
     Result := k_Mode;
End;

{===============================================================================}

Function TLayout.ProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean): String;
Begin
     If Lowercase(k_Layout) = 'avrophonetic*' Then
          ProcessVKeyDown := AvroPhonetic.ProcessVKeyDown(KeyCode, Block)
     Else Begin
          If FullOldStyleTyping <> 'YES' Then
               ProcessVKeyDown := GenericModernFixed.ProcessVKeyDown(KeyCode, Block)
          Else
               ProcessVKeyDown := GenericOldFixed.ProcessVKeyDown(KeyCode, Block);
     End;
End;

{===============================================================================}

Procedure TLayout.ProcessVKeyUP(Const KeyCode: Integer; Var Block: Boolean);
Begin
     If Lowercase(k_Layout) = 'avrophonetic*' Then
          AvroPhonetic.ProcessVKeyUP(KeyCode, Block)
     Else Begin
          If FullOldStyleTyping <> 'YES' Then
               GenericModernFixed.ProcessVKeyUP(KeyCode, Block)
          Else
               GenericOldFixed.ProcessVKeyUP(KeyCode, Block);
     End;
End;

{===============================================================================}

Procedure TLayout.ResetDeadKey;
Begin
     AvroPhonetic.ResetDeadKey;
     GenericModernFixed.ResetDeadKey;
     GenericOldFixed.ResetDeadKey;
End;

{===============================================================================}

Procedure TLayout.SelectCandidate(Const Item: String);
Begin
     AvroPhonetic.SelectCandidate(Item);
End;

Procedure TLayout.SetAutoCorrectEnabled(Const Value: Boolean);
Begin
     AvroPhonetic.AutoCorrectEnabled := Value;
End;

{===============================================================================}

Procedure TLayout.SetCurrentKeyboardLayout(Value: String);
Var
     RetVal                   : Integer;
Begin
     Removehook;

     If Lowercase(Value) <> 'avrophonetic*' Then Begin
          If Init_KeyboardLayout(Value) = False Then Begin
               Application.MessageBox(PChar('Error Loading ' + Value + ' keyboard layout!' + #10 + '' + #10 + 'Layout switched back to Avro Phonetic.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
               Value := 'AvroPhonetic*';
          End;
     End;

     ResetDeadKey;
     k_Layout := Value;

     If Assigned(FKeyboardLayoutChanged) Then FKeyboardLayoutChanged(k_Layout);


     RetVal := Sethook;

     If RetVal > 0 Then Begin
          If Assigned(FHookSet) Then FHookSet;
     End
     Else Begin
          If Assigned(FHookSettingFailed) Then FHookSettingFailed;
     End;
End;

{===============================================================================}

Procedure TLayout.SetKeyboardMode(Const Value: enumMode);
Begin
     k_Mode := Value;
     If Assigned(FKeyboardModeChanged) Then FKeyboardModeChanged(k_Mode);
     ResetDeadKey;
End;

{===============================================================================}

Procedure TLayout.SysMode;
Begin
     Self.KeyboardMode := SysDefault;
End;

{===============================================================================}

Procedure TLayout.ToggleMode;
Begin
     If Self.KeyboardMode = SysDefault Then
          Self.KeyboardMode := bangla
     Else
          Self.KeyboardMode := SysDefault;
End;

{===============================================================================}

End.

