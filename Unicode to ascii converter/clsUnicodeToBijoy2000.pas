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
  Mehdi Hasan Khan <mhasan@omicronlab.com>.

  Copyright (C) OmicronLab <https://www.omicronlab.com>. All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit clsUnicodeToBijoy2000;

interface

type
  TUnicodeToBijoy2000 = class
    private
      fUniText:       string;
      fConvertedText: string;
      procedure ReArrangeKars;
      procedure ReArrangeReph;
      procedure ReplaceFullForms;
      procedure ReplaceKarsVowels;
      procedure ConvertRFola_ZFola_Hasanta;
      procedure FirstHalfForms;
      procedure SecondHalfForms;
      procedure Consonants;
      procedure FinalTouch;
      procedure DeNormalize;

      // Utility Functions
      function BaseLineRightCharacter(const wC: string): Boolean;
      function WideStuffString(Source: string; Start, Len: Integer; SubString: string): string;
    public
      function Convert(const UniText: string): string;
  end;

implementation

uses
  Strutils,
  BanglaChars;

{ Bijoy2000 Font Map Constants }
const
  { Numbers }
  A_0: Char = #$30;
  A_1: Char = #$31;
  A_2: Char = #$32;
  A_3: Char = #$33;
  A_4: Char = #$34;
  A_5: Char = #$35;
  A_6: Char = #$36;
  A_7: Char = #$37;
  A_8: Char = #$38;
  A_9: Char = #$39;

  { Vowels and Kars }
  A_A: Char       = #$41;
  A_AA: string    = #$41#$76;
  A_AAKar: Char   = #$76;
  A_I: Char       = #$42;
  A_IKar: Char    = #$77;
  A_II: Char      = #$43;
  A_IIKar: Char   = #$78;
  A_U: Char       = #$44;
  A_UKar2: Char   = #$79;
  A_UKar1: Char   = #$7A;
  A_UKar3: Char   = #$2013;
  A_UKar4: Char   = #$201C;
  A_UU: Char      = #$45;
  A_UUKar2: Char  = #$7E;
  A_UUKar1: Char  = #$201A;
  A_UUKar3: Char  = #$192;
  A_RRI: Char     = #$46;
  A_RRIKar1: Char = #$201E;
  A_RRIKar2: Char = #$2026;
  A_E: Char       = #$47;
  A_EKar1: Char   = #$2020;
  A_EKar2: Char   = #$2021;
  A_OI: Char      = #$48;
  A_OIKar1: Char  = #$2C6;
  A_OIKar2: Char  = #$2030;
  A_O: Char       = #$49;
  A_OU: Char      = #$4A;
  A_OUKar: Char   = #$160;

  { Symbols }
  A_Taka: Char             = #$24;
  A_Dari: Char             = #$7C;
  A_DoubleDanda: Char      = #$5C;
  A_Hasanta: Char          = #$26;
  A_StartDoubleQuote: Char = #$D2;
  A_EndDoubleQuote: Char   = #$D3;

  { Consonants }
  A_K: Char        = #$4B;
  A_Kh: Char       = #$4C;
  A_G: Char        = #$4D;
  A_Gh: Char       = #$4E;
  A_NGA: Char      = #$4F;
  A_C: Char        = #$50;
  A_Ch: Char       = #$51;
  A_J: Char        = #$52;
  A_Jh: Char       = #$53;
  A_NYA: Char      = #$54;
  A_Tt: Char       = #$55;
  A_Tth: Char      = #$56;
  A_Dd: Char       = #$57;
  A_Ddh: Char      = #$58;
  A_Nn: Char       = #$59;
  A_T: Char        = #$5A;
  A_Th: Char       = #$5F;
  A_D: Char        = #$60;
  A_Dh: Char       = #$61;
  A_N: Char        = #$62;
  A_P: Char        = #$63;
  A_Ph: Char       = #$64;
  A_B: Char        = #$65;
  A_Bh: Char       = #$66;
  A_M: Char        = #$67;
  A_Z: Char        = #$68;
  A_R: Char        = #$69;
  A_L: Char        = #$6A;
  A_Sh: Char       = #$6B;
  A_SS: Char       = #$6C;
  A_S: Char        = #$6D;
  A_H: Char        = #$6E;
  A_RR: Char       = #$6F;
  A_RRH: Char      = #$70;
  A_Y: Char        = #$71;
  A_Khandata: Char = #$72;
  A_Anushar: Char  = #$73;
  A_Bisharga: Char = #$74;
  A_Chandra: Char  = #$75;

  { Full Forms }
  A_K_K: Char      = #$B0;
  A_K_Tt: Char     = #$B1;
  A_K_Ss_M: Char   = #$B2;
  A_K_T: Char      = #$B3;
  A_K_M: Char      = #$B4;
  A_K_R: Char      = #$B5;
  A_K_Ss: Char     = #$B6;
  A_K_S: Char      = #$B7;
  A_G_Ukar: Char   = #$B8;
  A_G_G: Char      = #$B9;
  A_G_D: Char      = #$BA;
  A_G_Dh: Char     = #$BB;
  A_NGA_K: Char    = #$BC;
  A_NGA_G: Char    = #$BD;
  A_J_J: Char      = #$BE;
  A_J_Jh: Char     = #$C0;
  A_J_NYA: Char    = #$C1;
  A_NYA_C: Char    = #$C2;
  A_NYA_CH: Char   = #$C3;
  A_NYA_J: Char    = #$C4;
  A_NYA_Jh: Char   = #$C5;
  A_Tt_Tt: Char    = #$C6;
  A_Dd_Dd: Char    = #$C7;
  A_Nn_Tt: Char    = #$C8;
  A_Nn_Tth: Char   = #$C9;
  A_NN_Dd: Char    = #$CA;
  A_T_T: Char      = #$CB;
  A_T_Th: Char     = #$CC;
  A_T_M: Char      = #$CD;
  A_T_R: Char      = #$CE;
  A_D_D: Char      = #$CF;
  A_D_Dh: Char     = #$D7;
  A_D_B: Char      = #$D8;
  A_D_M: Char      = #$D9;
  A_N_Tth: Char    = #$DA;
  A_N_Dd: Char     = #$DB;
  A_N_Dh: Char     = #$DC;
  A_N_S: Char      = #$DD;
  A_P_Tt: Char     = #$DE;
  A_P_T: Char      = #$DF;
  A_P_P: Char      = #$E0;
  A_P_S: Char      = #$E1;
  A_B_J: Char      = #$E2;
  A_B_D: Char      = #$E3;
  A_B_Dh: Char     = #$E4;
  A_Bh_R: Char     = #$E5;
  A_M_N: Char      = #$E6;
  A_M_Ph: Char     = #$E7;
  A_L_K: Char      = #$E9;
  A_L_G: Char      = #$EA;
  A_L_Tt: Char     = #$EB;
  A_L_Dd: Char     = #$EC;
  A_L_P: Char      = #$ED;
  A_L_Ph: Char     = #$EE;
  A_Sh_UKar: Char  = #$EF;
  A_Sh_C: Char     = #$F0;
  A_Sh_Ch: Char    = #$F1;
  A_Ss_Nn: Char    = #$F2;
  A_Ss_Tt: Char    = #$F3;
  A_Ss_Tth: Char   = #$F4;
  A_Ss_Ph: Char    = #$F5;
  A_S_Kh: Char     = #$F6;
  A_S_Tt: Char     = #$F7;
  A_S_N: Char      = #$F8;
  A_S_Ph: Char     = #$F9;
  A_H_UKar: Char   = #$FB;
  A_H_RRIKar: Char = #$FC;
  A_H_N: Char      = #$FD;
  A_H_M: Char      = #$FE;
  A_Rr_G: Char     = #$FF;

  { First Half forms }
  A_Reph: Char   = #$A9;
  A_M_1H: Char   = #$A4;
  A_Ss_1H: Char  = #$AE;
  A_S_1H_1: Char = #$AF;
  A_N_1H_1: Char = #$161;
  A_S_1H_2: Char = #$2C9; // -----------Not used
  A_D_1H_1: Char = #$2DC;
  A_C_1H: Char   = #$201D;
  A_NGA_1H: Char = #$2022;
  A_N_1H_2: Char = #$203A;
  A_D_1H_2: Char = #$2122;

  { Second Half forms }
  A_B_2H_1: Char    = #$5E; //
  A_B_2H_2: Char    = #$A1; //
  A_BH_2H: Char     = #$A2; //
  A_BH_R_2H: Char   = #$A3; //
  A_M_2H_1: Char    = #$A5; //
  A_B_2H_3: Char    = #$A6; //
  A_M_2H_2: Char    = #$A7; //
  A_ZFola: Char     = #$A8; //
  A_RFola_1: Char   = #$AA; //
  A_RFola_2: Char   = #$AB; //
  A_L_2H_1: Char    = #$AC; //
  A_L_2H_2: Char    = #$AD; // <--- Not used
  A_T_R_2H: Char    = #$BF; //
  A_RFola_3: Char   = #$D6; //
  A_Nn_2H_1: Char   = #$E8;
  A_K_R_2H: Char    = #$152; //
  A_Nn_2H_2: Char   = #$153;
  A_B_2H_4: Char    = #$178;  //
  A_T_2H: Char      = #$2014; //
  A_T_UKar_2H: Char = #$2018; //
  A_Th_2H: Char     = #$2019; //
  A_K_2H: Char      = #$2039; //
  A_L_2H_3: Char    = #$2212; //

  { TUnicodeToBijoy2000 }
  { =============================================================================== }

