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
{ COMPLETE TRANSFERING }

Unit clsE2BCharBased;

Interface

Uses
  classes,
  sysutils,
  StrUtils,
  clsEnglishToBangla,
  clsPhoneticRegExBuilder,
  Generics.Collections,
  clsAbbreviation,
  clsUnicodeToBijoy2000;

Const
  Max_EnglishLength = 50;
  Max_RegExQueryLength = 5000;

Type
  TPhoneticCache = Record
    EnglishT: String;
    Results: TStringList;
  End;

  // Skeleton of Class TE2BCharBased
Type
  TE2BCharBased = Class
  Private
    Parser: TEnglishToBangla;
    RegExBuilder: TEnglishToRegEx;
    Abbreviation: TAbbreviation;
    Bijoy: TUnicodeToBijoy2000;
    EnglishT: String;
    PrevBanglaT: String;
    BlockLast: boolean;
    WStringList: TStringList;
    NewBanglaText: String;
    FAutoCorrect: boolean;
    CandidateDict: TDictionary<String, String>;
    ManuallySelectedCandidate: boolean;
    DetermineZWNJ_ZWJ: String;
    PhoneticCache: Array [1 .. Max_EnglishLength] Of TPhoneticCache;

    Procedure Fix_ZWNJ_ZWJ(Var rList: TStringList);
    Procedure ProcessSpace(Var Block: boolean);
    Procedure ParseAndSend;
    Procedure ParseAndSendNow;
    Procedure ProcessEnter(Var Block: boolean);
    Procedure DoBackspace(Var Block: boolean);
    Procedure MyProcessVKeyDown(Const KeyCode: Integer; Var Block: boolean;
      Const var_IfShift: boolean; Const var_IfTrueShift: boolean);
    Procedure AddStr(Const Str: String);

    Procedure LoadCandidateOptions;
    Procedure SaveCandidateOptions;
    Procedure UpdateCandidateOption;

    Procedure AddToCache(Const MiddleMain_T: String; Var rList: TStringList);
    Procedure AddSuffix(Const MiddleMain_T: String; Var rList: TStringList);

    Procedure CutText(Const inputEStr: String; Var outSIgnore: String;
      Var outMidMain: String; Var outEIgnore: String);
    Procedure PadResults(Const Starting_Ignoreable_T, Ending_Ignorable_T
      : String; Var rList: TStringList);
    Function EscapeSpecialCharacters(Const inputT: String): String;

    Procedure SetAutoCorrectEnabled(Const Value: boolean);
    Function GetAutoCorrectEnabled: boolean;

  Public
    Constructor Create; // Initializer
    Destructor Destroy; Override; // Destructor

    Function ProcessVKeyDown(Const KeyCode: Integer;
      Var Block: boolean): String;
    Procedure ProcessVKeyUP(Const KeyCode: Integer; Var Block: boolean);
    Procedure ResetDeadKey;
    Procedure SelectCandidate(Const Item: String);
    // Published
    Property AutoCorrectEnabled: boolean Read GetAutoCorrectEnabled
      Write SetAutoCorrectEnabled;
  End;

Implementation

Uses
  KeyboardFunctions,
  VirtualKeyCode,
  uForm1,
  clsLayout,
  uRegistrySettings,
  ufrmPrevW,
  uSimilarSort,
  uRegExPhoneticSearch,
  uFileFolderHandling,
  BanglaChars,
  uDBase,
  WindowsVersion;

{ TE2BCharBased }

{ =============================================================================== }

Procedure TE2BCharBased.AddStr(Const Str: String);
Begin
  EnglishT := EnglishT + Str;

  ParseAndSend;

  If ShowPrevWindow = 'YES' Then
    frmPrevW.UpdateMe(EnglishT)
  Else
    frmPrevW.MakeMeHide;

End;

{ =============================================================================== }

Procedure TE2BCharBased.AddSuffix(Const MiddleMain_T: String;
  Var rList: TStringList);
Var
  iLen, J, K: Integer;
  isSuffix: String;
  B_Suffix: String;
  TempList: TStringList;
