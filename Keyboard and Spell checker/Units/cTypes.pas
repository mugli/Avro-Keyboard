{$INCLUDE cDictionaryDefines.inc}

Unit cTypes;

{                                                                              }
{                            Type base class v3.04                             }
{                                                                              }
{      This unit is copyright © 1999-2002 by David Butler (david@e.co.za)      }
{                                                                              }
{                  This unit is part of Delphi Fundamentals.                   }
{                    Its original file name is cTypes.pas                      }
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
{   [ cTypes ]                                                                 }
{   1999/11/12  0.01  Split cTypes from cDataStruct and cHolder.               }
{                      Default implementations for Assign, IsEqual             }
{   2001/07/30  1.02  Removed interfaces in AType (each interface adds four    }
{                      bytes to the instance size).                            }
{   [ cDataStructs ]                                                           }
{   2001/08/20  2.03  Merged cTypes and cDataStructs to allow object           }
{                      interface implementation in base classes.               }
{   [ cTypes ]                                                                 }
{   2002/05/15  3.04  Created cTypes from cDataStructs.                        }
{                                                                              }

Interface

Uses
     { Delphi }
     SysUtils,

     { Fundamentals }
     cUtils;



{                                                                              }
{ Note on class naming convention:                                             }
{   Classes with the A-prefix are abstract base classes. They define the       }
{   interface for the type and must never be instanciated.                     }
{                                                                              }



