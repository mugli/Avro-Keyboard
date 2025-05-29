{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit clsEnglishToBangla;

interface

uses
  classes,
  sysutils,
  StrUtils;

// Skeleton of Class TEnglishToBangla
type
  TEnglishToBangla = class
    private
      pEnglishText:      string;
      ln:                Integer; // Length of English String
      pos:               Integer; // Position of processing at English String
      RS:                string;  // Result String
      AutoCorrect:       Boolean;
      DetermineZWNJ_ZWJ: string;

      procedure CutText(const inputEStr: string; var outSIgnore: string; var outMidMain: string; var outEIgnore: string);
      function MyConvert(): string;
      procedure Dot;
      procedure smallO;
      procedure O;
      procedure h;
      procedure s;
      procedure l;
      procedure R;
      procedure m;
      procedure b;
      procedure p;
      procedure d;
      procedure T;
      procedure J;
      procedure c;
      procedure n;
      procedure k;
      procedure g;
      function Cnv(const Compare: string; const IfTrue: string): Boolean;
      procedure AddRs(const T: string);
      procedure AddRsEx(const T: string; p: Integer = 0);
      function PrevT: string;
      function PrevTEx(const Position: Integer): string;
      function NextT: string;
      function NextTEx(iLength: Integer; skipstart: Integer = 0): string;
      function Vowel(const T: string): Boolean;
      function Consonent(const T: string): Boolean;
      function Number(const T: string): Boolean;
      function Begining: Boolean;
    public
      constructor Create; // Initializer
      function Convert(const EnglishT: string): string;
      function CorrectCase(const inputT: string): string;
      // Published
      property AutoCorrectEnabled: Boolean read AutoCorrect write AutoCorrect;

  end;

implementation

uses
  uAutoCorrect,
  BanglaChars,
  WindowsVersion,
  uRegistrySettings;

{ TEnglishToBangla }

{ =============================================================================== }

procedure TEnglishToBangla.AddRs(const T: string);
begin
  RS := RS + T;
  pos := pos + 1;
end;

{ =============================================================================== }

procedure TEnglishToBangla.AddRsEx(const T: string; p: Integer);
begin
  RS := RS + T;
  pos := pos + p;
end;

{ =============================================================================== }

procedure TEnglishToBangla.b;
begin
  if Cnv('bdh', b_B + b_Hasanta + b_Dh) = True then
    Exit; // B+Dh
  if Cnv('bhl', b_Bh + b_Hasanta + b_L) = True then
    Exit; // Bh+L

  if Cnv('bj', b_B + b_Hasanta + b_J) = True then
    Exit; // B+J
  if Cnv('bd', b_B + b_Hasanta + b_D) = True then
    Exit; // B+D
  if Cnv('bb', b_B + b_Hasanta + b_B) = True then
    Exit; // B+B
  if Cnv('bl', b_B + b_Hasanta + b_L) = True then
    Exit; // B+L
  if Cnv('bh', b_Bh) = True then
    Exit; // Bh
  if Cnv('vl', b_Bh + b_Hasanta + b_L) = True then
    Exit; // Bh+L

  if Cnv('b', b_B) = True then
    Exit; // B
  if Cnv('v', b_Bh) = True then
    Exit; // Bh
end;

{ =============================================================================== }

{$HINTS Off}

function TEnglishToBangla.Begining: Boolean;
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

{$HINTS On}
{ =============================================================================== }

procedure TEnglishToBangla.c;
begin
  if Cnv('cNG', b_C + b_Hasanta + b_NYA) = True then
    Exit; // C+NYA
  if Cnv('cch', b_C + b_Hasanta + b_CH) = True then
    Exit; // C+C
  if Cnv('cc', b_C + b_Hasanta + b_C) = True then
    Exit; // C+C
  // If Cnv('chh', b_CH) = True Then Exit ; //Ch
  if Cnv('ch', b_CH) = True then
    Exit; // C
  if Cnv('c', b_C) = True then
    Exit; // C
end;

{ =============================================================================== }

{$HINTS Off}

function TEnglishToBangla.Cnv(const Compare: string; const IfTrue: string): Boolean;
var
  i:   Integer;
  tmp: string;
begin
  Result := False;
  i := length(Compare);
  tmp := MidStr(pEnglishText, pos, i);

  if Compare = tmp then
  begin
    Result := True;
    RS := RS + IfTrue;
    pos := pos + i;
  end
  else
    Result := False;
end;

{$HINTS On}
{ =============================================================================== }

{$HINTS Off}

function TEnglishToBangla.Consonent(const T: string): Boolean;
var
  temp: Char;
  myT:  string;
begin
  Result := False;
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

{$HINTS On}
{ =============================================================================== }

function TEnglishToBangla.Convert(const EnglishT: string): string;
var
  EngStr:                                                   string;
  Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T: string;
  tempStr:                                                  string;
  DictItem:                                                 string;
begin

  if EnglishT = '' then
    Exit;

  // As is support
  if AutoCorrect = True then
  begin
    if dict.TryGetValue(EnglishT, DictItem) then
    begin
      if EnglishT = DictItem then
      begin
        Convert := EnglishT;
        Exit;
      end;
    end;
  end;

  /// ////////////////////

  EngStr := CorrectCase(EnglishT);

  if AutoCorrect = True then
  begin
    if dict.TryGetValue(EngStr, DictItem) then
    begin
      pEnglishText := DictItem;
      Convert := MyConvert;
    end
    else
    begin
      // Whole word not found in the dictionary, lets try ignoring punctuations
      Starting_Ignoreable_T := '';
      Middle_Main_T := '';
      Ending_Ignorable_T := '';
      CutText(EngStr, Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T);

      if dict.TryGetValue(Middle_Main_T, DictItem) then
      begin
        if Starting_Ignoreable_T <> '' then
        begin
          pEnglishText := Starting_Ignoreable_T;
          tempStr := MyConvert;
        end;

        if Middle_Main_T <> '' then
        begin
          pEnglishText := DictItem;
          tempStr := tempStr + MyConvert;
        end;

        if Ending_Ignorable_T <> '' then
        begin
          pEnglishText := Ending_Ignorable_T;
          tempStr := tempStr + MyConvert;
        end;

        Convert := tempStr;
      end
      else
      begin // Autocorrect enabled but word not found even after ignoring punctuations
        pEnglishText := EngStr;
        Convert := MyConvert;
      end;
    end;
  end
  else
  begin
    pEnglishText := EngStr;
    Convert := MyConvert;
  end;
end;

{ =============================================================================== }

function TEnglishToBangla.CorrectCase(const inputT: string): string;
var
  i, l:    Integer;
  s, temp: string;
  T:       Char;
begin
  l := length(inputT);
  T := #0;
  s := '';

  for i := 1 to l do
  begin
    temp := MidStr(inputT, i, 1);
    if length(temp) > 0 then
      T := temp[1];

    case T of
      'o', 'O', 'i', 'I', 'u', 'U':
        s := s + T;
      'd', 'D', 'g', 'G', 'j', 'n', 'N', 'r', 'R', 's', 'S', 't', 'T', 'y', 'Y', 'z', 'Z':
        s := s + T;
      'J':
        if EnableJoNukta = 'YES' then
        begin
          s := s + T;
        end
        else
        begin
          s := s + LowerCase(T);
        end;
      else
        s := s + LowerCase(T);
    end;
  end;

  Result := s;
end;

{ =============================================================================== }

constructor TEnglishToBangla.Create;
begin
  AutoCorrect := True;

  // If IsWinVistaOrLater Then
  DetermineZWNJ_ZWJ := ZWJ;
  // Else
  // DetermineZWNJ_ZWJ := ZWNJ;
end;

{ =============================================================================== }

procedure TEnglishToBangla.CutText(const inputEStr: string; var outSIgnore, outMidMain, outEIgnore: string);
var
  i:                 Integer;
  p, q:              Integer;
  EStrLen:           Integer;
  tStr:              Char;
  reverse_inputEStr: string;
  temporaryString:   string;
begin

  tStr := #0;
  p := 0;

  EStrLen := length(inputEStr);
  // Start Cutting outSIgnore
  for i := 1 to EStrLen do
  begin
    temporaryString := MidStr(inputEStr, i, 1);
    if length(temporaryString) > 0 then
      tStr := temporaryString[1];
    case tStr of
      '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', #39, '"', ';', '<', '>', '/', '?', '|', '\', '.':

        p := i;

      ',':
        if MidStr(inputEStr, i + 1, 1) = ',' then
          Break
        else
          p := i;

      ':':
        if MidStr(inputEStr, i + 1, 1) = '`' then
          p := i
        else
          Break;

      '`':
        if i - 1 >= 1 then
        begin
          if (MidStr(inputEStr, i - 1, 1) = '.') or (MidStr(inputEStr, i - 1, 1) = ':') then
            p := i
          else
            Break;
        end
        else
          Break;
      else
        Break;
    end;
  end;

  outSIgnore := LeftStr(inputEStr, p);
  // End Cutting outSIgnore

  // Start Cutting outEIgnore
  tStr := #0;
  q := 0;

  reverse_inputEStr := ReverseString(inputEStr);
  for i := 1 to EStrLen - p do
  begin
    temporaryString := MidStr(reverse_inputEStr, i, 1);
    if length(temporaryString) > 0 then
      tStr := temporaryString[1];

    case tStr of
      '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', #39, #34, ';', '<', '>', '/', '.', '?', '|', '\':
        q := i;
      ',':
        if MidStr(reverse_inputEStr, i + 1, 1) = ',' then
          Break
        else
          q := i;

      '`':
        if (MidStr(reverse_inputEStr, i + 1, 1) = ':') or (MidStr(reverse_inputEStr, i + 1, 1) = '.') then
          q := i
        else
          Break;
      ':':
        if i - 1 >= 1 then
        begin
          if MidStr(reverse_inputEStr, i - 1, 1) = '`' then
            q := i
          else
            Break;
        end
        else
          Break;
      else
        Break;
    end;
  end;

  outEIgnore := RightStr(inputEStr, q);
  // End Cutting outEIgnore

  // Start Cutting outMidMain
  temporaryString := MidStr(inputEStr, p + 1, length(inputEStr));
  temporaryString := LeftStr(temporaryString, length(temporaryString) - q);
  outMidMain := temporaryString;

end;

{ =============================================================================== }

procedure TEnglishToBangla.d;
begin
  if Cnv('dhn', b_Dh + b_Hasanta + b_N) = True then
    Exit; // Dh+N
  if Cnv('dhm', b_Dh + b_Hasanta + b_M) = True then
    Exit; // Dh+M
  if Cnv('dgh', b_D + b_Hasanta + b_GH) = True then
    Exit; // D+Gh
  if Cnv('ddh', b_D + b_Hasanta + b_Dh) = True then
    Exit; // D+Dh
  if Cnv('dbh', b_D + b_Hasanta + b_Bh) = True then
    Exit; // D+Bh

  if Cnv('dv', b_D + b_Hasanta + b_Bh) = True then
    Exit; // D+Bh
  if Cnv('dm', b_D + b_Hasanta + b_M) = True then
    Exit; // D+M
  if Cnv('DD', b_Dd + b_Hasanta + b_Dd) = True then
    Exit; // Dd+Dd
  if Cnv('Dh', b_Ddh) = True then
    Exit; // Ddh
  if Cnv('dh', b_Dh) = True then
    Exit; // Dh
  if Cnv('dg', b_D + b_Hasanta + b_G) = True then
    Exit; // D+G
  if Cnv('dd', b_D + b_Hasanta + b_D) = True then
    Exit; // D+D

  if Cnv('D', b_Dd) = True then
    Exit; // Dd
  if Cnv('d', b_D) = True then
    Exit; // D
end;

{ =============================================================================== }

procedure TEnglishToBangla.Dot;
begin
  if Cnv('...', '...') = True then
    Exit; // ...

  if Cnv('.`', '.') = True then
    Exit; // .
  if Cnv('..', b_Dari + b_Dari) = True then
    Exit; // ||

  if Number(NextT) = True then
  begin
    if Cnv('.', '.') = True then
      Exit; // Decimal Mark
  end
  else if Cnv('.', b_Dari) = True then
    Exit; // |
end;

{ =============================================================================== }

procedure TEnglishToBangla.g;
begin
  if Cnv('ghn', b_GH + b_Hasanta + b_N) = True then
    Exit; // gh+N
  if Cnv('Ghn', b_GH + b_Hasanta + b_N) = True then
    Exit; // gh+N

  if Cnv('gdh', b_G + b_Hasanta + b_Dh) = True then
    Exit; // g+dh
  if Cnv('Gdh', b_G + b_Hasanta + b_Dh) = True then
    Exit; // g+dh

  if Cnv('gN', b_G + b_Hasanta + b_Nn) = True then
    Exit; // g+N
  if Cnv('GN', b_G + b_Hasanta + b_Nn) = True then
    Exit; // g+N

  if Cnv('gn', b_G + b_Hasanta + b_N) = True then
    Exit; // g+n
  if Cnv('Gn', b_G + b_Hasanta + b_N) = True then
    Exit; // g+n

  if Cnv('gm', b_G + b_Hasanta + b_M) = True then
    Exit; // g+M
  if Cnv('Gm', b_G + b_Hasanta + b_M) = True then
    Exit; // g+M

  if Cnv('gl', b_G + b_Hasanta + b_L) = True then
    Exit; // g+L
  if Cnv('Gl', b_G + b_Hasanta + b_L) = True then
    Exit; // g+L

  if Cnv('gg', b_J + b_Hasanta + b_NYA) = True then
    Exit; // gg
  if Cnv('GG', b_J + b_Hasanta + b_NYA) = True then
    Exit; // gg
  if Cnv('Gg', b_J + b_Hasanta + b_NYA) = True then
    Exit; // gg
  if Cnv('gG', b_J + b_Hasanta + b_NYA) = True then
    Exit; // gg

  if Cnv('gh', b_GH) = True then
    Exit; // gh
  if Cnv('Gh', b_GH) = True then
    Exit; // gh

  // If Cnv('gb', b_G + b_Hasanta + b_B) = True Then Exit ; //g+b
  // If Cnv('Gb', b_G + b_Hasanta + b_B) = True Then Exit ; //g+b

  if Cnv('g', b_G) = True then
    Exit; // g
  if Cnv('G', b_G) = True then
    Exit; // g
end;

{ =============================================================================== }

procedure TEnglishToBangla.h;
begin

  if Cnv('hN', b_H + b_Hasanta + b_Nn) = True then
    Exit; // H+Nn
  if Cnv('hn', b_H + b_Hasanta + b_N) = True then
    Exit; // H+N
  if Cnv('hm', b_H + b_Hasanta + b_M) = True then
    Exit; // H+m
  if Cnv('hl', b_H + b_Hasanta + b_L) = True then
    Exit; // H+L

  if Cnv('h', b_H) = True then
    Exit; // H
end;

{ =============================================================================== }

procedure TEnglishToBangla.J;
begin
  if Cnv('jjh', b_J + b_Hasanta + b_JH) = True then
    Exit; // J+Jh
  if Cnv('jNG', b_J + b_Hasanta + b_NYA) = True then
    Exit; // J+NYA
  if Cnv('jh', b_JH) = True then
    Exit; // Jh
  if Cnv('jj', b_J + b_Hasanta + b_J) = True then
    Exit; // J+J
  if Cnv('j', b_J) = True then
    Exit; // J
  if EnableJoNukta = 'YES' then
  begin
    if Cnv('J', b_J + b_Nukta) = True then
      Exit; // J+Nukta
  end
  else
  begin
    if Cnv('J', b_J) = True then
      Exit; // J+Nukta
  end;
end;

{ =============================================================================== }

procedure TEnglishToBangla.k;
begin
  if Cnv('kkhN', b_K + b_Hasanta + b_Ss + b_Hasanta + b_Nn) = True then
    Exit; // khioN
  if Cnv('kShN', b_K + b_Hasanta + b_Ss + b_Hasanta + b_Nn) = True then
    Exit; // khioN
  if Cnv('kkhm', b_K + b_Hasanta + b_Ss + b_Hasanta + b_M) = True then
    Exit; // khioM
  if Cnv('kShm', b_K + b_Hasanta + b_Ss + b_Hasanta + b_M) = True then
    Exit; // khioM

  if Cnv('kxN', b_K + b_Hasanta + b_Ss + b_Hasanta + b_Nn) = True then
    Exit; // khioN
  if Cnv('kxm', b_K + b_Hasanta + b_Ss + b_Hasanta + b_M) = True then
    Exit; // khioM
  if Cnv('kkh', b_K + b_Hasanta + b_Ss) = True then
    Exit; // khio
  if Cnv('kSh', b_K + b_Hasanta + b_Ss) = True then
    Exit; // khio

  if Cnv('ksh', b_K + b_Sh) = True then
    Exit; // K`Sh

  if Cnv('kx', b_K + b_Hasanta + b_Ss) = True then
    Exit; // khio
  if Cnv('kk', b_K + b_Hasanta + b_K) = True then
    Exit; // k+k
  if Cnv('kT', b_K + b_Hasanta + b_Tt) = True then
    Exit; // k+T
  if Cnv('kt', b_K + b_Hasanta + b_T) = True then
    Exit; // k+t
  if Cnv('km', b_K + b_Hasanta + b_M) = True then
    Exit; // k+M
  if Cnv('kl', b_K + b_Hasanta + b_L) = True then
    Exit; // k+L
  if Cnv('ks', b_K + b_Hasanta + b_S) = True then
    Exit; // k+S

  if Cnv('kh', b_KH) = True then
    Exit; // kh

  if Cnv('k', b_K) = True then
    Exit; // k
end;

{ =============================================================================== }

procedure TEnglishToBangla.l;
begin
  if Cnv('lbh', b_L + b_Hasanta + b_Bh) = True then
    Exit; // L+Bh
  if Cnv('ldh', b_L + b_Hasanta + b_Dh) = True then
    Exit; // L+Dh

  if Cnv('lkh', b_L + b_KH) = True then
    Exit; // L & Kk
  if Cnv('lgh', b_L + b_GH) = True then
    Exit; // L & Gh
  if Cnv('lph', b_L + b_Ph) = True then
    Exit; // L & Ph

  if Cnv('lk', b_L + b_Hasanta + b_K) = True then
    Exit; // L+K
  if Cnv('lg', b_L + b_Hasanta + b_G) = True then
    Exit; // L+G
  if Cnv('lT', b_L + b_Hasanta + b_Tt) = True then
    Exit; // L+T
  if Cnv('lD', b_L + b_Hasanta + b_Dd) = True then
    Exit; // L+Dd
  if Cnv('lp', b_L + b_Hasanta + b_P) = True then
    Exit; // L+P
  if Cnv('lv', b_L + b_Hasanta + b_Bh) = True then
    Exit; // L+Bh
  if Cnv('lm', b_L + b_Hasanta + b_M) = True then
    Exit; // L+M
  if Cnv('ll', b_L + b_Hasanta + b_L) = True then
    Exit; // L+L
  if Cnv('lb', b_L + b_Hasanta + b_B) = True then
    Exit; // L+B

  if Cnv('l', b_L) = True then
    Exit; // L
end;

{ =============================================================================== }

procedure TEnglishToBangla.m;
begin
  if Cnv('mth', b_M + b_Hasanta + b_Th) = True then
    Exit; // M+Th
  if Cnv('mph', b_M + b_Hasanta + b_Ph) = True then
    Exit; // M+Ph
  if Cnv('mbh', b_M + b_Hasanta + b_Bh) = True then
    Exit; // M+V
  if Cnv('mpl', b_M + b_P + b_Hasanta + b_L) = True then
    Exit; // M+V

  if Cnv('mn', b_M + b_Hasanta + b_N) = True then
    Exit; // M+N
  if Cnv('mp', b_M + b_Hasanta + b_P) = True then
    Exit; // M+P
  if Cnv('mv', b_M + b_Hasanta + b_Bh) = True then
    Exit; // M+V
  if Cnv('mm', b_M + b_Hasanta + b_M) = True then
    Exit; // M+M
  if Cnv('ml', b_M + b_Hasanta + b_L) = True then
    Exit; // M+L
  if Cnv('mb', b_M + b_Hasanta + b_B) = True then
    Exit; // M+B
  if Cnv('mf', b_M + b_Hasanta + b_Ph) = True then
    Exit; // M+Ph

  if Cnv('m', b_M) = True then
    Exit; // M
end;

{ =============================================================================== }

function TEnglishToBangla.MyConvert: string;
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
        if NextT = 'Z' then
          AddRsEx(b_A + b_Hasanta + b_Z + b_AAkar, 2)
        else if (Begining = True) and (NextT <> '`') then
          AddRs(b_AA)
        else if (Consonent(PrevT) = False) and (PrevT <> 'a') and (NextT <> '`') then
          AddRs(b_Y + b_AAkar)
        else if NextT = '`' then
          AddRsEx(b_AAkar, 2)
        else if (PrevT = 'a') and (NextT <> '`') then
          AddRs(b_AA)
        else
          AddRs(b_AAkar);

      'i':
        if ((Consonent(PrevT) = False) or (Begining = True)) and (NextT <> '`') then
          AddRs(b_I)
        else if NextT = '`' then
          AddRsEx(b_Ikar, 2)
        else
          AddRs(b_Ikar);

      'I':
        if ((Consonent(PrevT) = False) or (Begining = True)) and (NextT <> '`') then
          AddRs(b_II)
        else if NextT = '`' then
          AddRsEx(b_IIkar, 2)
        else
          AddRs(b_IIkar);

      'u':
        if ((Consonent(PrevT) = False) or (Begining = True)) and (NextT <> '`') then
          AddRs(b_U)
        else if NextT = '`' then
          AddRsEx(b_Ukar, 2)
        else
          AddRs(b_Ukar);

      'U':
        if ((Consonent(PrevT) = False) or (Begining = True)) and (NextT <> '`') then
          AddRs(b_UU)
        else if NextT = '`' then
          AddRsEx(b_UUkar, 2)
        else
          AddRs(b_UUkar);
      // We'll process ra, Ra,Rha, rri, rrikar, ra fola, reph later

      'e', 'E':
        if ((Consonent(PrevT) = False) or (Begining = True)) and (NextT <> '`') then
        begin
          if NextT = 'e' then
            AddRsEx(b_II, 2)
          else
            AddRs(b_E);
        end
        else if NextT = '`' then
          AddRsEx(b_Ekar, 2)
        else
        begin
          if NextT = 'e' then
            AddRsEx(b_IIkar, 2)
          else
            AddRs(b_Ekar);
        end;

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
        if PrevT = 'r' then
        begin
          if (Consonent(PrevTEx(2)) = True) and (PrevTEx(2) <> 'r') and (PrevTEx(2) <> 'y') and (PrevTEx(2) <> 'w') and (PrevTEx(2) <> 'x') then
            // Previous character is R-Fola, don't add ZWJ
            AddRs(b_Hasanta + b_Z)
          else
            AddRs(DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
        end
        else
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
        if (Consonent(PrevT) = False) and (Begining <> True) then
          AddRs(b_Y)
        else if Begining = True then
          AddRs(b_I + b_Y)
        else
        begin
          if PrevT = 'r' then
          begin
            if (Consonent(PrevTEx(2)) = True) and (PrevTEx(2) <> 'r') and (PrevTEx(2) <> 'y') and (PrevTEx(2) <> 'w') and (PrevTEx(2) <> 'x') then
              // Previous character is R-Fola, don't add ZWJ
              AddRs(b_Hasanta + b_Z)
            else
              AddRs(DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
          end
          else
            AddRs(b_Hasanta + b_Z);
        end;

      'Y':
        AddRs(b_Y); // Force Y
      'w':
        if (Begining = True) and (Vowel(NextT) = True) then
          AddRs(b_O + b_Y)
        else if Consonent(PrevT) = True then
          AddRs(b_Hasanta + b_B)
        else
          AddRs(b_O);

      'q':
        AddRs(b_K);
      'x':
        if Begining = True then
          AddRs(b_E + b_K + b_Hasanta + b_S)
        else
          AddRs(b_K + b_Hasanta + b_S);
      // -----------------End Consonent Generation---------------

      // -----------------Start Symbol Generation---------------
      '.':
        Dot();
      ':':
        if NextT <> '`' then
          AddRs(b_Bisharga)
        else
          AddRsEx(':', 2);

      '^':
        if NextT <> '`' then
          AddRs(b_Chandra)
        else
          AddRsEx('^', 2);

      ',':
        if NextT = ',' then
          AddRsEx(b_Hasanta + ZWNJ, 2)
        else
          AddRs(',');

      '$':
        AddRs(b_Taka);

      // -----------------End Symbol Generation---------------

      // ` - Make sure it is just above case else!
      '`':
        pos := pos + 1; // No change made here,just to bypass juktakkhar making

      else
        AddRs(tt);

    end;

  until pos > ln;

  MyConvert := RS;

end;

{ =============================================================================== }

procedure TEnglishToBangla.n;
begin

  if Cnv('NgkSh', b_NGA + b_Hasanta + b_K + b_Hasanta + b_Ss) = True then
    Exit; // NGA+Khio
  if Cnv('Ngkkh', b_NGA + b_Hasanta + b_K + b_Hasanta + b_Ss) = True then
    Exit; // NGA+Khio

  if Cnv('NGch', b_NYA + b_Hasanta + b_CH) = True then
    Exit; // NYA+Ch
  if Cnv('Nggh', b_NGA + b_Hasanta + b_GH) = True then
    Exit; // NGA+Gh
  if Cnv('Ngkh', b_NGA + b_Hasanta + b_KH) = True then
    Exit; // NGA+Kh
  if Cnv('NGjh', b_NYA + b_Hasanta + b_JH) = True then
    Exit; // NYA+Jh
  if Cnv('ngOU', b_NGA + b_Hasanta + b_G + b_OUkar) = True then
    Exit; // NGA+G
  if Cnv('ngOI', b_NGA + b_Hasanta + b_G + b_OIkar) = True then
    Exit; // NGA+G
  if Cnv('Ngkx', b_NGA + b_Hasanta + b_K + b_Hasanta + b_Ss) = True then
    Exit; // NGA+Khio

  if Cnv('NGc', b_NYA + b_Hasanta + b_C) = True then
    Exit; // NYA+Ch
  if Cnv('nch', b_NYA + b_Hasanta + b_CH) = True then
    Exit; // NYA+Ch
  if Cnv('njh', b_NYA + b_Hasanta + b_JH) = True then
    Exit; // NYA+Jh
  if Cnv('ngh', b_NGA + b_Hasanta + b_GH) = True then
    Exit; // NGA+Gh
  if Cnv('Ngk', b_NGA + b_Hasanta + b_K) = True then
    Exit; // NGA+K
  if Cnv('Ngx', b_NGA + b_Hasanta + b_Ss) = True then
    Exit; // NGA+Khio
  if Cnv('Ngg', b_NGA + b_Hasanta + b_G) = True then
    Exit; // NGA+G
  if Cnv('Ngm', b_NGA + b_Hasanta + b_M) = True then
    Exit; // NGA+M
  if Cnv('NGj', b_NYA + b_Hasanta + b_J) = True then
    Exit; // NYA+J
  if Cnv('ndh', b_N + b_Hasanta + b_Dh) = True then
    Exit; // N+Dh
  if Cnv('nTh', b_N + b_Hasanta + b_Tth) = True then
    Exit; // N+Tth
  if Cnv('NTh', b_Nn + b_Hasanta + b_Tth) = True then
    Exit; // Nn+Tth
  if Cnv('nth', b_N + b_Hasanta + b_Th) = True then
    Exit; // N+Th
  if Cnv('nkh', b_NGA + b_Hasanta + b_KH) = True then
    Exit; // NGA+Kh
  if Cnv('ngo', b_NGA + b_Hasanta + b_G) = True then
    Exit; // NGA+G
  if Cnv('nga', b_NGA + b_Hasanta + b_G + b_AAkar) = True then
    Exit; // NGA+G
  if Cnv('ngi', b_NGA + b_Hasanta + b_G + b_Ikar) = True then
    Exit; // NGA+G
  if Cnv('ngI', b_NGA + b_Hasanta + b_G + b_IIkar) = True then
    Exit; // NGA+G
  if Cnv('ngu', b_NGA + b_Hasanta + b_G + b_Ukar) = True then
    Exit; // NGA+G
  if Cnv('ngU', b_NGA + b_Hasanta + b_G + b_UUkar) = True then
    Exit; // NGA+G
  if Cnv('nge', b_NGA + b_Hasanta + b_G + b_Ekar) = True then
    Exit; // NGA+G
  if Cnv('ngO', b_NGA + b_Hasanta + b_G + b_Okar) = True then
    Exit; // NGA+G
  if Cnv('NDh', b_Nn + b_Hasanta + b_Ddh) = True then
    Exit; // Nn+Ddh

  if Cnv('nsh', b_N + b_Sh) = True then
    Exit; // N & Sh

  if Cnv('Ngr', b_NGA + b_R) = True then
    Exit; // NGA & R
  if Cnv('NGr', b_NYA + b_R) = True then
    Exit; // NYA & R
  if Cnv('ngr', b_Anushar + b_R) = True then
    Exit; // Anushar & R

  if Cnv('nj', b_NYA + b_Hasanta + b_J) = True then
    Exit; // NYA+J
  if Cnv('Ng', b_NGA) = True then
    Exit; // NGA
  if Cnv('NG', b_NYA) = True then
    Exit; // NYA
  if Cnv('nk', b_NGA + b_Hasanta + b_K) = True then
    Exit; // NGA+K
  if Cnv('ng', b_Anushar) = True then
    Exit; // Anushar
  if Cnv('nn', b_N + b_Hasanta + b_N) = True then
    Exit; // N+N
  if Cnv('NN', b_Nn + b_Hasanta + b_Nn) = True then
    Exit; // Nn+Nn
  if Cnv('Nn', b_Nn + b_Hasanta + b_N) = True then
    Exit; // Nn+N
  if Cnv('nm', b_N + b_Hasanta + b_M) = True then
    Exit; // N+M
  if Cnv('Nm', b_Nn + b_Hasanta + b_M) = True then
    Exit; // Nn+M
  if Cnv('nd', b_N + b_Hasanta + b_D) = True then
    Exit; // N+D
  if Cnv('nT', b_N + b_Hasanta + b_Tt) = True then
    Exit; // N+Tt
  if Cnv('NT', b_Nn + b_Hasanta + b_Tt) = True then
    Exit; // Nn+Tt
  if Cnv('nD', b_N + b_Hasanta + b_Dd) = True then
    Exit; // N+Dd
  if Cnv('ND', b_Nn + b_Hasanta + b_Dd) = True then
    Exit; // Nn+Dd
  if Cnv('nt', b_N + b_Hasanta + b_T) = True then
    Exit; // N+T
  if Cnv('ns', b_N + b_Hasanta + b_S) = True then
    Exit; // N+S
  if Cnv('nc', b_NYA + b_Hasanta + b_C) = True then
    Exit; // NYA+C

  if Cnv('n', b_N) = True then
    Exit; // N
  if Cnv('N', b_Nn) = True then
    Exit; // N
end;

{ =============================================================================== }

function TEnglishToBangla.NextT: string;
begin
  NextT := MidStr(pEnglishText, pos + 1, 1);
end;

{ =============================================================================== }

function TEnglishToBangla.NextTEx(iLength: Integer; skipstart: Integer): string;
begin
  if iLength < 1 then
    iLength := 1;

  NextTEx := MidStr(pEnglishText, pos + skipstart + 1, iLength);
end;

{ =============================================================================== }

procedure TEnglishToBangla.O;
begin
  if Cnv('OI`', b_OIkar) = True then
    Exit; // OIKar
  if Cnv('OU`', b_OUkar) = True then
    Exit; // OUKar

  if Cnv('O`', b_Okar) = True then
    Exit; // OKar

  if (Consonent(PrevT) = False) or (Begining = True) then
  begin
    if Cnv('OI', b_OI) = True then
      Exit; // OI
    if Cnv('OU', b_OU) = True then
      Exit; // OU
    if Cnv('O', b_O) = True then
      Exit; // O
  end
  else
  begin
    if Cnv('OI', b_OIkar) = True then
      Exit; // OIKar
    if Cnv('OU', b_OUkar) = True then
      Exit; // OUKar
    if Cnv('O', b_Okar) = True then
      Exit; // OKar
  end;
end;

{ =============================================================================== }

procedure TEnglishToBangla.p;
begin
  if Cnv('phl', b_Ph + b_Hasanta + b_L) = True then
    Exit; // Ph+L

  if Cnv('pT', b_P + b_Hasanta + b_Tt) = True then
    Exit; // P+Tt
  if Cnv('pt', b_P + b_Hasanta + b_T) = True then
    Exit; // P+T
  if Cnv('pn', b_P + b_Hasanta + b_N) = True then
    Exit; // P+N
  if Cnv('pp', b_P + b_Hasanta + b_P) = True then
    Exit; // P+P
  if Cnv('pl', b_P + b_Hasanta + b_L) = True then
    Exit; // P+L
  if Cnv('ps', b_P + b_Hasanta + b_S) = True then
    Exit; // P+S
  if Cnv('ph', b_Ph) = True then
    Exit; // Ph
  if Cnv('fl', b_Ph + b_Hasanta + b_L) = True then
    Exit; // Ph+L

  if Cnv('f', b_Ph) = True then
    Exit; // Ph
  if Cnv('p', b_P) = True then
    Exit; // P
end;

{ =============================================================================== }

function TEnglishToBangla.PrevT: string;
var
  i: Integer;
begin

  i := pos - 1;
  if i < 1 then
  begin
    PrevT := '';
    Exit;
  end;

  PrevT := MidStr(pEnglishText, i, 1);
end;

{ =============================================================================== }

function TEnglishToBangla.PrevTEx(const Position: Integer): string;
var
  i: Integer;
begin
  i := pos - Position;
  if i < 1 then
  begin
    PrevTEx := '';
    Exit;
  end;

  PrevTEx := MidStr(pEnglishText, i, 1);
end;

{ =============================================================================== }

procedure TEnglishToBangla.R;
begin
  if NextTEx(1, 2) = '`' then
  begin
    if Cnv('rri', b_RRIkar) = True then
      Exit; // RRI-Kar
  end;

  if Consonent(PrevT) = False then
  begin
    if Cnv('rri', b_RRI) = True then
      Exit; // RRI
  end
  else if Begining = True then
  begin
    if Cnv('rri', b_RRI) = True then
      Exit; // RRI
  end
  else
  begin
    if Cnv('rri', b_RRIkar) = True then
      Exit; // RRI-Kar
  end;

  if (Consonent(PrevT) = False) and (Vowel(NextTEx(1, 1)) = False) and (NextTEx(1, 1) <> 'r') and (NextTEx(1, 1) <> '') then
  begin
    if Cnv('rr', b_R + b_Hasanta) = True then
      Exit; // Reph
  end;

  if Cnv('Rg', b_Rr + b_Hasanta + b_G) = True then
    Exit; // Rh+G
  if Cnv('Rh', b_Rrh) = True then
    Exit; // Rrh

  if (Consonent(PrevT) = True) and (PrevT <> 'r') and (PrevT <> 'y') and (PrevT <> 'w') and (PrevT <> 'x') and (PrevT <> 'Z') then
  begin
    if Cnv('r', b_Hasanta + b_R) = True then
      Exit; // R-Fola
  end
  else
  begin
    if Cnv('r', b_R) = True then
      Exit; // R
  end;

  if Cnv('R', b_Rr) = True then
    Exit; // Rh
end;

{ =============================================================================== }

procedure TEnglishToBangla.s;
begin
  if Cnv('shch', b_Sh + b_Hasanta + b_CH) = True then
    Exit; // Sh+Chh
  if Cnv('ShTh', b_Ss + b_Hasanta + b_Tth) = True then
    Exit; // Sh+Tth
  if Cnv('Shph', b_Ss + b_Hasanta + b_Ph) = True then
    Exit; // Sh+Ph

  if Cnv('Sch', b_Sh + b_Hasanta + b_CH) = True then
    Exit; // Sh+Chh
  if Cnv('skl', b_S + b_Hasanta + b_K + b_Hasanta + b_L) = True then
    Exit; // S+K+L
  if Cnv('skh', b_S + b_Hasanta + b_KH) = True then
    Exit; // S+Kh
  if Cnv('sth', b_S + b_Hasanta + b_Th) = True then
    Exit; // S+Th
  if Cnv('sph', b_S + b_Hasanta + b_Ph) = True then
    Exit; // S+Ph
  if Cnv('shc', b_Sh + b_Hasanta + b_C) = True then
    Exit; // Sh+C
  if Cnv('sht', b_Sh + b_Hasanta + b_T) = True then
    Exit; // Sh+T
  if Cnv('shn', b_Sh + b_Hasanta + b_N) = True then
    Exit; // Sh+N
  if Cnv('shm', b_Sh + b_Hasanta + b_M) = True then
    Exit; // Sh+M
  if Cnv('shl', b_Sh + b_Hasanta + b_L) = True then
    Exit; // Sh+L
  if Cnv('Shk', b_Ss + b_Hasanta + b_K) = True then
    Exit; // Sh+K
  if Cnv('ShT', b_Ss + b_Hasanta + b_Tt) = True then
    Exit; // Sh+Tt
  if Cnv('ShN', b_Ss + b_Hasanta + b_Nn) = True then
    Exit; // Sh+Nn
  if Cnv('Shp', b_Ss + b_Hasanta + b_P) = True then
    Exit; // Sh+P
  if Cnv('Shf', b_Ss + b_Hasanta + b_Ph) = True then
    Exit; // Sh+Ph
  if Cnv('Shm', b_Ss + b_Hasanta + b_M) = True then
    Exit; // Sh+M
  if Cnv('spl', b_S + b_Hasanta + b_P + b_Hasanta + b_L) = True then
    Exit; // s+p+l

  if Cnv('sk', b_S + b_Hasanta + b_K) = True then
    Exit; // S+K
  if Cnv('Sc', b_Sh + b_Hasanta + b_C) = True then
    Exit; // Sh+Ch
  if Cnv('sT', b_S + b_Hasanta + b_Tt) = True then
    Exit; // S+Tt
  if Cnv('st', b_S + b_Hasanta + b_T) = True then
    Exit; // S+T
  if Cnv('sn', b_S + b_Hasanta + b_N) = True then
    Exit; // S+N
  if Cnv('sp', b_S + b_Hasanta + b_P) = True then
    Exit; // S+P
  if Cnv('sf', b_S + b_Hasanta + b_Ph) = True then
    Exit; // S+Ph
  if Cnv('sm', b_S + b_Hasanta + b_M) = True then
    Exit; // S+M
  if Cnv('sl', b_S + b_Hasanta + b_L) = True then
    Exit; // S+L
  if Cnv('sh', b_Sh) = True then
    Exit; // Sh
  if Cnv('Sc', b_Sh + b_Hasanta + b_C) = True then
    Exit; // Sh+Ch
  if Cnv('St', b_Sh + b_Hasanta + b_T) = True then
    Exit; // Sh+T
  if Cnv('Sn', b_Sh + b_Hasanta + b_N) = True then
    Exit; // Sh+N
  if Cnv('Sm', b_Sh + b_Hasanta + b_M) = True then
    Exit; // Sh+M
  if Cnv('Sl', b_Sh + b_Hasanta + b_L) = True then
    Exit; // Sh+L
  if Cnv('Sh', b_Ss) = True then
    Exit; // Sh

  if Cnv('s', b_S) = True then
    Exit; // S
  if Cnv('S', b_Sh) = True then
    Exit; // Sh
end;

{ =============================================================================== }

procedure TEnglishToBangla.smallO;
begin
  if ((Consonent(PrevT) = False) or (Begining = True)) and (NextT <> '`') then
  begin
    if Cnv('oo', b_U) = True then
      Exit; // U
    if Cnv('oZ', b_A + b_Hasanta + b_Z) = True then
      Exit; // U

    if (Vowel(PrevT) = True) and (PrevT <> 'o') then
    begin
      if Cnv('o', b_O) = True then
        Exit; // O
    end
    else if Cnv('o', b_A) = True then
      Exit; // A
  end;

  if Cnv('oo', b_Ukar) = True then
    Exit; // U Kar
  if Cnv('o`', '') = True then
    Exit; // Nothing
  if Cnv('o', '') = True then
    Exit; // Nothing
end;

{ =============================================================================== }

procedure TEnglishToBangla.T;
begin
  if Cnv('tth', b_T + b_Hasanta + b_Th) = True then
    Exit; // T+Th
  if Cnv('t``', b_Khandatta) = True then
    Exit; // Khandatta

  if Cnv('TT', b_Tt + b_Hasanta + b_Tt) = True then
    Exit; // Tt+Tt
  if Cnv('Tm', b_Tt + b_Hasanta + b_M) = True then
    Exit; // Tt+M
  if Cnv('Th', b_Tth) = True then
    Exit; // Tth
  if Cnv('tn', b_T + b_Hasanta + b_N) = True then
    Exit; // T+N
  if Cnv('tm', b_T + b_Hasanta + b_M) = True then
    Exit; // T+M
  if Cnv('th', b_Th) = True then
    Exit; // Th
  if Cnv('tt', b_T + b_Hasanta + b_T) = True then
    Exit; // T+T

  if Cnv('T', b_Tt) = True then
    Exit; // Tt
  if Cnv('t', b_T) = True then
    Exit; // T
end;

{ =============================================================================== }

{$HINTS Off}

function TEnglishToBangla.Vowel(const T: string): Boolean;
var
  myT: string;
begin
  Result := False;
  myT := LowerCase(T);
  if length(myT) > 0 then
    myT := myT[1];
  if (myT = 'a') or (myT = 'e') or (myT = 'i') or (myT = 'o') or (myT = 'u') then
    Result := True
  else
    Result := False;

end;

function TEnglishToBangla.Number(const T: string): Boolean;
var
  temp: Char;
  myT:  string;
begin
  Result := False;
  myT := LowerCase(T);
  temp := #0;
  if length(myT) > 0 then
    temp := myT[1];

  case temp of
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
      Number := True;
    else
      Number := False;
  end;
end;

{$HINTS On}

end.
