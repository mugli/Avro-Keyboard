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
     b_Vocalic_L              : Char = #$98C;
     b_Vocalic_LL             : Char = #$9E1;
     b_Vocalic_RR             : Char = #$9E0;
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     ' End Vowels
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     {$ENDREGION}


     {$REGION 'Vowels Signs (Kar/Matra)'}
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'Vowels Signs (Kar/Matra)
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     b_Vocalic_RR_Kar         : Char = #$9C4;
     b_Vocalic_L_Kar          : Char = #$9E2;
     b_Vocalic_LL_Kar         : Char = #$9E3;
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     ' End Vowels Signs (Kar/Matra)
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     {$ENDREGION}


     {$REGION 'Signs'}
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'Signs
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     b_Nukta                  : Char = #$9BC;
     b_Avagraha               : Char = #$9BD;
     b_LengthMark             : Char = #$9D7;
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'End Signs
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     {$ENDREGION}

     {$REGION 'Additional'}
     {'''''''''''''''''''''''''''''''''''''''''''''''''''
     'Additional
     '''''''''''''''''''''''''''''''''''''''''''''''''''}
     b_RupeeMark              : Char = #$9F2;
     b_CurrencyNumerator1     : Char = #$9F4;
     b_CurrencyNumerator2     : Char = #$9F5;
     b_CurrencyNumerator3     : Char = #$9F6;
     b_CurrencyNumerator4     : Char = #$9F7;
     b_CurrencyNumerator1LessThanDenominator: Char = #$9F8;
     b_CurrencyDenominator16  : Char = #$9F9;
     b_CurrencyEsshar         : Char = #$9FA;
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
     b_0                      : Char = #$9E6;
     b_1                      : Char = #$9E7;
     b_2                      : Char = #$9E8;
     b_3                      : Char = #$9E9;
     b_4                      : Char = #$9EA;
     b_5                      : Char = #$9EB;
     b_6                      : Char = #$9EC;
     b_7                      : Char = #$9ED;
     b_8                      : Char = #$9EE;
     b_9                      : Char = #$9EF;
     {'==============================================================
     'End Bangla Numbers
     '==============================================================}
     {$ENDREGION}


     {$REGION 'Bangla Vowels and Kars'}
     {'==============================================================
     'Bangla Vowels and Kars
     '==============================================================}
     b_A                      : Char = #$985;
     b_AA                     : Char = #$986;
     b_AAkar                  : Char = #$9BE;
     b_I                      : Char = #$987;
     b_II                     : Char = #$988;
     b_IIkar                  : Char = #$9C0;
     b_Ikar                   : Char = #$9BF;
     b_U                      : Char = #$989;
     b_Ukar                   : Char = #$9C1;
     b_UU                     : Char = #$98A;
     b_UUkar                  : Char = #$9C2;
     b_RRI                    : Char = #$98B;
     b_RRIkar                 : Char = #$9C3;
     b_E                      : Char = #$98F;
     b_Ekar                   : Char = #$9C7;
     b_O                      : Char = #$993;
     b_OI                     : Char = #$990;
     b_OIkar                  : Char = #$9C8;
     b_Okar                   : Char = #$9CB;
     b_OU                     : Char = #$994;
     b_OUkar                  : Char = #$9CC;
     {'==============================================================
     'End Bangla Vowels and Kars
     '==============================================================}
     {$ENDREGION}


     {$REGION 'Bangla Consonents'}
     {'==============================================================
     'Bangla Consonents
     '==============================================================}
     b_Anushar                : Char = #$982;
     b_B                      : Char = #$9AC;
     b_Bh                     : Char = #$9AD;
     b_Bisharga               : Char = #$983;
     b_C                      : Char = #$99A;
     b_CH                     : Char = #$99B;
     b_Chandra                : Char = #$981;
     b_D                      : Char = #$9A6;
     b_Dd                     : Char = #$9A1;
     b_Ddh                    : Char = #$9A2;
     b_Dh                     : Char = #$9A7;
     b_G                      : Char = #$997;
     b_GH                     : Char = #$998;
     b_H                      : Char = #$9B9;
     b_J                      : Char = #$99C;
     b_JH                     : Char = #$99D;
     b_K                      : Char = #$995;
     b_KH                     : Char = #$996;
     b_L                      : Char = #$9B2;
     b_M                      : Char = #$9AE;
     b_N                      : Char = #$9A8;
     b_NGA                    : Char = #$999;
     b_Nn                     : Char = #$9A3;
     b_NYA                    : Char = #$99E;
     b_P                      : Char = #$9AA;
     b_Ph                     : Char = #$9AB;
     b_R                      : Char = #$9B0;
     b_Rr                     : Char = #$9DC;
     b_Rrh                    : Char = #$9DD;
     b_S                      : Char = #$9B8;
     b_Sh                     : Char = #$9B6;
     b_Ss                     : Char = #$9B7;
     b_T                      : Char = #$9A4;
     b_Th                     : Char = #$9A5;
     b_Tt                     : Char = #$99F;
     b_Tth                    : Char = #$9A0;
     b_Y                      : Char = #$9DF;
     b_Z                      : Char = #$9AF;
     AssamRa                  : Char = #$9F0;
     AssamVa                  : Char = #$9F1;
     b_Khandatta              : Char = #$9CE;
     {'==============================================================
     'End Bangla Consonents
     '==============================================================}
     {$ENDREGION}


     {$REGION 'Bangla Others'}
     {'==============================================================
     'Bangla Others
     '==============================================================}
     b_Dari                   : Char = #$964;
     b_Hasanta                : Char = #$9CD;
     b_Taka                   : Char = #$9F3;
     ZWJ                      : Char = #$200D;
     ZWNJ                     : Char = #$200C;
     {'==============================================================
     'End Bangla Others
     '==============================================================}
     {$ENDREGION}

Function IsVowel(Const strX: String): Boolean;
Function IsPureConsonent(Const strX: String): Boolean;
Function IsKar(Const strX: String): Boolean;

Implementation

{$HINTS Off}

Function IsVowel(Const strX: String): Boolean;
Var
     WC                       : Char;
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

Function IsPureConsonent(Const strX: String): Boolean;
Var
     WC                       : Char;
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

Function IsKar(Const strX: String): Boolean;
Var
     WC                       : Char;
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

