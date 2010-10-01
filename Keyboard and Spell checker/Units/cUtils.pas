{$INCLUDE cDictionaryDefines.inc}

Unit cUtils;

{                                                                              }
{                    Miscellaneous utility functions v3.30                     }
{                                                                              }
{      This unit is copyright © 2000-2002 by David Butler (david@e.co.za)      }
{                                                                              }
{                  This unit is part of Delphi Fundamentals.                   }
{                     Its original file name is cUtils.pas                     }
{                     It was generated 19 Jan 2003 07:16.                      }
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
{   2000/02/02  0.01  Initial version                                          }
{   2000/03/08  1.02  Moved RealArray / IntegerArray functions from cMaths.    }
{   2000/04/10  1.03  Added Append, Renamed Delete to Remove and added         }
{                     StringArrays.                                            }
{   2000/05/03  1.04  Added Path functions.                                    }
{                     Added locked integer manipulation functions.             }
{   2000/05/08  1.05  Cleaned up unit.                                         }
{                     188 lines interface. 1171 lines implementation.          }
{   2000/06/01  1.06  Added Range and Dup constructors for dynamic arrays.     }
{   2000/06/03  1.07  Added ArrayInsert functions.                             }
{   2000/06/06  1.08  Moved bit functions from cMaths.                         }
{   2000/06/08  1.09  Removed TInteger, TReal, TRealArray, TIntegerArray.      }
{                     299 lines interface. 2019 lines implementations.         }
{   2000/06/10  1.10  Added linked lists for Integer, Int64, Extended and      }
{                     String.                                                  }
{                     518 lines interface. 3396 lines implementation.          }
{   2000/06/14  1.11  cUtils now generated from a template using a source      }
{                     pre-processor that uses cUtils.                          }
{                     560 lines interface. 1328 lines implementation.          }
{                     Produced source: 644 lines interface, 4716 lines         }
{                     implementation.                                          }
{   2000/07/04  1.12  Revision for Fundamentals release.                       }
{   2000/07/24  1.13  Added TrimArray functions.                               }
{   2000/07/26  1.14  Added Difference functions.                              }
{   2000/09/02  1.15  Added RemoveDuplicates functions.                        }
{                     Added Count functions.                                   }
{                     Fixed bug in Sort.                                       }
{   2000/09/27  1.16  Fixed bug in ArrayInsert.                                }
{   2000/11/29  1.17  Moved SetFPUPrecision to cSysUtils.                      }
{   2001/05/03  1.18  Improved bit functions. Added Pascal versions of         }
{                     assembly routines.                                       }
{                     Templ: 867 lines interface, 2886 lines implementation.   }
{                     Source: 939 lines interface, 9796 lines implementation.  }
{   2001/05/13  1.19  Added CharCount.                                         }
{   2001/05/15  1.20  Added PosNext (ClassType, ObjectArray).                  }
{   2001/05/18  1.21  Added hashing functions from cMaths.                     }
{   2001/07/07  1.22  Added TBinaryTreeNode.                                   }
{   2001/11/11  2.23  Revision.                                                }
{   2002/01/03  2.24  Moved EncodeBase64, DecodeBase64 from cMaths and         }
{                     optimized. Added LongWordToHex, HexToLongWord.           }
{   2002/03/30  2.25  Fixed bug in DecodeBase64.                               }
{   2002/04/02  2.26  Removed dependencies on all other units (incl. Delphi    )
{                     units) to remove initialization code associated with     }
{                     SysUtils. This allows usage of cUtils in projects        }
{                     and still have very small binaries.                      }
{                     Fixed bug in LongWordToHex.                              }
{   2002/05/31  3.27  Refactored for Fundamentals 3.                           }
{                     Moved linked lists to cLinkedLists.                      }
{   2002/08/09  3.28  Added HashInteger.                                       }
{   2002/10/06  3.29  Renamed Cond to iif.                                     }
{   2002/12/12  3.30  Small revisions.                                         }
{                                                                              }
Interface

Const
     UnitName                 = 'cUtils';
     UnitVersion              = '3.30';
     UnitDesc                 = 'Miscelleanous utility functions';
     UnitCopyright            = '(c) 2000-2002 David J Butler';



     {                                                                              }
     { Integer types                                                                }
     {   Byte      unsigned 8 bits                                                  }
     {   Word      unsigned 16 bits                                                 }
     {   LongWord  unsigned 32 bits                                                 }
     {   ShortInt  signed 8 bits                                                    }
     {   SmallInt  signed 16 bits                                                   }
     {   LongInt   signed 32 bits                                                   }
     {   Int64     signed 64 bits                                                   }
     {   Integer   signed system word                                               }
     {   Cardinal  unsigned system word                                             }
     {                                                                              }
Type
     Int8 = ShortInt;
     Int16 = SmallInt;
     Int32 = LongInt;

     {$IFNDEF DELPHI6_UP}
     PBoolean = ^Boolean;
     PByte = ^Byte;
     PWord = ^Word;
     PLongWord = ^LongWord;
     PShortInt = ^ShortInt;
     PSmallInt = ^SmallInt;
     PLongInt = ^LongInt;
     PInteger = ^Integer;
     PInt64 = ^Int64;
     {$ENDIF}

Const
     MinByte                  = Low(Byte);
     MaxByte                  = High(Byte);
     MinWord                  = Low(Word);
     MaxWord                  = High(Word);
     MinLongWord              = Low(LongWord);
     MaxLongWord              = High(LongWord);
     MinShortInt              = Low(ShortInt);
     MaxShortInt              = High(ShortInt);
     MinSmallInt              = Low(SmallInt);
     MaxSmallInt              = High(SmallInt);
     MinLongInt               = Low(LongInt);
     MaxLongInt               = High(LongInt);
     MaxInt64                 = High(Int64);
     MinInt64                 = Low(Int64);
     MinInteger               = Low(Integer);
     MaxInteger               = High(Integer);
     MinCardinal              = Low(Cardinal);
     MaxCardinal              = High(Cardinal);

     BitsPerByte              = 8;
     BitsPerWord              = 16;
     BitsPerLongWord          = 32;
     BytesPerCardinal         = Sizeof(Cardinal);
     BitsPerCardinal          = BytesPerCardinal * 8;

Function MinI(Const A, B: Integer): Integer;
Function MaxI(Const A, B: Integer): Integer;

Function Clip(Const Value: Integer; Const Low, High: Integer): Integer; overload;
Function ClipByte(Const Value: Integer): Integer;
Function ClipWord(Const Value: Integer): Integer;

Function RangeAdjacent(Const Low1, High1, Low2, High2: Integer): Boolean;
Function RangeOverlap(Const Low1, High1, Low2, High2: Integer): Boolean;



{                                                                              }
{ Floating point types                                                         }
{   Single    32 bits                                                          }
{   Double    64 bits                                                          }
{   Extended  80 bits                                                          }
{                                                                              }
Const
     MinSingle                = 1.5E-45;
     MaxSingle                = 3.4E+38;
     MinDouble                = 5.0E-324;
     MaxDouble                = 1.7E+308;
     MinExtended              = 3.4E-4932;
     MaxExtended              = 1.1E+4932;

     {$IFNDEF DELPHI6_UP}
Type
     PSingle = ^Single;
     PDouble = ^Double;
     PExtended = ^Extended;
     {$ENDIF}

     { Approximate comparison functions                                             }
Type
     TCompareResult = (crLess,          // <
          crEqual,                      // =
          crGreater,                    // >
          crUndefined);
     TCompareResultSet = Set Of TCompareResult;

Const
     DefaultCompareEpsilon    = 1E-9;

Function ApproxZero(Const Value: Extended;
     Const CompareEpsilon: Double = DefaultCompareEpsilon): Boolean;
Function ApproxEqual(Const A, B: Extended;
     Const CompareEpsilon: Double = DefaultCompareEpsilon): Boolean;
Function ApproxCompare(Const A, B: Extended;
     Const CompareEpsilon: Double = DefaultCompareEpsilon): TCompareResult;



{                                                                              }
{ Bit functions                                                                }
{   All bit functions operate on 32-bit values (LongWord).                     }
{                                                                              }
Function ClearBit(Const Value, BitIndex: LongWord): LongWord;
Function SetBit(Const Value, BitIndex: LongWord): LongWord;
Function IsBitSet(Const Value, BitIndex: LongWord): Boolean;
Function ToggleBit(Const Value, BitIndex: LongWord): LongWord;
Function IsHighBitSet(Const Value: LongWord): Boolean;

Function SetBitScanForward(Const Value: LongWord): Integer; overload;
Function SetBitScanForward(Const Value, BitIndex: LongWord): Integer; overload;
Function SetBitScanReverse(Const Value: LongWord): Integer; overload;
Function SetBitScanReverse(Const Value, BitIndex: LongWord): Integer; overload;
Function ClearBitScanForward(Const Value: LongWord): Integer; overload;
Function ClearBitScanForward(Const Value, BitIndex: LongWord): Integer; overload;
Function ClearBitScanReverse(Const Value: LongWord): Integer; overload;
Function ClearBitScanReverse(Const Value, BitIndex: LongWord): Integer; overload;

Function ReverseBits(Const Value: LongWord): LongWord; overload;
Function ReverseBits(Const Value: LongWord; Const BitCount: Integer): LongWord; overload;
Function SwapEndian(Const Value: LongWord): LongWord;
Procedure SwapEndianBuf(Var Buf; Const Count: Integer);
Function TwosComplement(Const Value: LongWord): LongWord;

Function RotateLeftBits(Const Value: LongWord; Const Bits: Byte): LongWord;
Function RotateRightBits(Const Value: LongWord; Const Bits: Byte): LongWord;

Function BitCount(Const Value: LongWord): LongWord;
Function IsPowerOfTwo(Const Value: LongWord): Boolean;

Function LowBitMask(Const HighBitIndex: LongWord): LongWord;
Function HighBitMask(Const LowBitIndex: LongWord): LongWord;
Function RangeBitMask(Const LowBitIndex, HighBitIndex: LongWord): LongWord;

Function SetBitRange(Const Value: LongWord;
     Const LowBitIndex, HighBitIndex: LongWord): LongWord;
Function ClearBitRange(Const Value: LongWord;
     Const LowBitIndex, HighBitIndex: LongWord): LongWord;
Function ToggleBitRange(Const Value: LongWord;
     Const LowBitIndex, HighBitIndex: LongWord): LongWord;
Function IsBitRangeSet(Const Value: LongWord;
     Const LowBitIndex, HighBitIndex: LongWord): Boolean;
Function IsBitRangeClear(Const Value: LongWord;
     Const LowBitIndex, HighBitIndex: LongWord): Boolean;

Const
     BitMaskTable             : Array[0..31] Of LongWord =
          ($00000001, $00000002, $00000004, $00000008,
          $00000010, $00000020, $00000040, $00000080,
          $00000100, $00000200, $00000400, $00000800,
          $00001000, $00002000, $00004000, $00008000,
          $00010000, $00020000, $00040000, $00080000,
          $00100000, $00200000, $00400000, $00800000,
          $01000000, $02000000, $04000000, $08000000,
          $10000000, $20000000, $40000000, $80000000);



     {                                                                              }
     { Sets                                                                         }
     {                                                                              }
Type
     CharSet = Set Of Char;
     ByteSet = Set Of Byte;
     PCharSet = ^CharSet;
     PByteSet = ^ByteSet;

