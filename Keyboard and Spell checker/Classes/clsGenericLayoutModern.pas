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

unit clsGenericLayoutModern;

interface

uses
  classes,
  sysutils,
  StrUtils,
  clsUnicodeToBijoy2000;

const
  TrackL = 100;

  // Skeleton of Class TGenericLayoutModern
type
  TGenericLayoutModern = class
    private
      Bijoy:                      TUnicodeToBijoy2000;
      LastChar:                   string;
      DeadKey:                    Boolean;
      DeadKeyChars:               string;
      DetermineZWNJ_ZWJ:          string;
      LastChars:                  array [1 .. TrackL] of string;
      PrevBanglaT, NewBanglaText: string;

      procedure InternalBackspace(KeyRepeat: Integer = 1);
      procedure DoBackspace(var Block: Boolean);
      procedure ParseAndSendNow;
      function InsertKar(const sKar: string): string;
      function InsertReph: string;
      procedure DeleteLastCharSteps_Ex(StepCount: Integer);
      procedure SetLastChar(const wChar: string);
      procedure ResetLastChar;
      function MyProcessVKeyDown(const KeyCode: Integer; var Block: Boolean; const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): string;
      procedure MyProcessVKeyUP(const KeyCode: Integer; var Block: Boolean; const var_IfShift: Boolean; const var_IfTrueShift: Boolean;
        const var_IfAltGr: Boolean);

      function IsDeadKeyChar(const CheckS: string): Boolean;

    public
      constructor Create;           // Initializer
      destructor Destroy; override; // Destructor

      function ProcessVKeyDown(const KeyCode: Integer; var Block: Boolean): string;
      procedure ProcessVKeyUP(const KeyCode: Integer; var Block: Boolean);
      procedure ResetDeadKey;
  end;

implementation

uses
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

constructor TGenericLayoutModern.Create;
begin
  inherited;
  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
  // Initialize DeadKeyChar Variable
  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
  // Standards Symbols

  DeadKeyChars := '`~!@#$%^+*-_=+\|"/;:,./?><()[]{}' + #39;

  // English Numbers + Letters
  DeadKeyChars := DeadKeyChars + '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

  // Bangla Numbers
  DeadKeyChars := DeadKeyChars + b_0 + b_1 + b_2 + b_3 + b_4 + b_5 + b_6 + b_7 + b_8 + b_9;

  // Bangla Vowels + Kars
  DeadKeyChars := DeadKeyChars + b_A + b_AA + b_AAkar + b_I + b_II + b_IIkar + b_Ikar + b_U + b_Ukar + b_UU + b_UUkar + b_RRI + b_RRIkar + b_E + b_Ekar + b_O +
    b_OI + b_OIkar + b_Okar + b_OU + b_OUkar;

  // Bangla Unusual Vowels + Kars
  DeadKeyChars := DeadKeyChars + b_Vocalic_L + b_Vocalic_LL + b_Vocalic_RR + b_Vocalic_RR_Kar + b_Vocalic_L_Kar + b_Vocalic_LL_Kar;

  // Bangla Symbols/Signs
  DeadKeyChars := DeadKeyChars + b_Anushar + b_Bisharga + b_Khandatta + b_Dari + b_Taka;

  // Bangla Unusal Symbols/Signs
  DeadKeyChars := DeadKeyChars + b_LengthMark + b_RupeeMark + b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 + b_CurrencyNumerator4 +
    b_CurrencyNumerator1LessThanDenominator + b_CurrencyDenominator16;

  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
  // End Initialize DeadKeyChar Variable
  // :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=

  ResetLastChar;

  // If IsWinVistaOrLater Then
  DetermineZWNJ_ZWJ := ZWJ;
  // Else
  // DetermineZWNJ_ZWJ := ZWNJ;

  Bijoy := TUnicodeToBijoy2000.Create;
end;

{ =============================================================================== }

procedure TGenericLayoutModern.DeleteLastCharSteps_Ex(StepCount: Integer);
var
  I, J: Integer;
  t1:   string;
begin

  for I := TrackL downto 1 do
    t1 := t1 + LastChars[I];

  if StepCount > TrackL then
    StepCount := TrackL;

  t1 := StringOfChar(' ', StepCount) + LeftStr(t1, Length(t1) - StepCount);

  for I := TrackL downto 1 do
  begin
    J := TrackL + 1 - I;
    LastChars[I] := MidStr(t1, J, 1);
  end;
  LastChar := LastChars[1];
end;

{ =============================================================================== }

destructor TGenericLayoutModern.Destroy;
begin
  FreeAndNil(Bijoy);

  inherited;
