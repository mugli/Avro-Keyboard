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

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

Unit clsGenericLayoutModern;

Interface

Uses
  classes,
  sysutils,
  StrUtils,
  clsUnicodeToBijoy2000;

Const
  TrackL = 100;

  // Skeleton of Class TGenericLayoutModern
Type
  TGenericLayoutModern = Class
  Private
    Bijoy: TUnicodeToBijoy2000;
    LastChar: String;
    DeadKey: Boolean;
    DeadKeyChars: String;
    DetermineZWNJ_ZWJ: String;
    LastChars: Array [1 .. TrackL] Of String;
    PrevBanglaT, NewBanglaText: String;

    Procedure InternalBackspace(KeyRepeat: Integer = 1);
    Procedure DoBackspace(Var Block: Boolean);
    Procedure ParseAndSendNow;
    Function InsertKar(Const sKar: String): String;
    Function InsertReph: String;
    Procedure DeleteLastCharSteps_Ex(StepCount: Integer);
    Procedure SetLastChar(Const wChar: String);
    Procedure ResetLastChar;
    Function MyProcessVKeyDown(Const KeyCode: Integer; Var Block: Boolean;
      Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): String;
    Procedure MyProcessVKeyUP(Const KeyCode: Integer; Var Block: Boolean;
      Const var_IfShift: Boolean; Const var_IfTrueShift: Boolean;
      Const var_IfAltGr: Boolean);

    Function IsDeadKeyChar(Const CheckS: String): Boolean;

  Public
    Constructor Create; // Initializer
    Destructor Destroy; Override; // Destructor

    Function ProcessVKeyDown(Const KeyCode: Integer;
      Var Block: Boolean): String;
    Procedure ProcessVKeyUP(Const KeyCode: Integer; Var Block: Boolean);
    Procedure ResetDeadKey;
  End;

Implementation

Uses
  uRegistrySettings,
  Banglachars,
  KeyboardFunctions,
  uForm1,
  KeyboardLayoutLoader,
  clsLayout,
  VirtualKeycode,
  WindowsVersion;

{ =============================================================================== }

{ TGenericLayoutModern }

Constructor TGenericLayoutModern.Create;
Begin
  Inherited;
  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
  // Initialize DeadKeyChar Variable
  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
  // Standards Symbols

  DeadKeyChars := '`~!@#$%^+*-_=+\|"/;:,./?><()[]{}' + #39;

  // English Numbers + Letters
  DeadKeyChars := DeadKeyChars +
    '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

  // Bangla Numbers
  DeadKeyChars := DeadKeyChars + b_0 + b_1 + b_2 + b_3 + b_4 + b_5 + b_6 + b_7 +
    b_8 + b_9;

  // Bangla Vowels + Kars
  DeadKeyChars := DeadKeyChars + b_A + b_AA + b_AAkar + b_I + b_II + b_IIkar +
    b_Ikar + b_U + b_Ukar + b_UU + b_UUkar + b_RRI + b_RRIkar + b_E + b_Ekar +
    b_O + b_OI + b_OIkar + b_Okar + b_OU + b_OUkar;

  // Bangla Unusual Vowels + Kars
  DeadKeyChars := DeadKeyChars + b_Vocalic_L + b_Vocalic_LL + b_Vocalic_RR +
    b_Vocalic_RR_Kar + b_Vocalic_L_Kar + b_Vocalic_LL_Kar;

  // Bangla Symbols/Signs
  DeadKeyChars := DeadKeyChars + b_Anushar + b_Bisharga + b_Khandatta +
    b_Dari + b_Taka;

  // Bangla Unusal Symbols/Signs
  DeadKeyChars := DeadKeyChars + b_LengthMark + b_RupeeMark +
    b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 +
    b_CurrencyNumerator4 + b_CurrencyNumerator1LessThanDenominator +
    b_CurrencyDenominator16;

  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
  // End Initialize DeadKeyChar Variable
  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

  ResetLastChar;

  // If IsWinVistaOrLater Then
  DetermineZWNJ_ZWJ := ZWJ;
  // Else
  // DetermineZWNJ_ZWJ := ZWNJ;

  Bijoy := TUnicodeToBijoy2000.Create;
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.DeleteLastCharSteps_Ex(StepCount: Integer);
Var
  I, J: Integer;
  t1: String;
Begin

  For I := TrackL Downto 1 Do
    t1 := t1 + LastChars[I];

  If StepCount > TrackL Then
    StepCount := TrackL;

  t1 := StringOfChar(' ', StepCount) + LeftStr(t1, Length(t1) - StepCount);

  For I := TrackL Downto 1 Do
  Begin
    J := TrackL + 1 - I;
    LastChars[I] := MidStr(t1, J, 1);
  End;
  LastChar := LastChars[1];
