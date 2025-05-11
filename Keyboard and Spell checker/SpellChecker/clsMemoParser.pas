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

unit clsMemoParser;

interface

type
  // Event types
  // --------------------------------------------------------------
  TTotalProgress    = procedure(FCurrentProgress: Integer) of object;
  TWordFound        = procedure(FCurrentWord: string) of object;
  TCompleteParsing  = procedure of object;
  TPositionConflict = procedure of object;

type
  TMemoParser = class
    private
      CurrentLine:  LongInt;
      LinePos:      Integer;
      SelStart:     LongInt;
      SelLength:    LongInt;
      ValidChars_B: string;
      FStopPursing: Boolean;

      // --------------------------------------------------------------
      // Event types
      FTotalProgress:    TTotalProgress;
      FWordFound:        TWordFound;
      FCompleteParsing:  TCompleteParsing;
      FPositionComflict: TPositionConflict;

    public
      constructor Create;
      procedure BeginPursing;
      procedure PausePursing;
      procedure SelectWord;
      procedure ResetAll;
      procedure ReplaceCurrentWord(const rWord: string; const PrevWord: string);

      // event properties
      property OnTotalProgress: TTotalProgress read FTotalProgress write FTotalProgress;
      property OnWordFound: TWordFound read FWordFound write FWordFound;
      property OnCompleteParsing: TCompleteParsing read FCompleteParsing write FCompleteParsing;
      property OnPositionConflict: TPositionConflict read FPositionComflict write FPositionComflict;
  end;

implementation

uses
  ufrmSpell,
  Banglachars,
  SysUtils,
  StrUtils,
  Messages,
  Windows;

{ TMemoParser }

constructor TMemoParser.Create;
begin
  ResetAll;
  FTotalProgress := nil;
  FWordFound := nil;
  FCompleteParsing := nil;
  ValidChars_B := b_0 + b_1 + b_2 + b_3 + b_4 + b_5 + b_6 + b_7 + b_8 + b_9 +

    b_A + b_AA + b_AAkar + b_I + b_II + b_IIkar + b_Ikar + b_U + b_Ukar + b_UU + b_UUkar + b_RRI + b_RRIkar + b_E + b_Ekar + b_O + b_OI + b_OIkar + b_Okar +
    b_OU + b_OUkar +

    b_Anushar + b_B + b_Bh + b_Bisharga + b_C + b_CH + b_Chandra + b_D + b_Dd + b_Ddh + b_Dh + b_G + b_GH + b_H + b_J + b_JH + b_K + b_KH + b_L + b_M + b_N +
    b_NGA + b_Nn + b_NYA + b_P + b_Ph + b_R + b_Rr + b_Rrh + b_S + b_Sh + b_Ss + b_T + b_Th + b_Tt + b_Tth + b_Y + b_Z + AssamRa + AssamVa + b_Khandatta +

    b_Hasanta + b_Taka + ZWJ + ZWNJ + b_Vocalic_L + b_Vocalic_LL + b_Vocalic_RR + b_Vocalic_RR_Kar + b_Vocalic_L_Kar + b_Vocalic_LL_Kar + b_Nukta + b_Avagraha +
    b_LengthMark + b_RupeeMark + b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 + b_CurrencyNumerator4 +
    b_CurrencyNumerator1LessThanDenominator + b_CurrencyDenominator16 + b_CurrencyEsshar;
end;

procedure TMemoParser.PausePursing;
begin
  FStopPursing := True;
end;

procedure TMemoParser.BeginPursing;
var
  LineText:    string;
  TotalLines:  Integer;
  CurrentWord: string;
begin
  CurrentWord := '';
  FStopPursing := False;
  TotalLines := frmSpell.MEMO.Lines.Count - 1;

  if CurrentLine > (TotalLines + 1) then
  begin
    if Assigned(FPositionComflict) then
      FPositionComflict;
    Exit;
  end;

  while CurrentLine <= TotalLines do
  begin

    if FStopPursing = True then
      Exit;

    if Assigned(FTotalProgress) then
      FTotalProgress(((CurrentLine + 1) * 100) div (TotalLines + 1));

    LineText := frmSpell.MEMO.Lines[CurrentLine];

    while LinePos + 1 <= Length(LineText) do
    begin

      if FStopPursing = True then
        Exit;

      inc(LinePos);

      if pos(LineText[LinePos], ValidChars_B) > 0 then
      begin
        if CurrentWord = '' then
          SelStart := LinePos;
        CurrentWord := CurrentWord + LineText[LinePos];
      end
      else
      begin
        if CurrentWord <> '' then
        begin
          if Assigned(FWordFound) then
          begin
            SelLength := Length(CurrentWord);
            FWordFound(CurrentWord);
            CurrentWord := '';
            Exit;
          end;
        end;
      end;
    end;

    if CurrentWord <> '' then
    begin
      if Assigned(FWordFound) then
      begin
        SelLength := Length(CurrentWord);
        FWordFound(CurrentWord);
        CurrentWord := '';
        Exit;
      end;
    end;

    inc(CurrentLine);
    LinePos := 0;
  end;

  if Assigned(FCompleteParsing) then
    FCompleteParsing;
end;

procedure TMemoParser.ReplaceCurrentWord(const rWord: string; const PrevWord: string);
begin
  frmSpell.MEMO.SelStart := frmSpell.MEMO.Perform(EM_LINEINDEX, CurrentLine, 0) + SelStart - 1;
  frmSpell.MEMO.SelLength := SelLength;

  if frmSpell.MEMO.SelText <> PrevWord then
  begin
    if Assigned(FPositionComflict) then
      FPositionComflict;
    Exit;
  end;

  frmSpell.MEMO.SelText := rWord;

  if Length(rWord) < SelLength then
  begin
    LinePos := LinePos - (SelLength - Length(rWord));
    SelLength := Length(rWord);
  end
  else if Length(rWord) > SelLength then
  begin
    LinePos := LinePos + (Length(rWord) - SelLength);
    SelLength := Length(rWord);
  end;

end;

procedure TMemoParser.ResetAll;
begin
  SelStart := 0;
  SelLength := 0;
  CurrentLine := 0;
  LinePos := 0;
  FStopPursing := False;
end;

procedure TMemoParser.SelectWord;
begin
  frmSpell.MEMO.SelStart := frmSpell.MEMO.Perform(EM_LINEINDEX, CurrentLine, 0) + SelStart - 1;
  frmSpell.MEMO.SelLength := SelLength;
  frmSpell.MEMO.Perform(EM_SCROLLCARET, 0, 0);
end;

end.
