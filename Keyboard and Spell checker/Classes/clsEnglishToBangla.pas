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

{ COMPLETE TRANSFERING! }

Unit clsEnglishToBangla;

Interface

Uses
		 classes,
		 sysutils,
		 StrUtils;


// Skeleton of Class TEnglishToBangla
Type
		 TEnglishToBangla = Class
		 Private
					pEnglishText: String;
					ln: Integer; // Length of English String
					pos: Integer; // Position of processing at English String
					RS: String; // Result String
					AutoCorrect: Boolean;
					DetermineZWNJ_ZWJ: String;

					Procedure CutText(Const inputEStr: String; Var outSIgnore: String; Var outMidMain: String; Var outEIgnore: String);
					Function MyConvert(): String;
					Procedure Dot;
					Procedure smallO;
					Procedure O;
					Procedure h;
					Procedure s;
					Procedure l;
					Procedure R;
					Procedure m;
					Procedure b;
					Procedure p;
					Procedure d;
					Procedure T;
					Procedure J;
					Procedure c;
					Procedure n;
					Procedure k;
					Procedure g;
					Function Cnv(Const Compare: String; Const IfTrue: String): Boolean;
					Procedure AddRs(Const T: String);
					Procedure AddRsEx(Const T: String; p: Integer = 0);
					Function PrevT: String;
					Function PrevTEx(Const Position: Integer): String;
					Function NextT: String;
					Function NextTEx(iLength: Integer; skipstart: Integer = 0): String;
					Function Vowel(Const T: String): Boolean;
					Function Consonent(Const T: String): Boolean;
          Function Number(Const T: String): Boolean;
					Function Begining: Boolean;
		 Public
					Constructor Create; // Initializer
					Function Convert(Const EnglishT: String): String;
					Function CorrectCase(Const inputT: String): String;
					// Published
					Property AutoCorrectEnabled: Boolean Read AutoCorrect Write AutoCorrect;

		 End;

Implementation

Uses
		 uAutoCorrect,
		 BanglaChars,
		 WindowsVersion,
		 uRegistrySettings;

{ TEnglishToBangla }

{ =============================================================================== }

Procedure TEnglishToBangla.AddRs(Const T: String);
Begin
		 RS := RS + T;
		 pos := pos + 1;
End;

{ =============================================================================== }

Procedure TEnglishToBangla.AddRsEx(Const T: String; p: Integer);
Begin
		 RS := RS + T;
		 pos := pos + p;
End;

{ =============================================================================== }

Procedure TEnglishToBangla.b;
Begin
		 If Cnv('bdh', b_B + b_Hasanta + b_Dh) = True Then
					Exit; // B+Dh
		 If Cnv('bhl', b_Bh + b_Hasanta + b_L) = True Then
					Exit; // Bh+L

		 If Cnv('bj', b_B + b_Hasanta + b_J) = True Then
					Exit; // B+J
		 If Cnv('bd', b_B + b_Hasanta + b_D) = True Then
					Exit; // B+D
		 If Cnv('bb', b_B + b_Hasanta + b_B) = True Then
					Exit; // B+B
		 If Cnv('bl', b_B + b_Hasanta + b_L) = True Then
					Exit; // B+L
		 If Cnv('bh', b_Bh) = True Then
					Exit; // Bh
		 If Cnv('vl', b_Bh + b_Hasanta + b_L) = True Then
					Exit; // Bh+L

		 If Cnv('b', b_B) = True Then
					Exit; // B
		 If Cnv('v', b_Bh) = True Then
					Exit; // Bh
End;

{ =============================================================================== }

{$HINTS Off}

Function TEnglishToBangla.Begining: Boolean;
Var
		 T: Char;
		 temp: String;
Begin

		 Result := False;

		 temp := PrevT;
		 T := #0;
		 If length(temp) > 0 Then
					T := temp[1];

		 If length(T) > 0 Then Begin
					Case T Of
							 '0' .. '9':
										Begining := False;
							 'A' .. 'Z':
										Begining := False;
							 'a' .. 'z':
										Begining := False;
							 Else
										Begining := True;
							 End;
		 End
		 Else
					Begining := True;

End;

{$HINTS On}

{ =============================================================================== }

Procedure TEnglishToBangla.c;
Begin
		 If Cnv('cNG', b_C + b_Hasanta + b_NYA) = True Then
					Exit; // C+NYA
		 If Cnv('cch', b_C + b_Hasanta + b_CH) = True Then
					Exit; // C+C
		 If Cnv('cc', b_C + b_Hasanta + b_C) = True Then
					Exit; // C+C
		 // If Cnv('chh', b_CH) = True Then Exit ; //Ch
		 If Cnv('ch', b_CH) = True Then
					Exit; // C
		 If Cnv('c', b_C) = True Then
					Exit; // C
End;

{ =============================================================================== }

{$HINTS Off}

Function TEnglishToBangla.Cnv(Const Compare: String; Const IfTrue: String): Boolean;
Var
		 i: Integer;
		 tmp: String;
Begin
		 Result := False;
		 i := length(Compare);
		 tmp := MidStr(pEnglishText, pos, i);

		 If Compare = tmp Then Begin
					Result := True;
					RS := RS + IfTrue;
					pos := pos + i;
		 End
		 Else
					Result := False;
End;

{$HINTS On}

{ =============================================================================== }

{$HINTS Off}

Function TEnglishToBangla.Consonent(Const T: String): Boolean;
Var
		 temp: Char;
		 myT: String;
Begin
		 Result := False;
		 myT := LowerCase(T);
		 temp := #0;
		 If length(myT) > 0 Then
					temp := myT[1];

		 Case temp Of
					'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z':
							 Consonent := True;
					Else
							 Consonent := False;
					End;
End;

{$HINTS On}

{ =============================================================================== }

Function TEnglishToBangla.Convert(Const EnglishT: String): String;
Var
		 EngStr: String;
		 Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T: String;
		 tempStr: String;
		 DictItem: String;
