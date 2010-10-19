{$INCLUDE cDictionaryDefines.inc}

Unit cDictionaries;

{                                                                              }
{                     Data structures: Dictionaries v3.10                      }
{                                                                              }
{      This unit is copyright © 1999-2002 by David Butler (david@e.co.za)      }
{                                                                              }
{                  This unit is part of Delphi Fundamentals.                   }
{                 Its original file name is cDictionaries.pas                  }
{                     It was generated 16 Feb 2003 13:24.                      }
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
{   2000/06/16  1.02  Added ADictionary.                                       }
{   2000/06/14  1.03  Converted cDataStructs to template.                      }
{   2000/06/16  1.04  Added dictionaries stored in AArrays.                    }
{   2000/07/07  1.05  Added ATypeDictionary.                                   }
{   2001/01/19  1.06  Added THashedStringDictionary.                           }
{   2001/04/13  1.07  Added TObjectDictionary.                                 }
{   2001/08/20  2.08  Merged cTypes and cDataStructs to allow object           }
{                     interface implementation in base classes.                }
{   2002/01/14  2.09  Replaced AllowDuplicates property with DuplicatesAction  }
{                     property.                                                }
{   [ cDictionaries ]                                                          }
{   2002/05/15  3.10  Created cDictionaries unit from cDataStructs.            }
{                     Refactored for Fundamentals 3.                           }
{                                                                              }

Interface

Uses
     { Delphi }
     SysUtils,

     { Fundamentals }
     cUtils,
     cTypes,
     cArrays;

Const
     UnitName                 = 'cDictionaries';
     UnitVersion              = '3.10';
     UnitDesc                 = 'Data structures: Dictionaries';
     UnitCopyright            = '(c) 1999-2002 David Butler';



     {                                                                              }
     { DICTIONARY BASE CLASSES                                                      }
     {   Classes with the A-prefix are Abstract base classes. They define the       }
     {   interface for the type and must never be instanciated.                     }
     {   Instead, create one of the implementation classes (T-prefix).              }
     {                                                                              }



     {                                                                              }
     { ADictionary                                                                  }
     {   Base class for a dictionary (key-value pair where the key is a AnsiString).    }
     {                                                                              }
Type
     TDictionaryDuplicatesAction = (ddError, // raises an exception on duplicate keys
          ddAccept,                     // allow duplicate keys
          ddIgnore);                    // silently discard duplicates
     ADictionary = Class(AType)
     Protected
          Procedure DictionaryError(Const Msg: AnsiString);
          Procedure KeyNotFoundError(Const Key: AnsiString);

          Function GetAddOnSet: Boolean; Virtual; Abstract;
          Procedure SetAddOnSet(Const AddOnSet: Boolean); Virtual; Abstract;
          Function GetDuplicatesAction: TDictionaryDuplicatesAction; Virtual; Abstract;
          Procedure SetDuplicatesAction(Const Value: TDictionaryDuplicatesAction); Virtual; Abstract;
          Function GetKeysCaseSensitive: Boolean; Virtual; Abstract;

     Public
          Procedure Delete(Const Key: AnsiString); Virtual; Abstract;
          Function HasKey(Const Key: AnsiString): Boolean; Virtual; Abstract;
          Procedure Rename(Const Key, NewKey: AnsiString); Virtual; Abstract;

          Function Count: Integer; Virtual; Abstract;
          Function GetKeyByIndex(Const Idx: Integer): AnsiString; Virtual; Abstract;

          Property AddOnSet: Boolean Read GetAddOnSet Write SetAddOnSet;
          Property DuplicatesAction: TDictionaryDuplicatesAction
               Read GetDuplicatesAction Write SetDuplicatesAction;
          Property KeysCaseSensitive: Boolean Read GetKeysCaseSensitive;
     End;
     EDictionary = Class(EType);




     {                                                                              }
     { AStringDictionary                                                            }
     {   A Dictionary with AnsiString values and AnsiString keys.                           }
     {                                                                              }