end;

{ =============================================================================== }

procedure TGenericLayoutModern.DoBackspace(var Block: Boolean);
var
  BijoyNewBanglaText: string;
begin

  if (Length(PrevBanglaT) - 1) <= 0 then
  begin

    if OutputIsBijoy <> 'YES' then
    begin
      if (Length(NewBanglaText) - 1) >= 1 then
        Backspace(Length(NewBanglaText) - 1);
    end
    else
    begin
      BijoyNewBanglaText := Bijoy.Convert(NewBanglaText);
      if (Length(BijoyNewBanglaText) - 1) >= 1 then
        Backspace(Length(BijoyNewBanglaText) - 1);
    end;

    ResetDeadKey;
    Block := False;
  end
  else
  begin
    Block := True;
    InternalBackspace;
    // ParseAndSendNow;
  end;
end;

{ =============================================================================== }

function TGenericLayoutModern.InsertKar(const sKar: string): string;
begin
  if AutomaticallyFixChandra = 'YES' then
  begin
    if LastChar = b_Chandra then
    begin
      InternalBackspace;
      InsertKar := sKar + b_Chandra;
    end
    else
      InsertKar := sKar;
  end
  else
    InsertKar := sKar;

end;

{ =============================================================================== }
{$HINTS Off}

function TGenericLayoutModern.InsertReph: string;
var
  RephMoveable: Boolean;
  TmpStr:       string;
  I, J:         Integer;
begin
  RephMoveable := False;

  if OldStyleReph = 'NO' then
    RephMoveable := False
  else
  begin

    if IsPureConsonent(LastChar) = True then
      RephMoveable := True
    else if IsKar(LastChar) = True then
    begin
      if IsPureConsonent(LastChars[2]) = True then
        RephMoveable := True
      else
        RephMoveable := False;
    end
    else if (LastChar = b_Chandra) then
    begin
      if IsPureConsonent(LastChars[2]) then
        RephMoveable := True
      else if ((IsKar(LastChars[2]) = True) and (IsPureConsonent(LastChars[3]) = True)) then
        RephMoveable := True
      else
        RephMoveable := False;
    end
    else
      RephMoveable := False;
  end;

  if not RephMoveable then
  begin
    InsertReph := b_R + b_Hasanta;
    Exit;
  end
  else
  begin
    I := 1;
    if ((IsKar(LastChar) = True) and (IsPureConsonent(LastChars[I + 1]) = True)) then
      I := I + 1
    else if LastChar = b_Chandra then
    begin
      if IsPureConsonent(LastChars[I + 1]) then
        I := I + 1
      else if ((IsKar(LastChars[I + 1]) = True) and (IsPureConsonent(LastChars[I + 2]) = True)) then
        I := I + 2;
    end;

    repeat
      if LastChars[I + 1] = b_Hasanta then
      begin
        if IsPureConsonent(LastChars[I + 2]) = True then
          I := I + 2
        else
        begin
          for J := I downto 1 do
            TmpStr := TmpStr + LastChars[J];

          InternalBackspace(I);
          InsertReph := b_R + b_Hasanta + TmpStr;
          Exit;
        end;
      end
      else
      begin
        for J := I downto 1 do
          TmpStr := TmpStr + LastChars[J];
        InternalBackspace(I);
        InsertReph := b_R + b_Hasanta + TmpStr;
        Exit;
      end;
    until (I >= TrackL);

  end;
end;

{ =============================================================================== }

procedure TGenericLayoutModern.InternalBackspace(KeyRepeat: Integer);
begin
  if KeyRepeat <= 0 then
    KeyRepeat := 1;
  if KeyRepeat > TrackL then
    KeyRepeat := TrackL;

  NewBanglaText := MidStr(PrevBanglaT, 1, Length(PrevBanglaT) - KeyRepeat);
  DeleteLastCharSteps_Ex(KeyRepeat);

end;

{$HINTS ON}
{ =============================================================================== }

{$HINTS Off}

function TGenericLayoutModern.IsDeadKeyChar(const CheckS: string): Boolean;
begin
  Result := False;

  if CheckS = '' then
  begin
    IsDeadKeyChar := False;
    Exit;
  end;

  // Check only the most right letter
  if pos(string(RightStr(CheckS, 1)), DeadKeyChars) > 0 then
    IsDeadKeyChar := True
  else
    IsDeadKeyChar := False;

end;
{$HINTS ON}
{ =============================================================================== }

function TGenericLayoutModern.MyProcessVKeyDown(const KeyCode: Integer; var Block: Boolean; const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): string;
var
  CharForKey: string;
