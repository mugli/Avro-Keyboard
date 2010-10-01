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

Unit clsGenericLayoutModern;

Interface

Uses
     classes,
     sysutils,
     StrUtils;

Const
     TrackL                   = 10;

     //Skeleton of Class TGenericLayoutModern
Type
     TGenericLayoutModern = Class
     Private
          LastChar: WideString;
          DeadKey: Boolean;
          DeadKeyChars: WideString;
          DetermineZWNJ_ZWJ: WideString;
          LastChars: Array[1..TrackL] Of WideString;

          Function InsertKar(Const sKar: WideString): WideString;
          Function InsertReph: WideString;
          Procedure DeleteLastCharOneStep;
          Procedure DeleteLastCharSteps_Ex(StepCount: Integer);
          Procedure SetLastChar(Const wChar: WideString);
          Procedure ResetLastChar;
          Function MyProcessVKeyDown(Const KeyCode: Integer;
               Var Block: Boolean; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): Widestring;
          Procedure MyProcessVKeyUP(Const KeyCode: Integer;
               Var Block: Boolean; Const var_IfShift: Boolean; Const var_IfTrueShift: Boolean; Const var_IfAltGr: Boolean);

          Function IsDeadKeyChar(Const CheckS: WideString): Boolean;

     Public
          Constructor Create;           //Initializer

          Function ProcessVKeyDown(Const KeyCode: Integer; Var Block: Boolean): WideString;
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

{===============================================================================}

{ TGenericLayoutModern }

Constructor TGenericLayoutModern.Create;
Begin
     Inherited;
     //:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
     //Initialize DeadKeyChar Variable
     //:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
     //Standards Symbols

     DeadKeyChars := '`~!@#$%^+*-_=+\|"/;:,./?><()[]{}' + #39;

     //English Numbers + Letters
     DeadKeyChars := DeadKeyChars + '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

     //Bangla Numbers
     DeadKeyChars := DeadKeyChars + b_0 + b_1 + b_2 + b_3 + b_4 + b_5 + b_6 + b_7 + b_8 + b_9;

     //Bangla Vowels + Kars
     DeadKeyChars := DeadKeyChars + b_A + b_AA + b_AAkar + b_I + b_II + b_IIkar + b_Ikar + b_U + b_Ukar + b_UU + b_UUkar + b_RRI + b_RRIkar + b_E + b_Ekar + b_O + b_OI + b_OIkar + b_Okar + b_OU + b_OUkar;

     //Bangla Unusual Vowels + Kars
     DeadKeyChars := DeadKeyChars + b_Vocalic_L + b_Vocalic_LL + b_Vocalic_RR + b_Vocalic_RR_Kar + b_Vocalic_L_Kar + b_Vocalic_LL_Kar;

     //Bangla Symbols/Signs
     DeadKeyChars := DeadKeyChars + b_Anushar + b_Bisharga + b_Khandatta + b_Dari + b_Taka;

     //Bangla Unusal Symbols/Signs
     DeadKeyChars := DeadKeyChars + b_LengthMark + b_RupeeMark + b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 + b_CurrencyNumerator4 + b_CurrencyNumerator1LessThanDenominator + b_CurrencyDenominator16;

     //:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
     //End Initialize DeadKeyChar Variable
     //:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

     ResetLastChar;

     // If IsWinVistaOrLater Then
     DetermineZWNJ_ZWJ := ZWJ;
     // Else
      //     DetermineZWNJ_ZWJ := ZWNJ;
End;

{===============================================================================}

Procedure TGenericLayoutModern.DeleteLastCharOneStep;
Var
     I, J                     : Integer;
     t1                       : WideString;
Begin
     For i := TrackL Downto 1 Do
          t1 := t1 + LastChars[i];


     t1 := ' ' + LeftStr(t1, Length(t1) - 1);

     For i := TrackL Downto 1 Do Begin
          J := TrackL + 1 - i;
          LastChars[i] := MidStr(t1, J, 1);
     End;
     LastChar := LastChars[1];