Type
     AStringDictionary = Class(ADictionary)
     Protected
          Function GetAsString: AnsiString; Override;

          Function GetItem(Const Key: AnsiString): AnsiString; Virtual;
          Procedure SetItem(Const Key: AnsiString; Const Value: AnsiString); Virtual; Abstract;

     Public
          { AType implementations                                                    }
          Procedure Assign(Const Source: TObject); Override;

          { AStringDictionary interface                                            }
          Property Item[Const Key: AnsiString]: AnsiString Read GetItem Write SetItem; Default;
          Procedure Add(Const Key: AnsiString; Const Value: AnsiString); Virtual; Abstract;

          Function GetItemByIndex(Const Idx: Integer): AnsiString; Virtual; Abstract;
          Function LocateItem(Const Key: AnsiString; Var Value: AnsiString): Integer; Virtual; Abstract;
          Function LocateNext(Const Key: AnsiString; Const Idx: Integer;
               Var Value: AnsiString): Integer; Virtual; Abstract;

          Function GetItemLength(Const Key: AnsiString): Integer; Virtual;
          Function GetTotalLength: Int64; Virtual;
     End;
     EStringDictionary = Class(EDictionary);








     {                                                                              }
     { DICTIONARY IMPLEMENTATIONS                                                   }
     {                                                                              }



     { TStringDictionary                                                            }
     {   Implements AStringDictionary using arrays.                                 }
     {   A 'chained-hash' lookup table is used for quick access.                    }
     {                                                                              }
Type
     TStringDictionary = Class(AStringDictionary)
     Protected
          FKeys: AStringArray;
          FValues: AStringArray;
          FLookup: Array Of IntegerArray;
          FCaseSensitive: Boolean;
          FAddOnSet: Boolean;
          FDuplicatesAction: TDictionaryDuplicatesAction;

          Function LocateKey(Const Key: AnsiString; Var LookupIdx: Integer;
               Const ErrorIfNotFound: Boolean): Integer;
          Function KeyIndex(Const Key: AnsiString; Const ErrorIfNotFound: Boolean): Integer;
          Procedure DeleteByIndex(Const Idx: Integer; Const Hash: Integer = -1);
          Procedure Rehash;
          Function GetHashTableSize: Integer;
          Procedure IndexError;

          { ADictionary implementations                                              }
          Function GetKeysCaseSensitive: Boolean; Override;
          Function GetAddOnSet: Boolean; Override;
          Procedure SetAddOnSet(Const AddOnSet: Boolean); Override;
          Function GetDuplicatesAction: TDictionaryDuplicatesAction; Override;
          Procedure SetDuplicatesAction(Const DuplicatesAction: TDictionaryDuplicatesAction); Override;

          { AStringDictionary implementations                                    }
          Procedure SetItem(Const Key: AnsiString; Const Value: AnsiString); Override;

     Public
          { TStringDictionary interface                                            }
          Constructor Create;
          Constructor CreateEx(Const Keys: AStringArray = Nil; Const Values: AStringArray = Nil;
               Const KeysCaseSensitive: Boolean = True;
               Const AddOnSet: Boolean = True;
               Const DuplicatesAction: TDictionaryDuplicatesAction = ddAccept);
          Destructor Destroy; Override;

          { AType implementations                                                    }
          Procedure Clear; Override;

          { ADictionary implementations                                              }
          Procedure Delete(Const Key: AnsiString); Override;
          Function HasKey(Const Key: AnsiString): Boolean; Override;
          Procedure Rename(Const Key: AnsiString; Const NewKey: AnsiString); Override;
          Function Count: Integer; Override;
          Function GetKeyByIndex(Const Idx: Integer): AnsiString; Override;

          { AStringDictionary implementations                                    }
          Procedure Add(Const Key: AnsiString; Const Value: AnsiString); Override;
          Function GetItemByIndex(Const Idx: Integer): AnsiString; Override;
          Procedure SetItemByIndex(Const Idx: Integer; Const Value: AnsiString);
          Function LocateItem(Const Key: AnsiString; Var Value: AnsiString): Integer; Override;
          Function LocateNext(Const Key: AnsiString; Const Idx: Integer;
               Var Value: AnsiString): Integer; Override;

          { TStringDictionary interface                                            }
          Property HashTableSize: Integer Read GetHashTableSize;
          Procedure DeleteItemByIndex(Const Idx: Integer);
     End;






     {                                                                              }
     { Dictionary functions                                                         }
     {                                                                              }
