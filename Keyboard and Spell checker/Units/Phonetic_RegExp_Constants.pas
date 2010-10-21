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

Unit Phonetic_RegExp_Constants;

{.$DEFINE FASTSEARCH_OFF}  //Uncomment to turn OFF fast searching

Interface
Uses
     BanglaChars;

Var
     r_A,
          r_B,
          r_C,
          r_D,
          r_E,
          r_F,
          r_G,
          r_H,
          r_I,
          r_J,
          r_K,
          r_L,
          r_M,
          r_N,
          r_O,
          r_OFirst,
          r_P,
          r_Q,
          r_R,
          r_S,
          r_T,
          r_U,
          r_V,
          r_W,
          r_X,
          r_Y,
          r_Z                 : String;

     r_AI,
          r_AU,
          r_AA,
          r_AZ,
          r_BH,
          r_BB,
          r_BD,
          r_BV,
          r_CH,
          r_CK,
          r_CC,
          r_CN,
          r_DB,
          r_DD,
          r_DG,
          r_DH,
          r_EY,
          r_EE,
          r_FF,
          r_GH,
          r_GG,
          r_HL,
          r_HH,
          r_HM,
          r_HN,
          r_IA,
          r_JJ,
          r_JH,
          r_KH,
          r_KK,
          r_KS,
          r_KX,
          r_LL,
          r_LK,
          r_LG,
          r_LP,
          r_LD,
          r_LB,
          r_MM,
          r_MB,
          r_MP,
          r_MT,
          r_NC,
          r_NN,
          r_NG,
          r_NK,
          r_NJ,
          r_ND,
          r_NT,
          r_OO,
          r_OI,
          r_OU,
          r_PH,
          r_PP,
          r_QQ,
          r_RI,
          r_RH,
          r_SS,
          r_SH,
          r_TT,
          r_TH,
          r_UU,
          r_VV,
          r_XM,
          r_XN,
          r_ZH,
          r_ZZ                : String;

     r_BBH,
          r_BDH,
          r_BHL,
          r_CCH,
          r_CHH,
          r_CNG,
          r_DHM,
          r_DHN,
          r_DBH,
          r_DDH,
          r_DGH,
          r_GDH,
          r_GGH,
          r_GHN,
          r_JNG,
          r_JJH,
          r_KSH,
          r_KKH,
          r_KXM,
          r_KXN,
          r_LKH,
          r_LGH,
          r_LPH,
          r_LDH,
          r_LBH,
          r_MBH,
          r_MPH,
          r_MTH,
          r_NSH,
          r_NDH,
          r_NKH,
          r_NTH,
          r_NGJ,
          r_NGM,
          r_NGG,
          r_NGX,
          r_NGK,
          r_NGH,
          r_NCH,
          r_NJH,
          r_NGC,
          r_PHL,
          r_RRI,
          r_SSH,
          r_SHM,
          r_SHN,
          r_T_Acnt_Acnt,
          r_TTH,
          r_ZZH               : String;

     r_KSHM,
          r_KKHM,
          r_KSHN,
          r_KKHN,
          r_NGKH,
          r_NGCH,
          r_NGGH,
          r_NGKX,
          r_NGJH,
          r_SHSH,
          r_THTH              : String;


     r_CHCHH,
          r_NGKSH,
          r_NGKKH             : String;


     r_InjectFola,
          r_InjectHasanta,
          r_InjectChandraBisharga: String;


Procedure Initialize_RVals;

Implementation