Begin
  iLen := Length(MiddleMain_T);
  rList.Sorted := True;
  rList.Duplicates := dupIgnore;

  If iLen >= 2 Then
  Begin
    TempList := TStringList.Create;
    For J := 2 To iLen Do
    Begin
      isSuffix := LowerCase(MidStr(MiddleMain_T, J, iLen));

      If suffix.TryGetValue(isSuffix, B_Suffix) Then
      Begin
        If PhoneticCache[iLen - Length(isSuffix)].Results.Count > 0 Then
        Begin
          For K := 0 To PhoneticCache[iLen - Length(isSuffix)
            ].Results.Count - 1 Do
          Begin
            If IsVowel(RightStr(PhoneticCache[iLen - Length(isSuffix)
              ].Results[K], 1)) And (IsKar(LeftStr(B_Suffix, 1))) Then
            Begin
              TempList.Add(PhoneticCache[iLen - Length(isSuffix)].Results[K] +
                b_Y + B_Suffix);
            End
            Else
            Begin
              If RightStr(PhoneticCache[iLen - Length(isSuffix)].Results[K], 1)
                = b_Khandatta Then
                TempList.Add(MidStr(PhoneticCache[iLen - Length(isSuffix)
                  ].Results[K], 1, Length(PhoneticCache[iLen - Length(isSuffix)
                  ].Results[K]) - 1) + b_T + B_Suffix)
              Else If RightStr(PhoneticCache[iLen - Length(isSuffix)
                ].Results[K], 1) = b_Anushar Then
                TempList.Add(MidStr(PhoneticCache[iLen - Length(isSuffix)
                  ].Results[K], 1, Length(PhoneticCache[iLen - Length(isSuffix)
                  ].Results[K]) - 1) + b_NGA + B_Suffix)
              Else
                TempList.Add(PhoneticCache[iLen - Length(isSuffix)].Results[K] +
                  B_Suffix);
            End;
          End;
        End;
      End;
    End;

    For J := 0 To TempList.Count - 1 Do
    Begin
      rList.Add(TempList[J]);
    End;

    TempList.Clear;
    FreeAndNil(TempList);
  End;
End;

{ =============================================================================== }

Procedure TE2BCharBased.AddToCache(Const MiddleMain_T: String;
  Var rList: TStringList);
Var
  iLen: Integer;
Begin
  iLen := Length(MiddleMain_T);
  PhoneticCache[iLen].EnglishT := MiddleMain_T;
  PhoneticCache[iLen].Results.Clear;
  PhoneticCache[iLen].Results.Assign(rList);
End;

{ =============================================================================== }

Constructor TE2BCharBased.Create;
Var
  I: Integer;
Begin
  Inherited;
  Parser := TEnglishToBangla.Create;
  Abbreviation := TAbbreviation.Create;
  Bijoy := TUnicodeToBijoy2000.Create;
  RegExBuilder := TEnglishToRegEx.Create;
  WStringList := TStringList.Create;
  CandidateDict := TDictionary<String, String>.Create;
  LoadCandidateOptions;

  For I := Low(PhoneticCache) To High(PhoneticCache) Do
  Begin
    PhoneticCache[I].Results := TStringList.Create;
  End;

  // If IsWinVistaOrLater Then
  DetermineZWNJ_ZWJ := ZWJ;
  // Else
  // DetermineZWNJ_ZWJ := ZWNJ;

End;

{ =============================================================================== }

Procedure TE2BCharBased.CutText(Const inputEStr: String;
  Var outSIgnore, outMidMain, outEIgnore: String);
Var
  I: Integer;
  p, q: Integer;
  EStrLen: Integer;
  tStr: Char;
  reverse_inputEStr: String;
  temporaryString: String;
Begin

  tStr := #0;
  p := 0;

  EStrLen := Length(inputEStr);
  // Start Cutting outSIgnore
  For I := 1 To EStrLen Do
  Begin

    temporaryString := MidStr(inputEStr, I, 1);
    If Length(temporaryString) > 0 Then
      tStr := temporaryString[1];

    Case tStr Of
      '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']',
        '{', '}', #39, '"', ';', '<', '>', '/', '?', '|', '\', '.':

        p := I;

      ',':
        p := I;

      ':':
        Break;

      '`':
        p := I
    Else
      Break;
    End;
  End;

  outSIgnore := LeftStr(inputEStr, p);
  // End Cutting outSIgnore

  // Start Cutting outEIgnore
  tStr := #0;
  q := 0;

  reverse_inputEStr := ReverseString(inputEStr);
  For I := 1 To EStrLen - p Do
  Begin
    temporaryString := MidStr(reverse_inputEStr, I, 1);
    If Length(temporaryString) > 0 Then
      tStr := temporaryString[1];

    Case tStr Of
      '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']',
        '{', '}', #39, #34, ';', '<', '>', '/', '.', '?', '|', '\':
        q := I;
      ',':
        q := I;

      '`':
        q := I;

      ':':
        q := I;

    Else
      Break;
    End;
  End;

  outEIgnore := RightStr(inputEStr, q);
  // End Cutting outEIgnore

  // Start Cutting outMidMain
  temporaryString := MidStr(inputEStr, p + 1, Length(inputEStr));
  temporaryString := LeftStr(temporaryString, Length(temporaryString) - q);
  outMidMain := temporaryString;

End;

{ =============================================================================== }

Destructor TE2BCharBased.Destroy;
Var
  I: Integer;