End;

{===============================================================================}

Procedure TGenericLayoutModern.DeleteLastCharSteps_Ex(StepCount: Integer);
Var
     I, J                     : Integer;
     t1                       : Widestring;
Begin

     For i := TrackL Downto 1 Do
          t1 := t1 + LastChars[i];

     If StepCount > TrackL Then StepCount := TrackL;

     t1 := StringOfChar(' ', StepCount) + LeftStr(t1, Length(t1) - StepCount);

     For i := TrackL Downto 1 Do Begin
          J := TrackL + 1 - i;
          LastChars[i] := MidStr(t1, J, 1);
     End;
     LastChar := LastChars[1];
End;


{===============================================================================}

Function TGenericLayoutModern.InsertKar(Const sKar: WideString): WideString;
Begin
     If AutomaticallyFixChandra = 'YES' Then Begin
          If LastChar = b_Chandra Then Begin
               Backspace;
               DeleteLastCharOneStep;
               InsertKar := sKar + b_Chandra;
          End
          Else
               InsertKar := sKar;
     End
     Else
          InsertKar := sKar;

End;

{===============================================================================}
{$HINTS Off}

Function TGenericLayoutModern.InsertReph: WideString;
Var
     RephMoveable             : Boolean;
     TmpStr                   : Widestring;
     I, J                     : Integer;
Begin
     RephMoveable := False;

     If OldStyleReph = 'NO' Then
          RephMoveable := False
     Else Begin

          If IsPureConsonent(LastChar) = True Then
               RephMoveable := True
          Else If IsKar(LastChar) = True Then Begin
               If IsPureConsonent(LastChars[2]) = True Then
                    RephMoveable := True
               Else
                    RephMoveable := False;
          End
          Else If (LastChar = b_Chandra) Then Begin
               If IsPureConsonent(LastChars[2]) Then
                    RephMoveable := True
               Else If ((IsKar(LastChars[2]) = True) And (IsPureConsonent(LastChars[3]) = True)) Then
                    RephMoveable := True
               Else
                    RephMoveable := False;
          End
          Else
               RephMoveable := False;
     End;

     If Not RephMoveable Then Begin
          InsertReph := b_R + b_Hasanta;
          Exit;
     End
     Else Begin
          i := 1;
          If ((IsKar(LastChar) = True) And (IsPureConsonent(LastChars[i + 1]) = True)) Then
               i := i + 1
          Else If LastChar = b_Chandra Then Begin
               If IsPureConsonent(LastChars[i + 1]) Then
                    i := i + 1
               Else If ((IsKar(LastChars[i + 1]) = True) And (IsPureConsonent(LastChars[i + 2]) = True)) Then
                    i := i + 2;
          End;

          Repeat
               If LastChars[i + 1] = b_Hasanta Then Begin
                    If IsPureConsonent(LastChars[i + 2]) = True Then
                         i := i + 2
                    Else Begin
                         For J := i Downto 1 Do
                              TmpStr := TmpStr + LastChars[J];

                         Backspace(i);
                         DeleteLastCharSteps_Ex(i);
                         InsertReph := b_R + b_Hasanta + TmpStr;
                         Exit;
                    End;
               End
               Else Begin
                    For J := i Downto 1 Do
                         TmpStr := TmpStr + LastChars[J];
                    Backspace(i);
                    DeleteLastCharSteps_Ex(i);
                    InsertReph := b_R + b_Hasanta + TmpStr;
                    Exit;
               End;
          Until (i >= TrackL);

     End;
End;
{$HINTS ON}
{===============================================================================}

{$HINTS Off}

Function TGenericLayoutModern.IsDeadKeyChar(Const CheckS: WideString): Boolean;
Begin
     Result := False;

     If CheckS = '' Then Begin
          IsDeadKeyChar := False;
          Exit;
     End;

     //Check only the most right letter
     If pos(RightStr(CheckS, 1), DeadKeyChars) > 0 Then
          IsDeadKeyChar := True
     Else
          IsDeadKeyChar := False;