Const
     AverageHashChainSize     = 4;

Function DictionaryRehashSize(Const Count: Integer): Integer;


Implementation

Uses
     { Fundamentals }
     cStrings;



{                                                                              }
{ DICTIONARY BASE CLASSES                                                      }
{                                                                              }



{                                                                              }
{ ADictionary                                                                  }
{                                                                              }

Procedure ADictionary.DictionaryError(Const Msg: AnsiString);
Begin
     TypeError(Msg, Nil, EDictionary);
End;

Procedure ADictionary.KeyNotFoundError(Const Key: AnsiString);
Begin
     DictionaryError('Key not found: ' + Key);
End;



{                                                                              }
{ AStringDictionary                                                            }
{                                                                              }

Function AStringDictionary.GetItem(Const Key: AnsiString): AnsiString;
Begin
     If LocateItem(Key, Result) < 0 Then
          KeyNotFoundError(Key);
End;

Procedure AStringDictionary.Assign(Const Source: TObject);
Var
     I                        : Integer;
Begin
     If Source Is AStringDictionary Then Begin
          Clear;
          For I := 0 To AStringDictionary(Source).Count - 1 Do
               Add(AStringDictionary(Source).GetKeyByIndex(I),
                    AStringDictionary(Source).GetItemByIndex(I));
     End
     Else
          Inherited Assign(Source);
End;

Function AStringDictionary.GetAsString: AnsiString;
Var
     I, L                     : Integer;
Begin
     L := Count - 1;
     For I := 0 To L Do Begin
          Result := Result + GetKeyByIndex(I) + ':' + StrQuote(GetItemByIndex(I));
          If I < L Then
               Result := Result + ',';
     End;
End;

Function AStringDictionary.GetItemLength(Const Key: AnsiString): Integer;
Begin
     Result := Length(GetItem(Key));
End;

Function AStringDictionary.GetTotalLength: Int64;
Var
     I                        : Integer;
Begin
     Result := 0;
     For I := 0 To Count - 1 Do
          Inc(Result, Length(GetItemByIndex(I)));
End;








{                                                                              }
{ DICTIONARY IMPLEMENTATIONS                                                   }
{                                                                              }



{ Dictionary helper functions                                                  }

Function DictionaryRehashSize(Const Count: Integer): Integer;
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
{ TStringDictionary                                                            }
{                                                                              }

Constructor TStringDictionary.Create;
Begin
     Inherited Create;
     FCaseSensitive := True;
     FDuplicatesAction := ddAccept;
     FAddOnSet := True;
     FKeys := TStringArray.Create;
     FValues := TStringArray.Create;
End;

Constructor TStringDictionary.CreateEx(Const Keys: AStringArray; Const Values: AStringArray; Const KeysCaseSensitive: Boolean; Const AddOnSet: Boolean; Const DuplicatesAction: TDictionaryDuplicatesAction);
Begin
     Inherited Create;
     If Assigned(Keys) Then
          FKeys := Keys
     Else
          FKeys := TStringArray.Create;
     If Assigned(Values) Then
          FValues := Values
     Else
          FValues := TStringArray.Create;
     Assert(FKeys.Count = FValues.Count, 'Keys and Values must be equal length');
     FAddOnSet := AddOnSet;
     FDuplicatesAction := DuplicatesAction;
     Rehash;
End;

Destructor TStringDictionary.Destroy;
Begin
     FreeAndNil(FValues);
     FreeAndNil(FKeys);
     Inherited Destroy;