Begin
  WStringList.Clear;
  FreeAndNil(WStringList);
  FreeAndNil(Bijoy);
  FreeAndNil(Parser);
  FreeAndNil(RegExBuilder);
  FreeAndNil(Abbreviation);
  If SaveCandidate = 'YES' Then
    SaveCandidateOptions;
  FreeAndNil(CandidateDict);

  For I := Low(PhoneticCache) To High(PhoneticCache) Do
  Begin
    PhoneticCache[I].Results.Clear;
    PhoneticCache[I].Results.Free;
  End;

  Inherited;
End;

{ =============================================================================== }

Procedure TE2BCharBased.DoBackspace(Var Block: boolean);
Var
  BijoyNewBanglaText: String;
Begin

  If (Length(EnglishT) - 1) <= 0 Then
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
  Else If (Length(EnglishT) - 1) > 0 Then
  Begin
    Block := True;
    EnglishT := LeftStr(EnglishT, Length(EnglishT) - 1);
    ParseAndSend;
  End;

  If ShowPrevWindow = 'YES' Then
  Begin
    If EnglishT <> '' Then
      frmPrevW.UpdateMe(EnglishT)
    Else
      frmPrevW.MakeMeHide;
  End
  Else
    frmPrevW.MakeMeHide;

End;

{ =============================================================================== }

Function TE2BCharBased.EscapeSpecialCharacters(Const inputT: String): String;
Var
  T: String;
