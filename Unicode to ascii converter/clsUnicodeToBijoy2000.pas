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
     Mehdi Hasan Khan <mhasan@omicronlab.com>.

     Copyright (C) OmicronLab <http://www.omicronlab.com>. All Rights Reserved.


     Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}

Unit clsUnicodeToBijoy2000;

Interface

Type
     TUnicodeToBijoy2000 = Class
     Private
          fUniText: WideString;
          fConvertedText: WideString;
          Procedure ReArrangeKars;
          Procedure ReArrangeReph;
          Procedure ReplaceFullForms;
          Procedure ReplaceKarsVowels;
          Procedure ConvertRFola_ZFola_Hasanta;
          Procedure FirstHalfForms;
          Procedure SecondHalfForms;
          Procedure Consonants;
          Procedure FinalTouch;
          Procedure DeNormalize;

          //Utility Functions
          Function BaseLineRightCharacter(Const wC: WideString): Boolean;
          Function WideStuffString(Source: WideString; Start, Len: Integer; SubString: WideString): WideString;
     Public
          Function Convert(Const UniText: WideString): WideString;
     End;

Implementation

Uses
     WideStrUtils,
     Strutils,
     BanglaChars;

{Bijoy2000 Font Map Constants}
Const
     {Numbers}
     A_0                      : WideChar = #$30;
     A_1                      : WideChar = #$31;
     A_2                      : WideChar = #$32;
     A_3                      : WideChar = #$33;
     A_4                      : WideChar = #$34;
     A_5                      : WideChar = #$35;
     A_6                      : WideChar = #$36;
     A_7                      : WideChar = #$37;
     A_8                      : WideChar = #$38;
     A_9                      : WideChar = #$39;

     {Vowels and Kars}
     A_A                      : WideChar = #$41;
     A_AA                     : WideString = #$41#$76;
     A_AAKar                  : WideChar = #$76;
     A_I                      : WideChar = #$42;
     A_IKar                   : WideChar = #$77;
     A_II                     : WideChar = #$43;
     A_IIKar                  : WideChar = #$78;
     A_U                      : WideChar = #$44;
     A_UKar2                  : WideChar = #$79;
     A_UKar1                  : WideChar = #$7A;
     A_UKar3                  : WideChar = #$2013;
     A_UKar4                  : WideChar = #$201C;
     A_UU                     : WideChar = #$45;
     A_UUKar2                 : WideChar = #$7E;
     A_UUKar1                 : WideChar = #$201A;
     A_UUKar3                 : WideChar = #$192;
     A_RRI                    : WideChar = #$46;
     A_RRIKar1                : WideChar = #$201E;
     A_RRIKar2                : WideChar = #$2026;
     A_E                      : WideChar = #$47;
     A_EKar1                  : WideChar = #$2020;
     A_EKar2                  : WideChar = #$2021;
     A_OI                     : WideChar = #$48;
     A_OIKar1                 : WideChar = #$2C6;
     A_OIKar2                 : WideChar = #$2030;
     A_O                      : WideChar = #$49;
     A_OU                     : WideChar = #$4A;
     A_OUKar                  : WideChar = #$160;

     {Symbols}
     A_Taka                   : WideChar = #$24;
     A_Dari                   : WideChar = #$7C;
     A_DoubleDanda            : WideChar = #$5C;
     A_Hasanta                : WideChar = #$26;
     A_StartDoubleQuote       : WideChar = #$D2;
     A_EndDoubleQuote         : WideChar = #$D3;


     {Consonants}
     A_K                      : WideChar = #$4B;
     A_Kh                     : WideChar = #$4C;
     A_G                      : WideChar = #$4D;
     A_Gh                     : WideChar = #$4E;
     A_NGA                    : WideChar = #$4F;
     A_C                      : WideChar = #$50;
     A_Ch                     : WideChar = #$51;
     A_J                      : WideChar = #$52;
     A_Jh                     : WideChar = #$53;
     A_NYA                    : WideChar = #$54;
     A_Tt                     : WideChar = #$55;
     A_Tth                    : WideChar = #$56;
     A_Dd                     : WideChar = #$57;
     A_Ddh                    : WideChar = #$58;
     A_Nn                     : WideChar = #$59;
     A_T                      : WideChar = #$5A;
     A_Th                     : WideChar = #$5F;
     A_D                      : WideChar = #$60;
     A_Dh                     : WideChar = #$61;
     A_N                      : WideChar = #$62;
     A_P                      : WideChar = #$63;
     A_Ph                     : WideChar = #$64;
     A_B                      : WideChar = #$65;
     A_Bh                     : WideChar = #$66;
     A_M                      : WideChar = #$67;
     A_Z                      : WideChar = #$68;
     A_R                      : WideChar = #$69;
     A_L                      : WideChar = #$6A;
     A_Sh                     : WideChar = #$6B;
     A_SS                     : WideChar = #$6C;
     A_S                      : WideChar = #$6D;
     A_H                      : WideChar = #$6E;
     A_RR                     : WideChar = #$6F;
     A_RRH                    : WideChar = #$70;
     A_Y                      : WideChar = #$71;
     A_Khandata               : WideChar = #$72;
     A_Anushar                : WideChar = #$73;
     A_Bisharga               : WideChar = #$74;
     A_Chandra                : WideChar = #$75;

     {Full Forms}
     A_K_K                    : WideChar = #$B0;
     A_K_Tt                   : WideChar = #$B1;
     A_K_Ss_M                 : WideChar = #$B2;
     A_K_T                    : WideChar = #$B3;
     A_K_M                    : WideChar = #$B4;
     A_K_R                    : WideChar = #$B5;
     A_K_Ss                   : WideChar = #$B6;
     A_K_S                    : WideChar = #$B7;
     A_G_Ukar                 : WideChar = #$B8;
     A_G_G                    : WideChar = #$B9;
     A_G_D                    : WideChar = #$BA;
     A_G_Dh                   : WideChar = #$BB;
     A_NGA_K                  : WideChar = #$BC;
     A_NGA_G                  : WideChar = #$BD;
     A_J_J                    : WideChar = #$BE;
     A_J_Jh                   : WideChar = #$C0;
     A_J_NYA                  : WideChar = #$C1;
     A_NYA_C                  : WideChar = #$C2;
     A_NYA_CH                 : WideChar = #$C3;
     A_NYA_J                  : WideChar = #$C4;
     A_NYA_Jh                 : WideChar = #$C5;
     A_Tt_Tt                  : WideChar = #$C6;
     A_Dd_Dd                  : WideChar = #$C7;
     A_Nn_Tt                  : WideChar = #$C8;
     A_Nn_Tth                 : WideChar = #$C9;
     A_NN_Dd                  : WideChar = #$CA;
     A_T_T                    : WideChar = #$CB;
     A_T_Th                   : WideChar = #$CC;
     A_T_M                    : WideChar = #$CD;
     A_T_R                    : WideChar = #$CE;
     A_D_D                    : WideChar = #$CF;
     A_D_Dh                   : WideChar = #$D7;
     A_D_B                    : WideChar = #$D8;
     A_D_M                    : WideChar = #$D9;
     A_N_Tth                  : WideChar = #$DA;
     A_N_Dd                   : WideChar = #$DB;
     A_N_Dh                   : WideChar = #$DC;
     A_N_S                    : WideChar = #$DD;
     A_P_Tt                   : WideChar = #$DE;
     A_P_T                    : WideChar = #$DF;
     A_P_P                    : WideChar = #$E0;
     A_P_S                    : WideChar = #$E1;
     A_B_J                    : WideChar = #$E2;
     A_B_D                    : WideChar = #$E3;
     A_B_Dh                   : WideChar = #$E4;
     A_Bh_R                   : WideChar = #$E5;
     A_M_N                    : WideChar = #$E6;
     A_M_Ph                   : WideChar = #$E7;
     A_L_K                    : WideChar = #$E9;
     A_L_G                    : WideChar = #$EA;
     A_L_Tt                   : WideChar = #$EB;
     A_L_Dd                   : WideChar = #$EC;
     A_L_P                    : WideChar = #$ED;
     A_L_Ph                   : WideChar = #$EE;
     A_Sh_UKar                : WideChar = #$EF;
     A_Sh_C                   : WideChar = #$F0;
     A_Sh_Ch                  : WideChar = #$F1;
     A_Ss_Nn                  : WideChar = #$F2;
     A_Ss_Tt                  : WideChar = #$F3;
     A_Ss_Tth                 : WideChar = #$F4;
     A_Ss_Ph                  : WideChar = #$F5;
     A_S_Kh                   : WideChar = #$F6;
     A_S_Tt                   : WideChar = #$F7;
     A_S_N                    : WideChar = #$F8;
     A_S_Ph                   : WideChar = #$F9;
     A_H_UKar                 : WideChar = #$FB;
     A_H_RRIKar               : WideChar = #$FC;
     A_H_N                    : WideChar = #$FD;
     A_H_M                    : WideChar = #$FE;
     A_Rr_G                   : WideChar = #$FF;

     {First Half forms}
     A_Reph                   : WideChar = #$A9;
     A_M_1H                   : WideChar = #$A4;
     A_Ss_1H                  : WideChar = #$AE;
     A_S_1H_1                 : WideChar = #$AF;
     A_N_1H_1                 : WideChar = #$161;
     A_S_1H_2                 : WideChar = #$2C9; //-----------Not used
     A_D_1H_1                 : WideChar = #$2DC;
     A_C_1H                   : WideChar = #$201D;
     A_NGA_1H                 : WideChar = #$2022;
     A_N_1H_2                 : WideChar = #$203A;
     A_D_1H_2                 : WideChar = #$2122;

     {Second Half forms}
     A_B_2H_1                 : WideChar = #$5E; //
     A_B_2H_2                 : WideChar = #$A1; //
     A_BH_2H                  : WideChar = #$A2; //
     A_BH_R_2H                : WideChar = #$A3; //
     A_M_2H_1                 : WideChar = #$A5; //
     A_B_2H_3                 : WideChar = #$A6; //
     A_M_2H_2                 : WideChar = #$A7; //
     A_ZFola                  : WideChar = #$A8; //
     A_RFola_1                : WideChar = #$AA; //
     A_RFola_2                : WideChar = #$AB; //
     A_L_2H_1                 : WideChar = #$AC; //
     A_L_2H_2                 : WideChar = #$AD; //
     A_T_R_2H                 : WideChar = #$BF; //
     A_RFola_3                : WideChar = #$D6; //
     A_Nn_2H_1                : WideChar = #$E8;
     A_K_R_2H                 : WideChar = #$152; //
     A_Nn_2H_2                : WideChar = #$153;
     A_B_2H_4                 : WideChar = #$178; //
     A_T_2H                   : WideChar = #$2014; //
     A_T_UKar_2H              : WideChar = #$2018; //
     A_Th_2H                  : WideChar = #$2019; //
     A_K_2H                   : WideChar = #$2039; //
     A_L_2H_3                 : WideChar = #$2212; //------Not used

     { TUnicodeToBijoy2000 }
{===============================================================================}

