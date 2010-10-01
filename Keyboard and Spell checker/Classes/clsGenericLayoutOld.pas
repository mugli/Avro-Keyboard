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

Unit clsGenericLayoutOld;

Interface

Uses
     classes,
     sysutils,
     StrUtils;

Const
     TrackL                   = 10;

     //Skeleton of Class TGenericLayoutOld
Type
     TGenericLayoutOld = Class
     Private
          LastChar: WideString;
          DetermineZWNJ_ZWJ: WideString;
          LastChars: Array[1..TrackL] Of WideString;

          //Kar Variables for Full Old Style Typing
          EKarActive, IKarActive, OIKarActive: Boolean;

          Function InsertKar(Const sKar: WideString): WideString;
          Function InsertReph: WideString;
          Procedure SetLastChar(Const wChar: WideString);
          Procedure DeleteLastCharOneStep;
          Procedure DeleteLastCharSteps_Ex(StepCount: Integer);
          Procedure ResetLastChar;
          Function MyProcessVKeyDown(Const KeyCode: Integer;
               Var Block: Boolean; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): widestring;
          Procedure MyProcessVKeyUP(Const KeyCode: Integer;
               Var Block: Boolean; Const var_IfShift: Boolean; Const var_IfTrueShift: Boolean; Const var_IfAltGr: Boolean);
          Procedure ResetAllKarsToInactive;
     Public
          Constructor Create;           //Initializer

          Function ProcessVKeyDown(Const KeyCode: Integer; Var Block: Boolean): WideString;
          Procedure ProcessVKeyUP(Const KeyCode: Integer; Var Block: Boolean);
          Procedure ResetDeadKey;
     End;

Implementation

Uses
     Banglachars,
     KeyboardFunctions,
     uForm1,
     KeyboardLayoutLoader,
     clsLayout,
     VirtualKeycode,
     WindowsVersion;

{===============================================================================}

{ TGenericLayoutOld }

Constructor TGenericLayoutOld.Create;
Begin
     Inherited;
     ResetLastChar;

   //  If IsWinVistaOrLater Then
          DetermineZWNJ_ZWJ := ZWJ ;
   //  Else
   //       DetermineZWNJ_ZWJ := ZWNJ;
End;

{===============================================================================}

Procedure TGenericLayoutOld.DeleteLastCharOneStep;
Var
     I, J                     : integer;
     t1                       : Widestring;
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

Procedure TGenericLayoutOld.DeleteLastCharSteps_Ex(StepCount: Integer);
Var
     I, J                     : integer;
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

Function TGenericLayoutOld.InsertKar(Const sKar: WideString): WideString;
Begin
     If LastChar = b_Chandra Then Begin
          If LastChars[2] = b_Ekar Then Begin
               If sKar = b_AAkar Then Begin
                    Backspace(2);
                    DeleteLastCharSteps_Ex(2);
                    InsertKar := b_Okar + b_Chandra;
               End
               Else If sKar = b_LengthMark Then Begin
                    Backspace(2);
                    DeleteLastCharSteps_Ex(2);
                    InsertKar := b_OUkar + b_Chandra;
               End
               Else
                    InsertKar := sKar;
          End
          Else Begin
               //Backspace;
               //DeleteLastCharOneStep;
               InsertKar := sKar {+ b_Chandra};
          End;
     End
     Else
          InsertKar := sKar;
End;

{===============================================================================}
{$HINTS Off}

Function TGenericLayoutOld.InsertReph: WideString;
Var
     RephMoveable             : Boolean;
     TmpStr                   : Widestring;
     I, J                     : Integer;
