{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit Phonetic_RegExp_Constants;

{ .$DEFINE FASTSEARCH_OFF }  // Uncomment to turn OFF fast searching

interface

uses
  BanglaChars;

var
  r_A, r_B, r_C, r_D, r_E, r_F, r_G, r_H, r_I, r_J, r_K, r_L, r_M, r_N, r_O, r_OFirst, r_P, r_Q, r_R, r_S, r_T, r_U, r_V, r_W, r_X, r_Y, r_Z: string;

  r_AI, r_AU, r_AA, r_AZ, r_BH, r_BB, r_BD, r_BV, r_CH, r_CK, r_CC, r_CN, r_DB, r_DD, r_DG, r_DH, r_EY, r_EE, r_FF, r_GH, r_GG, r_HL, r_HH, r_HM, r_HN, r_IA,
    r_JJ, r_JH, r_KH, r_KK, r_KS, r_KX, r_LL, r_LK, r_LG, r_LP, r_LD, r_LB, r_MM, r_MB, r_MP, r_MT, r_NC, r_NN, r_NG, r_NK, r_NJ, r_ND, r_NT, r_OO, r_OI, r_OU,
    r_PH, r_PP, r_QQ, r_RI, r_RH, r_SS, r_SH, r_TT, r_TH, r_UU, r_VV, r_XM, r_XN, r_ZH, r_ZZ: string;

  r_BBH, r_BDH, r_BHL, r_CCH, r_CHH, r_CNG, r_DHM, r_DHN, r_DBH, r_DDH, r_DGH, r_GDH, r_GGH, r_GHN, r_JNG, r_JJH, r_KSH, r_KKH, r_KXM, r_KXN, r_LKH, r_LGH,
    r_LPH, r_LDH, r_LBH, r_MBH, r_MPH, r_MTH, r_NSH, r_NDH, r_NKH, r_NTH, r_NGJ, r_NGM, r_NGG, r_NGX, r_NGK, r_NGH, r_NCH, r_NJH, r_NGC, r_PHL, r_RRI, r_SSH,
    r_SHM, r_SHN, r_T_Acnt_Acnt, r_TTH, r_ZZH: string;

  r_KSHM, r_KKHM, r_KSHN, r_KKHN, r_NGKH, r_NGCH, r_NGGH, r_NGKX, r_NGJH, r_SHSH, r_THTH: string;

  r_CHCHH, r_NGKSH, r_NGKKH: string;

  r_InjectFola, r_InjectHasanta, r_InjectChandraBisharga: string;

procedure Initialize_RVals;

implementation

procedure Initialize_RVals;
begin

  r_InjectFola := '(' + b_Hasanta + '[' + b_Z + b_B + b_M + '])?';
  r_InjectHasanta := '(' + b_Hasanta + '?)';
  r_InjectChandraBisharga := '([' + b_Bisharga + b_Chandra + ']?)';

  { Single characters }
  { FastSearch OFF }
  {$IFDEF FASTSEARCH_OFF}
  r_A := '(([' + b_A + b_E + ']' + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_AA + b_E + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')?' + b_AAkar + ')|(' +
    b_Y + b_AAkar + '))';
  r_B := '(' + b_B + '|(' + b_B + b_Ikar + '))';
  r_C := '(([' + b_C + b_CH + '])|(' + b_S + b_Ikar + '))';
  r_D := '(([' + b_D + b_Dd + '])|(' + b_Dd + b_Ikar + '))';
  r_E := '((' + b_E + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_E + b_Ekar + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')' + b_AAkar + ')|(' + b_Y +
    b_Ekar + '))';
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
  { FastSearch On }
  r_A := '(([' + b_A + b_E + ']' + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_AA + b_E + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')?' + b_AAkar + ')|(' +
    b_Y + b_AAkar + '))';
  r_B := '(' + b_B + ')';
  r_C := '([' + b_C + b_CH + '])';
  r_D := '([' + b_D + b_Dd + '])';
  r_E := '((' + b_E + b_Hasanta + b_Z + b_AAkar + '?)|([' + b_E + b_Ekar + '])|([' + ZWJ + ZWNJ + ']?(' + b_Hasanta + b_Z + ')' + b_AAkar + ')|(' + b_Y +
    b_Ekar + '))';
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
  { Two character combinations }
  // A
  r_AI := '(' + b_OI + '|' + b_OIkar + '|' + r_A + r_I + ')';
  r_AU := '(' + b_OU + '|' + b_OUkar + r_A + r_U + ')';
  r_AZ := '(' + r_A + '(' + r_Z + ')?)';
  r_AA := '((' + b_AA + ')|(' + b_Y + b_AAkar + ')|(' + b_AAkar + ')|(' + r_A + '(' + r_A + ')?))';
  // B
  r_BH := '((' + b_Bh + ')|(' + r_B + '(' + b_Hasanta + '?)' + r_H + '))';
  r_BB := '(' + r_B + '(' + b_Hasanta + '?)(' + r_B + ')?)';
  r_BV := '((' + r_B + ')?(' + b_Hasanta + '?)' + r_V + ')';
  r_BD := '(' + r_B + '(' + b_Hasanta + '?)' + r_D + ')';
  // C
  r_CH := '((' + b_C + ')|(' + b_CH + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_H + '))';
  r_CK := '((' + b_K + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_K + '))';
  r_CC := '(' + r_C + '(' + b_Hasanta + '?)(' + r_C + ')?)';
  r_CN := '(' + r_C + '(' + b_Hasanta + '?)' + r_N + ')';
  // D
  r_DB := '(' + r_D + '(' + b_Hasanta + '?)' + r_B + ')';
  r_DD := '(' + r_D + '(' + b_Hasanta + '?)(' + r_D + ')?)';
  r_DG := '(' + r_D + '(' + b_Hasanta + '?)' + r_G + ')';
  r_DH := '((' + b_Dh + ')|(' + b_Ddh + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_H + '))';
  // E
  r_EY := '((' + b_E + ')|(' + b_I + ')|(' + b_Ekar + ')|(' + b_Ekar + b_I + ')|(' + b_E + b_I + ')|(' + b_II + ')|(' + b_IIkar + ')|(' + r_E + r_Y + '))';
  r_EE := '((' + b_I + ')|(' + b_II + ')|(' + b_Ikar + ')|(' + b_IIkar + ')|(' + b_Y + b_Ekar + b_I + ')|(' + r_E + r_E + '))';
  // F
  r_FF := '(' + r_F + '(' + b_Hasanta + '?)(' + r_F + ')?)';
  // G
  r_GH := '((' + b_GH + ')|(' + r_G + '(' + b_Hasanta + '?)' + r_H + '))';
  r_GG := '((' + b_J + b_Hasanta + b_NYA + ')|(' + r_G + '(' + b_Hasanta + '?)(' + r_G + ')?))';
  // H
  r_HL := '(' + r_H + '(' + b_Hasanta + '?)' + r_L + ')';
  r_HH := '(' + r_H + '(' + b_Hasanta + '?)' + r_H + ')';
  r_HM := '(' + r_H + '(' + b_Hasanta + '?)' + r_M + ')';
  r_HN := '(' + r_H + '(' + b_Hasanta + '?)' + r_N + ')';
  // I
  r_IA := '((' + b_NYA + b_AAkar + ')|(' + r_I + r_A + '))';
  // J
  r_JJ := '((' + b_H + b_Hasanta + b_Z + ')|(' + r_J + '(' + b_Hasanta + '?)(' + r_J + ')?))';
  r_JH := '((' + b_JH + ')|(' + r_J + '(' + b_Hasanta + '?)' + r_H + '))';
  // K
  r_KH := '((' + b_KH + ')|(' + b_K + b_Hasanta + b_Ss + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_H + '))';
  r_KK := '(' + r_K + '(' + b_Hasanta + '?)(' + r_K + ')?)';
  r_KS := '(' + r_K + '(' + b_Hasanta + '?)' + r_S + ')';
  r_KX := '((' + b_K + b_Hasanta + b_Ss + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_X + '))';
  // L
  r_LL := '((' + b_H + b_Hasanta + b_L + ')|((' + r_L + ')?(' + b_Hasanta + '?)' + r_L + ')|(' + r_L + '(' + b_Hasanta + '?)' + r_L + '))';
  r_LK := '(' + r_L + '(' + b_Hasanta + '?)' + r_K + ')';
  r_LG := '(' + r_L + '(' + b_Hasanta + '?)' + r_G + ')';
  r_LP := '(' + r_L + '(' + b_Hasanta + '?)' + r_P + ')';
  r_LD := '(' + r_L + '(' + b_Hasanta + '?)' + r_D + ')';
  r_LB := '(' + r_L + '(' + b_Hasanta + '?)' + r_B + ')';
  // M
  r_MM := '((' + b_H + b_Hasanta + b_M + ')|(' + r_M + '(' + b_Hasanta + '?)(' + r_M + ')?))';
  r_MB := '(' + r_M + '(' + b_Hasanta + '?)' + r_B + ')';
  r_MP := '(' + r_M + '(' + b_Hasanta + '?)' + r_P + ')';
  r_MT := '(' + r_M + '(' + b_Hasanta + '?)' + r_T + ')';
  // N
  r_NC := '((' + b_NYA + b_Hasanta + b_C + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_C + '))';
  r_NN := '((' + b_H + b_Hasanta + b_Nn + ')|(' + b_H + b_Hasanta + b_N + ')|(' + r_N + '(' + b_Hasanta + '?)(' + r_N + ')?))';
  r_NG := '((' + b_NGA + ')|(' + b_Anushar + ')|(' + b_NYA + ')|(' + b_NGA + b_Hasanta + b_G + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '))';
  r_NK := '((' + b_NGA + b_Hasanta + b_K + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_K + '))';
  r_NJ := '((' + b_NYA + b_Hasanta + b_J + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_J + '))';
  r_ND := '(' + r_N + '(' + b_Hasanta + '?)' + r_D + ')';
  r_NT := '(' + r_N + '(' + b_Hasanta + '?)' + r_T + ')';
  // O
  r_OO := '((' + r_U + ')|(' + r_O + r_O + '))';
  r_OI := '((' + b_OI + ')|(' + b_OIkar + ')|(' + r_O + r_I + '))';
  r_OU := '((' + b_OU + ')|(' + b_OUkar + ')|(' + r_O + r_U + '))';
  // P
  r_PH := '((' + b_Ph + ')|(' + r_P + '(' + b_Hasanta + '?)' + r_H + '))';
  r_PP := '(' + r_P + '(' + b_Hasanta + '?)(' + r_P + ')?)';
  // Q
  r_QQ := '(' + r_Q + '(' + b_Hasanta + '?)(' + r_Q + ')?)';
  // R
  r_RI := '((' + b_RRI + ')|(' + b_RRIkar + ')|(' + b_H + b_RRIkar + ')|(' + r_R + r_I + '))';
  r_RH := '((' + r_R + ')|(' + r_R + '(' + b_Hasanta + '?)' + r_H + '))';
  // S
  r_SS := '(' + r_S + '(' + b_Hasanta + '?)(' + r_S + ')?)';
  r_SH := '((' + b_S + ')|(' + b_Sh + ')|(' + b_Ss + ')|(' + r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  // T
  r_TT := '(' + r_T + '(' + b_Hasanta + '?)(' + r_T + ')?)';
  r_TH := '((' + b_Th + ')|(' + b_Tth + ')|(' + r_T + '(' + b_Hasanta + '?)' + r_H + '))';
  // U
  r_UU := '((' + b_UU + ')|(' + b_UUkar + ')|(' + r_U + '(' + r_U + ')?))';
  // V
  r_VV := '(' + r_V + '(' + b_Hasanta + '?)(' + r_V + ')?)';
  // W
  // X
  r_XM := '(' + r_X + '(' + b_Hasanta + '?)' + r_M + ')';
  r_XN := '(' + r_X + '(' + b_Hasanta + '?)' + r_N + ')';
  // Y
  // Z
  r_ZH := '((' + b_JH + ')|(' + r_J + '(' + b_Hasanta + '?)' + r_H + '))';
  r_ZZ := '((' + b_H + b_Hasanta + b_Z + ')|(' + r_Z + '(' + b_Hasanta + '?)(' + r_Z + ')?))';

  { Three character combinations }
  // A
  // B
  r_BBH := '(((' + r_B + ')?(' + b_Hasanta + '?)' + r_BH + ')|(' + r_BB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_B + '(' + b_Hasanta + '?)' + r_B + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_BDH := '((' + r_B + '(' + b_Hasanta + '?)' + r_DH + ')|(' + r_BD + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_B + '(' + b_Hasanta + '?)' + r_D + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_BHL := '((' + r_BH + '(' + b_Hasanta + '?)' + r_L + ')|(' + r_B + '(' + b_Hasanta + '?)' + r_HL + ')|(' + r_B + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_L + '))';
  // C
  r_CCH := '((' + r_C + '(' + b_Hasanta + '?)' + r_CH + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_C + '(' + b_Hasanta + '?)' + r_H + '))';
  r_CHH := '((' + r_CH + '(' + b_Hasanta + '?)' + '(' + r_H + ')?' + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_HH + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_H +
    '(' + b_Hasanta + '?)' + r_H + '))';
  r_CNG := '((' + b_C + b_Hasanta + b_NYA + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_NG + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_N + '(' + b_Hasanta + '?)' +
    r_G + ')|(' + r_CN + '(' + b_Hasanta + '?)' + r_G + '))';
  // D
  r_DHM := '((' + r_DH + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_HM + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_M + '))';
  r_DHN := '((' + r_DH + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_N + '))';
  r_DBH := '((' + r_D + '(' + b_Hasanta + '?)' + r_BH + ')|(' + r_DB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_B + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_DDH := '(((' + r_D + ')?(' + b_Hasanta + '?)' + r_DH + ')|(' + r_DD + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_D + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_DGH := '((' + r_D + '(' + b_Hasanta + '?)' + r_GH + ')|(' + r_DG + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_D + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_H + '))';
  // E
  // F
  // G
  r_GDH := '((' + r_G + '(' + b_Hasanta + '?)' + r_DH + ')|(' + r_G + '(' + b_Hasanta + '?)' + r_D + '(' + b_Hasanta + '?)' + r_H + '))';
  r_GGH := '((' + r_GG + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_G + '(' + b_Hasanta + '?)' + r_GH + ')|(' + r_G + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_GHN := '((' + r_GH + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_G + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_G + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_N + '))';
  // H
  // I
  // J
  r_JNG := '((' + b_J + b_Hasanta + b_NYA + ')|(' + r_J + '(' + b_Hasanta + '?)' + r_NG + ')|(' + r_J + '(' + b_Hasanta + '?)' + r_N + '(' + b_Hasanta + '?)' +
    r_G + '))';
  r_JJH := '(((' + r_J + ')?(' + b_Hasanta + '?)' + r_JH + ')|(' + b_H + b_Hasanta + b_Z + ')|(' + r_JJ + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_J + '(' +
    b_Hasanta + '?)' + r_J + '(' + b_Hasanta + '?)' + r_H + '))';
  // K
  r_KSH := '((' + r_K + '(' + b_Hasanta + '?)' + r_SH + ')|(' + r_KS + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_S + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_KKH := '((' + b_K + b_Hasanta + b_Ss + ')|(' + r_KK + '(' + b_Hasanta + '?)' + r_H + ')|((' + r_K + ')?(' + b_Hasanta + '?)' + r_KH + ')|(' + r_K + '(' +
    b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_H + '))';
  r_KXM := '((' + r_KX + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_XM + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_X + '(' +
    b_Hasanta + '?)' + r_M + '))';
  r_KXN := '((' + r_KX + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_XN + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_X + '(' +
    b_Hasanta + '?)' + r_N + '))';
  // L
  r_LKH := '((' + r_L + '(' + b_Hasanta + '?)' + r_KH + ')|(' + r_LK + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' + r_K + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_LGH := '((' + r_L + '(' + b_Hasanta + '?)' + r_GH + ')|(' + r_LG + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_LPH := '((' + r_L + '(' + b_Hasanta + '?)' + r_PH + ')|(' + r_LP + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' + r_P + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_LDH := '((' + r_L + '(' + b_Hasanta + '?)' + r_DH + ')|(' + r_LD + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' + r_D + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_LBH := '((' + r_L + '(' + b_Hasanta + '?)' + r_BH + ')|(' + r_LB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_L + '(' + b_Hasanta + '?)' + r_B + '(' +
    b_Hasanta + '?)' + r_H + '))';
  // M
  r_MBH := '((' + r_M + '(' + b_Hasanta + '?)' + r_BH + ')|(' + r_MB + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_M + '(' + b_Hasanta + '?)' + r_B + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_MPH := '((' + r_M + '(' + b_Hasanta + '?)' + r_PH + ')|(' + r_MP + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_M + '(' + b_Hasanta + '?)' + r_P + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_MTH := '((' + r_M + '(' + b_Hasanta + '?)' + r_TH + ')|(' + r_MT + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_M + '(' + b_Hasanta + '?)' + r_T + '(' +
    b_Hasanta + '?)' + r_H + '))';
  // N
  r_NSH := '((' + r_N + '(' + b_Hasanta + '?)' + r_SH + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NDH := '((' + r_N + '(' + b_Hasanta + '?)' + r_DH + ')|(' + r_ND + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_D + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_NKH := '((' + r_N + '(' + b_Hasanta + '?)' + r_KH + ')|(' + r_NK + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_K + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_NTH := '((' + r_N + '(' + b_Hasanta + '?)' + r_TH + ')|(' + r_NT + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_T + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_NGJ := '((' + r_NG + '(' + b_Hasanta + '?)' + r_J + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_J + '))';
  r_NGM := '((' + r_NG + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_M + '))';
  r_NGG := '((' + b_NGA + b_Hasanta + b_G + ')|(' + r_NG + '(' + b_Hasanta + '?)' + r_G + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' +
    r_G + '))';
  r_NGX := '((' + r_NG + '(' + b_Hasanta + '?)' + r_X + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_X + '))';
  r_NGK := '((' + r_NG + '(' + b_Hasanta + '?)' + r_K + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_K + '))';
  r_NGH := '((' + b_NGA + b_Hasanta + b_GH + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_GH + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' +
    r_H + '))';
  r_NCH := '((' + r_N + '(' + b_Hasanta + '?)' + r_CH + ')|(' + r_NC + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_C + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_NJH := '((' + r_N + '(' + b_Hasanta + '?)' + r_JH + ')|(' + r_NJ + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_J + '(' +
    b_Hasanta + '?)' + r_H + '))';
  r_NGC := '((' + r_NG + '(' + b_Hasanta + '?)' + r_C + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_C + '))';
  // O
  // P
  r_PHL := '((' + r_PH + '(' + b_Hasanta + '?)' + r_L + ')|(' + r_P + '(' + b_Hasanta + '?)' + r_HL + ')|(' + r_P + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_L + '))';
  // Q
  // R
  r_RRI := '((' + b_RRI + ')|(' + b_RRIkar + ')|(' + r_R + r_R + r_I + '))';
  // S
  r_SSH := '(((' + r_S + ')?(' + b_Hasanta + '?)' + r_SH + ')|(' + r_S + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  r_SHM := '((' + r_SH + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_S + '(' + b_Hasanta + '?)' + r_HM + ')|(' + r_S + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_M + '))';
  r_SHN := '((' + r_SH + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_S + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_S + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_N + '))';
  // T
  r_T_Acnt_Acnt := '(' + b_Khandatta + ')';
  r_TTH := '(((' + r_T + ')?(' + b_Hasanta + '?)' + r_TH + ')|(' + r_TT + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_T + '(' + b_Hasanta + '?)' + r_T + '(' +
    b_Hasanta + '?)' + r_H + '))';
  // U
  // V
  // W
  // X
  // Y
  // Z
  r_ZZH := '((' + b_H + b_Hasanta + b_Z + ')|(' + r_Z + '(' + b_Hasanta + '?)' + r_ZH + ')|(' + r_ZZ + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_Z + '(' +
    b_Hasanta + '?)' + r_Z + '(' + b_Hasanta + '?)' + r_H + '))';

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
  r_KSHM := '((' + r_KSH + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_SHM + ')|(' + r_KS + '(' + b_Hasanta + '?)' + r_HM + ')|(' +
    r_K + '(' + b_Hasanta + '?)' + r_SH + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_M + '))';
  r_KKHM := '((' + r_KKH + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_KK + '(' + b_Hasanta + '?)' + r_HM + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_K + '(' +
    b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_M + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_KH + '(' + b_Hasanta + '?)' + r_M + '))';
  r_KSHN := '((' + r_KSH + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_SHN + ')|(' + r_KS + '(' + b_Hasanta + '?)' + r_HN + ')|(' +
    r_K + '(' + b_Hasanta + '?)' + r_SH + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '(' +
    b_Hasanta + '?)' + r_N + '))';
  r_KKHN := '((' + r_KKH + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_KK + '(' + b_Hasanta + '?)' + r_HN + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_K + '(' +
    b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_N + ')|(' + r_K + '(' + b_Hasanta + '?)' + r_KH + '(' + b_Hasanta + '?)' + r_N + '))';
  // L
  // M
  // N
  r_NGCH := '((' + r_NG + '(' + b_Hasanta + '?)' + r_CH + ')|(' + r_NGC + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_C + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGGH := '((' + r_NG + '(' + b_Hasanta + '?)' + r_GH + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_GG + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' +
    b_Hasanta + '?)' + r_GGH + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_NG + '(' +
    b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_NGG + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGKH := '((' + r_NG + '(' + b_Hasanta + '?)' + r_KH + ')|(' + r_NG + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' +
    b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_NGK + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGKX := '((' + r_NG + '(' + b_Hasanta + '?)' + r_KX + ')|(' + r_NGK + '(' + b_Hasanta + '?)' + r_X + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_KX + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_X + '))';
  r_NGJH := '((' + r_NG + '(' + b_Hasanta + '?)' + r_JH + ')|(' + r_NGJ + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_J + '(' + b_Hasanta + '?)' + r_H + '))';
  // O
  // P
  // Q
  // R
  // S
  r_SHSH := '(((' + r_SH + ')?(' + b_Hasanta + '?)' + r_SH + ')|(' + r_S + '(' + b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)'
    + r_H + '))';
  // T
  r_THTH := '((' + b_T + b_Hasanta + b_Th + ')|((' + r_TH + ')?(' + b_Hasanta + '?)' + r_TH + ')|(' + r_T + '(' + b_Hasanta + '?)' + r_H + '(' + b_Hasanta +
    '?)' + r_T + '(' + b_Hasanta + '?)' + r_H + '))';
  // U
  // V
  // W
  // X
  // Y
  // Z

  { Five character combinations }
  // C
  r_CHCHH := '((' + b_C + b_Hasanta + b_CH + ')|(' + r_CH + '(' + b_Hasanta + '?)' + r_CHH + ')|(' + r_CH + '(' + b_Hasanta + '?)' + r_CH + '(' + b_Hasanta +
    '?)' + r_H + ')|(' + r_C + '(' + b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_C + '(' + b_Hasanta + '?)' + r_H + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGKSH := '((' + r_NGK + '(' + b_Hasanta + '?)' + r_SH + ')|(' + r_NG + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_SH + ')|(' + r_NG + '(' +
    b_Hasanta + '?)' + r_KSH + ')|(' + r_NG + '(' + b_Hasanta + '?)' + r_KS + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_S + '(' + b_Hasanta + '?)' + r_H + '))';
  r_NGKKH := '((' + r_NG + '(' + b_Hasanta + '?)' + r_KKH + ')|(' + r_NGK + '(' + b_Hasanta + '?)' + r_KH + ')|(' + r_NG + '(' + b_Hasanta + '?)' + r_K + '(' +
    b_Hasanta + '?)' + r_KH + ')|(' + r_NG + '(' + b_Hasanta + '?)' + r_KK + '(' + b_Hasanta + '?)' + r_H + ')|(' + r_N + '(' + b_Hasanta + '?)' + r_G + '(' +
    b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_K + '(' + b_Hasanta + '?)' + r_H + '))';
end;

end.
