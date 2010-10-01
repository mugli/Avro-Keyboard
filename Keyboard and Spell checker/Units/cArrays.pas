{$INCLUDE cDictionaryDefines.inc}

Unit cArrays;

{                                                                              }
{                        Data structures: Arrays v3.14                         }
{                                                                              }
{      This unit is copyright © 1999-2002 by David Butler (david@e.co.za)      }
{                                                                              }
{                  This unit is part of Delphi Fundamentals.                   }
{                    Its original file name is cArrays.pas                     }
{                     It was generated 18 Dec 2002 22:04.                      }
{       The latest version is available from the Fundamentals home page        }
{                     http://fundementals.sourceforge.net/                     }
{                                                                              }
{                I invite you to use this unit, free of charge.                }
{        I invite you to distibute this unit, but it must be for free.         }
{             I also invite you to contribute to its development,              }
{             but do not distribute a modified copy of this file.              }
{                                                                              }
{          A forum is available on SourceForge for general discussion          }
{             http://sourceforge.net/forum/forum.php?forum_id=2117             }
{                                                                              }
{                                                                              }
{ Revision history:                                                            }
{   [ cDataStructs ]                                                           }
{   1999/11/12  0.01  Split cTypes from cDataStruct and cHolder.               }
{   1999/11/14  0.02  Added AListType.                                         }
{   2000/02/08  1.03  Initial version. AArray, TArray and TStreamArray.        }
{   2000/06/07  1.04  Base classes (AIntegerArray, ASet).                      }
{   2000/06/08  1.05  Added AObjectArray.                                      }
{   2000/06/03  1.06  Added AArray, AIntegerArray, AExtendedArray,             }
{                     AStringArray and ABitArray (formerly ASet) with some     }
{                     implementations.                                         }
{   2000/06/06  1.07  TFlatBitArray implementation.                            }
{                     Added AInt64Array.                                       }
{   2000/06/08  1.08  Added TObjectArray.                                      }
{   2000/06/14  1.09  Converted cDataStructs to template.                      }
{   2001/07/15  1.10  Changed memory arrays to pre-allocate when growing.      }
{   2001/08/20  2.11  Merged cTypes and cDataStructs to allow object           }
{                     interface implementation in base classes.                }
{   [ cArrays ]                                                                }
{   2002/05/15  3.12  Created cArrays unit from cDataStructs.                  }
{                     Refactored for Fundamentals 3.                           }
{   2002/09/30  3.13  Moved stream array classes to unit cStreamArrays.        }
{   2002/12/17  3.14  Added THashedStringArray.                                }
{                                                                              }

Interface

Uses
     { Delphi }
     SysUtils,

     { Fundamentals }
     cUtils,
     cTypes;

Const
     UnitName                 = 'cArrays';
     UnitVersion              = '3.14';
     UnitDesc                 = 'Data structures: Arrays';
     UnitCopyright            = '(c) 1999-2002 David Butler';



     {                                                                              }
     { ARRAY BASE CLASSES                                                           }
     {   Classes with the A-prefix are abstract base classes. They define the       }
     {   interface for the type and must never be instanciated.                     }
     {   Instead, create one of the implementation classes (T-prefix).              }
     {                                                                              }



     {                                                                              }
     { AArray                                                                       }
     {                                                                              }
Type
     AArray = Class(AType)
     Protected
          Procedure IndexError(Const Idx: Integer); Virtual;

          Function GetCount: Integer; Virtual; Abstract;
          Procedure SetCount(Const NewCount: Integer); Virtual; Abstract;

     Public
          Procedure Clear; Override;
          Property Count: Integer Read GetCount Write SetCount;

          Function CompareItems(Const Idx1, Idx2: Integer): TCompareResult; Virtual; Abstract;
          Procedure ExchangeItems(Const Idx1, Idx2: Integer); Virtual; Abstract;
          Procedure Sort; Virtual;
          Procedure ReverseOrder; Virtual;

          Function DuplicateRange(Const LoIdx, HiIdx: Integer): AArray; Virtual; Abstract;
          Procedure Delete(Const Idx: Integer; Const Count: Integer = 1); Virtual; Abstract;
          Procedure Insert(Const Idx: Integer; Const Count: Integer = 1); Virtual; Abstract;
          Function AddArray(Const V: AArray): Integer; Virtual; Abstract;
     End;
     EArray = Class(Exception);
     ArrayClass = Class Of AArray;








     {                                                                              }
     { AStringArray                                                                 }
     {   Base class for an array of Strings.                                        }
     {                                                                              }
Type
     EStringArray = Class(EArray);
     AStringArray = Class(AArray)
     Protected
          Procedure SetItem(Const Idx: Integer; Const Value: String); Virtual; Abstract;
          Function GetItem(Const Idx: Integer): String; Virtual; Abstract;
          Function GetRange(Const LoIdx, HiIdx: Integer): StringArray; Virtual;
          Procedure SetRange(Const LoIdx, HiIdx: Integer; Const V: StringArray); Virtual;
          Function GetAsString: String; Override;
          Procedure SetAsString(Const S: String); Override;

     Public
          { AType implementations                                                    }
          Procedure Assign(Const Source: TObject); Override;
          Function IsEqual(Const V: TObject): Boolean; Override;

          { AArray implementations                                                   }
          Procedure ExchangeItems(Const Idx1, Idx2: Integer); Override;
          Function CompareItems(Const Idx1, Idx2: Integer): TCompareResult; Override;
          Function AddArray(Const V: AArray): Integer; Reintroduce; Overload; Override;
          Function DuplicateRange(Const LoIdx, HiIdx: Integer): AArray; Override;
          Procedure Delete(Const Idx: Integer; Const Count: Integer = 1); Override;
          Procedure Insert(Const Idx: Integer; Const Count: Integer = 1); Override;

          { AStringArray interface                                                   }
          Property Item[Const Idx: Integer]: String Read GetItem Write SetItem; Default;
          Property Range[Const LoIdx, HiIdx: Integer]: StringArray Read GetRange Write SetRange;
          Procedure Fill(Const Idx, Count: Integer; Const Value: String = ''); Virtual;
          Function AddItem(Const Value: String): Integer; Reintroduce; Overload; Virtual;
          Function AddArray(Const V: StringArray): Integer; Reintroduce; Overload; Virtual;
          Function PosNext(Const Find: String; Const PrevPos: Integer = -1;
               Const IsSortedAscending: Boolean = False): Integer;
     End;




     {                                                                              }
     { ARRAY IMPLEMENTATIONS                                                        }
     {                                                                              }



     {                                                                              }
     { TStringArray                                                                 }
     {   AStringArray implemented using a dynamic array.                            }
     {                                                                              }
Type
     TStringArray = Class(AStringArray)
     Protected
          FData: StringArray;
          FCount: Integer;

          { ACollection implementations                                              }
          Function GetCount: Integer; Override;
          Procedure SetCount(Const NewCount: Integer); Override;

          { AStringArray implementations                                            }
          Procedure SetItem(Const Idx: Integer; Const Value: String); Override;
          Function GetItem(Const Idx: Integer): String; Override;
          Function GetRange(Const LoIdx, HiIdx: Integer): StringArray; Override;
          Procedure SetRange(Const LoIdx, HiIdx: Integer; Const V: StringArray); Override;
          Procedure SetData(Const Data: StringArray); Virtual;

     Public
          Constructor Create(Const V: StringArray = Nil); Reintroduce; Overload;

          { AType implementations                                                    }
          Procedure Assign(Const Source: TObject); Reintroduce; Overload; Override;

          { AArray implementations                                                   }
          Function DuplicateRange(Const LoIdx, HiIdx: Integer): AArray; Override;
          Procedure Delete(Const Idx: Integer; Const Count: Integer = 1); Override;
          Procedure Insert(Const Idx: Integer; Const Count: Integer = 1); Override;

          { AStringArray implementations                                            }
          Procedure Assign(Const V: StringArray); Reintroduce; Overload;
          Procedure Assign(Const V: Array Of String); Reintroduce; Overload;
          Property Data: StringArray Read FData Write SetData;
     End;





     {                                                                              }
     { THashedStringArray                                                           }
     {   AStringArray that maintains a hash lookup table of array values.           }
     {                                                                              }
Type
     THashedStringArray = Class(TStringArray)
     Protected
          FLookup: Array Of IntegerArray;
          FCaseSensitive: Boolean;

          Function LocateItemHashBuf(Const ValueStrPtr: PChar;
               Const ValueStrLen: Integer;
               Var LookupList, LookupIdx: Integer): Boolean;
          Function LocateItemHash(Const Value: String;
               Var LookupList, LookupIdx: Integer): Boolean;
          Procedure Rehash;

          Procedure Init; Override;
          Procedure SetItem(Const Idx: Integer; Const Value: String); Override;
          Procedure SetData(Const Data: StringArray); Override;

     Public
          Constructor Create(Const CaseSensitive: Boolean = True);

          Procedure Assign(Const Source: TObject); Override;
          Procedure Clear; Override;

          Procedure ExchangeItems(Const Idx1, Idx2: Integer); Override;
          Procedure Delete(Const Idx: Integer; Const Count: Integer = 1); Override;
          Procedure Insert(Const Idx: Integer; Const Count: Integer = 1); Override;
          Function AddItem(Const Value: String): Integer; Override;

          Function PosNextBuf(Const FindStrPtr: PChar; Const FindStrLen: Integer;
               Const PrevPos: Integer = -1): Integer;
          Function PosNext(Const Find: String; Const PrevPos: Integer = -1): Integer;
     End;







Implementation

Uses
     { Fundamentals }
     cStrings;



{                                                                              }
{                                                                              }
{ TYPE BASE CLASSES                                                            }
{                                                                              }
{                                                                              }



{                                                                              }
{ AArray                                                                       }
{                                                                              }

Procedure AArray.IndexError(Const Idx: Integer);
Begin
     Raise EArray.Create({$IFDEF DEBUG}ObjectClassName(self) + ': ' + {$ENDIF}
          'Array index out of bounds'
          {$IFDEF DEBUG} + ': ' + IntToStr(Idx) + '/' + IntToStr(GetCount){$ENDIF});
End;

Procedure AArray.Clear;
Begin
     Count := 0;
End;

Procedure AArray.Sort;

     Procedure QuickSort(L, R: Integer);
     Var
          I, J                : Integer;
          M                   : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While CompareItems(I, M) = crLess Do
                         Inc(I);
                    While CompareItems(J, M) = crGreater Do
                         Dec(J);
                    If I <= J Then Begin
                         ExchangeItems(I, J);
                         Inc(I);
                         Dec(J);
                    End;
               Until I > J;
               If L < J Then
                    QuickSort(L, J);
               L := I;
          Until I >= R;
     End;

Var
     I                        : Integer;
Begin
     I := Count;
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure AArray.ReverseOrder;
Var
     I, L                     : Integer;
Begin
     L := Count;
     For I := 1 To L Div 2 Do
          ExchangeItems(I - 1, L - I);
End;





{                                                                              }
{ AStringArray                                                                 }
{                                                                              }

Procedure AStringArray.ExchangeItems(Const Idx1, Idx2: Integer);
Var
     I                        : String;
Begin
     I := Item[Idx1];
     Item[Idx1] := Item[Idx2];
     Item[Idx2] := I;
End;

Function AStringArray.AddItem(Const Value: String): Integer;
Begin
     Result := Count;
     Count := Result + 1;
     Item[Result] := Value;
End;

Function AStringArray.GetRange(Const LoIdx, HiIdx: Integer): StringArray;
Var
     I, L, H, C               : Integer;
Begin
     L := MaxI(0, LoIdx);
     H := MinI(Count - 1, HiIdx);
     C := H - L + 1;
     SetLength(Result, C);
     For I := 0 To C - 1 Do
          Result[I] := Item[L + I];
End;

Function AStringArray.DuplicateRange(Const LoIdx, HiIdx: Integer): AArray;
Var
     I, L, H, C               : Integer;
Begin
     Result := AStringArray(CreateInstance);
     L := MaxI(0, LoIdx);
     H := MinI(Count - 1, HiIdx);
     C := H - L + 1;
     AStringArray(Result).Count := C;
     For I := 0 To C - 1 Do
          AStringArray(Result)[I] := Item[L + I];
End;

Procedure AStringArray.SetRange(Const LoIdx, HiIdx: Integer; Const V: StringArray);
Var
     I, L, H, C               : Integer;
Begin
     L := MaxI(0, LoIdx);
     H := MinI(Count - 1, HiIdx);
     C := MinI(Length(V), H - L + 1);
     For I := 0 To C - 1 Do
          Item[L + I] := V[I];
End;

Procedure AStringArray.Fill(Const Idx, Count: Integer; Const Value: String);
Var
     I                        : Integer;
Begin
     For I := Idx To Idx + Count - 1 Do
          Item[I] := Value;
End;

Function AStringArray.AddArray(Const V: StringArray): Integer;
Begin
     Result := Count;
     Count := Result + Length(V);
     Range[Result, Count - 1] := V;
End;

Function AStringArray.CompareItems(Const Idx1, Idx2: Integer): TCompareResult;
Var
     I, J                     : String;
Begin
     I := Item[Idx1];
     J := Item[Idx2];
     If I < J Then
          Result := crLess
     Else If I > J Then
          Result := crGreater
     Else
          Result := crEqual;
End;

Function AStringArray.PosNext(Const Find: String; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : String;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Count - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := Item[I];
                    If D = Find Then Begin
                         While (I > 0) And (Item[I - 1] = Find) Do
                              Dec(I);
                         Result := I;
                         exit;
                    End
                    Else If D > Find Then
                         H := I - 1
                    Else
                         L := I + 1;
               Until L > H;
               Result := -1;
          End
          Else {// find next} If PrevPos >= Count - 1 Then
               Result := -1
          Else If Item[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else                               {// linear search} Begin

          For I := MaxI(PrevPos + 1, 0) To Count - 1 Do
               If Item[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function AStringArray.GetAsString: String;
Var
     I, L                     : Integer;
Begin
     L := Count;
     If L = 0 Then Begin
          Result := '';
          exit;
     End;
     Result := StrUnquote(Item[0]);
     For I := 1 To L - 1 Do
          Result := Result + ',' + StrUnquote(Item[I]);
     Result := Result;
End;

Procedure AStringArray.SetAsString(Const S: String);
Var
     F, G, L, C               : Integer;
Begin
     L := Length(S);
     If L = 0 Then Begin
          Count := 0;
          exit;
     End;
     L := 0;
     F := 2;
     C := Length(S);
     While F < C Do Begin
          G := 0;
          While (F + G < C) And (S[F + G] <> ',') Do
               Inc(G);
          Inc(L);
          Count := L;
          If G = 0 Then
               Item[L - 1] := ''
          Else
               Item[L - 1] := StrQuote(Copy(S, F, G));
          Inc(F, G + 1);
     End;
End;

Procedure AStringArray.Assign(Const Source: TObject);
Var
     I, L                     : Integer;
Begin
     If Source Is AStringArray Then Begin
          L := AStringArray(Source).Count;
          Count := L;
          For I := 0 To L - 1 Do
               Item[I] := AStringArray(Source).Item[I];
     End
     Else
          Inherited Assign(Source);
End;

Function AStringArray.IsEqual(Const V: TObject): Boolean;
Var
     I, L                     : Integer;
Begin
     If V Is AStringArray Then Begin
          L := AStringArray(V).Count;
          Result := L = Count;
          If Not Result Then
               exit;
          For I := 0 To L - 1 Do
               If Item[I] <> AStringArray(V).Item[I] Then Begin
                    Result := False;
                    exit;
               End;
     End
     Else
          Result := Inherited IsEqual(V);
End;

Function AStringArray.AddArray(Const V: AArray): Integer;
Var
     I, L                     : Integer;
Begin
     If V Is AStringArray Then Begin
          Result := Count;
          L := V.Count;
          Count := Result + L;
          For I := 0 To L - 1 Do
               Item[Result + I] := AStringArray(V)[I];
     End
     Else Begin
          TypeError(ObjectClassName(self) + ' can not add array ' + ObjectClassName(V));
          Result := -1;
     End;
End;

Procedure AStringArray.Delete(Const Idx: Integer; Const Count: Integer);
Var
     I, C, J, L               : Integer;
Begin
     J := MaxI(Idx, 0);
     C := GetCount;
     L := MinI(Count, C - J);
     If L > 0 Then Begin
          For I := J To J + C - 1 Do
               SetItem(I, GetItem(I + Count));
          SetCount(C - L);
     End;
End;

Procedure AStringArray.Insert(Const Idx: Integer; Const Count: Integer);
Var
     I, C, J, L               : Integer;
Begin
     If Count <= 0 Then
          exit;
     C := GetCount;
     SetCount(C + Count);
     J := MinI(MaxI(Idx, 0), C);
     L := C - J;
     For I := C - 1 Downto C - L Do
          SetItem(I + Count, GetItem(I));
End;







{                                                                              }
{ TStringArray                                                                 }
{                                                                              }

Procedure TStringArray.SetItem(Const Idx: Integer; Const Value: String);
Begin
     {$IFOPT R+}
     If (Idx < 0) Or (Idx >= FCount) Then
          IndexError(Idx);
     {$ENDIF}
     FData[Idx] := Value;
End;

Function TStringArray.GetItem(Const Idx: Integer): String;
Begin
     {$IFOPT R+}
     If (Idx < 0) Or (Idx >= FCount) Then
          IndexError(Idx);
     {$ENDIF}
     Result := FData[Idx];
End;

Function TStringArray.GetCount: Integer;
Begin
     Result := FCount;
End;

Procedure TStringArray.SetCount(Const NewCount: Integer);
Var
     L, N                     : Integer;
Begin
     If FCount = NewCount Then
          exit;
     FCount := NewCount;

     N := NewCount;
     L := Length(FData);
     If (N > 16) And (L > 0) Then
          If N > L Then
               N := N + N Shr 3
          Else If N > L Shr 1 Then
               exit;

     If N <> L Then
          SetLength(FData, N);
End;

Procedure TStringArray.Delete(Const Idx: Integer; Const Count: Integer = 1);
Begin
     FCount := MaxI(FCount - Remove(FData, Idx, Count), 0);
     If FCount = 0 Then
          FData := Nil;
End;

Procedure TStringArray.Insert(Const Idx: Integer; Const Count: Integer = 1);
Var
     I                        : Integer;
Begin
     I := ArrayInsert(FData, Idx, Count);
     If I >= 0 Then
          Inc(FCount, Count);
End;

Function TStringArray.GetRange(Const LoIdx, HiIdx: Integer): StringArray;
Var
     L, H                     : Integer;
Begin
     L := MaxI(0, LoIdx);
     H := MinI(HiIdx, FCount);
     If H >= L Then
          Result := Copy(FData, L, H - L + 1)
     Else
          Result := Nil;
End;

Procedure TStringArray.SetRange(Const LoIdx, HiIdx: Integer; Const V: StringArray);
Var
     L, H, C                  : Integer;
Begin
     L := MaxI(0, LoIdx);
     H := MinI(HiIdx, FCount);
     C := MaxI(MinI(Length(V), H - L + 1), 0);
     If C > 0 Then
          Move(V[0], FData[L], C * Sizeof(String));
End;

Constructor TStringArray.Create(Const V: StringArray);
Begin
     Inherited Create;
     SetData(V);
End;

Procedure TStringArray.SetData(Const Data: StringArray);
Begin
     FData := Data;
     FCount := Length(FData);
End;

Function TStringArray.DuplicateRange(Const LoIdx, HiIdx: Integer): AArray;
Var
     L, H, C                  : Integer;
Begin
     L := MaxI(0, LoIdx);
     H := MinI(HiIdx, FCount);
     C := MaxI(0, H - L + 1);
     Result := CreateInstance As TStringArray;
     TStringArray(Result).FCount := C;
     If C > 0 Then
          TStringArray(Result).FData := Copy(FData, L, C);
End;

Procedure TStringArray.Assign(Const V: StringArray);
Begin
     FData := Copy(V);
     FCount := Length(FData);
End;

Procedure TStringArray.Assign(Const V: Array Of String);
Begin
     FData := AsStringArray(V);
     FCount := Length(FData);
End;

Procedure TStringArray.Assign(Const Source: TObject);
Begin
     If Source Is TStringArray Then Begin
          FCount := TStringArray(Source).FCount;
          FData := Copy(TStringArray(Source).FData, 0, FCount);
     End
     Else
          Inherited Assign(Source);
End;





{                                                                              }
{ Hashed Array helper function                                                 }
{                                                                              }
Const
     AverageHashChainSize     = 4;

Function ArrayRehashSize(Const Count: Integer): Integer;
Var
     L                        : Integer;
Begin
     L := Count Div AverageHashChainSize; // Number of slots
     If L <= 16 Then                    // Rehash in powers of 16
          Result := 16
     Else If L <= 256 Then
          Result := 256
     Else If L <= 4096 Then
          Result := 4096
     Else If L <= 65536 Then
          Result := 65536
     Else If L <= 1048576 Then
          Result := 1048576
     Else If L <= 16777216 Then
          Result := 16777216
     Else
          Result := 268435456;
End;



{                                                                              }
{ THashedStringArray                                                           }
{                                                                              }

Constructor THashedStringArray.Create(Const CaseSensitive: Boolean);
Begin
     Inherited Create(Nil);
     FCaseSensitive := CaseSensitive;
End;

Procedure THashedStringArray.Init;
Begin
     Inherited;
     FCaseSensitive := True;
End;

Procedure THashedStringArray.Assign(Const Source: TObject);
Begin
     If Source Is THashedStringArray Then Begin
          // Assign array data
          Inherited;
          // Assign hash lookup
          FLookup := Copy(THashedStringArray(Source).FLookup);
          FCaseSensitive := THashedStringArray(Source).FCaseSensitive;
     End
     Else
          Inherited;
End;

Procedure THashedStringArray.Clear;
Begin
     Inherited;
     FLookup := Nil;
End;

Function THashedStringArray.LocateItemHashBuf(Const ValueStrPtr: PChar;
     Const ValueStrLen: Integer; Var LookupList, LookupIdx: Integer): Boolean;
Var
     I                        : Integer;
Begin
     // Hash value
     LookupList := HashStr(ValueStrPtr, ValueStrLen, Length(FLookup), FCaseSensitive);
     // Locate value in hash lookup
     For I := 0 To Length(FLookup[LookupList]) - 1 Do
          If StrPEqual(ValueStrPtr, ValueStrLen, FData[FLookup[LookupList][I]], FCaseSensitive) Then Begin
               LookupIdx := I;
               Result := True;
               exit;
          End;
     // Not found
     LookupIdx := -1;
     Result := False;
End;

Function THashedStringArray.LocateItemHash(Const Value: String;
     Var LookupList, LookupIdx: Integer): Boolean;
Begin
     Result := LocateItemHashBuf(Pointer(Value), Length(Value),
          LookupList, LookupIdx);
End;

Procedure THashedStringArray.Rehash;
Var
     I, C, L                  : Integer;
Begin
     C := FCount;
     L := ArrayRehashSize(C);
     FLookup := Nil;
     SetLength(FLookup, L);
     For I := 0 To C - 1 Do
          Append(FLookup[HashStr(FData[I], L, FCaseSensitive)], I);
End;

Procedure THashedStringArray.ExchangeItems(Const Idx1, Idx2: Integer);
Var
     L1, L2, I1, I2           : Integer;
Begin
     // Swap lookup
     If LocateItemHash(FData[Idx1], L1, I1) And
          LocateItemHash(FData[Idx2], L2, I2) Then
          Swap(FLookup[L1][I1], FLookup[L2][I2]);
     // Swap array items
     Inherited;
End;

Procedure THashedStringArray.Delete(Const Idx: Integer; Const Count: Integer);
Var
     I, L, V                  : Integer;
Begin
     // Delete lookup
     For I := MaxI(0, Idx) To MinI(FCount, Idx + Count - 1) Do
          If LocateItemHash(FData[I], L, V) Then
               Remove(FLookup[L], V, 1);
     // Delete array
     Inherited;
End;

Procedure THashedStringArray.Insert(Const Idx: Integer; Const Count: Integer);
Var
     I, J                     : Integer;
Begin
     // Insert array
     Inherited;
     // Add lookup
     J := MaxI(Idx, 0);
     For I := J To J + Count - 1 Do
          Append(FLookup[0], I);
End;

Procedure THashedStringArray.SetData(Const Data: StringArray);
Begin
     Inherited;
     Rehash;
End;

Procedure THashedStringArray.SetItem(Const Idx: Integer; Const Value: String);
Var
     S                        : String;
     I, J                     : Integer;
Begin
     {$IFOPT R+}
     If (Idx < 0) Or (Idx >= FCount) Then
          IndexError(Idx);
     {$ENDIF}
     // Remove old hash
     S := FData[Idx];
     If LocateItemHash(S, I, J) Then
          Remove(FLookup[I], J, 1);
     // Set array value
     FData[Idx] := Value;
     // Add new hash
     Append(FLookup[HashStr(Value, Length(FLookup), FCaseSensitive)], Idx);
End;

Function THashedStringArray.AddItem(Const Value: String): Integer;
Var
     L                        : Integer;
Begin
     // add to array
     Result := Count;
     Count := Result + 1;
     FData[Result] := Value;
     // add lookup
     L := Length(FLookup);
     Append(FLookup[HashStr(Value, L, FCaseSensitive)], Result);
     If (Result + 1) Div AverageHashChainSize > L Then
          Rehash;
End;

Function THashedStringArray.PosNextBuf(Const FindStrPtr: PChar;
     Const FindStrLen: Integer; Const PrevPos: Integer): Integer;
Var
     I, J, F, L, P            : Integer;
Begin
     // locate first
     If Not LocateItemHashBuf(FindStrPtr, FindStrLen, I, J) Then Begin
          Result := -1;
          exit;
     End;
     If PrevPos < 0 Then Begin
          Result := FLookup[I][J];
          exit;
     End;
     // locate previous
     L := Length(FLookup[I]);
     P := -1;
     For F := J To L - 1 Do
          If FLookup[I][F] = PrevPos Then Begin
               P := F;
               break;
          End;
     If P = -1 Then Begin
          Result := 1;
          exit;
     End;
     // locate next
     For F := P + 1 To L - 1 Do Begin
          Result := FLookup[I][F];
          If StrPEqual(FindStrPtr, FindStrLen, FData[Result], FCaseSensitive) Then
               // found
               exit;
     End;
     // not found
     Result := 1;
End;

Function THashedStringArray.PosNext(Const Find: String; Const PrevPos: Integer): Integer;
Begin
     Result := PosNextBuf(Pointer(Find), Length(Find), PrevPos);
End;







End.
