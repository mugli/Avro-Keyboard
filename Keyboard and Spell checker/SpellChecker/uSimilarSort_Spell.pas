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

unit uSimilarSort_Spell;

interface

uses
  Classes,
  uSpellEditDistanceSearch,
  clsReversePhonetic,
  SysUtils;

const
  PhoneticWeight = 9;
  ManualWeight   = 1;

procedure SimilarSort(SourceS: string; var WList: TStringList);
function MyCustomSort(List: TStringList; Index1, Index2: Integer): Integer;

var
  SourceCompareS: string;
  RP:             TReversePhonetic;

implementation

function MyCustomSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  SRP, i1Rp, i2RP: string;
begin
  SRP := RP.Convert(SourceCompareS);
  i1Rp := RP.Convert(List[Index1]);
  i2RP := RP.Convert(List[Index2]);
  if ((EditDistance(SourceCompareS, List[Index1]) * ManualWeight) + (EditDistance(SRP, i1Rp) * PhoneticWeight)) <
    ((EditDistance(SourceCompareS, List[Index2]) * ManualWeight) + (EditDistance(SRP, i2RP) * PhoneticWeight)) then
    Result := -1
  else if ((EditDistance(SourceCompareS, List[Index1]) * ManualWeight) + (EditDistance(SRP, i1Rp) * PhoneticWeight)) >
    ((EditDistance(SourceCompareS, List[Index2]) * ManualWeight) + (EditDistance(SRP, i2RP) * PhoneticWeight)) then
    Result := 1
  else
    Result := 0;
end;

procedure SimilarSort(SourceS: string; var WList: TStringList);
begin
  WList.Sorted := False;
  SourceCompareS := SourceS;
  RP := TReversePhonetic.Create;
  WList.CustomSort(MyCustomSort);
  FreeAndNil(RP);
end;

end.
