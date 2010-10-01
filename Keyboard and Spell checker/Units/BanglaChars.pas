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


{$IFDEF SpellChecker}
{$INCLUDE ../../ProjectDefines.inc}
{$ELSE}
{$INCLUDE ../ProjectDefines.inc}
{$ENDIF}

{COMPLETE TRANSFERING!}

Unit BanglaChars;

Interface

Const
     {$REGION 'Unusual Bangla Characters'}
     {
     '==============================================================
     '==============================================================
     'Unusual Bangla Characters
     }

     {$REGION 'Vowels'}
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'Vowels
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     b_Vocalic_L              : WideChar = #$98C;
     b_Vocalic_LL             : WideChar = #$9E1;
     b_Vocalic_RR             : WideChar = #$9E0;
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     ' End Vowels
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     {$ENDREGION}


     {$REGION 'Vowels Signs (Kar/Matra)'}
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'Vowels Signs (Kar/Matra)
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     b_Vocalic_RR_Kar         : WideChar = #$9C4;
     b_Vocalic_L_Kar          : WideChar = #$9E2;
     b_Vocalic_LL_Kar         : WideChar = #$9E3;
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     ' End Vowels Signs (Kar/Matra)
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     {$ENDREGION}


     {$REGION 'Signs'}
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'Signs
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     b_Nukta                  : WideChar = #$9BC;
     b_Avagraha               : WideChar = #$9BD;
     b_LengthMark             : WideChar = #$9D7;
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'End Signs
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     {$ENDREGION}

     {$REGION 'Additional'}
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'Additional
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     b_RupeeMark              : WideChar = #$9F2;
     b_CurrencyNumerator1     : WideChar = #$9F4;
     b_CurrencyNumerator2     : WideChar = #$9F5;
     b_CurrencyNumerator3     : WideChar = #$9F6;
     b_CurrencyNumerator4     : WideChar = #$9F7;
     b_CurrencyNumerator1LessThanDenominator: WideChar = #$9F8;
     b_CurrencyDenominator16  : WideChar = #$9F9;
     b_CurrencyEsshar         : WideChar = #$9FA;
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'End Additional
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     {$ENDREGION}

     {'End Unusual Bangla Characters
     '==============================================================
     '==============================================================}
     {$ENDREGION}


     {$REGION 'Bangla Numbers'}
     {'==============================================================
     'Bangla Numbers
     '==============================================================}
     b_0                      : WideChar = #$9E6;
     b_1                      : WideChar = #$9E7;
     b_2                      : WideChar = #$9E8;
     b_3                      : WideChar = #$9E9;
     b_4                      : WideChar = #$9EA;
     b_5                      : WideChar = #$9EB;
     b_6                      : WideChar = #$9EC;
     b_7                      : WideChar = #$9ED;
     b_8                      : WideChar = #$9EE;
     b_9                      : WideChar = #$9EF;
     {'==============================================================
     'End Bangla Numbers
     '==============================================================}
     {$ENDREGION}


     {$REGION 'Bangla Vowels and Kars'}
     {'==============================================================
     'Bangla Vowels and Kars
     '==============================================================}
     b_A                      : WideChar = #$985;
     b_AA                     : WideChar = #$986;
     b_AAkar                  : WideChar = #$9BE;
     b_I                      : WideChar = #$987;
     b_II                     : WideChar = #$988;
     b_IIkar                  : WideChar = #$9C0;
     b_Ikar                   : WideChar = #$9BF;
     b_U                      : WideChar = #$989;
     b_Ukar                   : WideChar = #$9C1;
     b_UU                     : WideChar = #$98A;
     b_UUkar                  : WideChar = #$9C2;
     b_RRI                    : WideChar = #$98B;
     b_RRIkar                 : WideChar = #$9C3;
     b_E                      : WideChar = #$98F;
     b_Ekar                   : WideChar = #$9C7;
     b_O                      : WideChar = #$993;
     b_OI                     : WideChar = #$990;
     b_OIkar                  : WideChar = #$9C8;
     b_Okar                   : WideChar = #$9CB;
     b_OU                     : WideChar = #$994;
     b_OUkar                  : WideChar = #$9CC;
     {'==============================================================
     'End Bangla Vowels and Kars
     '==============================================================}
     {$ENDREGION}


     {$REGION 'Bangla Consonents'}
     {'==============================================================
     'Bangla Consonents
     '==============================================================}
     b_Anushar                : WideChar = #$982;
     b_B                      : WideChar = #$9AC;
     b_Bh                     : WideChar = #$9AD;
     b_Bisharga               : WideChar = #$983;
     b_C                      : WideChar = #$99A;
     b_CH                     : WideChar = #$99B;
     b_Chandra                : WideChar = #$981;
     b_D                      : WideChar = #$9A6;
     b_Dd                     : WideChar = #$9A1;
     b_Ddh                    : WideChar = #$9A2;
     b_Dh                     : WideChar = #$9A7;
     b_G                      : WideChar = #$997;
     b_GH                     : WideChar = #$998;
     b_H                      : WideChar = #$9B9;
     b_J                      : WideChar = #$99C;
     b_JH                     : WideChar = #$99D;
     b_K                      : WideChar = #$995;
     b_KH                     : WideChar = #$996;
     b_L                      : WideChar = #$9B2;
     b_M                      : WideChar = #$9AE;
     b_N                      : WideChar = #$9A8;
     b_NGA                    : WideChar = #$999;
     b_Nn                     : WideChar = #$9A3;
     b_NYA                    : WideChar = #$99E;
     b_P                      : WideChar = #$9AA;
     b_Ph                     : WideChar = #$9AB;
     b_R                      : WideChar = #$9B0;
     b_Rr                     : WideChar = #$9DC;
     b_Rrh                    : WideChar = #$9DD;
     b_S                      : WideChar = #$9B8;
     b_Sh                     : WideChar = #$9B6;
     b_Ss                     : WideChar = #$9B7;
     b_T                      : WideChar = #$9A4;
     b_Th                     : WideChar = #$9A5;
     b_Tt                     : WideChar = #$99F;
     b_Tth                    : WideChar = #$9A0;
     b_Y                      : WideChar = #$9DF;
     b_Z                      : WideChar = #$9AF;
     AssamRa                  : WideChar = #$9F0;
     AssamVa                  : WideChar = #$9F1;
     b_Khandatta              : WideChar = #$9CE;
     {'==============================================================
     'End Bangla Consonents
     '==============================================================}
     {$ENDREGION}


     {$REGION 'Bangla Others'}
     {'==============================================================
     'Bangla Others
     '==============================================================}
     b_Dari                   : WideChar = #$964;
     b_Hasanta                : WideChar = #$9CD;
     b_Taka                   : WideChar = #$9F3;
     ZWJ                      : WideChar = #$200D;
     ZWNJ                     : WideChar = #$200C;
     {'==============================================================
     'End Bangla Others
     '==============================================================}
     {$ENDREGION}

Function IsVowel(Const strX: WideString): Boolean;
Function IsPureConsonent(Const strX: WideString): Boolean;
Function IsKar(Const strX: WideString): Boolean;

Implementation

{$HINTS Off}

Function IsVowel(Const strX: WideString): Boolean;
Var
     WC                       : Widechar;
Begin

     Result := false;


     WC := strx[1];

     If (WC = b_A) Or
          (WC = b_AA) Or
          (WC = b_AAkar) Or
          (WC = b_I) Or
          (WC = b_II) Or
          (WC = b_IIkar) Or
          (WC = b_Ikar) Or
          (WC = b_U) Or
          (WC = b_Ukar) Or
          (WC = b_UU) Or
          (WC = b_UUkar) Or
          (WC = b_RRI) Or
          (WC = b_RRIkar) Or
          (WC = b_E) Or
          (WC = b_Ekar) Or
          (WC = b_OI) Or
          (WC = b_OIkar) Or
          (WC = b_O) Or
          (WC = b_Okar) Or
          (WC = b_OU) Or
          (WC = b_OUkar) Or
          (WC = b_Vocalic_L) Or
          (WC = b_Vocalic_LL) Or
          (WC = b_Vocalic_RR) Or
          (WC = b_Vocalic_RR_Kar) Or
          (WC = b_Vocalic_L_Kar) Or
          (WC = b_Vocalic_LL_Kar) Then
          Result := True
     Else
          Result := false;

End;
{$HINTS On}

{$HINTS Off}

Function IsPureConsonent(Const strX: WideString): Boolean;
Var
     WC                       : Widechar;
Begin

     Result := false;

     WC := strX[1];

     If (WC = b_B) Or
          (WC = b_Bh) Or
          (WC = b_C) Or
          (WC = b_CH) Or
          (WC = b_D) Or
          (WC = b_Dd) Or
          (WC = b_Ddh) Or
          (WC = b_Dh) Or
          (WC = b_G) Or
          (WC = b_GH) Or
          (WC = b_H) Or
          (WC = b_J) Or
          (WC = b_JH) Or
          (WC = b_K) Or
          (WC = b_KH) Or
          (WC = b_L) Or
          (WC = b_M) Or
          (WC = b_N) Or
          (WC = b_NGA) Or
          (WC = b_Nn) Or
          (WC = b_NYA) Or
          (WC = b_P) Or
          (WC = b_Ph) Or
          (WC = b_R) Or
          (WC = b_Rr) Or
          (WC = b_Rrh) Or
          (WC = b_S) Or
          (WC = b_Sh) Or
          (WC = b_Ss) Or
          (WC = b_T) Or
          (WC = b_Th) Or
          (WC = b_Tt) Or
          (WC = b_Tth) Or
          (WC = b_Z) Or
          (WC = b_Y) Or
          (WC = b_Khandatta) Or
          (WC = AssamRa) Or
          (WC = AssamVa) Then
          Result := True
     Else
          Result := False;
End;
{$HINTS On}

{$HINTS Off}

Function IsKar(Const strX: WideString): Boolean;
Var
     // pWC                      : PWidechar;
     WC                       : Widechar;
Begin

     Result := false;


     WC := strX[1];

     If (WC = b_AAkar) Or
          (WC = b_IIkar) Or
          (WC = b_Ikar) Or
          (WC = b_Ukar) Or
          (WC = b_UUkar) Or
          (WC = b_RRIkar) Or
          (WC = b_Ekar) Or
          (WC = b_OIkar) Or
          (WC = b_OUkar) Or
          (WC = b_Vocalic_RR_Kar) Or
          (WC = b_Vocalic_L_Kar) Or
          (WC = b_Vocalic_LL_Kar) Then
          Result := True
     Else
          Result := False;

End;
{$HINTS On}

End.