End;

{ =============================================================================== }

Destructor TGenericLayoutModern.Destroy;
Begin
  FreeAndNil(Bijoy);

  Inherited;
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.DoBackspace(Var Block: Boolean);
Var
  BijoyNewBanglaText: String;
Begin

  If (Length(PrevBanglaT) - 1) <= 0 Then
  Begin

    If OutputIsBijoy <> 'YES' Then
    Begin
      If (Length(NewBanglaText) - 1) >= 1 Then
        Backspace(Length(NewBanglaText) - 1);
    End
    Else
    Begin
      BijoyNewBanglaText := Bijoy.Convert(NewBanglaText);
      If (Length(BijoyNewBanglaText) - 1) >= 1 Then
        Backspace(Length(BijoyNewBanglaText) - 1);
    End;

    ResetDeadKey;
    Block := False;
  End
  Else
  Begin
    Block := True;
    InternalBackspace;
    // ParseAndSendNow;
  End;
End;

{ =============================================================================== }

Function TGenericLayoutModern.InsertKar(Const sKar: String): String;
Begin
  If AutomaticallyFixChandra = 'YES' Then
  Begin
    If LastChar = b_Chandra Then
    Begin
      InternalBackspace;
      InsertKar := sKar + b_Chandra;
    End
    Else
      InsertKar := sKar;
  End
  Else
    InsertKar := sKar;

End;

{ =============================================================================== }
{$HINTS Off}

Function TGenericLayoutModern.InsertReph: String;
Var
  RephMoveable: Boolean;
  TmpStr: String;
  I, J: Integer;
Begin
  RephMoveable := False;

  If OldStyleReph = 'NO' Then
    RephMoveable := False
  Else
  Begin

    If IsPureConsonent(LastChar) = True Then
      RephMoveable := True
    Else If IsKar(LastChar) = True Then
    Begin
      If IsPureConsonent(LastChars[2]) = True Then
        RephMoveable := True
      Else
        RephMoveable := False;
    End
    Else If (LastChar = b_Chandra) Then
    Begin
      If IsPureConsonent(LastChars[2]) Then
        RephMoveable := True
      Else If ((IsKar(LastChars[2]) = True) And
        (IsPureConsonent(LastChars[3]) = True)) Then
        RephMoveable := True
      Else
        RephMoveable := False;
    End
    Else
      RephMoveable := False;
  End;

  If Not RephMoveable Then
  Begin
    InsertReph := b_R + b_Hasanta;
    Exit;
  End
  Else
  Begin
    I := 1;
    If ((IsKar(LastChar) = True) And (IsPureConsonent(LastChars[I + 1])
      = True)) Then
      I := I + 1
    Else If LastChar = b_Chandra Then
    Begin
      If IsPureConsonent(LastChars[I + 1]) Then
        I := I + 1
      Else If ((IsKar(LastChars[I + 1]) = True) And
        (IsPureConsonent(LastChars[I + 2]) = True)) Then
        I := I + 2;
    End;

    Repeat
      If LastChars[I + 1] = b_Hasanta Then
      Begin
        If IsPureConsonent(LastChars[I + 2]) = True Then
          I := I + 2
        Else
        Begin
          For J := I Downto 1 Do
            TmpStr := TmpStr + LastChars[J];

          InternalBackspace(I);
          InsertReph := b_R + b_Hasanta + TmpStr;
          Exit;
        End;
      End
      Else
      Begin
        For J := I Downto 1 Do
          TmpStr := TmpStr + LastChars[J];
        InternalBackspace(I);
        InsertReph := b_R + b_Hasanta + TmpStr;
        Exit;
      End;
    Until (I >= TrackL);

  End;
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.InternalBackspace(KeyRepeat: Integer);
Begin
  If KeyRepeat <= 0 Then
    KeyRepeat := 1;
  If KeyRepeat > TrackL Then
    KeyRepeat := TrackL;

  NewBanglaText := MidStr(PrevBanglaT, 1, Length(PrevBanglaT) - KeyRepeat);
  DeleteLastCharSteps_Ex(KeyRepeat);

End;

{$HINTS ON}
{ =============================================================================== }

{$HINTS Off}

Function TGenericLayoutModern.IsDeadKeyChar(Const CheckS: String): Boolean;
Begin
  Result := False;

  If CheckS = '' Then
  Begin
    IsDeadKeyChar := False;
    Exit;
  End;

  // Check only the most right letter
  If pos(String(RightStr(CheckS, 1)), DeadKeyChars) > 0 Then
    IsDeadKeyChar := True
  Else
    IsDeadKeyChar := False;

End;
{$HINTS ON}
{ =============================================================================== }

