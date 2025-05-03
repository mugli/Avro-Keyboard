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
  Mehdi Hasan Khan <mhasan@omicronlab.com>.

  Copyright (C) OmicronLab <https://www.omicronlab.com>. All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
Unit uShapeInterceptor;

Interface

Uses
        Windows,
        SysUtils,
        Classes,
        Controls,
        Graphics,
        Dialogs,
        ToolWin,
        StdCtrls,
        ExtCtrls;

Type
        TShape = Class(ExtCtrls.TShape)
        Private
                fSelected: Boolean;
                fKeyName: String;
                fCaptionNormal: String;
                fCaptionShift: String;
                fNormal: String;
                fShift: String;
                fAltGr: String;
                fShiftAltGr: String;

                Procedure SetSelected(Const Value: Boolean);
                Procedure SetKeyName(Const Value: String);
                Procedure SetCaptionNormal(Const Value: String);
                Procedure SetCaptionShift(Const Value: String);
                Procedure SetNormal(Const Value: String);
                Procedure SetShift(Const Value: String);
                Procedure SetAltGr(Const Value: String);
                Procedure SetShiftAltGr(Const Value: String);
        Public

        Published
                Property Selected: Boolean Read fSelected Write SetSelected;
                Property KeyName: String Read fKeyName Write SetKeyName;
                Property CaptionNormal: String Read fCaptionNormal
                  Write SetCaptionNormal;
                Property CaptionShift: String Read fCaptionShift
                  Write SetCaptionShift;
                Property Normal: String Read fNormal Write SetNormal;
                Property Shift: String Read fShift Write SetShift;
                Property AltGr: String Read fAltGr Write SetAltGr;
                Property ShiftAltGr: String Read fShiftAltGr
                  Write SetShiftAltGr;
        End;

Implementation

{ TShape }

Procedure TShape.SetCaptionNormal(Const Value: String);
Begin
        fCaptionNormal := Value;
End;

Procedure TShape.SetCaptionShift(Const Value: String);
Begin
        fCaptionShift := Value;
End;

Procedure TShape.SetKeyName(Const Value: String);
Begin
        fKeyName := Value;
End;

Procedure TShape.SetNormal(Const Value: String);
Begin
        fNormal := Value;
End;

Procedure TShape.SetSelected(Const Value: Boolean);
Begin
        fSelected := Value;
        If fSelected = True Then
        Begin
                If self.Brush.Color <> clYellow Then
                        self.Brush.Color := clYellow;
                If self.Brush.Style <> bsFDiagonal Then
                        self.Brush.Style := bsFDiagonal;
        End
        Else
        Begin
                If self.Brush.Color <> clYellow Then
                        self.Brush.Color := clYellow;
                If self.Brush.Style <> bsClear Then
                        self.Brush.Style := bsClear;
        End;

End;

Procedure TShape.SetShift(Const Value: String);
Begin
        fShift := Value;
End;

Procedure TShape.SetAltGr(Const Value: String);
Begin
        fAltGr := Value;
End;

Procedure TShape.SetShiftAltGr(Const Value: String);
Begin
        fShiftAltGr := Value;
End;

End.