Begin

		 If EnglishT = '' Then
					Exit;

		 // As is support
		 If AutoCorrect = True Then Begin
					If dict.TryGetValue(EnglishT, DictItem) Then Begin
							 If EnglishT = DictItem Then Begin
										Convert := EnglishT;
										Exit;
							 End;
					End;
		 End;

		 /// ////////////////////

		 EngStr := CorrectCase(EnglishT);

		 If AutoCorrect = True Then Begin
					If dict.TryGetValue(EngStr, DictItem) Then Begin
							 pEnglishText := DictItem;
							 Convert := MyConvert;
					End
					Else Begin
							 // Whole word not found in the dictionary, lets try ignoring punctuations
							 Starting_Ignoreable_T := '';
							 Middle_Main_T := '';
							 Ending_Ignorable_T := '';
							 CutText(EngStr, Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T);

							 If dict.TryGetValue(Middle_Main_T, DictItem) Then Begin
										If Starting_Ignoreable_T <> '' Then Begin
												 pEnglishText := Starting_Ignoreable_T;
												 tempStr := MyConvert;
										End;

										If Middle_Main_T <> '' Then Begin
												 pEnglishText := DictItem;
												 tempStr := tempStr + MyConvert;
										End;

										If Ending_Ignorable_T <> '' Then Begin
												 pEnglishText := Ending_Ignorable_T;
												 tempStr := tempStr + MyConvert;
										End;

										Convert := tempStr;
							 End
							 Else Begin // Autocorrect enabled but word not found even after ignoring punctuations
										pEnglishText := EngStr;
										Convert := MyConvert;
							 End;
					End;
		 End
		 Else Begin
					pEnglishText := EngStr;
					Convert := MyConvert;
		 End;
End;

{ =============================================================================== }

Function TEnglishToBangla.CorrectCase(Const inputT: String): String;
Var
		 i, l: Integer;
		 s, temp: String;
		 T: Char;
Begin
		 l := length(inputT);
		 T := #0;
		 s := '';

		 For i := 1 To l Do Begin
					temp := MidStr(inputT, i, 1);
					If length(temp) > 0 Then
							 T := temp[1];


					Case T Of
							 'o', 'O', 'i', 'I', 'u', 'U':
										s := s + T;
							 'd', 'D', 'g', 'G', 'j', 'n', 'N', 'r', 'R', 's', 'S', 't', 'T', 'y', 'Y', 'z', 'Z':
										s := s + T;
							 'J':
										If EnableJoNukta = 'YES' Then Begin
												 s := s + T;
										End
										Else Begin
												 s := s + LowerCase(T);
										End;
							 Else
										s := s + LowerCase(T);
							 End;
		 End;

		 Result := s;
End;

{ =============================================================================== }

Constructor TEnglishToBangla.Create;
Begin
		 AutoCorrect := True;

		 // If IsWinVistaOrLater Then
		 DetermineZWNJ_ZWJ := ZWJ;
		 // Else
		 // DetermineZWNJ_ZWJ := ZWNJ;
End;

{ =============================================================================== }

Procedure TEnglishToBangla.CutText(Const inputEStr: String; Var outSIgnore, outMidMain, outEIgnore: String);
Var
		 i: Integer;
		 p, q: Integer;
		 EStrLen: Integer;
		 tStr: Char;
		 reverse_inputEStr: String;
		 temporaryString: String;
Begin

		 tStr := #0;
		 p := 0;

		 EStrLen := length(inputEStr);
		 // Start Cutting outSIgnore
		 For i := 1 To EStrLen Do Begin
					temporaryString := MidStr(inputEStr, i, 1);
					If length(temporaryString) > 0 Then
							 tStr := temporaryString[1];
					Case tStr Of
							 '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', #39, '"', ';', '<', '>', '/', '?', '|', '\', '.':

										p := i;

							 ',':
										If MidStr(inputEStr, i + 1, 1) = ',' Then
												 Break
										Else
												 p := i;


							 ':':
										If MidStr(inputEStr, i + 1, 1) = '`' Then
												 p := i
										Else
												 Break;

							 '`':
										If i - 1 >= 1 Then Begin
												 If (MidStr(inputEStr, i - 1, 1) = '.') Or (MidStr(inputEStr, i - 1, 1) = ':') Then
															p := i
												 Else
															Break;
										End
										Else
												 Break;
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
		 For i := 1 To EStrLen - p Do Begin
					temporaryString := MidStr(reverse_inputEStr, i, 1);
					If length(temporaryString) > 0 Then
							 tStr := temporaryString[1];

					Case tStr Of
							 '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', #39, #34, ';', '<', '>', '/', '.', '?', '|', '\':
										q := i;
							 ',':
										If MidStr(reverse_inputEStr, i + 1, 1) = ',' Then
												 Break
										Else
												 q := i;

							 '`':
										If (MidStr(reverse_inputEStr, i + 1, 1) = ':') Or (MidStr(reverse_inputEStr, i + 1, 1) = '.') Then
												 q := i
										Else
												 Break;
							 ':':
										If i - 1 >= 1 Then Begin
												 If MidStr(reverse_inputEStr, i - 1, 1) = '`' Then
															q := i
												 Else
															Break;
										End
										Else
												 Break;
							 Else
										Break;
							 End;
		 End;

		 outEIgnore := RightStr(inputEStr, q);
		 // End Cutting outEIgnore

		 // Start Cutting outMidMain
		 temporaryString := MidStr(inputEStr, p + 1, length(inputEStr));
		 temporaryString := LeftStr(temporaryString, length(temporaryString) - q);
		 outMidMain := temporaryString;


End;

{ =============================================================================== }