Const
     CompleteCharSet          = [#0..#255];
     CompleteByteSet          = [0..255];

Function AsCharSet(Const C: Array Of Char): CharSet;
Function AsByteSet(Const C: Array Of Byte): ByteSet;
Procedure ComplementChar(Var C: CharSet; Const Ch: Char);
Procedure ClearCharSet(Var C: CharSet);
Procedure FillCharSet(Var C: CharSet);
Procedure ComplementCharSet(Var C: CharSet);
Procedure AssignCharSet(Var DestSet: CharSet; Const SourceSet: CharSet); overload;
Procedure Union(Var DestSet: CharSet; Const SourceSet: CharSet); overload;
Procedure Difference(Var DestSet: CharSet; Const SourceSet: CharSet); overload;
Procedure Intersection(Var DestSet: CharSet; Const SourceSet: CharSet); overload;
Procedure XORCharSet(Var DestSet: CharSet; Const SourceSet: CharSet);
Function IsSubSet(Const A, B: CharSet): Boolean;
Function IsEqual(Const A, B: CharSet): Boolean; overload;
Function IsEmpty(Const C: CharSet): Boolean;
Function IsComplete(Const C: CharSet): Boolean;
Function CharCount(Const C: CharSet): Integer; overload;
Procedure ConvertCaseInsensitive(Var C: CharSet);
Function CaseInsensitiveCharSet(Const C: CharSet): CharSet;



{                                                                              }
{ Swap                                                                         }
{                                                                              }
Procedure Swap(Var X, Y: Boolean); overload;
Procedure Swap(Var X, Y: Byte); overload;
Procedure Swap(Var X, Y: Word); overload;
Procedure Swap(Var X, Y: LongWord); overload;
Procedure Swap(Var X, Y: ShortInt); overload;
Procedure Swap(Var X, Y: SmallInt); overload;
Procedure Swap(Var X, Y: LongInt); overload;
Procedure Swap(Var X, Y: Int64); overload;
Procedure Swap(Var X, Y: Single); overload;
Procedure Swap(Var X, Y: Double); overload;
Procedure Swap(Var X, Y: Extended); overload;
Procedure Swap(Var X, Y: String); overload;
Procedure Swap(Var X, Y: Pointer); overload;
Procedure Swap(Var X, Y: TObject); overload;
Procedure SwapObjects(Var X, Y);



{                                                                              }
{ iif                                                                          }
{   iif (inline if) returns TrueValue if Expr is True, otherwise it returns    }
{   FalseValue.                                                                }
{                                                                              }
Function iif(Const Expr: Boolean; Const TrueValue: Integer;
     Const FalseValue: Integer = 0): Integer; overload;
Function iif(Const Expr: Boolean; Const TrueValue: Int64;
     Const FalseValue: Int64 = 0): Int64; overload;
Function iif(Const Expr: Boolean; Const TrueValue: Extended;
     Const FalseValue: Extended = 0.0): Extended; overload;
Function iif(Const Expr: Boolean; Const TrueValue: String;
     Const FalseValue: String = ''): String; overload;
Function iif(Const Expr: Boolean; Const TrueValue: TObject;
     Const FalseValue: TObject = Nil): TObject; overload;



{                                                                              }
{ Compare                                                                      }
{                                                                              }
Function Compare(Const I1, I2: Boolean): TCompareResult; overload;
Function Compare(Const I1, I2: Integer): TCompareResult; overload;
Function Compare(Const I1, I2: Int64): TCompareResult; overload;
Function Compare(Const I1, I2: Extended): TCompareResult; overload;
Function Compare(Const I1, I2: String): TCompareResult; overload;
Function NegatedCompareResult(Const C: TCompareResult): TCompareResult;



{                                                                              }
{ Base Conversion                                                              }
{   EncodeBase64 converts a binary string (S) to a base 64 string using        }
{   Alphabet. if Pad is True, the result will be padded with PadChar to be a   }
{   multiple of PadMultiple.                                                   }
{   DecodeBase64 converts a base 64 string using Alphabet (64 characters for   }
{   values 0-63) to a binary string.                                           }
{                                                                              }
Const
     s_HexDigitsUpper         : String[16] = '0123456789ABCDEF';
     s_HexDigitsLower         : String[16] = '0123456789abcdef';

Function IsHexChar(Const Ch: Char): Boolean;
Function HexCharValue(Const Ch: Char): Byte;

Function LongWordToBin(Const I: LongWord; Const Digits: Byte = 0): String;
Function LongWordToOct(Const I: LongWord; Const Digits: Byte = 0): String;
Function LongWordToHex(Const I: LongWord; Const Digits: Byte = 0): String;
Function LongWordToStr(Const I: LongWord; Const Digits: Byte = 0): String;

Function BinToLongWord(Const S: String): LongWord;
Function OctToLongWord(Const S: String): LongWord;
Function HexToLongWord(Const S: String): LongWord;
Function StrToLongWord(Const S: String): LongWord;

Function EncodeBase64(Const S, Alphabet: String; Const Pad: Boolean = False;
     Const PadMultiple: Integer = 4; Const PadChar: Char = '='): String;
Function DecodeBase64(Const S, Alphabet: String; Const PadSet: CharSet = []): String;

Const
     b64_MIMEBase64           = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
     b64_UUEncode             = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
     b64_XXEncode             = '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

Function MIMEBase64Decode(Const S: String): String;
Function MIMEBase64Encode(Const S: String): String;
Function UUDecode(Const S: String): String;
Function XXDecode(Const S: String): String;

Function BytesToHex(Const P: Pointer; Const Count: Integer): String;



{                                                                              }
{ Type conversion                                                              }
{                                                                              }
Function PointerToStr(Const P: Pointer): String;
Function StrToPointer(Const S: String): Pointer;
Function ObjectClassName(Const O: TObject): String;
Function ClassClassName(Const C: TClass): String;
Function ObjectToStr(Const O: TObject): String;
Function ClassToStr(Const C: TClass): String;
Function CharSetToStr(Const C: CharSet): String;
Function StrToCharSet(Const S: String): CharSet;



{                                                                              }
{ Hash functions                                                               }
{                                                                              }
Function HashBuf(Const Buf; Const BufSize: Integer;
     Const Slots: LongWord = 0): LongWord;
Function HashStr(Const StrBuf: Pointer; Const StrLength: Integer;
     Const Slots: LongWord = 0; Const CaseSensitive: Boolean = True): LongWord; overload;
Function HashStr(Const S: String; Const Slots: LongWord = 0;
     Const CaseSensitive: Boolean = True): LongWord; overload;
Function HashInteger(Const I: Integer; Const Slots: LongWord = 0): LongWord;



{                                                                              }
{ Memory                                                                       }
{                                                                              }
Procedure MoveMem(Const Source; Var Dest; Const Count: Integer);
Function CompareMem(Const Buf1; Const Buf2; Const Count: Integer): Boolean;
Function CompareMemNoCase(Const Buf1; Const Buf2; Const Count: Integer): TCompareResult;
Procedure ReverseMem(Var Buf; Const Size: Integer);



{                                                                              }
{ Dynamic Arrays                                                               }
{                                                                              }
Type
     ByteArray = Array Of Byte;
     WordArray = Array Of Word;
     LongWordArray = Array Of LongWord;
     ShortIntArray = Array Of ShortInt;
     SmallIntArray = Array Of SmallInt;
     LongIntArray = Array Of LongInt;
     Int64Array = Array Of Int64;
     SingleArray = Array Of Single;
     DoubleArray = Array Of Double;
     ExtendedArray = Array Of Extended;
     StringArray = Array Of String;
     PointerArray = Array Of Pointer;
     ObjectArray = Array Of TObject;
     BooleanArray = Array Of Boolean;
     CharSetArray = Array Of CharSet;
     ByteSetArray = Array Of ByteSet;
     IntegerArray = LongIntArray;
     CardinalArray = LongWordArray;


Function Append(Var V: ByteArray; Const R: Byte): Integer; overload;
Function Append(Var V: WordArray; Const R: Word): Integer; overload;
Function Append(Var V: LongWordArray; Const R: LongWord): Integer; overload;
Function Append(Var V: ShortIntArray; Const R: ShortInt): Integer; overload;
Function Append(Var V: SmallIntArray; Const R: SmallInt): Integer; overload;
Function Append(Var V: LongIntArray; Const R: LongInt): Integer; overload;
Function Append(Var V: Int64Array; Const R: Int64): Integer; overload;
Function Append(Var V: SingleArray; Const R: Single): Integer; overload;
Function Append(Var V: DoubleArray; Const R: Double): Integer; overload;
Function Append(Var V: ExtendedArray; Const R: Extended): Integer; overload;
Function Append(Var V: StringArray; Const R: String): Integer; overload;
Function Append(Var V: BooleanArray; Const R: Boolean): Integer; overload;
Function Append(Var V: PointerArray; Const R: Pointer): Integer; overload;
Function Append(Var V: ObjectArray; Const R: TObject): Integer; overload;
Function Append(Var V: ByteSetArray; Const R: ByteSet): Integer; overload;
Function Append(Var V: CharSetArray; Const R: CharSet): Integer; overload;
Function AppendByteArray(Var V: ByteArray; Const R: Array Of Byte): Integer; overload;
Function AppendWordArray(Var V: WordArray; Const R: Array Of Word): Integer; overload;
Function AppendCardinalArray(Var V: CardinalArray; Const R: Array Of LongWord): Integer; overload;
Function AppendShortIntArray(Var V: ShortIntArray; Const R: Array Of ShortInt): Integer; overload;
Function AppendSmallIntArray(Var V: SmallIntArray; Const R: Array Of SmallInt): Integer; overload;
Function AppendIntegerArray(Var V: IntegerArray; Const R: Array Of LongInt): Integer; overload;
Function AppendInt64Array(Var V: Int64Array; Const R: Array Of Int64): Integer; overload;
Function AppendSingleArray(Var V: SingleArray; Const R: Array Of Single): Integer; overload;
Function AppendDoubleArray(Var V: DoubleArray; Const R: Array Of Double): Integer; overload;
Function AppendExtendedArray(Var V: ExtendedArray; Const R: Array Of Extended): Integer; overload;
Function AppendStringArray(Var V: StringArray; Const R: Array Of String): Integer; overload;
Function AppendPointerArray(Var V: PointerArray; Const R: Array Of Pointer): Integer; overload;
Function AppendObjectArray(Var V: ObjectArray; Const R: Array Of TObject): Integer; overload;
Function AppendCharSetArray(Var V: CharSetArray; Const R: Array Of CharSet): Integer; overload;
Function AppendByteSetArray(Var V: ByteSetArray; Const R: Array Of ByteSet): Integer; overload;


Function Remove(Var V: ByteArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: WordArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: LongWordArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: ShortIntArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: SmallIntArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: LongIntArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: Int64Array; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: SingleArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: DoubleArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: ExtendedArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: StringArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: PointerArray; Const Idx: Integer; Const Count: Integer = 1): Integer; overload;
Function Remove(Var V: ObjectArray; Const Idx: Integer; Const Count: Integer = 1;
     Const FreeObjects: Boolean = False): Integer; overload;

Procedure RemoveDuplicates(Var V: ByteArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: WordArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: LongWordArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: ShortIntArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: SmallIntArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: LongIntArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: Int64Array; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: SingleArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: DoubleArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: ExtendedArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: StringArray; Const IsSorted: Boolean); overload;
Procedure RemoveDuplicates(Var V: PointerArray; Const IsSorted: Boolean); overload;

Procedure TrimArrayLeft(Var S: ByteArray; Const TrimList: Array Of Byte); overload;
Procedure TrimArrayLeft(Var S: WordArray; Const TrimList: Array Of Word); overload;
Procedure TrimArrayLeft(Var S: LongWordArray; Const TrimList: Array Of LongWord); overload;
Procedure TrimArrayLeft(Var S: ShortIntArray; Const TrimList: Array Of ShortInt); overload;
Procedure TrimArrayLeft(Var S: SmallIntArray; Const TrimList: Array Of SmallInt); overload;
Procedure TrimArrayLeft(Var S: LongIntArray; Const TrimList: Array Of LongInt); overload;
Procedure TrimArrayLeft(Var S: Int64Array; Const TrimList: Array Of Int64); overload;
Procedure TrimArrayLeft(Var S: SingleArray; Const TrimList: Array Of Single); overload;
Procedure TrimArrayLeft(Var S: DoubleArray; Const TrimList: Array Of Double); overload;
Procedure TrimArrayLeft(Var S: ExtendedArray; Const TrimList: Array Of Extended); overload;
Procedure TrimArrayLeft(Var S: StringArray; Const TrimList: Array Of String); overload;
Procedure TrimArrayLeft(Var S: PointerArray; Const TrimList: Array Of Pointer); overload;

Procedure TrimArrayRight(Var S: ByteArray; Const TrimList: Array Of Byte); overload;
Procedure TrimArrayRight(Var S: WordArray; Const TrimList: Array Of Word); overload;
Procedure TrimArrayRight(Var S: LongWordArray; Const TrimList: Array Of LongWord); overload;
Procedure TrimArrayRight(Var S: ShortIntArray; Const TrimList: Array Of ShortInt); overload;
Procedure TrimArrayRight(Var S: SmallIntArray; Const TrimList: Array Of SmallInt); overload;
Procedure TrimArrayRight(Var S: LongIntArray; Const TrimList: Array Of LongInt); overload;
Procedure TrimArrayRight(Var S: Int64Array; Const TrimList: Array Of Int64); overload;
Procedure TrimArrayRight(Var S: SingleArray; Const TrimList: Array Of Single); overload;
Procedure TrimArrayRight(Var S: DoubleArray; Const TrimList: Array Of Double); overload;
Procedure TrimArrayRight(Var S: ExtendedArray; Const TrimList: Array Of Extended); overload;
Procedure TrimArrayRight(Var S: StringArray; Const TrimList: Array Of String); overload;
Procedure TrimArrayRight(Var S: PointerArray; Const TrimList: Array Of Pointer); overload;

Function ArrayInsert(Var V: ByteArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: WordArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: LongWordArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: ShortIntArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: SmallIntArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: LongIntArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: Int64Array; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: SingleArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: DoubleArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: ExtendedArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: StringArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: PointerArray; Const Idx: Integer; Const Count: Integer): Integer; overload;
Function ArrayInsert(Var V: ObjectArray; Const Idx: Integer; Const Count: Integer): Integer; overload;

Procedure FreeObjectArray(Var V); overload;
Procedure FreeObjectArray(Var V; Const LoIdx, HiIdx: Integer); overload;
Procedure FreeAndNilObjectArray(Var V: ObjectArray);

Function PosNext(Const Find: Byte; Const V: ByteArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: Word; Const V: WordArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: LongWord; Const V: LongWordArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: ShortInt; Const V: ShortIntArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: SmallInt; Const V: SmallIntArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: LongInt; Const V: LongIntArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: Int64; Const V: Int64Array; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: Single; Const V: SingleArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: Double; Const V: DoubleArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: Extended; Const V: ExtendedArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: Boolean; Const V: BooleanArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: String; Const V: StringArray; Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function PosNext(Const Find: Pointer; Const V: PointerArray;
     Const PrevPos: Integer = -1): Integer; overload;
Function PosNext(Const Find: TObject; Const V: ObjectArray;
     Const PrevPos: Integer = -1): Integer; overload;
Function PosNext(Const ClassType: TClass; Const V: ObjectArray;
     Const PrevPos: Integer = -1): Integer; overload;
Function PosNext(Const ClassName: String; Const V: ObjectArray;
     Const PrevPos: Integer = -1): Integer; overload;

Function Count(Const Find: Byte; Const V: ByteArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: Word; Const V: WordArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: LongWord; Const V: LongWordArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: ShortInt; Const V: ShortIntArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: SmallInt; Const V: SmallIntArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: LongInt; Const V: LongIntArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: Int64; Const V: Int64Array;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: Single; Const V: SingleArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: Double; Const V: DoubleArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: Extended; Const V: ExtendedArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: String; Const V: StringArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;
Function Count(Const Find: Boolean; Const V: BooleanArray;
     Const IsSortedAscending: Boolean = False): Integer; overload;

Procedure RemoveAll(Const Find: Byte; Var V: ByteArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: Word; Var V: WordArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: LongWord; Var V: LongWordArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: ShortInt; Var V: ShortIntArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: SmallInt; Var V: SmallIntArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: LongInt; Var V: LongIntArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: Int64; Var V: Int64Array;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: Single; Var V: SingleArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: Double; Var V: DoubleArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: Extended; Var V: ExtendedArray;
     Const IsSortedAscending: Boolean = False); overload;
Procedure RemoveAll(Const Find: String; Var V: StringArray;
     Const IsSortedAscending: Boolean = False); overload;

Function Intersection(Const V1, V2: ByteArray;
     Const IsSortedAscending: Boolean = False): ByteArray; overload;
Function Intersection(Const V1, V2: WordArray;
     Const IsSortedAscending: Boolean = False): WordArray; overload;
Function Intersection(Const V1, V2: LongWordArray;
     Const IsSortedAscending: Boolean = False): LongWordArray; overload;
Function Intersection(Const V1, V2: ShortIntArray;
     Const IsSortedAscending: Boolean = False): ShortIntArray; overload;
Function Intersection(Const V1, V2: SmallIntArray;
     Const IsSortedAscending: Boolean = False): SmallIntArray; overload;
Function Intersection(Const V1, V2: LongIntArray;
     Const IsSortedAscending: Boolean = False): LongIntArray; overload;
Function Intersection(Const V1, V2: Int64Array;
     Const IsSortedAscending: Boolean = False): Int64Array; overload;
Function Intersection(Const V1, V2: SingleArray;
     Const IsSortedAscending: Boolean = False): SingleArray; overload;
Function Intersection(Const V1, V2: DoubleArray;
     Const IsSortedAscending: Boolean = False): DoubleArray; overload;
Function Intersection(Const V1, V2: ExtendedArray;
     Const IsSortedAscending: Boolean = False): ExtendedArray; overload;
Function Intersection(Const V1, V2: StringArray;
     Const IsSortedAscending: Boolean = False): StringArray; overload;

Function Difference(Const V1, V2: ByteArray;
     Const IsSortedAscending: Boolean = False): ByteArray; overload;
Function Difference(Const V1, V2: WordArray;
     Const IsSortedAscending: Boolean = False): WordArray; overload;
Function Difference(Const V1, V2: LongWordArray;
     Const IsSortedAscending: Boolean = False): LongWordArray; overload;
Function Difference(Const V1, V2: ShortIntArray;
     Const IsSortedAscending: Boolean = False): ShortIntArray; overload;
Function Difference(Const V1, V2: SmallIntArray;
     Const IsSortedAscending: Boolean = False): SmallIntArray; overload;
Function Difference(Const V1, V2: LongIntArray;
     Const IsSortedAscending: Boolean = False): LongIntArray; overload;
Function Difference(Const V1, V2: Int64Array;
     Const IsSortedAscending: Boolean = False): Int64Array; overload;
Function Difference(Const V1, V2: SingleArray;
     Const IsSortedAscending: Boolean = False): SingleArray; overload;
Function Difference(Const V1, V2: DoubleArray;
     Const IsSortedAscending: Boolean = False): DoubleArray; overload;
Function Difference(Const V1, V2: ExtendedArray;
     Const IsSortedAscending: Boolean = False): ExtendedArray; overload;
Function Difference(Const V1, V2: StringArray;
     Const IsSortedAscending: Boolean = False): StringArray; overload;

Procedure Reverse(Var V: ByteArray); overload;
Procedure Reverse(Var V: WordArray); overload;
Procedure Reverse(Var V: LongWordArray); overload;
Procedure Reverse(Var V: ShortIntArray); overload;
Procedure Reverse(Var V: SmallIntArray); overload;
Procedure Reverse(Var V: LongIntArray); overload;
Procedure Reverse(Var V: Int64Array); overload;
Procedure Reverse(Var V: SingleArray); overload;
Procedure Reverse(Var V: DoubleArray); overload;
Procedure Reverse(Var V: ExtendedArray); overload;
Procedure Reverse(Var V: StringArray); overload;
Procedure Reverse(Var V: PointerArray); overload;
Procedure Reverse(Var V: ObjectArray); overload;

Function AsBooleanArray(Const V: Array Of Boolean): BooleanArray; overload;
Function AsByteArray(Const V: Array Of Byte): ByteArray; overload;
Function AsWordArray(Const V: Array Of Word): WordArray; overload;
Function AsLongWordArray(Const V: Array Of LongWord): LongWordArray; overload;
Function AsCardinalArray(Const V: Array Of Cardinal): CardinalArray; overload;
Function AsShortIntArray(Const V: Array Of ShortInt): ShortIntArray; overload;
Function AsSmallIntArray(Const V: Array Of SmallInt): SmallIntArray; overload;
Function AsLongIntArray(Const V: Array Of LongInt): LongIntArray; overload;
Function AsIntegerArray(Const V: Array Of Integer): IntegerArray; overload;
Function AsInt64Array(Const V: Array Of Int64): Int64Array; overload;
Function AsSingleArray(Const V: Array Of Single): SingleArray; overload;
Function AsDoubleArray(Const V: Array Of Double): DoubleArray; overload;
Function AsExtendedArray(Const V: Array Of Extended): ExtendedArray; overload;
Function AsStringArray(Const V: Array Of String): StringArray; overload;
Function AsPointerArray(Const V: Array Of Pointer): PointerArray; overload;
Function AsCharSetArray(Const V: Array Of CharSet): CharSetArray; overload;
Function AsObjectArray(Const V: Array Of TObject): ObjectArray; overload;

Function RangeByte(Const First: Byte; Const Count: Integer;
     Const Increment: Byte = 1): ByteArray;
Function RangeWord(Const First: Word; Const Count: Integer;
     Const Increment: Word = 1): WordArray;
Function RangeLongWord(Const First: LongWord; Const Count: Integer;
     Const Increment: LongWord = 1): LongWordArray;
Function RangeCardinal(Const First: Cardinal; Const Count: Integer;
     Const Increment: Cardinal = 1): CardinalArray;
Function RangeShortInt(Const First: ShortInt; Const Count: Integer;
     Const Increment: ShortInt = 1): ShortIntArray;
Function RangeSmallInt(Const First: SmallInt; Const Count: Integer;
     Const Increment: SmallInt = 1): SmallIntArray;
Function RangeLongInt(Const First: LongInt; Const Count: Integer;
     Const Increment: LongInt = 1): LongIntArray;
Function RangeInteger(Const First: Integer; Const Count: Integer;
     Const Increment: Integer = 1): IntegerArray;
Function RangeInt64(Const First: Int64; Const Count: Integer;
     Const Increment: Int64 = 1): Int64Array;
Function RangeSingle(Const First: Single; Const Count: Integer;
     Const Increment: Single = 1): SingleArray;
Function RangeDouble(Const First: Double; Const Count: Integer;
     Const Increment: Double = 1): DoubleArray;
Function RangeExtended(Const First: Extended; Const Count: Integer;
     Const Increment: Extended = 1): ExtendedArray;

Function DupByte(Const V: Byte; Const Count: Integer): ByteArray;
Function DupWord(Const V: Word; Const Count: Integer): WordArray;
Function DupLongWord(Const V: LongWord; Const Count: Integer): LongWordArray;
Function DupCardinal(Const V: Cardinal; Const Count: Integer): CardinalArray;
Function DupShortInt(Const V: ShortInt; Const Count: Integer): ShortIntArray;
Function DupSmallInt(Const V: SmallInt; Const Count: Integer): SmallIntArray;
Function DupLongInt(Const V: LongInt; Const Count: Integer): LongIntArray;
Function DupInteger(Const V: Integer; Const Count: Integer): IntegerArray;
Function DupInt64(Const V: Int64; Const Count: Integer): Int64Array;
Function DupSingle(Const V: Single; Const Count: Integer): SingleArray;
Function DupDouble(Const V: Double; Const Count: Integer): DoubleArray;
Function DupExtended(Const V: Extended; Const Count: Integer): ExtendedArray;
Function DupString(Const V: String; Const Count: Integer): StringArray;
Function DupCharSet(Const V: CharSet; Const Count: Integer): CharSetArray;
Function DupObject(Const V: TObject; Const Count: Integer): ObjectArray;

Procedure SetLengthAndZero(Var V: ByteArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: WordArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: LongWordArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: ShortIntArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: SmallIntArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: LongIntArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: Int64Array; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: SingleArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: DoubleArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: ExtendedArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: CharSetArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: BooleanArray; Const NewLength: Integer); overload;
Procedure SetLengthAndZero(Var V: ObjectArray; Const NewLength: Integer;
     Const FreeObjects: Boolean = False); overload;

Function IsEqual(Const V1, V2: ByteArray): Boolean; overload;
Function IsEqual(Const V1, V2: WordArray): Boolean; overload;
Function IsEqual(Const V1, V2: LongWordArray): Boolean; overload;
Function IsEqual(Const V1, V2: ShortIntArray): Boolean; overload;
Function IsEqual(Const V1, V2: SmallIntArray): Boolean; overload;
Function IsEqual(Const V1, V2: LongIntArray): Boolean; overload;
Function IsEqual(Const V1, V2: Int64Array): Boolean; overload;
Function IsEqual(Const V1, V2: SingleArray): Boolean; overload;
Function IsEqual(Const V1, V2: DoubleArray): Boolean; overload;
Function IsEqual(Const V1, V2: ExtendedArray): Boolean; overload;
Function IsEqual(Const V1, V2: StringArray): Boolean; overload;
Function IsEqual(Const V1, V2: CharSetArray): Boolean; overload;

Function ByteArrayToLongIntArray(Const V: ByteArray): LongIntArray;
Function WordArrayToLongIntArray(Const V: WordArray): LongIntArray;
Function ShortIntArrayToLongIntArray(Const V: ShortIntArray): LongIntArray;
Function SmallIntArrayToLongIntArray(Const V: SmallIntArray): LongIntArray;
Function LongIntArrayToInt64Array(Const V: LongIntArray): Int64Array;
Function LongIntArrayToSingleArray(Const V: LongIntArray): SingleArray;
Function LongIntArrayToDoubleArray(Const V: LongIntArray): DoubleArray;
Function LongIntArrayToExtendedArray(Const V: LongIntArray): ExtendedArray;
Function SingleArrayToExtendedArray(Const V: SingleArray): ExtendedArray;
Function SingleArrayToDoubleArray(Const V: SingleArray): DoubleArray;
Function SingleArrayToLongIntArray(Const V: SingleArray): LongIntArray;
Function SingleArrayToInt64Array(Const V: SingleArray): Int64Array;
Function DoubleArrayToSingleArray(Const V: DoubleArray): SingleArray;
Function DoubleArrayToExtendedArray(Const V: DoubleArray): ExtendedArray;
Function DoubleArrayToLongIntArray(Const V: DoubleArray): LongIntArray;
Function DoubleArrayToInt64Array(Const V: DoubleArray): Int64Array;
Function ExtendedArrayToSingleArray(Const V: ExtendedArray): SingleArray;
Function ExtendedArrayToDoubleArray(Const V: ExtendedArray): DoubleArray;
Function ExtendedArrayToLongIntArray(Const V: ExtendedArray): LongIntArray;
Function ExtendedArrayToInt64Array(Const V: ExtendedArray): Int64Array;

Function ByteArrayFromIndexes(Const V: ByteArray;
     Const Indexes: IntegerArray): ByteArray;
Function WordArrayFromIndexes(Const V: WordArray;
     Const Indexes: IntegerArray): WordArray;
Function LongWordArrayFromIndexes(Const V: LongWordArray;
     Const Indexes: IntegerArray): LongWordArray;
Function CardinalArrayFromIndexes(Const V: CardinalArray;
     Const Indexes: IntegerArray): CardinalArray;
Function ShortIntArrayFromIndexes(Const V: ShortIntArray;
     Const Indexes: IntegerArray): ShortIntArray;
Function SmallIntArrayFromIndexes(Const V: SmallIntArray;
     Const Indexes: IntegerArray): SmallIntArray;
Function LongIntArrayFromIndexes(Const V: LongIntArray;
     Const Indexes: IntegerArray): LongIntArray;
Function IntegerArrayFromIndexes(Const V: IntegerArray;
     Const Indexes: IntegerArray): IntegerArray;
Function Int64ArrayFromIndexes(Const V: Int64Array;
     Const Indexes: IntegerArray): Int64Array;
Function SingleArrayFromIndexes(Const V: SingleArray;
     Const Indexes: IntegerArray): SingleArray;
Function DoubleArrayFromIndexes(Const V: DoubleArray;
     Const Indexes: IntegerArray): DoubleArray;
Function ExtendedArrayFromIndexes(Const V: ExtendedArray;
     Const Indexes: IntegerArray): ExtendedArray;
Function StringArrayFromIndexes(Const V: StringArray;
     Const Indexes: IntegerArray): StringArray;

Procedure Sort(Var V: ByteArray); overload;
Procedure Sort(Var V: WordArray); overload;
Procedure Sort(Var V: LongWordArray); overload;
Procedure Sort(Var V: ShortIntArray); overload;
Procedure Sort(Var V: SmallIntArray); overload;
Procedure Sort(Var V: LongIntArray); overload;
Procedure Sort(Var V: Int64Array); overload;
Procedure Sort(Var V: SingleArray); overload;
Procedure Sort(Var V: DoubleArray); overload;
Procedure Sort(Var V: ExtendedArray); overload;
Procedure Sort(Var V: StringArray); overload;

Procedure Sort(Var Key: IntegerArray; Var Data: IntegerArray); overload;
Procedure Sort(Var Key: IntegerArray; Var Data: Int64Array); overload;
Procedure Sort(Var Key: IntegerArray; Var Data: StringArray); overload;
Procedure Sort(Var Key: IntegerArray; Var Data: ExtendedArray); overload;
Procedure Sort(Var Key: IntegerArray; Var Data: PointerArray); overload;
Procedure Sort(Var Key: StringArray; Var Data: IntegerArray); overload;
Procedure Sort(Var Key: StringArray; Var Data: Int64Array); overload;
Procedure Sort(Var Key: StringArray; Var Data: StringArray); overload;
Procedure Sort(Var Key: StringArray; Var Data: ExtendedArray); overload;
Procedure Sort(Var Key: StringArray; Var Data: PointerArray); overload;
Procedure Sort(Var Key: ExtendedArray; Var Data: IntegerArray); overload;
Procedure Sort(Var Key: ExtendedArray; Var Data: Int64Array); overload;
Procedure Sort(Var Key: ExtendedArray; Var Data: StringArray); overload;
Procedure Sort(Var Key: ExtendedArray; Var Data: ExtendedArray); overload;
Procedure Sort(Var Key: ExtendedArray; Var Data: PointerArray); overload;



{                                                                              }
{ Self testing code                                                            }
{                                                                              }
Procedure SelfTest;



Implementation



{                                                                              }
{ Integer                                                                      }
{                                                                              }

Function MinI(Const A, B: Integer): Integer;
Begin
     If A < B Then
          Result := A
     Else
          Result := B;
End;

Function MaxI(Const A, B: Integer): Integer;
Begin
     If A > B Then
          Result := A
     Else
          Result := B;
End;

Function Clip(Const Value: Integer; Const Low, High: Integer): Integer;
Begin
     If Value < Low Then
          Result := Low
     Else If Value > High Then
          Result := High
     Else
          Result := Value;
End;

Function ClipByte(Const Value: Integer): Integer;
Begin
     If Value < MinByte Then
          Result := MinByte
     Else If Value > MaxByte Then
          Result := MaxByte
     Else
          Result := Value;
End;

Function ClipWord(Const Value: Integer): Integer;
Begin
     If Value < MinWord Then
          Result := MinWord
     Else If Value > MaxWord Then
          Result := MaxWord
     Else
          Result := Value;
End;

Function RangeAdjacent(Const Low1, High1, Low2, High2: Integer): Boolean;
Begin
     Result := ((Low2 > MinInteger) And (High1 = Low2 - 1)) Or
          ((High2 < MaxInteger) And (Low1 = High2 + 1));
End;

Function RangeOverlap(Const Low1, High1, Low2, High2: Integer): Boolean;
Begin
     Result := ((Low1 >= Low2) And (Low1 <= High2)) Or
          ((Low2 >= Low1) And (Low2 <= High1));
End;



{                                                                              }
{ Float                                                                        }
{                                                                              }

{ Approximate comparison functions taken from FltMath by Tempest Software as   }
{ taken from Knuth, Seminumerical Algorithms, 2nd ed., Addison-Wesley,         }
{ 1981, pp. 217-20.                                                            }
Type
     TExtended = Packed Record
          Case Boolean Of
               True: (
                    Mantissa: Packed Array[0..1] Of LongWord; { MSB of [1] is the normalized 1 bit }
                    Exponent: Word;     { MSB is the sign bit }
                    );
               False: (Value: Extended);
     End;

Function ApproxEqual(Const A, B: Extended; Const CompareEpsilon: Double): Boolean;
Var
     ExtA                     : TExtended Absolute A;
     ExtB                     : TExtended Absolute B;
     ExpA                     : Word;
     ExpB                     : Word;
     Exp                      : TExtended;
Begin
     ExpA := ExtA.Exponent And $7FFF;
     ExpB := ExtB.Exponent And $7FFF;
     If (ExpA = $7FFF) And
          ((ExtA.Mantissa[1] <> $80000000) Or (ExtA.Mantissa[0] <> 0)) Then
          { A is NaN }
          Result := False
     Else If (ExpB = $7FFF) And
          ((ExtB.Mantissa[1] <> $80000000) Or (ExtB.Mantissa[0] <> 0)) Then
          { B is NaN }
          Result := False
     Else If (ExpA = $7FFF) Or (ExpB = $7FFF) Then
          { A or B is infinity. Use the builtin comparison, which will       }
          { properly account for signed infinities, comparing infinity with  }
          { infinity, or comparing infinity with a finite value.             }
          Result := A = B
     Else Begin
          { We are comparing two finite values, so take the difference and   }
          { compare that against the scaled Epsilon.                         }
          Exp.Value := 1.0;
          If ExpA < ExpB Then
               Exp.Exponent := ExpB
          Else
               Exp.Exponent := ExpA;
          Result := Abs(A - B) <= (CompareEpsilon * Exp.Value);
     End;
End;

Function ApproxCompare(Const A, B: Extended; Const CompareEpsilon: Double): TCompareResult;
Var
     ExtA                     : TExtended Absolute A;
     ExtB                     : TExtended Absolute B;
     ExpA                     : Word;
     ExpB                     : Word;
     Exp                      : TExtended;
     V                        : Extended;
Begin
     ExpA := ExtA.Exponent And $7FFF;
     ExpB := ExtB.Exponent And $7FFF;
     If (ExpA = $7FFF) And
          ((ExtA.Mantissa[1] <> $80000000) Or (ExtA.Mantissa[0] <> 0)) Then
          { A is NaN }
          Result := crUndefined
     Else If (ExpB = $7FFF) And
          ((ExtB.Mantissa[1] <> $80000000) Or (ExtB.Mantissa[0] <> 0)) Then
          { B is NaN }
          Result := crUndefined
     Else If (ExpA = $7FFF) Or (ExpB = $7FFF) Then
          { A or B is infinity. Use the builtin comparison, which will       }
          { properly account for signed infinities, comparing infinity with  }
          { infinity, or comparing infinity with a finite value.             }
          Result := Compare(A, B)
     Else Begin
          { We are comparing two finite values, so take the difference and   }
          { compare that against the scaled Epsilon.                         }
          Exp.Value := 1.0;
          If ExpA < ExpB Then
               Exp.Exponent := ExpB
          Else
               Exp.Exponent := ExpA;
          V := CompareEpsilon * Exp.Value;
          If Abs(A - B) <= V Then
               Result := crEqual
          Else If A - B >= V Then
               Result := crGreater
          Else
               Result := crLess;
     End;
End;

Function ApproxZero(Const Value: Extended; Const CompareEpsilon: Double): Boolean;
Begin
     Result := ApproxEqual(Value, 0.0, CompareEpsilon);
End;



{                                                                              }
{ Bit functions                                                                }
{                                                                              }

{ Assembly versions of ReverseBits and SwapEndian taken from the               }
{ Delphi Encryption Compendium by Hagen Reddmann (HaReddmann@aol.com)          }
{$IFDEF CPU_INTEL386}

Function ReverseBits(Const Value: LongWord): LongWord;
Asm
      BSWAP   EAX
      MOV     EDX, EAX
      AND     EAX, 0AAAAAAAAh
      SHR     EAX, 1
      AND     EDX, 055555555h
      SHL     EDX, 1
      OR      EAX, EDX
      MOV     EDX, EAX
      AND     EAX, 0CCCCCCCCh
      SHR     EAX, 2
      AND     EDX, 033333333h
      SHL     EDX, 2
      OR      EAX, EDX
      MOV     EDX, EAX
      AND     EAX, 0F0F0F0F0h
      SHR     EAX, 4
      AND     EDX, 00F0F0F0Fh
      SHL     EDX, 4
      OR      EAX, EDX
End;
{$ELSE}

Function ReverseBits(Const Value: LongWord): LongWord;
Var
     I                        : Byte;
Begin
     Result := 0;
     For I := 0 To 31 Do
          If Value And BitMaskTable[I] <> 0 Then
               Result := Result Or BitMaskTable[31 - I];
End;
{$ENDIF}

Function ReverseBits(Const Value: LongWord; Const BitCount: Integer): LongWord;
Var
     I                        : Integer;
     V                        : LongWord;
Begin
     V := Value;
     Result := 0;
     For I := 0 To MinI(BitCount, BitsPerLongWord) - 1 Do Begin
          Result := (Result Shl 1) Or (V And 1);
          V := V Shr 1;
     End;
End;

{$IFDEF CPU_INTEL386}

Function SwapEndian(Const Value: LongWord): LongWord;
Asm
      XCHG    AH, AL
      ROL     EAX, 16
      XCHG    AH, AL
End;
{$ELSE}

Function SwapEndian(Const Value: LongWord): LongWord;
Type
     Bytes4 = Packed Record
          B1, B2, B3, B4: Byte;
     End;
Var
     Val                      : Bytes4 Absolute Value;
     Res                      : Bytes4 Absolute Result;
Begin
     Res.B4 := Val.B1;
     Res.B3 := Val.B2;
     Res.B2 := Val.B3;
     Res.B1 := Val.B4;
End;
{$ENDIF}

Procedure SwapEndianBuf(Var Buf; Const Count: Integer);
Var
     P                        : PLongWord;
     I                        : Integer;
Begin
     P := @Buf;
     For I := 1 To Count Do Begin
          P^ := SwapEndian(P^);
          Inc(P);
     End;
End;

{$IFDEF CPU_INTEL386}

Function TwosComplement(Const Value: LongWord): LongWord;
Asm
      NEG EAX
End;
{$ELSE}

Function TwosComplement(Const Value: LongWord): LongWord;
Begin
     Result := Not Value + 1;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function RotateLeftBits(Const Value: LongWord; Const Bits: Byte): LongWord;
Asm
      MOV   CL, DL
      ROL   EAX, CL
End;
{$ELSE}

Function RotateLeftBits(Const Value: LongWord; Const Bits: Byte): LongWord;
Var
     I                        : Integer;
Begin
     Result := Value;
     For I := 1 To Bits Do
          If Value And $80000000 = 0 Then
               Result := Value Shl 1
          Else
               Result := (Value Shl 1) Or 1;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function RotateRightBits(Const Value: LongWord; Const Bits: Byte): LongWord;
Asm
      MOV   CL, DL
      ROL   EAX, CL
End;
{$ELSE}

Function RotateRightBits(Const Value: LongWord; Const Bits: Byte): LongWord;
Var
     I                        : Integer;
Begin
     Result := Value;
     For I := 1 To Bits Do
          If Value And 1 = 0 Then
               Result := Value Shr 1
          Else
               Result := (Value Shr 1) Or $80000000;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function SetBit(Const Value, BitIndex: LongWord): LongWord;
Asm
      {$IFOPT R+}
      CMP     BitIndex, BitsPerLongWord
      JAE     @Fin
      {$ENDIF}
      OR      EAX, DWORD PTR [BitIndex * 4 + BitMaskTable]
    @Fin:
End;
{$ELSE}

Function SetBit(Const Value, BitIndex: LongWord): LongWord;
Begin
     Result := Value Or BitMaskTable[BitIndex];
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function ClearBit(Const Value, BitIndex: LongWord): LongWord;
Asm
      {$IFOPT R+}
      CMP     BitIndex, BitsPerLongWord
      JAE     @Fin
      {$ENDIF}
      MOV     ECX, DWORD PTR [BitIndex * 4 + BitMaskTable]
      NOT     ECX
      AND     EAX, ECX
    @Fin:
End;
{$ELSE}

Function ClearBit(Const Value, BitIndex: LongWord): LongWord;
Begin
     Result := Value And Not BitMaskTable[BitIndex];
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function ToggleBit(Const Value, BitIndex: LongWord): LongWord;
Asm
      {$IFOPT R+}
      CMP     BitIndex, BitsPerLongWord
      JAE     @Fin
      {$ENDIF}
      XOR     EAX, DWORD PTR [BitIndex * 4 + BitMaskTable]
    @Fin:
End;
{$ELSE}

Function ToggleBit(Const Value, BitIndex: LongWord): LongWord;
Begin
     Result := Value Xor BitMaskTable[BitIndex];
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function IsHighBitSet(Const Value: LongWord): Boolean;
Asm
      TEST    Value, $80000000
      SETNZ   AL
End;
{$ELSE}

Function IsHighBitSet(Const Value: LongWord): Boolean;
Begin
     Result := Value And $80000000 <> 0;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function IsBitSet(Const Value, BitIndex: LongWord): Boolean;
Asm
      {$IFOPT R+}
      CMP     BitIndex, BitsPerLongWord
      JAE     @Fin
      {$ENDIF}
      MOV     ECX, DWORD PTR BitMaskTable [BitIndex * 4]
      TEST    Value, ECX
      SETNZ   AL
    @Fin:
End;
{$ELSE}

Function IsBitSet(Const Value, BitIndex: LongWord): Boolean;
Begin
     Result := Value And BitMaskTable[BitIndex] <> 0;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function SetBitScanForward(Const Value: LongWord): Integer;
Asm
      OR      EAX, EAX
      JZ      @NoBits
      BSF     EAX, EAX
      RET
  @NoBits:
      MOV     EAX, -1
End;

Function SetBitScanForward(Const Value, BitIndex: LongWord): Integer;
Asm
      {$IFOPT R+}
      CMP     BitIndex, BitsPerLongWord
      JAE     @@zq
      {$ENDIF}
      MOV     ECX, BitIndex
      MOV     EDX, $FFFFFFFF
      SHL     EDX, CL
      AND     EDX, EAX
      JE      @@zq
      BSF     EAX, EDX
      RET
@@zq: MOV     EAX, -1
End;
{$ELSE}

Function SetBitScanForward(Const Value, BitIndex: LongWord): Integer;
Var
     I                        : Byte;
Begin
     For I := BitIndex To 31 Do
          If Value And BitMaskTable[I] <> 0 Then Begin
               Result := I;
               exit;
          End;
     Result := -1;
End;

Function SetBitScanForward(Const Value: LongWord): Integer;
Begin
     Result := SetBitScanForward(Value, 0);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function SetBitScanReverse(Const Value: LongWord): Integer;
Asm
      OR      EAX, EAX
      JZ      @NoBits
      BSR     EAX, EAX
      RET
  @NoBits:
      MOV     EAX, -1
End;

Function SetBitScanReverse(Const Value, BitIndex: LongWord): Integer;
Asm
      {$IFOPT R+}
      CMP     EDX, BitsPerLongWord
      JAE     @@zq
      {$ENDIF}
      LEA     ECX, [EDX-31]
      MOV     EDX, $FFFFFFFF
      NEG     ECX
      SHR     EDX, CL
      AND     EDX, EAX
      JE      @@zq
      BSR     EAX, EDX
      RET
@@zq: MOV     EAX, -1
End;
{$ELSE}

Function SetBitScanReverse(Const Value, BitIndex: LongWord): Integer;
Var
     I                        : Byte;
Begin
     For I := BitIndex Downto 0 Do
          If Value And BitMaskTable[I] <> 0 Then Begin
               Result := I;
               exit;
          End;
     Result := -1;
End;

Function SetBitScanReverse(Const Value: LongWord): Integer;
Begin
     Result := SetBitScanReverse(Value, 31);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function ClearBitScanForward(Const Value: LongWord): Integer;
Asm
      NOT     EAX
      OR      EAX, EAX
      JZ      @NoBits
      BSF     EAX, EAX
      RET
  @NoBits:
      MOV     EAX, -1
End;

Function ClearBitScanForward(Const Value, BitIndex: LongWord): Integer;
Asm
      {$IFOPT R+}
      CMP     EDX, BitsPerLongWord
      JAE     @@zq
      {$ENDIF}
      MOV     ECX, EDX
      MOV     EDX, $FFFFFFFF
      NOT     EAX
      SHL     EDX, CL
      AND     EDX, EAX
      JE      @@zq
      BSF     EAX, EDX
      RET
@@zq: MOV     EAX, -1
End;
{$ELSE}

Function ClearBitScanForward(Const Value, BitIndex: LongWord): Integer;
Var
     I                        : Byte;
Begin
     For I := BitIndex To 31 Do
          If Value And BitMaskTable[I] = 0 Then Begin
               Result := I;
               exit;
          End;
     Result := -1;
End;

Function ClearBitScanForward(Const Value: LongWord): Integer;
Begin
     Result := ClearBitScanForward(Value, 0);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function ClearBitScanReverse(Const Value: LongWord): Integer;
Asm
      NOT     EAX
      OR      EAX, EAX
      JZ      @NoBits
      BSR     EAX, EAX
      RET
  @NoBits:
      MOV     EAX, -1
End;

Function ClearBitScanReverse(Const Value, BitIndex: LongWord): Integer;
Asm
      {$IFOPT R+}
      CMP     EDX, BitsPerLongWord
      JAE     @@zq
      {$ENDIF}
      LEA     ECX, [EDX-31]
      MOV     EDX, $FFFFFFFF
      NEG     ECX
      NOT     EAX
      SHR     EDX, CL
      AND     EDX, EAX
      JE      @@zq
      BSR     EAX, EDX
      RET
@@zq: MOV     EAX, -1
End;
{$ELSE}

Function ClearBitScanReverse(Const Value, BitIndex: LongWord): Integer;
Var
     I                        : Byte;
Begin
     For I := BitIndex Downto 0 Do
          If Value And BitMaskTable[I] = 0 Then Begin
               Result := I;
               exit;
          End;
     Result := -1;
End;

Function ClearBitScanReverse(Const Value: LongWord): Integer;
Begin
     Result := ClearBitScanReverse(Value, 31);
End;
{$ENDIF}

Const
     BitCountTable            : Array[0..255] Of Byte =
          (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
          1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
          1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
          2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
          1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
          2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
          2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
          3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
          1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
          2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
          2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
          3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
          2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
          3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
          3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
          4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8);

     {$IFDEF CPU_INTEL386}

Function BitCount(Const Value: LongWord): LongWord;
Asm
      MOVZX   EDX, AL
      MOVZX   EDX, BYTE PTR [EDX + BitCountTable]
      MOVZX   ECX, AH
      ADD     DL, BYTE PTR [ECX + BitCountTable]
      SHR     EAX, 16
      MOVZX   ECX, AH
      ADD     DL, BYTE PTR [ECX + BitCountTable]
      AND     EAX, $FF
      ADD     DL, BYTE PTR [EAX + BitCountTable]
      MOV     AL, DL
End;
{$ELSE}

Function BitCount(Const Value: LongWord): LongWord;
Var
     V                        : Array[0..3] Of Byte Absolute Value;
Begin
     Result := BitCountTable[V[0]] + BitCountTable[V[1]] +
          BitCountTable[V[2]] + BitCountTable[V[3]];
End;
{$ENDIF}

Function IsPowerOfTwo(Const Value: LongWord): Boolean;
Begin
     Result := BitCount(Value) = 1;
End;

Function LowBitMask(Const HighBitIndex: LongWord): LongWord;
Begin
     {$IFOPT R+}
     If HighBitIndex >= BitsPerLongWord Then
          Result := 0
     Else
          {$ENDIF}
          Result := BitMaskTable[HighBitIndex] - 1;
End;

Function HighBitMask(Const LowBitIndex: LongWord): LongWord;
Begin
     {$IFOPT R+}
     If LowBitIndex >= BitsPerLongWord Then
          Result := 0
     Else
          {$ENDIF}
          Result := Not BitMaskTable[LowBitIndex] + 1;
End;

Function RangeBitMask(Const LowBitIndex, HighBitIndex: LongWord): LongWord;
Begin
     {$IFOPT R+}
     If (LowBitIndex >= BitsPerLongWord) And (HighBitIndex >= BitsPerLongWord) Then Begin
          Result := 0;
          exit;
     End;
     {$ENDIF}
     Result := $FFFFFFFF;
     If LowBitIndex > 0 Then
          Result := Result Xor (BitMaskTable[LowBitIndex] - 1);
     If HighBitIndex < 31 Then
          Result := Result Xor (Not BitMaskTable[HighBitIndex + 1] + 1);
End;

Function SetBitRange(Const Value: LongWord; Const LowBitIndex, HighBitIndex: LongWord): LongWord;
Begin
     Result := Value Or RangeBitMask(LowBitIndex, HighBitIndex);
End;

Function ClearBitRange(Const Value: LongWord; Const LowBitIndex, HighBitIndex: LongWord): LongWord;
Begin
     Result := Value And Not RangeBitMask(LowBitIndex, HighBitIndex);
End;

Function ToggleBitRange(Const Value: LongWord; Const LowBitIndex, HighBitIndex: LongWord): LongWord;
Begin
     Result := Value Xor RangeBitMask(LowBitIndex, HighBitIndex);
End;

Function IsBitRangeSet(Const Value: LongWord; Const LowBitIndex, HighBitIndex: LongWord): Boolean;
Var
     M                        : LongWord;
Begin
     M := RangeBitMask(LowBitIndex, HighBitIndex);
     Result := Value And M = M;
End;

Function IsBitRangeClear(Const Value: LongWord; Const LowBitIndex, HighBitIndex: LongWord): Boolean;
Begin
     Result := Value And RangeBitMask(LowBitIndex, HighBitIndex) = 0;
End;



{                                                                              }
{ Sets                                                                         }
{                                                                              }

Function AsCharSet(Const C: Array Of Char): CharSet;
Var
     I                        : Integer;
Begin
     Result := [];
     For I := 0 To High(C) Do
          Include(Result, C[I]);
End;

Function AsByteSet(Const C: Array Of Byte): ByteSet;
Var
     I                        : Integer;
Begin
     Result := [];
     For I := 0 To High(C) Do
          Include(Result, C[I]);
End;

{$IFDEF CPU_INTEL386}

Procedure ComplementChar(Var C: CharSet; Const Ch: Char);
Asm
      MOVZX   ECX, DL
      BTC     [EAX], ECX
End;
{$ELSE}

Procedure ComplementChar(Var C: CharSet; Const Ch: Char);
Begin
     If Ch In C Then
          Exclude(C, Ch)
     Else
          Include(C, Ch);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure ClearCharSet(Var C: CharSet);
Asm
      XOR     EDX, EDX
      MOV     [EAX], EDX
      MOV     [EAX + 4], EDX
      MOV     [EAX + 8], EDX
      MOV     [EAX + 12], EDX
      MOV     [EAX + 16], EDX
      MOV     [EAX + 20], EDX
      MOV     [EAX + 24], EDX
      MOV     [EAX + 28], EDX
End;
{$ELSE}

Procedure ClearCharSet(Var C: CharSet);
Begin
     C := [];
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure FillCharSet(Var C: CharSet);
Asm
      MOV     EDX, $FFFFFFFF
      MOV     [EAX], EDX
      MOV     [EAX + 4], EDX
      MOV     [EAX + 8], EDX
      MOV     [EAX + 12], EDX
      MOV     [EAX + 16], EDX
      MOV     [EAX + 20], EDX
      MOV     [EAX + 24], EDX
      MOV     [EAX + 28], EDX
End;
{$ELSE}

Procedure FillCharSet(Var C: CharSet);
Begin
     C := [#0..#255];
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure ComplementCharSet(Var C: CharSet);
Asm
      NOT     DWORD PTR [EAX]
      NOT     DWORD PTR [EAX + 4]
      NOT     DWORD PTR [EAX + 8]
      NOT     DWORD PTR [EAX + 12]
      NOT     DWORD PTR [EAX + 16]
      NOT     DWORD PTR [EAX + 20]
      NOT     DWORD PTR [EAX + 24]
      NOT     DWORD PTR [EAX + 28]
End;
{$ELSE}

Procedure ComplementCharSet(Var C: CharSet);
Begin
     C := [#0..#255] - C;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure AssignCharSet(Var DestSet: CharSet; Const SourceSet: CharSet);
Asm
      MOV     ECX, [EDX]
      MOV     [EAX], ECX
      MOV     ECX, [EDX + 4]
      MOV     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      MOV     [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      MOV     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      MOV     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      MOV     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      MOV     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      MOV     [EAX + 28], ECX
End;
{$ELSE}

Procedure AssignCharSet(Var DestSet: CharSet; Const SourceSet: CharSet);
Begin
     DestSet := SourceSet;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Union(Var DestSet: CharSet; Const SourceSet: CharSet);
Asm
      MOV     ECX, [EDX]
      OR      [EAX], ECX
      MOV     ECX, [EDX + 4]
      OR      [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      OR      [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      OR      [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      OR      [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      OR      [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      OR      [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      OR      [EAX + 28], ECX
End;
{$ELSE}

Procedure Union(Var DestSet: CharSet; Const SourceSet: CharSet);
Begin
     DestSet := DestSet + SourceSet;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Difference(Var DestSet: CharSet; Const SourceSet: CharSet);
Asm
      MOV     ECX, [EDX]
      NOT     ECX
      AND     [EAX], ECX
      MOV     ECX, [EDX + 4]
      NOT     ECX
      AND     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      NOT     ECX
      AND     [EAX + 8],ECX
      MOV     ECX, [EDX + 12]
      NOT     ECX
      AND     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      NOT     ECX
      AND     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      NOT     ECX
      AND     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      NOT     ECX
      AND     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      NOT     ECX
      AND     [EAX + 28], ECX
End;
{$ELSE}

Procedure Difference(Var DestSet: CharSet; Const SourceSet: CharSet);
Begin
     DestSet := DestSet - SourceSet;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Intersection(Var DestSet: CharSet; Const SourceSet: CharSet);
Asm
      MOV     ECX, [EDX]
      AND     [EAX], ECX
      MOV     ECX, [EDX + 4]
      AND     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      AND     [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      AND     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      AND     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      AND     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      AND     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      AND     [EAX + 28], ECX
End;
{$ELSE}

Procedure Intersection(Var DestSet: CharSet; Const SourceSet: CharSet);
Begin
     DestSet := DestSet * SourceSet;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure XORCharSet(Var DestSet: CharSet; Const SourceSet: CharSet);
Asm
      MOV     ECX, [EDX]
      XOR     [EAX], ECX
      MOV     ECX, [EDX + 4]
      XOR     [EAX + 4], ECX
      MOV     ECX, [EDX + 8]
      XOR     [EAX + 8], ECX
      MOV     ECX, [EDX + 12]
      XOR     [EAX + 12], ECX
      MOV     ECX, [EDX + 16]
      XOR     [EAX + 16], ECX
      MOV     ECX, [EDX + 20]
      XOR     [EAX + 20], ECX
      MOV     ECX, [EDX + 24]
      XOR     [EAX + 24], ECX
      MOV     ECX, [EDX + 28]
      XOR     [EAX + 28], ECX
End;
{$ELSE}

Procedure XORCharSet(Var DestSet: CharSet; Const SourceSet: CharSet);
Var
     Ch                       : Char;
Begin
     For Ch := #0 To #255 Do
          If Ch In DestSet Then Begin
               If Ch In SourceSet Then
                    Exclude(DestSet, Ch);
          End
          Else If Ch In SourceSet Then
               Include(DestSet, Ch);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function IsSubSet(Const A, B: CharSet): Boolean;
Asm
      MOV     ECX, [EDX]
      NOT     ECX
      AND     ECX, [EAX]
      JNE     @Fin0
      MOV     ECX, [EDX + 4]
      NOT     ECX
      AND     ECX, [EAX + 4]
      JNE     @Fin0
      MOV     ECX, [EDX + 8]
      NOT     ECX
      AND     ECX, [EAX + 8]
      JNE     @Fin0
      MOV     ECX, [EDX + 12]
      NOT     ECX
      AND     ECX, [EAX + 12]
      JNE     @Fin0
      MOV     ECX, [EDX + 16]
      NOT     ECX
      AND     ECX, [EAX + 16]
      JNE     @Fin0
      MOV     ECX, [EDX + 20]
      NOT     ECX
      AND     ECX, [EAX + 20]
      JNE     @Fin0
      MOV     ECX, [EDX + 24]
      NOT     ECX
      AND     ECX, [EAX + 24]
      JNE     @Fin0
      MOV     ECX, [EDX + 28]
      NOT     ECX
      AND     ECX, [EAX + 28]
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX, EAX
End;
{$ELSE}

Function IsSubSet(Const A, B: CharSet): Boolean;
Begin
     Result := A <= B;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function IsEqual(Const A, B: CharSet): Boolean;
Asm
      MOV     ECX, [EDX]
      XOR     ECX, [EAX]
      JNE     @Fin0
      MOV     ECX, [EDX + 4]
      XOR     ECX, [EAX + 4]
      JNE     @Fin0
      MOV     ECX, [EDX + 8]
      XOR     ECX, [EAX + 8]
      JNE     @Fin0
      MOV     ECX, [EDX + 12]
      XOR     ECX, [EAX + 12]
      JNE     @Fin0
      MOV     ECX, [EDX + 16]
      XOR     ECX, [EAX + 16]
      JNE     @Fin0
      MOV     ECX, [EDX + 20]
      XOR     ECX, [EAX + 20]
      JNE     @Fin0
      MOV     ECX, [EDX + 24]
      XOR     ECX, [EAX + 24]
      JNE     @Fin0
      MOV     ECX, [EDX + 28]
      XOR     ECX, [EAX + 28]
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX, EAX
End;
{$ELSE}

Function IsEqual(Const A, B: CharSet): Boolean;
Begin
     Result := A = B;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function IsEmpty(Const C: CharSet): Boolean;
Asm
      MOV     EDX, [EAX]
      OR      EDX, [EAX + 4]
      OR      EDX, [EAX + 8]
      OR      EDX, [EAX + 12]
      OR      EDX, [EAX + 16]
      OR      EDX, [EAX + 20]
      OR      EDX, [EAX + 24]
      OR      EDX, [EAX + 28]
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX,EAX
End;
{$ELSE}

Function IsEmpty(Const C: CharSet): Boolean;
Begin
     Result := C = [];
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function IsComplete(Const C: CharSet): Boolean;
Asm
      MOV     EDX, [EAX]
      AND     EDX, [EAX + 4]
      AND     EDX, [EAX + 8]
      AND     EDX, [EAX + 12]
      AND     EDX, [EAX + 16]
      AND     EDX, [EAX + 20]
      AND     EDX, [EAX + 24]
      AND     EDX, [EAX + 28]
      CMP     EDX, $FFFFFFFF
      JNE     @Fin0
      MOV     EAX, 1
      RET
@Fin0:
      XOR     EAX, EAX
End;
{$ELSE}

Function IsComplete(Const C: CharSet): Boolean;
Begin
     Result := C = CompleteCharSet;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function CharCount(Const C: CharSet): Integer;
Asm
      PUSH    EBX
      PUSH    ESI
      MOV     EBX, EAX
      XOR     ESI, ESI
      MOV     EAX, [EBX]
      CALL    BitCount
      ADD     ESI, EAX
      MOV     EAX, [EBX + 4]
      CALL    BitCount
      ADD     ESI, EAX
      MOV     EAX, [EBX + 8]
      CALL    BitCount
      ADD     ESI, EAX
      MOV     EAX, [EBX + 12]
      CALL    BitCount
      ADD     ESI, EAX
      MOV     EAX, [EBX + 16]
      CALL    BitCount
      ADD     ESI, EAX
      MOV     EAX, [EBX + 20]
      CALL    BitCount
      ADD     ESI, EAX
      MOV     EAX, [EBX + 24]
      CALL    BitCount
      ADD     ESI, EAX
      MOV     EAX, [EBX + 28]
      CALL    BitCount
      ADD     EAX, ESI
      POP     ESI
      POP     EBX
End;
{$ELSE}

Function CharCount(Const C: CharSet): Integer;
Var
     I                        : Char;
Begin
     Result := 0;
     For I := #0 To #255 Do
          If I In C Then
               Inc(Result);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure ConvertCaseInsensitive(Var C: CharSet);
Asm
      MOV     ECX, [EAX + 12]
      AND     ECX, $3FFFFFF
      OR      [EAX + 8], ECX
      MOV     ECX, [EAX + 8]
      AND     ECX, $3FFFFFF
      OR      [EAX + 12], ECX
End;
{$ELSE}

Procedure ConvertCaseInsensitive(Var C: CharSet);
Var
     Ch                       : Char;
Begin
     For Ch := 'A' To 'Z' Do
          If Ch In C Then
               Include(C, Char(Ord(Ch) + 32));
     For Ch := 'a' To 'z' Do
          If Ch In C Then
               Include(C, Char(Ord(Ch) - 32));
End;
{$ENDIF}

Function CaseInsensitiveCharSet(Const C: CharSet): CharSet;
Begin
     AssignCharSet(Result, C);
     ConvertCaseInsensitive(Result);
End;



{                                                                              }
{ Swap                                                                         }
{                                                                              }
{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: Boolean);
Asm
    mov cl, [edx]
    xchg byte ptr [eax], cl
    mov [edx], cl
End;
{$ELSE}

Procedure Swap(Var X, Y: Boolean);
Var
     F                        : Boolean;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: Byte);
Asm
    mov cl, [edx]
    xchg byte ptr [eax], cl
    mov [edx], cl
End;
{$ELSE}

Procedure Swap(Var X, Y: Byte);
Var
     F                        : Byte;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: ShortInt);
Asm
    mov cl, [edx]
    xchg byte ptr [eax], cl
    mov [edx], cl
End;
{$ELSE}

Procedure Swap(Var X, Y: ShortInt);
Var
     F                        : ShortInt;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: Word);
Asm
    mov cx, [edx]
    xchg word ptr [eax], cx
    mov [edx], cx
End;
{$ELSE}

Procedure Swap(Var X, Y: Word);
Var
     F                        : Word;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: SmallInt);
Asm
    mov cx, [edx]
    xchg word ptr [eax], cx
    mov [edx], cx
End;
{$ELSE}

Procedure Swap(Var X, Y: SmallInt);
Var
     F                        : SmallInt;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: LongInt);
Asm
    mov ecx, [edx]
    xchg [eax], ecx
    mov [edx], ecx
End;
{$ELSE}

Procedure Swap(Var X, Y: LongInt);
Var
     F                        : LongInt;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: LongWord);
Asm
    mov ecx, [edx]
    xchg [eax], ecx
    mov [edx], ecx
End;
{$ELSE}

Procedure Swap(Var X, Y: LongWord);
Var
     F                        : LongWord;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: Pointer);
Asm
    mov ecx, [edx]
    xchg [eax], ecx
    mov [edx], ecx
End;
{$ELSE}

Procedure Swap(Var X, Y: Pointer);
Var
     F                        : Pointer;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure Swap(Var X, Y: TObject);
Asm
    mov ecx, [edx]
    xchg [eax], ecx
    mov [edx], ecx
End;
{$ELSE}

Procedure Swap(Var X, Y: TObject);
Var
     F                        : TObject;
Begin
     F := X;
     X := Y;
     Y := F;
End;
{$ENDIF}

Procedure Swap(Var X, Y: Int64);
Var
     F                        : Int64;
Begin
     F := X;
     X := Y;
     Y := F;
End;

Procedure Swap(Var X, Y: Single);
Var
     F                        : Single;
Begin
     F := X;
     X := Y;
     Y := F;
End;

Procedure Swap(Var X, Y: Double);
Var
     F                        : Double;
Begin
     F := X;
     X := Y;
     Y := F;
End;

Procedure Swap(Var X, Y: Extended);
Var
     F                        : Extended;
Begin
     F := X;
     X := Y;
     Y := F;
End;

Procedure Swap(Var X, Y: String);
Var
     F                        : String;
Begin
     F := X;
     X := Y;
     Y := F;
End;

{$IFDEF CPU_INTEL386}

Procedure SwapObjects(Var X, Y);
Asm
    mov ecx, [edx]
    xchg [eax], ecx
    mov [edx], ecx
End;
{$ELSE}

Procedure SwapObjects(Var X, Y);
Var
     F                        : TObject;
Begin
     F := TObject(X);
     TObject(X) := TObject(Y);
     TObject(Y) := F;
End;
{$ENDIF}



{                                                                              }
{ iif                                                                          }
{                                                                              }

Function iif(Const Expr: Boolean; Const TrueValue, FalseValue: Integer): Integer;
Begin
     If Expr Then
          Result := TrueValue
     Else
          Result := FalseValue;
End;

Function iif(Const Expr: Boolean; Const TrueValue, FalseValue: Int64): Int64;
Begin
     If Expr Then
          Result := TrueValue
     Else
          Result := FalseValue;
End;

Function iif(Const Expr: Boolean; Const TrueValue, FalseValue: Extended): Extended;
Begin
     If Expr Then
          Result := TrueValue
     Else
          Result := FalseValue;
End;

Function iif(Const Expr: Boolean; Const TrueValue, FalseValue: String): String;
Begin
     If Expr Then
          Result := TrueValue
     Else
          Result := FalseValue;
End;

Function iif(Const Expr: Boolean; Const TrueValue, FalseValue: TObject): TObject;
Begin
     If Expr Then
          Result := TrueValue
     Else
          Result := FalseValue;
End;



{                                                                              }
{ Compare                                                                      }
{                                                                              }

Function Compare(Const I1, I2: Integer): TCompareResult;
Begin
     If I1 < I2 Then
          Result := crLess
     Else If I1 > I2 Then
          Result := crGreater
     Else
          Result := crEqual;
End;

Function Compare(Const I1, I2: Int64): TCompareResult;
Begin
     If I1 < I2 Then
          Result := crLess
     Else If I1 > I2 Then
          Result := crGreater
     Else
          Result := crEqual;
End;

Function Compare(Const I1, I2: Extended): TCompareResult;
Begin
     If I1 < I2 Then
          Result := crLess
     Else If I1 > I2 Then
          Result := crGreater
     Else
          Result := crEqual;
End;

Function Compare(Const I1, I2: Boolean): TCompareResult;
Begin
     If I1 = I2 Then
          Result := crEqual
     Else If I1 Then
          Result := crGreater
     Else
          Result := crLess;
End;

Function Compare(Const I1, I2: String): TCompareResult;
Begin
     If I1 = I2 Then
          Result := crEqual
     Else If I1 > I2 Then
          Result := crGreater
     Else
          Result := crLess;
End;

Function NegatedCompareResult(Const C: TCompareResult): TCompareResult;
Begin
     If C = crLess Then
          Result := crGreater
     Else If C = crGreater Then
          Result := crLess
     Else
          Result := C;
End;



{                                                                              }
{ Base Conversion                                                              }
{                                                                              }

Function LongWordToBase(Const I: LongWord; Const Digits, Base: Byte): String;
Var
     D                        : LongWord;
     L                        : Byte;
     P                        : PChar;
Begin
     Assert(Base <= 16, 'Base <= 16');
     If I = 0 Then Begin
          If Digits = 0 Then
               L := 1
          Else
               L := Digits;
          SetLength(Result, L);
          FillChar(Pointer(Result)^, L, '0');
          exit;
     End;
     L := 0;
     D := I;
     While D > 0 Do Begin
          Inc(L);
          D := D Div Base;
     End;
     If L < Digits Then
          L := Digits;
     SetLength(Result, L);
     P := Pointer(Result);
     Inc(P, L - 1);
     D := I;
     While D > 0 Do Begin
          P^ := s_HexDigitsUpper[D Mod Base + 1];
          Dec(P);
          Dec(L);
          D := D Div Base;
     End;
     While L > 0 Do Begin
          P^ := '0';
          Dec(P);
          Dec(L);
     End;
End;

Function LongWordToBin(Const I: LongWord; Const Digits: Byte): String;
Begin
     Result := LongWordToBase(I, Digits, 2);
End;

Function LongWordToOct(Const I: LongWord; Const Digits: Byte): String;
Begin
     Result := LongWordToBase(I, Digits, 8);
End;

Function LongWordToHex(Const I: LongWord; Const Digits: Byte): String;
Begin
     Result := LongWordToBase(I, Digits, 16);
End;

Function LongWordToStr(Const I: LongWord; Const Digits: Byte): String;
Begin
     Result := LongWordToBase(I, Digits, 10);
End;

Const
     HexLookup                : Array[Char] Of Byte = (
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, 10, 11, 12, 13, 14, 15, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, 10, 11, 12, 13, 14, 15, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
          $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);

Function IsHexChar(Const Ch: Char): Boolean;
Begin
     Result := HexLookup[Ch] <= 15;
End;

Function HexCharValue(Const Ch: Char): Byte;
Begin
     Result := HexLookup[Ch];
End;

Function BaseToLongWord(Const S: String; Const BaseLog2: Byte): LongWord;
Var
     L                        : LongWord;
     P                        : Byte;
     C                        : Byte;
     Q                        : PChar;
Begin
     Assert(BaseLog2 <= 4, 'BaseLog2 <= 4');
     P := Length(S);
     If P = 0 Then Begin
          Result := 0;
          exit;
     End;
     L := 0;
     Result := 0;
     Q := Pointer(S);
     Inc(Q, P - 1);
     Repeat
          C := HexLookup[Q^];
          If C <> $FF Then
               Inc(Result, LongWord(C) Shl L);
          Inc(L, BaseLog2);
          Dec(P);
          Dec(Q);
     Until (P = 0) Or (L = 32);
End;

Function BinToLongWord(Const S: String): LongWord;
Begin
     Result := BaseToLongWord(S, 1);
End;

Function OctToLongWord(Const S: String): LongWord;
Begin
     Result := BaseToLongWord(S, 3);
End;

Function HexToLongWord(Const S: String): LongWord;
Begin
     Result := BaseToLongWord(S, 4);
End;

Function StrToLongWord(Const S: String): LongWord;
Var
     L                        : Integer;
     P                        : PChar;
     C                        : Char;
     F                        : LongWord;
Begin
     L := Length(S);
     If L = 0 Then Begin
          Result := 0;
          exit;
     End;
     Result := 0;
     F := 1;
     P := Pointer(S);
     Inc(P, L - 1);
     Repeat
          C := P^;
          If C In ['0'..'9'] Then
               Inc(Result, Int64(Ord(C) - Ord('0')) * F);
          If F = 1000000000 Then
               exit;
          F := F * 10;
          Dec(P);
          Dec(L);
     Until L = 0;
End;

Function EncodeBase64(Const S, Alphabet: String; Const Pad: Boolean; Const PadMultiple: Integer; Const PadChar: Char): String;
Var
     R, C                     : Byte;
     F, L, M, N, U            : Integer;
     P                        : PChar;
     T                        : Boolean;
Begin
     Assert(Length(Alphabet) = 64, 'Alphabet must contain 64 characters.');
     L := Length(S);
     If L = 0 Then Begin
          Result := '';
          exit;
     End;
     M := L Mod 3;
     N := (L Div 3) * 4 + M;
     If M > 0 Then
          Inc(N);
     T := Pad And (PadMultiple > 1);
     If T Then Begin
          U := N Mod PadMultiple;
          If U > 0 Then Begin
               U := PadMultiple - U;
               Inc(N, U);
          End;
     End
     Else
          U := 0;
     SetLength(Result, N);
     P := Pointer(Result);
     R := 0;
     For F := 0 To L - 1 Do Begin
          C := Byte(S[F + 1]);
          Case F Mod 3 Of
               0: Begin
                         P^ := Alphabet[C Shr 2 + 1];
                         Inc(P);
                         R := (C And 3) Shl 4;
                    End;
               1: Begin
                         P^ := Alphabet[C Shr 4 + R + 1];
                         Inc(P);
                         R := (C And $0F) Shl 2;
                    End;
               2: Begin
                         P^ := Alphabet[C Shr 6 + R + 1];
                         Inc(P);
                         P^ := Alphabet[C And $3F + 1];
                         Inc(P);
                    End;
          End;
     End;
     If M > 0 Then Begin
          P^ := Alphabet[R + 1];
          Inc(P);
     End;
     For F := 1 To U Do Begin
          P^ := PadChar;
          Inc(P);
     End;
End;

Function DecodeBase64(Const S, Alphabet: String; Const PadSet: CharSet): String;
Var
     F, L, M, P               : Integer;
     B, OutPos                : Byte;
     OutB                     : Array[1..3] Of Byte;
     Lookup                   : Array[Char] Of Byte;
     R                        : PChar;
Begin
     Assert(Length(Alphabet) = 64, 'Alphabet must contain 64 characters.');
     L := Length(S);
     P := 0;
     If PadSet <> [] Then
          While (L - P > 0) And (S[L - P] In PadSet) Do
               Inc(P);
     M := L - P;
     If M = 0 Then Begin
          Result := '';
          exit;
     End;
     SetLength(Result, (M * 3) Div 4);
     FillChar(Lookup, Sizeof(Lookup), #0);
     For F := 0 To 63 Do
          Lookup[Alphabet[F + 1]] := F;
     R := Pointer(Result);
     OutPos := 0;
     For F := 1 To L - P Do Begin
          B := Lookup[S[F]];
          Case OutPos Of
               0: OutB[1] := B Shl 2;
               1: Begin
                         OutB[1] := OutB[1] Or (B Shr 4);
                         R^ := Char(OutB[1]);
                         Inc(R);
                         OutB[2] := (B Shl 4) And $FF;
                    End;
               2: Begin
                         OutB[2] := OutB[2] Or (B Shr 2);
                         R^ := Char(OutB[2]);
                         Inc(R);
                         OutB[3] := (B Shl 6) And $FF;
                    End;
               3: Begin
                         OutB[3] := OutB[3] Or B;
                         R^ := Char(OutB[3]);
                         Inc(R);
                    End;
          End;
          OutPos := (OutPos + 1) Mod 4;
     End;
     If (OutPos > 0) And (P = 0) Then   // incomplete encoding, add the partial byte if not 0
          If OutB[OutPos] <> 0 Then
               Result := Result + Char(OutB[OutPos]);
End;

Function MIMEBase64Encode(Const S: String): String;
Begin
     Result := EncodeBase64(S, b64_MIMEBase64, True, 4, '=');
End;

Function UUDecode(Const S: String): String;
Begin
     // Line without size indicator (first byte = length + 32)
     Result := DecodeBase64(S, b64_UUEncode, ['`']);
End;

Function MIMEBase64Decode(Const S: String): String;
Begin
     Result := DecodeBase64(S, b64_MIMEBase64, ['=']);
End;

Function XXDecode(Const S: String): String;
Begin
     Result := DecodeBase64(S, b64_XXEncode, []);
End;

Function BytesToHex(Const P: Pointer; Const Count: Integer): String;
Var
     Q                        : PByte;
     D                        : PChar;
     L                        : Integer;
Begin
     Q := P;
     L := Count;
     If (L <= 0) Or Not Assigned(Q) Then Begin
          Result := '';
          exit;
     End;
     SetLength(Result, Count * 2);
     D := Pointer(Result);
     While L > 0 Do Begin
          D^ := s_HexDigitsUpper[Q^ Shr 4 + 1];
          Inc(D);
          D^ := s_HexDigitsUpper[Q^ And $F + 1];
          Inc(D);
          Inc(Q);
          Dec(L);
     End;
End;



{                                                                              }
{ Type conversion                                                              }
{                                                                              }

Function PointerToStr(Const P: Pointer): String;
Begin
     Result := '$' + LongWordToHex(LongWord(P), 8);
End;

Function StrToPointer(Const S: String): Pointer;
Begin
     Result := Pointer(HexToLongWord(S));
End;

Function ObjectClassName(Const O: TObject): String;
Begin
     If Not Assigned(O) Then
          Result := 'nil'
     Else
          Result := O.ClassName;
End;

Function ClassClassName(Const C: TClass): String;
Begin
     If Not Assigned(C) Then
          Result := 'nil'
     Else
          Result := C.ClassName;
End;

Function ObjectToStr(Const O: TObject): String;
Begin
     If Not Assigned(O) Then
          Result := 'nil'
     Else
          Result := O.ClassName + '@' + LongWordToHex(LongWord(O), 8);
End;

Function ClassToStr(Const C: TClass): String;
Begin
     If Not Assigned(C) Then
          Result := 'nil'
     Else
          Result := C.ClassName + '@' + LongWordToHex(LongWord(C), 8);
End;

{$IFDEF CPU_INTEL386}

Function CharSetToStr(Const C: CharSet): String; // Andrew N. Driazgov
Asm
      PUSH    EBX
      MOV     ECX, $100
      MOV     EBX, EAX
      PUSH    ESI
      MOV     EAX, EDX
      SUB     ESP, ECX
      XOR     ESI, ESI
      XOR     EDX, EDX
@@lp: BT      [EBX], EDX
      JC      @@mm
@@nx: INC     EDX
      DEC     ECX
      JNE     @@lp
      MOV     ECX, ESI
      MOV     EDX, ESP
      CALL    System.@LStrFromPCharLen
      ADD     ESP, $100
      POP     ESI
      POP     EBX
      RET
@@mm: MOV     [ESP + ESI], DL
      INC     ESI
      JMP     @@nx
End;
{$ELSE}

Function CharSetToStr(Const C: CharSet): String;
// Implemented recursively to avoid multiple memory allocations

     Procedure CharMatch(Const Start: Char; Const Count: Integer);
     Var
          Ch                  : Char;
     Begin
          For Ch := Start To #255 Do
               If Ch In C Then Begin
                    If Ch = #255 Then
                         SetLength(Result, Count + 1)
                    Else
                         CharMatch(Char(Byte(Ch) + 1), Count + 1);
                    Result[Count + 1] := Ch;
                    exit;
               End;
          SetLength(Result, Count);
     End;
Begin
     CharMatch(#0, 0);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function StrToCharSet(Const S: String): CharSet; // Andrew N. Driazgov
Asm
      XOR     ECX, ECX
      MOV     [EDX], ECX
      MOV     [EDX + 4], ECX
      MOV     [EDX + 8], ECX
      MOV     [EDX + 12], ECX
      MOV     [EDX + 16], ECX
      MOV     [EDX + 20], ECX
      MOV     [EDX + 24], ECX
      MOV     [EDX + 28], ECX
      TEST    EAX, EAX
      JE      @@qt
      MOV     ECX, [EAX - 4]
      PUSH    EBX
      SUB     ECX, 8
      JS      @@nx
@@lp: MOVZX   EBX, BYTE PTR [EAX]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 1]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 2]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 3]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 4]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 5]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 6]
      BTS     [EDX], EBX
      MOVZX   EBX, BYTE PTR [EAX + 7]
      BTS     [EDX], EBX
      ADD     EAX, 8
      SUB     ECX, 8
      JNS     @@lp
@@nx: JMP     DWORD PTR @@tV[ECX * 4 + 32]
@@tV: DD      @@ex, @@t1, @@t2, @@t3
      DD      @@t4, @@t5, @@t6, @@t7
@@t7: MOVZX   EBX, BYTE PTR [EAX + 6]
      BTS     [EDX], EBX
@@t6: MOVZX   EBX, BYTE PTR [EAX + 5]
      BTS     [EDX], EBX
@@t5: MOVZX   EBX, BYTE PTR [EAX + 4]
      BTS     [EDX], EBX
@@t4: MOVZX   EBX, BYTE PTR [EAX + 3]
      BTS     [EDX], EBX
@@t3: MOVZX   EBX, BYTE PTR [EAX + 2]
      BTS     [EDX], EBX
@@t2: MOVZX   EBX, BYTE PTR [EAX + 1]
      BTS     [EDX], EBX
@@t1: MOVZX   EBX, BYTE PTR [EAX]
      BTS     [EDX], EBX
@@ex: POP     EBX
@@qt:
End;
{$ELSE}

Function StrToCharSet(Const S: String): CharSet;
Var
     I                        : Integer;
Begin
     ClearCharSet(Result);
     For I := 1 To Length(S) Do
          Include(Result, S[I]);
End;
{$ENDIF}



{                                                                              }
{ Hash functions                                                               }
{   Based on CRC32 algorithm                                                   }
{                                                                              }
Var
     CRC32TableInit           : Boolean = False;
     CRC32Table               : Array[Byte] Of LongWord;
     CRC32Poly                : LongWord = $EDB88320;

Procedure InitCRC32Table;
Var
     I, J                     : Byte;
     R                        : LongWord;
Begin
     For I := $00 To $FF Do Begin
          R := I;
          For J := 8 Downto 1 Do
               If R And 1 <> 0 Then
                    R := (R Shr 1) Xor CRC32Poly
               Else
                    R := R Shr 1;
          CRC32Table[I] := R;
     End;
     CRC32TableInit := True;
End;

Function CalcCRC32Byte(Const CRC32: LongWord; Const Octet: Byte): LongWord;
Begin
     Result := CRC32Table[Byte(CRC32) Xor Octet] Xor (CRC32 Shr 8);
End;

Function CRC32Buf(Const CRC32: LongWord; Const Buf; Const BufSize: Integer): LongWord;
Var
     P                        : PByte;
     I                        : Integer;
Begin
     If Not CRC32TableInit Then
          InitCRC32Table;
     P := @Buf;
     Result := CRC32;
     For I := 1 To BufSize Do Begin
          Result := CalcCRC32Byte(Result, P^);
          Inc(P);
     End;
End;

Function CRC32BufNoCase(Const CRC32: LongWord; Const Buf; Const BufSize: Integer): LongWord;
Var
     P                        : PByte;
     I                        : Integer;
     C                        : Byte;
Begin
     If Not CRC32TableInit Then
          InitCRC32Table;
     P := @Buf;
     Result := CRC32;
     For I := 1 To BufSize Do Begin
          C := P^;
          If Char(C) In ['A'..'Z'] Then
               C := C Or 32;
          Result := CalcCRC32Byte(Result, C);
          Inc(P);
     End;
End;

Procedure CRC32Init(Var CRC32: LongWord);
Begin
     CRC32 := $FFFFFFFF;
End;

Function CalcCRC32(Const Buf; Const BufSize: Integer): LongWord;
Begin
     CRC32Init(Result);
     Result := Not CRC32Buf(Result, Buf, BufSize);
End;

Function HashBuf(Const Buf; Const BufSize: Integer; Const Slots: LongWord): LongWord;
Begin
     If BufSize <= 0 Then
          Result := 0
     Else
          Result := CalcCRC32(Buf, BufSize);
     // Mod into slots
     If (Slots <> 0) And (Slots <> High(LongWord)) Then
          Result := Result Mod Slots;
End;

Function HashStr(Const StrBuf: Pointer; Const StrLength: Integer;
     Const Slots: LongWord; Const CaseSensitive: Boolean): LongWord;

Var
     P                        : PChar;
     I, J                     : Integer;

     Procedure CRC32StrBuf(Const Size: Integer);
     Begin
          If CaseSensitive Then
               Result := CRC32Buf(Result, P^, Size)
          Else
               Result := CRC32BufNoCase(Result, P^, Size);
     End;

Begin
     // Return 0 for an empty string
     Result := 0;
     If (StrLength <= 0) Or Not Assigned(StrBuf) Then
          exit;

     If Not CRC32TableInit Then
          InitCRC32Table;
     Result := $FFFFFFFF;
     P := StrBuf;

     If StrLength <= 48 Then            // Hash everything for short strings
          CRC32StrBuf(StrLength)
     Else Begin
          // Hash first 16 bytes
          CRC32StrBuf(16);

          // Hash last 16 bytes
          Inc(P, StrLength - 16);
          CRC32StrBuf(16);

          // Hash 16 bytes sampled from rest of string
          I := (StrLength - 48) Div 16;
          P := StrBuf;
          Inc(P, 16);
          For J := 1 To 16 Do Begin
               CRC32StrBuf(1);
               Inc(P, I + 1);
          End;
     End;

     // Mod into slots
     If (Slots <> 0) And (Slots <> High(LongWord)) Then
          Result := Result Mod Slots;
End;

Function HashStr(Const S: String; Const Slots: LongWord; Const CaseSensitive: Boolean): LongWord;
Begin
     Result := HashStr(Pointer(S), Length(S), Slots, CaseSensitive);
End;

{ HashInteger based on the CRC32 algorithm. It is a very good all purpose hash }
{ with a highly uniform distribution of results.                               }

Function HashInteger(Const I: Integer; Const Slots: LongWord): LongWord;
Var
     P                        : PByte;
     F                        : Integer;
     Hash                     : LongWord;
Begin
     If Not CRC32TableInit Then
          InitCRC32Table;
     Hash := $FFFFFFFF;
     P := @I;
     For F := 1 To Sizeof(Integer) Do Begin
          Hash := CalcCRC32Byte(Hash, P^);
          Inc(P);
     End;
     Hash := Not Hash;
     If (Slots <> 0) And (Slots <> High(LongWord)) Then
          Hash := Hash Mod Slots;
     Result := Hash;
End;



{                                                                              }
{ Memory                                                                       }
{                                                                              }
{$IFDEF CPU_INTEL386}

Procedure MoveMem(Const Source; Var Dest; Const Count: Integer);
Asm
    CMP    ECX, 4
    JA     @GeneralMove
    JE     @Move4
    TEST   ECX, ECX
    JLE    @Fin
    DEC    ECX
    JZ     @Move1
    DEC    ECX
    JZ     @Move2
  @Move3:
    MOV    CX, [EAX]
    MOV    AL, [EAX + 2]
    MOV    [EDX], CX
    MOV    [EDX + 2], AL
    RET
  @Move4:
    MOV    EAX, [EAX]
    MOV    [EDX], EAX
    RET
  @Move1:
    MOV    AL, [EAX]
    MOV    [EDX], AL
    RET
  @Move2:
    MOV    AX, [EAX]
    MOV    [EDX], AX
    RET
  @GeneralMove:
    CALL   Move
  @Fin:
    RET
End;
{$ELSE}

Procedure MoveMem(Const Source; Var Dest; Const Count: Integer);
Begin
     If Count <= 0 Then
          exit;
     If Count > 4 Then
          Move(Source, Dest, Count)
     Else
          Case Count Of                 // optimization for small moves
               1: PByte(@Source)^ := PByte(@Dest)^;
               2: PWord(@Source)^ := PWord(@Dest)^;
               4: PLongWord(@Source)^ := PLongWord(@Dest)^;
          Else
               Move(Source, Dest, Count);
          End;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function CompareMem(Const Buf1; Const Buf2; Const Count: Integer): Boolean; Assembler;
Asm
    PUSH    ESI
    PUSH    EDI
    MOV     ESI, Buf1
    MOV     EDI, Buf2
    MOV     EDX, ECX
    XOR     EAX, EAX
    AND     EDX, 3
    SHR     ECX, 1
    SHR     ECX, 1
    REPE    CMPSD
    JNE     @Fin
    MOV     ECX, EDX
    REPE    CMPSB
    JNE     @Fin
    INC     EAX
  @Fin:
    POP     EDI
    POP     ESI
End;
{$ELSE}

Function CompareMem(Const Buf1; Const Buf2; Const Count: Integer): Boolean;
Var
     P, Q                     : Pointer;
     D, I                     : Integer;
Begin
     If Count <= 0 Then Begin
          Result := True;
          exit;
     End;
     P := @Buf1;
     Q := @Buf2;
     D := LongWord(Count) Div 4;
     For I := 1 To D Do
          If PLongWord(P)^ = PLongWord(Q)^ Then Begin
               Inc(PLongWord(P));
               Inc(PLongWord(Q));
          End
          Else Begin
               Result := False;
               exit;
          End;
     D := LongWord(Count) And 3;
     For I := 1 To D Do
          If PByte(P)^ = PByte(Q)^ Then Begin
               Inc(PByte(P));
               Inc(PByte(Q));
          End
          Else Begin
               Result := False;
               exit;
          End;
     Result := True;
End;
{$ENDIF}

Function CompareMemNoCase(Const Buf1; Const Buf2; Const Count: Integer): TCompareResult;
Var
     P, Q                     : Pointer;
     I                        : Integer;
     C, D                     : Byte;
Begin
     If Count <= 0 Then Begin
          Result := crEqual;
          exit;
     End;
     P := @Buf1;
     Q := @Buf2;
     For I := 1 To Count Do Begin
          C := PByte(P)^;
          D := PByte(Q)^;
          If C In [Ord('A')..Ord('Z')] Then
               C := C Or 32;
          If D In [Ord('A')..Ord('Z')] Then
               D := D Or 32;
          If C = D Then Begin
               Inc(PByte(P));
               Inc(PByte(Q));
          End
          Else Begin
               If C < D Then
                    Result := crLess
               Else
                    Result := crGreater;
               exit;
          End;
     End;
     Result := crEqual;
End;

Procedure ReverseMem(Var Buf; Const Size: Integer);
Var
     I                        : Integer;
     P                        : PByte;
     Q                        : PByte;
     T                        : Byte;
Begin
     P := @Buf;
     Q := P;
     Inc(Q, Size - 1);
     For I := 1 To Size Div 2 Do Begin
          T := P^;
          P^ := Q^;
          Q^ := T;
          Inc(P);
          Dec(Q);
     End;
End;



{                                                                              }
{ Append                                                                       }
{                                                                              }

Function Append(Var V: ByteArray; Const R: Byte): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: WordArray; Const R: Word): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: LongWordArray; Const R: LongWord): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: ShortIntArray; Const R: ShortInt): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: SmallIntArray; Const R: SmallInt): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: LongIntArray; Const R: LongInt): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: Int64Array; Const R: Int64): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: SingleArray; Const R: Single): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: DoubleArray; Const R: Double): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: ExtendedArray; Const R: Extended): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: StringArray; Const R: String): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: BooleanArray; Const R: Boolean): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: PointerArray; Const R: Pointer): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: ObjectArray; Const R: TObject): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: ByteSetArray; Const R: ByteSet): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;