begin

  if AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault then
  begin
    Block := False;
    MyProcessVKeyDown := '';
    Exit;
  end
  else if AvroMainForm1.GetMyCurrentKeyboardMode = bangla then
  begin
    CharForKey := GetCharForKey(KeyCode, var_IfShift, var_IfTrueShift, var_IfAltGr);

    if VowelFormating = 'NO' then
      DeadKey := False;

    if DeadKey then
    begin
      if CharForKey = b_AAkar then
      begin
        MyProcessVKeyDown := b_AA;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Ikar then
      begin
        MyProcessVKeyDown := b_I;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_IIkar then
      begin
        MyProcessVKeyDown := b_II;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Ukar then
      begin
        MyProcessVKeyDown := b_U;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_UUkar then
      begin
        MyProcessVKeyDown := b_UU;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_RRIkar then
      begin
        MyProcessVKeyDown := b_RRI;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Ekar then
      begin
        MyProcessVKeyDown := b_E;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_OIkar then
      begin
        MyProcessVKeyDown := b_OI;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Okar then
      begin
        MyProcessVKeyDown := b_O;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_OUkar then
      begin
        MyProcessVKeyDown := b_OU;
        DeadKey := True;
        Exit;
      end
      // ElseIf KeyCode = VK_LSHIFT Or KeyCode = VK_RSHIFT Or KeyCode = VK_CAPITAL Or KeyCode = VK_NUMLOCK Or KeyCode = VK_LCONTROL Or KeyCode = VK_RCONTROL Or KeyCode = VK_CONTROL Or KeyCode = VK_MENU Or KeyCode = VK_LMENU Or KeyCode = VK_RMENU Then
      // DeadKey = True
      // MyProcessVKeyDown = ""
      // Block = False
      // Exit Function
      else
        DeadKey := False;
    end;

    if LastChar = b_Hasanta then
    begin
      if CharForKey = b_AAkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_AA;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Ikar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_I;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_IIkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_II;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Ukar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_U;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_UUkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_UU;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_RRIkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_RRI;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Ekar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_E;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_OIkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_OI;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Okar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_O;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_OUkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := b_OU;
        DeadKey := True;
        Exit;
      end
      else if CharForKey = b_Hasanta then
      begin
        MyProcessVKeyDown := ZWNJ;
        DeadKey := True;
        Exit;
      end;
    end;

    case KeyCode of
      VK_RETURN:
        begin
          Block := False;
          DeadKey := True;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        end;
      VK_SPACE:
        begin
          Block := False;
          DeadKey := True;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        end;
      VK_TAB:
        begin
          Block := False;
          DeadKey := True;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        end;
      VK_BACK:
        begin
          DoBackspace(Block);
          MyProcessVKeyDown := '';
          Exit;
        end;
      else
        begin
          if CharForKey = b_R + b_Hasanta then
          begin
            MyProcessVKeyDown := InsertReph;
            Exit;
          end
          else if CharForKey = '' then
          begin
            DeadKey := False;
            Block := False;
            MyProcessVKeyDown := '';
            ResetLastChar;
            Exit;
          end
          else if CharForKey = b_Hasanta + b_Z then
          begin
            if (LastChar = b_R) and (LastChars[2] <> b_Hasanta) then
            begin
              MyProcessVKeyDown := DetermineZWNJ_ZWJ + b_Hasanta + b_Z;
              Exit;
            end
            else
            begin
              MyProcessVKeyDown := b_Hasanta + b_Z;
              Exit;
            end;
          end
          else
          begin
            if IsDeadKeyChar(CharForKey) then
            begin
              if IsKar(CharForKey) then
              begin
                DeadKey := True;
                MyProcessVKeyDown := InsertKar(CharForKey);
                Exit;
              end
              else
              begin
                DeadKey := True;
                MyProcessVKeyDown := CharForKey;
                Exit;
              end;
            end
            else
            begin
              MyProcessVKeyDown := CharForKey;
              Exit;
            end;
          end;
        end;
    end;
  end;
end;

{ =============================================================================== }

procedure TGenericLayoutModern.MyProcessVKeyUP(const KeyCode: Integer; var Block: Boolean; const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean);
var
  CharForKey: string;
begin
  if AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault then
  begin

    Block := False;
    Exit;
  end
  else if AvroMainForm1.GetMyCurrentKeyboardMode = bangla then
  begin

    CharForKey := GetCharForKey(KeyCode, var_IfShift, var_IfTrueShift, var_IfAltGr);

    if CharForKey = '' then
      Block := False
    else
    begin
      Block := True;
      Exit;
    end;

  end;
