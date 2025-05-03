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

Unit clsPhoneticRegExBuilder;

Interface

Uses
  classes,
  sysutils,
  RegularExpressions,
  StrUtils;


// Skeleton of Class TEnglishToRegEx
Type
  TEnglishToRegEx = Class
    pEnglishText: String;
    ln: Integer; // Length of English String
    pos: Integer; // Position of processing at English String
    RS: String; // Result String

  Private
    Function MyConvert(): String;
    Function Cnv(Const Compare: String; Const IfTrue: String): Boolean;
    Procedure AddRs(Const T: String);
    Function PrevT: String;
    Function NextT: String;
    Function Vowel(Const T: String): Boolean;
    Function Consonent(Const T: String): Boolean;
    Function Begining: Boolean;
    Procedure A;
    Procedure B;
    Procedure C;
    Procedure D;
    Procedure E;
    Procedure F;
    Procedure G;
    Procedure H;
    Procedure I;
    Procedure J;
    Procedure K;
    Procedure L;
    Procedure M;
    Procedure N;
    Procedure O;
    Procedure P;
    Procedure Q;
    Procedure R;
    Procedure S;
    Procedure T;
    Procedure U;
    Procedure V;
    Procedure W;
    Procedure X;
    Procedure Y;
    Procedure Z;

  Public
    Constructor Create; // Initializer
    Function Convert(Const EnglishT: String): String;
    Function CorrectCase(Const inputT: String): String;
    Function EscapeSpecialCharacters(Const inputT: String): String;
  End;

Implementation

Uses
  Phonetic_RegExp_Constants,
  BanglaChars;

{ TEnglishToRegEx }

Procedure TEnglishToRegEx.A;
Begin
  If Cnv('aa', r_AA) = True Then
    Exit;
  If Cnv('au', r_AU) = True Then
    Exit;
  If Cnv('az', r_AZ) = True Then
    Exit;
  If Cnv('ai', r_AI) = True Then
    Exit;

  If Cnv('a', r_A) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.AddRs(Const T: String);
Begin
  If (Consonent(PrevT) = True) And (Consonent(NextT) = True) Then
    RS := RS + T + r_InjectHasanta
  Else
  Begin
    If NextT <> '' Then
      RS := RS + T + r_InjectFola + r_InjectChandraBisharga
    Else
      RS := RS + T + r_InjectChandraBisharga;
  End;

  pos := pos + 1;
End;

Procedure TEnglishToRegEx.B;
Begin
  If Cnv('bdh', r_BDH) = True Then
    Exit;
  If Cnv('bhl', r_BHL) = True Then
    Exit;

  If Cnv('bh', r_BH) = True Then
    Exit;
  If Cnv('bb', r_BB) = True Then
    Exit;
  If Cnv('bd', r_BD) = True Then
    Exit;
  If Cnv('bv', r_BV) = True Then
    Exit;

  If Cnv('b', r_B) = True Then
    Exit;
End;

Function TEnglishToRegEx.Begining: Boolean;
Var
  T: Char;
  temp: String;
Begin
  temp := PrevT;
  T := #0;
  If length(temp) > 0 Then
    T := temp[1];

  If length(T) > 0 Then
  Begin
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

Procedure TEnglishToRegEx.C;
Begin
  If Cnv('chchh', r_CHCHH) = True Then
    Exit;

  If Cnv('cch', r_CCH) = True Then
    Exit;
  If Cnv('chh', r_CHH) = True Then
    Exit;
  If Cnv('cng', r_CNG) = True Then
    Exit;

  If Cnv('ch', r_CH) = True Then
    Exit;
  If Cnv('ck', r_CK) = True Then
    Exit;
  If Cnv('cc', r_CC) = True Then
    Exit;
  If Cnv('cn', r_CN) = True Then
    Exit;

  If Cnv('c', r_C) = True Then
    Exit;
End;

{$HINTS Off}

Function TEnglishToRegEx.Cnv(Const Compare: String;
  Const IfTrue: String): Boolean;
Var
  I: Integer;
  tmp: String;
  NextCharacterAfterBlock, LastCharacterOfBlock: String;
Begin
  Result := False;
  I := length(Compare);
  tmp := MidStr(pEnglishText, pos, I);

  If Compare = tmp Then
  Begin
    Result := True;
    NextCharacterAfterBlock := MidStr(pEnglishText, pos + I, 1);
    LastCharacterOfBlock := MidStr(pEnglishText, pos + I - 1, 1);

    If (Consonent(LastCharacterOfBlock) = True) And
      (Consonent(NextCharacterAfterBlock) = True) Then
      RS := RS + IfTrue + r_InjectHasanta
    Else
    Begin
      If NextCharacterAfterBlock <> '' Then
        RS := RS + IfTrue + r_InjectFola + r_InjectChandraBisharga
      Else
        RS := RS + IfTrue + r_InjectChandraBisharga;
    End;

    pos := pos + I;
  End
  Else
    Result := False;
