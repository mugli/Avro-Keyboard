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

Unit clsReversePhonetic;

Interface

Uses
  SysUtils,
  StrUtils;

Type
  TReversePhonetic = Class
  Private
    ln: Integer; // Length of Bangla String
    ipos: Integer; // Position of processing at Bangla string
    fBanglaText: String;

    Function WipeInvalidChars(input: String): String;
    Function NextT: String;
    Function NextTEx(iLength: Integer; skipstart: Integer = 0): String;
  Public
    Function Convert(Const BanglaT: String): String;
  End;

Implementation

Uses
  BanglaChars;

{ TReversePhonetic }

Function TReversePhonetic.Convert(Const BanglaT: String): String;
Var
  T: Char;
Begin
  fBanglaText := WipeInvalidChars(BanglaT);
  ln := Length(fBanglaText);
  Result := '';

  If ln <= 0 Then
    exit;
  ipos := 1;
  Repeat
    T := BanglaT[ipos];

    { Numbers }
    If T = b_0 Then
    Begin
      Result := Result + '0';
      Inc(ipos);
    End
    Else If T = b_1 Then
    Begin
      Result := Result + '1';
      Inc(ipos);
    End
    Else If T = b_2 Then
    Begin
      Result := Result + '2';
      Inc(ipos);
    End
    Else If T = b_3 Then
    Begin
      Result := Result + '3';
      Inc(ipos);
    End
    Else If T = b_4 Then
    Begin
      Result := Result + '4';
      Inc(ipos);
    End
    Else If T = b_5 Then
    Begin
      Result := Result + '5';
      Inc(ipos);
    End
    Else If T = b_6 Then
    Begin
      Result := Result + '6';
      Inc(ipos);
    End
    Else If T = b_7 Then
    Begin
      Result := Result + '7';
      Inc(ipos);
    End
    Else If T = b_8 Then
    Begin
      Result := Result + '8';
      Inc(ipos);
    End
    Else If T = b_9 Then
    Begin
      Result := Result + '9';
      Inc(ipos);
    End

    { vowels }
    Else If (T = b_A) Or (T = b_O) Or (T = b_OKar) Then
    Begin
      If (T = b_A) And (NextT = b_aakar) Then
      Begin
        Result := Result + 'a';
        ipos := ipos + 2;
      End
      Else
      Begin
        Result := Result + 'o';
        Inc(ipos);
      End;
    End
    Else If (T = b_I) Or (T = b_II) Or (T = b_IKar) Or (T = b_IIKar) Then
    Begin
      Result := Result + 'i';
      Inc(ipos);
    End
    Else If (T = b_u) Or (T = b_uu) Or (T = b_uKar) Or (T = b_uuKar) Then
    Begin
      Result := Result + 'u';
      Inc(ipos);
    End
    Else If (T = b_rri) Or (T = b_rrikar) Then
    Begin
      Result := Result + 'ri';
      Inc(ipos);
    End
    Else If (T = b_e) Or (T = b_ekar) Then
    Begin
      Result := Result + 'e';
      Inc(ipos);
    End
    Else If (T = b_oi) Or (T = b_oikar) Then
    Begin
      Result := Result + 'oi';
      Inc(ipos);
    End
    Else If (T = b_ou) Or (T = b_oukar) Then
    Begin
      Result := Result + 'ou';
      Inc(ipos);
    End
    Else If (T = b_aa) Or (T = b_aakar) Then
    Begin
      Result := Result + 'a';
      Inc(ipos);
    End

    { consonants }
    Else If T = b_k Then
    Begin
      If NextTEx(2) = b_hasanta + b_SS Then
      Begin
        Result := Result + 'kh';
        ipos := ipos + 3;
      End
      Else
      Begin
        Result := Result + 'k';
        Inc(ipos);
      End;
    End
    Else If (T = b_Kh) Then
    Begin
      Result := Result + 'kh';
      Inc(ipos);
    End
    Else If (T = b_g) Then
    Begin
      Result := Result + 'g';
      Inc(ipos);
    End
    Else If (T = b_gh) Then
    Begin
      Result := Result + 'gh';
      Inc(ipos);
    End
    Else If (T = b_n) Or (T = b_nn) Or (T = b_nga) Or (T = b_nya) Or
      (T = b_anushar) Then
    Begin
      Result := Result + 'n';
      Inc(ipos);
    End
    Else If (T = b_c) Or (T = b_ch) Then
    Begin
      Result := Result + 'c';
      Inc(ipos);
    End
    Else If (T = b_j) Or (T = b_z) Then
    Begin
      If NextTEx(2) = b_hasanta + b_nya Then
      Begin
        Result := Result + 'gg';
        ipos := ipos + 3;
      End
      Else
      Begin
        Result := Result + 'z';
        Inc(ipos);
      End;
    End
    Else If (T = b_jh) Then
    Begin
      Result := Result + 'jh';
      Inc(ipos);
    End
    Else If (T = b_t) Or (T = b_tt) Or (T = b_khandatta) Then
    Begin
      Result := Result + 't';
      Inc(ipos);
    End
    Else If (T = b_th) Or (T = b_tth) Then
    Begin
      Result := Result + 'th';
      Inc(ipos);
    End
    Else If (T = b_d) Or (T = b_dd) Then
    Begin
      Result := Result + 'd';
      Inc(ipos);
    End
    Else If (T = b_dh) Or (T = b_ddh) Then
    Begin
      Result := Result + 'dh';
      Inc(ipos);
    End
    Else If (T = b_p) Then
    Begin
      Result := Result + 'p';
      Inc(ipos);
    End
    Else If (T = b_ph) Then
    Begin
      Result := Result + 'ph';
      Inc(ipos);
    End
    Else If (T = b_b) Then
    Begin
      Result := Result + 'b';
      Inc(ipos);
    End
    Else If (T = b_bh) Then
    Begin
      Result := Result + 'bh';
      Inc(ipos);
    End
    Else If (T = b_m) Then
    Begin
      Result := Result + 'm';
      Inc(ipos);
    End
    Else If (T = b_r) Or (T = b_rr) Or (T = b_rrh) Then
    Begin
      Result := Result + 'r';
      Inc(ipos);
    End
    Else If (T = b_l) Then
    Begin
      Result := Result + 'l';
      Inc(ipos);
    End
    Else If (T = b_s) Or (T = b_sh) Or (T = b_SS) Then
    Begin
      Result := Result + 's';
      Inc(ipos);
    End
    Else If (T = b_h) Then
    Begin
      Result := Result + 'h';
      Inc(ipos);
    End
    Else If (T = b_y) Then
    Begin
      Result := Result + 'y';
      Inc(ipos);
    End
    Else If (T = b_hasanta) Then
    Begin
      If (NextTEx(1, 1) <> b_hasanta) And
        ((NextT = b_z) Or (NextT = b_m) Or (NextT = b_b)) Then
        // B/M/Z-fola
        ipos := ipos + 2
      Else
        Inc(ipos);
    End
    Else
    Begin
      Inc(ipos);
    End;

  Until (ipos > ln);
End;

Function TReversePhonetic.NextT: String;
Begin
  NextT := MidStr(fBanglaText, ipos + 1, 1);
End;

Function TReversePhonetic.NextTEx(iLength, skipstart: Integer): String;
Begin
  If iLength < 1 Then
    iLength := 1;

  NextTEx := MidStr(fBanglaText, ipos + skipstart + 1, iLength);
End;

Function TReversePhonetic.WipeInvalidChars(input: String): String;
Begin
  Result := input;
End;

End.
