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

{COMPLETE TRANSFERING}

Unit clsE2BCharBased;


Interface

Uses
     classes,
     sysutils,
     StrUtils,
     clsEnglishToBangla,
     clsPhoneticRegExBuilder,
     WideStrings,
     cDictionaries,
     clsAbbreviation;

Const
     Max_EnglishLength        = 50;
     Max_RegExQueryLength     = 5000;

Type
     TPhoneticCache = Record
          EnglishT: AnsiString;
          Results: TWideStringList;
     End;


     //Skeleton of Class TE2BCharBased
Type
     TE2BCharBased = Class
     Private
          Parser: TEnglishToBangla;
          RegExBuilder: TEnglishToRegEx;
          Abbreviation: TAbbreviation;
          EnglishT: AnsiString;
          PrevBanglaT: WideString;
          BlockLast: boolean;
          WStringList: TWideStringList;
          NewBanglaText: WideString;
          FAutoCorrect: Boolean;
          CandidateDict: TStringDictionary;
          ManuallySelectedCandidate: Boolean;
          DetermineZWNJ_ZWJ: WideString;
          PhoneticCache: Array[1..Max_EnglishLength] Of TPhoneticCache;

          Procedure Fix_ZWNJ_ZWJ(Var rList: TWideStringList);
          Procedure ProcessSpace(Var Block: Boolean);
          Procedure ParseAndSend;
          Procedure ParseAndSendNow;
          Procedure ProcessTab(Var Block: Boolean);
          Procedure ProcessEnter(Var Block: Boolean);
          Procedure DoBackspace(Var Block: Boolean);
          Procedure MyProcessVKeyDown(Const KeyCode: Integer;
               Var Block: Boolean; Const var_IfShift: Boolean; Const var_IfTrueShift: Boolean);
          Procedure AddStr(Const Str: AnsiString);

          Procedure LoadCandidateOptions;
          Procedure SaveCandidateOptions;
          Procedure UpdateCandidateOption;

          Procedure AddToCache(Const MiddleMain_T: AnsiString; Var rList: TWideStringList);
          Procedure AddSuffix(Const MiddleMain_T: AnsiString; Var rList: TWideStringList);

          Procedure CutText(Const inputEStr: AnsiString; Var outSIgnore: AnsiString; Var outMidMain: AnsiString; Var outEIgnore: AnsiString);
          Procedure PadResults(Const Starting_Ignoreable_T, Ending_Ignorable_T: AnsiString; Var rList: TWideStringList);
          Function EscapeSpecialCharacters(Const inputT: WideString): WideString;

          Procedure SetAutoCorrectEnabled(Const Value: Boolean);
          Function GetAutoCorrectEnabled: Boolean;

     Public
          Constructor Create;           //Initializer
          Destructor Destroy; Override; //Destructor

          Function ProcessVKeyDown(Const KeyCode: Integer; Var Block: Boolean): WideString;
          Procedure ProcessVKeyUP(Const KeyCode: Integer; Var Block: Boolean);
          Procedure ResetDeadKey;
          Procedure SelectCandidate(Const Item: WideString);
          //Published
          Property AutoCorrectEnabled: Boolean
               Read GetAutoCorrectEnabled Write SetAutoCorrectEnabled;
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
     WideStrUtils,
     BanglaChars,
     uDBase,
     WindowsVersion;

{ TE2BCharBased }

{===============================================================================}

Procedure TE2BCharBased.AddStr(Const Str: AnsiString);
Begin
     EnglishT := EnglishT + Str;

     ParseAndSend;

     If ShowPrevWindow = 'YES' Then
          frmPrevW.UpdateMe(EnglishT)
     Else
          frmPrevW.MakeMeHide;

End;

{===============================================================================}

Procedure TE2BCharBased.AddSuffix(Const MiddleMain_T: AnsiString;
     Var rList: TWideStringList);
Var
     iLen, J, K               : Integer;
     isSuffix                 : String;
     B_Suffix                 : WideString;
     TempList                 : TWideStringList;