Begin
     RephMoveable := False;

     If IsPureConsonent(LastChar) = True Then
          RephMoveable := True
     Else If IsKar(LastChar) = true Then Begin
          If IsPureConsonent(LastChars[2]) Then
               RephMoveable := True
          Else
               RephMoveable := False;
     End
     Else If LastChar = b_Chandra Then Begin
          If IsPureConsonent(LastChars[2]) = true Then
               RephMoveable := True
          Else If (IsKar(LastChars[2]) = true) And (IsPureConsonent(LastChars[3]) = true) Then
               RephMoveable := True
          Else
               RephMoveable := False;
     End
     Else
          RephMoveable := False;


     If Not RephMoveable Then Begin
          InsertReph := b_R + b_Hasanta;
          Exit;
     End
     Else Begin
          i := 1;

          If (IsKar(LastChar) = True) And (IsPureConsonent(LastChars[i + 1]) = True) Then
               i := i + 1
          Else If LastChar = b_Chandra Then Begin
               If IsPureConsonent(LastChars[i + 1]) = True Then
                    i := i + 1
               Else If (IsKar(LastChars[i + 1]) = True) And (IsPureConsonent(LastChars[i + 2]) = True) Then
                    i := i + 2;
          End;

          Repeat
               If LastChars[i + 1] = b_Hasanta Then Begin
                    If IsPureConsonent(LastChars[i + 2]) Then
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
          Until i >= TrackL;

     End;
End;
{$HINTS ON}
{===============================================================================}

Function TGenericLayoutOld.MyProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): Widestring;
Var
     CharForKey, tmpString, PendingKar: Widestring;