procedure TUnicodeToBijoy2000.SecondHalfForms;
var
  I:  Integer;
  wT: string;
begin
  { A_BH_2H }
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_Bh, A_BH_2H);
  { A_T_2H }
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_t, A_T_2H);
  { A_Th_2H }
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_Th, A_Th_2H);
  { A_K_2H }
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_K, A_K_2H);

  { A_B_2H_1, A_B_2H_2, A_B_2H_3, A_B_2H_4 }
  repeat
    I := Pos(b_Hasanta + b_b, fConvertedText);
    if I <= 0 then
      break;
    wT := MidStr(fConvertedText, I - 1, 1);

    if ((wT = b_s) or (wT = b_ss) or (wT = b_m) or (wT = b_n) or (wT = b_d) or (wT = A_M_1H) or (wT = A_Ss_1H) or (wT = A_S_1H_1) or (wT = A_N_1H_1) or
        (wT = A_D_1H_2)) then
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_1)
    else if ((wT = b_dh) or (wT = b_b) or (wT = b_h)) then
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_4)
    else if ((wT = b_sh) or (wT = b_g) or (wT = b_p)) then
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_3)
    else
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_B_2H_2);
  until I <= 0;

  { A_M_2H_1  and  A_M_2H_2 }
  repeat
    I := Pos(b_Hasanta + b_m, fConvertedText);
    if I <= 0 then
      break;
    wT := MidStr(fConvertedText, I - 1, 1);
    if ((wT = A_M_1H) or (wT = A_Ss_1H) or (wT = A_C_1H) or (wT = A_S_1H_1) or (wT = A_D_1H_2) or (wT = A_N_1H_1) or (wT = A_N_1H_2)) then
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_M_2H_2)
    else if wT = A_NGA_1H then
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_M)
    else
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_M_2H_1);
  until I <= 0;

  { A_L_2H_1  and  A_L_2H_3 }
  repeat
    I := Pos(b_Hasanta + b_L, fConvertedText);
    if I <= 0 then
      break;
    wT := MidStr(fConvertedText, I - 1, 1);
    if BaseLineRightCharacter(wT) then
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_L_2H_3)
    else
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_L_2H_1);
  until I <= 0;

  { A_Nn_2H_1 }
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_Nn, A_Nn_2H_1);
  { A_Nn_2H_2 }
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_n, A_Nn_2H_2);
end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.FirstHalfForms;
var
  I: Integer;