Begin
  T := inputT;
  T := ReplaceStr(T, '\', '');
  T := ReplaceStr(T, '|', '');
  T := ReplaceStr(T, '(', '');
  T := ReplaceStr(T, ')', '');
  T := ReplaceStr(T, '[', '');
  T := ReplaceStr(T, ']', '');
  T := ReplaceStr(T, '{', '');
  T := ReplaceStr(T, '}', '');
  T := ReplaceStr(T, '^', '');
  T := ReplaceStr(T, '$', '');
  T := ReplaceStr(T, '*', '');
  T := ReplaceStr(T, '+', '');
  T := ReplaceStr(T, '?', '');
  T := ReplaceStr(T, '.', '');

  // Additional characters
  T := ReplaceStr(T, '~', '');
  T := ReplaceStr(T, '!', '');
  T := ReplaceStr(T, '@', '');
  T := ReplaceStr(T, '#', '');
  T := ReplaceStr(T, '%', '');
  T := ReplaceStr(T, '&', '');
  T := ReplaceStr(T, '-', '');
  T := ReplaceStr(T, '_', '');
  T := ReplaceStr(T, '=', '');
  T := ReplaceStr(T, #39, '');
  T := ReplaceStr(T, '"', '');
  T := ReplaceStr(T, ';', '');
  T := ReplaceStr(T, '<', '');
  T := ReplaceStr(T, '>', '');
  T := ReplaceStr(T, '/', '');
  T := ReplaceStr(T, '\', '');
  T := ReplaceStr(T, ',', '');
  T := ReplaceStr(T, ':', '');
  T := ReplaceStr(T, '`', '');
  T := ReplaceStr(T, b_Taka, '');
  T := ReplaceStr(T, b_Dari, '');

  Result := T;

End;

{ =============================================================================== }

Procedure TE2BCharBased.Fix_ZWNJ_ZWJ(Var rList: TStringList);
Var
  I: Integer;
  StartCounter, EndCounter: Integer;
Begin
  StartCounter := 0;
  EndCounter := rList.Count - 1;

  If EndCounter <= 0 Then
    exit;

  rList.Sorted := False;

  For I := StartCounter To EndCounter Do
  Begin
    rList[I] := ReplaceStr(rList[I], b_R + ZWNJ + b_Hasanta + b_Z,
      b_R + DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
  End;
End;

{ =============================================================================== }

Function TE2BCharBased.GetAutoCorrectEnabled: boolean;
Begin
  Result := Parser.AutoCorrectEnabled;
End;

{ =============================================================================== }

Procedure TE2BCharBased.LoadCandidateOptions;
Var
  I, p: Integer;
  FirstPart, SecondPart: String;
  tmpList: TStringList;
Begin
  If FileExists(GetAvroDataDir + 'CandidateOptions.dat') = False Then
    exit;
  Try
    Try
      tmpList := TStringList.Create;
      tmpList.LoadFromFile(GetAvroDataDir + 'CandidateOptions.dat',
        TEncoding.UTF8);
      For I := 1 To tmpList.Count - 1 Do
      Begin
        If trim(tmpList[I]) <> '' Then
        Begin
          p := Pos(' ', trim(tmpList[I]));
          FirstPart := LeftStr(trim(tmpList[I]), p - 1);
          SecondPart := MidStr(trim(tmpList[I]), p + 1,
            Length(trim(tmpList[I])));
          CandidateDict.AddOrSetValue(FirstPart, SecondPart);
        End;
      End;
    Except
      On E: Exception Do
      Begin
        // Nothing
      End;
    End;
  Finally
    tmpList.Clear;
    FreeAndNil(tmpList);
  End;

End;

{ =============================================================================== }

Procedure TE2BCharBased.MyProcessVKeyDown(Const KeyCode: Integer;
  Var Block: boolean; Const var_IfShift, var_IfTrueShift: boolean);
Begin
  Block := False;
  Case KeyCode Of
    VK_DECIMAL:
      Begin
        AddStr('.`');
        Block := True;
        exit;
      End;
    VK_DIVIDE:
      Begin
        AddStr('/');
        Block := True;
        exit;
      End;
    VK_MULTIPLY:
      Begin
        AddStr('*');
        Block := True;
        exit;
      End;
    VK_SUBTRACT:
      Begin
        AddStr('-');
        Block := True;
        exit;
      End;
    VK_ADD:
      Begin
        AddStr('+');
        Block := True;
        exit;
      End;

    VK_OEM_1:
      Begin // key ;:
        If var_IfTrueShift = True Then
          AddStr(':');
        If var_IfTrueShift = False Then
          AddStr(';');
        Block := True;
        exit;
      End;
    VK_OEM_2:
      Begin // key /?
        If var_IfTrueShift = True Then
        Begin
          AddStr('?');
          Block := True;
        End;

        If var_IfTrueShift = False Then
        Begin
          AddStr('/');
          Block := True;
        End;
        exit;
      End;

    VK_OEM_3:
      Begin // key `~
        If var_IfTrueShift = True Then
          AddStr('~');
        If var_IfTrueShift = False Then
          AddStr('`');
        Block := True;
        exit;
      End;

    VK_OEM_4:
      Begin // key [{
        If var_IfTrueShift = True Then
          AddStr('{');
        If var_IfTrueShift = False Then
          AddStr('[');
        Block := True;
        exit;
      End;

    VK_OEM_5:
      Begin // key \|
        If var_IfTrueShift = True Then
        Begin
          If PipeToDot = 'YES' Then
            AddStr('.`') { New dot! }
          Else
            AddStr('|');
        End;
        If var_IfTrueShift = False Then
          AddStr('\');
        Block := True;
        exit;
      End;
    VK_OEM_6:
      Begin // key ]}
        If var_IfTrueShift = True Then
          AddStr('}');
        If var_IfTrueShift = False Then
          AddStr(']');
        Block := True;
        exit;
      End;
    VK_OEM_7:
      Begin // key '"
        If var_IfTrueShift = True Then
          AddStr('"');
        If var_IfTrueShift = False Then
          AddStr(#39);
        Block := True;
        exit;
      End;
    VK_OEM_COMMA:
      Begin // key ,<
        If var_IfTrueShift = True Then
          AddStr('<');
        If var_IfTrueShift = False Then
          AddStr(',');
        Block := True;
        exit;
      End;
    VK_OEM_MINUS:
      Begin // key - underscore
        If var_IfTrueShift = True Then
          AddStr('_');
        If var_IfTrueShift = False Then
          AddStr('-');
        Block := True;
        exit;
      End;
    VK_OEM_PERIOD:
      Begin // key . >
        If var_IfTrueShift = True Then
          AddStr('>');
        If var_IfTrueShift = False Then
          AddStr('.');
        Block := True;
        exit;
      End;
    VK_OEM_PLUS:
      Begin // key =+
        If var_IfTrueShift = True Then
          AddStr('+');
        If var_IfTrueShift = False Then
          AddStr('=');
        Block := True;
        exit;
      End;

    VK_0:
      Begin
        If var_IfTrueShift = True Then
          AddStr(')');
        If var_IfTrueShift = False Then
          AddStr('0');
        Block := True;
        exit;
      End;
    VK_1:
      Begin
        If var_IfTrueShift = True Then
          AddStr('!');
        If var_IfTrueShift = False Then
          AddStr('1');
        Block := True;
        exit;
      End;
    VK_2:
      Begin
        If var_IfTrueShift = True Then
          AddStr('@');
        If var_IfTrueShift = False Then
          AddStr('2');
        Block := True;
        exit;
      End;
    VK_3:
      Begin
        If var_IfTrueShift = True Then
          AddStr('#');
        If var_IfTrueShift = False Then
          AddStr('3');
        Block := True;
        exit;
      End;
    VK_4:
      Begin
        If var_IfTrueShift = True Then
          AddStr('$');
        If var_IfTrueShift = False Then
          AddStr('4');
        Block := True;
        exit;
      End;
    VK_5:
      Begin
        If var_IfTrueShift = True Then
          AddStr('%');
        If var_IfTrueShift = False Then
          AddStr('5');
        Block := True;
        exit;
      End;
    VK_6:
      Begin
        If var_IfTrueShift = True Then
          AddStr('^');
        If var_IfTrueShift = False Then
          AddStr('6');
        Block := True;
        exit;
      End;
    VK_7:
      Begin
        If var_IfTrueShift = True Then
          AddStr('&');
        If var_IfTrueShift = False Then
          AddStr('7');
        Block := True;
        exit;
      End;
    VK_8:
      Begin
        If var_IfTrueShift = True Then
          AddStr('*');
        If var_IfTrueShift = False Then
          AddStr('8');
        Block := True;
        exit;
      End;
    VK_9:
      Begin
        If var_IfTrueShift = True Then
          AddStr('(');
        If var_IfTrueShift = False Then
          AddStr('9');
        Block := True;
        exit;
      End;

    VK_NUMPAD0:
      Begin
        AddStr('0');
        Block := True;
        exit;
      End;
    VK_NUMPAD1:
      Begin
        AddStr('1');
        Block := True;
        exit;
      End;
    VK_NUMPAD2:
      Begin
        AddStr('2');
        Block := True;
        exit;
      End;
    VK_NUMPAD3:
      Begin
        AddStr('3');
        Block := True;
        exit;
      End;
    VK_NUMPAD4:
      Begin
        AddStr('4');
        Block := True;
        exit;
      End;
    VK_NUMPAD5:
      Begin
        AddStr('5');
        Block := True;
        exit;
      End;
    VK_NUMPAD6:
      Begin
        AddStr('6');
        Block := True;
        exit;
      End;
    VK_NUMPAD7:
      Begin
        AddStr('7');
        Block := True;
        exit;
      End;
    VK_NUMPAD8:
      Begin
        AddStr('8');
        Block := True;
        exit;
      End;
    VK_NUMPAD9:
      Begin
        AddStr('9');
        Block := True;
        exit;
      End;

    A_Key:
      Begin
        If var_IfShift = True Then
          AddStr('A');
        If var_IfShift = False Then
          AddStr('a');
        Block := True;
        exit;
      End;
    B_Key:
      Begin
        If var_IfShift = True Then
          AddStr('B');
        If var_IfShift = False Then
          AddStr('b');
        Block := True;
        exit;
      End;
    C_Key:
      Begin
        If var_IfShift = True Then
          AddStr('C');
        If var_IfShift = False Then
          AddStr('c');
        Block := True;
        exit;
      End;
    D_Key:
      Begin
        If var_IfShift = True Then
          AddStr('D');
        If var_IfShift = False Then
          AddStr('d');
        Block := True;
        exit;
      End;
    E_Key:
      Begin
        If var_IfShift = True Then
          AddStr('E');
        If var_IfShift = False Then
          AddStr('e');
        Block := True;
        exit;
      End;
    F_Key:
      Begin
        If var_IfShift = True Then
          AddStr('F');
        If var_IfShift = False Then
          AddStr('f');
        Block := True;
        exit;
      End;
    G_Key:
      Begin
        If var_IfShift = True Then
          AddStr('G');
        If var_IfShift = False Then
          AddStr('g');
        Block := True;
        exit;
      End;
    H_Key:
      Begin
        If var_IfShift = True Then
          AddStr('H');
        If var_IfShift = False Then
          AddStr('h');
        Block := True;
        exit;
      End;
    I_Key:
      Begin
        If var_IfShift = True Then
          AddStr('I');
        If var_IfShift = False Then
          AddStr('i');
        Block := True;
        exit;
      End;
    J_Key:
      Begin
        If var_IfShift = True Then
          AddStr('J');
        If var_IfShift = False Then
          AddStr('j');
        Block := True;
        exit;
      End;
    K_Key:
      Begin
        If var_IfShift = True Then
          AddStr('K');
        If var_IfShift = False Then
          AddStr('k');
        Block := True;
        exit;
      End;
    L_Key:
      Begin
        If var_IfShift = True Then
          AddStr('L');
        If var_IfShift = False Then
          AddStr('l');
        Block := True;
        exit;
      End;
    M_Key:
      Begin
        If var_IfShift = True Then
          AddStr('M');
        If var_IfShift = False Then
          AddStr('m');
        Block := True;
        exit;
      End;
    N_Key:
      Begin
        If var_IfShift = True Then
          AddStr('N');
        If var_IfShift = False Then
          AddStr('n');
        Block := True;
        exit;
      End;
    O_Key:
      Begin
        If var_IfShift = True Then
          AddStr('O');
        If var_IfShift = False Then
          AddStr('o');
        Block := True;
        exit;
      End;
    P_Key:
      Begin
        If var_IfShift = True Then
          AddStr('P');
        If var_IfShift = False Then
          AddStr('p');
        Block := True;
        exit;
      End;
    Q_Key:
      Begin
        If var_IfShift = True Then
          AddStr('Q');
        If var_IfShift = False Then
          AddStr('q');
        Block := True;
        exit;
      End;
    R_Key:
      Begin
        If var_IfShift = True Then
          AddStr('R');
        If var_IfShift = False Then
          AddStr('r');
        Block := True;
        exit;
      End;
    S_Key:
      Begin
        If var_IfShift = True Then
          AddStr('S');
        If var_IfShift = False Then
          AddStr('s');
        Block := True;
        exit;
      End;
    T_Key:
      Begin
        If var_IfShift = True Then
          AddStr('T');
        If var_IfShift = False Then
          AddStr('t');
        Block := True;
        exit;
      End;
    U_Key:
      Begin
        If var_IfShift = True Then
          AddStr('U');
        If var_IfShift = False Then
          AddStr('u');
        Block := True;
        exit;
      End;
    V_Key:
      Begin
        If var_IfShift = True Then
          AddStr('V');
        If var_IfShift = False Then
          AddStr('v');
        Block := True;
        exit;
      End;
    W_Key:
      Begin
        If var_IfShift = True Then
          AddStr('W');
        If var_IfShift = False Then
          AddStr('w');
        Block := True;
        exit;
      End;
    X_Key:
      Begin
        If var_IfShift = True Then
          AddStr('X');
        If var_IfShift = False Then
          AddStr('x');
        Block := True;
        exit;
      End;
    Y_Key:
      Begin
        If var_IfShift = True Then
          AddStr('Y');
        If var_IfShift = False Then
          AddStr('y');
        Block := True;
        exit;
      End;
    Z_Key:
      Begin
        If var_IfShift = True Then
          AddStr('Z');
        If var_IfShift = False Then
          AddStr('z');
        Block := True;
        exit;
      End;

    // Special cases-------------------->
    VK_HOME:
      Begin
        Block := False;
        ResetDeadKey;
        exit;
      End;
    VK_END:
      Begin
        Block := False;
        ResetDeadKey;
        exit;
      End;
    VK_PRIOR:
      Begin
        Block := False;
        ResetDeadKey;
        exit;
      End;
    VK_NEXT:
      Begin
        Block := False;
        ResetDeadKey;
        exit;
      End;
    VK_UP:
      Begin
        If (frmPrevW.List.Count > 1) And (EnglishT <> '') Then
        Begin
          Block := True;
          frmPrevW.SelectPrevItem;
          UpdateCandidateOption;
          exit;
        End
        Else
        Begin
          Block := False;
          ResetDeadKey;
          exit;
        End;
      End;
    VK_DOWN:
      Begin
        If (frmPrevW.List.Count > 1) And (EnglishT <> '') Then
        Begin
          Block := True;
          frmPrevW.SelectNextItem;
          UpdateCandidateOption;
          exit;
        End
        Else
        Begin
          Block := False;
          ResetDeadKey;
          exit;
        End;
      End;
    VK_RIGHT:
      Begin
        Block := False;
        ResetDeadKey;
        exit;
      End;
    VK_LEFT:
      Begin
        Block := False;
        ResetDeadKey;
        exit;
      End;
    VK_BACK:
      Begin
        DoBackspace(Block);
        exit;
      End;
    VK_DELETE:
      Begin
        Block := False;
        ResetDeadKey;
        exit;
      End;
    VK_ESCAPE:
      Begin
        If (frmPrevW.PreviewWVisible = True) And (EnglishT <> '') Then
        Begin
          Block := True;
          ResetDeadKey;
          exit;
        End;
      End;

    VK_INSERT:
      Begin
        Block := True;
        exit;
      End;
  End;
End;

{ =============================================================================== }

Procedure TE2BCharBased.PadResults(Const Starting_Ignoreable_T,
  Ending_Ignorable_T: String; Var rList: TStringList);
Var
  B_Starting_Ignoreable_T, B_Ending_Ignorable_T: String;
  I: Integer;
Begin
  Parser.AutoCorrectEnabled := False;
  B_Starting_Ignoreable_T := Parser.Convert(Starting_Ignoreable_T);
  B_Ending_Ignorable_T := Parser.Convert(Ending_Ignorable_T);

  rList.Sorted := False;
  For I := 0 To rList.Count - 1 Do
  Begin
    rList[I] := B_Starting_Ignoreable_T + rList[I] + B_Ending_Ignorable_T;
  End;
End;

{ =============================================================================== }

Procedure TE2BCharBased.ParseAndSend;
Var
  I: Integer;
  RegExQuery: String;
  TempBanglaText1, TempBanglaText2: String;

  DictionaryFirstItem: String;
  Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T: String;

  AbbText: String;
  CandidateItem: String;
Begin
  frmPrevW.List.Items.Clear;

  Parser.AutoCorrectEnabled := True;
  TempBanglaText1 := Parser.Convert(EnglishT);
  Parser.AutoCorrectEnabled := False;
  TempBanglaText2 := Parser.Convert(EnglishT);

  If TempBanglaText1 = TempBanglaText2 Then
    frmPrevW.List.Items.Add(TempBanglaText1)
  Else
  Begin
    // If FAutoCorrect Then Begin
    frmPrevW.List.Items.Add(TempBanglaText1);
    frmPrevW.List.Items.Add(TempBanglaText2);
    // End
    // Else Begin
    // frmPrevW.List.Items.Add(TempBanglaText2);
    // frmPrevW.List.Items.Add(TempBanglaText1);
    // End;
  End;

  If (PhoneticMode = 'ONLYCHAR') Or (ShowPrevWindow = 'NO') Then
  Begin
    If (TempBanglaText1 <> TempBanglaText2) Then
    Begin
      If FAutoCorrect Then
        frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText1))
      Else
        frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2));
    End
    Else
      frmPrevW.SelectFirstItem;
  End
  Else
  Begin
    CutText(EnglishT, Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T);
    If (Length(Middle_Main_T) <= Max_EnglishLength) And
      (Length(Middle_Main_T) > 0) Then
    Begin

      WStringList.Clear;

      If Middle_Main_T = PhoneticCache[Length(Middle_Main_T)].EnglishT Then
      Begin
        WStringList.Assign(PhoneticCache[Length(Middle_Main_T)].Results);
        AddSuffix(Middle_Main_T, WStringList);
        SimilarSort(TempBanglaText2, WStringList);
        AbbText := '';
        AbbText := Abbreviation.CheckConvert(Middle_Main_T);
        If AbbText <> '' Then
          WStringList.Add(AbbText);
        PadResults(Starting_Ignoreable_T, Ending_Ignorable_T, WStringList);
      End
      Else
      Begin
        RegExQuery := RegExBuilder.Convert(Middle_Main_T);
        uRegExPhoneticSearch.SearchPhonetic(Middle_Main_T, RegExQuery,
          WStringList);

        Fix_ZWNJ_ZWJ(WStringList);
        AddToCache(Middle_Main_T, WStringList);
        AddSuffix(Middle_Main_T, WStringList);
        SimilarSort(TempBanglaText2, WStringList);
        AbbText := '';
        AbbText := Abbreviation.CheckConvert(Middle_Main_T);
        If AbbText <> '' Then
          WStringList.Add(AbbText);
        PadResults(Starting_Ignoreable_T, Ending_Ignorable_T, WStringList);
      End;

      If WStringList.Count > 0 Then
        DictionaryFirstItem := WStringList[0];

      For I := 0 To WStringList.Count - 1 Do
      Begin
        If (WStringList[I] <> TempBanglaText1) And
          (WStringList[I] <> TempBanglaText2) Then
          frmPrevW.List.Items.Add(WStringList[I]);
      End;

      // Add English option as the last item
      frmPrevW.List.Items.Add(EnglishT);

      // frmPrevW.SelectFirstItem;
      if CandidateDict.TryGetValue(Middle_Main_T, CandidateItem) And
        (SaveCandidate = 'YES') Then
      Begin
        frmPrevW.SelectItem(EscapeSpecialCharacters(CandidateItem));
      End
      Else
      Begin
        If WStringList.Count > 0 Then
        Begin
          If Length(Middle_Main_T) = 1 Then
            frmPrevW.SelectFirstItem
          Else
          Begin
            If (TempBanglaText1 <> TempBanglaText2) Then
            Begin
              If FAutoCorrect Then
                frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText1))
              Else
              Begin
                If PhoneticMode = 'DICT' Then
                Begin
                  If DictionaryFirstItem <> '' Then
                    frmPrevW.SelectItem
                      (EscapeSpecialCharacters(DictionaryFirstItem))
                  Else
                    frmPrevW.SelectItem
                      (EscapeSpecialCharacters(WStringList[0]));
                End
                Else If PhoneticMode = 'CHAR' Then
                Begin
                  frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2))
                End;
              End;
            End
            Else
            Begin
              If PhoneticMode = 'DICT' Then
              Begin
                If DictionaryFirstItem <> '' Then
                  frmPrevW.SelectItem
                    (EscapeSpecialCharacters(DictionaryFirstItem))
                Else
                  frmPrevW.SelectItem(EscapeSpecialCharacters(WStringList[0]));
              End
              Else If PhoneticMode = 'CHAR' Then
              Begin
                frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2))
              End;
            End;
          End;
        End
        Else
          frmPrevW.SelectFirstItem;
      End;
    End
    Else
      frmPrevW.SelectFirstItem;
  End;

  frmPrevW.ShowHideList;

  ManuallySelectedCandidate := False;