End;
{$HINTS ON}
{===============================================================================}

Function TGenericLayoutModern.MyProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): Widestring;
Var
     CharForKey               : WideString;
Begin

     If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then Begin
          Block := False;
          MyProcessVKeyDown := '';
          Exit;
     End
     Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then Begin
          CharForKey := GetCharForKey(KeyCode, var_IfShift, var_IfTrueShift, var_IfAltGr);

          If VowelFormating = 'NO' Then DeadKey := False;

          If DeadKey Then Begin
               If CharForKey = b_AAkar Then Begin
                    MyProcessVKeyDown := b_AA;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Ikar Then Begin
                    MyProcessVKeyDown := b_I;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_IIkar Then Begin
                    MyProcessVKeyDown := b_II;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Ukar Then Begin
                    MyProcessVKeyDown := b_U;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_UUkar Then Begin
                    MyProcessVKeyDown := b_UU;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_RRIkar Then Begin
                    MyProcessVKeyDown := b_RRI;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Ekar Then Begin
                    MyProcessVKeyDown := b_E;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_OIkar Then Begin
                    MyProcessVKeyDown := b_OI;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Okar Then Begin
                    MyProcessVKeyDown := b_O;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_OUkar Then Begin
                    MyProcessVKeyDown := b_OU;
                    DeadKey := True;
                    Exit;
               End
                    //ElseIf KeyCode = VK_LSHIFT Or KeyCode = VK_RSHIFT Or KeyCode = VK_CAPITAL Or KeyCode = VK_NUMLOCK Or KeyCode = VK_LCONTROL Or KeyCode = VK_RCONTROL Or KeyCode = VK_CONTROL Or KeyCode = VK_MENU Or KeyCode = VK_LMENU Or KeyCode = VK_RMENU Then
                    //    DeadKey = True
                    //    MyProcessVKeyDown = ""
                    //    Block = False
                    //    Exit Function
               Else
                    DeadKey := False;
          End;

          If LastChar = b_Hasanta Then Begin
               If CharForKey = b_AAkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_AA;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Ikar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_I;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_IIkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_II;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Ukar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_U;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_UUkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_UU;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_RRIkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_RRI;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Ekar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_E;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_OIkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_OI;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Okar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_O;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_OUkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := b_OU;
                    DeadKey := True;
                    Exit;
               End
               Else If CharForKey = b_Hasanta Then Begin
                    MyProcessVKeyDown := ZWNJ;
                    DeadKey := True;
                    Exit;
               End;
          End;

          Case KeyCode Of
               VK_RETURN: Begin
                         Block := False;
                         DeadKey := True;
                         ResetLastChar;
                         MyProcessVKeyDown := '';
                         Exit;
                    End;
               VK_SPACE: Begin
                         Block := False;
                         DeadKey := True;
                         ResetLastChar;
                         MyProcessVKeyDown := '';
                         Exit;
                    End;
               VK_TAB: Begin
                         Block := False;
                         DeadKey := True;
                         ResetLastChar;
                         MyProcessVKeyDown := '';
                         Exit;
                    End;
          Else Begin
                    If CharForKey = b_R + b_Hasanta Then Begin
                         MyProcessVKeyDown := InsertReph;
                         Exit;
                    End
                    Else If CharForKey = '' Then Begin
                         DeadKey := False;
                         Block := False;
                         MyProcessVKeyDown := '';
                         ResetLastChar;
                         Exit;
                    End
                    Else If CharForKey = b_Hasanta + b_Z Then Begin
                         If (LastChar = b_R) And (LastChars[2] <> b_Hasanta) Then Begin
                              MyProcessVKeyDown := DetermineZWNJ_ZWJ + b_Hasanta + b_Z;
                              Exit;
                         End
                         Else Begin
                              MyProcessVKeyDown := b_Hasanta + b_Z;
                              Exit;
                         End;
                    End
                    Else Begin
                         If IsDeadKeyChar(CharForKey) Then Begin
                              If IsKar(CharForKey) Then Begin
                                   DeadKey := True;
                                   MyProcessVKeyDown := InsertKar(CharForKey);
                                   Exit;
                              End
                              Else Begin
                                   DeadKey := True;
                                   MyProcessVKeyDown := CharForKey;
                                   Exit;
                              End;
                         End
                         Else Begin
                              MyProcessVKeyDown := CharForKey;
                              Exit;
                         End;
                    End;
               End;
          End;
     End;