begin
  { A_M_1H }
  fConvertedText := ReplaceStr(fConvertedText, b_m + b_Hasanta, A_M_1H + b_Hasanta);
  { A_Ss_1H }
  fConvertedText := ReplaceStr(fConvertedText, b_ss + b_Hasanta, A_Ss_1H + b_Hasanta);
  { A_C_1H }
  fConvertedText := ReplaceStr(fConvertedText, b_C + b_Hasanta, A_C_1H + b_Hasanta);
  { A_NGA_1H }
  fConvertedText := ReplaceStr(fConvertedText, b_NGA + b_Hasanta, A_NGA_1H + b_Hasanta);
  { A_S_1H_1 }
  fConvertedText := ReplaceStr(fConvertedText, b_s + b_Hasanta, A_S_1H_1 + b_Hasanta);

  { A_D_1H_1  and  A_D_1H_2 }
  repeat
    I := Pos(b_d + b_Hasanta, fConvertedText);
    if I <= 0 then
      break;
    if MidStr(fConvertedText, I + 2, 1) = b_g then
      fConvertedText[I] := A_D_1H_1
    else
      fConvertedText[I] := A_D_1H_2;
  until I <= 0;

  { A_N_1H_1 AND A_N_1H_2 }
  repeat
    I := Pos(b_n + b_Hasanta, fConvertedText);
    if I <= 0 then
      break;
    if ((MidStr(fConvertedText, I + 2, 1) = b_t) or (MidStr(fConvertedText, I + 2, 1) = b_Th) or (MidStr(fConvertedText, I + 2, 1) = b_L) or
        (MidStr(fConvertedText, I + 2, 1) = b_b) or (MidStr(fConvertedText, I + 2, 1) = A_T_R_2H) or (MidStr(fConvertedText, I + 2, 1) = A_T_UKar_2H)) then
      fConvertedText[I] := A_N_1H_1
    else if (MidStr(fConvertedText, I + 2, 1) = b_m) or (MidStr(fConvertedText, I + 2, 1) = b_n) then
      fConvertedText[I] := A_N
    else
      fConvertedText[I] := A_N_1H_2;
  until I <= 0;

end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.Consonants;
begin
  fConvertedText := ReplaceStr(fConvertedText, b_K, A_K);
  fConvertedText := ReplaceStr(fConvertedText, b_kh, A_Kh);
  fConvertedText := ReplaceStr(fConvertedText, b_g, A_G);
  fConvertedText := ReplaceStr(fConvertedText, b_gh, A_Gh);
  fConvertedText := ReplaceStr(fConvertedText, b_NGA, A_NGA);
  fConvertedText := ReplaceStr(fConvertedText, b_C, A_C);
  fConvertedText := ReplaceStr(fConvertedText, b_ch, A_Ch);
  fConvertedText := ReplaceStr(fConvertedText, b_j, A_J);
  fConvertedText := ReplaceStr(fConvertedText, b_jh, A_Jh);
  fConvertedText := ReplaceStr(fConvertedText, b_nya, A_NYA);
  fConvertedText := ReplaceStr(fConvertedText, b_tt, A_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_tth, A_Tth);
  fConvertedText := ReplaceStr(fConvertedText, b_dd, A_Dd);
  fConvertedText := ReplaceStr(fConvertedText, b_ddh, A_Ddh);
  fConvertedText := ReplaceStr(fConvertedText, b_Nn, A_Nn);
  fConvertedText := ReplaceStr(fConvertedText, b_t, A_T);
  fConvertedText := ReplaceStr(fConvertedText, b_Th, A_Th);
  fConvertedText := ReplaceStr(fConvertedText, b_d, A_D);
  fConvertedText := ReplaceStr(fConvertedText, b_dh, A_Dh);
  fConvertedText := ReplaceStr(fConvertedText, b_n, A_N);
  fConvertedText := ReplaceStr(fConvertedText, b_p, A_P);
  fConvertedText := ReplaceStr(fConvertedText, b_ph, A_Ph);
  fConvertedText := ReplaceStr(fConvertedText, b_b, A_B);
  fConvertedText := ReplaceStr(fConvertedText, b_Bh, A_Bh);
  fConvertedText := ReplaceStr(fConvertedText, b_m, A_M);
  fConvertedText := ReplaceStr(fConvertedText, b_z, A_Z);
  fConvertedText := ReplaceStr(fConvertedText, b_r, A_R);
  fConvertedText := ReplaceStr(fConvertedText, b_L, A_L);
  fConvertedText := ReplaceStr(fConvertedText, b_sh, A_Sh);
  fConvertedText := ReplaceStr(fConvertedText, b_ss, A_SS);
  fConvertedText := ReplaceStr(fConvertedText, b_s, A_S);
  fConvertedText := ReplaceStr(fConvertedText, b_h, A_H);
  fConvertedText := ReplaceStr(fConvertedText, b_y, A_Y);
  fConvertedText := ReplaceStr(fConvertedText, b_rr, A_RR);
  fConvertedText := ReplaceStr(fConvertedText, b_rrh, A_RRH);
