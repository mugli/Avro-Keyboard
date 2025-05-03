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

Unit Phonetic_RegExp_Constants_Spell;

Interface

Uses
  BanglaChars;

Var
  r_A, r_B, r_C, r_D, r_E, r_F, r_G, r_H, r_I, r_J, r_K, r_L, r_M, r_N, r_O,
    r_OFirst, r_P, r_Q, r_R, r_RFirst, r_S, r_T, r_U, r_V, r_W, r_X, r_Y,
    r_Z: String;

  r_AI, r_AU, r_AA, r_AZ, r_BH, r_BB, r_BD, r_BV, r_CH, r_CK, r_CC, r_CN, r_DB,
    r_DD, r_DG, r_DH, r_EY, r_EE, r_FF, r_GH, r_GG, r_HL, r_HH, r_HM, r_HN,
    r_IA, r_JJ, r_JH, r_KH, r_KK, r_KS, r_KX, r_LL, r_LK, r_LG, r_LP, r_LD,
    r_LB, r_MM, r_MB, r_MP, r_MT, r_NC, r_NN, r_NG, r_NK, r_NJ, r_ND, r_NT,
    r_OO, r_OI, r_OU, r_PH, r_PP, r_QQ, r_RI, r_RH, r_SS, r_SH, r_TT, r_TH,
    r_UU, r_VV, r_XM, r_XN, r_ZH, r_ZZ: String;

  r_BBH, r_BDH, r_BHL, r_CCH, r_CHH, r_CNG, r_DHM, r_DHN, r_DBH, r_DDH, r_DGH,
    r_GDH, r_GGH, r_GHN, r_JNG, r_JJH, r_KSH, r_KKH, r_KXM, r_KXN, r_LKH, r_LGH,
    r_LPH, r_LDH, r_LBH, r_MBH, r_MPH, r_MTH, r_NSH, r_NDH, r_NKH, r_NTH, r_NGJ,
    r_NGM, r_NGG, r_NGX, r_NGK, r_NGH, r_NCH, r_NJH, r_NGC, r_PHL, r_RRI, r_SSH,
    r_SHM, r_SHN, r_T_Acnt_Acnt, r_TTH, r_ZZH: String;

  r_KSHM, r_KKHM, r_KSHN, r_KKHN, r_NGKH, r_NGCH, r_NGGH, r_NGKX, r_NGJH,
    r_SHSH, r_THTH: String;

  r_CHCHH, r_NGKSH, r_NGKKH: String;

  r_InjectFola, r_InjectHasanta, r_InjectChandraBisharga, r_InjectReph,
    r_InjectedVowel: String;

Procedure Initialize_RVals;

Implementation