End;

Function TStringDictionary.GetKeysCaseSensitive: Boolean;
Begin
     Result := FCaseSensitive;
End;

Function TStringDictionary.GetAddOnSet: Boolean;
Begin
     Result := FAddOnSet;
End;

Procedure TStringDictionary.SetAddOnSet(Const AddOnSet: Boolean);
Begin
     FAddOnSet := AddOnSet;
End;

Function TStringDictionary.GetHashTableSize: Integer;
Begin
     Result := Length(FLookup);
End;

Procedure TStringDictionary.Rehash;
Var
     I, C, L                  : Integer;
Begin
     C := FKeys.Count;
     L := DictionaryRehashSize(C);
     FLookup := Nil;
     SetLength(FLookup, L);
     For I := 0 To C - 1 Do
          Append(FLookup[HashStr(FKeys[I], L, FCaseSensitive)], I);
End;

Function TStringDictionary.LocateKey(Const Key: AnsiString; Var LookupIdx: Integer; Const ErrorIfNotFound: Boolean): Integer;
Var
     H, I, J, L               : Integer;
Begin
     Result := -1;
     L := Length(FLookup);
     If L > 0 Then Begin
          H := HashStr(Key, L, FCaseSensitive);
          LookupIdx := H;
          For I := 0 To Length(FLookup[H]) - 1 Do Begin
               J := FLookup[H, I];
               If StrEqual(Key, FKeys[J], FCaseSensitive) Then Begin
                    Result := J;
                    break;
               End;
          End;
     End;
     If ErrorIfNotFound And (Result = -1) Then
          KeyNotFoundError(Key);
End;

Function TStringDictionary.KeyIndex(Const Key: AnsiString; Const ErrorIfNotFound: Boolean): Integer;
Var
     H                        : Integer;
Begin
     Result := LocateKey(Key, H, ErrorIfNotFound);
End;

Procedure TStringDictionary.Add(Const Key: AnsiString; Const Value: AnsiString);
Var
     H, L, I                  : Integer;
Begin
     If FDuplicatesAction In [ddIgnore, ddError] Then
          If LocateKey(Key, H, False) >= 0 Then
               If FDuplicatesAction = ddIgnore Then
                    exit
               Else
                    DictionaryError('Duplicate key: ' + StrQuote(Key));
     L := Length(FLookup);
     If L = 0 Then Begin
          Rehash;
          L := Length(FLookup);
     End;
     H := Integer(HashStr(Key, LongWord(L), FCaseSensitive));
     I := FKeys.AddItem(Key);
     Append(FLookup[H], I);
     FValues.AddItem(Value);

     If (I + 1) Div AverageHashChainSize > L Then
          Rehash;
End;

Procedure TStringDictionary.DeleteByIndex(Const Idx: Integer; Const Hash: Integer);
Var
     I, J, H                  : Integer;
Begin
     If Hash = -1 Then
          H := HashStr(FKeys[Idx], Length(FLookup), FCaseSensitive)
     Else
          H := Hash;
     FKeys.Delete(Idx);
     FValues.Delete(Idx);
     J := PosNext(Idx, FLookup[H]);
     Assert(J >= 0, 'Invalid hash value/lookup table');
     Remove(FLookup[H], J, 1);

     For I := 0 To Length(FLookup) - 1 Do
          For J := 0 To Length(FLookup[I]) - 1 Do
               If FLookup[I][J] > Idx Then
                    Dec(FLookup[I][J]);
End;

Procedure TStringDictionary.Delete(Const Key: AnsiString);
Var
     I, H                     : Integer;
Begin
     I := LocateKey(Key, H, True);
     DeleteByIndex(I, H);
End;

Function TStringDictionary.HasKey(Const Key: AnsiString): Boolean;
Begin
     Result := KeyIndex(Key, False) >= 0;
End;

Procedure TStringDictionary.Rename(Const Key, NewKey: AnsiString);
Var
     I, J, H                  : Integer;