Procedure TUnicodeToBijoy2000.SecondHalfForms;
Var
     I                        : Integer;
     wT                       : WideString;
Begin
     {A_BH_2H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_Bh, A_BH_2H);
     {A_T_2H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_t, A_T_2H);
     {A_Th_2H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_Th, A_Th_2H);
     {A_K_2H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_K, A_K_2H);

     {A_B_2H_1, A_B_2H_2, A_B_2H_3, A_B_2H_4}
     Repeat
          I := Pos(b_Hasanta + b_b, fConvertedText);
          If I <= 0 Then break;
          wT := MidStr(fConvertedText, i - 1, 1);

          If ((wT = b_s) Or (wT = b_ss) Or (wT = b_m) Or (wT = b_n) Or (wt = b_d)
               Or (wT = A_M_1H) Or (wT = A_Ss_1H) Or (wT = A_S_1H_1) Or (wT = A_N_1H_1) Or (wT = A_D_1H_2)) Then
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_1)
          Else If ((wt = b_dh) Or (wt = b_b) Or (wt = b_h)) Then
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_4)
          Else If ((wt = b_sh) Or (wt = b_g) Or (wt = b_p)) Then
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_3)
          Else
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_2);
     Until I <= 0;

     {A_M_2H_1  and  A_M_2H_2}
     Repeat
          I := Pos(b_Hasanta + b_m, fConvertedText);
          If I <= 0 Then break;
          wT := MidStr(fConvertedText, i - 1, 1);
          If ((wT = A_M_1H) Or (wT = A_Ss_1H) Or (wT = A_C_1H) Or (wT = A_S_1H_1)
               Or (wT = A_D_1H_2) Or (wT = A_N_1H_1) Or (wT = A_N_1H_2)) Then
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_M_2H_2)
          Else If wT = A_NGA_1H Then
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_M)
          Else
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_M_2H_1);
     Until I <= 0;

     {A_L_2H_1  and  A_L_2H_2}
     Repeat
          I := Pos(b_Hasanta + b_L, fConvertedText);
          If I <= 0 Then break;
          wT := MidStr(fConvertedText, i - 1, 1);
          If BaseLineRightCharacter(wT) Then
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_L_2H_2)
          Else
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_L_2H_1);
     Until I <= 0;

     {A_Nn_2H_1}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_Nn, A_Nn_2H_1);
     {A_Nn_2H_2}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_N, A_Nn_2H_2);
