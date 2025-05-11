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

unit clsReversePhonetic;

interface

uses
  SysUtils,
  StrUtils;

type
  TReversePhonetic = class
    private
      ln:          Integer; // Length of Bangla String
      ipos:        Integer; // Position of processing at Bangla string
      fBanglaText: string;

      function WipeInvalidChars(input: string): string;
      function NextT: string;
      function NextTEx(iLength: Integer; skipstart: Integer = 0): string;
    public
      function Convert(const BanglaT: string): string;
  end;

implementation

uses
  BanglaChars;

{ TReversePhonetic }

function TReversePhonetic.Convert(const BanglaT: string): string;
var
  T: Char;
begin
  fBanglaText := WipeInvalidChars(BanglaT);
  ln := Length(fBanglaText);
  Result := '';

  if ln <= 0 then
    exit;
  ipos := 1;
  repeat
    T := BanglaT[ipos];

    { Numbers }
    if T = b_0 then
    begin
      Result := Result + '0';
      Inc(ipos);
    end
    else if T = b_1 then
    begin
      Result := Result + '1';
      Inc(ipos);
    end
    else if T = b_2 then
    begin
      Result := Result + '2';
      Inc(ipos);
    end
    else if T = b_3 then
    begin
      Result := Result + '3';
      Inc(ipos);
    end
    else if T = b_4 then
    begin
      Result := Result + '4';
      Inc(ipos);
    end
    else if T = b_5 then
    begin
      Result := Result + '5';
      Inc(ipos);
    end
    else if T = b_6 then
    begin
      Result := Result + '6';
      Inc(ipos);
    end
    else if T = b_7 then
    begin
      Result := Result + '7';
      Inc(ipos);
    end
    else if T = b_8 then
    begin
      Result := Result + '8';
      Inc(ipos);
    end
    else if T = b_9 then
    begin
      Result := Result + '9';
      Inc(ipos);
    end

    { vowels }
    else if (T = b_A) or (T = b_O) or (T = b_OKar) then
    begin
      if (T = b_A) and (NextT = b_aakar) then
      begin
        Result := Result + 'a';
        ipos := ipos + 2;
      end
      else
      begin
        Result := Result + 'o';
        Inc(ipos);
      end;
    end
    else if (T = b_I) or (T = b_II) or (T = b_IKar) or (T = b_IIKar) then
    begin
      Result := Result + 'i';
      Inc(ipos);
    end
    else if (T = b_u) or (T = b_uu) or (T = b_uKar) or (T = b_uuKar) then
    begin
      Result := Result + 'u';
      Inc(ipos);
    end
    else if (T = b_rri) or (T = b_rrikar) then
    begin
      Result := Result + 'ri';
      Inc(ipos);
    end
    else if (T = b_e) or (T = b_ekar) then
    begin
      Result := Result + 'e';
      Inc(ipos);
    end
    else if (T = b_oi) or (T = b_oikar) then
    begin
      Result := Result + 'oi';
      Inc(ipos);
    end
    else if (T = b_ou) or (T = b_oukar) then
    begin
      Result := Result + 'ou';
      Inc(ipos);
    end
    else if (T = b_aa) or (T = b_aakar) then
    begin
      Result := Result + 'a';
      Inc(ipos);
    end

    { consonants }
    else if T = b_k then
    begin
      if NextTEx(2) = b_hasanta + b_SS then
      begin
        Result := Result + 'kh';
        ipos := ipos + 3;
      end
      else
      begin
        Result := Result + 'k';
        Inc(ipos);
      end;
    end
    else if (T = b_Kh) then
    begin
      Result := Result + 'kh';
      Inc(ipos);
    end
    else if (T = b_g) then
    begin
      Result := Result + 'g';
      Inc(ipos);
    end
    else if (T = b_gh) then
    begin
      Result := Result + 'gh';
      Inc(ipos);
    end
    else if (T = b_n) or (T = b_nn) or (T = b_nga) or (T = b_nya) or (T = b_anushar) then
    begin
      Result := Result + 'n';
      Inc(ipos);
    end
    else if (T = b_c) or (T = b_ch) then
    begin
      Result := Result + 'c';
      Inc(ipos);
    end
    else if (T = b_j) or (T = b_z) then
    begin
      if NextTEx(2) = b_hasanta + b_nya then
      begin
        Result := Result + 'gg';
        ipos := ipos + 3;
      end
      else
      begin
        Result := Result + 'z';
        Inc(ipos);
      end;
    end
    else if (T = b_jh) then
    begin
      Result := Result + 'jh';
      Inc(ipos);
    end
    else if (T = b_t) or (T = b_tt) or (T = b_khandatta) then
    begin
      Result := Result + 't';
      Inc(ipos);
    end
    else if (T = b_th) or (T = b_tth) then
    begin
      Result := Result + 'th';
      Inc(ipos);
    end
    else if (T = b_d) or (T = b_dd) then
    begin
      Result := Result + 'd';
      Inc(ipos);
    end
    else if (T = b_dh) or (T = b_ddh) then
    begin
      Result := Result + 'dh';
      Inc(ipos);
    end
    else if (T = b_p) then
    begin
      Result := Result + 'p';
      Inc(ipos);
    end
    else if (T = b_ph) then
    begin
      Result := Result + 'ph';
      Inc(ipos);
    end
    else if (T = b_b) then
    begin
      Result := Result + 'b';
      Inc(ipos);
    end
    else if (T = b_bh) then
    begin
      Result := Result + 'bh';
      Inc(ipos);
    end
    else if (T = b_m) then
    begin
      Result := Result + 'm';
      Inc(ipos);
    end
    else if (T = b_r) or (T = b_rr) or (T = b_rrh) then
    begin
      Result := Result + 'r';
      Inc(ipos);
    end
    else if (T = b_l) then
    begin
      Result := Result + 'l';
      Inc(ipos);
    end
    else if (T = b_s) or (T = b_sh) or (T = b_SS) then
    begin
      Result := Result + 's';
      Inc(ipos);
    end
    else if (T = b_h) then
    begin
      Result := Result + 'h';
      Inc(ipos);
    end
    else if (T = b_y) then
    begin
      Result := Result + 'y';
      Inc(ipos);
    end
    else if (T = b_hasanta) then
    begin
      if (NextTEx(1, 1) <> b_hasanta) and ((NextT = b_z) or (NextT = b_m) or (NextT = b_b)) then
        // B/M/Z-fola
        ipos := ipos + 2
      else
        Inc(ipos);
    end
    else
    begin
      Inc(ipos);
    end;

  until (ipos > ln);
end;

function TReversePhonetic.NextT: string;
begin
  NextT := MidStr(fBanglaText, ipos + 1, 1);
end;

function TReversePhonetic.NextTEx(iLength, skipstart: Integer): string;
begin
  if iLength < 1 then
    iLength := 1;

  NextTEx := MidStr(fBanglaText, ipos + skipstart + 1, iLength);
end;

function TReversePhonetic.WipeInvalidChars(input: string): string;
begin
  Result := input;
end;

end.
