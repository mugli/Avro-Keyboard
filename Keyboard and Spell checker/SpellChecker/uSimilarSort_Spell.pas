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

Unit uSimilarSort_Spell;

Interface
Uses
     WideStrings,
     uSpellEditDistanceSearch,
     clsReversePhonetic,
     SysUtils;

const
PhoneticWeight=9;
ManualWeight=1;

{Type
     SimilarRec = Record
          wS: WideString;
          Match: Integer;
     End;
 }
Procedure SimilarSort(SourceS: WideString; Var WList: TWideStringList);
Function MyCustomSort(List: TWideStringList; Index1, Index2: Integer): Integer;

Var
     SourceCompareS           : WideString;
     RP                       : TReversePhonetic;

Implementation


Function MyCustomSort(List: TWideStringList; Index1, Index2: Integer):
     Integer;
Var
     SRP, i1Rp, i2RP          : String;
Begin
     SRP := rp.Convert(SourceCompareS);
     i1Rp := rp.Convert(List[Index1]);
     i2Rp := rp.Convert(List[Index2]);
     If ((EditDistance(SourceCompareS, List[Index1]) * ManualWeight) + (EditDistance(SRP, i1rp) * PhoneticWeight)) < ((EditDistance(SourceCompareS, List[Index2]) * ManualWeight) + (EditDistance(SRP, i2rp) * PhoneticWeight)) Then
          Result := -1
     Else If ((EditDistance(SourceCompareS, List[Index1]) * ManualWeight) + (EditDistance(SRP, i1rp) * PhoneticWeight)) > ((EditDistance(SourceCompareS, List[Index2]) * ManualWeight) + (EditDistance(SRP, i2rp) * PhoneticWeight)) Then
          Result := 1
     Else
          Result := 0;
End;


{
Procedure SimilarSort(SourceS: WideString; Var WList: TWideStringList);
Var
     tArray                   : Array Of SimilarRec;
     i, c                     : Integer;
     tEntry                   : SimilarRec;
Begin

if WList.Count<=1  then exit;
I:=0;
C:=0;
tEntry.wS:='';
tEntry.Match :=0;
SetLength(tArray, 0);
WList.Sorted:=False;

     SetLength(tArray, WList.Count);
     For I := 0 To WList.Count - 1 Do Begin
          tArray[i].wS := WList[i];
          tArray[i].Match := LD(SourceS, tArray[i].wS);
     End;

     For c := 2 To High(tArray)+1 Do Begin
          For i := 0 To High(tArray)+1 - c Do Begin
               If tArray[i].Match > tArray[i + 1].Match Then Begin
                    tEntry := tArray[i];
                    tArray[i] := tArray[i + 1];
                    tArray[i + 1] := tEntry;
               End;
          End;
     End;

     WList.Clear;
     For I := Low(tArray) To High(tArray) Do Begin
          WList.Add ( tArray[i].wS );
     End;

     SetLength(tArray, 0);
End;
}

Procedure SimilarSort(SourceS: WideString; Var WList: TWideStringList);
Begin
     WList.Sorted := False;
     SourceCompareS := SourceS;
     RP := TReversePhonetic.Create;
     Wlist.CustomSort(MyCustomSort);
     FreeAndNil(RP);
End;

End.