Begin

     If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then Begin

          Block := False;
          MyProcessVKeyDown := '';
          Exit;
     End
     Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then Begin
          CharForKey := GetCharForKey(KeyCode, var_IfShift, var_IfTrueShift, var_IfAltGr);


          If LastChar = b_Hasanta Then Begin

               If EKarActive Then
                    PendingKar := b_Ekar
               Else If IKarActive Then
                    PendingKar := b_Ikar
               Else If OIKarActive Then
                    PendingKar := b_OIkar
               Else
                    PendingKar := '';

               If CharForKey = b_AAkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_AA;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_Ikar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_I;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_IIkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_II;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_Ukar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_U;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_UUkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_UU;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_RRIkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_RRI;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_Ekar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_E;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_OIkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_OI;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_Okar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_O;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_OUkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_OU;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_LengthMark Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(PendingKar) + b_OU;
                    ResetAllKarsToInactive;
                    Exit;
               End
               Else If CharForKey = b_Hasanta Then Begin
                    MyProcessVKeyDown := ZWNJ;
                    ResetAllKarsToInactive;
                    Exit;
               End;
          End;

          If CharForKey = b_Ekar Then Begin
               If EKarActive = True Then Begin
                    EKarActive := False;
                    MyProcessVKeyDown := b_Ekar;
                    Exit;
               End
               Else Begin
                    ResetAllKarsToInactive;
                    EKarActive := True;
                    Block := True;
                    MyProcessVKeyDown := '';
                    Exit;
               End;
          End;


          If CharForKey = b_Ikar Then Begin
               If IKarActive = True Then Begin
                    IKarActive := False;
                    MyProcessVKeyDown := b_Ikar;
                    Exit;
               End
               Else Begin
                    ResetAllKarsToInactive;
                    IKarActive := True;
                    Block := True;
                    MyProcessVKeyDown := '';
                    Exit;
               End;
          End;


          If CharForKey = b_OIkar Then Begin
               If OIKarActive = True Then Begin
                    OIKarActive := False;
                    MyProcessVKeyDown := b_OIkar;
                    Exit;
               End
               Else Begin
                    ResetAllKarsToInactive;
                    OIKarActive := True;
                    Block := True;
                    MyProcessVKeyDown := '';
                    Exit;
               End;
          End;


          If CharForKey = b_AAkar Then Begin
               If LastChar = b_Ekar Then Begin
                    ResetAllKarsToInactive;
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(b_Okar);
                    Exit;
               End;
          End;


          If CharForKey = b_LengthMark Then Begin
               If LastChar = b_Ekar Then Begin
                    ResetAllKarsToInactive;
                    Backspace;
                    DeleteLastCharOneStep;
                    MyProcessVKeyDown := InsertKar(b_OUkar);
                    Exit;
               End;
          End;


          If CharForKey = b_Hasanta Then Begin
               If LastChar = b_Ekar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    EKarActive := True;
                    MyProcessVKeyDown := b_Hasanta;
                    Exit;
               End
               Else If LastChar = b_Ikar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    IKarActive := True;
                    MyProcessVKeyDown := b_Hasanta;
                    Exit;
               End
               Else If LastChar = b_OIkar Then Begin
                    Backspace;
                    DeleteLastCharOneStep;
                    OIKarActive := True;
                    MyProcessVKeyDown := b_Hasanta;
                    Exit;
               End
               Else Begin
                    MyProcessVKeyDown := b_Hasanta;
                    Exit;
               End;
          End;


          Case Keycode Of
               VK_RETURN: Begin
                         Block := False;
                         ResetLastChar;
                         MyProcessVKeyDown := '';
                         Exit;
                    End;
               VK_SPACE: Begin
                         Block := False;
                         ResetLastChar;
                         MyProcessVKeyDown := '';
                         Exit;
                    End;
               VK_TAB: Begin
                         Block := False;
                         ResetLastChar;
                         MyProcessVKeyDown := '';
                         Exit;
                    End;
          Else Begin
                    If EKarActive = True Then Begin
                         If CharForKey = b_R + b_Hasanta Then Begin
                              EKarActive := False;
                              MyProcessVKeyDown := InsertReph + InsertKar(b_Ekar);
                              Exit;
                         End
                         Else If CharForKey = b_AAkar Then Begin
                              EKarActive := False;
                              MyProcessVKeyDown := InsertKar(b_Okar);
                              Exit;
                         End
                         Else If CharForKey = b_LengthMark Then Begin
                              EKarActive := False;
                              MyProcessVKeyDown := InsertKar(b_OUkar);
                              Exit;
                         End
                         Else If CharForKey = '' Then Begin
                              ResetLastChar;
                              Block := False;
                              MyProcessVKeyDown := '';
                              Exit;
                         End
                         Else Begin
                              EKarActive := False;
                              MyProcessVKeyDown := CharForKey + InsertKar(b_Ekar);
                              Exit;
                         End;
                    End
                    Else If IKarActive = True Then Begin
                         If CharForKey = b_R + b_Hasanta Then Begin
                              IKarActive := False;
                              MyProcessVKeyDown := InsertReph + InsertKar(b_Ikar);
                              Exit;
                         End
                         Else If CharForKey = '' Then Begin
                              ResetLastChar;
                              Block := False;
                              MyProcessVKeyDown := '';
                              Exit;
                         End
                         Else Begin
                              IKarActive := False;
                              MyProcessVKeyDown := CharForKey + InsertKar(b_Ikar);
                              Exit;
                         End;
                    End
                    Else If OIKarActive = True Then Begin
                         If CharForKey = b_R + b_Hasanta Then Begin
                              OIKarActive := False;
                              MyProcessVKeyDown := InsertReph + InsertKar(b_OIkar);
                              Exit;
                         End
                         Else If CharForKey = '' Then Begin
                              ResetLastChar;
                              Block := False;
                              MyProcessVKeyDown := '';
                              Exit;
                         End
                         Else Begin
                              OIKarActive := False;
                              MyProcessVKeyDown := CharForKey + InsertKar(b_OIkar);
                              Exit;
                         End;
                    End
                    Else Begin
                         If CharForKey = b_R + b_Hasanta Then Begin
                              MyProcessVKeyDown := InsertReph;
                              Exit;
                         End
                         Else If CharForKey = b_AAkar Then Begin
                              If LastChar = b_A Then Begin
                                   Backspace;
                                   DeleteLastCharOneStep;
                                   MyProcessVKeyDown := b_AA;
                                   Exit;
                              End
                              Else Begin
                                   MyProcessVKeyDown := b_AAkar;
                                   Exit;
                              End;
                         End
                         Else If CharForKey = b_Hasanta + b_Z Then Begin

                              If (LastChar = b_R) And (LastChars[2] <> b_Hasanta) Then Begin
                                   MyProcessVKeyDown := DetermineZWNJ_ZWJ + b_Hasanta + b_Z;
                                   Exit;
                              End
                              Else If IsKar(LastChar) Then Begin
                                   If (LastChars[2] = b_R) And (LastChars[3] <> b_Hasanta) Then Begin
                                        tmpString := LastChar;
                                        Backspace;
                                        DeleteLastCharOneStep;
                                        MyProcessVKeyDown := DetermineZWNJ_ZWJ + CharForKey + tmpString;
                                        Exit;
                                   End
                                   Else Begin
                                        tmpString := LastChar;
                                        Backspace;
                                        DeleteLastCharOneStep;
                                        MyProcessVKeyDown := CharForKey + tmpString;
                                        Exit;
                                   End;
                              End
                              Else Begin
                                   MyProcessVKeyDown := b_Hasanta + b_Z;
                                   Exit;
                              End;

                         End
                         Else If CharForKey = '' Then Begin
                              ResetLastChar;
                              Block := False;
                              MyProcessVKeyDown := '';
                              Exit;
                         End
                         Else Begin
                              If (Length(CharForKey) > 1) And (LeftStr(CharForKey, 1) = b_Hasanta) Then Begin
                                   If IsKar(LastChar) Then Begin
                                        tmpString := LastChar;
                                        Backspace;
                                        DeleteLastCharOneStep;
                                        MyProcessVKeyDown := CharForKey + tmpString;
                                        Exit;
                                   End;
                              End;

                              If IsKar(CharForKey) Then Begin
                                   MyProcessVKeyDown := InsertKar(CharForKey);
                                   Exit;
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