Function Append(Var V: CharSetArray; Const R: CharSet): Integer;
Begin
     Result := Length(V);
     SetLength(V, Result + 1);
     V[Result] := R;
End;


Function AppendByteArray(Var V: ByteArray; Const R: Array Of Byte): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(Byte) * L);
     End;
End;

Function AppendWordArray(Var V: WordArray; Const R: Array Of Word): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(Word) * L);
     End;
End;

Function AppendCardinalArray(Var V: CardinalArray; Const R: Array Of LongWord): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(LongWord) * L);
     End;
End;

Function AppendShortIntArray(Var V: ShortIntArray; Const R: Array Of ShortInt): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(ShortInt) * L);
     End;
End;

Function AppendSmallIntArray(Var V: SmallIntArray; Const R: Array Of SmallInt): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(SmallInt) * L);
     End;
End;

Function AppendIntegerArray(Var V: IntegerArray; Const R: Array Of LongInt): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(LongInt) * L);
     End;
End;

Function AppendInt64Array(Var V: Int64Array; Const R: Array Of Int64): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(Int64) * L);
     End;
End;

Function AppendSingleArray(Var V: SingleArray; Const R: Array Of Single): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(Single) * L);
     End;
End;

Function AppendDoubleArray(Var V: DoubleArray; Const R: Array Of Double): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(Double) * L);
     End;