Begin
     iLen := Length(MiddleMain_T);
     rList.Sorted := True;
     rList.Duplicates := dupIgnore;

     If iLen >= 2 Then Begin
          TempList := TWideStringList.Create;
          For j := 2 To iLen Do Begin
               isSuffix := LowerCase(MidStr(MiddleMain_T, j, iLen));
               If Suffix.HasKey(isSuffix) Then Begin
                    B_Suffix := utf8decode(Suffix.Item[isSuffix]);
                    If PhoneticCache[iLen - Length(isSuffix)].Results.Count > 0 Then Begin
                         For K := 0 To PhoneticCache[iLen - Length(isSuffix)].Results.Count - 1 Do Begin
                              If IsVowel(RightStr(PhoneticCache[iLen - Length(isSuffix)].Results[k], 1)) And (IsKar(LeftStr(B_Suffix, 1))) Then Begin
                                   TempList.Add(PhoneticCache[iLen - Length(isSuffix)].Results[k] + b_Y + B_Suffix);
                              End
                              Else Begin
                                   If RightStr(PhoneticCache[iLen - Length(isSuffix)].Results[k], 1) = b_Khandatta Then
                                        TempList.Add(MidStr(PhoneticCache[iLen - Length(isSuffix)].Results[k], 1,
                                             Length(PhoneticCache[iLen - Length(isSuffix)].Results[k]) - 1) + b_T + B_Suffix)
                                   Else If RightStr(PhoneticCache[iLen - Length(isSuffix)].Results[k], 1) = b_Anushar Then
                                        TempList.Add(MidStr(PhoneticCache[iLen - Length(isSuffix)].Results[k], 1,
                                             Length(PhoneticCache[iLen - Length(isSuffix)].Results[k]) - 1) + b_NGA + B_Suffix)
                                   Else
                                        TempList.Add(PhoneticCache[iLen - Length(isSuffix)].Results[k] + B_Suffix);
                              End;
                         End;
                    End;
               End;
          End;

          For J := 0 To TempList.Count - 1 Do Begin
               rList.Add(TempList[J]);
          End;

          TempList.Clear;
          FreeAndNil(TempList);
     End;
End;

{===============================================================================}

Procedure TE2BCharBased.AddToCache(Const MiddleMain_T: AnsiString;
     Var rList: TWideStringList);
Var
     iLen                     : Integer;
Begin
     iLen := Length(MiddleMain_T);
     PhoneticCache[iLen].EnglishT := MiddleMain_T;
     PhoneticCache[iLen].Results.Clear;
     PhoneticCache[iLen].Results.Assign(rList);
End;

{===============================================================================}

Constructor TE2BCharBased.Create;
Var
     I                        : Integer;
Begin
     Inherited;
     Parser := TEnglishToBangla.Create;
     Abbreviation := TAbbreviation.Create;
     RegExBuilder := TEnglishToRegEx.Create;
     WStringList := TWideStringList.Create;
     CandidateDict := TStringDictionary.Create;
     CandidateDict.DuplicatesAction := ddIgnore;
     LoadCandidateOptions;

     For i := Low(PhoneticCache) To High(PhoneticCache) Do Begin
          PhoneticCache[i].Results := TWideStringList.Create;
     End;

    // If IsWinVistaOrLater Then
          DetermineZWNJ_ZWJ := ZWJ;
   //  Else
   //       DetermineZWNJ_ZWJ := ZWNJ;

End;

{===============================================================================}

Procedure TE2BCharBased.CutText(Const inputEStr: AnsiString; Var outSIgnore,
     outMidMain, outEIgnore: AnsiString);
Var
     i                        : Integer;
     p, q                     : integer;
     EStrLen                  : Integer;
     tStr                     : AnsiChar;
     reverse_inputEStr        : AnsiString;
     temporaryString          : AnsiString;
Begin

     tstr := #0;
     P := 0;

     EStrLen := Length(inputEStr);
     //Start Cutting outSIgnore
     For I := 1 To EStrLen Do Begin

          temporaryString := MidStr(inputEStr, i, 1);
          If Length(temporaryString) > 0 Then
               tStr := temporaryString[1];

          Case tStr Of
               '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_',
                    '=', '+', '[', ']', '{', '}', #39, '"', ';', '<', '>',
                    '/', '?', '|', '\', '.':

                    p := i;

               ',':
                    p := i;


               ':':
                    Break;

               '`':
                    p := i
          Else
               Break;
          End;
     End;

     outSIgnore := LeftStr(inputEStr, p);
     //End Cutting outSIgnore

     //Start Cutting outEIgnore
     tstr := #0;
     Q := 0;

     reverse_inputEStr := ReverseString(inputEStr);
     For I := 1 To EStrLen - p Do Begin
          temporaryString := MidStr(reverse_inputEStr, i, 1);
          If Length(temporaryString) > 0 Then
               tStr := temporaryString[1];

          Case tStr Of
               '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_',
                    '=', '+', '[', ']', '{', '}', #39, #34, ';', '<', '>',
                    '/', '.', '?', '|', '\':
                    q := i;
               ',':
                    q := i;

               '`':
                    q := i;

               ':':
                    q := i;

          Else
               Break;
          End;
     End;

     outEIgnore := RightStr(inputEStr, q);
     //End Cutting outEIgnore

     //Start Cutting outMidMain
     temporaryString := MidStr(inputEStr, p + 1, Length(inputEStr));
     temporaryString := LeftStr(temporaryString, Length(temporaryString) - q);
     outMidMain := temporaryString;

End;

{===============================================================================}

Destructor TE2BCharBased.Destroy;
Var
     I                        : Integer;