End;

{===============================================================================}

Procedure TGenericLayoutModern.MyProcessVKeyUP(Const KeyCode: Integer;
     Var Block: Boolean; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean);
Var
     CharForKey               : Widestring;
Begin
     If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then Begin

          Block := False;
          Exit;
     End
     Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then Begin

          CharForKey := GetCharForKey(KeyCode, var_IfShift, var_IfTrueShift, var_IfAltGr);

          If CharForKey = '' Then
               Block := False
          Else Begin
               Block := True;
               Exit;
          End;

     End;
End;

{===============================================================================}

Function TGenericLayoutModern.ProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean): WideString;
Var
     m_Block                  : Boolean;
     m_Str                    : Widestring;
Begin
     m_Block := False;

     If (IfWinKey = True) Or (IfOnlyCtrlKey = True) Or (IfOnlyLeftAltKey = True) Then Begin
          Block := False;
          ProcessVKeyDown := '';
          Exit;
     End;

     If IfIgnorableModifierKey(KeyCode) Then Begin
          Block := False;
          ProcessVKeyDown := '';
          Exit;
     End;

     m_Str := MyProcessVKeyDown(KeyCode, m_Block, IfShift, IfTrueShift, IfAltGr);
     If m_Str <> '' Then Begin
          m_Block := True;
          SetLastChar(m_Str);
     End;

     If m_Block Then Begin
          Block := True;
          //DebugPrint "PrcessVKeyDown Returns:" & WhichBanglaChar(m_Str)
          ProcessVKeyDown := m_Str;
     End
     Else Begin
          Block := False;
          ProcessVKeyDown := m_Str;
     End;

End;

{===============================================================================}

Procedure TGenericLayoutModern.ProcessVKeyUP(Const KeyCode: Integer;
     Var Block: Boolean);
Begin
     If ((IfWinKey = True) Or (IfOnlyCtrlKey = True) Or (IfOnlyLeftAltKey = True)) Then Begin
          Block := False;
          Exit;
     End;

     If IfIgnorableModifierKey(KeyCode) = True Then Begin
          Block := False;
          Exit;
     End;

     MyProcessVKeyUP(KeyCode, Block, IfShift, IfTrueShift, IfAltGr);
End;

{===============================================================================}

Procedure TGenericLayoutModern.ResetDeadKey;
Begin
     DeadKey := False;
     ResetLastChar;
End;

{===============================================================================}

Procedure TGenericLayoutModern.ResetLastChar;
Var
     i                        : integer;
Begin
     For i := 1 To TrackL Do
          LastChars[i] := ' ';

     LastChar := ' ';
End;

{===============================================================================}

Procedure TGenericLayoutModern.SetLastChar(Const wChar: WideString);
Var
     t1, t2                   : Widestring;
     I, J                     : Integer;
Begin
     For i := TrackL Downto 1 Do
          t1 := t1 + LastChars[i];


     t1 := t1 + wChar;
     t2 := RightStr(t1, TrackL);

     For i := TrackL Downto 1 Do Begin
          J := TrackL + 1 - i;
          LastChars[i] := MidStr(t2, J, 1);
     End;
     LastChar := LastChars[1];
End;

{===============================================================================}

End.