{                                                                              }
{ AType                                                                        }
{   Abstract base class for data structures.                                   }
{                                                                              }
{   Provides an interface for commonly used data operations such as            }
{   assigning, comparing and duplicating.                                      }
{                                                                              }
{   Duplicate creates a new instance of the object and copies the content.     }
{   Clear sets an instance's content (value) to an empty/zero state.           }
{   IsEqual compares content of an instances.                                  }
{   Compare is the ranking function used by sorting and searching.             }
{   Assign's default implementation calls the protected AssignTo.              }
{                                                                              }
Type
     AType = Class
     Protected
          Procedure TypeError(Const Msg: AnsiString; Const Error: Exception = Nil;
               Const ErrorClass: ExceptClass = Nil);
          Procedure MethodNotImplementedError(Const Method: AnsiString);

          Procedure Init; Virtual;
          Procedure AssignTo(Const Dest: TObject); Virtual;

          Function GetAsString: AnsiString; Virtual;
          Procedure SetAsString(Const S: AnsiString); Virtual;

     Public
          Constructor Create;
          Class Function CreateInstance: AType; Virtual;

          Function Duplicate: TObject; Virtual;
          Procedure Assign(Const Source: TObject); Virtual;
          Procedure Clear; Virtual;
          Function IsEmpty: Boolean; Virtual;
          Function IsEqual(Const V: TObject): Boolean; Virtual;
          Function Compare(Const V: TObject): TCompareResult; Virtual;
          Function HashValue: LongWord; Virtual;
          Property AsString: AnsiString Read GetAsString Write SetAsString;
     End;
     EType = Class(Exception);
     TypeClass = Class Of AType;
     ATypeArray = Array Of AType;
     TypeClassArray = Array Of TypeClass;



     {                                                                              }
     { AType helper functions                                                       }
     {                                                                              }
Function TypeDuplicate(Const V: TObject): TObject;
Procedure TypeAssign(Const A, B: TObject);
Function TypeIsEqual(Const A, B: TObject): Boolean;
Function TypeCompare(Const A, B: TObject): TCompareResult;
Function TypeGetAsString(Const V: TObject): AnsiString;
Procedure TypeSetAsString(Const V: TObject; Const S: AnsiString);
Function TypeHashValue(Const A: TObject): LongWord;



Implementation



{                                                                              }
{ AType                                                                        }
{                                                                              }

Constructor AType.Create;
Begin
     Inherited Create;
     Init;
End;

Procedure AType.Init;
Begin
End;

Procedure AType.TypeError(Const Msg: AnsiString; Const Error: Exception; Const ErrorClass: ExceptClass);
Var
     S                        : AnsiString;
Begin
     S := {$IFDEF DEBUG}ObjectClassName(self) + ': ' + {$ENDIF}
     Msg;
     If Assigned(Error) Then
          S := S + ': ' + AnsiString(Error.Message);
     If Assigned(ErrorClass) Then
          Raise ErrorClass.Create(S)
     Else
          Raise EType.Create(S);
End;

Procedure AType.MethodNotImplementedError(Const Method: AnsiString);
Begin
     TypeError('Method ' + ObjectClassName(self) + '.' + Method + ' not implemented');
End;

Class Function AType.CreateInstance: AType;
Begin
     Result := AType(TypeClass(self).Create);
End;

Procedure AType.Clear;
Begin
     MethodNotImplementedError('Clear');
End;

{$WARNINGS OFF}

Function AType.IsEmpty: Boolean;
Begin
     MethodNotImplementedError('IsEmpty');
End;
{$WARNINGS ON}

Function AType.Duplicate: TObject;
Begin
     Try
          Result := CreateInstance;
          Try
               AType(Result).Assign(self);
          Except
               FreeAndNil(Result);
               Raise;
          End;
     Except
          On E: Exception Do
               TypeError('Duplicate failed', E);
     End;
End;

Procedure AType.Assign(Const Source: TObject);
Var
     R                        : Boolean;
Begin
     If Source Is AType Then Try
          AType(Source).AssignTo(self);
          R := True;
     Except
          R := False;
     End
     Else
          R := False;
     If Not R Then
          TypeError(ObjectClassName(self) + ' can not assign from ' + ObjectClassName(Source));
End;

Procedure AType.AssignTo(Const Dest: TObject);
Begin
     TypeError(ObjectClassName(self) + ' can not assign to ' + ObjectClassName(Dest));
End;

{$WARNINGS OFF}

Function AType.IsEqual(Const V: TObject): Boolean;
Begin
     TypeError(ObjectClassName(self) + ' can not compare with ' + ObjectClassName(V));
End;

Function AType.Compare(Const V: TObject): TCompareResult;
Begin
     TypeError(ObjectClassName(self) + ' can not compare with ' + ObjectClassName(V));
End;

Function AType.HashValue: LongWord;
Begin
     Try
          Result := HashStr(GetAsString, MaxLongWord, True);
     Except
          On E: Exception Do
               TypeError('Hash error', E);
     End;
End;
{$WARNINGS ON}

Function AType.GetAsString: AnsiString;
Begin
     MethodNotImplementedError('GetAsString');
End;

Procedure AType.SetAsString(Const S: AnsiString);
Begin
     MethodNotImplementedError('SetAsString');
End;



{                                                                              }
{ AType helper functions                                                       }
{                                                                              }

Function TypeGetAsString(Const V: TObject): AnsiString;
Begin
     If V Is AType Then
          Result := AType(V).GetAsString
     Else
          Raise EType.Create(ObjectClassName(V) + ' can not convert to AnsiString');
End;

Procedure TypeSetAsString(Const V: TObject; Const S: AnsiString);
Begin
     If V Is AType Then
          AType(V).SetAsString(S)
     Else
          Raise EType.Create(ObjectClassName(V) + ' can not set as AnsiString');
End;

Function TypeDuplicate(Const V: TObject): TObject;
Begin
     If V Is AType Then
          Result := AType(V).Duplicate
     Else If Not Assigned(V) Then
          Result := Nil
     Else
          Raise EType.Create(ObjectClassName(V) + ' can not duplicate');
End;

Function TypeIsEqual(Const A, B: TObject): Boolean;
Begin
     If A = B Then
          Result := True
     Else If A Is AType Then
          Result := AType(A).IsEqual(B)
     Else If B Is AType Then
          Result := AType(B).IsEqual(A)
     Else
          Raise EType.Create(ObjectClassName(A) + ' and ' + ObjectClassName(B) + ' can not compare');
End;

Function TypeCompare(Const A, B: TObject): TCompareResult;
Begin
     If A = B Then
          Result := crEqual
     Else If A Is AType Then
          Result := AType(A).Compare(B)
     Else If B Is AType Then
          Result := NegatedCompareResult(AType(B).Compare(A))
     Else
          Result := crUndefined;
End;

Procedure TypeAssign(Const A, B: TObject);
Begin
     If A = B Then
          exit
     Else If A Is AType Then
          AType(A).Assign(B)
     Else If B Is AType Then
          AType(B).AssignTo(A)
     Else
          Raise EType.Create(ObjectClassName(B) + ' can not assign to ' + ObjectClassName(A));
End;

{$WARNINGS OFF}

Function TypeHashValue(Const A: TObject): LongWord;
Begin
     If Not Assigned(A) Then
          Result := 0
     Else If A Is AType Then
          Result := AType(A).HashValue
     Else
          Raise EType.Create(ObjectClassName(A) + ' can not calculate hash value');
End;
{$WARNINGS ON}



End.