Begin
     WStringList.Clear;
     FreeAndNil(WStringList);
     FreeAndNil(Parser);
     FreeAndNil(RegExBuilder);
     FreeAndNil(Abbreviation);
     If SaveCandidate = 'YES' Then
          SaveCandidateOptions;
     CandidateDict.Clear;
     FreeAndNil(CandidateDict);

     For i := Low(PhoneticCache) To High(PhoneticCache) Do Begin
          PhoneticCache[i].Results.Clear;
          PhoneticCache[i].Results.Free;
     End;

     Inherited;
End;

{===============================================================================}

Procedure TE2BCharBased.DoBackspace(Var Block: Boolean);
Begin
     If Length(EnglishT) - 1 <= 0 Then Begin
          ResetDeadKey;
          Block := False;
     End
     Else If Length(EnglishT) - 1 > 0 Then Begin
          Block := True;
          EnglishT := LeftStr(EnglishT, Length(EnglishT) - 1);
          ParseAndSend;
     End;


     If ShowPrevWindow = 'YES' Then Begin
          If EnglishT <> '' Then
               frmPrevW.UpdateMe(EnglishT)
          Else
               frmPrevW.MakeMeHide;
     End
     Else
          frmPrevW.MakeMeHide;


End;

{===============================================================================}

Function TE2BCharBased.EscapeSpecialCharacters(
     Const inputT: WideString): WideString;
Var
     T                        : WideString;