end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.FinalTouch;
begin
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta, '');
  fConvertedText := ReplaceStr(fConvertedText, zwj, '');
  fConvertedText := ReplaceStr(fConvertedText, zwnj, '');
  // Warning: Hardcoded conversion
  fConvertedText := ReplaceStr(fConvertedText, 'n�', 'n�');
  fConvertedText := ReplaceStr(fConvertedText, 'K�', 'K�');
  fConvertedText := ReplaceStr(fConvertedText, '�y', '�z');
  fConvertedText := ReplaceStr(fConvertedText, 'Rz', 'Ry');
  fConvertedText := ReplaceStr(fConvertedText, 'R�', 'R~');
  fConvertedText := ReplaceStr(fConvertedText, 'R�', 'R�');
end;

procedure TUnicodeToBijoy2000.ReplaceFullForms;
begin
  { Replace Numbers }
  fConvertedText := ReplaceStr(fConvertedText, b_0, A_0);
  fConvertedText := ReplaceStr(fConvertedText, b_1, A_1);
  fConvertedText := ReplaceStr(fConvertedText, b_2, A_2);
  fConvertedText := ReplaceStr(fConvertedText, b_3, A_3);
  fConvertedText := ReplaceStr(fConvertedText, b_4, A_4);
  fConvertedText := ReplaceStr(fConvertedText, b_5, A_5);
  fConvertedText := ReplaceStr(fConvertedText, b_6, A_6);
  fConvertedText := ReplaceStr(fConvertedText, b_7, A_7);
  fConvertedText := ReplaceStr(fConvertedText, b_8, A_8);
  fConvertedText := ReplaceStr(fConvertedText, b_9, A_9);

  { Replace Symbols }
  fConvertedText := ReplaceStr(fConvertedText, b_Taka, A_Taka);
  fConvertedText := ReplaceStr(fConvertedText, b_Dari, A_Dari);
  fConvertedText := ReplaceStr(fConvertedText, string(#$965), A_DoubleDanda);

  { Replace Other Full Forms }
  fConvertedText := ReplaceStr(fConvertedText, b_Khandatta, A_Khandata);
  fConvertedText := ReplaceStr(fConvertedText, b_Anushar, A_Anushar);
  fConvertedText := ReplaceStr(fConvertedText, b_Bisharga, A_Bisharga);
  fConvertedText := ReplaceStr(fConvertedText, b_Chandra, A_Chandra);
  fConvertedText := ReplaceStr(fConvertedText, b_K + b_Hasanta + b_K, A_K_K);
  fConvertedText := ReplaceStr(fConvertedText, b_K + b_Hasanta + b_tt, A_K_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_K + b_Hasanta + b_ss + b_Hasanta + b_m, A_K_Ss_M);
  fConvertedText := ReplaceStr(fConvertedText, b_K + b_Hasanta + b_t, A_K_T);
  fConvertedText := ReplaceStr(fConvertedText, b_K + b_Hasanta + b_m, A_K_M);
  fConvertedText := ReplaceStr(fConvertedText, b_K + b_Hasanta + b_ss, A_K_Ss);
  fConvertedText := ReplaceStr(fConvertedText, b_K + b_Hasanta + b_s, A_K_S);
  fConvertedText := ReplaceStr(fConvertedText, b_g + b_Hasanta + b_g, A_G_G);
  fConvertedText := ReplaceStr(fConvertedText, b_g + b_Hasanta + b_d, A_G_D);
  fConvertedText := ReplaceStr(fConvertedText, b_g + b_Hasanta + b_dh, A_G_Dh);
  fConvertedText := ReplaceStr(fConvertedText, b_NGA + b_Hasanta + b_K, A_NGA_K);
  fConvertedText := ReplaceStr(fConvertedText, b_NGA + b_Hasanta + b_g, A_NGA_G);
  fConvertedText := ReplaceStr(fConvertedText, b_j + b_Hasanta + b_j, A_J_J);
  fConvertedText := ReplaceStr(fConvertedText, b_j + b_Hasanta + b_jh, A_J_Jh);
  fConvertedText := ReplaceStr(fConvertedText, b_j + b_Hasanta + b_nya, A_J_NYA);
  fConvertedText := ReplaceStr(fConvertedText, b_nya + b_Hasanta + b_C, A_NYA_C);
  fConvertedText := ReplaceStr(fConvertedText, b_nya + b_Hasanta + b_ch, A_NYA_CH);
  fConvertedText := ReplaceStr(fConvertedText, b_nya + b_Hasanta + b_j, A_NYA_J);
  fConvertedText := ReplaceStr(fConvertedText, b_nya + b_Hasanta + b_jh, A_NYA_Jh);
  fConvertedText := ReplaceStr(fConvertedText, b_tt + b_Hasanta + b_tt, A_Tt_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_dd + b_Hasanta + b_dd, A_Dd_Dd);
  fConvertedText := ReplaceStr(fConvertedText, b_Nn + b_Hasanta + b_tt, A_Nn_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_Nn + b_Hasanta + b_tth, A_Nn_Tth);
  fConvertedText := ReplaceStr(fConvertedText, b_Nn + b_Hasanta + b_dd, A_NN_Dd);
  fConvertedText := ReplaceStr(fConvertedText, b_t + b_Hasanta + b_t, A_T_T);
  fConvertedText := ReplaceStr(fConvertedText, b_t + b_Hasanta + b_Th, A_T_Th);
  fConvertedText := ReplaceStr(fConvertedText, b_t + b_Hasanta + b_m, A_T_M);
  fConvertedText := ReplaceStr(fConvertedText, b_d + b_Hasanta + b_d, A_D_D);
  fConvertedText := ReplaceStr(fConvertedText, b_d + b_Hasanta + b_dh, A_D_Dh);
  fConvertedText := ReplaceStr(fConvertedText, b_d + b_Hasanta + b_b, A_D_B);
  fConvertedText := ReplaceStr(fConvertedText, b_d + b_Hasanta + b_m, A_D_M);
  fConvertedText := ReplaceStr(fConvertedText, b_n + b_Hasanta + b_tth, A_N_Tth);
  fConvertedText := ReplaceStr(fConvertedText, b_n + b_Hasanta + b_dd, A_N_Dd);
  fConvertedText := ReplaceStr(fConvertedText, b_n + b_Hasanta + b_dh, A_N_Dh);
  fConvertedText := ReplaceStr(fConvertedText, b_n + b_Hasanta + b_s, A_N_S);
  fConvertedText := ReplaceStr(fConvertedText, b_p + b_Hasanta + b_tt, A_P_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_p + b_Hasanta + b_t, A_P_T);
  fConvertedText := ReplaceStr(fConvertedText, b_p + b_Hasanta + b_p, A_P_P);
  fConvertedText := ReplaceStr(fConvertedText, b_p + b_Hasanta + b_s, A_P_S);
  fConvertedText := ReplaceStr(fConvertedText, b_b + b_Hasanta + b_j, A_B_J);
  fConvertedText := ReplaceStr(fConvertedText, b_b + b_Hasanta + b_d, A_B_D);
  fConvertedText := ReplaceStr(fConvertedText, b_b + b_Hasanta + b_dh, A_B_Dh);
  fConvertedText := ReplaceStr(fConvertedText, b_m + b_Hasanta + b_n, A_M_N);
  fConvertedText := ReplaceStr(fConvertedText, b_m + b_Hasanta + b_ph, A_M_Ph);
  fConvertedText := ReplaceStr(fConvertedText, b_L + b_Hasanta + b_K, A_L_K);
  fConvertedText := ReplaceStr(fConvertedText, b_L + b_Hasanta + b_g, A_L_G);
  fConvertedText := ReplaceStr(fConvertedText, b_L + b_Hasanta + b_tt, A_L_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_L + b_Hasanta + b_dd, A_L_Dd);
  fConvertedText := ReplaceStr(fConvertedText, b_L + b_Hasanta + b_p, A_L_P);
  fConvertedText := ReplaceStr(fConvertedText, b_L + b_Hasanta + b_ph, A_L_Ph);
  fConvertedText := ReplaceStr(fConvertedText, b_sh + b_Hasanta + b_C, A_Sh_C);
  fConvertedText := ReplaceStr(fConvertedText, b_sh + b_Hasanta + b_ch, A_Sh_Ch);
  fConvertedText := ReplaceStr(fConvertedText, b_ss + b_Hasanta + b_Nn, A_Ss_Nn);
  fConvertedText := ReplaceStr(fConvertedText, b_ss + b_Hasanta + b_tt, A_Ss_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_ss + b_Hasanta + b_tth, A_Ss_Tth);
  fConvertedText := ReplaceStr(fConvertedText, b_ss + b_Hasanta + b_ph, A_Ss_Ph);
  fConvertedText := ReplaceStr(fConvertedText, b_s + b_Hasanta + b_kh, A_S_Kh);
  fConvertedText := ReplaceStr(fConvertedText, b_s + b_Hasanta + b_tt, A_S_Tt);
  fConvertedText := ReplaceStr(fConvertedText, b_s + b_Hasanta + b_n, A_S_N);
  fConvertedText := ReplaceStr(fConvertedText, b_s + b_Hasanta + b_ph, A_S_Ph);
  fConvertedText := ReplaceStr(fConvertedText, b_h + b_Hasanta + b_n, A_H_N);
  fConvertedText := ReplaceStr(fConvertedText, b_h + b_Hasanta + b_m, A_H_M);
  fConvertedText := ReplaceStr(fConvertedText, b_rr + b_Hasanta + b_g, A_Rr_G);

end;

{ =============================================================================== }

function TUnicodeToBijoy2000.BaseLineRightCharacter(const wC: string): Boolean;
begin
  Result := False;
  if (wC = b_kh) or (wC = b_g) or (wC = b_gh) or (wC = b_Nn) or (wC = b_Th) or (wC = b_d) or (wC = b_dh) or (wC = b_n) or (wC = b_p) or (wC = b_b) or
    (wC = b_m) or (wC = b_z) or (wC = b_r) or (wC = b_L) or (wC = b_sh) or (wC = b_ss) or (wC = b_s) or (wC = b_h) or (wC = b_y) then
    Result := True;

end;

{ =============================================================================== }

function TUnicodeToBijoy2000.Convert(const UniText: string): string;
begin
  if UniText = '' then
  begin
    Result := '';
    exit;
  end;

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
end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.ConvertRFola_ZFola_Hasanta;
var
  I: Integer;
begin
  // Convert Z-Fola
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_z, A_ZFola);
  // Convert Hasanta
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + zwnj, A_Hasanta);
  // Convert R-Fola
  repeat
    I := Pos(b_Hasanta + b_r, fConvertedText);
    if I <= 0 then
      break;
    { P/G + RoFola }
    if ((MidStr(fConvertedText, I - 1, 1) = b_p) or (MidStr(fConvertedText, I - 1, 1) = b_g)) then
      // MidStr(fConvertedText, I, 2) := A_RFola_3
      fConvertedText := WideStuffString(fConvertedText, I, 2, A_RFola_3)
      { V+Rofola, 2nd Half V+Rofola }
    else if MidStr(fConvertedText, I - 1, 1) = b_Bh then
    begin
      if MidStr(fConvertedText, I - 2, 1) = b_Hasanta then
        // MidStr(fConvertedText, I - 1, 3) := A_BH_R_2H
        fConvertedText := WideStuffString(fConvertedText, I - 1, 3, A_BH_R_2H)
      else
        // MidStr(fConvertedText, I - 1, 3) := A_BH_R;
        fConvertedText := WideStuffString(fConvertedText, I - 1, 3, A_Bh_R);
    end
    { K+Rofola, 2nd Half K+Rofola }
    else if MidStr(fConvertedText, I - 1, 1) = b_K then
    begin
      if MidStr(fConvertedText, I - 2, 1) = b_Hasanta then
        // MidStr(fConvertedText, I - 1, 3) := A_K_R_2H
        fConvertedText := WideStuffString(fConvertedText, I - 1, 3, A_K_R_2H)
      else
        // MidStr(fConvertedText, I - 1, 3) := A_K_R;
        fConvertedText := WideStuffString(fConvertedText, I - 1, 3, A_K_R);
    end
    { T+Rofola, 2nd Half T+Rofola }
    else if MidStr(fConvertedText, I - 1, 1) = b_t then
    begin
      if MidStr(fConvertedText, I - 2, 1) = b_Hasanta then
      begin
        // MidStr(fConvertedText, I - 1, 3) := A_T_R_2H
        if (MidStr(fConvertedText, I - 3, 1) = b_K) or (MidStr(fConvertedText, I - 3, 1) = b_t) then
          fConvertedText := WideStuffString(fConvertedText, I, 2, A_RFola_2)
        else
          fConvertedText := WideStuffString(fConvertedText, I - 1, 3, A_T_R_2H);
      end
      else
        // MidStr(fConvertedText, I - 1, 3) := A_T_R;
        fConvertedText := WideStuffString(fConvertedText, I - 1, 3, A_T_R);
    end
    else
    begin
      if MidStr(fConvertedText, I - 1, 1) = b_ph then
        // MidStr(fConvertedText, I, 2) := A_RFola_2
        fConvertedText := WideStuffString(fConvertedText, I, 2, A_RFola_2)
      else
        // MidStr(fConvertedText, I, 2) := A_RFola_1;
        fConvertedText := WideStuffString(fConvertedText, I, 2, A_RFola_1);
    end;

  until I <= 0;