End;

{$HINTS On}
{$HINTS Off}

Function TEnglishToRegEx.Consonent(Const T: String): Boolean;
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
    'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's',
      't', 'v', 'w', 'x', 'y', 'z':
      Consonent := True;
  Else
    Consonent := False;
  End;
End;

{$HINTS On}




Function TEnglishToRegEx.Convert(Const EnglishT: String): String;
var

  theRegex: TRegex;
  theMatch: TMatch;
  WideSearchStr: string;
Begin
  If EnglishT = '' Then
    Exit;

  WideSearchStr := ('^([a-zA-Z])\1\1\1.*$');
  theRegex := TRegex.Create(WideSearchStr);
  theMatch := theRegex.Match(EnglishT);
  If theMatch.Success Then
  Begin
    Exit;
  End;

  pEnglishText := EscapeSpecialCharacters(CorrectCase(EnglishT));
  Result := MyConvert;
End;

Function TEnglishToRegEx.CorrectCase(Const inputT: String): String;
Begin
  Result := LowerCase(inputT);
End;

Constructor TEnglishToRegEx.Create;
Begin
  Initialize_RVals;
  ln := 0;
  pos := 0;
End;

Procedure TEnglishToRegEx.D;
Begin
  If Cnv('dhm', r_DHM) = True Then
    Exit;
  If Cnv('dhn', r_DHN) = True Then
    Exit;
  If Cnv('dbh', r_DBH) = True Then
    Exit;
  If Cnv('ddh', r_DDH) = True Then
    Exit;
  If Cnv('dgh', r_DGH) = True Then
    Exit;

  If Cnv('db', r_DB) = True Then
    Exit;
  If Cnv('dd', r_DD) = True Then
    Exit;
  If Cnv('dg', r_DG) = True Then
    Exit;
  If Cnv('dh', r_DH) = True Then
    Exit;

  If Cnv('d', r_D) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.E;
Begin
  If Cnv('ey', r_EY) = True Then
    Exit;
  If Cnv('ee', r_EE) = True Then
    Exit;

  If Cnv('e', r_E) = True Then
    Exit;
End;

{$WARN NO_RETVAL OFF}

Function TEnglishToRegEx.EscapeSpecialCharacters(Const inputT: String): String;
Var
  T: String;
Begin
  (*
    We need to escape the following 14 metacharacters:
    \ | ( ) [ ] { } ^ $ * + ? .
  *)

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

  Result := T;
End;

{$WARN NO_RETVAL On}

Procedure TEnglishToRegEx.F;
Begin
  If Cnv('ff', r_FF) = True Then
    Exit;

  If Cnv('f', r_F) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.G;
Begin
  If Cnv('ggh', r_GGH) = True Then
    Exit;
  If Cnv('gdh', r_GDH) = True Then
    Exit;
  If Cnv('ghn', r_GHN) = True Then
    Exit;

  If Cnv('gh', r_GH) = True Then
    Exit;
  If Cnv('gg', r_GG) = True Then
    Exit;

  If Cnv('g', r_G) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.H;
Begin
  If Cnv('hl', r_HL) = True Then
    Exit;
  If Cnv('hh', r_HH) = True Then
    Exit;
  If Cnv('hm', r_HM) = True Then
    Exit;
  If Cnv('hn', r_HN) = True Then
    Exit;

  If Cnv('h', r_H) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.I;
Begin
  If Cnv('ia', r_IA) = True Then
    Exit;

  If Cnv('i', r_I) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.J;
Begin
  If Cnv('jng', r_JNG) = True Then
    Exit;
  If Cnv('jjh', r_JJH) = True Then
    Exit;

  If Cnv('jj', r_JJ) = True Then
    Exit;
  If Cnv('jh', r_JH) = True Then
    Exit;

  If Cnv('j', r_J) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.K;
Begin
  If Cnv('kshm', r_KSHM) = True Then
    Exit;
  If Cnv('kkhm', r_KKHM) = True Then
    Exit;
  If Cnv('kshn', r_KSHN) = True Then
    Exit;
  If Cnv('kkhn', r_KKHN) = True Then
    Exit;

  If Cnv('ksh', r_KSH) = True Then
    Exit;
  If Cnv('kkh', r_KKH) = True Then
    Exit;
  If Cnv('kxm', r_KXM) = True Then
    Exit;
  If Cnv('kxn', r_KXN) = True Then
    Exit;

  If Cnv('kh', r_KH) = True Then
    Exit;
  If Cnv('kk', r_KK) = True Then
    Exit;
  If Cnv('ks', r_KS) = True Then
    Exit;
  If Cnv('kx', r_KX) = True Then
    Exit;

  If Cnv('k', r_K) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.L;