Begin
     T := inputT;
     T := WideReplaceStr(T, '\', '');
     T := WideReplaceStr(T, '|', '');
     T := WideReplaceStr(T, '(', '');
     T := WideReplaceStr(T, ')', '');
     T := WideReplaceStr(T, '[', '');
     T := WideReplaceStr(T, ']', '');
     T := WideReplaceStr(T, '{', '');
     T := WideReplaceStr(T, '}', '');
     T := WideReplaceStr(T, '^', '');
     T := WideReplaceStr(T, '$', '');
     T := WideReplaceStr(T, '*', '');
     T := WideReplaceStr(T, '+', '');
     T := WideReplaceStr(T, '?', '');
     T := WideReplaceStr(T, '.', '');

     //Additional characters
     T := WideReplaceStr(T, '~', '');
     T := WideReplaceStr(T, '!', '');
     T := WideReplaceStr(T, '@', '');
     T := WideReplaceStr(T, '#', '');
     T := WideReplaceStr(T, '%', '');
     T := WideReplaceStr(T, '&', '');
     T := WideReplaceStr(T, '-', '');
     T := WideReplaceStr(T, '_', '');
     T := WideReplaceStr(T, '=', '');
     T := WideReplaceStr(T, #39, '');
     T := WideReplaceStr(T, '"', '');
     T := WideReplaceStr(T, ';', '');
     T := WideReplaceStr(T, '<', '');
     T := WideReplaceStr(T, '>', '');
     T := WideReplaceStr(T, '/', '');
     T := WideReplaceStr(T, '\', '');
     T := WideReplaceStr(T, ',', '');
     T := WideReplaceStr(T, ':', '');
     T := WideReplaceStr(T, '`', '');
     T := WideReplaceStr(T, b_Taka, '');
     T := WideReplaceStr(T, b_Dari, '');

     Result := T;

End;

{===============================================================================}

Procedure TE2BCharBased.Fix_ZWNJ_ZWJ(Var rList: TWideStringList);
Var
     I                        : Integer;
     StartCounter, EndCounter : Integer;
Begin
     StartCounter := 0;
     EndCounter := rList.Count - 1;

     If EndCounter <= 0 Then exit;

     rList.Sorted := False;

     For I := StartCounter To EndCounter Do Begin
          rList[i] := WideReplaceStr(rList[i], b_R + ZWNJ + b_Hasanta + b_Z,
               b_r + DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
         { rList[i] := WideReplaceStr(rList[i], b_R + ZWJ + b_Hasanta + b_Z,
               b_r + DetermineZWNJ_ZWJ + b_Hasanta + b_Z); }
     End;
End;

{===============================================================================}

Function TE2BCharBased.GetAutoCorrectEnabled: Boolean;
Begin
     Result := Parser.AutoCorrectEnabled;
End;

{===============================================================================}

Procedure TE2BCharBased.LoadCandidateOptions;
Var
     I, P                     : integer;
     FirstPart, SecondPart    : String;
     tmpList                  : TStringList;
Begin
     If FileExists(GetAvroDataDir + 'CandidateOptions.dat') = False Then exit;
     Try
          Try
               tmpList := TStringList.Create;
               tmpList.LoadFromFile(GetAvroDataDir + 'CandidateOptions.dat');
               For I := 1 To tmpList.Count - 1 Do Begin
                    If trim(tmpList[i]) <> '' Then Begin
                         P := Pos(' ', Trim(tmpList[i]));
                         FirstPart := LeftStr(Trim(tmpList[i]), P - 1);
                         SecondPart := MidStr(Trim(tmpList[i]), p + 1, Length(Trim(tmpList[i])));
                         CandidateDict.Add(FirstPart, SecondPart);
                    End;
               End;
          Except
               On E: Exception Do Begin
                    //Nothing
               End;
          End;
     Finally
          tmpList.Clear;
          FreeAndNil(tmpList);
     End;

End;

{===============================================================================}

Procedure TE2BCharBased.MyProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean; Const var_IfShift, var_IfTrueShift: Boolean);
Begin
     Block := False;
     Case KeyCode Of
          VK_DECIMAL: Begin
                    AddStr('.`');
                    Block := True;
                    exit;
               End;
          VK_DIVIDE: Begin
                    AddStr('/');
                    Block := True;
                    exit;
               End;
          VK_MULTIPLY: Begin
                    AddStr('*');
                    Block := True;
                    exit;
               End;
          VK_SUBTRACT: Begin
                    AddStr('-');
                    Block := True;
                    exit;
               End;
          VK_ADD: Begin
                    AddStr('+');
                    Block := True;
                    exit;
               End;

          VK_OEM_1: Begin               //key ;:
                    If var_IfTrueShift = True Then AddStr(':');
                    If var_IfTrueShift = False Then AddStr(';');
                    Block := True;
                    Exit;
               End;
          VK_OEM_2: Begin               //key /?
                    If var_IfTrueShift = True Then Begin
                         AddStr('?');
                         Block := True;
                    End;

                    If var_IfTrueShift = False Then Begin
                         AddStr('/');
                         Block := True;
                    End;
                    Exit;
               End;

          VK_OEM_3: Begin               //key `~
                    If var_IfTrueShift = True Then AddStr('~');
                    If var_IfTrueShift = False Then AddStr('`');
                    Block := True;
                    Exit;
               End;

          VK_OEM_4: Begin               //key [{
                    If var_IfTrueShift = True Then AddStr('{');
                    If var_IfTrueShift = False Then AddStr('[');
                    Block := True;
                    Exit;
               End;

          VK_OEM_5: Begin               // key \|
                    If var_IfTrueShift = True Then AddStr('.`'); {New dot!}
                    If var_IfTrueShift = False Then AddStr('\');
                    Block := True;
                    Exit;
               End;
          VK_OEM_6: Begin               // key ]}
                    If var_IfTrueShift = True Then AddStr('}');
                    If var_IfTrueShift = False Then AddStr(']');
                    Block := True;
                    Exit;
               End;
          VK_OEM_7: Begin               //key '"
                    If var_IfTrueShift = True Then AddStr('"');
                    If var_IfTrueShift = False Then AddStr(#39);
                    Block := True;
                    Exit;
               End;
          VK_OEM_COMMA: Begin           //key ,<
                    If var_IfTrueShift = True Then AddStr('<');
                    If var_IfTrueShift = False Then AddStr(',');
                    Block := True;
                    Exit;
               End;
          VK_OEM_MINUS: Begin           //key - underscore
                    If var_IfTrueShift = True Then AddStr('_');
                    If var_IfTrueShift = False Then AddStr('-');
                    Block := True;
                    Exit;
               End;
          VK_OEM_PERIOD: Begin          //key . >
                    If var_IfTrueShift = True Then AddStr('>');
                    If var_IfTrueShift = False Then AddStr('.');
                    Block := True;
                    Exit;
               End;
          VK_OEM_PLUS: Begin            //key =+
                    If var_IfTrueShift = True Then AddStr('+');
                    If var_IfTrueShift = False Then AddStr('=');
                    Block := True;
                    Exit;
               End;


          VK_0: Begin
                    If var_IfTrueShift = True Then AddStr(')');
                    If var_IfTrueShift = False Then AddStr('0');
                    Block := True;
                    Exit;
               End;
          VK_1: Begin
                    If var_IfTrueShift = True Then AddStr('!');
                    If var_IfTrueShift = False Then AddStr('1');
                    Block := True;
                    Exit;
               End;
          VK_2: Begin
                    If var_IfTrueShift = True Then AddStr('@');
                    If var_IfTrueShift = False Then AddStr('2');
                    Block := True;
                    Exit;
               End;
          VK_3: Begin
                    If var_IfTrueShift = True Then AddStr('#');
                    If var_IfTrueShift = False Then AddStr('3');
                    Block := True;
                    Exit;
               End;
          VK_4: Begin
                    If var_IfTrueShift = True Then AddStr('$');
                    If var_IfTrueShift = False Then AddStr('4');
                    Block := True;
                    Exit;
               End;
          VK_5: Begin
                    If var_IfTrueShift = True Then AddStr('%');
                    If var_IfTrueShift = False Then AddStr('5');
                    Block := True;
                    Exit;
               End;
          VK_6: Begin
                    If var_IfTrueShift = True Then AddStr('^');
                    If var_IfTrueShift = False Then AddStr('6');
                    Block := True;
                    Exit;
               End;
          VK_7: Begin
                    If var_IfTrueShift = True Then AddStr('&');
                    If var_IfTrueShift = False Then AddStr('7');
                    Block := True;
                    Exit;
               End;
          VK_8: Begin
                    If var_IfTrueShift = True Then AddStr('*');
                    If var_IfTrueShift = False Then AddStr('8');
                    Block := True;
                    Exit;
               End;
          VK_9: Begin
                    If var_IfTrueShift = True Then AddStr('(');
                    If var_IfTrueShift = False Then AddStr('9');
                    Block := True;
                    Exit;
               End;



          VK_NUMPAD0: Begin
                    AddStr('0');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD1: Begin
                    AddStr('1');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD2: Begin
                    AddStr('2');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD3: Begin
                    AddStr('3');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD4: Begin
                    AddStr('4');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD5: Begin
                    AddStr('5');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD6: Begin
                    AddStr('6');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD7: Begin
                    AddStr('7');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD8: Begin
                    AddStr('8');
                    Block := True;
                    Exit;
               End;
          VK_NUMPAD9: Begin
                    AddStr('9');
                    Block := True;
                    Exit;
               End;


          A_Key: Begin
                    If var_IfShift = True Then AddStr('A');
                    If var_IfShift = False Then AddStr('a');
                    Block := True;
                    Exit;
               End;
          B_Key: Begin
                    If var_IfShift = True Then AddStr('B');
                    If var_IfShift = False Then AddStr('b');
                    Block := True;
                    Exit;
               End;
          C_Key: Begin
                    If var_IfShift = True Then AddStr('C');
                    If var_IfShift = False Then AddStr('c');
                    Block := True;
                    Exit;
               End;
          D_Key: Begin
                    If var_IfShift = True Then AddStr('D');
                    If var_IfShift = False Then AddStr('d');
                    Block := True;
                    Exit;
               End;
          E_Key: Begin
                    If var_IfShift = True Then AddStr('E');
                    If var_IfShift = False Then AddStr('e');
                    Block := True;
                    Exit;
               End;
          F_Key: Begin
                    If var_IfShift = True Then AddStr('F');
                    If var_IfShift = False Then AddStr('f');
                    Block := True;
                    Exit;
               End;
          G_Key: Begin
                    If var_IfShift = True Then AddStr('G');
                    If var_IfShift = False Then AddStr('g');
                    Block := True;
                    Exit;
               End;
          H_Key: Begin
                    If var_IfShift = True Then AddStr('H');
                    If var_IfShift = False Then AddStr('h');
                    Block := True;
                    Exit;
               End;
          I_Key: Begin
                    If var_IfShift = True Then AddStr('I');
                    If var_IfShift = False Then AddStr('i');
                    Block := True;
                    Exit;
               End;
          J_Key: Begin
                    If var_IfShift = True Then AddStr('J');
                    If var_IfShift = False Then AddStr('j');
                    Block := True;
                    Exit;
               End;
          K_Key: Begin
                    If var_IfShift = True Then AddStr('K');
                    If var_IfShift = False Then AddStr('k');
                    Block := True;
                    Exit;
               End;
          L_Key: Begin
                    If var_IfShift = True Then AddStr('L');
                    If var_IfShift = False Then AddStr('l');
                    Block := True;
                    Exit;
               End;
          M_Key: Begin
                    If var_IfShift = True Then AddStr('M');
                    If var_IfShift = False Then AddStr('m');
                    Block := True;
                    Exit;
               End;
          N_Key: Begin
                    If var_IfShift = True Then AddStr('N');
                    If var_IfShift = False Then AddStr('n');
                    Block := True;
                    Exit;
               End;
          O_Key: Begin
                    If var_IfShift = True Then AddStr('O');
                    If var_IfShift = False Then AddStr('o');
                    Block := True;
                    Exit;
               End;
          P_Key: Begin
                    If var_IfShift = True Then AddStr('P');
                    If var_IfShift = False Then AddStr('p');
                    Block := True;
                    Exit;
               End;
          Q_Key: Begin
                    If var_IfShift = True Then AddStr('Q');
                    If var_IfShift = False Then AddStr('q');
                    Block := True;
                    Exit;
               End;
          R_Key: Begin
                    If var_IfShift = True Then AddStr('R');
                    If var_IfShift = False Then AddStr('r');
                    Block := True;
                    Exit;
               End;
          S_Key: Begin
                    If var_IfShift = True Then AddStr('S');
                    If var_IfShift = False Then AddStr('s');
                    Block := True;
                    Exit;
               End;
          T_Key: Begin
                    If var_IfShift = True Then AddStr('T');
                    If var_IfShift = False Then AddStr('t');
                    Block := True;
                    Exit;
               End;
          U_Key: Begin
                    If var_IfShift = True Then AddStr('U');
                    If var_IfShift = False Then AddStr('u');
                    Block := True;
                    Exit;
               End;
          V_Key: Begin
                    If var_IfShift = True Then AddStr('V');
                    If var_IfShift = False Then AddStr('v');
                    Block := True;
                    Exit;
               End;
          W_Key: Begin
                    If var_IfShift = True Then AddStr('W');
                    If var_IfShift = False Then AddStr('w');
                    Block := True;
                    Exit;
               End;
          X_Key: Begin
                    If var_IfShift = True Then AddStr('X');
                    If var_IfShift = False Then AddStr('x');
                    Block := True;
                    Exit;
               End;
          Y_Key: Begin
                    If var_IfShift = True Then AddStr('Y');
                    If var_IfShift = False Then AddStr('y');
                    Block := True;
                    Exit;
               End;
          Z_Key: Begin
                    If var_IfShift = True Then AddStr('Z');
                    If var_IfShift = False Then AddStr('z');
                    Block := True;
                    Exit;
               End;

          //Special cases-------------------->
          VK_HOME: Begin
                    Block := False;
                    ResetDeadKey;
                    Exit;
               End;
          VK_END: Begin
                    Block := False;
                    ResetDeadKey;
                    Exit;
               End;
          VK_PRIOR: Begin
                    Block := False;
                    ResetDeadKey;
                    Exit;
               End;
          VK_NEXT: Begin
                    Block := False;
                    ResetDeadKey;
                    Exit;
               End;
          VK_UP: Begin
                    If (frmPrevW.List.Count > 1) And (EnglishT <> '') Then Begin
                         Block := True;
                         frmPrevW.SelectPrevItem;
                         UpdateCandidateOption;
                         Exit;
                    End
                    Else Begin
                         Block := False;
                         ResetDeadKey;
                         Exit;
                    End;
               End;
          VK_DOWN: Begin
                    If (frmPrevW.List.Count > 1) And (EnglishT <> '') Then Begin
                         Block := True;
                         frmPrevW.SelectNextItem;
                         UpdateCandidateOption;
                         Exit;
                    End
                    Else Begin
                         Block := False;
                         ResetDeadKey;
                         Exit;
                    End;
               End;
          VK_RIGHT: Begin
                    Block := False;
                    ResetDeadKey;
                    Exit;
               End;
          VK_LEFT: Begin
                    Block := False;
                    ResetDeadKey;
                    Exit;
               End;
          VK_BACK: Begin
                    DoBackspace(Block);
                    Exit;
               End;
          VK_DELETE: Begin
                    Block := False;
                    ResetDeadKey;
                    Exit;
               End;
          VK_ESCAPE: Begin
                    If (frmPrevW.PreviewWVisible = True) And (EnglishT <> '') Then Begin
                         Block := True;
                         ResetDeadKey;
                         Exit;
                    End;
               End;

          VK_INSERT: Begin
                    Block := True;
                    exit;
               End;
     End;
End;

{===============================================================================}

Procedure TE2BCharBased.PadResults(Const Starting_Ignoreable_T, Ending_Ignorable_T: AnsiString; Var rList: TWideStringList);
Var
     B_Starting_Ignoreable_T, B_Ending_Ignorable_T: WideString;
     I                        : Integer;
Begin
     Parser.AutoCorrectEnabled := False;
     B_Starting_Ignoreable_T := Parser.Convert(Starting_Ignoreable_T);
     B_Ending_Ignorable_T := Parser.Convert(Ending_Ignorable_T);

     rList.Sorted := False;
     For I := 0 To rList.Count - 1 Do Begin
          rList[i] := B_Starting_Ignoreable_T + rList[i] + B_Ending_Ignorable_T;
     End;
End;

{===============================================================================}

Procedure TE2BCharBased.ParseAndSend;
Var
     I                        : Integer;
     RegExQuery               : String;
     TempBanglaText1, TempBanglaText2: WideString;

     DictionaryFirstItem      : WideString;
     Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T: AnsiString;

     AbbText                  : WideString;
Begin
     frmPrevW.List.Items.Clear;

     Parser.AutoCorrectEnabled := True;
     TempBanglaText1 := Parser.Convert(EnglishT);
     Parser.AutoCorrectEnabled := False;
     TempBanglaText2 := Parser.Convert(EnglishT);


     If TempBanglaText1 = TempBanglaText2 Then
          frmPrevW.List.Items.Add(TempBanglaText1)
     Else Begin
          //   If FAutoCorrect Then Begin
          frmPrevW.List.Items.Add(TempBanglaText1);
          frmPrevW.List.Items.Add(TempBanglaText2);
          //   End
          //   Else Begin
          //        frmPrevW.List.Items.Add(TempBanglaText2);
          //       frmPrevW.List.Items.Add(TempBanglaText1);
          //  End;
     End;

     If (PhoneticMode = 'ONLYCHAR') or (ShowPrevWindow = 'NO') Then Begin
          If (TempBanglaText1 <> TempBanglaText2) Then Begin
               If FAutoCorrect Then
                    frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText1))
               Else
                    frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2));
          End
          Else
               frmPrevW.SelectFirstItem;
     End
     Else Begin
          CutText(EnglishT, Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T);
          If (Length(Middle_Main_T) <= Max_EnglishLength) And (Length(Middle_Main_T) > 0) Then Begin

               WStringList.Clear;

               If Middle_Main_T = PhoneticCache[Length(Middle_Main_T)].EnglishT Then Begin
                    WStringList.Assign(PhoneticCache[Length(Middle_Main_T)].Results);
                    AddSuffix(Middle_Main_T, WStringList);
                    SimilarSort(TempBanglaText2, WStringList);
                    AbbText :='';
                    AbbText := Abbreviation.CheckConvert(Middle_Main_T);
                    If AbbText <> '' Then WStringList.Add(AbbText);   
                    PadResults(Starting_Ignoreable_T, Ending_Ignorable_T, WStringList);
               End
               Else Begin
                    RegExQuery := RegExBuilder.Convert(Middle_Main_T);
                    uRegExPhoneticSearch.SearchPhonetic(Middle_Main_T, RegExQuery, WStringList);

                    Fix_ZWNJ_ZWJ(WStringList);
                    AddToCache(Middle_Main_T, WStringList);
                    AddSuffix(Middle_Main_T, WStringList);
                    SimilarSort(TempBanglaText2, WStringList);
                    AbbText :='';
                    AbbText := Abbreviation.CheckConvert(Middle_Main_T);
                    If AbbText <> '' Then WStringList.Add(AbbText);
                    PadResults(Starting_Ignoreable_T, Ending_Ignorable_T, WStringList);
               End;

               If WStringList.Count > 0 Then
                    DictionaryFirstItem := WStringList[0];

               For I := 0 To WStringList.Count - 1 Do Begin
                    If (WStringList[i] <> TempBanglaText1) And (WStringList[i] <> TempBanglaText2) Then
                         frmPrevW.List.Items.Add(WStringList[i]);
               End;

               //frmPrevW.SelectFirstItem;
               If (CandidateDict.HasKey(Middle_Main_T) = True) And (SaveCandidate = 'YES') Then Begin
                    frmPrevW.SelectItem(EscapeSpecialCharacters(utf8decode(CandidateDict.Item[Middle_Main_T])));
               End
               Else Begin
                    If WStringList.Count > 0 Then Begin
                         If Length(Middle_Main_T) = 1 Then
                              frmPrevW.SelectFirstItem
                         Else Begin
                              If (TempBanglaText1 <> TempBanglaText2) Then Begin
                                   If FAutoCorrect Then
                                        frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText1))
                                   Else Begin
                                        If PhoneticMode = 'DICT' Then Begin
                                             If DictionaryFirstItem <> '' Then
                                                  frmPrevW.SelectItem(EscapeSpecialCharacters(DictionaryFirstItem))
                                             Else
                                                  frmPrevW.SelectItem(EscapeSpecialCharacters(WStringList[0]));
                                        End
                                        Else If PhoneticMode = 'CHAR' Then Begin
                                             frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2))
                                        End;
                                   End;
                              End
                              Else Begin
                                   If PhoneticMode = 'DICT' Then Begin
                                        If DictionaryFirstItem <> '' Then
                                             frmPrevW.SelectItem(EscapeSpecialCharacters(DictionaryFirstItem))
                                        Else
                                             frmPrevW.SelectItem(EscapeSpecialCharacters(WStringList[0]));
                                   End
                                   Else If PhoneticMode = 'CHAR' Then Begin
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