End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.FirstHalfForms;
Var
     I                        : Integer;
Begin
     {A_M_1H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_M + b_Hasanta, A_M_1H + b_Hasanta);
     {A_Ss_1H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Ss + b_Hasanta, A_Ss_1H + b_Hasanta);
     {A_C_1H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_C + b_Hasanta, A_C_1H + b_Hasanta);
     {A_NGA_1H}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_NGA + b_Hasanta, A_NGA_1H + b_Hasanta);
     {A_S_1H_1}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_S + b_Hasanta, A_S_1H_1 + b_Hasanta);

     {A_D_1H_1  and  A_D_1H_2}
     Repeat
          I := Pos(b_D + b_Hasanta, fConvertedText);
          If I <= 0 Then break;
          If MidStr(fConvertedText, i + 2, 1) = b_g Then
               fConvertedText[I] := A_D_1H_1
          Else
               fConvertedText[I] := A_D_1H_2;
     Until I <= 0;


     {A_N_1H_1 AND A_N_1H_2}
     Repeat
          I := Pos(b_N + b_Hasanta, fConvertedText);
          If I <= 0 Then break;
          If ((MidStr(fConvertedText, i + 2, 1) = b_t) Or
               (MidStr(fConvertedText, i + 2, 1) = b_th) Or
               (MidStr(fConvertedText, i + 2, 1) = b_l) Or
               (MidStr(fConvertedText, i + 2, 1) = b_b) Or
               (MidStr(fConvertedText, i + 2, 1) = A_T_R_2H) Or
               (MidStr(fConvertedText, i + 2, 1) = A_T_UKar_2H)) Then
               fConvertedText[I] := A_N_1H_1
          Else If (MidStr(fConvertedText, i + 2, 1) = b_m) Or (MidStr(fConvertedText, i + 2, 1) = b_n) Then
               fConvertedText[I] := A_N
          Else
               fConvertedText[I] := A_N_1H_2;
     Until I <= 0;


