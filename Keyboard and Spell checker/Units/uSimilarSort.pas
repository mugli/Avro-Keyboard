{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit uSimilarSort;

interface

uses
  Classes,
  Levenshtein;

type
  SimilarRec = record
    wS: string;
    Match: Integer;
  end;

procedure SimilarSort(SourceS: string; var WList: TStringList);
function MyCustomSort(List: TStringList; Index1, Index2: Integer): Integer;

var
  SourceCompareS: string;

implementation

function MyCustomSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if LD(SourceCompareS, List[Index1]) < LD(SourceCompareS, List[Index2]) then
    Result := -1
  else if LD(SourceCompareS, List[Index1]) > LD(SourceCompareS, List[Index2]) then
    Result := 1
  else
    Result := 0;
end;

procedure SimilarSort(SourceS: string; var WList: TStringList);
begin
  WList.Sorted := False;
  SourceCompareS := SourceS;
  WList.CustomSort(MyCustomSort);
end;

end.