End;

Function AppendExtendedArray(Var V: ExtendedArray; Const R: Array Of Extended): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(Extended) * L);
     End;
End;

Function AppendPointerArray(Var V: PointerArray; Const R: Array Of Pointer): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(Pointer) * L);
     End;
End;

Function AppendCharSetArray(Var V: CharSetArray; Const R: Array Of CharSet): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(CharSet) * L);
     End;
End;

Function AppendByteSetArray(Var V: ByteSetArray; Const R: Array Of ByteSet): Integer;
Var
     L                        : Integer;
Begin
     Result := Length(V);
     L := Length(R);
     If L > 0 Then Begin
          SetLength(V, Result + L);
          Move(R[0], V[Result], Sizeof(ByteSet) * L);
     End;
End;


Function AppendObjectArray(Var V: ObjectArray; Const R: Array Of TObject): Integer;
Var
     I, LR                    : Integer;
Begin
     Result := Length(V);
     LR := Length(R);
     If LR > 0 Then Begin
          SetLength(V, Result + LR);
          For I := 0 To LR - 1 Do
               V[Result + I] := R[I];
     End;
End;

Function AppendStringArray(Var V: StringArray; Const R: Array Of String): Integer;
Var
     I, LR                    : Integer;
Begin
     Result := Length(V);
     LR := Length(R);
     If LR > 0 Then Begin
          SetLength(V, Result + LR);
          For I := 0 To LR - 1 Do
               V[Result + I] := R[I];
     End;