Begin
  If Cnv('lkh', r_LKH) = True Then
    Exit;
  If Cnv('lgh', r_LGH) = True Then
    Exit;
  If Cnv('lph', r_LPH) = True Then
    Exit;
  If Cnv('ldh', r_LDH) = True Then
    Exit;
  If Cnv('lbh', r_LBH) = True Then
    Exit;

  If Cnv('ll', r_LL) = True Then
    Exit;
  If Cnv('lk', r_LK) = True Then
    Exit;
  If Cnv('lg', r_LG) = True Then
    Exit;
  If Cnv('lp', r_LP) = True Then
    Exit;
  If Cnv('ld', r_LD) = True Then
    Exit;
  If Cnv('lb', r_LB) = True Then
    Exit;

  If Cnv('l', r_L) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.M;
Begin
  If Cnv('mbh', r_MBH) = True Then
    Exit;
  If Cnv('mph', r_MPH) = True Then
    Exit;
  If Cnv('mth', r_MTH) = True Then
    Exit;

  If Cnv('mm', r_MM) = True Then
    Exit;
  If Cnv('mb', r_MB) = True Then
    Exit;
  If Cnv('mp', r_MP) = True Then
    Exit;
  If Cnv('mt', r_MT) = True Then
    Exit;

  If Cnv('m', r_M) = True Then
    Exit;
End;

Function TEnglishToRegEx.MyConvert: String;
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
        AddRs('((' + b_0 + ')|(0)|(' + b_Sh + b_UUkar + b_N + b_Hasanta +
          b_Z + '))');
      '1':
        AddRs('((' + b_1 + ')|(1)|(' + b_E + b_K + '))');
      '2':
        AddRs('((' + b_2 + ')|(2)|(' + b_D + b_Ukar + b_I + '))');
      '3':
        AddRs('((' + b_3 + ')|(3)|(' + b_T + b_Ikar + b_N + '))');
      '4':
        AddRs('((' + b_4 + ')|(4)|(' + b_C + b_AAkar + b_R + '))');
      '5':
        AddRs('((' + b_5 + ')|(5)|(' + b_P + b_AAkar + b_Chandra + b_C + '))');
      '6':
        AddRs('((6)|(' + b_6 + ')|(' + b_CH + b_Y + '))');
      '7':
        AddRs('((' + b_7 + ')|(7)|(' + b_S + b_AAkar + b_T + '))');
      '8':
        AddRs('((' + b_8 + ')|(8)|(' + b_AA + b_Tt + '))');
      '9':
        AddRs('((' + b_9 + ')|(9)|(' + b_N + b_Y + '))');
      // ------------End Number Generation-------------

      'a':
        A();
      'b':
        B();
      'c':
        C();
      'd':
        D();
      'e':
        E();
      'f':
        F();
      'g':
        G();
      'h':
        H();
      'i':
        I();
      'j':
        J();
      'k':
        K();
      'l':
        L();
      'm':
        M();
      'n':
        N();
      'o':
        O();
      'p':
        P();
      'q':
        Q();
      'r':
        R();
      's':
        S();
      't':
        T();
      'u':
        U();
      'v':
        V();
      'w':
        W();
      'x':
        X();
      'y':
        Y();
      'z':
        Z();

      // ` - Make sure it is just above case else!
      '`':
        pos := pos + 1; // No change made here,just to bypass juktakkhar making

    Else
      AddRs(tt);

    End;

  Until pos > ln;

  MyConvert := RS;

End;

Procedure TEnglishToRegEx.N;
Begin
  If Cnv('ngksh', r_NGKSH) = True Then
    Exit;
  If Cnv('ngkkh', r_NGKKH) = True Then
    Exit;

  If Cnv('ngch', r_NGCH) = True Then
    Exit;
  If Cnv('nggh', r_NGGH) = True Then
    Exit;
  If Cnv('ngkx', r_NGKX) = True Then
    Exit;
  If Cnv('ngjh', r_NGJH) = True Then
    Exit;
  If Cnv('ngkh', r_NGKH) = True Then
    Exit;

  If Cnv('nsh', r_NSH) = True Then
    Exit;
  If Cnv('ndh', r_NDH) = True Then
    Exit;
  If Cnv('nkh', r_NKH) = True Then
    Exit;
  If Cnv('nth', r_NTH) = True Then
    Exit;
  If Cnv('ngj', r_NGJ) = True Then
    Exit;
  If Cnv('ngm', r_NGM) = True Then
    Exit;
  If Cnv('ngg', r_NGG) = True Then
    Exit;
  If Cnv('ngx', r_NGX) = True Then
    Exit;
  If Cnv('ngk', r_NGK) = True Then
    Exit;
  If Cnv('ngh', r_NGH) = True Then
    Exit;
  If Cnv('nch', r_NCH) = True Then
    Exit;
  If Cnv('njh', r_NJH) = True Then
    Exit;
  If Cnv('ngc', r_NGC) = True Then
    Exit;

  If Cnv('nc', r_NC) = True Then
    Exit;
  If Cnv('nn', r_NN) = True Then
    Exit;
  If Cnv('ng', r_NG) = True Then
    Exit;
  If Cnv('nk', r_NK) = True Then
    Exit;
  If Cnv('nj', r_NJ) = True Then
    Exit;
  If Cnv('nd', r_ND) = True Then
    Exit;
  If Cnv('nt', r_NT) = True Then
    Exit;

  If Cnv('n', r_N) = True Then
    Exit;