Function TGenericLayoutModern.MyProcessVKeyDown(Const KeyCode: Integer;
  Var Block: Boolean; Const var_IfShift, var_IfTrueShift,
  var_IfAltGr: Boolean): String;
Var
  CharForKey: String;
Begin

  If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then
  Begin
    Block := False;
    MyProcessVKeyDown := '';
    Exit;
  End
  Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then
  Begin
    CharForKey := GetCharForKey(KeyCode, var_IfShift, var_IfTrueShift,
      var_IfAltGr);

    If VowelFormating = 'NO' Then
      DeadKey := False;

    If DeadKey Then
    Begin
      If CharForKey = b_AAkar Then
      Begin
        MyProcessVKeyDown := b_AA;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Ikar Then
      Begin
        MyProcessVKeyDown := b_I;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_IIkar Then
      Begin
        MyProcessVKeyDown := b_II;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Ukar Then
      Begin
        MyProcessVKeyDown := b_U;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_UUkar Then
      Begin
        MyProcessVKeyDown := b_UU;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_RRIkar Then
      Begin
        MyProcessVKeyDown := b_RRI;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Ekar Then
      Begin
        MyProcessVKeyDown := b_E;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_OIkar Then
      Begin
        MyProcessVKeyDown := b_OI;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Okar Then
      Begin
        MyProcessVKeyDown := b_O;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_OUkar Then
      Begin
        MyProcessVKeyDown := b_OU;
        DeadKey := True;
        Exit;
      End
      // ElseIf KeyCode = VK_LSHIFT Or KeyCode = VK_RSHIFT Or KeyCode = VK_CAPITAL Or KeyCode = VK_NUMLOCK Or KeyCode = VK_LCONTROL Or KeyCode = VK_RCONTROL Or KeyCode = VK_CONTROL Or KeyCode = VK_MENU Or KeyCode = VK_LMENU Or KeyCode = VK_RMENU Then
      // DeadKey = True
      // MyProcessVKeyDown = ""
      // Block = False
      // Exit Function
      Else
        DeadKey := False;
    End;

    If LastChar = b_Hasanta Then
    Begin
      If CharForKey = b_AAkar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_AA;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Ikar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_I;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_IIkar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_II;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Ukar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_U;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_UUkar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_UU;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_RRIkar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_RRI;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Ekar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_E;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_OIkar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_OI;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Okar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_O;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_OUkar Then
      Begin
        InternalBackspace;
        MyProcessVKeyDown := b_OU;
        DeadKey := True;
        Exit;
      End
      Else If CharForKey = b_Hasanta Then
      Begin
        MyProcessVKeyDown := ZWNJ;
        DeadKey := True;
        Exit;
      End;
    End;

    Case KeyCode Of
      VK_RETURN:
        Begin
          Block := False;
          DeadKey := True;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        End;
      VK_SPACE:
        Begin
          Block := False;
          DeadKey := True;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        End;
      VK_TAB:
        Begin
          Block := False;
          DeadKey := True;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        End;
      VK_BACK:
        Begin
          DoBackspace(Block);
          MyProcessVKeyDown := '';
          Exit;
        End;
    Else
      Begin
        If CharForKey = b_R + b_Hasanta Then
        Begin
          MyProcessVKeyDown := InsertReph;
          Exit;
        End
        Else If CharForKey = '' Then
        Begin
          DeadKey := False;
          Block := False;
          MyProcessVKeyDown := '';
          ResetLastChar;
          Exit;
        End
        Else If CharForKey = b_Hasanta + b_Z Then
        Begin
          If (LastChar = b_R) And (LastChars[2] <> b_Hasanta) Then
          Begin
            MyProcessVKeyDown := DetermineZWNJ_ZWJ + b_Hasanta + b_Z;
            Exit;
          End
          Else
          Begin
            MyProcessVKeyDown := b_Hasanta + b_Z;
            Exit;
          End;
        End
        Else
        Begin
          If IsDeadKeyChar(CharForKey) Then
          Begin
            If IsKar(CharForKey) Then
            Begin
              DeadKey := True;
              MyProcessVKeyDown := InsertKar(CharForKey);
              Exit;
            End
            Else
            Begin
              DeadKey := True;
              MyProcessVKeyDown := CharForKey;
              Exit;
            End;
          End
          Else
          Begin
            MyProcessVKeyDown := CharForKey;
            Exit;
          End;
        End;
      End;
    End;
  End;
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.MyProcessVKeyUP(Const KeyCode: Integer;
  Var Block: Boolean; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean);
Var
  CharForKey: String;