Procedure Initialize_RVals;
Begin

     r_InjectFola := '(' + b_Hasanta + '[' + b_Z + b_B + b_M + '])?';
     r_InjectHasanta := '(' + b_Hasanta + '?)';
     r_InjectChandraBisharga := '([' + b_Bisharga + b_Chandra + ']?)';

     {Single characters}
     {FastSearch OFF}
     {$IFDEF FASTSEARCH_OFF}
     r_A := '(([' + b_A + b_E + ']' + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_AA + b_E + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')?' + b_AAkar + ')|(' + b_Y + b_AAkar + '))';
     r_B := '(' + b_B + '|(' + b_B + b_Ikar + '))';
     r_C := '(([' + b_C + b_CH + '])|(' + b_S + b_Ikar + '))';
     r_D := '(([' + b_D + b_Dd + '])|(' + b_Dd + b_Ikar + '))';
     r_E := '((' + b_E + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_E + b_Ekar + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')' + b_AAkar + ')|(' + b_Y + b_Ekar + '))';
     r_F := '(' + b_Ph + '|(' + b_E + b_Ph + '))';
     r_G := '(' + b_G + '|(' + b_J + b_Ikar + ')|(' + b_J + b_Hasanta + b_NYA + '))';
     r_H := '(' + b_H + '|(' + b_E + b_I + b_C + ')|' + b_Bisharga + '|(' + b_H + b_Hasanta + ZWNJ + '?))';
     r_I := '(([' + b_I + b_II + b_Ikar + b_IIkar + '])|(' + b_Y + '[' + b_Ikar + b_IIkar + ']))';
     r_J := '(([' + b_J + b_Z + '])|(' + b_J + b_Ekar + ')|(' + b_J + b_Nukta + '))';
     r_K := '(' + b_K + '|(' + b_K + b_Ekar + '))';
     r_L := '(' + b_L + '|(' + b_E + b_L + '))';
     r_M := '(' + b_M + '|(' + b_E + b_M + '))';
     r_N := '(([' + b_N + b_Nn + b_Chandra + b_NGA + b_NYA + b_Anushar + '])|(' + b_E + b_N + '))';
     r_O := '(([' + b_O + b_Okar + b_A + '])|(' + b_A + b_Hasanta + b_Z + ')|(' + b_Y + b_Okar + '?))?';
     r_OFirst := '(([' + b_O + b_Okar + b_A + '])|(' + b_A + b_Hasanta + b_Z + ')|(' + b_Y + b_Okar + '?))';
     r_P := '(' + b_P + '|(' + b_P + b_Ikar + '))';
     r_Q := '((' + b_K + ')|(' + b_K + b_Ikar + b_U + '))';
     r_R := '(([' + b_R + b_Rr + b_Rrh + '])|(' + b_AA + b_R + ')|(' + b_H + b_Hasanta + b_R + '))';
     r_S := '(([' + b_S + b_Sh + b_Ss + '])|(' + b_E + b_S + '))';
     r_T := '(([' + b_T + b_Tt + b_Khandatta + '])|(' + b_Tt + b_Ikar + '))';
     r_U := '(([' + b_U + b_UU + b_Ukar + b_UUkar + '])|(' + b_I + b_U + ')|(' + b_Y + '[' + b_Ukar + b_UUkar + ']))';
     r_V := '(' + b_Bh + '|(' + b_Bh + b_Ikar + '))';
     r_W := '(' + b_O + '|(' + b_O + b_Y + ')|(' + b_Hasanta + b_B + ')|(' + b_Dd + b_B + b_Hasanta + b_L + b_Ikar + b_U + '))';
     r_X := '((' + b_K + b_Hasanta + b_S + ')|(' + b_E + b_K + b_Hasanta + b_S + ')|' + b_Ss + ')';
     r_Y := '(' + b_Y + '|(' + b_I + b_Y + ')|(' + b_O + b_Y + b_AAkar + b_I + ')|([' + ZWJ + ZWNJ + ']?' + b_Hasanta + b_Z + '))';
     r_Z := '(' + b_J + '|' + b_Z + '|(' + b_J + b_Nukta + ')|(' + b_J + b_Ekar + b_Dd + ')|([' + ZWJ + ZWNJ + ']?' + b_Hasanta + b_Z + '))';
     {$ELSE}
     {FastSearch On}
     r_A := '(([' + b_A + b_E + ']' + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_AA + b_E + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')?' + b_AAkar + ')|(' + b_Y + b_AAkar + '))';
     r_B := '(' + b_B + ')';
     r_C := '([' + b_C + b_CH + '])';
     r_D := '([' + b_D + b_Dd + '])';
     r_E := '((' + b_E + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_E + b_Ekar + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')' + b_AAkar + ')|(' + b_Y + b_Ekar + '))';
     r_F := '(' + b_Ph + ')';
     r_G := '(' + b_G + '|(' + b_J + b_Hasanta + b_NYA + '))';
     r_H := '(' + b_H + '|' + b_Bisharga + '|(' + b_H + b_Hasanta + ZWNJ + '?))';
     r_I := '(([' + b_I + b_II + b_Ikar + b_IIkar + '])|(' + b_Y + '[' + b_Ikar + b_IIkar + ']))';
     r_J := '(([' + b_J + b_Z + '])|(' + b_J + b_Nukta + '))';
     r_K := '(' + b_K + ')';
     r_L := '(' + b_L + ')';
     r_M := '(' + b_M + ')';
     r_N := '([' + b_N + b_Nn + b_Chandra + b_NGA + b_NYA + b_Anushar + '])';
     r_O := '(([' + b_O + b_Okar + b_A + '])|(' + b_A + b_Hasanta + b_Z + ')|(' + b_Y + b_Okar + '?))?';
     r_OFirst := '(([' + b_O + b_Okar + b_A + '])|(' + b_A + b_Hasanta + b_Z + ')|(' + b_Y + b_Okar + '?))';
     r_P := '(' + b_P + ')';
     r_Q := '(' + b_K + ')';
     r_R := '(([' + b_R + b_Rr + b_Rrh + '])|(' + b_H + b_Hasanta + b_R + '))';
     r_S := '([' + b_S + b_Sh + b_Ss + '])';
     r_T := '([' + b_T + b_Tt + b_Khandatta + '])';
     r_U := '(([' + b_U + b_UU + b_Ukar + b_UUkar + '])|(' + b_Y + '[' + b_Ukar + b_UUkar + ']))';
     r_V := '(' + b_Bh + ')';
     r_W := '(' + b_O + '|(' + b_O + b_Y + ')|(' + b_Hasanta + b_B + '))';
     r_X := '((' + b_K + b_Hasanta + b_S + ')|' + b_Ss + ')';
     r_Y := '(' + b_Y + '|(' + b_I + b_Y + ')|([' + ZWJ + ZWNJ + ']?' + b_Hasanta + b_Z + '))';
     r_Z := '(' + b_J + '|' + b_Z + '|(' + b_J + b_Nukta + ')|([' + ZWJ + ZWNJ + ']?' + b_Hasanta + b_Z + '))';
     {$ENDIF}

     {Two character combinations}
     //A
     r_AI := '(' + b_OI + '|' + b_OIkar + '|' + r_A + r_I + ')';
     r_AU := '(' + b_OU + '|' + b_OUkar + r_A + r_U + ')';
     r_AZ:= '('+ r_A + '('+r_Z+')?)';
     r_AA := '((' + b_AA + ')|(' + b_Y + b_AAkar + ')|(' + b_AAkar + ')|(' + r_a + '(' + r_a + ')?))';
     //B
     r_BH := '((' + b_Bh + ')|(' + r_b + '(' + b_Hasanta + '?)' + r_h + '))';
     r_BB := '(' + r_b + '(' + b_Hasanta + '?)(' + r_b + ')?)';
     r_BV := '((' + r_b + ')?(' + b_Hasanta + '?)' + r_v + ')';
     r_BD := '(' + r_b + '(' + b_Hasanta + '?)' + r_d + ')';
     //C
     r_CH := '((' + b_C + ')|(' + b_CH + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_h + '))';
     r_CK := '((' + b_K + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_k + '))';
     r_CC := '(' + r_c + '(' + b_Hasanta + '?)(' + r_c + ')?)';
     r_CN := '(' + r_c + '(' + b_Hasanta + '?)' + r_n + ')';
     //D
     r_DB := '(' + r_d + '(' + b_Hasanta + '?)' + r_b + ')';
     r_DD := '(' + r_d + '(' + b_Hasanta + '?)(' + r_d + ')?)';
     r_DG := '(' + r_d + '(' + b_Hasanta + '?)' + r_g + ')';
     r_DH := '((' + b_Dh + ')|(' + b_Ddh + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_h + '))';
     //E
     r_EY := '((' + b_E + ')|(' + b_I + ')|(' + b_Ekar + ')|(' + b_Ekar + b_I + ')|(' + b_E + b_I + ')|(' + b_II + ')|(' + b_IIkar + ')|(' + r_e + r_y + '))';
     r_EE := '((' + b_I + ')|(' + b_II + ')|(' + b_Ikar + ')|(' + b_IIkar + ')|(' + b_Y + b_Ekar + b_I + ')|(' + r_e + r_e + '))';
     //F
     r_FF := '(' + r_f + '(' + b_Hasanta + '?)(' + r_f + ')?)';
     //G
     r_GH := '((' + b_GH + ')|(' + r_g + '(' + b_Hasanta + '?)' + r_h + '))';
     r_GG := '((' + b_J + b_Hasanta + b_NYA + ')|(' + r_g + '(' + b_Hasanta + '?)(' + r_g + ')?))';
     //H
     r_HL := '(' + r_h + '(' + b_Hasanta + '?)' + r_l + ')';
     r_HH := '(' + r_h + '(' + b_Hasanta + '?)' + r_h + ')';
     r_HM := '(' + r_h + '(' + b_Hasanta + '?)' + r_m + ')';
     r_HN := '(' + r_h + '(' + b_Hasanta + '?)' + r_n + ')';
     //I
     r_IA := '((' + b_NYA + b_AAkar + ')|(' + r_i + r_a + '))';
     //J
     r_JJ := '((' + b_H + b_Hasanta + b_Z + ')|(' + r_j + '(' + b_Hasanta + '?)(' + r_j + ')?))';
     r_JH := '((' + b_JH + ')|(' + r_j + '(' + b_Hasanta + '?)' + r_h + '))';
     //K
     r_KH := '((' + b_KH + ')|(' + b_K + b_Hasanta + b_Ss + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_h + '))';
     r_KK := '(' + r_k + '(' + b_Hasanta + '?)(' + r_k + ')?)';
     r_KS := '(' + r_k + '(' + b_Hasanta + '?)' + r_s + ')';
     r_KX := '((' + b_K + b_Hasanta + b_Ss + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_x + '))';
     //L
     r_LL := '((' + b_H + b_Hasanta + b_L + ')|((' + r_l + ')?(' + b_Hasanta + '?)' + r_l + ')|(' + r_l + '(' + b_Hasanta + '?)' + r_l + '))';
     r_LK := '(' + r_l + '(' + b_Hasanta + '?)' + r_k + ')';
     r_LG := '(' + r_l + '(' + b_Hasanta + '?)' + r_g + ')';
     r_LP := '(' + r_l + '(' + b_Hasanta + '?)' + r_p + ')';
     r_LD := '(' + r_l + '(' + b_Hasanta + '?)' + r_d + ')';
     r_LB := '(' + r_l + '(' + b_Hasanta + '?)' + r_b + ')';
     //M
     r_MM := '((' + b_H + b_Hasanta + b_M + ')|(' + r_m + '(' + b_Hasanta + '?)(' + r_m + ')?))';
     r_MB := '(' + r_m + '(' + b_Hasanta + '?)' + r_b + ')';
     r_MP := '(' + r_m + '(' + b_Hasanta + '?)' + r_p + ')';
     r_MT := '(' + r_m + '(' + b_Hasanta + '?)' + r_t + ')';
     //N
     r_NC := '((' + b_NYA + b_Hasanta + b_C + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_c + '))';
     r_NN := '((' + b_H + b_Hasanta + b_Nn + ')|(' + b_H + b_Hasanta + b_N + ')|(' + r_n + '(' + b_Hasanta + '?)(' + r_n + ')?))';
     r_NG := '((' + b_NGA + ')|(' + b_Anushar + ')|(' + b_NYA + ')|(' + b_NGA + b_Hasanta + b_G + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '))';
     r_NK := '((' + b_NGA + b_Hasanta + b_K + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_k + '))';
     r_NJ := '((' + b_NYA + b_Hasanta + b_J + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_j + '))';
     r_ND := '(' + r_n + '(' + b_Hasanta + '?)' + r_d + ')';
     r_NT := '(' + r_n + '(' + b_Hasanta + '?)' + r_t + ')';
     //O
     r_OO := '((' + r_u + ')|(' + r_o + r_o + '))';
     r_OI := '((' + b_OI + ')|(' + b_OIkar + ')|(' + r_o + r_i + '))';
     r_OU := '((' + b_OU + ')|(' + b_OUkar + ')|(' + r_o + r_u + '))';
     //P
     r_PH := '((' + b_Ph + ')|(' + r_p + '(' + b_Hasanta + '?)' + r_h + '))';
     r_PP := '(' + r_p + '(' + b_Hasanta + '?)(' + r_p + ')?)';
     //Q
     r_QQ := '(' + r_q + '(' + b_Hasanta + '?)(' + r_q + ')?)';
     //R
     r_RI := '((' + b_RRI + ')|(' + b_RRIkar + ')|(' + b_H + b_RRIkar + ')|(' + r_r + r_i + '))';
     r_RH := '((' + r_r + ')|(' + r_r + '(' + b_Hasanta + '?)' + r_h + '))';
     //S
     r_SS := '(' + r_s + '(' + b_Hasanta + '?)(' + r_s + ')?)';
     r_SH := '((' + b_S + ')|(' + b_Sh + ')|(' + b_Ss + ')|(' + r_s + '(' + b_Hasanta + '?)' + r_h + '))';
     //T
     r_TT := '(' + r_t + '(' + b_Hasanta + '?)(' + r_t + ')?)';
     r_TH := '((' + b_Th + ')|(' + b_Tth + ')|(' + r_t + '(' + b_Hasanta + '?)' + r_h + '))';
     //U
     r_UU := '((' + b_UU + ')|(' + b_UUkar + ')|(' + r_u + '(' + r_u + ')?))';
     //V
     r_VV := '(' + r_v + '(' + b_Hasanta + '?)(' + r_v + ')?)';
     //W
     //X
     r_XM := '(' + r_x + '(' + b_Hasanta + '?)' + r_m + ')';
     r_XN := '(' + r_x + '(' + b_Hasanta + '?)' + r_n + ')';
     //Y
     //Z
     r_ZH := '((' + b_JH + ')|(' + r_j + '(' + b_Hasanta + '?)' + r_h + '))';
     r_ZZ := '((' + b_H + b_Hasanta + b_Z + ')|(' + r_z + '(' + b_Hasanta + '?)(' + r_z + ')?))';


     {Three character combinations}
     //A
     //B
     r_BBH := '(((' + r_b + ')?(' + b_Hasanta + '?)' + r_bh + ')|(' + r_bb + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_b + '(' + b_Hasanta + '?)' + r_b + '(' + b_Hasanta + '?)' + r_h + '))';
     r_BDH := '((' + r_b + '(' + b_Hasanta + '?)' + r_dh + ')|(' + r_bd + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_b + '(' + b_Hasanta + '?)' + r_d + '(' + b_Hasanta + '?)' + r_h + '))';
     r_BHL := '((' + r_bh + '(' + b_Hasanta + '?)' + r_l + ')|(' + r_b + '(' + b_Hasanta + '?)' + r_hl + ')|(' + r_b + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_l + '))';
     //C
     r_CCH := '((' + r_c + '(' + b_Hasanta + '?)' + r_ch + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_c + '(' + b_Hasanta + '?)' + r_h + '))';
     r_CHH := '((' + r_ch + '(' + b_Hasanta + '?)' + '(' + r_h + ')?' + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_hh + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_h + '))';
     r_CNG := '((' + b_C + b_Hasanta + b_NYA + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_ng + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_n + '(' + b_Hasanta + '?)' + r_g + ')|(' + r_cn + '(' + b_Hasanta + '?)' + r_g + '))';
     //D
     r_DHM := '((' + r_dh + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_hm + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_m + '))';
     r_DHN := '((' + r_dh + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_hn + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_n + '))';
     r_DBH := '((' + r_d + '(' + b_Hasanta + '?)' + r_bh + ')|(' + r_db + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_b + '(' + b_Hasanta + '?)' + r_h + '))';
     r_DDH := '(((' + r_d + ')?(' + b_Hasanta + '?)' + r_dh + ')|(' + r_dd + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_d + '(' + b_Hasanta + '?)' + r_h + '))';
     r_DGH := '((' + r_d + '(' + b_Hasanta + '?)' + r_gh + ')|(' + r_dg + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_d + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_h + '))';
     //E
     //F
     //G
     r_GDH := '((' + r_g + '(' + b_Hasanta + '?)' + r_dh + ')|(' + r_g + '(' + b_Hasanta + '?)' + r_d + '(' + b_Hasanta + '?)' + r_h + '))';
     r_GGH := '((' + r_gg + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_g + '(' + b_Hasanta + '?)' + r_gh + ')|(' + r_g + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_h + '))';
     r_GHN := '((' + r_gh + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_g + '(' + b_Hasanta + '?)' + r_hn + ')|(' + r_g + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_n + '))';
     //H
     //I
     //J
     r_JNG := '((' + b_J + b_Hasanta + b_NYA + ')|(' + r_j + '(' + b_Hasanta + '?)' + r_ng + ')|(' + r_j + '(' + b_Hasanta + '?)' + r_n + '(' + b_Hasanta + '?)' + r_g + '))';
     r_JJH := '(((' + r_j + ')?(' + b_Hasanta + '?)' + r_jh + ')|(' + b_H + b_Hasanta + b_Z + ')|(' + r_jj + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_j + '(' + b_Hasanta + '?)' + r_j + '(' + b_Hasanta + '?)' + r_h + '))';
     //K
     r_KSH := '((' + r_k + '(' + b_Hasanta + '?)' + r_sh + ')|(' + r_ks + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_s + '(' + b_Hasanta + '?)' + r_h + '))';
     r_KKH := '((' + b_K + b_Hasanta + b_Ss + ')|(' + r_kk + '(' + b_Hasanta + '?)' + r_h + ')|((' + r_k + ')?(' + b_Hasanta + '?)' + r_kh + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + '))';
     r_KXM := '((' + r_kx + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_xm + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_x + '(' + b_Hasanta + '?)' + r_m + '))';
     r_KXN := '((' + r_kx + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_xn + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_x + '(' + b_Hasanta + '?)' + r_n + '))';
     //L
     r_LKH := '((' + r_l + '(' + b_Hasanta + '?)' + r_kh + ')|(' + r_lk + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_l + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + '))';
     r_LGH := '((' + r_l + '(' + b_Hasanta + '?)' + r_gh + ')|(' + r_lg + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_l + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_h + '))';
     r_LPH := '((' + r_l + '(' + b_Hasanta + '?)' + r_ph + ')|(' + r_lp + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_l + '(' + b_Hasanta + '?)' + r_p + '(' + b_Hasanta + '?)' + r_h + '))';
     r_LDH := '((' + r_l + '(' + b_Hasanta + '?)' + r_dh + ')|(' + r_ld + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_l + '(' + b_Hasanta + '?)' + r_d + '(' + b_Hasanta + '?)' + r_h + '))';
     r_LBH := '((' + r_l + '(' + b_Hasanta + '?)' + r_bh + ')|(' + r_lb + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_l + '(' + b_Hasanta + '?)' + r_b + '(' + b_Hasanta + '?)' + r_h + '))';
     //M
     r_MBH := '((' + r_m + '(' + b_Hasanta + '?)' + r_bh + ')|(' + r_mb + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_m + '(' + b_Hasanta + '?)' + r_b + '(' + b_Hasanta + '?)' + r_h + '))';
     r_MPH := '((' + r_m + '(' + b_Hasanta + '?)' + r_ph + ')|(' + r_mp + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_m + '(' + b_Hasanta + '?)' + r_p + '(' + b_Hasanta + '?)' + r_h + '))';
     r_MTH := '((' + r_m + '(' + b_Hasanta + '?)' + r_th + ')|(' + r_mt + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_m + '(' + b_Hasanta + '?)' + r_t + '(' + b_Hasanta + '?)' + r_h + '))';
     //N
     r_NSH := '((' + r_n + '(' + b_Hasanta + '?)' + r_sh + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_s + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NDH := '((' + r_n + '(' + b_Hasanta + '?)' + r_dh + ')|(' + r_nd + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_d + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NKH := '((' + r_n + '(' + b_Hasanta + '?)' + r_kh + ')|(' + r_nk + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NTH := '((' + r_n + '(' + b_Hasanta + '?)' + r_th + ')|(' + r_nt + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_t + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NGJ := '((' + r_ng + '(' + b_Hasanta + '?)' + r_j + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_j + '))';
     r_NGM := '((' + r_ng + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_m + '))';
     r_NGG := '((' + b_NGA + b_Hasanta + b_G + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_g + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_g + '))';
     r_NGX := '((' + r_ng + '(' + b_Hasanta + '?)' + r_x + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_x + '))';
     r_NGK := '((' + r_ng + '(' + b_Hasanta + '?)' + r_k + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_k + '))';
     r_NGH := '((' + b_NGA + b_Hasanta + b_GH + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_gh + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NCH := '((' + r_n + '(' + b_Hasanta + '?)' + r_ch + ')|(' + r_nc + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_c + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NJH := '((' + r_n + '(' + b_Hasanta + '?)' + r_jh + ')|(' + r_nj + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_j + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NGC := '((' + r_ng + '(' + b_Hasanta + '?)' + r_c + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_c + '))';
     //O
     //P
     r_PHL := '((' + r_ph + '(' + b_Hasanta + '?)' + r_l + ')|(' + r_p + '(' + b_Hasanta + '?)' + r_hl + ')|(' + r_p + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_l + '))';
     //Q
     //R
     r_RRI := '((' + b_RRI + ')|(' + b_RRIkar + ')|(' + r_r + r_r + r_i + '))';
     //S
     r_SSH := '(((' + r_s + ')?(' + b_Hasanta + '?)' + r_sh + ')|(' + r_s + '(' + b_Hasanta + '?)' + r_s + '(' + b_Hasanta + '?)' + r_h + '))';
     r_SHM := '((' + r_sh + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_s + '(' + b_Hasanta + '?)' + r_hm + ')|(' + r_s + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_m + '))';
     r_SHN := '((' + r_sh + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_s + '(' + b_Hasanta + '?)' + r_hn + ')|(' + r_s + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_n + '))';
     //T
     r_T_Acnt_Acnt := '(' + b_Khandatta + ')';
     r_TTH := '(((' + r_t + ')?(' + b_Hasanta + '?)' + r_th + ')|(' + r_tt + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_t + '(' + b_Hasanta + '?)' + r_t + '(' + b_Hasanta + '?)' + r_h + '))';
     //U
     //V
     //W
     //X
     //Y
     //Z
     r_ZZH := '((' + b_H + b_Hasanta + b_Z + ')|(' + r_z + '(' + b_Hasanta + '?)' + r_zh + ')|(' + r_zz + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_z + '(' + b_Hasanta + '?)' + r_z + '(' + b_Hasanta + '?)' + r_h + '))';


     {Four character combinations}
     //A
     //B
     //C
     //D
     //E
     //F
     //G
     //H
     //I
     //J
     //K
     r_KSHM := '((' + r_ksh + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_shm + ')|(' + r_ks + '(' + b_Hasanta + '?)' + r_hm + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_sh + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_s + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_m + '))';
     r_KKHM := '((' + r_kkh + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_kk + '(' + b_Hasanta + '?)' + r_hm + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_m + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_kh + '(' + b_Hasanta + '?)' + r_m + '))';
     r_KSHN := '((' + r_ksh + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_shn + ')|(' + r_ks + '(' + b_Hasanta + '?)' + r_hn + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_sh + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_s + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_n + '))';
     r_KKHN := '((' + r_kkh + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_kk + '(' + b_Hasanta + '?)' + r_hn + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_n + ')|(' + r_k + '(' + b_Hasanta + '?)' + r_kh + '(' + b_Hasanta + '?)' + r_n + '))';
     //L
     //M
     //N
     r_NGCH := '((' + r_ng + '(' + b_Hasanta + '?)' + r_ch + ')|(' + r_ngc + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_c + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NGGH := '((' + r_ng + '(' + b_Hasanta + '?)' + r_gh + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_gg + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_ggh + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_ngg + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NGKH := '((' + r_ng + '(' + b_Hasanta + '?)' + r_kh + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_ngk + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NGKX := '((' + r_ng + '(' + b_Hasanta + '?)' + r_kx + ')|(' + r_ngk + '(' + b_Hasanta + '?)' + r_x + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_kx + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_x + '))';
     r_NGJH := '((' + r_ng + '(' + b_Hasanta + '?)' + r_jh + ')|(' + r_ngj + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_j + '(' + b_Hasanta + '?)' + r_h + '))';
     //O
     //P
     //Q
     //R
     //S
     r_SHSH := '(((' + r_sh + ')?(' + b_Hasanta + '?)' + r_sh + ')|(' + r_s + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_s + '(' + b_Hasanta + '?)' + r_h + '))';
     //T
     r_THTH := '((' + b_T + b_Hasanta + b_Th + ')|((' + r_th + ')?(' + b_Hasanta + '?)' + r_th + ')|(' + r_t + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_t + '(' + b_Hasanta + '?)' + r_h + '))';
     //U
     //V
     //W
     //X
     //Y
     //Z

     {Five character combinations}
     //C
     r_CHCHH := '((' + b_C + b_Hasanta + b_CH + ')|(' + r_ch + '(' + b_Hasanta + '?)' + r_chh + ')|(' + r_ch + '(' + b_Hasanta + '?)' + r_ch + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_c + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_c + '(' + b_Hasanta + '?)' + r_h + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NGKSH := '((' + r_ngk + '(' + b_Hasanta + '?)' + r_sh + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_sh + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_ksh + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_ks + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_s + '(' + b_Hasanta + '?)' + r_h + '))';
     r_NGKKH := '((' + r_ng + '(' + b_Hasanta + '?)' + r_kkh + ')|(' + r_ngk + '(' + b_Hasanta + '?)' + r_kh + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_kh + ')|(' + r_ng + '(' + b_Hasanta + '?)' + r_kk + '(' + b_Hasanta + '?)' + r_h + ')|(' + r_n + '(' + b_Hasanta + '?)' + r_g + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_k + '(' + b_Hasanta + '?)' + r_h + '))';
End;

End.

