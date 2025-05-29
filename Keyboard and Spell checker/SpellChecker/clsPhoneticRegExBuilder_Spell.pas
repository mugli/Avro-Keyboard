{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit clsPhoneticRegExBuilder_Spell;

interface

uses
  classes,
  sysutils,
  StrUtils;

// Skeleton of Class TEnglishToRegEx
type
  TEnglishToRegEx = class
    pEnglishText: string;
    ln: Integer;  // Length of English String
    pos: Integer; // Position of processing at English String
    RS: string;   // Result String

    private
      function MyConvert(): string;
      function Cnv(const Compare: string; const IfTrue: string): Boolean;
      procedure AddRs(const T: string);
      function PrevT: string;
      function NextT: string;
      function Vowel(const T: string): Boolean;
      function Consonent(const T: string): Boolean;
      function Begining: Boolean;
      procedure A;
      procedure B;
      procedure C;
      procedure D;
      procedure E;
      procedure F;
      procedure G;
      procedure H;
      procedure I;
      procedure J;
      procedure K;
      procedure L;
      procedure M;
      procedure N;
      procedure O;
      procedure P;
      procedure Q;
      procedure R;
      procedure S;
      procedure T;
      procedure U;
      procedure V;
      procedure W;
      procedure X;
      procedure Y;
      procedure Z;

    public
      constructor Create; // Initializer
      function Convert(const EnglishT: string): string;
      function CorrectCase(const inputT: string): string;
      function EscapeSpecialCharacters(const inputT: string): string;
  end;

implementation

uses
  Phonetic_RegExp_Constants_Spell,
  BanglaChars;

{ TEnglishToRegEx }

procedure TEnglishToRegEx.A;
begin
  if Cnv('aa', r_AA) = True then
    Exit;
  if Cnv('au', r_AU) = True then
    Exit;
  if Cnv('az', r_AZ) = True then
    Exit;
  if Cnv('ai', r_AI) = True then
    Exit;

  if Cnv('a', r_A) = True then
    Exit;
end;

procedure TEnglishToRegEx.AddRs(const T: string);
begin
  { If (Consonent(PrevT) = True) And (Consonent(NextT) = True) Then
    Rs := Rs + T + r_InjectHasanta
    Else Begin
    If NextT <> '' Then
    Rs := Rs + T + r_InjectFola + r_InjectChandraBisharga
    Else
    Rs := Rs + T + r_InjectChandraBisharga;
    End; }

  RS := RS + T + r_InjectHasanta + r_InjectFola + r_InjectedVowel + r_InjectChandraBisharga;

  pos := pos + 1;
end;

procedure TEnglishToRegEx.B;
begin
  if Cnv('bdh', r_BDH) = True then
    Exit;
  if Cnv('bhl', r_BHL) = True then
    Exit;

  if Cnv('bh', r_BH) = True then
    Exit;
  if Cnv('bb', r_BB) = True then
    Exit;
  if Cnv('bd', r_BD) = True then
    Exit;
  if Cnv('bv', r_BV) = True then
    Exit;

  if Cnv('b', r_BB) = True then
    Exit;
end;

{$HINTS OFF}

function TEnglishToRegEx.Begining: Boolean;
var
  T:    Char;
  temp: string;
begin
  Result := False;
  temp := PrevT;
  T := #0;
  if length(temp) > 0 then
    T := temp[1];

  if length(T) > 0 then
  begin
    case T of
      '0' .. '9':
        Begining := False;
      'A' .. 'Z':
        Begining := False;
      'a' .. 'z':
        Begining := False;
      else
        Begining := True;
    end;
  end
  else
    Begining := True;
end;
{$HINTS ON}

procedure TEnglishToRegEx.C;
begin
  if Cnv('chchh', r_CHCHH) = True then
    Exit;

  if Cnv('cch', r_CCH) = True then
    Exit;
  if Cnv('chh', r_CHH) = True then
    Exit;
  if Cnv('cng', r_CNG) = True then
    Exit;

  if Cnv('ch', r_CH) = True then
    Exit;
  if Cnv('ck', r_CK) = True then
    Exit;
  if Cnv('cc', r_CC) = True then
    Exit;
  if Cnv('cn', r_CN) = True then
    Exit;

  if Cnv('c', r_CC) = True then
    Exit;
end;

{$HINTS Off}

function TEnglishToRegEx.Cnv(const Compare: string; const IfTrue: string): Boolean;
var
  I:                                             Integer;
  tmp:                                           string;
  NextCharacterAfterBlock, LastCharacterOfBlock: string;
begin
  Result := False;
  I := length(Compare);
  tmp := MidStr(pEnglishText, pos, I);

  if Compare = tmp then
  begin
    Cnv := True;
    NextCharacterAfterBlock := MidStr(pEnglishText, pos + I, 1);
    LastCharacterOfBlock := MidStr(pEnglishText, pos + I - 1, 1);

    {
      If (Consonent(LastCharacterOfBlock) = True) And (Consonent(NextCharacterAfterBlock) = True) Then
      Rs := Rs + IfTrue + r_InjectHasanta
      Else Begin
      If NextCharacterAfterBlock <> '' Then
      Rs := Rs + IfTrue + r_InjectFola + r_InjectChandraBisharga
      Else
      Rs := Rs + IfTrue + r_InjectChandraBisharga;
      End;
    }
    RS := RS + IfTrue + r_InjectHasanta + r_InjectFola + r_InjectedVowel + r_InjectChandraBisharga;

    pos := pos + I;
  end
  else
    Cnv := False;
end;
{$HINTS ON}

function TEnglishToRegEx.Consonent(const T: string): Boolean;
var
  temp: Char;
  myT:  string;
begin
  myT := LowerCase(T);
  temp := #0;
  if length(myT) > 0 then
    temp := myT[1];

  case temp of
    'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z':
      Consonent := True;
    else
      Consonent := False;
  end;
end;

function TEnglishToRegEx.Convert(const EnglishT: string): string;
begin
  if EnglishT = '' then
    Exit;
  pEnglishText := EscapeSpecialCharacters(CorrectCase(EnglishT));
  Result := MyConvert;
end;

function TEnglishToRegEx.CorrectCase(const inputT: string): string;
begin
  Result := LowerCase(inputT);
end;

constructor TEnglishToRegEx.Create;
begin
  Initialize_RVals;
  ln := 0;
  pos := 0;
end;

procedure TEnglishToRegEx.D;
begin
  if Cnv('dhm', r_DHM) = True then
    Exit;
  if Cnv('dhn', r_DHN) = True then
    Exit;
  if Cnv('dbh', r_DBH) = True then
    Exit;
  if Cnv('ddh', r_DDH) = True then
    Exit;
  if Cnv('dgh', r_DGH) = True then
    Exit;

  if Cnv('db', r_DB) = True then
    Exit;
  if Cnv('dd', r_DD) = True then
    Exit;
  if Cnv('dg', r_DG) = True then
    Exit;
  if Cnv('dh', r_DH) = True then
    Exit;

  if Cnv('d', r_DD) = True then
    Exit;
end;

procedure TEnglishToRegEx.E;
begin
  if Cnv('ey', r_EY) = True then
    Exit;
  if Cnv('ee', r_EE) = True then
    Exit;

  if Cnv('e', r_E) = True then
    Exit;
end;

{$WARN NO_RETVAL OFF}

function TEnglishToRegEx.EscapeSpecialCharacters(const inputT: string): string;
var
  T: string;
begin
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
end;
{$WARN NO_RETVAL On}

procedure TEnglishToRegEx.F;
begin
  if Cnv('ff', r_FF) = True then
    Exit;

  if Cnv('f', r_FF) = True then
    Exit;
end;

procedure TEnglishToRegEx.G;
begin
  if Cnv('ggh', r_GGH) = True then
    Exit;
  if Cnv('gdh', r_GDH) = True then
    Exit;
  if Cnv('ghn', r_GHN) = True then
    Exit;

  if Cnv('gh', r_GH) = True then
    Exit;
  if Cnv('gg', r_GG) = True then
    Exit;

  if Cnv('g', r_GG) = True then
    Exit;
end;

procedure TEnglishToRegEx.H;
begin
  if Cnv('hl', r_HL) = True then
    Exit;
  if Cnv('hh', r_HH) = True then
    Exit;
  if Cnv('hm', r_HM) = True then
    Exit;
  if Cnv('hn', r_HN) = True then
    Exit;

  if Cnv('h', r_HH) = True then
    Exit;
end;

procedure TEnglishToRegEx.I;
begin
  if Cnv('ia', r_IA) = True then
    Exit;

  if Cnv('i', r_I) = True then
    Exit;
end;

procedure TEnglishToRegEx.J;
begin
  if Cnv('jng', r_JNG) = True then
    Exit;
  if Cnv('jjh', r_JJH) = True then
    Exit;

  if Cnv('jj', r_JJ) = True then
    Exit;
  if Cnv('jh', r_JH) = True then
    Exit;

  if Cnv('j', r_JJ) = True then
    Exit;
end;

procedure TEnglishToRegEx.K;
begin
  if Cnv('kshm', r_KSHM) = True then
    Exit;
  if Cnv('kkhm', r_KKHM) = True then
    Exit;
  if Cnv('kshn', r_KSHN) = True then
    Exit;
  if Cnv('kkhn', r_KKHN) = True then
    Exit;

  if Cnv('ksh', r_KSH) = True then
    Exit;
  if Cnv('kkh', r_KKH) = True then
    Exit;
  if Cnv('kxm', r_KXM) = True then
    Exit;
  if Cnv('kxn', r_KXN) = True then
    Exit;

  if Cnv('kh', r_KH) = True then
    Exit;
  if Cnv('kk', r_KK) = True then
    Exit;
  if Cnv('ks', r_KS) = True then
    Exit;
  if Cnv('kx', r_KX) = True then
    Exit;

  if Cnv('k', r_KK) = True then
    Exit;
end;

procedure TEnglishToRegEx.L;
begin
  if Cnv('lkh', r_LKH) = True then
    Exit;
  if Cnv('lgh', r_LGH) = True then
    Exit;
  if Cnv('lph', r_LPH) = True then
    Exit;
  if Cnv('ldh', r_LDH) = True then
    Exit;
  if Cnv('lbh', r_LBH) = True then
    Exit;

  if Cnv('ll', r_LL) = True then
    Exit;
  if Cnv('lk', r_LK) = True then
    Exit;
  if Cnv('lg', r_LG) = True then
    Exit;
  if Cnv('lp', r_LP) = True then
    Exit;
  if Cnv('ld', r_LD) = True then
    Exit;
  if Cnv('lb', r_LB) = True then
    Exit;

  if Cnv('l', r_LL) = True then
    Exit;
end;

procedure TEnglishToRegEx.M;
begin
  if Cnv('mbh', r_MBH) = True then
    Exit;
  if Cnv('mph', r_MPH) = True then
    Exit;
  if Cnv('mth', r_MTH) = True then
    Exit;

  if Cnv('mm', r_MM) = True then
    Exit;
  if Cnv('mb', r_MB) = True then
    Exit;
  if Cnv('mp', r_MP) = True then
    Exit;
  if Cnv('mt', r_MT) = True then
    Exit;

  if Cnv('m', r_MM) = True then
    Exit;
end;

function TEnglishToRegEx.MyConvert: string;
var
  tt:      Char;
  tString: string;
begin
  ln := length(pEnglishText);
  pos := 1;
  RS := '';

  repeat
    tString := MidStr(pEnglishText, pos, 1);
    tt := #0;
    if length(tString) > 0 then
      tt := tString[1];

    case tt of

      // --------START Number Generation---------------
      // 1st, we'll convert numbers. Hassel free :)
      '0':
        AddRs('((' + b_0 + ')|(0)|(' + b_Sh + b_UUkar + b_N + b_Hasanta + b_Z + '))');
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

      else
        AddRs(tt);

    end;

  until pos > ln;

  MyConvert := RS;

end;

procedure TEnglishToRegEx.N;
begin
  if Cnv('ngksh', r_NGKSH) = True then
    Exit;
  if Cnv('ngkkh', r_NGKKH) = True then
    Exit;

  if Cnv('ngch', r_NGCH) = True then
    Exit;
  if Cnv('nggh', r_NGGH) = True then
    Exit;
  if Cnv('ngkx', r_NGKX) = True then
    Exit;
  if Cnv('ngjh', r_NGJH) = True then
    Exit;
  if Cnv('ngkh', r_NGKH) = True then
    Exit;

  if Cnv('nsh', r_NSH) = True then
    Exit;
  if Cnv('ndh', r_NDH) = True then
    Exit;
  if Cnv('nkh', r_NKH) = True then
    Exit;
  if Cnv('nth', r_NTH) = True then
    Exit;
  if Cnv('ngj', r_NGJ) = True then
    Exit;
  if Cnv('ngm', r_NGM) = True then
    Exit;
  if Cnv('ngg', r_NGG) = True then
    Exit;
  if Cnv('ngx', r_NGX) = True then
    Exit;
  if Cnv('ngk', r_NGK) = True then
    Exit;
  if Cnv('ngh', r_NGH) = True then
    Exit;
  if Cnv('nch', r_NCH) = True then
    Exit;
  if Cnv('njh', r_NJH) = True then
    Exit;
  if Cnv('ngc', r_NGC) = True then
    Exit;

  if Cnv('nc', r_NC) = True then
    Exit;
  if Cnv('nn', r_NN) = True then
    Exit;
  if Cnv('ng', r_NG) = True then
    Exit;
  if Cnv('nk', r_NK) = True then
    Exit;
  if Cnv('nj', r_NJ) = True then
    Exit;
  if Cnv('nd', r_ND) = True then
    Exit;
  if Cnv('nt', r_NT) = True then
    Exit;

  if Cnv('n', r_NN) = True then
    Exit;
end;

function TEnglishToRegEx.NextT: string;
begin
  NextT := MidStr(pEnglishText, pos + 1, 1);
end;

procedure TEnglishToRegEx.O;
begin
  if Cnv('oo', r_OO) = True then
    Exit;
  if Cnv('oi', r_OI) = True then
    Exit;
  if Cnv('ou', r_OU) = True then
    Exit;

  if Begining then
  begin
    if Cnv('o', r_OFirst) = True then
      Exit;
  end
  else
  begin
    if Cnv('o', r_O) = True then
      Exit;
  end;

end;

procedure TEnglishToRegEx.P;
begin
  if Cnv('phl', r_PHL) = True then
    Exit;

  if Cnv('ph', r_PH) = True then
    Exit;
  if Cnv('pp', r_PP) = True then
    Exit;

  if Cnv('p', r_PP) = True then
    Exit;
end;

function TEnglishToRegEx.PrevT: string;
var
  I: Integer;
begin

  I := pos - 1;
  if I < 1 then
  begin
    PrevT := '';
    Exit;
  end;

  PrevT := MidStr(pEnglishText, I, 1);
end;

procedure TEnglishToRegEx.Q;
begin
  if Cnv('qq', r_QQ) = True then
    Exit;

  if Cnv('q', r_QQ) = True then
    Exit;
end;

procedure TEnglishToRegEx.R;
begin
  if Cnv('rri', r_RRI) = True then
    Exit;

  if Cnv('ri', r_RI) = True then
    Exit;
  if Cnv('rh', r_RH) = True then
    Exit;

  if Begining then
  begin
    if Cnv('r', r_RFirst) = True then
      Exit;
  end
  else
  begin
    if Cnv('r', r_R) = True then
      Exit;
  end;
end;

procedure TEnglishToRegEx.S;
begin
  if Cnv('shsh', r_SHSH) = True then
    Exit;

  if Cnv('ssh', r_SSH) = True then
    Exit;
  if Cnv('shm', r_SHM) = True then
    Exit;
  if Cnv('shn', r_SHN) = True then
    Exit;

  if Cnv('ss', r_SS) = True then
    Exit;
  if Cnv('sh', r_SH) = True then
    Exit;

  if Cnv('s', r_SS) = True then
    Exit;
end;

procedure TEnglishToRegEx.T;
begin
  if Cnv('thth', r_THTH) = True then
    Exit;

  if Cnv('tth', r_TTH) = True then
    Exit;
  if Cnv('t``', r_T_Acnt_Acnt) = True then
    Exit;
  if Cnv('tth', r_TTH) = True then
    Exit;

  if Cnv('tt', r_TT) = True then
    Exit;
  if Cnv('th', r_TH) = True then
    Exit;

  if Cnv('t', r_TT) = True then
    Exit;
end;

procedure TEnglishToRegEx.U;
begin
  if Cnv('uu', r_UU) = True then
    Exit;
  if Cnv('u', r_U) = True then
    Exit;
end;

procedure TEnglishToRegEx.V;
begin
  if Cnv('vv', r_VV) = True then
    Exit;
  if Cnv('v', r_VV) = True then
    Exit;
end;

{$HINTS Off}

function TEnglishToRegEx.Vowel(const T: string): Boolean;
var
  myT: string;
begin
  Result := False;
  myT := LowerCase(T);
  if length(myT) > 0 then
    myT := myT[1];

  if (myT = 'a') or (myT = 'e') or (myT = 'i') or (myT = 'o') or (myT = 'u') then
    Vowel := True
  else
    Vowel := False;
end;
{$HINTS ON}

procedure TEnglishToRegEx.W;
begin
  if Cnv('w', r_W) = True then
    Exit;
end;

procedure TEnglishToRegEx.X;
begin
  if Cnv('xm', r_XM) = True then
    Exit;
  if Cnv('xn', r_XN) = True then
    Exit;

  if Cnv('x', r_X) = True then
    Exit;
end;

procedure TEnglishToRegEx.Y;
begin
  if Cnv('y', r_Y) = True then
    Exit;
end;

procedure TEnglishToRegEx.Z;
begin
  if Cnv('zzh', r_ZZH) = True then
    Exit;

  if Cnv('zh', r_ZH) = True then
    Exit;
  if Cnv('zz', r_ZZ) = True then
    Exit;

  if Cnv('z', r_ZZ) = True then
    Exit;
end;

end.