End;

Function TEnglishToRegEx.NextT: String;
Begin
  NextT := MidStr(pEnglishText, pos + 1, 1);
End;

Procedure TEnglishToRegEx.O;
Begin
  If Cnv('oo', r_OO) = True Then
    Exit;
  If Cnv('oi', r_OI) = True Then
    Exit;
  If Cnv('ou', r_OU) = True Then
    Exit;

  If Begining Then
  Begin
    If Cnv('o', r_OFirst) = True Then
      Exit;
  End
  Else
  Begin
    If Cnv('o', r_O) = True Then
      Exit;
  End;

End;

Procedure TEnglishToRegEx.P;
Begin
  If Cnv('phl', r_PHL) = True Then
    Exit;

  If Cnv('ph', r_PH) = True Then
    Exit;
  If Cnv('pp', r_PP) = True Then
    Exit;

  If Cnv('p', r_P) = True Then
    Exit;
End;

Function TEnglishToRegEx.PrevT: String;
Var
  I: Integer;
Begin

  I := pos - 1;
  If I < 1 Then
  Begin
    PrevT := '';
    Exit;
  End;

  PrevT := MidStr(pEnglishText, I, 1);
End;

Procedure TEnglishToRegEx.Q;
Begin
  If Cnv('qq', r_QQ) = True Then
    Exit;

  If Cnv('q', r_Q) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.R;
Begin
  If Cnv('rri', r_RRI) = True Then
    Exit;

  If Cnv('ri', r_RI) = True Then
    Exit;
  If Cnv('rh', r_RH) = True Then
    Exit;

  If Cnv('r', r_R) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.S;
Begin
  If Cnv('shsh', r_SHSH) = True Then
    Exit;

  If Cnv('ssh', r_SSH) = True Then
    Exit;
  If Cnv('shm', r_SHM) = True Then
    Exit;
  If Cnv('shn', r_SHN) = True Then
    Exit;

  If Cnv('ss', r_SS) = True Then
    Exit;
  If Cnv('sh', r_SH) = True Then
    Exit;

  If Cnv('s', r_S) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.T;
Begin
  If Cnv('thth', r_THTH) = True Then
    Exit;

  If Cnv('tth', r_TTH) = True Then
    Exit;
  If Cnv('t``', r_T_Acnt_Acnt) = True Then
    Exit;
  If Cnv('tth', r_TTH) = True Then
    Exit;

  If Cnv('tt', r_TT) = True Then
    Exit;
  If Cnv('th', r_TH) = True Then
    Exit;

  If Cnv('t', r_T) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.U;
Begin
  If Cnv('uu', r_UU) = True Then
    Exit;
  If Cnv('u', r_U) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.V;
Begin
  If Cnv('vv', r_VV) = True Then
    Exit;
  If Cnv('v', r_V) = True Then
    Exit;
End;

{$HINTS Off}

Function TEnglishToRegEx.Vowel(Const T: String): Boolean;
Var
  myT: String;
Begin
  Result := False;
  myT := LowerCase(T);
  If length(myT) > 0 Then
    myT := myT[1];

  If (myT = 'a') Or (myT = 'e') Or (myT = 'i') Or (myT = 'o') Or
    (myT = 'u') Then
    Vowel := True
  Else
    Vowel := False;
End;

{$HINTS On}

Procedure TEnglishToRegEx.W;
Begin
  If Cnv('w', r_W) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.X;
Begin
  If Cnv('xm', r_XM) = True Then
    Exit;
  If Cnv('xn', r_XN) = True Then
    Exit;

  If Cnv('x', r_X) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.Y;
Begin
  If Cnv('y', r_Y) = True Then
    Exit;
End;

Procedure TEnglishToRegEx.Z;
Begin
  If Cnv('zzh', r_ZZH) = True Then
    Exit;

  If Cnv('zh', r_ZH) = True Then
    Exit;
  If Cnv('zz', r_ZZ) = True Then
    Exit;

  If Cnv('z', r_Z) = True Then
    Exit;
End;

End.