End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.Consonants;
Begin
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k, A_k);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_kh, A_kh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_g, A_g);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_gh, A_gh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nga, A_nga);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_c, A_c);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ch, A_ch);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_j, A_j);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_jh, A_jh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nya, A_nya);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_tt, A_tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_tth, A_tth);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_dd, A_dd);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ddh, A_ddh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nn, A_nn);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_t, A_t);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_th, A_th);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_d, A_d);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_dh, A_dh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_n, A_n);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_p, A_p);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ph, A_ph);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_b, A_b);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_bh, A_bh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_m, A_m);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_z, A_z);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_r, A_r);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_l, A_l);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_sh, A_sh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ss, A_ss);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_s, A_s);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_h, A_h);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_y, A_y);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_rr, A_rr);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_rrh, A_rrh);
End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.FinalTouch;
Begin
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta, '');
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, zwj, '');
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, zwnj, '');
End;



Procedure TUnicodeToBijoy2000.ReplaceFullForms;
Begin
     {Replace Numbers}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_0, A_0);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_1, A_1);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_2, A_2);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_3, A_3);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_4, A_4);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_5, A_5);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_6, A_6);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_7, A_7);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_8, A_8);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_9, A_9);

     {Replace Symbols}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Taka, A_Taka);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Dari, A_Dari);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, WideString(#$965), A_DoubleDanda);

     {Replace Other Full Forms}
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Khandatta, A_Khandata);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Anushar, A_Anushar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Bisharga, A_Bisharga);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Chandra, A_Chandra);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k + b_Hasanta + b_k, A_K_K);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k + b_Hasanta + b_tt, A_K_Tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k + b_Hasanta + b_Ss + b_Hasanta + b_M, A_K_Ss_M);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k + b_Hasanta + b_t, A_K_T);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k + b_Hasanta + b_m, A_K_M);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k + b_Hasanta + b_ss, A_K_Ss);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_k + b_Hasanta + b_s, A_K_S);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_g + b_Hasanta + b_g, A_G_G);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_g + b_Hasanta + b_d, A_G_D);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_g + b_Hasanta + b_dh, A_G_Dh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nga + b_Hasanta + b_k, A_NGA_K);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nga + b_Hasanta + b_g, A_NGA_G);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_j + b_Hasanta + b_j, A_J_J);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_j + b_Hasanta + b_jh, A_J_Jh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_j + b_Hasanta + b_nya, A_J_NYA);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nya + b_Hasanta + b_c, A_NYA_C);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nya + b_Hasanta + b_ch, A_NYA_CH);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nya + b_Hasanta + b_j, A_NYA_J);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nya + b_Hasanta + b_jh, A_NYA_Jh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_tt + b_Hasanta + b_tt, A_Tt_Tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_dd + b_Hasanta + b_dd, A_Dd_Dd);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nn + b_Hasanta + b_tt, A_Nn_Tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nn + b_Hasanta + b_tth, A_Nn_Tth);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_nn + b_Hasanta + b_dd, A_NN_Dd);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_t + b_Hasanta + b_t, A_T_T);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_t + b_Hasanta + b_th, A_T_Th);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_t + b_Hasanta + b_m, A_T_M);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_d + b_Hasanta + b_d, A_D_D);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_d + b_Hasanta + b_dh, A_D_Dh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_d + b_Hasanta + b_b, A_D_B);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_d + b_Hasanta + b_m, A_D_M);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_n + b_Hasanta + b_tth, A_N_Tth);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_n + b_Hasanta + b_dd, A_N_Dd);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_n + b_Hasanta + b_dh, A_N_Dh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_n + b_Hasanta + b_s, A_N_S);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_p + b_Hasanta + b_tt, A_P_Tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_p + b_Hasanta + b_t, A_P_T);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_p + b_Hasanta + b_p, A_P_P);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_p + b_Hasanta + b_s, A_P_S);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_b + b_Hasanta + b_j, A_B_J);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_b + b_Hasanta + b_d, A_B_D);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_b + b_Hasanta + b_dh, A_B_Dh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_m + b_Hasanta + b_n, A_M_N);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_m + b_Hasanta + b_ph, A_M_Ph);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_l + b_Hasanta + b_k, A_L_K);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_l + b_Hasanta + b_g, A_L_G);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_l + b_Hasanta + b_tt, A_L_Tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_l + b_Hasanta + b_dd, A_L_Dd);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_l + b_Hasanta + b_p, A_L_P);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_l + b_Hasanta + b_ph, A_L_Ph);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_sh + b_Hasanta + b_c, A_Sh_C);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_sh + b_Hasanta + b_ch, A_Sh_Ch);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ss + b_Hasanta + b_nn, A_Ss_Nn);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ss + b_Hasanta + b_tt, A_Ss_Tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ss + b_Hasanta + b_tth, A_Ss_Tth);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_ss + b_Hasanta + b_ph, A_Ss_Ph);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_s + b_Hasanta + b_kh, A_S_Kh);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_s + b_Hasanta + b_tt, A_S_Tt);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_s + b_Hasanta + b_n, A_S_N);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_s + b_Hasanta + b_ph, A_S_Ph);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_h + b_Hasanta + b_n, A_H_N);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_h + b_Hasanta + b_m, A_H_M);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_rr + b_Hasanta + b_g, A_Rr_G);