end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.DeNormalize;
begin
  fConvertedText := ReplaceStr(fUniText, b_z + b_Nukta, b_y);
  fConvertedText := ReplaceStr(fConvertedText, b_dd + b_Nukta, b_rr);
  fConvertedText := ReplaceStr(fConvertedText, b_ddh + b_Nukta, b_rrh);
end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.ReArrangeKars;
var
  I:           Integer;
  fKar, wCTmp: Char;
  wSTmp:       string;

  function MoveAbleKar(const wKar: Char): Boolean;
  begin
    Result := False;
    if ((wKar = b_Ekar) or (wKar = b_IKar) or (wKar = b_OIKar)) then
      Result := True;
  end;

begin
  // Break O-kar and OU-Kar
  fConvertedText := ReplaceStr(fConvertedText, b_OKar, b_Ekar + b_AAKar);
  fConvertedText := ReplaceStr(fConvertedText, b_OUKar, b_Ekar + b_LengthMark);

  // Bring IKar,EKar and OIkar to beginning of consonant/conjuncts
  I := Length(fConvertedText);
  wSTmp := '';
  fKar := #0;
  repeat
    wCTmp := fConvertedText[I];
    if MoveAbleKar(wCTmp) then
    begin // Make this kar pending
      fKar := wCTmp;
    end
    else
    begin
      if fKar = #0 then
      begin // No Kar is pending
        wSTmp := wCTmp + wSTmp;
      end
      else
      begin // Kar is pending
        if (I - 1 < 1) then
        begin // This is begining of text, no need to search back
          wSTmp := fKar + wCTmp + wSTmp;
          // Place pending kar at begining
          fKar := #0;
        end
        else
        begin // Not begining of text, search backward more deeply
          if ((IsPureConsonent(wCTmp) = False) and (wCTmp <> b_Hasanta) and (wCTmp <> zwj) and (wCTmp <> zwnj)) then
          begin
            // We are at the beginning of a Consonant, place pending kar here
            wSTmp := wCTmp + fKar + wSTmp;
            fKar := #0;
          end
          else
          begin
            if ((wCTmp = b_Hasanta) or (wCTmp = zwj) or (wCTmp = zwnj)) then
              wSTmp := wCTmp + wSTmp;

            if (IsPureConsonent(wCTmp) = True) then
            begin
              if ((fConvertedText[I - 1] = b_Hasanta) or (fConvertedText[I - 1] = zwj) or (fConvertedText[I - 1] = zwnj)) then
                wSTmp := wCTmp + wSTmp
              else
              begin
                wSTmp := fKar + wCTmp + wSTmp;
                // Place pending kar at begining
                fKar := #0;
              end;
            end;
          end;
        end;
      end;

    end;

    I := I - 1;
  until I < 1;

  fConvertedText := wSTmp;

  fConvertedText := ReplaceStr(fConvertedText, string('�'), A_StartDoubleQuote);
  fConvertedText := ReplaceStr(fConvertedText, string('�'), A_EndDoubleQuote);