End;

{ =============================================================================== }

Procedure TE2BCharBased.ParseAndSendNow;
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

Procedure TE2BCharBased.ProcessEnter(Var Block: boolean);
Begin
  ResetDeadKey;
  Block := False;
End;

{ =============================================================================== }

Procedure TE2BCharBased.ProcessSpace(Var Block: boolean);
Begin
  ResetDeadKey;
  Block := False;
End;

{ =============================================================================== }

Function TE2BCharBased.ProcessVKeyDown(Const KeyCode: Integer;
  Var Block: boolean): String;
Var
  m_Block: boolean;
Begin
  m_Block := False;
  If (IfControl = True) Or (IfAlter = True) Or (IfWinKey = True) Then
  Begin
    Block := False;
    BlockLast := False;
    ProcessVKeyDown := '';
    exit;
  End;

  If (KeyCode = VK_SHIFT) Or (KeyCode = VK_LSHIFT) Or (KeyCode = VK_RSHIFT) Then
  Begin
    Block := False;
    BlockLast := False;
    ProcessVKeyDown := '';
    exit;
  End;

  If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then
  Begin
    Block := False;
    BlockLast := False;
    ProcessVKeyDown := '';
    exit;
  End
  Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then
  Begin
    If KeyCode = VK_SPACE Then
    Begin
      ProcessSpace(Block);
      ProcessVKeyDown := '';
      exit;
    End
    Else If KeyCode = VK_TAB Then
    Begin
      If TabBrowsing = 'YES' Then
      Begin
        If (frmPrevW.List.Count > 1) And (EnglishT <> '') Then
        Begin
          Block := True;
          frmPrevW.SelectNextItem;
          UpdateCandidateOption;
          exit;
        End
        Else
        Begin
          ResetDeadKey;
          Block := False;
          ProcessVKeyDown := '';
          exit;
        End;
      End
      Else
      Begin
        ResetDeadKey;
        Block := False;
        ProcessVKeyDown := '';
        exit;
      End;
    End
    Else If KeyCode = VK_RETURN Then
    Begin
      ProcessEnter(Block);
      ProcessVKeyDown := '';
      exit;
    End
    Else
    Begin

      MyProcessVKeyDown(KeyCode, m_Block, IfShift, IfTrueShift);
      ProcessVKeyDown := '';

      Block := m_Block;
      BlockLast := m_Block;
    End;
  End;