{===============================================================================}

Procedure TE2BCharBased.ParseAndSendNow;
Var
     I, Matched, UnMatched    : Integer;
Begin
     Matched := 0;

     If PrevBanglaT = '' Then Begin
          SendKey_Char(NewBanglaText);
          PrevBanglaT := NewBanglaText;
     End
     Else Begin
          For I := 1 To Length(PrevBanglaT) Do Begin
               If MidStr(PrevBanglaT, I, 1) = MidStr(NewBanglaText, i, 1) Then
                    Matched := Matched + 1
               Else
                    Break;
          End;
          UnMatched := Length(PrevBanglaT) - Matched;

          If UnMatched >= 1 Then Backspace(UnMatched);
          SendKey_Char(MidStr(NewBanglaText, Matched + 1, Length(NewBanglaText)));
          PrevBanglaT := NewBanglaText;
     End;
End;

{===============================================================================}

Procedure TE2BCharBased.ProcessEnter(Var Block: Boolean);
Begin
     ResetDeadKey;
     Block := False;
End;

{===============================================================================}

Procedure TE2BCharBased.ProcessSpace(Var Block: Boolean);
Begin
     ResetDeadKey;
     Block := False;
End;

{===============================================================================}

Procedure TE2BCharBased.ProcessTab(Var Block: Boolean);
Begin
     ResetDeadKey;
     Block := False;