End;

{===============================================================================}

Function TUnicodeToBijoy2000.BaseLineRightCharacter(
     Const wC: WideString): Boolean;
Begin
     Result := False;
     If (wC = b_Kh) Or
          (wC = b_G) Or
          (wC = b_Gh) Or
          (wC = b_Nn) Or
          (wC = b_Th) Or
          (wC = b_D) Or
          (wC = b_Dh) Or
          (wC = b_N) Or
          (wC = b_P) Or
          (wC = b_B) Or
          (wC = b_M) Or
          (wC = b_Z) Or
          (wC = b_R) Or
          (wC = b_L) Or
          (wC = b_Sh) Or
          (wC = b_Ss) Or
          (wC = b_S) Or
          (wC = b_H) Or
          (wC = b_Y) Then
          Result := True;

End;

{===============================================================================}

Function TUnicodeToBijoy2000.Convert(Const UniText: WideString): WideString;
Begin
     If UniText = '' Then exit;

     fUniText := UniText;
     fConvertedText := '';
     DeNormalize;
     ReArrangeKars;
     ReArrangeReph;
     ReplaceKarsVowels;
     ConvertRFola_ZFola_Hasanta;
     ReplaceFullForms;
     FirstHalfForms;
     SecondHalfForms;
     Consonants;
     FinalTouch;
     Result := fConvertedText;
End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.ConvertRFola_ZFola_Hasanta;
Var
     I                        : Integer;