End;



{                                                                              }
{ FreeAndNil                                                                   }
{                                                                              }

Procedure FreeAndNil(Var Obj);
Var
     Temp                     : TObject;
Begin
     Temp := TObject(Obj);
     Pointer(Obj) := Nil;
     Temp.Free;
End;



{                                                                              }
{ Remove                                                                       }
{                                                                              }

Function Remove(Var V: ByteArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Byte));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: WordArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Word));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: LongWordArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(LongWord));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: ShortIntArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(ShortInt));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: SmallIntArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(SmallInt));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: LongIntArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(LongInt));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: Int64Array; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Int64));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: SingleArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Single));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: DoubleArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Double));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: ExtendedArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Extended));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: PointerArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, L, M               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Pointer));
     SetLength(V, L - J);
     Result := J;
End;


Function Remove(Var V: ObjectArray; Const Idx: Integer; Const Count: Integer; Const FreeObjects: Boolean): Integer;
Var
     I, J, K, L, M            : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     If FreeObjects Then
          For K := I To I + J - 1 Do
               FreeAndNil(V[K]);
     M := L - J - I;
     If M > 0 Then
          Move(V[I + J], V[I], M * SizeOf(Pointer));
     SetLength(V, L - J);
     Result := J;
End;