End;

{===============================================================================}

Function TE2BCharBased.ProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean): WideString;
Var
     m_Block                  : Boolean;
Begin
     m_Block := False;
     If (IfControl = True) Or (IfAlter = True) Or (IfWinKey = True) Then Begin
          Block := False;
          BlockLast := False;
          ProcessVKeyDown := '';
          Exit;
     End;

     If (KeyCode = VK_SHIFT) Or (KeyCode = VK_LSHIFT) Or (KeyCode = VK_RSHIFT) Then Begin
          Block := False;
          BlockLast := False;
          ProcessVKeyDown := '';
          Exit;
     End;

     If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then Begin
          Block := False;
          BlockLast := False;
          ProcessVKeyDown := '';
          Exit;
     End
     Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then Begin
          If KeyCode = VK_SPACE Then Begin
               ProcessSpace(Block);
               ProcessVKeyDown := '';
               Exit;
          End
          Else If KeyCode = VK_TAB Then Begin
               ProcessTab(Block);
               ProcessVKeyDown := '';
               Exit;
          End
          Else If KeyCode = VK_RETURN Then Begin
               ProcessEnter(Block);
               ProcessVKeyDown := '';
               Exit;
          End
          Else Begin

               MyProcessVKeyDown(KeyCode, m_Block, IfShift, IfTrueShift);
               ProcessVKeyDown := '';

               Block := m_Block;
               BlockLast := m_Block;
          End;
     End;