end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.ReArrangeReph;
var
  I:           Integer;
  wCTmp:       Char;
  wSTmp:       string;
  RephPending: Boolean;

  function MoveAbleReph: Boolean;
  begin
    Result := False;
    if I + 2 > Length(fConvertedText) then
      exit;
    if ((fConvertedText[I] = b_r) and (fConvertedText[I + 1] = b_Hasanta) and (fConvertedText[I + 2] <> zwj) and (fConvertedText[I + 2] <> zwnj)) then
      Result := True;
  end;

begin
  if Length(fConvertedText) < 3 then
    exit;
  I := 1;
  wSTmp := '';
  RephPending := False;
  repeat
    wCTmp := fConvertedText[I];
    if MoveAbleReph = False then
    begin
      if RephPending = False then
      begin
        wSTmp := wSTmp + wCTmp;
      end
      else
      begin
        if ((IsPureConsonent(wCTmp) = False) and (wCTmp <> b_Hasanta) and (wCTmp <> zwj) and (wCTmp <> zwnj)) then
        begin
          wSTmp := wSTmp + A_Reph + wCTmp;
          RephPending := False;
        end
        else
        begin
          if I + 1 > Length(fConvertedText) then
          begin
            wSTmp := wSTmp + wCTmp + A_Reph;
            RephPending := False;
          end
          else
          begin
            if ((wCTmp = b_Hasanta) or (wCTmp = zwj) or (wCTmp = zwnj)) then
              wSTmp := wSTmp + wCTmp;

            if (IsPureConsonent(wCTmp) = True) then
            begin
              if ((fConvertedText[I + 1] = b_Hasanta) or (fConvertedText[I + 1] = zwj) or (fConvertedText[I + 1] = zwnj)) then
                wSTmp := wSTmp + wCTmp
              else
              begin
                wSTmp := wSTmp + wCTmp + A_Reph;
                RephPending := False;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      RephPending := True;
      I := I + 1;
    end;

    I := I + 1;
  until I > Length(fConvertedText);
  fConvertedText := wSTmp;