End;

{ =============================================================================== }

Procedure TE2BCharBased.ProcessVKeyUP(Const KeyCode: Integer;
  Var Block: boolean);
Begin
  If (KeyCode = VK_SHIFT) Or (KeyCode = VK_RSHIFT) Or (KeyCode = VK_LSHIFT) Or
    (KeyCode = VK_LCONTROL) Or (KeyCode = VK_RCONTROL) Or (KeyCode = VK_CONTROL)
    Or (KeyCode = VK_MENU) Or (KeyCode = VK_LMENU) Or (KeyCode = VK_RMENU) Or
    (IfWinKey = True) Then
  Begin
    Block := False;
    BlockLast := False;
    exit;
  End;

  If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then
  Begin
    Block := False;
    BlockLast := False;
  End
  Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then
  Begin
    If BlockLast = True Then
      Block := True;
  End;
End;

{ =============================================================================== }

Procedure TE2BCharBased.ResetDeadKey;
Var
  I: Integer;
Begin
  PrevBanglaT := '';
  EnglishT := '';
  BlockLast := False;
  NewBanglaText := '';

  For I := Low(PhoneticCache) To High(PhoneticCache) Do
  Begin
    PhoneticCache[I].EnglishT := '';
    PhoneticCache[I].Results.Clear;
  End;

  If ShowPrevWindow = 'YES' Then
    frmPrevW.MakeMeHide;