Procedure TEnglishToBangla.d;
Begin
		 If Cnv('dhn', b_Dh + b_Hasanta + b_N) = True Then
					Exit; // Dh+N
		 If Cnv('dhm', b_Dh + b_Hasanta + b_M) = True Then
					Exit; // Dh+M
		 If Cnv('dgh', b_D + b_Hasanta + b_GH) = True Then
					Exit; // D+Gh
		 If Cnv('ddh', b_D + b_Hasanta + b_Dh) = True Then
					Exit; // D+Dh
		 If Cnv('dbh', b_D + b_Hasanta + b_Bh) = True Then
					Exit; // D+Bh

		 If Cnv('dv', b_D + b_Hasanta + b_Bh) = True Then
					Exit; // D+Bh
		 If Cnv('dm', b_D + b_Hasanta + b_M) = True Then
					Exit; // D+M
		 If Cnv('DD', b_Dd + b_Hasanta + b_Dd) = True Then
					Exit; // Dd+Dd
		 If Cnv('Dh', b_Ddh) = True Then
					Exit; // Ddh
		 If Cnv('dh', b_Dh) = True Then
					Exit; // Dh
		 If Cnv('dg', b_D + b_Hasanta + b_G) = True Then
					Exit; // D+G
		 If Cnv('dd', b_D + b_Hasanta + b_D) = True Then
					Exit; // D+D

		 If Cnv('D', b_Dd) = True Then
					Exit; // Dd
		 If Cnv('d', b_D) = True Then
					Exit; // D
End;

{ =============================================================================== }

Procedure TEnglishToBangla.Dot;
Begin
		 If Cnv('...', '...') = True Then
					Exit; // ...

		 If Cnv('.`', '.') = True Then
					Exit; // .
		 If Cnv('..', b_Dari + b_Dari) = True Then
					Exit; // ||

     if Number(NextT) = True then begin
       If Cnv('.', '.') = True Then
            Exit; // Decimal Mark
     end
     else
		    If Cnv('.', b_Dari) = True Then
					  Exit; // |
End;

{ =============================================================================== }

Procedure TEnglishToBangla.g;
Begin
		 If Cnv('ghn', b_GH + b_Hasanta + b_N) = True Then
					Exit; // gh+N
		 If Cnv('Ghn', b_GH + b_Hasanta + b_N) = True Then
					Exit; // gh+N

		 If Cnv('gdh', b_G + b_Hasanta + b_Dh) = True Then
					Exit; // g+dh
		 If Cnv('Gdh', b_G + b_Hasanta + b_Dh) = True Then
					Exit; // g+dh

		 If Cnv('gN', b_G + b_Hasanta + b_Nn) = True Then
					Exit; // g+N
		 If Cnv('GN', b_G + b_Hasanta + b_Nn) = True Then
					Exit; // g+N

		 If Cnv('gn', b_G + b_Hasanta + b_N) = True Then
					Exit; // g+n
		 If Cnv('Gn', b_G + b_Hasanta + b_N) = True Then
					Exit; // g+n

		 If Cnv('gm', b_G + b_Hasanta + b_M) = True Then
					Exit; // g+M
		 If Cnv('Gm', b_G + b_Hasanta + b_M) = True Then
					Exit; // g+M

		 If Cnv('gl', b_G + b_Hasanta + b_L) = True Then
					Exit; // g+L
		 If Cnv('Gl', b_G + b_Hasanta + b_L) = True Then
					Exit; // g+L

		 If Cnv('gg', b_J + b_Hasanta + b_NYA) = True Then
					Exit; // gg
		 If Cnv('GG', b_J + b_Hasanta + b_NYA) = True Then
					Exit; // gg
		 If Cnv('Gg', b_J + b_Hasanta + b_NYA) = True Then
					Exit; // gg
		 If Cnv('gG', b_J + b_Hasanta + b_NYA) = True Then
					Exit; // gg

		 If Cnv('gh', b_GH) = True Then
					Exit; // gh
		 If Cnv('Gh', b_GH) = True Then
					Exit; // gh

		 // If Cnv('gb', b_G + b_Hasanta + b_B) = True Then Exit ; //g+b
		 // If Cnv('Gb', b_G + b_Hasanta + b_B) = True Then Exit ; //g+b

		 If Cnv('g', b_G) = True Then
					Exit; // g
		 If Cnv('G', b_G) = True Then
					Exit; // g
End;

{ =============================================================================== }

Procedure TEnglishToBangla.h;
Begin

		 If Cnv('hN', b_H + b_Hasanta + b_Nn) = True Then
					Exit; // H+Nn
		 If Cnv('hn', b_H + b_Hasanta + b_N) = True Then
					Exit; // H+N
		 If Cnv('hm', b_H + b_Hasanta + b_M) = True Then
					Exit; // H+m
		 If Cnv('hl', b_H + b_Hasanta + b_L) = True Then
					Exit; // H+L

		 If Cnv('h', b_H) = True Then
					Exit; // H
End;

{ =============================================================================== }

Procedure TEnglishToBangla.J;
Begin
		 If Cnv('jjh', b_J + b_Hasanta + b_JH) = True Then
					Exit; // J+Jh
		 If Cnv('jNG', b_J + b_Hasanta + b_NYA) = True Then
					Exit; // J+NYA
		 If Cnv('jh', b_JH) = True Then
					Exit; // Jh
		 If Cnv('jj', b_J + b_Hasanta + b_J) = True Then
					Exit; // J+J
		 If Cnv('j', b_J) = True Then
					Exit; // J
		 If EnableJoNukta = 'YES' Then Begin
					If Cnv('J', b_J + b_Nukta) = True Then
							 Exit; // J+Nukta
		 End
		 Else Begin
					If Cnv('J', b_J) = True Then
							 Exit; // J+Nukta
		 End;
End;

{ =============================================================================== }