Procedure Initialize_RVals;
Begin

  r_InjectFola := '(' + b_Hasanta + '[' + b_Z + b_B + b_M + '])?';
  r_InjectHasanta := '(' + b_Hasanta + '?)';
  r_InjectChandraBisharga := '([' + b_Bisharga + b_Chandra + ']?)';
  r_InjectReph := '((' + b_R + b_Hasanta + ')?)';
  r_InjectedVowel := '((' + b_OKar + ')?)';
  // r_InjectedVowel :='';// '(([' + b_A + b_AA + b_I + b_II + b_U + b_UU + b_RRI + b_E + b_OI + b_O + b_OU + b_OUkar + b_Okar + b_OIkar + b_Ekar + b_RRIkar + b_UUkar + b_Ukar + b_IIkar + b_Ikar + b_AAkar + '])?)';

  { Single characters }
  r_A := r_InjectReph + '(([' + b_A + b_E + ']' + b_Hasanta + b_Z + b_AAkar +
    '?)|([' + b_AA + b_E + b_A + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z
    + ')?' + b_AAkar + '?)|(' + b_Y + b_AAkar + '))';
  r_B := r_InjectReph + '(' + b_B + ')';
  r_C := r_InjectReph + '([' + b_C + b_CH + '])';
  r_D := r_InjectReph + '([' + b_D + b_Dd + b_Dh + b_Ddh + '])';
  r_E := r_InjectReph + '((' + b_E + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_E +
    b_Ekar + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')' + b_AAkar +
    '?)|(' + b_Y + b_Ekar + '))';
  r_F := r_InjectReph + '(' + b_Ph + ')';
  r_G := r_InjectReph + '(' + b_G + '|(' + b_J + b_Hasanta + b_NYA + '))';
  r_H := r_InjectReph + '(' + b_H + '|' + b_Th + '|' + b_Bisharga + '|(' + b_H +
    b_Hasanta + ZWNJ + '?))';
  r_I := r_InjectReph + '(([' + b_I + b_II + b_Ikar + b_IIkar + '])|(' + b_Y +
    '[' + b_Ikar + b_IIkar + ']))';
  r_J := r_InjectReph + '(([' + b_J + b_Z + b_JH + '])|(' + b_J +
    b_Nukta + '))';
  r_K := r_InjectReph + '(' + b_K + ')';
  r_L := r_InjectReph + '(' + b_L + ')';
  r_M := r_InjectReph + '(' + b_M + ')';
  r_N := r_InjectReph + '([' + b_N + b_Nn + b_Chandra + b_NGA + b_NYA +
    b_Anushar + '])';
  r_O := r_InjectReph + '(([' + b_O + b_OKar + b_A + '])|(' + b_A + b_Hasanta +
    b_Z + ')|(' + b_Y + b_OKar + '?))?';
  r_OFirst := '(([' + b_O + b_OKar + b_A + '])|(' + b_A + b_Hasanta + b_Z +
    ')|(' + b_Y + b_OKar + '?))';
  r_P := r_InjectReph + '(' + b_P + ')';
  r_Q := r_InjectReph + '(' + b_K + ')';
  r_R := '((([' + b_R + b_Rr + b_Rrh + '])|(' + b_H + b_Hasanta + b_R + '))?)';
  r_RFirst := '((([' + b_R + b_Rr + b_Rrh + '])|(' + b_H + b_Hasanta +
    b_R + '))?)';
  r_S := r_InjectReph + '([' + b_S + b_Sh + b_Ss + '])';
  r_T := r_InjectReph + '([' + b_T + b_Tt + b_Khandatta + b_Th + b_Tth + '])';
  r_U := r_InjectReph + '(([' + b_U + b_UU + b_Ukar + b_UUkar + '])|(' + b_Y +
    '[' + b_Ukar + b_UUkar + ']))';
  r_V := r_InjectReph + '(' + b_Bh + ')';
  r_W := r_InjectReph + '(' + b_O + '|(' + b_O + b_Y + ')|(' + b_Hasanta +
    b_B + '))';
  r_X := r_InjectReph + '((' + b_K + b_Hasanta + b_S + ')|' + b_Ss + ')';
  r_Y := r_InjectReph + '(' + b_Y + '|(' + b_I + b_Y + ')|([' + ZWJ + ZWNJ +
    ']?' + b_Hasanta + b_Z + '))';
  r_Z := r_InjectReph + '(' + b_J + '|' + b_Z + '|(' + b_J + b_Nukta + ')|([' +
    ZWJ + ZWNJ + ']?' + b_Hasanta + b_Z + '))';

  { Two character combinations }
  // A
  r_AI := r_InjectReph + '(' + b_OI + '|' + b_OIkar + '|' + r_A + r_I + ')';
  r_AU := r_InjectReph + '(' + b_OU + '|' + b_OUkar + r_A + r_U + ')';
  r_AZ := r_InjectReph + '(' + r_A + '(' + r_Z + ')?)';
  r_AA := r_InjectReph + '((' + b_AA + ')|(' + b_Y + b_AAkar + ')|(' + b_AAkar +
    ')|(' + r_A + '(' + r_A + ')?))';
  // B
  r_BH := r_InjectReph + '((' + b_Bh + ')|(' + r_B + '(' + b_Hasanta + '?)' +
    r_H + '))';
  r_BB := r_InjectReph + '(' + r_B + '(' + b_Hasanta + '?)(' + r_B + ')?)';
  r_BV := r_InjectReph + '((' + r_B + ')?(' + b_Hasanta + '?)' + r_V + ')';
  r_BD := r_InjectReph + '(' + r_B + '(' + b_Hasanta + '?)' + r_D + ')';
  // C
  r_CH := r_InjectReph + '((' + b_C + ')|(' + b_CH + ')|(' + r_C + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_CK := r_InjectReph + '((' + b_K + ')|(' + r_C + '(' + b_Hasanta + '?)' +
    r_K + '))';
  r_CC := r_InjectReph + '(' + r_C + '(' + b_Hasanta + '?)(' + r_C + ')?)';
  r_CN := r_InjectReph + '(' + r_C + '(' + b_Hasanta + '?)' + r_N + ')';
  // D
  r_DB := r_InjectReph + '(' + r_D + '(' + b_Hasanta + '?)' + r_B + ')';
  r_DD := r_InjectReph + '(' + r_D + '(' + b_Hasanta + '?)(' + r_D + ')?)';
  r_DG := r_InjectReph + '(' + r_D + '(' + b_Hasanta + '?)' + r_G + ')';
  r_DH := r_InjectReph + '((' + b_Dh + ')|(' + b_Ddh + ')|(' + r_D + '(' +
    b_Hasanta + '?)' + r_H + '))';
  // E
  r_EY := r_InjectReph + '((' + b_E + ')|(' + b_I + ')|(' + b_Ekar + ')|(' +
    b_Ekar + b_I + ')|(' + b_E + b_I + ')|(' + b_II + ')|(' + b_IIkar + ')|(' +
    r_E + r_Y + '))';
  r_EE := r_InjectReph + '((' + b_I + ')|(' + b_II + ')|(' + b_Ikar + ')|(' +
    b_IIkar + ')|(' + b_Y + b_Ekar + b_I + ')|(' + r_E + r_E + '))';
  // F
  r_FF := r_InjectReph + '(' + r_F + '(' + b_Hasanta + '?)(' + r_F + ')?)';
  // G
  r_GH := r_InjectReph + '((' + b_GH + ')|(' + r_G + '(' + b_Hasanta + '?)' +
    r_H + '))';
  r_GG := r_InjectReph + '((' + b_J + b_Hasanta + b_NYA + ')|(' + r_G + '(' +
    b_Hasanta + '?)(' + r_G + ')?))';
  // H
  r_HL := r_InjectReph + '(' + r_H + '(' + b_Hasanta + '?)' + r_L + ')';
  r_HH := r_InjectReph + '(' + r_H + '(' + b_Hasanta + '?)' + r_H + ')';
  r_HM := r_InjectReph + '(' + r_H + '(' + b_Hasanta + '?)' + r_M + ')';
  r_HN := r_InjectReph + '(' + r_H + '(' + b_Hasanta + '?)' + r_N + ')';
  // I
  r_IA := r_InjectReph + '((' + b_NYA + b_AAkar + ')|(' + r_I + r_A + '))';
  // J
  r_JJ := r_InjectReph + '((' + b_H + b_Hasanta + b_Z + ')|(' + r_J + '(' +
    b_Hasanta + '?)(' + r_J + ')?))';
  r_JH := r_InjectReph + '((' + b_JH + ')|(' + r_J + '(' + b_Hasanta + '?)' +
    r_H + '))';
  // K
  r_KH := r_InjectReph + '((' + b_KH + ')|(' + b_K + b_Hasanta + b_Ss + ')|(' +
    r_K + '(' + b_Hasanta + '?)' + r_H + '))';
  r_KK := r_InjectReph + '(' + r_K + '(' + b_Hasanta + '?)(' + r_K + ')?)';
  r_KS := r_InjectReph + '(' + r_K + '(' + b_Hasanta + '?)' + r_S + ')';
  r_KX := r_InjectReph + '((' + b_K + b_Hasanta + b_Ss + ')|(' + r_K + '(' +
    b_Hasanta + '?)' + r_X + '))';
  // L
  r_LL := r_InjectReph + '((' + b_H + b_Hasanta + b_L + ')|((' + r_L + ')?(' +
    b_Hasanta + '?)' + r_L + ')|(' + r_L + '(' + b_Hasanta + '?)' + r_L + '))';
  r_LK := r_InjectReph + '(' + r_L + '(' + b_Hasanta + '?)' + r_K + ')';
  r_LG := r_InjectReph + '(' + r_L + '(' + b_Hasanta + '?)' + r_G + ')';
  r_LP := r_InjectReph + '(' + r_L + '(' + b_Hasanta + '?)' + r_P + ')';
  r_LD := r_InjectReph + '(' + r_L + '(' + b_Hasanta + '?)' + r_D + ')';
  r_LB := r_InjectReph + '(' + r_L + '(' + b_Hasanta + '?)' + r_B + ')';
  // M
  r_MM := r_InjectReph + '((' + b_H + b_Hasanta + b_M + ')|(' + r_M + '(' +
    b_Hasanta + '?)(' + r_M + ')?))';
  r_MB := r_InjectReph + '(' + r_M + '(' + b_Hasanta + '?)' + r_B + ')';
  r_MP := r_InjectReph + '(' + r_M + '(' + b_Hasanta + '?)' + r_P + ')';
  r_MT := r_InjectReph + '(' + r_M + '(' + b_Hasanta + '?)' + r_T + ')';
  // N
  r_NC := r_InjectReph + '((' + b_NYA + b_Hasanta + b_C + ')|(' + r_N + '(' +
    b_Hasanta + '?)' + r_C + '))';
  r_NN := r_InjectReph + '((' + b_H + b_Hasanta + b_Nn + ')|(' + b_H + b_Hasanta
    + b_N + ')|(' + r_N + '(' + b_Hasanta + '?)(' + r_N + ')?))';
  r_NG := r_InjectReph + '((' + b_NGA + ')|(' + b_Anushar + ')|(' + b_NYA +
    ')|(' + b_NGA + b_Hasanta + b_G + ')|(' + r_N + '(' + b_Hasanta + '?)' +
    r_G + '))';
  r_NK := r_InjectReph + '((' + b_NGA + b_Hasanta + b_K + ')|(' + r_N + '(' +
    b_Hasanta + '?)' + r_K + '))';
  r_NJ := r_InjectReph + '((' + b_NYA + b_Hasanta + b_J + ')|(' + r_N + '(' +
    b_Hasanta + '?)' + r_J + '))';
  r_ND := r_InjectReph + '(' + r_N + '(' + b_Hasanta + '?)' + r_D + ')';
  r_NT := r_InjectReph + '(' + r_N + '(' + b_Hasanta + '?)' + r_T + ')';
  // O
  r_OO := r_InjectReph + '((' + r_U + ')|(' + r_O + r_O + '))';
  r_OI := r_InjectReph + '((' + b_OI + ')|(' + b_OIkar + ')|(' + r_O +
    r_I + '))';
  r_OU := r_InjectReph + '((' + b_OU + ')|(' + b_OUkar + ')|(' + r_O +
    r_U + '))';
  // P
  r_PH := r_InjectReph + '((' + b_Ph + ')|(' + r_P + '(' + b_Hasanta + '?)' +
    r_H + '))';
  r_PP := r_InjectReph + '(' + r_P + '(' + b_Hasanta + '?)(' + r_P + ')?)';
  // Q
  r_QQ := r_InjectReph + '(' + r_Q + '(' + b_Hasanta + '?)(' + r_Q + ')?)';
  // R
  r_RI := r_InjectReph + '((' + b_RRI + ')|(' + b_RRIkar + ')|(' + b_H +
    b_RRIkar + ')|(' + r_R + r_I + '))';
  r_RH := r_InjectReph + '((' + r_R + ')|(' + r_R + '(' + b_Hasanta + '?)' +
    r_H + '))';
  // S
  r_SS := r_InjectReph + '(' + r_S + '(' + b_Hasanta + '?)(' + r_S + ')?)';
  r_SH := r_InjectReph + '((' + b_S + ')|(' + b_Sh + ')|(' + b_Ss + ')|(' + r_S
    + '(' + b_Hasanta + '?)' + r_H + '))';
  // T
  r_TT := r_InjectReph + '(' + r_T + '(' + b_Hasanta + '?)(' + r_T + ')?)';
  r_TH := r_InjectReph + '((' + b_Th + ')|(' + b_Tth + ')|(' + r_T + '(' +
    b_Hasanta + '?)' + r_H + '))';
  // U
  r_UU := r_InjectReph + '((' + b_UU + ')|(' + b_UUkar + ')|(' + r_U + '(' +
    r_U + ')?))';
  // V
  r_VV := r_InjectReph + '(' + r_V + '(' + b_Hasanta + '?)(' + r_V + ')?)';
  // W
  // X
  r_XM := r_InjectReph + '(' + r_X + '(' + b_Hasanta + '?)' + r_M + ')';
  r_XN := r_InjectReph + '(' + r_X + '(' + b_Hasanta + '?)' + r_N + ')';
  // Y
  // Z
  r_ZH := r_InjectReph + '((' + b_JH + ')|(' + r_J + '(' + b_Hasanta + '?)' +
    r_H + '))';
  r_ZZ := r_InjectReph + '((' + b_H + b_Hasanta + b_Z + ')|(' + r_Z + '(' +
    b_Hasanta + '?)(' + r_Z + ')?))';

  { Three character combinations }
  // A
  // B
  r_BBH := r_InjectReph + '(((' + r_B + ')?(' + b_Hasanta + '?)' + r_BH + ')|('
    + r_BB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_B + '(' + b_Hasanta + '?)'
    + r_B + '(' + b_Hasanta + '?)' + r_H + '))';
  r_BDH := r_InjectReph + '((' + r_B + '(' + b_Hasanta + '?)' + r_DH + ')|(' +
    r_BD + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_B + '(' + b_Hasanta + '?)' +
    r_D + '(' + b_Hasanta + '?)' + r_H + '))';
  r_BHL := r_InjectReph + '((' + r_BH + '(' + b_Hasanta + '?)' + r_L + ')|(' +
    r_B + '(' + b_Hasanta + '?)' + r_HL + ')|(' + r_B + '(' + b_Hasanta + '?)' +
    r_H + '(' + b_Hasanta + '?)' + r_L + '))';
  // C
  r_CCH := r_InjectReph + '((' + r_C + '(' + b_Hasanta + '?)' + r_CH + ')|(' +
    r_C + '(' + b_Hasanta + '?)' + r_C + '(' + b_Hasanta + '?)' + r_H + '))';
  r_CHH := r_InjectReph + '((' + r_CH + '(' + b_Hasanta + '?)' + '(' + r_H +
    ')?' + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_HH + ')|(' + r_C + '(' +
    b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_H + '))';
  r_CNG := r_InjectReph + '((' + b_C + b_Hasanta + b_NYA + ')|(' + r_C + '(' +
    b_Hasanta + '?)' + r_NG + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_N + '(' +
    b_Hasanta + '?)' + r_G + ')|(' + r_CN + '(' + b_Hasanta + '?)' + r_G + '))';
  // D
  r_DHM := r_InjectReph + '((' + r_DH + '(' + b_Hasanta + '?)' + r_M + ')|(' +
    r_D + '(' + b_Hasanta + '?)' + r_HM + ')|(' + r_D + '(' + b_Hasanta + '?)' +
    r_H + '(' + b_Hasanta + '?)' + r_M + '))';
  r_DHN := r_InjectReph + '((' + r_DH + '(' + b_Hasanta + '?)' + r_N + ')|(' +
    r_D + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_D + '(' + b_Hasanta + '?)' +
    r_H + '(' + b_Hasanta + '?)' + r_N + '))';
  r_DBH := r_InjectReph + '((' + r_D + '(' + b_Hasanta + '?)' + r_BH + ')|(' +
    r_DB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_D + '(' + b_Hasanta + '?)' +
    r_B + '(' + b_Hasanta + '?)' + r_H + '))';
  r_DDH := r_InjectReph + '(((' + r_D + ')?(' + b_Hasanta + '?)' + r_DH + ')|('
    + r_DD + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_D + '(' + b_Hasanta + '?)'
    + r_D + '(' + b_Hasanta + '?)' + r_H + '))';
  r_DGH := r_InjectReph + '((' + r_D + '(' + b_Hasanta + '?)' + r_GH + ')|(' +
    r_DG + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_D + '(' + b_Hasanta + '?)' +
    r_G + '(' + b_Hasanta + '?)' + r_H + '))';
  // E
  // F
  // G
  r_GDH := r_InjectReph + '((' + r_G + '(' + b_Hasanta + '?)' + r_DH + ')|(' +
    r_G + '(' + b_Hasanta + '?)' + r_D + '(' + b_Hasanta + '?)' + r_H + '))';
  r_GGH := r_InjectReph + '((' + r_GG + '(' + b_Hasanta + '?)' + r_H + ')|(' +
    r_G + '(' + b_Hasanta + '?)' + r_GH + ')|(' + r_G + '(' + b_Hasanta + '?)' +
    r_G + '(' + b_Hasanta + '?)' + r_H + '))';
  r_GHN := r_InjectReph + '((' + r_GH + '(' + b_Hasanta + '?)' + r_N + ')|(' +
    r_G + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_G + '(' + b_Hasanta + '?)' +
    r_H + '(' + b_Hasanta + '?)' + r_N + '))';
  // H
  // I
  // J
  r_JNG := r_InjectReph + '((' + b_J + b_Hasanta + b_NYA + ')|(' + r_J + '(' +
    b_Hasanta + '?)' + r_NG + ')|(' + r_J + '(' + b_Hasanta + '?)' + r_N + '(' +
    b_Hasanta + '?)' + r_G + '))';
  r_JJH := r_InjectReph + '(((' + r_J + ')?(' + b_Hasanta + '?)' + r_JH + ')|('
    + b_H + b_Hasanta + b_Z + ')|(' + r_JJ + '(' + b_Hasanta + '?)' + r_H +
    ')|(' + r_J + '(' + b_Hasanta + '?)' + r_J + '(' + b_Hasanta + '?)' +
    r_H + '))';
  // K
  r_KSH := r_InjectReph + '((' + r_K + '(' + b_Hasanta + '?)' + r_SH + ')|(' +
    r_KS + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_K + '(' + b_Hasanta + '?)' +
    r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  r_KKH := r_InjectReph + '((' + b_K + b_Hasanta + b_Ss + ')|(' + r_KK + '(' +
    b_Hasanta + '?)' + r_H + ')|((' + r_K + ')?(' + b_Hasanta + '?)' + r_KH +
    ')|(' + r_K + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' +
    r_H + '))';
  r_KXM := r_InjectReph + '((' + r_KX + '(' + b_Hasanta + '?)' + r_M + ')|(' +
    r_K + '(' + b_Hasanta + '?)' + r_XM + ')|(' + r_K + '(' + b_Hasanta + '?)' +
    r_X + '(' + b_Hasanta + '?)' + r_M + '))';
  r_KXN := r_InjectReph + '((' + r_KX + '(' + b_Hasanta + '?)' + r_N + ')|(' +
    r_K + '(' + b_Hasanta + '?)' + r_XN + ')|(' + r_K + '(' + b_Hasanta + '?)' +
    r_X + '(' + b_Hasanta + '?)' + r_N + '))';
  // L
  r_LKH := r_InjectReph + '((' + r_L + '(' + b_Hasanta + '?)' + r_KH + ')|(' +
    r_LK + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' +
    r_K + '(' + b_Hasanta + '?)' + r_H + '))';
  r_LGH := r_InjectReph + '((' + r_L + '(' + b_Hasanta + '?)' + r_GH + ')|(' +
    r_LG + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' +
    r_G + '(' + b_Hasanta + '?)' + r_H + '))';
  r_LPH := r_InjectReph + '((' + r_L + '(' + b_Hasanta + '?)' + r_PH + ')|(' +
    r_LP + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' +
    r_P + '(' + b_Hasanta + '?)' + r_H + '))';
  r_LDH := r_InjectReph + '((' + r_L + '(' + b_Hasanta + '?)' + r_DH + ')|(' +
    r_LD + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' +
    r_D + '(' + b_Hasanta + '?)' + r_H + '))';
  r_LBH := r_InjectReph + '((' + r_L + '(' + b_Hasanta + '?)' + r_BH + ')|(' +
    r_LB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' +
    r_B + '(' + b_Hasanta + '?)' + r_H + '))';
  // M
  r_MBH := r_InjectReph + '((' + r_M + '(' + b_Hasanta + '?)' + r_BH + ')|(' +
    r_MB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_M + '(' + b_Hasanta + '?)' +
    r_B + '(' + b_Hasanta + '?)' + r_H + '))';
  r_MPH := r_InjectReph + '((' + r_M + '(' + b_Hasanta + '?)' + r_PH + ')|(' +
    r_MP + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_M + '(' + b_Hasanta + '?)' +
    r_P + '(' + b_Hasanta + '?)' + r_H + '))';
  r_MTH := r_InjectReph + '((' + r_M + '(' + b_Hasanta + '?)' + r_TH + ')|(' +
    r_MT + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_M + '(' + b_Hasanta + '?)' +
    r_T + '(' + b_Hasanta + '?)' + r_H + '))';
  // N
  r_NSH := r_InjectReph + '((' + r_N + '(' + b_Hasanta + '?)' + r_SH + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NDH := r_InjectReph + '((' + r_N + '(' + b_Hasanta + '?)' + r_DH + ')|(' +
    r_ND + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' +
    r_D + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NKH := r_InjectReph + '((' + r_N + '(' + b_Hasanta + '?)' + r_KH + ')|(' +
    r_NK + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' +
    r_K + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NTH := r_InjectReph + '((' + r_N + '(' + b_Hasanta + '?)' + r_TH + ')|(' +
    r_NT + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' +
    r_T + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGJ := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_J + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_J + '))';
  r_NGM := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_M + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_M + '))';
  r_NGG := r_InjectReph + '((' + b_NGA + b_Hasanta + b_G + ')|(' + r_NG + '(' +
    b_Hasanta + '?)' + r_G + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_G + '))';
  r_NGX := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_X + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_X + '))';
  r_NGK := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_K + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_K + '))';
  r_NGH := r_InjectReph + '((' + b_NGA + b_Hasanta + b_GH + ')|(' + r_N + '(' +
    b_Hasanta + '?)' + r_GH + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_NCH := r_InjectReph + '((' + r_N + '(' + b_Hasanta + '?)' + r_CH + ')|(' +
    r_NC + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' +
    r_C + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NJH := r_InjectReph + '((' + r_N + '(' + b_Hasanta + '?)' + r_JH + ')|(' +
    r_NJ + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' +
    r_J + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGC := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_C + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_C + '))';
  // O
  // P
  r_PHL := r_InjectReph + '((' + r_PH + '(' + b_Hasanta + '?)' + r_L + ')|(' +
    r_P + '(' + b_Hasanta + '?)' + r_HL + ')|(' + r_P + '(' + b_Hasanta + '?)' +
    r_H + '(' + b_Hasanta + '?)' + r_L + '))';
  // Q
  // R
  r_RRI := r_InjectReph + '((' + b_RRI + ')|(' + b_RRIkar + ')|(' + r_R + r_R +
    r_I + '))';
  // S
  r_SSH := r_InjectReph + '(((' + r_S + ')?(' + b_Hasanta + '?)' + r_SH + ')|('
    + r_S + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  r_SHM := r_InjectReph + '((' + r_SH + '(' + b_Hasanta + '?)' + r_M + ')|(' +
    r_S + '(' + b_Hasanta + '?)' + r_HM + ')|(' + r_S + '(' + b_Hasanta + '?)' +
    r_H + '(' + b_Hasanta + '?)' + r_M + '))';
  r_SHN := r_InjectReph + '((' + r_SH + '(' + b_Hasanta + '?)' + r_N + ')|(' +
    r_S + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_S + '(' + b_Hasanta + '?)' +
    r_H + '(' + b_Hasanta + '?)' + r_N + '))';
  // T
  r_T_Acnt_Acnt := r_InjectReph + '(' + b_Khandatta + ')';
  r_TTH := r_InjectReph + '(((' + r_T + ')?(' + b_Hasanta + '?)' + r_TH + ')|('
    + r_TT + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_T + '(' + b_Hasanta + '?)'
    + r_T + '(' + b_Hasanta + '?)' + r_H + '))';
  // U
  // V
  // W
  // X
  // Y
  // Z
  r_ZZH := r_InjectReph + '((' + b_H + b_Hasanta + b_Z + ')|(' + r_Z + '(' +
    b_Hasanta + '?)' + r_ZH + ')|(' + r_ZZ + '(' + b_Hasanta + '?)' + r_H +
    ')|(' + r_Z + '(' + b_Hasanta + '?)' + r_Z + '(' + b_Hasanta + '?)' +
    r_H + '))';

  { Four character combinations }
  // A
  // B
  // C
  // D
  // E
  // F
  // G
  // H
  // I
  // J
  // K
  r_KSHM := r_InjectReph + '((' + r_KSH + '(' + b_Hasanta + '?)' + r_M + ')|(' +
    r_K + '(' + b_Hasanta + '?)' + r_SHM + ')|(' + r_KS + '(' + b_Hasanta + '?)'
    + r_HM + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_SH + '(' + b_Hasanta +
    '?)' + r_M + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta +
    '?)' + r_H + '(' + b_Hasanta + '?)' + r_M + '))';
  r_KKHM := r_InjectReph + '((' + r_KKH + '(' + b_Hasanta + '?)' + r_M + ')|(' +
    r_KK + '(' + b_Hasanta + '?)' + r_HM + ')|(' + r_K + '(' + b_Hasanta + '?)'
    + r_K + '(' + b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_M + ')|('
    + r_K + '(' + b_Hasanta + '?)' + r_KH + '(' + b_Hasanta + '?)' + r_M + '))';
  r_KSHN := r_InjectReph + '((' + r_KSH + '(' + b_Hasanta + '?)' + r_N + ')|(' +
    r_K + '(' + b_Hasanta + '?)' + r_SHN + ')|(' + r_KS + '(' + b_Hasanta + '?)'
    + r_HN + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_SH + '(' + b_Hasanta +
    '?)' + r_N + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta +
    '?)' + r_H + '(' + b_Hasanta + '?)' + r_N + '))';
  r_KKHN := r_InjectReph + '((' + r_KKH + '(' + b_Hasanta + '?)' + r_N + ')|(' +
    r_KK + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_K + '(' + b_Hasanta + '?)'
    + r_K + '(' + b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_N + ')|('
    + r_K + '(' + b_Hasanta + '?)' + r_KH + '(' + b_Hasanta + '?)' + r_N + '))';
  // L
  // M
  // N
  r_NGCH := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_CH + ')|(' +
    r_NGC + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)'
    + r_G + '(' + b_Hasanta + '?)' + r_C + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGGH := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_GH + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_GG + '(' + b_Hasanta + '?)' + r_H + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_GGH + ')|(' + r_N + '(' + b_Hasanta + '?)'
    + r_G + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_H + ')|('
    + r_NG + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_H + ')|('
    + r_NGG + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGKH := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_KH + ')|(' +
    r_NG + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_H + ')|(' +
    r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_K + '(' +
    b_Hasanta + '?)' + r_H + ')|(' + r_NGK + '(' + b_Hasanta + '?)' +
    r_H + '))';
  r_NGKX := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_KX + ')|(' +
    r_NGK + '(' + b_Hasanta + '?)' + r_X + ')|(' + r_N + '(' + b_Hasanta + '?)'
    + r_G + '(' + b_Hasanta + '?)' + r_KX + ')|(' + r_N + '(' + b_Hasanta + '?)'
    + r_G + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_X + '))';
  r_NGJH := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_JH + ')|(' +
    r_NGJ + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)'
    + r_G + '(' + b_Hasanta + '?)' + r_J + '(' + b_Hasanta + '?)' + r_H + '))';
  // O
  // P
  // Q
  // R
  // S
  r_SHSH := r_InjectReph + '(((' + r_SH + ')?(' + b_Hasanta + '?)' + r_SH +
    ')|(' + r_S + '(' + b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_S +
    '(' + b_Hasanta + '?)' + r_H + '))';
  // T
  r_THTH := r_InjectReph + '((' + b_T + b_Hasanta + b_Th + ')|((' + r_TH + ')?('
    + b_Hasanta + '?)' + r_TH + ')|(' + r_T + '(' + b_Hasanta + '?)' + r_H + '('
    + b_Hasanta + '?)' + r_T + '(' + b_Hasanta + '?)' + r_H + '))';
  // U
  // V
  // W
  // X
  // Y
  // Z

  { Five character combinations }
  // C
  r_CHCHH := r_InjectReph + '((' + b_C + b_Hasanta + b_CH + ')|(' + r_CH + '(' +
    b_Hasanta + '?)' + r_CHH + ')|(' + r_CH + '(' + b_Hasanta + '?)' + r_CH +
    '(' + b_Hasanta + '?)' + r_H + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_H +
    '(' + b_Hasanta + '?)' + r_C + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_NGKSH := r_InjectReph + '((' + r_NGK + '(' + b_Hasanta + '?)' + r_SH + ')|('
    + r_NG + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_SH +
    ')|(' + r_NG + '(' + b_Hasanta + '?)' + r_KSH + ')|(' + r_NG + '(' +
    b_Hasanta + '?)' + r_KS + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' +
    b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta +
    '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGKKH := r_InjectReph + '((' + r_NG + '(' + b_Hasanta + '?)' + r_KKH + ')|('
    + r_NGK + '(' + b_Hasanta + '?)' + r_KH + ')|(' + r_NG + '(' + b_Hasanta +
    '?)' + r_K + '(' + b_Hasanta + '?)' + r_KH + ')|(' + r_NG + '(' + b_Hasanta
    + '?)' + r_KK + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta
    + '?)' + r_G + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_K +
    '(' + b_Hasanta + '?)' + r_H + '))';
End;

End.