end;

{ =============================================================================== }

procedure TGenericLayoutModern.ParseAndSendNow;
var
  I, Matched, UnMatched:                Integer;
  BijoyPrevBanglaT, BijoyNewBanglaText: string;
begin
  Matched := 0;

  if OutputIsBijoy <> 'YES' then
  begin
    { Output to Unicode }
    if PrevBanglaT = '' then
    begin
      SendKey_Char(NewBanglaText);
      PrevBanglaT := NewBanglaText;
    end
    else
    begin
      for I := 1 to Length(PrevBanglaT) do
      begin
        if MidStr(PrevBanglaT, I, 1) = MidStr(NewBanglaText, I, 1) then
          Matched := Matched + 1
        else
          Break;
      end;
      UnMatched := Length(PrevBanglaT) - Matched;

      if UnMatched >= 1 then
        Backspace(UnMatched);
      SendKey_Char(MidStr(NewBanglaText, Matched + 1, Length(NewBanglaText)));
      PrevBanglaT := NewBanglaText;
    end;

  end
  else
  begin
    { Output to Bijoy }
    BijoyPrevBanglaT := Bijoy.Convert(PrevBanglaT);
    BijoyNewBanglaText := Bijoy.Convert(NewBanglaText);

    if BijoyPrevBanglaT = '' then
    begin
      SendKey_Char(BijoyNewBanglaText);
      PrevBanglaT := NewBanglaText;
    end
    else
    begin
      for I := 1 to Length(BijoyPrevBanglaT) do
      begin
        if MidStr(BijoyPrevBanglaT, I, 1) = MidStr(BijoyNewBanglaText, I, 1) then
          Matched := Matched + 1
        else
          Break;
      end;
      UnMatched := Length(BijoyPrevBanglaT) - Matched;

      if UnMatched >= 1 then
        Backspace(UnMatched);
      SendKey_Char(MidStr(BijoyNewBanglaText, Matched + 1, Length(BijoyNewBanglaText)));
      PrevBanglaT := NewBanglaText;
    end;

  end;
end;

{ =============================================================================== }

function TGenericLayoutModern.ProcessVKeyDown(const KeyCode: Integer; var Block: Boolean): string;
var
  m_Block: Boolean;
  m_Str:   string;
begin
  m_Block := False;

  if (IfWinKey = True) or (IfOnlyCtrlKey = True) or (IfOnlyLeftAltKey = True) then
  begin
    Block := False;
    ProcessVKeyDown := '';
    Exit;
  end;

  if IfIgnorableModifierKey(KeyCode) then
  begin
    Block := False;
    ProcessVKeyDown := '';
    Exit;
  end;

  m_Str := MyProcessVKeyDown(KeyCode, m_Block, IfShift, IfTrueShift, IfAltGr);
  if m_Str <> '' then
  begin
    m_Block := True;
    SetLastChar(m_Str);
  end;

  NewBanglaText := NewBanglaText + m_Str;
  ParseAndSendNow;

  Block := m_Block;
  ProcessVKeyDown := '';
end;

{ =============================================================================== }

procedure TGenericLayoutModern.ProcessVKeyUP(const KeyCode: Integer; var Block: Boolean);
begin
  if ((IfWinKey = True) or (IfOnlyCtrlKey = True) or (IfOnlyLeftAltKey = True)) then
  begin
    Block := False;
    Exit;
  end;

  if IfIgnorableModifierKey(KeyCode) = True then
  begin
    Block := False;
    Exit;
  end;

  MyProcessVKeyUP(KeyCode, Block, IfShift, IfTrueShift, IfAltGr);
end;

{ =============================================================================== }

procedure TGenericLayoutModern.ResetDeadKey;
begin
  DeadKey := False;
  ResetLastChar;
end;

{ =============================================================================== }

procedure TGenericLayoutModern.ResetLastChar;
var
  I: Integer;
begin
  for I := 1 to TrackL do
    LastChars[I] := ' ';

  LastChar := ' ';
  PrevBanglaT := '';
  NewBanglaText := '';
end;

{ =============================================================================== }

procedure TGenericLayoutModern.SetLastChar(const wChar: string);
var
  t1, t2: string;
  I, J:   Integer;
begin
  for I := TrackL downto 1 do
    t1 := t1 + LastChars[I];

  t1 := t1 + wChar;
  t2 := RightStr(t1, TrackL);

  for I := TrackL downto 1 do
  begin
    J := TrackL + 1 - I;
    LastChars[I] := MidStr(t2, J, 1);
  end;
  LastChar := LastChars[1];
end;

{ =============================================================================== }

end.