Procedure TEnglishToBangla.k;
Begin
		 If Cnv('kkhN', b_K + b_Hasanta + b_Ss + b_Hasanta + b_Nn) = True Then
					Exit; // khioN
		 If Cnv('kShN', b_K + b_Hasanta + b_Ss + b_Hasanta + b_Nn) = True Then
					Exit; // khioN
		 If Cnv('kkhm', b_K + b_Hasanta + b_Ss + b_Hasanta + b_M) = True Then
					Exit; // khioM
		 If Cnv('kShm', b_K + b_Hasanta + b_Ss + b_Hasanta + b_M) = True Then
					Exit; // khioM

		 If Cnv('kxN', b_K + b_Hasanta + b_Ss + b_Hasanta + b_Nn) = True Then
					Exit; // khioN
		 If Cnv('kxm', b_K + b_Hasanta + b_Ss + b_Hasanta + b_M) = True Then
					Exit; // khioM
		 If Cnv('kkh', b_K + b_Hasanta + b_Ss) = True Then
					Exit; // khio
		 If Cnv('kSh', b_K + b_Hasanta + b_Ss) = True Then
					Exit; // khio

		 If Cnv('ksh', b_K + b_Sh) = True Then
					Exit; // K`Sh

		 If Cnv('kx', b_K + b_Hasanta + b_Ss) = True Then
					Exit; // khio
		 If Cnv('kk', b_K + b_Hasanta + b_K) = True Then
					Exit; // k+k
		 If Cnv('kT', b_K + b_Hasanta + b_Tt) = True Then
					Exit; // k+T
		 If Cnv('kt', b_K + b_Hasanta + b_T) = True Then
					Exit; // k+t
		 If Cnv('km', b_K + b_Hasanta + b_M) = True Then
					Exit; // k+M
		 If Cnv('kl', b_K + b_Hasanta + b_L) = True Then
					Exit; // k+L
		 If Cnv('ks', b_K + b_Hasanta + b_S) = True Then
					Exit; // k+S

		 If Cnv('kh', b_KH) = True Then
					Exit; // kh

		 If Cnv('k', b_K) = True Then
					Exit; // k
End;

{ =============================================================================== }

Procedure TEnglishToBangla.l;
Begin
		 If Cnv('lbh', b_L + b_Hasanta + b_Bh) = True Then
					Exit; // L+Bh
		 If Cnv('ldh', b_L + b_Hasanta + b_Dh) = True Then
					Exit; // L+Dh

		 If Cnv('lkh', b_L + b_KH) = True Then
					Exit; // L & Kk
		 If Cnv('lgh', b_L + b_GH) = True Then
					Exit; // L & Gh
		 If Cnv('lph', b_L + b_Ph) = True Then
					Exit; // L & Ph

		 If Cnv('lk', b_L + b_Hasanta + b_K) = True Then
					Exit; // L+K
		 If Cnv('lg', b_L + b_Hasanta + b_G) = True Then
					Exit; // L+G
		 If Cnv('lT', b_L + b_Hasanta + b_Tt) = True Then
					Exit; // L+T
		 If Cnv('lD', b_L + b_Hasanta + b_Dd) = True Then
					Exit; // L+Dd
		 If Cnv('lp', b_L + b_Hasanta + b_P) = True Then
					Exit; // L+P
		 If Cnv('lv', b_L + b_Hasanta + b_Bh) = True Then
					Exit; // L+Bh
		 If Cnv('lm', b_L + b_Hasanta + b_M) = True Then
					Exit; // L+M
		 If Cnv('ll', b_L + b_Hasanta + b_L) = True Then
					Exit; // L+L
		 If Cnv('lb', b_L + b_Hasanta + b_B) = True Then
					Exit; // L+B

		 If Cnv('l', b_L) = True Then
					Exit; // L
End;

{ =============================================================================== }

Procedure TEnglishToBangla.m;
Begin
		 If Cnv('mth', b_M + b_Hasanta + b_Th) = True Then
					Exit; // M+Th
		 If Cnv('mph', b_M + b_Hasanta + b_Ph) = True Then
					Exit; // M+Ph
		 If Cnv('mbh', b_M + b_Hasanta + b_Bh) = True Then
					Exit; // M+V
		 If Cnv('mpl', b_M + b_P + b_Hasanta + b_L) = True Then
					Exit; // M+V

		 If Cnv('mn', b_M + b_Hasanta + b_N) = True Then
					Exit; // M+N
		 If Cnv('mp', b_M + b_Hasanta + b_P) = True Then
					Exit; // M+P
		 If Cnv('mv', b_M + b_Hasanta + b_Bh) = True Then
					Exit; // M+V
		 If Cnv('mm', b_M + b_Hasanta + b_M) = True Then
					Exit; // M+M
		 If Cnv('ml', b_M + b_Hasanta + b_L) = True Then
					Exit; // M+L
		 If Cnv('mb', b_M + b_Hasanta + b_B) = True Then
					Exit; // M+B
		 If Cnv('mf', b_M + b_Hasanta + b_Ph) = True Then
					Exit; // M+Ph

		 If Cnv('m', b_M) = True Then
					Exit; // M
End;

{ =============================================================================== }

Function TEnglishToBangla.MyConvert: String;
Var
		 tt: Char;
		 tString: String;
