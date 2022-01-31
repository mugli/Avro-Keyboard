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

Unit uSimilarSort;

Interface

Uses
  Classes,
  Levenshtein;

Type
  SimilarRec = Record
    wS: String;
    Match: Integer;
  End;

Procedure SimilarSort(SourceS: String; Var WList: TStringList);
Function MyCustomSort(List: TStringList; Index1, Index2: Integer): Integer;

Var
  SourceCompareS: String;

Implementation

Function MyCustomSort(List: TStringList; Index1, Index2: Integer): Integer;
Begin
  If LD(SourceCompareS, List[Index1]) < LD(SourceCompareS, List[Index2]) Then
    Result := -1
  Else If LD(SourceCompareS, List[Index1]) > LD(SourceCompareS,
    List[Index2]) Then
    Result := 1
  Else
    Result := 0;
End;

Procedure SimilarSort(SourceS: String; Var WList: TStringList);
Begin
  WList.Sorted := False;
  SourceCompareS := SourceS;
  WList.CustomSort(MyCustomSort);
End;

End.