Function Remove(Var V: StringArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, J, K, L               : Integer;
Begin
     L := Length(V);
     If (Idx >= L) Or (Idx + Count <= 0) Or (L = 0) Or (Count = 0) Then Begin
          Result := 0;
          exit;
     End;
     I := MaxI(Idx, 0);
     J := MinI(Count, L - I);
     For K := I To L - J - 1 Do
          V[K] := V[K + J];
     SetLength(V, L - J);
     Result := J;
End;

Procedure FreeObjectArray(Var V);
Var
     I                        : Integer;
     A                        : ObjectArray Absolute V;
Begin
     For I := Length(A) - 1 Downto 0 Do
          FreeAndNil(A[I]);
End;

Procedure FreeObjectArray(Var V; Const LoIdx, HiIdx: Integer);
Var
     I                        : Integer;
     A                        : ObjectArray Absolute V;
Begin
     For I := HiIdx Downto LoIdx Do
          FreeAndNil(A[I]);
End;

// Note: The parameter can not be changed to be untyped and then typecasted
// using an absolute variable, as in FreeObjectArray. The reference counting
// will be done incorrectly.

Procedure FreeAndNilObjectArray(Var V: ObjectArray);
Var
     W                        : ObjectArray;
Begin
     W := V;
     V := Nil;
     FreeObjectArray(W);
End;


{                                                                              }
{ RemoveDuplicates                                                             }
{                                                                              }

Procedure RemoveDuplicates(Var V: ByteArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : Byte;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: WordArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : Word;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: LongWordArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : LongWord;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: ShortIntArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : ShortInt;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: SmallIntArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : SmallInt;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: LongIntArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : LongInt;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: Int64Array; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : Int64;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: SingleArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : Single;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: DoubleArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : Double;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: ExtendedArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : Extended;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: StringArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : String;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;

Procedure RemoveDuplicates(Var V: PointerArray; Const IsSorted: Boolean);
Var
     I, C, J, L               : Integer;
     F                        : Pointer;
Begin
     L := Length(V);
     If L = 0 Then
          exit;

     If IsSorted Then Begin
          J := 0;
          Repeat
               F := V[J];
               I := J + 1;
               While (I < L) And (V[I] = F) Do
                    Inc(I);
               C := I - J;
               If C > 1 Then Begin
                    Remove(V, J + 1, C - 1);
                    Dec(L, C - 1);
                    Inc(J);
               End
               Else
                    J := I;
          Until J >= L;
     End
     Else Begin
          J := 0;
          Repeat
               Repeat
                    I := PosNext(V[J], V, J);
                    If I >= 0 Then
                         Remove(V, I, 1);
               Until I < 0;
               Inc(J);
          Until J >= Length(V);
     End;
End;



Procedure TrimArrayLeft(Var S: ByteArray; Const TrimList: Array Of Byte); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: WordArray; Const TrimList: Array Of Word); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: LongWordArray; Const TrimList: Array Of LongWord); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: ShortIntArray; Const TrimList: Array Of ShortInt); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: SmallIntArray; Const TrimList: Array Of SmallInt); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: LongIntArray; Const TrimList: Array Of LongInt); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: Int64Array; Const TrimList: Array Of Int64); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: SingleArray; Const TrimList: Array Of Single); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: DoubleArray; Const TrimList: Array Of Double); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: ExtendedArray; Const TrimList: Array Of Extended); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: StringArray; Const TrimList: Array Of String); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;


