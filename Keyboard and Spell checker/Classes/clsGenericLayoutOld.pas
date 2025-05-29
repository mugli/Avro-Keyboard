{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit clsGenericLayoutOld;

interface

uses
  classes,
  sysutils,
  StrUtils,
  clsUnicodeToBijoy2000;

const
  TrackL = 100;

  // Skeleton of Class TGenericLayoutOld
type
  TGenericLayoutOld = class
    private
      Bijoy:                      TUnicodeToBijoy2000;
      LastChar:                   string;
      DetermineZWNJ_ZWJ:          string;
      LastChars:                  array [1 .. TrackL] of string;
      PrevBanglaT, NewBanglaText: string;

      // Kar Variables for Full Old Style Typing
      EKarActive, IKarActive, OIKarActive: Boolean;

      procedure InternalBackspace(KeyRepeat: Integer = 1);
      procedure DoBackspace(var Block: Boolean);
      procedure ParseAndSendNow;
      function InsertKar(const sKar: string): string;
      function InsertReph: string;
      procedure SetLastChar(const wChar: string);
      procedure DeleteLastCharSteps_Ex(StepCount: Integer);
      procedure ResetLastChar;
      function MyProcessVKeyDown(const KeyCode: Integer; var Block: Boolean; const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): string;
      procedure MyProcessVKeyUP(const KeyCode: Integer; var Block: Boolean; const var_IfShift: Boolean; const var_IfTrueShift: Boolean;
        const var_IfAltGr: Boolean);
      procedure ResetAllKarsToInactive;
    public
      constructor Create;           // Initializer
      destructor Destroy; override; // Destructor

      function ProcessVKeyDown(const KeyCode: Integer; var Block: Boolean): string;
      procedure ProcessVKeyUP(const KeyCode: Integer; var Block: Boolean);
      procedure ResetDeadKey;
  end;

implementation

uses
  Banglachars,
  KeyboardFunctions,
  uForm1,
  KeyboardLayoutLoader,
  clsLayout,
  VirtualKeycode,
  WindowsVersion,
  uRegistrySettings;

{ =============================================================================== }

{ TGenericLayoutOld }

constructor TGenericLayoutOld.Create;
begin
  inherited;
  ResetLastChar;

  // If IsWinVistaOrLater Then
  DetermineZWNJ_ZWJ := ZWJ;
  // Else
  // DetermineZWNJ_ZWJ := ZWNJ;

  Bijoy := TUnicodeToBijoy2000.Create;
end;

{ =============================================================================== }

procedure TGenericLayoutOld.DeleteLastCharSteps_Ex(StepCount: Integer);
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

destructor TGenericLayoutOld.Destroy;
begin
  FreeAndNil(Bijoy);

  inherited;
end;

{ =============================================================================== }

procedure TGenericLayoutOld.DoBackspace(var Block: Boolean);
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

function TGenericLayoutOld.InsertKar(const sKar: string): string;
begin
  if LastChar = b_Chandra then
  begin
    if LastChars[2] = b_Ekar then
    begin
      if sKar = b_AAkar then
      begin
        InternalBackspace(2);
        InsertKar := b_Okar + b_Chandra;
      end
      else if sKar = b_LengthMark then
      begin
        InternalBackspace(2);
        InsertKar := b_OUkar + b_Chandra;
      end
      else
        InsertKar := sKar;
    end
    else
    begin
      InsertKar := sKar;
    end;
  end
  else
    InsertKar := sKar;
end;

{ =============================================================================== }
{$HINTS Off}

function TGenericLayoutOld.InsertReph: string;
var
  RephMoveable: Boolean;
  TmpStr:       string;
  I, J:         Integer;
begin
  RephMoveable := False;

  if IsPureConsonent(LastChar) = True then
    RephMoveable := True
  else if IsKar(LastChar) = True then
  begin
    if IsPureConsonent(LastChars[2]) then
      RephMoveable := True
    else
      RephMoveable := False;
  end
  else if LastChar = b_Chandra then
  begin
    if IsPureConsonent(LastChars[2]) = True then
      RephMoveable := True
    else if (IsKar(LastChars[2]) = True) and (IsPureConsonent(LastChars[3]) = True) then
      RephMoveable := True
    else
      RephMoveable := False;
  end
  else
    RephMoveable := False;

  if not RephMoveable then
  begin
    InsertReph := b_R + b_Hasanta;
    Exit;
  end
  else
  begin
    I := 1;

    if (IsKar(LastChar) = True) and (IsPureConsonent(LastChars[I + 1]) = True) then
      I := I + 1
    else if LastChar = b_Chandra then
    begin
      if IsPureConsonent(LastChars[I + 1]) = True then
        I := I + 1
      else if (IsKar(LastChars[I + 1]) = True) and (IsPureConsonent(LastChars[I + 2]) = True) then
        I := I + 2;
    end;

    repeat
      if LastChars[I + 1] = b_Hasanta then
      begin
        if IsPureConsonent(LastChars[I + 2]) then
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
    until I >= TrackL;

  end;
end;

{ =============================================================================== }

procedure TGenericLayoutOld.InternalBackspace(KeyRepeat: Integer);
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

function TGenericLayoutOld.MyProcessVKeyDown(const KeyCode: Integer; var Block: Boolean; const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): string;
var
  CharForKey, tmpString, PendingKar: string;
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

    if LastChar = b_Hasanta then
    begin

      if EKarActive then
        PendingKar := b_Ekar
      else if IKarActive then
        PendingKar := b_Ikar
      else if OIKarActive then
        PendingKar := b_OIkar
      else
        PendingKar := '';

      if CharForKey = b_AAkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_AA;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_Ikar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_I;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_IIkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_II;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_Ukar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_U;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_UUkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_UU;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_RRIkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_RRI;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_Ekar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_E;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_OIkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_OI;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_Okar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_O;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_OUkar then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_OU;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_LengthMark then
      begin
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(PendingKar) + b_OU;
        ResetAllKarsToInactive;
        Exit;
      end
      else if CharForKey = b_Hasanta then
      begin
        MyProcessVKeyDown := ZWNJ;
        ResetAllKarsToInactive;
        Exit;
      end;
    end;

    if CharForKey = b_Ekar then
    begin
      if EKarActive = True then
      begin
        EKarActive := False;
        MyProcessVKeyDown := b_Ekar;
        Exit;
      end
      else
      begin
        ResetAllKarsToInactive;
        EKarActive := True;
        Block := True;
        MyProcessVKeyDown := '';
        Exit;
      end;
    end;

    if CharForKey = b_Ikar then
    begin
      if IKarActive = True then
      begin
        IKarActive := False;
        MyProcessVKeyDown := b_Ikar;
        Exit;
      end
      else
      begin
        ResetAllKarsToInactive;
        IKarActive := True;
        Block := True;
        MyProcessVKeyDown := '';
        Exit;
      end;
    end;

    if CharForKey = b_OIkar then
    begin
      if OIKarActive = True then
      begin
        OIKarActive := False;
        MyProcessVKeyDown := b_OIkar;
        Exit;
      end
      else
      begin
        ResetAllKarsToInactive;
        OIKarActive := True;
        Block := True;
        MyProcessVKeyDown := '';
        Exit;
      end;
    end;

    if CharForKey = b_AAkar then
    begin
      if LastChar = b_Ekar then
      begin
        ResetAllKarsToInactive;
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(b_Okar);
        Exit;
      end;
    end;

    if CharForKey = b_LengthMark then
    begin
      if LastChar = b_Ekar then
      begin
        ResetAllKarsToInactive;
        InternalBackspace;
        MyProcessVKeyDown := InsertKar(b_OUkar);
        Exit;
      end;
    end;

    if CharForKey = b_Hasanta then
    begin
      if LastChar = b_Ekar then
      begin
        InternalBackspace;
        EKarActive := True;
        MyProcessVKeyDown := b_Hasanta;
        Exit;
      end
      else if LastChar = b_Ikar then
      begin
        InternalBackspace;
        IKarActive := True;
        MyProcessVKeyDown := b_Hasanta;
        Exit;
      end
      else if LastChar = b_OIkar then
      begin
        InternalBackspace;
        OIKarActive := True;
        MyProcessVKeyDown := b_Hasanta;
        Exit;
      end
      else
      begin
        MyProcessVKeyDown := b_Hasanta;
        Exit;
      end;
    end;

    case KeyCode of
      VK_RETURN:
        begin
          Block := False;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        end;
      VK_SPACE:
        begin
          Block := False;
          ResetLastChar;
          MyProcessVKeyDown := '';
          Exit;
        end;
      VK_TAB:
        begin
          Block := False;
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
          if EKarActive = True then
          begin
            if CharForKey = b_R + b_Hasanta then
            begin
              EKarActive := False;
              MyProcessVKeyDown := InsertReph + InsertKar(b_Ekar);
              Exit;
            end
            else if CharForKey = b_AAkar then
            begin
              EKarActive := False;
              MyProcessVKeyDown := InsertKar(b_Okar);
              Exit;
            end
            else if CharForKey = b_LengthMark then
            begin
              EKarActive := False;
              MyProcessVKeyDown := InsertKar(b_OUkar);
              Exit;
            end
            else if CharForKey = '' then
            begin
              ResetLastChar;
              Block := False;
              MyProcessVKeyDown := '';
              Exit;
            end
            else
            begin
              EKarActive := False;
              MyProcessVKeyDown := CharForKey + InsertKar(b_Ekar);
              Exit;
            end;
          end
          else if IKarActive = True then
          begin
            if CharForKey = b_R + b_Hasanta then
            begin
              IKarActive := False;
              MyProcessVKeyDown := InsertReph + InsertKar(b_Ikar);
              Exit;
            end
            else if CharForKey = '' then
            begin
              ResetLastChar;
              Block := False;
              MyProcessVKeyDown := '';
              Exit;
            end
            else
            begin
              IKarActive := False;
              MyProcessVKeyDown := CharForKey + InsertKar(b_Ikar);
              Exit;
            end;
          end
          else if OIKarActive = True then
          begin
            if CharForKey = b_R + b_Hasanta then
            begin
              OIKarActive := False;
              MyProcessVKeyDown := InsertReph + InsertKar(b_OIkar);
              Exit;
            end
            else if CharForKey = '' then
            begin
              ResetLastChar;
              Block := False;
              MyProcessVKeyDown := '';
              Exit;
            end
            else
            begin
              OIKarActive := False;
              MyProcessVKeyDown := CharForKey + InsertKar(b_OIkar);
              Exit;
            end;
          end
          else
          begin
            if CharForKey = b_R + b_Hasanta then
            begin
              MyProcessVKeyDown := InsertReph;
              Exit;
            end
            else if CharForKey = b_AAkar then
            begin
              if LastChar = b_A then
              begin
                InternalBackspace;
                MyProcessVKeyDown := b_AA;
                Exit;
              end
              else
              begin
                MyProcessVKeyDown := b_AAkar;
                Exit;
              end;
            end
            else if CharForKey = b_Hasanta + b_Z then
            begin

              if (LastChar = b_R) and (LastChars[2] <> b_Hasanta) then
              begin
                MyProcessVKeyDown := DetermineZWNJ_ZWJ + b_Hasanta + b_Z;
                Exit;
              end
              else if IsKar(LastChar) then
              begin
                if (LastChars[2] = b_R) and (LastChars[3] <> b_Hasanta) then
                begin
                  tmpString := LastChar;
                  InternalBackspace;
                  MyProcessVKeyDown := DetermineZWNJ_ZWJ + CharForKey + tmpString;
                  Exit;
                end
                else
                begin
                  tmpString := LastChar;
                  InternalBackspace;
                  MyProcessVKeyDown := CharForKey + tmpString;
                  Exit;
                end;
              end
              else
              begin
                MyProcessVKeyDown := b_Hasanta + b_Z;
                Exit;
              end;

            end
            else if CharForKey = '' then
            begin
              ResetLastChar;
              Block := False;
              MyProcessVKeyDown := '';
              Exit;
            end
            else
            begin
              if (Length(CharForKey) > 1) and (LeftStr(CharForKey, 1) = b_Hasanta) then
              begin
                if IsKar(LastChar) then
                begin
                  tmpString := LastChar;
                  InternalBackspace;
                  MyProcessVKeyDown := CharForKey + tmpString;
                  Exit;
                end;
              end;

              if IsKar(CharForKey) then
              begin
                MyProcessVKeyDown := InsertKar(CharForKey);
                Exit;
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

end;

{ =============================================================================== }

procedure TGenericLayoutOld.MyProcessVKeyUP(const KeyCode: Integer; var Block: Boolean; const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean);
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
    begin
      Block := False;
      Exit;
    end
    else
    begin
      Block := True;
      Exit;
    end;
  end;

end;

{ =============================================================================== }

procedure TGenericLayoutOld.ParseAndSendNow;
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

function TGenericLayoutOld.ProcessVKeyDown(const KeyCode: Integer; var Block: Boolean): string;
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

procedure TGenericLayoutOld.ProcessVKeyUP(const KeyCode: Integer; var Block: Boolean);
begin
  if (IfWinKey = True) or (IfOnlyCtrlKey = True) or (IfOnlyLeftAltKey = True) then
  begin
    Block := False;
    Exit;
  end;

  if IfIgnorableModifierKey(KeyCode) = True then
  begin
    Block := False;
    Exit;
  end;

  // If BlockedLast Then
  // Block = True
  // Else
  // Block = False
  // End If

  MyProcessVKeyUP(KeyCode, Block, IfShift, IfTrueShift, IfAltGr);
end;

{ =============================================================================== }

procedure TGenericLayoutOld.ResetAllKarsToInactive;
begin
  EKarActive := False;
  IKarActive := False;
  OIKarActive := False;
end;

{ =============================================================================== }

procedure TGenericLayoutOld.ResetDeadKey;
begin
  ResetLastChar;
end;

{ =============================================================================== }

procedure TGenericLayoutOld.ResetLastChar;
var
  I: Integer;
begin
  for I := 1 to TrackL do
    LastChars[I] := ' ';

  LastChar := ' ';
  ResetAllKarsToInactive;
  PrevBanglaT := '';
  NewBanglaText := '';
end;

{ =============================================================================== }

procedure TGenericLayoutOld.SetLastChar(const wChar: string);
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