End;

{===============================================================================}

Procedure TE2BCharBased.ProcessVKeyUP(Const KeyCode: Integer;
     Var Block: Boolean);
Begin
     If (KeyCode = VK_SHIFT) Or (KeyCode = VK_RSHIFT)
          Or (KeyCode = VK_LSHIFT) Or (KeyCode = VK_LCONTROL)
          Or (KeyCode = VK_RCONTROL) Or (KeyCode = VK_CONTROL)
          Or (KeyCode = VK_MENU) Or (KeyCode = VK_LMENU) Or (KeyCode = VK_RMENU)
          Or (IfWinKey = True) Then Begin
          Block := False;
          BlockLast := False;
          Exit;
     End;

     If AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault Then Begin
          Block := False;
          BlockLast := False;
     End
     Else If AvroMainForm1.GetMyCurrentKeyboardMode = bangla Then Begin
          If BlockLast = True Then Block := True;
     End;
End;

{===============================================================================}

Procedure TE2BCharBased.ResetDeadKey;
Var
     I                        : Integer;
Begin
     PrevBanglaT := '';
     EnglishT := '';
     BlockLast := False;
     NewBanglaText := '';

     For i := Low(PhoneticCache) To High(PhoneticCache) Do Begin
          PhoneticCache[i].EnglishT := '';
          PhoneticCache[i].Results.Clear;
     End;

     If ShowPrevWindow = 'YES' Then
          frmPrevW.MakeMeHide;