Procedure TrimArrayLeft(Var S: PointerArray; Const TrimList: Array Of Pointer); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := 0;
     R := True;
     While R And (I < Length(S)) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Inc(I);
                    break;
               End;
     End;
     If I > 0 Then
          Remove(S, 0, I - 1);
End;



Procedure TrimArrayRight(Var S: ByteArray; Const TrimList: Array Of Byte); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: WordArray; Const TrimList: Array Of Word); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: LongWordArray; Const TrimList: Array Of LongWord); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: ShortIntArray; Const TrimList: Array Of ShortInt); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: SmallIntArray; Const TrimList: Array Of SmallInt); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: LongIntArray; Const TrimList: Array Of LongInt); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: Int64Array; Const TrimList: Array Of Int64); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: SingleArray; Const TrimList: Array Of Single); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: DoubleArray; Const TrimList: Array Of Double); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: ExtendedArray; Const TrimList: Array Of Extended); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: StringArray; Const TrimList: Array Of String); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;


Procedure TrimArrayRight(Var S: PointerArray; Const TrimList: Array Of Pointer); Overload;
Var
     I, J                     : Integer;
     R                        : Boolean;
Begin
     I := Length(S) - 1;
     R := True;
     While R And (I >= 0) Do Begin
          R := False;
          For J := 0 To High(TrimList) Do
               If S[I] = TrimList[J] Then Begin
                    R := True;
                    Dec(I);
                    break;
               End;
     End;
     If I < Length(S) - 1 Then
          SetLength(S, I + 1);
End;



{                                                                              }
{ ArrayInsert                                                                  }
{                                                                              }

Function ArrayInsert(Var V: ByteArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Byte);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Byte));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: WordArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Word);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Word));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: LongWordArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(LongWord);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(LongWord));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: ShortIntArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(ShortInt);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(ShortInt));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: SmallIntArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(SmallInt);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(SmallInt));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: LongIntArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(LongInt);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(LongInt));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: Int64Array; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Int64);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Int64));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: SingleArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Single);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Single));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: DoubleArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Double);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Double));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: ExtendedArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Extended);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Extended));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: StringArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(String);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(String));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: PointerArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Pointer);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Pointer));
     FillChar(V[I], C, #0);
     Result := I;
End;

Function ArrayInsert(Var V: ObjectArray; Const Idx: Integer; Const Count: Integer): Integer;
Var
     I, L, C                  : Integer;
Begin
     L := Length(V);
     If (Idx > L) Or (Idx + Count <= 0) Or (Count = 0) Then Begin
          Result := -1;
          exit;
     End;
     I := MaxI(Idx, 0);
     SetLength(V, L + Count);
     C := Count * Sizeof(Pointer);
     If I < L Then
          Move(V[I], V[I + Count], (L - I) * Sizeof(Pointer));
     FillChar(V[I], C, #0);
     Result := I;
End;



{                                                                              }
{ PosNext                                                                      }
{   PosNext finds the next occurance of Find in V, -1 if it was not found.     }
{     Searches from Item[PrevPos + 1], ie PrevPos = -1 to find first           }
{     occurance.                                                               }
{                                                                              }

Function PosNext(Const Find: Byte; Const V: ByteArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : Byte;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: Word; Const V: WordArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : Word;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: LongWord; Const V: LongWordArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : LongWord;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: ShortInt; Const V: ShortIntArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : ShortInt;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: SmallInt; Const V: SmallIntArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : SmallInt;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: LongInt; Const V: LongIntArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : LongInt;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: Int64; Const V: Int64Array; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : Int64;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: Single; Const V: SingleArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : Single;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: Double; Const V: DoubleArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : Double;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: Extended; Const V: ExtendedArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : Extended;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: Boolean; Const V: BooleanArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : Boolean;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: String; Const V: StringArray; Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
     D                        : String;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    D := V[I];
                    If Find = D Then Begin
                         While (I > 0) And (V[I - 1] = Find) Do
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
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If V[PrevPos + 1] = Find Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If V[I] = Find Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;

Function PosNext(Const Find: TObject; Const V: ObjectArray; Const PrevPos: Integer): Integer;
Var
     I                        : Integer;
Begin
     For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
          If V[I] = Find Then Begin
               Result := I;
               exit;
          End;
     Result := -1;
End;

Function PosNext(Const ClassType: TClass; Const V: ObjectArray; Const PrevPos: Integer): Integer;
Var
     I                        : Integer;
Begin
     For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
          If V[I] Is ClassType Then Begin
               Result := I;
               exit;
          End;
     Result := -1;
End;

Function PosNext(Const ClassName: String; Const V: ObjectArray; Const PrevPos: Integer): Integer;
Var
     I                        : Integer;
     T                        : TObject;
Begin
     For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do Begin
          T := V[I];
          If Assigned(T) And (T.ClassName = ClassName) Then Begin
               Result := I;
               exit;
          End;
     End;
     Result := -1;
End;

Function PosNext(Const Find: Pointer; Const V: PointerArray; Const PrevPos: Integer): Integer;
Var
     I                        : Integer;
Begin
     For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
          If V[I] = Find Then Begin
               Result := I;
               exit;
          End;
     Result := -1;
End;



{                                                                              }
{ Count                                                                        }
{                                                                              }

Function Count(Const Find: Byte; Const V: ByteArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: Word; Const V: WordArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: LongWord; Const V: LongWordArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: ShortInt; Const V: ShortIntArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: SmallInt; Const V: SmallIntArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: LongInt; Const V: LongIntArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: Int64; Const V: Int64Array; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: Single; Const V: SingleArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: Double; Const V: DoubleArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: Extended; Const V: ExtendedArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: String; Const V: StringArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;

Function Count(Const Find: Boolean; Const V: BooleanArray; Const IsSortedAscending: Boolean = False): Integer;
Var
     I, J                     : Integer;
Begin
     If IsSortedAscending Then Begin
          I := PosNext(Find, V, -1, True);
          If I = -1 Then
               Result := 0
          Else Begin
               Result := 1;
               J := Length(V);
               While (I + Result < J) And (V[I + Result] = Find) Do
                    Inc(Result);
          End;
     End
     Else Begin
          J := -1;
          Result := 0;
          Repeat
               I := PosNext(Find, V, J, False);
               If I >= 0 Then Begin
                    Inc(Result);
                    J := I;
               End;
          Until I < 0;
     End;
End;



{                                                                              }
{ RemoveAll                                                                    }
{                                                                              }

Procedure RemoveAll(Const Find: Byte; Var V: ByteArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: Word; Var V: WordArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: LongWord; Var V: LongWordArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: ShortInt; Var V: ShortIntArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: SmallInt; Var V: SmallIntArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: LongInt; Var V: LongIntArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: Int64; Var V: Int64Array; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: Single; Var V: SingleArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: Double; Var V: DoubleArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: Extended; Var V: ExtendedArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;

Procedure RemoveAll(Const Find: String; Var V: StringArray; Const IsSortedAscending: Boolean = False);
Var
     I, J                     : Integer;
Begin
     I := PosNext(Find, V, -1, IsSortedAscending);
     While I >= 0 Do Begin
          J := 1;
          While (I + J < Length(V)) And (V[I + J] = Find) Do
               Inc(J);
          Remove(V, I, J);
          I := PosNext(Find, V, I, IsSortedAscending);
     End;
End;



{                                                                              }
{ Intersection                                                                 }
{   If both arrays are sorted ascending then time is o(n) instead of o(n^2).   }
{                                                                              }

Function Intersection(Const V1, V2: SingleArray; Const IsSortedAscending: Boolean): SingleArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: DoubleArray; Const IsSortedAscending: Boolean): DoubleArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: ExtendedArray; Const IsSortedAscending: Boolean): ExtendedArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: ByteArray; Const IsSortedAscending: Boolean): ByteArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: WordArray; Const IsSortedAscending: Boolean): WordArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: LongWordArray; Const IsSortedAscending: Boolean): LongWordArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: ShortIntArray; Const IsSortedAscending: Boolean): ShortIntArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: SmallIntArray; Const IsSortedAscending: Boolean): SmallIntArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: LongIntArray; Const IsSortedAscending: Boolean): LongIntArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: Int64Array; Const IsSortedAscending: Boolean): Int64Array;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Intersection(Const V1, V2: StringArray; Const IsSortedAscending: Boolean): StringArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] = V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) >= 0) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;



{                                                                              }
{ Difference                                                                   }
{   Returns elements in V1 but not in V2.                                      }
{   If both arrays are sorted ascending then time is o(n) instead of o(n^2).   }
{                                                                              }

Function Difference(Const V1, V2: SingleArray; Const IsSortedAscending: Boolean): SingleArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: DoubleArray; Const IsSortedAscending: Boolean): DoubleArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: ExtendedArray; Const IsSortedAscending: Boolean): ExtendedArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: ByteArray; Const IsSortedAscending: Boolean): ByteArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: WordArray; Const IsSortedAscending: Boolean): WordArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: LongWordArray; Const IsSortedAscending: Boolean): LongWordArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: ShortIntArray; Const IsSortedAscending: Boolean): ShortIntArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: SmallIntArray; Const IsSortedAscending: Boolean): SmallIntArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: LongIntArray; Const IsSortedAscending: Boolean): LongIntArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: Int64Array; Const IsSortedAscending: Boolean): Int64Array;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;

Function Difference(Const V1, V2: StringArray; Const IsSortedAscending: Boolean): StringArray;
Var
     I, J, L, LV              : Integer;
Begin
     SetLength(Result, 0);
     If IsSortedAscending Then Begin
          I := 0;
          J := 0;
          L := Length(V1);
          LV := Length(V2);
          While (I < L) And (J < LV) Do Begin
               While (I < L) And (V1[I] < V2[J]) Do
                    Inc(I);
               If I < L Then Begin
                    If V1[I] <> V2[J] Then
                         Append(Result, V1[I]);
                    While (J < LV) And (V2[J] <= V1[I]) Do
                         Inc(J);
               End;
          End;
     End
     Else
          For I := 0 To Length(V1) - 1 Do
               If (PosNext(V1[I], V2) = -1) And (PosNext(V1[I], Result) = -1) Then
                    Append(Result, V1[I]);
End;



{                                                                              }
{ Reverse                                                                      }
{                                                                              }

Procedure Reverse(Var V: ByteArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: WordArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: LongWordArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: ShortIntArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: SmallIntArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: LongIntArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: Int64Array);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: StringArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: PointerArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: ObjectArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: SingleArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: DoubleArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;

Procedure Reverse(Var V: ExtendedArray);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     For I := 1 To L Div 2 Do
          Swap(V[I - 1], V[L - I]);
End;



{                                                                              }
{ Returns an open array (V) as a dynamic array.                                }
{                                                                              }

Function AsBooleanArray(Const V: Array Of Boolean): BooleanArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsByteArray(Const V: Array Of Byte): ByteArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsWordArray(Const V: Array Of Word): WordArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsLongWordArray(Const V: Array Of LongWord): LongWordArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsCardinalArray(Const V: Array Of Cardinal): CardinalArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsShortIntArray(Const V: Array Of ShortInt): ShortIntArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsSmallIntArray(Const V: Array Of SmallInt): SmallIntArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsLongIntArray(Const V: Array Of LongInt): LongIntArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsIntegerArray(Const V: Array Of Integer): IntegerArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsInt64Array(Const V: Array Of Int64): Int64Array;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsSingleArray(Const V: Array Of Single): SingleArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsDoubleArray(Const V: Array Of Double): DoubleArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsExtendedArray(Const V: Array Of Extended): ExtendedArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsStringArray(Const V: Array Of String): StringArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsPointerArray(Const V: Array Of Pointer): PointerArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsCharSetArray(Const V: Array Of CharSet): CharSetArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;

Function AsObjectArray(Const V: Array Of TObject): ObjectArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, High(V) + 1);
     For I := 0 To High(V) Do
          Result[I] := V[I];
End;



Function RangeByte(Const First: Byte; Const Count: Integer; Const Increment: Byte): ByteArray;
Var
     I                        : Integer;
     J                        : Byte;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeWord(Const First: Word; Const Count: Integer; Const Increment: Word): WordArray;
Var
     I                        : Integer;
     J                        : Word;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeLongWord(Const First: LongWord; Const Count: Integer; Const Increment: LongWord): LongWordArray;
Var
     I                        : Integer;
     J                        : LongWord;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeCardinal(Const First: Cardinal; Const Count: Integer; Const Increment: Cardinal): CardinalArray;
Var
     I                        : Integer;
     J                        : Cardinal;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeShortInt(Const First: ShortInt; Const Count: Integer; Const Increment: ShortInt): ShortIntArray;
Var
     I                        : Integer;
     J                        : ShortInt;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeSmallInt(Const First: SmallInt; Const Count: Integer; Const Increment: SmallInt): SmallIntArray;
Var
     I                        : Integer;
     J                        : SmallInt;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeLongInt(Const First: LongInt; Const Count: Integer; Const Increment: LongInt): LongIntArray;
Var
     I                        : Integer;
     J                        : LongInt;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeInteger(Const First: Integer; Const Count: Integer; Const Increment: Integer): IntegerArray;
Var
     I                        : Integer;
     J                        : Integer;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeInt64(Const First: Int64; Const Count: Integer; Const Increment: Int64): Int64Array;
Var
     I                        : Integer;
     J                        : Int64;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeSingle(Const First: Single; Const Count: Integer; Const Increment: Single): SingleArray;
Var
     I                        : Integer;
     J                        : Single;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeDouble(Const First: Double; Const Count: Integer; Const Increment: Double): DoubleArray;
Var
     I                        : Integer;
     J                        : Double;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;

Function RangeExtended(Const First: Extended; Const Count: Integer; Const Increment: Extended): ExtendedArray;
Var
     I                        : Integer;
     J                        : Extended;
Begin
     SetLength(Result, Count);
     J := First;
     For I := 0 To Count - 1 Do Begin
          Result[I] := J;
          J := J + Increment;
     End;
End;



{                                                                              }
{ Dup                                                                          }
{                                                                              }

Function DupByte(Const V: Byte; Const Count: Integer): ByteArray;
Begin
     SetLength(Result, Count);
     FillChar(Result[0], Count, V);
End;