Begin
  If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then
  Begin

    Block := False;
    Exit;
  End
  Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then
  Begin

    CharForKey := GetCharForKey(KeyCode, var_IfShift, var_IfTrueShift,
      var_IfAltGr);

    If CharForKey = '' Then
      Block := False
    Else
    Begin
      Block := True;
      Exit;
    End;

  End;
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.ParseAndSendNow;
Var
  I, Matched, UnMatched: Integer;
  BijoyPrevBanglaT, BijoyNewBanglaText: String;
Begin
  Matched := 0;

  If OutputIsBijoy <> 'YES' Then
  Begin
    { Output to Unicode }
    If PrevBanglaT = '' Then
    Begin
      SendKey_Char(NewBanglaText);
      PrevBanglaT := NewBanglaText;
    End
    Else
    Begin
      For I := 1 To Length(PrevBanglaT) Do
      Begin
        If MidStr(PrevBanglaT, I, 1) = MidStr(NewBanglaText, I, 1) Then
          Matched := Matched + 1
        Else
          Break;
      End;
      UnMatched := Length(PrevBanglaT) - Matched;

      If UnMatched >= 1 Then
        Backspace(UnMatched);
      SendKey_Char(MidStr(NewBanglaText, Matched + 1, Length(NewBanglaText)));
      PrevBanglaT := NewBanglaText;
    End;

  End
  Else
  Begin
    { Output to Bijoy }
    BijoyPrevBanglaT := Bijoy.Convert(PrevBanglaT);
    BijoyNewBanglaText := Bijoy.Convert(NewBanglaText);

    If BijoyPrevBanglaT = '' Then
    Begin
      SendKey_Char(BijoyNewBanglaText);
      PrevBanglaT := NewBanglaText;
    End
    Else
    Begin
      For I := 1 To Length(BijoyPrevBanglaT) Do
      Begin
        If MidStr(BijoyPrevBanglaT, I, 1) = MidStr(BijoyNewBanglaText,
          I, 1) Then
          Matched := Matched + 1
        Else
          Break;
      End;
      UnMatched := Length(BijoyPrevBanglaT) - Matched;

      If UnMatched >= 1 Then
        Backspace(UnMatched);
      SendKey_Char(MidStr(BijoyNewBanglaText, Matched + 1,
        Length(BijoyNewBanglaText)));
      PrevBanglaT := NewBanglaText;
    End;

  End;
End;

{ =============================================================================== }

Function TGenericLayoutModern.ProcessVKeyDown(Const KeyCode: Integer;
  Var Block: Boolean): String;
Var
  m_Block: Boolean;
  m_Str: String;
Begin
  m_Block := False;

  If (IfWinKey = True) Or (IfOnlyCtrlKey = True) Or
    (IfOnlyLeftAltKey = True) Then
  Begin
    Block := False;
    ProcessVKeyDown := '';
    Exit;
  End;

  If IfIgnorableModifierKey(KeyCode) Then
  Begin
    Block := False;
    ProcessVKeyDown := '';
    Exit;
  End;

  m_Str := MyProcessVKeyDown(KeyCode, m_Block, IfShift, IfTrueShift, IfAltGr);
  If m_Str <> '' Then
  Begin
    m_Block := True;
    SetLastChar(m_Str);
  End;

  NewBanglaText := NewBanglaText + m_Str;
  ParseAndSendNow;

  Block := m_Block;
  ProcessVKeyDown := '';
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.ProcessVKeyUP(Const KeyCode: Integer;
  Var Block: Boolean);
Begin
  If ((IfWinKey = True) Or (IfOnlyCtrlKey = True) Or
    (IfOnlyLeftAltKey = True)) Then
  Begin
    Block := False;
    Exit;
  End;

  If IfIgnorableModifierKey(KeyCode) = True Then
  Begin
    Block := False;
    Exit;
  End;

  MyProcessVKeyUP(KeyCode, Block, IfShift, IfTrueShift, IfAltGr);
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.ResetDeadKey;
Begin
  DeadKey := False;
  ResetLastChar;
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.ResetLastChar;
Var
  I: Integer;
Begin
  For I := 1 To TrackL Do
    LastChars[I] := ' ';

  LastChar := ' ';
  PrevBanglaT := '';
  NewBanglaText := '';
End;

{ =============================================================================== }

Procedure TGenericLayoutModern.SetLastChar(Const wChar: String);
Var
  t1, t2: String;
  I, J: Integer;
Begin
  For I := TrackL Downto 1 Do
    t1 := t1 + LastChars[I];

  t1 := t1 + wChar;
  t2 := RightStr(t1, TrackL);

  For I := TrackL Downto 1 Do
  Begin
    J := TrackL + 1 - I;
    LastChars[I] := MidStr(t2, J, 1);
  End;
  LastChar := LastChars[1];
End;

{ =============================================================================== }

End.