End;

{===============================================================================}

Procedure TGenericLayoutOld.MyProcessVKeyUP(Const KeyCode: Integer;
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

          If CharForKey = '' Then Begin
               Block := False;
               Exit;
          End
          Else Begin
               Block := True;
               Exit;
          End;
     End;

End;

{===============================================================================}

Function TGenericLayoutOld.ProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean): WideString;
Var
     m_Block                  : Boolean;
     m_Str                    : WideString;
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
          //Debug.Print "PrcessVKeyDown Returns:" & WhichBanglaChar(m_Str)
          ProcessVKeyDown := m_Str;
     End
     Else Begin
          Block := False;
          ProcessVKeyDown := m_Str;
     End;



End;

{===============================================================================}

Procedure TGenericLayoutOld.ProcessVKeyUP(Const KeyCode: Integer;
     Var Block: Boolean);
Begin
     If (IfWinKey = True) Or (IfOnlyCtrlKey = True) Or (IfOnlyLeftAltKey = True) Then Begin
          Block := False;
          Exit;
     End;

     If IfIgnorableModifierKey(KeyCode) = True Then Begin
          Block := False;
          Exit;
     End;

     //        If BlockedLast Then
     //            Block = True
     //        Else
     //            Block = False
     //        End If

     MyProcessVKeyUP(KeyCode, Block, IfShift, IfTrueShift, IfAltGr);
End;

{===============================================================================}

Procedure TGenericLayoutOld.ResetAllKarsToInactive;
Begin
     EKarActive := False;
     IKarActive := False;
     OIKarActive := False;
End;

{===============================================================================}

Procedure TGenericLayoutOld.ResetDeadKey;
Begin
     ResetLastChar;
End;

{===============================================================================}

Procedure TGenericLayoutOld.ResetLastChar;
Var
     i                        : Integer;
Begin
     For i := 1 To TrackL Do
          LastChars[i] := ' ';

     LastChar := ' ';
     ResetAllKarsToInactive;
End;

{===============================================================================}

Procedure TGenericLayoutOld.SetLastChar(Const wChar: WideString);
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