Function DupWord(Const V: Word; Const Count: Integer): WordArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupLongWord(Const V: LongWord; Const Count: Integer): LongWordArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupCardinal(Const V: Cardinal; Const Count: Integer): CardinalArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupShortInt(Const V: ShortInt; Const Count: Integer): ShortIntArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupSmallInt(Const V: SmallInt; Const Count: Integer): SmallIntArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupLongInt(Const V: LongInt; Const Count: Integer): LongIntArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupInteger(Const V: Integer; Const Count: Integer): IntegerArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupInt64(Const V: Int64; Const Count: Integer): Int64Array;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupSingle(Const V: Single; Const Count: Integer): SingleArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupDouble(Const V: Double; Const Count: Integer): DoubleArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupExtended(Const V: Extended; Const Count: Integer): ExtendedArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupString(Const V: String; Const Count: Integer): StringArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupCharSet(Const V: CharSet; Const Count: Integer): CharSetArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;

Function DupObject(Const V: TObject; Const Count: Integer): ObjectArray;
Var
     I                        : Integer;
Begin
     SetLength(Result, Count);
     For I := 0 To Count - 1 Do
          Result[I] := V;
End;



{                                                                              }
{ SetLengthAndZero                                                             }
{                                                                              }

Procedure SetLengthAndZero(Var V: ByteArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Byte) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: WordArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Word) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: LongWordArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(LongWord) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: ShortIntArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(ShortInt) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: SmallIntArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(SmallInt) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: LongIntArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(LongInt) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: Int64Array; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Int64) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: SingleArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Single) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: DoubleArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Double) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: ExtendedArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Extended) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: CharSetArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(CharSet) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: BooleanArray; Const NewLength: Integer);
Var
     L                        : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Boolean) * (NewLength - L), #0);
End;

Procedure SetLengthAndZero(Var V: ObjectArray; Const NewLength: Integer;
     Const FreeObjects: Boolean);
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     If L = NewLength Then
          exit;
     If (L > NewLength) And FreeObjects Then
          For I := NewLength To L - 1 Do
               FreeAndNil(V[I]);
     SetLength(V, NewLength);
     If L > NewLength Then
          exit;
     FillChar(V[L], Sizeof(Pointer) * (NewLength - L), #0);
End;



{                                                                              }
{ IsEqual                                                                      }
{                                                                              }

Function IsEqual(Const V1, V2: ByteArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Byte) * L);
End;

Function IsEqual(Const V1, V2: WordArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Word) * L);
End;

Function IsEqual(Const V1, V2: LongWordArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(LongWord) * L);
End;

Function IsEqual(Const V1, V2: ShortIntArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(ShortInt) * L);
End;

Function IsEqual(Const V1, V2: SmallIntArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(SmallInt) * L);
End;

Function IsEqual(Const V1, V2: LongIntArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(LongInt) * L);
End;

Function IsEqual(Const V1, V2: Int64Array): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Int64) * L);
End;

Function IsEqual(Const V1, V2: SingleArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Single) * L);
End;

Function IsEqual(Const V1, V2: DoubleArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Double) * L);
End;

Function IsEqual(Const V1, V2: ExtendedArray): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     Result := CompareMem(Pointer(V1)^, Pointer(V2)^, Sizeof(Extended) * L);
End;

Function IsEqual(Const V1, V2: StringArray): Boolean;
Var
     I, L                     : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     For I := 0 To L - 1 Do
          If V1[I] <> V2[I] Then Begin
               Result := False;
               exit;
          End;
     Result := True;
End;

Function IsEqual(Const V1, V2: CharSetArray): Boolean;
Var
     I, L                     : Integer;
Begin
     L := Length(V1);
     If L <> Length(V2) Then Begin
          Result := False;
          exit;
     End;
     For I := 0 To L - 1 Do
          If V1[I] <> V2[I] Then Begin
               Result := False;
               exit;
          End;
     Result := True;
End;



{                                                                              }
{ Dynamic array to Dynamic array                                               }
{                                                                              }

Function ByteArrayToLongIntArray(Const V: ByteArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function WordArrayToLongIntArray(Const V: WordArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function ShortIntArrayToLongIntArray(Const V: ShortIntArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function SmallIntArrayToLongIntArray(Const V: SmallIntArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function LongIntArrayToInt64Array(Const V: LongIntArray): Int64Array;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function LongIntArrayToSingleArray(Const V: LongIntArray): SingleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function LongIntArrayToDoubleArray(Const V: LongIntArray): DoubleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function LongIntArrayToExtendedArray(Const V: LongIntArray): ExtendedArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function SingleArrayToExtendedArray(Const V: SingleArray): ExtendedArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function SingleArrayToDoubleArray(Const V: SingleArray): DoubleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function SingleArrayToLongIntArray(Const V: SingleArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := Trunc(V[I]);
End;

Function SingleArrayToInt64Array(Const V: SingleArray): Int64Array;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := Trunc(V[I]);
End;

Function DoubleArrayToSingleArray(Const V: DoubleArray): SingleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function DoubleArrayToExtendedArray(Const V: DoubleArray): ExtendedArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function DoubleArrayToLongIntArray(Const V: DoubleArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := Trunc(V[I]);
End;

Function DoubleArrayToInt64Array(Const V: DoubleArray): Int64Array;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := Trunc(V[I]);
End;

Function ExtendedArrayToSingleArray(Const V: ExtendedArray): SingleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function ExtendedArrayToDoubleArray(Const V: ExtendedArray): DoubleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[I];
End;

Function ExtendedArrayToLongIntArray(Const V: ExtendedArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := Trunc(V[I]);
End;

Function ExtendedArrayToInt64Array(Const V: ExtendedArray): Int64Array;
Var
     I, L                     : Integer;
Begin
     L := Length(V);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := Trunc(V[I]);
End;



{                                                                              }
{ Array from indexes                                                           }
{                                                                              }

Function ByteArrayFromIndexes(Const V: ByteArray; Const Indexes: IntegerArray): ByteArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function WordArrayFromIndexes(Const V: WordArray; Const Indexes: IntegerArray): WordArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function LongWordArrayFromIndexes(Const V: LongWordArray; Const Indexes: IntegerArray): LongWordArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function CardinalArrayFromIndexes(Const V: CardinalArray; Const Indexes: IntegerArray): CardinalArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function ShortIntArrayFromIndexes(Const V: ShortIntArray; Const Indexes: IntegerArray): ShortIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function SmallIntArrayFromIndexes(Const V: SmallIntArray; Const Indexes: IntegerArray): SmallIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function LongIntArrayFromIndexes(Const V: LongIntArray; Const Indexes: IntegerArray): LongIntArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function IntegerArrayFromIndexes(Const V: IntegerArray; Const Indexes: IntegerArray): IntegerArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function Int64ArrayFromIndexes(Const V: Int64Array; Const Indexes: IntegerArray): Int64Array;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function SingleArrayFromIndexes(Const V: SingleArray; Const Indexes: IntegerArray): SingleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function DoubleArrayFromIndexes(Const V: DoubleArray; Const Indexes: IntegerArray): DoubleArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function ExtendedArrayFromIndexes(Const V: ExtendedArray; Const Indexes: IntegerArray): ExtendedArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;

Function StringArrayFromIndexes(Const V: StringArray; Const Indexes: IntegerArray): StringArray;
Var
     I, L                     : Integer;
Begin
     L := Length(Indexes);
     SetLength(Result, L);
     For I := 0 To L - 1 Do
          Result[I] := V[Indexes[I]];
End;



{                                                                              }
{ Dynamic array Sort                                                           }
{                                                                              }

Procedure Sort(Var V: ByteArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: WordArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: LongWordArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: ShortIntArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: SmallIntArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: LongIntArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: Int64Array);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: SingleArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: DoubleArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: ExtendedArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var V: StringArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While V[I] < V[M] Do
                         Inc(I);
                    While V[J] > V[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(V[I], V[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     I := Length(V);
     If I > 0 Then
          QuickSort(0, I - 1);
End;



Procedure Sort(Var Key: IntegerArray; Var Data: IntegerArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: IntegerArray; Var Data: Int64Array);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: IntegerArray; Var Data: StringArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: IntegerArray; Var Data: ExtendedArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: IntegerArray; Var Data: PointerArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: StringArray; Var Data: IntegerArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: StringArray; Var Data: Int64Array);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: StringArray; Var Data: StringArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: StringArray; Var Data: ExtendedArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: StringArray; Var Data: PointerArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: ExtendedArray; Var Data: IntegerArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: ExtendedArray; Var Data: Int64Array);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: ExtendedArray; Var Data: StringArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: ExtendedArray; Var Data: ExtendedArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;

Procedure Sort(Var Key: ExtendedArray; Var Data: PointerArray);

     Procedure QuickSort(L, R: Integer);
     Var
          I, J, M             : Integer;
     Begin
          Repeat
               I := L;
               J := R;
               M := (L + R) Shr 1;
               Repeat
                    While Key[I] < Key[M] Do
                         Inc(I);
                    While Key[J] > Key[M] Do
                         Dec(J);
                    If I <= J Then Begin
                         Swap(Key[I], Key[J]);
                         Swap(Data[I], Data[J]);
                         If M = I Then
                              M := J
                         Else If M = J Then
                              M := I;
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
     Assert(Length(Key) = Length(Data), 'Sort pair must be of equal length.');
     I := Length(Key);
     If I > 0 Then
          QuickSort(0, I - 1);
End;




{                                                                              }
{ Test cases                                                                   }
{                                                                              }

Procedure Test_Misc;
Var
     A, B                     : String;
Begin
     { iif                                                                 }
     Assert(iif(True, 1, 2) = 1, 'iif');
     Assert(iif(False, 1, 2) = 2, 'iif');
     Assert(iif(True, -1, -2) = -1, 'iif');
     Assert(iif(False, -1, -2) = -2, 'iif');
     Assert(iif(True, '1', '2') = '1', 'iif');
     Assert(iif(False, '1', '2') = '2', 'iif');
     Assert(iif(True, 1.1, 2.2) = 1.1, 'iif');
     Assert(iif(False, 1.1, 2.2) = 2.2, 'iif');

     { CharSet                                                              }
     Assert(CharCount([]) = 0, 'CharCount');
     Assert(CharCount(['a'..'z']) = 26, 'CharCount');
     Assert(CharCount([#0, #255]) = 2, 'CharCount');

     { MoveMem                                                              }
     A := '12345';
     B := '     ';
     MoveMem(A[1], B[1], 0);
     Assert(B = '     ', 'MoveMem');
     MoveMem(A[1], B[1], 1);
     Assert(B = '1    ', 'MoveMem');
     MoveMem(A[1], B[1], 2);
     Assert(B = '12   ', 'MoveMem');
     MoveMem(A[1], B[1], 3);
     Assert(B = '123  ', 'MoveMem');
     MoveMem(A[1], B[1], 4);
     Assert(B = '1234 ', 'MoveMem');
     MoveMem(A[1], B[1], 5);
     Assert(B = '12345', 'MoveMem');

     { Hash                                                                 }
     Assert(HashStr('Fundamentals') = $3FB7796E, 'HashStr');

     { Encodings                                                            }
     Assert(HexCharValue('A') = 10, 'HexCharValue');
     Assert(HexCharValue('a') = 10, 'HexCharValue');
     Assert(HexCharValue('1') = 1, 'HexCharValue');
     Assert(HexCharValue('G') = $FF, 'HexCharValue');

     Assert(LongWordToStr(123) = '123', 'LongWordToStr');
     Assert(LongWordToStr(0) = '0', 'LongWordToStr');
     Assert(LongWordToStr($FFFFFFFF) = '4294967295', 'LongWordToStr');
     Assert(LongWordToStr(10000) = '10000', 'LongWordToStr');
     Assert(LongWordToStr(99999) = '99999', 'LongWordToStr');
     Assert(LongWordToStr(1, 1) = '1', 'LongWordToStr');
     Assert(LongWordToStr(1, 3) = '001', 'LongWordToStr');
     Assert(LongWordToStr(1234, 3) = '1234', 'LongWordToStr');

     Assert(StrToLongWord('') = 0, 'StrToLongWord');
     Assert(StrToLongWord('123') = 123, 'StrToLongWord');
     Assert(StrToLongWord('4294967295') = $FFFFFFFF, 'StrToLongWord');
     Assert(StrToLongWord('99999') = 99999, 'StrToLongWord');

     Assert(LongWordToHex(0) = '0', 'LongWordToHex');
     Assert(LongWordToHex($FFFFFFFF) = 'FFFFFFFF', 'LongWordToHex');
     Assert(LongWordToHex($10000) = '10000', 'LongWordToHex');
     Assert(LongWordToHex($12345678) = '12345678', 'LongWordToHex');
     Assert(LongWordToHex($AB, 4) = '00AB', 'LongWordToHex');
     Assert(LongWordToHex($ABCD, 8) = '0000ABCD', 'LongWordToHex');
     Assert(LongWordToHex(0, 8) = '00000000', 'LongWordToHex');
     Assert(LongWordToHex($CDEF, 2) = 'CDEF', 'LongWordToHex');

     Assert(HexToLongWord('FFFFFFFF') = $FFFFFFFF, 'HexToLongWord');
     Assert(HexToLongWord('0') = 0, 'HexToLongWord');
     Assert(HexToLongWord('123456') = $123456, 'HexToLongWord');
     Assert(HexToLongWord('ABC') = $ABC, 'HexToLongWord');
     Assert(HexToLongWord('') = 0, 'HexToLongWord');
     Assert(HexToLongWord('x') = 0, 'HexToLongWord');
     Assert(HexToLongWord('1000') = $1000, 'HexToLongWord');
End;

Procedure Test_BitFunctions;
Begin
     { Bits                                                                 }
     Assert(SetBit($100F, 5) = $102F, 'SetBit');
     Assert(ClearBit($102F, 5) = $100F, 'ClearBit');
     Assert(ToggleBit($102F, 5) = $100F, 'ToggleBit');
     Assert(ToggleBit($100F, 5) = $102F, 'ToggleBit');
     Assert(IsBitSet($102F, 5), 'IsBitSet');
     Assert(Not IsBitSet($100F, 5), 'IsBitSet');

     Assert(SetBitScanForward(0) = -1, 'SetBitScanForward');
     Assert(SetBitScanForward($1020) = 5, 'SetBitScanForward');
     Assert(SetBitScanReverse($1020) = 12, 'SetBitScanForward');
     Assert(SetBitScanForward($1020, 6) = 12, 'SetBitScanForward');
     Assert(SetBitScanReverse($1020, 11) = 5, 'SetBitScanForward');
     Assert(ClearBitScanForward($FFFFFFFF) = -1, 'ClearBitScanForward');
     Assert(ClearBitScanForward($1020) = 0, 'ClearBitScanForward');
     Assert(ClearBitScanReverse($1020) = 31, 'ClearBitScanForward');
     Assert(ClearBitScanForward($1020, 5) = 6, 'ClearBitScanForward');
     Assert(ClearBitScanReverse($1020, 12) = 11, 'ClearBitScanForward');

     Assert(ReverseBits($12345678) = $1E6A2C48, 'ReverseBits');
     Assert(SwapEndian($12345678) = $78563412, 'SwapEndian');

     Assert(BitCount($12341234) = 10, 'BitCount');

     Assert(LowBitMask(10) = $3FF, 'LowBitMask');
     Assert(HighBitMask(28) = $F0000000, 'HighBitMask');
     Assert(RangeBitMask(2, 6) = $7C, 'RangeBitMask');

     Assert(SetBitRange($101, 2, 6) = $17D, 'SetBitRange');
     Assert(ClearBitRange($17D, 2, 6) = $101, 'ClearBitRange');
     Assert(ToggleBitRange($17D, 2, 6) = $101, 'ToggleBitRange');
     Assert(IsBitRangeSet($17D, 2, 6), 'IsBitRangeSet');
     Assert(Not IsBitRangeSet($101, 2, 6), 'IsBitRangeSet');
     Assert(Not IsBitRangeClear($17D, 2, 6), 'IsBitRangeClear');
     Assert(IsBitRangeClear($101, 2, 6), 'IsBitRangeClear');
End;

Procedure Test_IntegerArray;
Var
     S, T                     : IntegerArray;
     F                        : Integer;
Begin
     { IntegerArray                                                         }
     S := Nil;
     For F := 1 To 100 Do Begin
          Append(S, F);
          Assert(Length(S) = F, 'Append');
          Assert(S[F - 1] = F, 'Append');
     End;

     T := Copy(S);
     AppendIntegerArray(S, T);
     For F := 1 To 100 Do
          Assert(S[F + 99] = F, 'Append');
     Assert(PosNext(60, S) = 59, 'PosNext');
     Assert(PosNext(60, T) = 59, 'PosNext');
     Assert(PosNext(60, S, 59) = 159, 'PosNext');
     Assert(PosNext(60, T, 59) = -1, 'PosNext');
     Assert(PosNext(60, T, -1, True) = 59, 'PosNext');
     Assert(PosNext(60, T, 59, True) = -1, 'PosNext');

     For F := 1 To 100 Do Begin
          Remove(S, PosNext(F, S), 1);
          Assert(Length(S) = 200 - F, 'Remove');
     End;
     For F := 99 Downto 0 Do Begin
          Remove(S, PosNext(F Xor 3 + 1, S), 1);
          Assert(Length(S) = F, 'Remove');
     End;

     S := AsIntegerArray([3, 1, 2, 5, 4]);
     Sort(S);
     Assert(S[0] = 1, 'Sort');
     Assert(S[1] = 2, 'Sort');
     Assert(S[2] = 3, 'Sort');
     Assert(S[3] = 4, 'Sort');
     Assert(S[4] = 5, 'Sort');
End;

Procedure SelfTest;
Begin
     Test_Misc;
     Test_BitFunctions;
     Test_IntegerArray;
End;



End.