End;

{===============================================================================}

Procedure TE2BCharBased.SaveCandidateOptions;
Var
     I                        : Integer;
     tmpList                  : TStringList;
Begin
     Try
          Try
               tmpList := TStringList.Create;
               tmpList.Add('// Avro Phonetic Candidate Selection Options');
               For I := 0 To CandidateDict.Count - 1 Do Begin
                    tmpList.Add(CandidateDict.GetKeyByIndex(I) + ' ' + CandidateDict.GetItemByIndex(I));
               End;
               tmpList.SaveToFile(GetAvroDataDir + 'CandidateOptions.dat');
          Except
               On E: Exception Do Begin
                    //Nothing
               End;
          End;
     Finally
          tmpList.Clear;
          FreeAndNil(tmpList);
     End;
End;

{===============================================================================}

Procedure TE2BCharBased.SelectCandidate(Const Item: WideString);
Begin
     NewBanglaText := Item;
     ParseAndSendNow;
     ManuallySelectedCandidate := True;
End;

{===============================================================================}

Procedure TE2BCharBased.SetAutoCorrectEnabled(Const Value: Boolean);
Begin
     Parser.AutoCorrectEnabled := Value;
     FAutoCorrect := Value;
End;

{===============================================================================}

Procedure TE2BCharBased.UpdateCandidateOption;
Var
     Dummy, Middle_Main_T     : AnsiString;
Begin
     CutText(EnglishT, Dummy, Middle_Main_T, Dummy);
     If ManuallySelectedCandidate Then Begin
          If Trim(Middle_Main_T) <> '' Then Begin
               If CandidateDict.HasKey(Middle_Main_T) Then Begin
                    CandidateDict.Item[Middle_Main_T] := utf8encode(NewBanglaText);
               End
               Else Begin
                    CandidateDict.Add(Middle_Main_T, utf8encode(NewBanglaText));
               End;
          End;
     End;
End;

{===============================================================================}

End.