Begin
     //Convert Z-Fola
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_Z, A_ZFola);
     //Convert Hasanta
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + ZWNJ, A_Hasanta);
     //Convert R-Fola
     Repeat
          I := Pos(b_Hasanta + b_R, fConvertedText);
          If I <= 0 Then break;
          {P/G + RoFola}
          If ((MidStr(fConvertedText, I - 1, 1) = b_P) Or (MidStr(fConvertedText, I - 1, 1) = b_G)) Then
               //MidStr(fConvertedText, I, 2) := A_RFola_3
               fConvertedText := WideStuffString(fConvertedText, I, 2, A_RFola_3)
                    {V+Rofola, 2nd Half V+Rofola}
          Else If MidStr(fConvertedText, i - 1, 1) = b_Bh Then Begin
               If MidStr(fConvertedText, i - 2, 1) = b_Hasanta Then
                    //MidStr(fConvertedText, I - 1, 3) := A_BH_R_2H
                    fConvertedText := WideStuffString(fConvertedText, I - 1, 3, A_BH_R_2H)
               Else
                    //MidStr(fConvertedText, I - 1, 3) := A_BH_R;
                    fConvertedText := WideStuffString(fConvertedText, i - 1, 3, A_BH_R);
          End
               {K+Rofola, 2nd Half K+Rofola}
          Else If MidStr(fConvertedText, i - 1, 1) = b_K Then Begin
               If MidStr(fConvertedText, i - 2, 1) = b_Hasanta Then
                    //MidStr(fConvertedText, I - 1, 3) := A_K_R_2H
                    fConvertedText := WideStuffString(fConvertedText, i - 1, 3, A_K_R_2H)
               Else
                    //MidStr(fConvertedText, I - 1, 3) := A_K_R;
                    fConvertedText := WideStuffString(fConvertedText, i - 1, 3, A_K_R);
          End
               {T+Rofola, 2nd Half T+Rofola}
          Else If MidStr(fConvertedText, i - 1, 1) = b_T Then Begin
               If MidStr(fConvertedText, i - 2, 1) = b_Hasanta Then Begin
                    //MidStr(fConvertedText, I - 1, 3) := A_T_R_2H
                    If (MidStr(fConvertedText, i - 3, 1) = b_K)
                         Or (MidStr(fConvertedText, i - 3, 1) = b_T) Then
                         fConvertedText := WideStuffString(fConvertedText, i, 2, A_RFola_2)
                    Else
                         fConvertedText := WideStuffString(fConvertedText, i - 1, 3, A_T_R_2H);
               End
               Else
                    //MidStr(fConvertedText, I - 1, 3) := A_T_R;
                    fConvertedText := WideStuffString(fConvertedText, i - 1, 3, A_T_R);
          End
          Else Begin
               If MidStr(fConvertedText, i - 1, 1) = b_Ph Then
                    //MidStr(fConvertedText, I, 2) := A_RFola_2
                    fConvertedText := WideStuffString(fConvertedText, i, 2, A_RFola_2)
               Else
                    //MidStr(fConvertedText, I, 2) := A_RFola_1;
                    fConvertedText := WideStuffString(fConvertedText, i, 2, A_RFola_1);
          End;

     Until I <= 0;
End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.DeNormalize;
Begin
     fConvertedText := WideStrUtils.WideReplaceStr(fUniText, b_Z + b_Nukta, b_Y);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Dd + b_Nukta, b_Rr);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Ddh + b_Nukta, b_Rrh);
End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.ReArrangeKars;
Var
     I                        : Integer;
     fKar, wCTmp              : WideChar;
     wSTmp                    : WideString;

     Function MoveAbleKar(Const wKar: WideChar): Boolean;
     Begin
          Result := False;
          If ((wKar = b_Ekar) Or (wKar = b_IKar) Or (wKar = b_OIKar)) Then
               Result := True;
     End;


Begin
     //Break O-kar and OU-Kar
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_OKar, b_EKar + b_AAKar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_OUKar, b_EKar + b_LengthMark);

     //Bring IKar,EKar and OIkar to beginning of consonant/conjuncts
     I := Length(fConvertedText);
     wSTmp := '';
     fKar := #0;
     Repeat
          wCTmp := fConvertedText[I];
          If MoveAbleKar(wCTmp) Then Begin //Make this kar pending
               fKar := wCTmp;
          End
          Else Begin
               If fKar = #0 Then Begin  //No Kar is pending
                    wSTmp := wCTmp + wSTmp;
               End
               Else Begin               //Kar is pending
                    If (I - 1 < 1) Then Begin //This is begining of text, no need to search back
                         wSTmp := fKar + wCTmp + wSTmp; //Place pending kar at begining
                         fKar := #0;
                    End
                    Else Begin          //Not begining of text, search backward more deeply
                         If ((IsPureConsonent(wCTmp) = False) And (wCTmp <> b_Hasanta) And (wCTmp <> ZWJ) And (wCTmp <> ZWNJ)) Then Begin
                              //We are at the beginning of a Consonant, place pending kar here
                              wSTmp := wCTmp + fKar + wSTmp;
                              fKar := #0;
                         End
                         Else Begin
                              If ((wCTmp = b_Hasanta) Or (wCTmp = ZWJ) Or (wCTmp = ZWNJ)) Then
                                   wSTmp := wCTmp + wSTmp;

                              If (IsPureConsonent(wCTmp) = True) Then Begin
                                   If ((fConvertedText[I - 1] = b_Hasanta) Or (fConvertedText[I - 1] = ZWJ) Or (fConvertedText[I - 1] = zwnj)) Then
                                        wSTmp := wCTmp + wSTmp
                                   Else Begin
                                        wSTmp := fKar + wCTmp + wSTmp; //Place pending kar at begining
                                        fKar := #0;
                                   End;
                              End;
                         End;
                    End;
               End;

          End;

          I := I - 1;
     Until I < 1;

     fConvertedText := wSTmp;

     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, WideString('“'), A_StartDoubleQuote);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, WideString('”'), A_EndDoubleQuote);

