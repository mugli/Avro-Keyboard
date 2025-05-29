{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit uShapeInterceptor;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Graphics,
  Dialogs,
  ToolWin,
  StdCtrls,
  ExtCtrls;

type
  TShape = class(ExtCtrls.TShape)
    private
      fSelected:      Boolean;
      fKeyName:       string;
      fCaptionNormal: string;
      fCaptionShift:  string;
      fNormal:        string;
      fShift:         string;
      fAltGr:         string;
      fShiftAltGr:    string;

      procedure SetSelected(const Value: Boolean);
      procedure SetKeyName(const Value: string);
      procedure SetCaptionNormal(const Value: string);
      procedure SetCaptionShift(const Value: string);
      procedure SetNormal(const Value: string);
      procedure SetShift(const Value: string);
      procedure SetAltGr(const Value: string);
      procedure SetShiftAltGr(const Value: string);
    public

    published
      property Selected:      Boolean read fSelected write SetSelected;
      property KeyName:       string read fKeyName write SetKeyName;
      property CaptionNormal: string read fCaptionNormal write SetCaptionNormal;
      property CaptionShift:  string read fCaptionShift write SetCaptionShift;
      property Normal:        string read fNormal write SetNormal;
      property Shift:         string read fShift write SetShift;
      property AltGr:         string read fAltGr write SetAltGr;
      property ShiftAltGr:    string read fShiftAltGr write SetShiftAltGr;
  end;

implementation

{ TShape }

procedure TShape.SetCaptionNormal(const Value: string);
begin
  fCaptionNormal := Value;
end;

procedure TShape.SetCaptionShift(const Value: string);
begin
  fCaptionShift := Value;
end;

procedure TShape.SetKeyName(const Value: string);
begin
  fKeyName := Value;
end;

procedure TShape.SetNormal(const Value: string);
begin
  fNormal := Value;
end;

procedure TShape.SetSelected(const Value: Boolean);
begin
  fSelected := Value;
  if fSelected = True then
  begin
    if self.Brush.Color <> clYellow then
      self.Brush.Color := clYellow;
    if self.Brush.Style <> bsFDiagonal then
      self.Brush.Style := bsFDiagonal;
  end
  else
  begin
    if self.Brush.Color <> clYellow then
      self.Brush.Color := clYellow;
    if self.Brush.Style <> bsClear then
      self.Brush.Style := bsClear;
  end;

end;

procedure TShape.SetShift(const Value: string);
begin
  fShift := Value;
end;

procedure TShape.SetAltGr(const Value: string);
begin
  fAltGr := Value;
end;

procedure TShape.SetShiftAltGr(const Value: string);
begin
  fShiftAltGr := Value;
end;

end.