Begin
     I := LocateKey(Key, H, True);
     FKeys[I] := NewKey;
     J := PosNext(I, FLookup[H]);
     Assert(J >= 0, 'Invalid hash value/lookup table');
     Remove(FLookup[H], J, 1);
     Append(FLookup[HashStr(NewKey, Length(FLookup), FCaseSensitive)], I);
End;

Function TStringDictionary.GetDuplicatesAction: TDictionaryDuplicatesAction;
Begin
     Result := FDuplicatesAction;
End;

Procedure TStringDictionary.SetDuplicatesAction(Const DuplicatesAction: TDictionaryDuplicatesAction);
Begin
     FDuplicatesAction := DuplicatesAction;
End;

Function TStringDictionary.LocateItem(Const Key: AnsiString; Var Value: AnsiString): Integer;
Begin
     Result := KeyIndex(Key, False);
     If Result >= 0 Then
          Value := FValues[Result]
     Else
          Value := '';
End;

Function TStringDictionary.LocateNext(Const Key: AnsiString; Const Idx: Integer; Var Value: AnsiString): Integer;
Var
     L, H, I, J, K            : Integer;
Begin
     Result := -1;
     L := Length(FLookup);
     If L = 0 Then
          DictionaryError('Item not found');
     H := HashStr(Key, L, FCaseSensitive);
     For I := 0 To Length(FLookup[H]) - 1 Do Begin
          J := FLookup[H, I];
          If J = Idx Then Begin
               If Not StrEqual(Key, FKeys[J], FCaseSensitive) Then
                    DictionaryError('Item not found');
               For K := I + 1 To Length(FLookup[H]) - 1 Do Begin
                    J := FLookup[H, K];
                    If StrEqual(Key, FKeys[J], FCaseSensitive) Then Begin
                         Value := FValues[J];
                         Result := J;
                         exit;
                    End;
               End;
               Result := -1;
               exit;
          End;
     End;
     DictionaryError('Item not found');
End;

Procedure TStringDictionary.SetItem(Const Key: AnsiString; Const Value: AnsiString);
Var
     I                        : Integer;
Begin
     I := KeyIndex(Key, False);
     If I >= 0 Then
          FValues[I] := Value
     Else If AddOnSet Then
          Add(Key, Value)
     Else
          KeyNotFoundError(Key);
End;

Procedure TStringDictionary.IndexError;
Begin
     DictionaryError('Index out of range');
End;

Function TStringDictionary.Count: Integer;
Begin
     Result := FKeys.Count;
     Assert(FValues.Count = Result, 'Key/Value count mismatch');
End;

Function TStringDictionary.GetKeyByIndex(Const Idx: Integer): AnsiString;
Begin
     {$IFOPT R+}
     If (Idx < 0) Or (Idx >= FKeys.Count) Then
          IndexError;
     {$ENDIF}
     Result := FKeys[Idx];
End;

Procedure TStringDictionary.DeleteItemByIndex(Const Idx: Integer);
Begin
     {$IFOPT R+}
     If (Idx < 0) Or (Idx >= FValues.Count) Then
          IndexError;
     {$ENDIF}
     DeleteByIndex(Idx, -1);
End;

Function TStringDictionary.GetItemByIndex(Const Idx: Integer): AnsiString;
Begin
     {$IFOPT R+}
     If (Idx < 0) Or (Idx >= FValues.Count) Then
          IndexError;
     {$ENDIF}
     Result := FValues[Idx];
End;

Procedure TStringDictionary.SetItemByIndex(Const Idx: Integer; Const Value: AnsiString);
Begin
     {$IFOPT R+}
     If (Idx < 0) Or (Idx >= FValues.Count) Then
          IndexError;
     {$ENDIF}
     FValues[Idx] := Value;
End;

Procedure TStringDictionary.Clear;
Begin
     FKeys.Clear;
     FValues.Clear;
     Rehash;
End;









End.