End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.ReArrangeReph;
Var
     I                        : Integer;
     wCTmp                    : WideChar;
     wSTmp                    : WideString;
     RephPending              : Boolean;

     Function MoveAbleReph: Boolean;
     Begin
          Result := False;
          If I + 2 > Length(fConvertedText) Then exit;
          If ((fConvertedText[I] = b_R) And (fConvertedText[I + 1] = b_Hasanta) And (fConvertedText[I + 2] <> ZWJ) And (fConvertedText[I + 2] <> ZWNJ)) Then
               Result := True;
     End;

Begin
     If Length(fConvertedText) < 3 Then exit;
     I := 1;
     wSTmp := '';
     RephPending := False;
     Repeat
          wCTmp := fConvertedText[I];
          If MoveAbleReph = False Then Begin
               If RephPending = False Then Begin
                    wSTmp := wSTmp + wCTmp;
               End
               Else Begin
                    If ((IsPureConsonent(wCTmp) = False) And (wCTmp <> b_Hasanta) And (wCTmp <> ZWJ) And (wCTmp <> ZWNJ)) Then Begin
                         wSTmp := wSTmp + A_Reph + wCTmp;
                         RephPending := False;
                    End
                    Else Begin
                         If I + 1 > Length(fConvertedText) Then Begin
                              wSTmp := wSTmp + wCTmp + A_Reph;
                              RephPending := False;
                         End
                         Else Begin
                              If ((wCTmp = b_Hasanta) Or (wCTmp = ZWJ) Or (wCTmp = ZWNJ)) Then
                                   wSTmp := wSTmp + wCTmp;

                              If (IsPureConsonent(wCTmp) = True) Then Begin
                                   If ((fConvertedText[I + 1] = b_Hasanta) Or (fConvertedText[I + 1] = ZWJ) Or (fConvertedText[I + 1] = zwnj)) Then
                                        wSTmp := wSTmp + wCTmp
                                   Else Begin
                                        wSTmp := wSTmp + wCTmp + A_Reph;
                                        RephPending := False;
                                   End;
                              End;
                         End;
                    End;
               End;
          End
          Else Begin
               RephPending := True;
               I := I + 1;
          End;

          I := I + 1;
     Until I > Length(fConvertedText);
     fConvertedText := wSTmp;
End;

{===============================================================================}

Procedure TUnicodeToBijoy2000.ReplaceKarsVowels;
Var
     I                        : Integer;
