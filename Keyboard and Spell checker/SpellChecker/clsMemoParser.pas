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

Unit clsMemoParser;

Interface

Type
        // Event types
        // --------------------------------------------------------------
        TTotalProgress = Procedure(FCurrentProgress: Integer) Of Object;
        TWordFound = Procedure(FCurrentWord: String) Of Object;
        TCompleteParsing = Procedure Of Object;
        TPositionConflict = Procedure Of Object;

Type
        TMemoParser = Class
        Private
                CurrentLine: LongInt;
                LinePos: Integer;
                SelStart: LongInt;
                SelLength: LongInt;
                ValidChars_B: String;
                FStopPursing: Boolean;

                // --------------------------------------------------------------
                // Event types
                FTotalProgress: TTotalProgress;
                FWordFound: TWordFound;
                FCompleteParsing: TCompleteParsing;
                FPositionComflict: TPositionConflict;

        Public
                Constructor Create;
                Procedure BeginPursing;
                Procedure PausePursing;
                Procedure SelectWord;
                Procedure ResetAll;
                Procedure ReplaceCurrentWord(Const rWord: String;
                  Const PrevWord: String);

                // event properties
                Property OnTotalProgress: TTotalProgress Read FTotalProgress
                  Write FTotalProgress;
                Property OnWordFound: TWordFound Read FWordFound
                  Write FWordFound;
                Property OnCompleteParsing: TCompleteParsing
                  Read FCompleteParsing Write FCompleteParsing;
                Property OnPositionConflict: TPositionConflict
                  Read FPositionComflict Write FPositionComflict;
        End;

Implementation

Uses
        ufrmSpell,
        Banglachars,
        SysUtils,
        StrUtils,
        Messages,
        Windows;

{ TMemoParser }

Constructor TMemoParser.Create;
Begin
        ResetAll;
        FTotalProgress := Nil;
        FWordFound := Nil;
        FCompleteParsing := Nil;
        ValidChars_B := b_0 + b_1 + b_2 + b_3 + b_4 + b_5 + b_6 + b_7 +
          b_8 + b_9 +

          b_A + b_AA + b_AAkar + b_I + b_II + b_IIkar + b_Ikar + b_U + b_Ukar +
          b_UU + b_UUkar + b_RRI + b_RRIkar + b_E + b_Ekar + b_O + b_OI +
          b_OIkar + b_Okar + b_OU + b_OUkar +

          b_Anushar + b_B + b_Bh + b_Bisharga + b_C + b_CH + b_Chandra + b_D +
          b_Dd + b_Ddh + b_Dh + b_G + b_GH + b_H + b_J + b_JH + b_K + b_KH + b_L
          + b_M + b_N + b_NGA + b_Nn + b_NYA + b_P + b_Ph + b_R + b_Rr + b_Rrh +
          b_S + b_Sh + b_Ss + b_T + b_Th + b_Tt + b_Tth + b_Y + b_Z + AssamRa +
          AssamVa + b_Khandatta +

          b_Hasanta + b_Taka + ZWJ + ZWNJ + b_Vocalic_L + b_Vocalic_LL +
          b_Vocalic_RR + b_Vocalic_RR_Kar + b_Vocalic_L_Kar + b_Vocalic_LL_Kar +
          b_Nukta + b_Avagraha + b_LengthMark + b_RupeeMark +
          b_CurrencyNumerator1 + b_CurrencyNumerator2 + b_CurrencyNumerator3 +
          b_CurrencyNumerator4 + b_CurrencyNumerator1LessThanDenominator +
          b_CurrencyDenominator16 + b_CurrencyEsshar;
End;

Procedure TMemoParser.PausePursing;
Begin
        FStopPursing := True;
End;

Procedure TMemoParser.BeginPursing;
Var
        LineText: String;
        TotalLines: Integer;
        CurrentWord: String;
Begin
        CurrentWord := '';
        FStopPursing := False;
        TotalLines := frmSpell.MEMO.Lines.Count - 1;

        If CurrentLine > (TotalLines + 1) Then
        Begin
                If Assigned(FPositionComflict) Then
                        FPositionComflict;
                Exit;
        End;

        While CurrentLine <= TotalLines Do
        Begin

                If FStopPursing = True Then
                        Exit;

                If Assigned(FTotalProgress) Then
                        FTotalProgress(((CurrentLine + 1) * 100)
                          Div (TotalLines + 1));

                LineText := frmSpell.MEMO.Lines[CurrentLine];

                While LinePos + 1 <= Length(LineText) Do
                Begin

                        If FStopPursing = True Then
                                Exit;

                        inc(LinePos);

                        If pos(LineText[LinePos], ValidChars_B) > 0 Then
                        Begin
                                If CurrentWord = '' Then
                                        SelStart := LinePos;
                                CurrentWord := CurrentWord + LineText[LinePos];
                        End
                        Else
                        Begin
                                If CurrentWord <> '' Then
                                Begin
                                        If Assigned(FWordFound) Then
                                        Begin
                                        SelLength := Length(CurrentWord);
                                        FWordFound(CurrentWord);
                                        CurrentWord := '';
                                        Exit;
                                        End;
                                End;
                        End;
                End;

                If CurrentWord <> '' Then
                Begin
                        If Assigned(FWordFound) Then
                        Begin
                                SelLength := Length(CurrentWord);
                                FWordFound(CurrentWord);
                                CurrentWord := '';
                                Exit;
                        End;
                End;

                inc(CurrentLine);
                LinePos := 0;
        End;

        If Assigned(FCompleteParsing) Then
                FCompleteParsing;
End;

Procedure TMemoParser.ReplaceCurrentWord(Const rWord: String;
  Const PrevWord: String);
Begin
        frmSpell.MEMO.SelStart := frmSpell.MEMO.Perform(EM_LINEINDEX,
          CurrentLine, 0) + SelStart - 1;
        frmSpell.MEMO.SelLength := SelLength;

        If frmSpell.MEMO.SelText <> PrevWord Then
        Begin
                If Assigned(FPositionComflict) Then
                        FPositionComflict;
                Exit;
        End;

        frmSpell.MEMO.SelText := rWord;

        If Length(rWord) < SelLength Then
        Begin
                LinePos := LinePos - (SelLength - Length(rWord));
                SelLength := Length(rWord);
        End
        Else If Length(rWord) > SelLength Then
        Begin
                LinePos := LinePos + (Length(rWord) - SelLength);
                SelLength := Length(rWord);
        End;

End;

Procedure TMemoParser.ResetAll;
Begin
        SelStart := 0;
        SelLength := 0;
        CurrentLine := 0;
        LinePos := 0;
        FStopPursing := False;
End;

Procedure TMemoParser.SelectWord;
Begin
        frmSpell.MEMO.SelStart := frmSpell.MEMO.Perform(EM_LINEINDEX,
          CurrentLine, 0) + SelStart - 1;
        frmSpell.MEMO.SelLength := SelLength;
        frmSpell.MEMO.Perform(EM_SCROLLCARET, 0, 0);
End;

End.