End;

{ =============================================================================== }

Procedure TE2BCharBased.SaveCandidateOptions;
Var
  S: String;
  tmpList: TStringList;
Begin
  Try
    Try
      tmpList := TStringList.Create;
      tmpList.Add
        ('// Avro Phonetic Candidate Selection Options (Do not remove this line)');
      for S in CandidateDict.Keys do
      begin
        tmpList.Add(S + ' ' + CandidateDict.Items[S]);
      End;
      tmpList.SaveToFile(GetAvroDataDir + 'CandidateOptions.dat',
        TEncoding.UTF8);
    Except
      On E: Exception Do
      Begin
        // Nothing
      End;
    End;
  Finally
    tmpList.Clear;
    FreeAndNil(tmpList);
  End;
End;

{ =============================================================================== }

Procedure TE2BCharBased.SelectCandidate(Const Item: String);
Begin
  NewBanglaText := Item;
  ParseAndSendNow;
  ManuallySelectedCandidate := True;
End;

{ =============================================================================== }

Procedure TE2BCharBased.SetAutoCorrectEnabled(Const Value: boolean);
Begin
  Parser.AutoCorrectEnabled := Value;
  FAutoCorrect := Value;
End;

{ =============================================================================== }

Procedure TE2BCharBased.UpdateCandidateOption;
Var
  Dummy, Middle_Main_T: String;
Begin
  CutText(EnglishT, Dummy, Middle_Main_T, Dummy);
  If ManuallySelectedCandidate Then
  Begin
    If trim(Middle_Main_T) <> '' Then
    Begin
      CandidateDict.AddOrSetValue(Middle_Main_T, NewBanglaText);
    End;
  End;
End;

{ =============================================================================== }

End.