Begin
		 ln := length(pEnglishText);
		 pos := 1;
		 RS := '';

		 Repeat
					tString := MidStr(pEnglishText, pos, 1);
					tt := #0;
					If length(tString) > 0 Then
							 tt := tString[1];

					Case tt Of
							 // --------START Number Generation---------------
							 // 1st, we'll convert numbers. Hassel free :)
							 '0':
										AddRs(b_0);
							 '1':
										AddRs(b_1);
							 '2':
										AddRs(b_2);
							 '3':
										AddRs(b_3);
							 '4':
										AddRs(b_4);
							 '5':
										AddRs(b_5);
							 '6':
										AddRs(b_6);
							 '7':
										AddRs(b_7);
							 '8':
										AddRs(b_8);
							 '9':
										AddRs(b_9);
							 // ------------End Number Generation-------------



							 // --------START Vowel Generation---------------
							 // 2nd, we'll convert Vowels.Comperatively easy

							 'o':
										smallO(); // SmallO

							 'a', 'A':
										If NextT = 'Z' Then
												 AddRsEx(b_A + b_Hasanta + b_Z + b_AAkar, 2)
										Else If (Begining = True) And (NextT <> '`') Then
												 AddRs(b_AA)
										Else If (Consonent(PrevT) = False) And (PrevT <> 'a') And (NextT <> '`') Then
												 AddRs(b_Y + b_AAkar)
										Else If NextT = '`' Then
												 AddRsEx(b_AAkar, 2)
										Else If (PrevT = 'a') And (NextT <> '`') Then
												 AddRs(b_AA)
										Else
												 AddRs(b_AAkar);

							 'i':
										If ((Consonent(PrevT) = False) Or (Begining = True)) And (NextT <> '`') Then
												 AddRs(b_I)
										Else If NextT = '`' Then
												 AddRsEx(b_Ikar, 2)
										Else
												 AddRs(b_Ikar);

							 'I':
										If ((Consonent(PrevT) = False) Or (Begining = True)) And (NextT <> '`') Then
												 AddRs(b_II)
										Else If NextT = '`' Then
												 AddRsEx(b_IIkar, 2)
										Else
												 AddRs(b_IIkar);

							 'u':
										If ((Consonent(PrevT) = False) Or (Begining = True)) And (NextT <> '`') Then
												 AddRs(b_U)
										Else If NextT = '`' Then
												 AddRsEx(b_Ukar, 2)
										Else
												 AddRs(b_Ukar);

							 'U':
										If ((Consonent(PrevT) = False) Or (Begining = True)) And (NextT <> '`') Then
												 AddRs(b_UU)
										Else If NextT = '`' Then
												 AddRsEx(b_UUkar, 2)
										Else
												 AddRs(b_UUkar);
							 // We'll process ra, Ra,Rha, rri, rrikar, ra fola, reph later

							 'e', 'E':
										If ((Consonent(PrevT) = False) Or (Begining = True)) And (NextT <> '`') Then Begin
												 If NextT = 'e' Then
															AddRsEx(b_II, 2)
												 Else
															AddRs(b_E);
										End
										Else If NextT = '`' Then
												 AddRsEx(b_Ekar, 2)
										Else Begin
												 If NextT = 'e' Then
															AddRsEx(b_IIkar, 2)
												 Else
															AddRs(b_Ekar);
										End;

							 // Now-O,OI,OU processing! Its  fun man:)

							 'O':
										O(); // Capital O
							 // -----------------End Vowel Generation---------------

							 // -----------------START Consonent Processing---------------
							 'k':
										k();
							 'G', 'g':
										g();
							 'N', 'n':
										n();
							 'c':
										c();
							 'J', 'j':
										J();
							 'T', 't':
										T();
							 'D', 'd':
										d();
							 'p', 'f':
										p();
							 'b', 'v':
										b();
							 'm':
										m();
							 'z':
										AddRs(b_Z);
							 'Z':
										If PrevT = 'r' Then Begin
												 If (Consonent(PrevTEx(2)) = True) And (PrevTEx(2) <> 'r') And (PrevTEx(2) <> 'y') And (PrevTEx(2) <> 'w') And (PrevTEx(2) <> 'x') Then
															// Previous character is R-Fola, don't add ZWJ
															AddRs(b_Hasanta + b_Z)
												 Else
															AddRs(DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
										End
										Else
												 AddRs(b_Hasanta + b_Z);

							 'R', 'r':
										R();
							 'l':
										l();
							 'S', 's':
										s();
							 'h':
										h();
							 'y':
										If (Consonent(PrevT) = False) And (Begining <> True) Then
												 AddRs(b_Y)
										Else If Begining = True Then
												 AddRs(b_I + b_Y)
										Else Begin
												 If PrevT = 'r' Then Begin
															If (Consonent(PrevTEx(2)) = True) And (PrevTEx(2) <> 'r') And (PrevTEx(2) <> 'y') And (PrevTEx(2) <> 'w') And (PrevTEx(2) <> 'x') Then
																	 // Previous character is R-Fola, don't add ZWJ
																	 AddRs(b_Hasanta + b_Z)
															Else
																	 AddRs(DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
												 End
												 Else
															AddRs(b_Hasanta + b_Z);
										End;

							 'Y':
										AddRs(b_Y); // Force Y
							 'w':
										If (Begining = True) And (Vowel(NextT) = True) Then
												 AddRs(b_O + b_Y)
										Else If Consonent(PrevT) = True Then
												 AddRs(b_Hasanta + b_B)
										Else
												 AddRs(b_O);

							 'q':
										AddRs(b_K);
							 'x':
										If Begining = True Then
												 AddRs(b_E + b_K + b_Hasanta + b_S)
										Else
												 AddRs(b_K + b_Hasanta + b_S);
							 // -----------------End Consonent Generation---------------

							 // -----------------Start Symbol Generation---------------
							 '.':
										Dot();
							 ':':
										If NextT <> '`' Then
												 AddRs(b_Bisharga)
										Else
												 AddRsEx(':', 2);

							 '^':
										If NextT <> '`' Then
												 AddRs(b_Chandra)
										Else
												 AddRsEx('^', 2);


							 ',':
										If NextT = ',' Then
												 AddRsEx(b_Hasanta + ZWNJ, 2)
										Else
												 AddRs(',');

							 '$':
										AddRs(b_Taka);

							 // -----------------End Symbol Generation---------------


							 // ` - Make sure it is just above case else!
							 '`':
										pos := pos + 1; // No change made here,just to bypass juktakkhar making

							 Else
										AddRs(tt);

							 End;

		 Until pos > ln;

		 MyConvert := RS;

End;

{ =============================================================================== }

Procedure TEnglishToBangla.n;
Begin

		 If Cnv('NgkSh', b_NGA + b_Hasanta + b_K + b_Hasanta + b_Ss) = True Then
					Exit; // NGA+Khio
		 If Cnv('Ngkkh', b_NGA + b_Hasanta + b_K + b_Hasanta + b_Ss) = True Then
					Exit; // NGA+Khio


		 If Cnv('NGch', b_NYA + b_Hasanta + b_CH) = True Then
					Exit; // NYA+Ch
		 If Cnv('Nggh', b_NGA + b_Hasanta + b_GH) = True Then
					Exit; // NGA+Gh
		 If Cnv('Ngkh', b_NGA + b_Hasanta + b_KH) = True Then
					Exit; // NGA+Kh
		 If Cnv('NGjh', b_NYA + b_Hasanta + b_JH) = True Then
					Exit; // NYA+Jh
		 If Cnv('ngOU', b_NGA + b_Hasanta + b_G + b_OUkar) = True Then
					Exit; // NGA+G
		 If Cnv('ngOI', b_NGA + b_Hasanta + b_G + b_OIkar) = True Then
					Exit; // NGA+G
		 If Cnv('Ngkx', b_NGA + b_Hasanta + b_K + b_Hasanta + b_Ss) = True Then
					Exit; // NGA+Khio

		 If Cnv('NGc', b_NYA + b_Hasanta + b_C) = True Then
					Exit; // NYA+Ch
		 If Cnv('nch', b_NYA + b_Hasanta + b_CH) = True Then
					Exit; // NYA+Ch
		 If Cnv('njh', b_NYA + b_Hasanta + b_JH) = True Then
					Exit; // NYA+Jh
		 If Cnv('ngh', b_NGA + b_Hasanta + b_GH) = True Then
					Exit; // NGA+Gh
		 If Cnv('Ngk', b_NGA + b_Hasanta + b_K) = True Then
					Exit; // NGA+K
		 If Cnv('Ngx', b_NGA + b_Hasanta + b_Ss) = True Then
					Exit; // NGA+Khio
		 If Cnv('Ngg', b_NGA + b_Hasanta + b_G) = True Then
					Exit; // NGA+G
		 If Cnv('Ngm', b_NGA + b_Hasanta + b_M) = True Then
					Exit; // NGA+M
		 If Cnv('NGj', b_NYA + b_Hasanta + b_J) = True Then
					Exit; // NYA+J
		 If Cnv('ndh', b_N + b_Hasanta + b_Dh) = True Then
					Exit; // N+Dh
		 If Cnv('nTh', b_N + b_Hasanta + b_Tth) = True Then
					Exit; // N+Tth
		 If Cnv('NTh', b_Nn + b_Hasanta + b_Tth) = True Then
					Exit; // Nn+Tth
		 If Cnv('nth', b_N + b_Hasanta + b_Th) = True Then
					Exit; // N+Th
		 If Cnv('nkh', b_NGA + b_Hasanta + b_KH) = True Then
					Exit; // NGA+Kh
		 If Cnv('ngo', b_NGA + b_Hasanta + b_G) = True Then
					Exit; // NGA+G
		 If Cnv('nga', b_NGA + b_Hasanta + b_G + b_AAkar) = True Then
					Exit; // NGA+G
		 If Cnv('ngi', b_NGA + b_Hasanta + b_G + b_Ikar) = True Then
					Exit; // NGA+G
		 If Cnv('ngI', b_NGA + b_Hasanta + b_G + b_IIkar) = True Then
					Exit; // NGA+G
		 If Cnv('ngu', b_NGA + b_Hasanta + b_G + b_Ukar) = True Then
					Exit; // NGA+G
		 If Cnv('ngU', b_NGA + b_Hasanta + b_G + b_UUkar) = True Then
					Exit; // NGA+G
		 If Cnv('nge', b_NGA + b_Hasanta + b_G + b_Ekar) = True Then
					Exit; // NGA+G
		 If Cnv('ngO', b_NGA + b_Hasanta + b_G + b_Okar) = True Then
					Exit; // NGA+G
		 If Cnv('NDh', b_Nn + b_Hasanta + b_Ddh) = True Then
					Exit; // Nn+Ddh

		 If Cnv('nsh', b_N + b_Sh) = True Then
					Exit; // N & Sh

		 If Cnv('Ngr', b_NGA + b_R) = True Then
					Exit; // NGA & R
		 If Cnv('NGr', b_NYA + b_R) = True Then
					Exit; // NYA & R
		 If Cnv('ngr', b_Anushar + b_R) = True Then
					Exit; // Anushar & R

		 If Cnv('nj', b_NYA + b_Hasanta + b_J) = True Then
					Exit; // NYA+J
		 If Cnv('Ng', b_NGA) = True Then
					Exit; // NGA
		 If Cnv('NG', b_NYA) = True Then
					Exit; // NYA
		 If Cnv('nk', b_NGA + b_Hasanta + b_K) = True Then
					Exit; // NGA+K
		 If Cnv('ng', b_Anushar) = True Then
					Exit; // Anushar
		 If Cnv('nn', b_N + b_Hasanta + b_N) = True Then
					Exit; // N+N
		 If Cnv('NN', b_Nn + b_Hasanta + b_Nn) = True Then
					Exit; // Nn+Nn
		 If Cnv('Nn', b_Nn + b_Hasanta + b_N) = True Then
					Exit; // Nn+N
		 If Cnv('nm', b_N + b_Hasanta + b_M) = True Then
					Exit; // N+M
		 If Cnv('Nm', b_Nn + b_Hasanta + b_M) = True Then
					Exit; // Nn+M
		 If Cnv('nd', b_N + b_Hasanta + b_D) = True Then
					Exit; // N+D
		 If Cnv('nT', b_N + b_Hasanta + b_Tt) = True Then
					Exit; // N+Tt
		 If Cnv('NT', b_Nn + b_Hasanta + b_Tt) = True Then
					Exit; // Nn+Tt
		 If Cnv('nD', b_N + b_Hasanta + b_Dd) = True Then
					Exit; // N+Dd
		 If Cnv('ND', b_Nn + b_Hasanta + b_Dd) = True Then
					Exit; // Nn+Dd
		 If Cnv('nt', b_N + b_Hasanta + b_T) = True Then
					Exit; // N+T
		 If Cnv('ns', b_N + b_Hasanta + b_S) = True Then
					Exit; // N+S
		 If Cnv('nc', b_NYA + b_Hasanta + b_C) = True Then
					Exit; // NYA+C

		 If Cnv('n', b_N) = True Then
					Exit; // N
		 If Cnv('N', b_Nn) = True Then
					Exit; // N
End;

{ =============================================================================== }

Function TEnglishToBangla.NextT: String;
Begin
		 NextT := MidStr(pEnglishText, pos + 1, 1);
End;

{ =============================================================================== }

Function TEnglishToBangla.NextTEx(iLength: Integer; skipstart: Integer): String;
Begin
		 If iLength < 1 Then
					iLength := 1;

		 NextTEx := MidStr(pEnglishText, pos + skipstart + 1, iLength);
End;

{ =============================================================================== }

Procedure TEnglishToBangla.O;
Begin
		 If Cnv('OI`', b_OIkar) = True Then
					Exit; // OIKar
		 If Cnv('OU`', b_OUkar) = True Then
					Exit; // OUKar

		 If Cnv('O`', b_Okar) = True Then
					Exit; // OKar

		 If (Consonent(PrevT) = False) Or (Begining = True) Then Begin
					If Cnv('OI', b_OI) = True Then
							 Exit; // OI
					If Cnv('OU', b_OU) = True Then
							 Exit; // OU
					If Cnv('O', b_O) = True Then
							 Exit; // O
		 End
		 Else Begin
					If Cnv('OI', b_OIkar) = True Then
							 Exit; // OIKar
					If Cnv('OU', b_OUkar) = True Then
							 Exit; // OUKar
					If Cnv('O', b_Okar) = True Then
							 Exit; // OKar
		 End;
End;

{ =============================================================================== }

Procedure TEnglishToBangla.p;
Begin
		 If Cnv('phl', b_Ph + b_Hasanta + b_L) = True Then
					Exit; // Ph+L

		 If Cnv('pT', b_P + b_Hasanta + b_Tt) = True Then
					Exit; // P+Tt
		 If Cnv('pt', b_P + b_Hasanta + b_T) = True Then
					Exit; // P+T
		 If Cnv('pn', b_P + b_Hasanta + b_N) = True Then
					Exit; // P+N
		 If Cnv('pp', b_P + b_Hasanta + b_P) = True Then
					Exit; // P+P
		 If Cnv('pl', b_P + b_Hasanta + b_L) = True Then
					Exit; // P+L
		 If Cnv('ps', b_P + b_Hasanta + b_S) = True Then
					Exit; // P+S
		 If Cnv('ph', b_Ph) = True Then
					Exit; // Ph
		 If Cnv('fl', b_Ph + b_Hasanta + b_L) = True Then
					Exit; // Ph+L

		 If Cnv('f', b_Ph) = True Then
					Exit; // Ph
		 If Cnv('p', b_P) = True Then
					Exit; // P
End;

{ =============================================================================== }

Function TEnglishToBangla.PrevT: String;
Var
		 i: Integer;
Begin

		 i := pos - 1;
		 If i < 1 Then Begin
					PrevT := '';
					Exit;
		 End;

		 PrevT := MidStr(pEnglishText, i, 1);
End;

{ =============================================================================== }

Function TEnglishToBangla.PrevTEx(Const Position: Integer): String;
Var
		 i: Integer;
Begin
		 i := pos - Position;
		 If i < 1 Then Begin
					PrevTEx := '';
					Exit;
		 End;

		 PrevTEx := MidStr(pEnglishText, i, 1);
End;

{ =============================================================================== }

Procedure TEnglishToBangla.R;
Begin
		 If NextTEx(1, 2) = '`' Then Begin
					If Cnv('rri', b_RRIkar) = True Then
							 Exit; // RRI-Kar
		 End;

		 If Consonent(PrevT) = False Then Begin
					If Cnv('rri', b_RRI) = True Then
							 Exit; // RRI
		 End
		 Else If Begining = True Then Begin
					If Cnv('rri', b_RRI) = True Then
							 Exit; // RRI
		 End
		 Else Begin
					If Cnv('rri', b_RRIkar) = True Then
							 Exit; // RRI-Kar
		 End;

		 If (Consonent(PrevT) = False) And (Vowel(NextTEx(1, 1)) = False) And (NextTEx(1, 1) <> 'r') And (NextTEx(1, 1) <> '') Then Begin
					If Cnv('rr', b_R + b_Hasanta) = True Then
							 Exit; // Reph
		 End;

		 If Cnv('Rg', b_Rr + b_Hasanta + b_G) = True Then
					Exit; // Rh+G
		 If Cnv('Rh', b_Rrh) = True Then
					Exit; // Rrh

		 If (Consonent(PrevT) = True) And (PrevT <> 'r') And (PrevT <> 'y') And (PrevT <> 'w') And (PrevT <> 'x') And (PrevT <> 'Z') Then Begin
					If Cnv('r', b_Hasanta + b_R) = True Then
							 Exit; // R-Fola
		 End
		 Else Begin
					If Cnv('r', b_R) = True Then
							 Exit; // R
		 End;

		 If Cnv('R', b_Rr) = True Then
					Exit; // Rh
End;

{ =============================================================================== }

Procedure TEnglishToBangla.s;
Begin
		 If Cnv('shch', b_Sh + b_Hasanta + b_CH) = True Then
					Exit; // Sh+Chh
		 If Cnv('ShTh', b_Ss + b_Hasanta + b_Tth) = True Then
					Exit; // Sh+Tth
		 If Cnv('Shph', b_Ss + b_Hasanta + b_Ph) = True Then
					Exit; // Sh+Ph

		 If Cnv('Sch', b_Sh + b_Hasanta + b_CH) = True Then
					Exit; // Sh+Chh
		 If Cnv('skl', b_S + b_Hasanta + b_K + b_Hasanta + b_L) = True Then
					Exit; // S+K+L
		 If Cnv('skh', b_S + b_Hasanta + b_KH) = True Then
					Exit; // S+Kh
		 If Cnv('sth', b_S + b_Hasanta + b_Th) = True Then
					Exit; // S+Th
		 If Cnv('sph', b_S + b_Hasanta + b_Ph) = True Then
					Exit; // S+Ph
		 If Cnv('shc', b_Sh + b_Hasanta + b_C) = True Then
					Exit; // Sh+C
		 If Cnv('sht', b_Sh + b_Hasanta + b_T) = True Then
					Exit; // Sh+T
		 If Cnv('shn', b_Sh + b_Hasanta + b_N) = True Then
					Exit; // Sh+N
		 If Cnv('shm', b_Sh + b_Hasanta + b_M) = True Then
					Exit; // Sh+M
		 If Cnv('shl', b_Sh + b_Hasanta + b_L) = True Then
					Exit; // Sh+L
		 If Cnv('Shk', b_Ss + b_Hasanta + b_K) = True Then
					Exit; // Sh+K
		 If Cnv('ShT', b_Ss + b_Hasanta + b_Tt) = True Then
					Exit; // Sh+Tt
		 If Cnv('ShN', b_Ss + b_Hasanta + b_Nn) = True Then
					Exit; // Sh+Nn
		 If Cnv('Shp', b_Ss + b_Hasanta + b_P) = True Then
					Exit; // Sh+P
		 If Cnv('Shf', b_Ss + b_Hasanta + b_Ph) = True Then
					Exit; // Sh+Ph
		 If Cnv('Shm', b_Ss + b_Hasanta + b_M) = True Then
					Exit; // Sh+M
		 If Cnv('spl', b_S + b_Hasanta + b_P + b_Hasanta + b_L) = True Then
					Exit; // s+p+l

		 If Cnv('sk', b_S + b_Hasanta + b_K) = True Then
					Exit; // S+K
		 If Cnv('Sc', b_Sh + b_Hasanta + b_C) = True Then
					Exit; // Sh+Ch
		 If Cnv('sT', b_S + b_Hasanta + b_Tt) = True Then
					Exit; // S+Tt
		 If Cnv('st', b_S + b_Hasanta + b_T) = True Then
					Exit; // S+T
		 If Cnv('sn', b_S + b_Hasanta + b_N) = True Then
					Exit; // S+N
		 If Cnv('sp', b_S + b_Hasanta + b_P) = True Then
					Exit; // S+P
		 If Cnv('sf', b_S + b_Hasanta + b_Ph) = True Then
					Exit; // S+Ph
		 If Cnv('sm', b_S + b_Hasanta + b_M) = True Then
					Exit; // S+M
		 If Cnv('sl', b_S + b_Hasanta + b_L) = True Then
					Exit; // S+L
		 If Cnv('sh', b_Sh) = True Then
					Exit; // Sh
		 If Cnv('Sc', b_Sh + b_Hasanta + b_C) = True Then
					Exit; // Sh+Ch
		 If Cnv('St', b_Sh + b_Hasanta + b_T) = True Then
					Exit; // Sh+T
		 If Cnv('Sn', b_Sh + b_Hasanta + b_N) = True Then
					Exit; // Sh+N
		 If Cnv('Sm', b_Sh + b_Hasanta + b_M) = True Then
					Exit; // Sh+M
		 If Cnv('Sl', b_Sh + b_Hasanta + b_L) = True Then
					Exit; // Sh+L
		 If Cnv('Sh', b_Ss) = True Then
					Exit; // Sh

		 If Cnv('s', b_S) = True Then
					Exit; // S
		 If Cnv('S', b_Sh) = True Then
					Exit; // Sh
End;

{ =============================================================================== }

Procedure TEnglishToBangla.smallO;
Begin
		 If ((Consonent(PrevT) = False) Or (Begining = True)) And (NextT <> '`') Then Begin
					If Cnv('oo', b_U) = True Then
							 Exit; // U
					If Cnv('oZ', b_A + b_Hasanta + b_Z) = True Then
							 Exit; // U

					If (Vowel(PrevT) = True) And (PrevT <> 'o') Then Begin
							 If Cnv('o', b_O) = True Then
										Exit; // O
					End
					Else If Cnv('o', b_A) = True Then
							 Exit; // A
		 End;

		 If Cnv('oo', b_Ukar) = True Then
					Exit; // U Kar
		 If Cnv('o`', '') = True Then
					Exit; // Nothing
		 If Cnv('o', '') = True Then
					Exit; // Nothing
End;

{ =============================================================================== }

Procedure TEnglishToBangla.T;
Begin
		 If Cnv('tth', b_T + b_Hasanta + b_Th) = True Then
					Exit; // T+Th
		 If Cnv('t``', b_Khandatta) = True Then
					Exit; // Khandatta

		 If Cnv('TT', b_Tt + b_Hasanta + b_Tt) = True Then
					Exit; // Tt+Tt
		 If Cnv('Tm', b_Tt + b_Hasanta + b_M) = True Then
					Exit; // Tt+M
		 If Cnv('Th', b_Tth) = True Then
					Exit; // Tth
		 If Cnv('tn', b_T + b_Hasanta + b_N) = True Then
					Exit; // T+N
		 If Cnv('tm', b_T + b_Hasanta + b_M) = True Then
					Exit; // T+M
		 If Cnv('th', b_Th) = True Then
					Exit; // Th
		 If Cnv('tt', b_T + b_Hasanta + b_T) = True Then
					Exit; // T+T

		 If Cnv('T', b_Tt) = True Then
					Exit; // Tt
		 If Cnv('t', b_T) = True Then
					Exit; // T
End;

{ =============================================================================== }

{$HINTS Off}

Function TEnglishToBangla.Vowel(Const T: String): Boolean;
Var
		 myT: String;
Begin
		 Result := False;
		 myT := LowerCase(T);
		 If length(myT) > 0 Then
					myT := myT[1];
		 If (myT = 'a') Or (myT = 'e') Or (myT = 'i') Or (myT = 'o') Or (myT = 'u') Then
					Result := True
		 Else
					Result := False;

End;


Function TEnglishToBangla.Number(Const T: String): Boolean;
Var
		 temp: Char;
		 myT: String;
Begin
		 Result := False;
		 myT := LowerCase(T);
		 temp := #0;
		 If length(myT) > 0 Then
					temp := myT[1];

		 Case temp Of
					'0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
							 Number := True;
					Else
							 Number := False;
					End;
End;

{$HINTS On}


End.
