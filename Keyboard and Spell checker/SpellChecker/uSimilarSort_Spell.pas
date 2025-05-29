{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