end;

{ =============================================================================== }

procedure TUnicodeToBijoy2000.ReplaceKarsVowels;
var
  I: Integer;
begin
  // Convert Ekar
  repeat
    I := Pos(b_Ekar, fConvertedText);
    if I <= 0 then
      break;
    if ((I = 1) or (MidStr(fConvertedText, I - 1, 1) = ' ') or (MidStr(fConvertedText, I - 1, 1) = #13) or (MidStr(fConvertedText, I - 1, 1) = #10) or
        (MidStr(fConvertedText, I - 1, 1) = #9)) then
      fConvertedText[I] := A_EKar1
    else
      fConvertedText[I] := A_EKar2;
  until I <= 0;

  // Convert OIKar
  repeat
    I := Pos(b_OIKar, fConvertedText);
    if I <= 0 then
      break;
    if ((I = 1) or (MidStr(fConvertedText, I - 1, 1) = ' ') or (MidStr(fConvertedText, I - 1, 1) = #13) or (MidStr(fConvertedText, I - 1, 1) = #10) or
        (MidStr(fConvertedText, I - 1, 1) = #9)) then
      fConvertedText[I] := A_OIKar1
    else
      fConvertedText[I] := A_OIKar2;
  until I <= 0;

  // Convert UKar
  fConvertedText := ReplaceStr(fConvertedText, b_g + b_Ukar, A_G_Ukar);
  fConvertedText := ReplaceStr(fConvertedText, b_sh + b_Ukar, A_Sh_UKar);
  fConvertedText := ReplaceStr(fConvertedText, b_h + b_Ukar, A_H_UKar);
  fConvertedText := ReplaceStr(fConvertedText, b_Hasanta + b_t + b_Ukar, b_Hasanta + A_T_UKar_2H);
  repeat
    I := Pos(b_Ukar, fConvertedText);
    if I <= 0 then
      break;
    if I - 1 >= 1 then
    begin
      if BaseLineRightCharacter(fConvertedText[I - 1]) = True then
      begin

        if fConvertedText[I - 1] = b_r then
        begin
          if ((MidStr(fConvertedText, I - 3, 3) = b_sh + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_d + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_g + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_t + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_j + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_Th + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_dh + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 5, 5) = b_n + b_Hasanta + b_d + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_p + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_b + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_Bh + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_m + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_s + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 5, 5) = b_m + b_Hasanta + b_p + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 5, 5) = b_ss + b_Hasanta + b_p + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 5, 5) = b_s + b_Hasanta + b_p + b_Hasanta + b_r)) then
            fConvertedText[I] := A_UKar4
          else if MidStr(fConvertedText, I - 2, 1) <> b_Hasanta then
            fConvertedText[I] := A_UKar4
          else
            fConvertedText[I] := A_UKar2;
        end
        else if fConvertedText[I - 1] = b_L then
        begin
          if ((MidStr(fConvertedText, I - 3, 3) = b_g + b_Hasanta + b_L) or (MidStr(fConvertedText, I - 3, 3) = b_p + b_Hasanta + b_L) or
              (MidStr(fConvertedText, I - 3, 3) = b_b + b_Hasanta + b_L) or (MidStr(fConvertedText, I - 3, 3) = b_sh + b_Hasanta + b_L) or
              (MidStr(fConvertedText, I - 3, 3) = b_s + b_Hasanta + b_L) or (MidStr(fConvertedText, I - 5, 5) = b_s + b_Hasanta + b_p + b_Hasanta + b_L)) then
            fConvertedText[I] := A_UKar4
          else
            fConvertedText[I] := A_UKar2;
        end
        else
          fConvertedText[I] := A_UKar2;

        if MidStr(fConvertedText, I - 3, 3) = b_ss + b_Hasanta + b_Nn then
          fConvertedText[I] := A_UKar1;
        { Else
          fConvertedText[I] := A_UKar2; }

      end
      else
      begin
        if ((fConvertedText[I - 1] = b_rr) or (fConvertedText[I - 1] = b_rrh)) then
        begin
          fConvertedText[I] := A_UKar3;
        end
        else
          fConvertedText[I] := A_UKar1;
      end;
    end
    else
      fConvertedText[I] := A_UKar1;
  until I <= 0;

  // Convert UUKar
  repeat
    I := Pos(b_UUKar, fConvertedText);
    if I <= 0 then
      break;
    if I - 1 >= 1 then
    begin
      if BaseLineRightCharacter(fConvertedText[I - 1]) = True then
      begin
        if fConvertedText[I - 1] = b_r then
        begin
          if ((MidStr(fConvertedText, I - 3, 3) = b_sh + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_d + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_g + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_t + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_j + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_Th + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_dh + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 5, 5) = b_n + b_Hasanta + b_d + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_p + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_b + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_Bh + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 3, 3) = b_m + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 3, 3) = b_s + b_Hasanta + b_r) or (MidStr(fConvertedText, I - 5, 5) = b_m + b_Hasanta + b_p + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 5, 5) = b_ss + b_Hasanta + b_p + b_Hasanta + b_r) or
              (MidStr(fConvertedText, I - 5, 5) = b_s + b_Hasanta + b_p + b_Hasanta + b_r)) then
            fConvertedText[I] := A_UUKar3
          else if MidStr(fConvertedText, I - 2, 1) <> b_Hasanta then
            fConvertedText[I] := A_UUKar3
          else
            fConvertedText[I] := A_UUKar2;
        end
        else if fConvertedText[I - 1] = b_L then
        begin
          if ((MidStr(fConvertedText, I - 3, 3) = b_g + b_Hasanta + b_L) or (MidStr(fConvertedText, I - 3, 3) = b_p + b_Hasanta + b_L) or
              (MidStr(fConvertedText, I - 3, 3) = b_b + b_Hasanta + b_L) or (MidStr(fConvertedText, I - 3, 3) = b_sh + b_Hasanta + b_L) or
              (MidStr(fConvertedText, I - 3, 3) = b_s + b_Hasanta + b_L) or (MidStr(fConvertedText, I - 5, 5) = b_s + b_Hasanta + b_p + b_Hasanta + b_L)) then
            fConvertedText[I] := A_UUKar3
          else
            fConvertedText[I] := A_UUKar2;
        end
        else
          fConvertedText[I] := A_UUKar2;
      end
      else
        fConvertedText[I] := A_UUKar1;
    end
    else
      fConvertedText[I] := A_UUKar1;
  until I <= 0;

  // Convert RRIKar
  fConvertedText := ReplaceStr(fConvertedText, b_h + b_Rrikar, A_H_RRIKar);
  repeat
    I := Pos(b_Rrikar, fConvertedText);
    if I <= 0 then
      break;
    if I - 1 >= 1 then
    begin
      if BaseLineRightCharacter(fConvertedText[I - 1]) = True then
      begin
        fConvertedText[I] := A_RRIKar1;
      end
      else
        fConvertedText[I] := A_RRIKar2;
    end
    else
      fConvertedText[I] := A_RRIKar2;
  until I <= 0;

  // Convert rest of the Kars
  fConvertedText := ReplaceStr(fConvertedText, b_AAKar, A_AAKar);
  fConvertedText := ReplaceStr(fConvertedText, b_IKar, A_IKar);
  fConvertedText := ReplaceStr(fConvertedText, b_IIKar, A_IIKar);
  fConvertedText := ReplaceStr(fConvertedText, b_LengthMark, A_OUKar);

  // Convert Vowels
  fConvertedText := ReplaceStr(fConvertedText, b_A, A_A);
  fConvertedText := ReplaceStr(fConvertedText, b_AA, A_AA);
  fConvertedText := ReplaceStr(fConvertedText, b_I, A_I);
  fConvertedText := ReplaceStr(fConvertedText, b_II, A_II);
  fConvertedText := ReplaceStr(fConvertedText, b_U, A_U);
  fConvertedText := ReplaceStr(fConvertedText, b_UU, A_UU);
  fConvertedText := ReplaceStr(fConvertedText, b_RRI, A_RRI);
  fConvertedText := ReplaceStr(fConvertedText, b_E, A_E);
  fConvertedText := ReplaceStr(fConvertedText, b_OI, A_OI);
  fConvertedText := ReplaceStr(fConvertedText, b_O, A_O);
  fConvertedText := ReplaceStr(fConvertedText, b_OU, A_OU);
end;

{ =============================================================================== }

function TUnicodeToBijoy2000.WideStuffString(Source: string; Start, Len: Integer; SubString: string): string;
var
  FirstPart, LastPart: string;
begin
  FirstPart := LeftStr(Source, Start - 1);
  LastPart := MidStr(Source, Start + Len, Length(Source));
  Result := FirstPart + SubString + LastPart;
end;

{ =============================================================================== }

end.