Begin
     //Convert Ekar
     Repeat
          I := Pos(b_EKar, fConvertedText);
          If I <= 0 Then break;
          If ((I = 1) Or (MidStr(fConvertedText, i - 1, 1) = ' ')
               Or (MidStr(fConvertedText, i - 1, 1) = #13)
               Or (MidStr(fConvertedText, i - 1, 1) = #10)
               Or (MidStr(fConvertedText, i - 1, 1) = #9)) Then
               fConvertedText[I] := A_EKar1
          Else
               fConvertedText[I] := A_EKar2;
     Until I <= 0;

     //Convert OIKar
     Repeat
          I := Pos(b_OIKar, fConvertedText);
          If I <= 0 Then break;
          If ((I = 1) Or (MidStr(fConvertedText, i - 1, 1) = ' ')
               Or (MidStr(fConvertedText, i - 1, 1) = #13)
               Or (MidStr(fConvertedText, i - 1, 1) = #10)
               Or (MidStr(fConvertedText, i - 1, 1) = #9)) Then
               fConvertedText[I] := A_OIKar1
          Else
               fConvertedText[I] := A_OIKar2;
     Until I <= 0;

     //Convert UKar
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_G + b_Ukar, A_G_Ukar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Sh + b_Ukar, A_Sh_Ukar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_H + b_Ukar, A_H_Ukar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_Hasanta + b_T + b_Ukar, b_Hasanta + A_T_UKar_2H);
     Repeat
          I := Pos(b_UKar, fConvertedText);
          If I <= 0 Then break;
          If I - 1 >= 1 Then Begin
               If BaseLineRightCharacter(fConvertedText[i - 1]) = true Then Begin

                    If fConvertedText[i - 1] = b_R Then Begin
                         If ((MidStr(fConvertedText, i - 3, 3) = b_Sh + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_D + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_G + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_T + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_J + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Th + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Dh + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_N + b_Hasanta + b_D + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_P + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_B + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Bh + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_M + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_S + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_m + b_Hasanta + b_p + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_Ss + b_Hasanta + b_P + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_S + b_Hasanta + b_P + b_Hasanta + b_R)) Then
                              fConvertedText[I] := A_UKar4
                         Else If MidStr(fConvertedText, i - 2, 1) <> b_Hasanta Then
                              fConvertedText[I] := A_UKar4
                         Else
                              fConvertedText[I] := A_UKar2;
                    End
                    Else If fConvertedText[i - 1] = b_L Then Begin
                         If ((MidStr(fConvertedText, i - 3, 3) = b_G + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_P + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_B + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Sh + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_S + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_S + b_Hasanta + b_P + b_Hasanta + b_L)) Then
                              fConvertedText[I] := A_UKar4
                         Else
                              fConvertedText[I] := A_UKar2;
                    End
                    Else
                         fConvertedText[I] := A_UKar2;

                    If MidStr(fConvertedText, i - 3, 3) = b_Ss + B_Hasanta + b_Nn Then
                         fConvertedText[I] := A_UKar1;
                    { Else
                          fConvertedText[I] := A_UKar2; }

               End
               Else Begin
                    If ((fConvertedText[i - 1] = b_Rr)
                         Or (fConvertedText[i - 1] = b_Rrh)) Then Begin
                         fConvertedText[I] := A_UKar3;
                    End
                    Else
                         fConvertedText[I] := A_UKar1;
               End;
          End
          Else
               fConvertedText[I] := A_UKar1;
     Until I <= 0;


     //Convert UUKar
     Repeat
          I := Pos(b_UUKar, fConvertedText);
          If I <= 0 Then break;
          If I - 1 >= 1 Then Begin
               If BaseLineRightCharacter(fConvertedText[i - 1]) = true Then Begin
                    If fConvertedText[i - 1] = b_R Then Begin
                         If ((MidStr(fConvertedText, i - 3, 3) = b_Sh + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_D + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_G + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_T + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_J + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Th + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Dh + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_N + b_Hasanta + b_D + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_P + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_B + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Bh + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_M + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_S + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_m + b_Hasanta + b_p + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_Ss + b_Hasanta + b_P + b_Hasanta + b_R) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_S + b_Hasanta + b_P + b_Hasanta + b_R)) Then
                              fConvertedText[I] := A_UUKar3
                         Else If MidStr(fConvertedText, i - 2, 1) <> b_Hasanta Then
                              fConvertedText[I] := A_UUKar3
                         Else
                              fConvertedText[I] := A_UUKar2;
                    End
                    Else If fConvertedText[i - 1] = b_L Then Begin
                         If ((MidStr(fConvertedText, i - 3, 3) = b_G + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_P + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_B + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_Sh + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 3, 3) = b_S + b_Hasanta + b_L) Or
                              (MidStr(fConvertedText, i - 5, 5) = b_S + b_Hasanta + b_P + b_Hasanta + b_L)) Then
                              fConvertedText[I] := A_UUKar3
                         Else
                              fConvertedText[I] := A_UUKar2;
                    End
                    Else
                         fConvertedText[I] := A_UUKar2;
               End
               Else
                    fConvertedText[I] := A_UUKar1;
          End
          Else
               fConvertedText[I] := A_UUKar1;
     Until I <= 0;


     //Convert RRIKar
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_H + b_Rrikar, A_H_Rrikar);
     Repeat
          I := Pos(b_RRiKar, fConvertedText);
          If I <= 0 Then break;
          If I - 1 >= 1 Then Begin
               If BaseLineRightCharacter(fConvertedText[i - 1]) = true Then Begin
                    fConvertedText[I] := A_RRIKar1;
               End
               Else
                    fConvertedText[I] := A_RRIKar2;
          End
          Else
               fConvertedText[I] := A_RRIKar2;
     Until I <= 0;


     //Convert rest of the Kars
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_AAKar, A_AAKar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_IKar, A_IKar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_IIKar, A_IIkar);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_LengthMark, A_OUKar);


     //Convert Vowels
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_A, A_A);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_AA, A_AA);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_I, A_I);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_II, A_II);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_U, A_U);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_UU, A_UU);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_RRI, A_RRI);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_E, A_E);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_OI, A_OI);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_O, A_O);
     fConvertedText := WideStrUtils.WideReplaceStr(fConvertedText, b_OU, A_OU);
End;

{===============================================================================}

Function TUnicodeToBijoy2000.WideStuffString(Source: WideString; Start,
     Len: Integer; SubString: WideString): WideString;
Var
     FirstPart, LastPart      : WideString;
Begin
     FirstPart := LeftStr(WideString(Source), Start - 1);
     LastPart := MidStr(WideString(Source), Start + Len, Length(Source));
     Result := FirstPart + SubString + LastPart;
End;

{===============================================================================}

End.

