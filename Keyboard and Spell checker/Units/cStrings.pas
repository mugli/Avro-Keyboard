{$INCLUDE cDictionaryDefines.inc}

Unit cStrings;

{                                                                              }
{                             Ansi Strings v3.33                               }
{                                                                              }
{      This unit is copyright © 1999-2002 by David Butler (david@e.co.za)      }
{                                                                              }
{                  This unit is part of Delphi Fundamentals.                   }
{                   Its original file name is cStrings.pas                     }
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
{   1999/10/19  v0.01  Spawned from Maths unit.                                }
{   1999/10/26  v0.02  Revision.                                               }
{   1999/10/30  v0.03  Added Count, Reverse.                                   }
{   1999/10/31  v0.04  Improved Match.                                         }
{                      Added Replace, Count, PadInside.                        }
{   1999/11/06  v1.05  261 lines interface, 772 lines implementation.          }
{                      Added Remove, TrimEllipse.                              }
{   1999/11/09  v1.06  Added Pack functions.                                   }
{   1999/11/17  v1.07  Added PosN, Before, After, Between and Split.           }
{   1999/11/22  v1.08  Added Join.                                             }
{   1999/11/23  v1.09  Added Translate.                                        }
{   1999/12/02  v1.10  Fixed bugs in Replace and Match reported by             }
{                      daiqingbo@netease.com                                   }
{   1999/12/27  v1.11  Added SelfTest procedure and Bug fixes.                 }
{   2000/01/04  v1.12  Added InsensitiveCharSet.                               }
{   2000/01/08  v1.13  Added Append.                                           }
{   2000/05/08  v1.14  Revision.                                               }
{   2000/07/20  v1.15  Bug fixes.                                              }
{   2000/08/30  v1.16  Bug fixes.                                              }
{   2000/09/04  v1.17  Added MatchFileMask.                                    }
{   2000/09/31  v1.18  Added HexEscapeText and HexUnescapeText.                }
{   2000/12/04  v1.19  Changes to CopyRange, CopyLeft to avoid memory          }
{                      allocation in specific cases.                           }
{   2001/04/22  v1.20  Added CaseSensitive parameter to Match, PosNext, PosN   }
{   2001/04/25  v1.21  Added CopyEx, MatchLeft and MatchRight.                 }
{   2001/04/28  v1.22  Major refactoring.                                      }
{                      Replaced PosNext and PosPrev with Pos.                  }
{                      1000 lines interface. 3727 lines implementation.        }
{   2001/04/29  v1.23  Improvements.                                           }
{   2001/05/13  v1.24  Added simple regular expression matching.               }
{                      Added CharClassStr conversion routines.                 }
{                      1149 lines interface. 4851 lines implementation.        }
{   2001/06/01  v1.25  Added TQuickLexer                                       }
{   2001/07/07  v1.26  Optimizations.                                          }
{   2001/07/30  v1.27  Changed Iterators from objects to records.              }
{   2001/08/22  v1.28  Added LZ-Huffman packer / unpacker.                     }
{                      1429 lines interface. 6445 lines implementation.        }
{   2001/11/11  v2.29  Revision.                                               }
{   2002/02/14  v2.30  Added MatchPattern.                                     }
{   2002/04/03  v3.31  Added AnsiString functions from cUtils.                     }
{   2002/04/14  v3.32  Moved TQuickLexer to cQuickLexer.                       }
{   2002/12/14  v3.33  Major revision. Removed rarely used functions.          }
{                      674 lines interface. 3889 lines implementation.         }
{                                                                              }
Interface

Uses
     { Fundamentals }
     cUtils;

Const
     UnitName                 = 'cStrings';
     UnitVersion              = '3.33';
     UnitCopyright            = '(c) 1999-2002 by David Butler';



     {                                                                              }
     { Constants                                                                    }
     {                                                                              }
Const
     { ASCII characters }
     asciiNULL                = AnsiChar(#0);
     asciiSOH                 = AnsiChar(#1);
     asciiSTX                 = AnsiChar(#2);
     asciiETX                 = AnsiChar(#3);
     asciiEOT                 = AnsiChar(#4);
     asciiENQ                 = AnsiChar(#5);
     asciiACK                 = AnsiChar(#6);
     asciiBEL                 = AnsiChar(#7);
     asciiBS                  = AnsiChar(#8);
     asciiHT                  = AnsiChar(#9);
     asciiLF                  = AnsiChar(#10);
     asciiVT                  = AnsiChar(#11);
     asciiFF                  = AnsiChar(#12);
     asciiCR                  = AnsiChar(#13);
     asciiSO                  = AnsiChar(#14);
     asciiSI                  = AnsiChar(#15);
     asciiDLE                 = AnsiChar(#16);
     asciiDC1                 = AnsiChar(#17);
     asciiDC2                 = AnsiChar(#18);
     asciiDC3                 = AnsiChar(#19);
     asciiDC4                 = AnsiChar(#20);
     asciiNAK                 = AnsiChar(#21);
     asciiSYN                 = AnsiChar(#22);
     asciiETB                 = AnsiChar(#23);
     asciiCAN                 = AnsiChar(#24);
     asciiEM                  = AnsiChar(#25);
     asciiEOF                 = AnsiChar(#26);
     asciiESC                 = AnsiChar(#27);
     asciiFS                  = AnsiChar(#28);
     asciiGS                  = AnsiChar(#29);
     asciiRS                  = AnsiChar(#30);
     asciiUS                  = AnsiChar(#31);
     asciiSP                  = AnsiChar(#32);
     asciiDEL                 = AnsiChar(#127);

     { Common characters }
     chTab                    = asciiHT;
     chSpace                  = asciiSP;
     chDecimalPoint           = AnsiChar('.');
     chComma                  = AnsiChar(',');
     chBackSlash              = AnsiChar('\');
     chForwardSlash           = AnsiChar('/');
     chPercent                = AnsiChar('%');
     chAmpersand              = AnsiChar('&');
     chPlus                   = AnsiChar('+');
     chMinus                  = AnsiChar('-');
     chSingleQuote            = AnsiChar('''');
     chDoubleQuote            = AnsiChar('"');

     { Common sequences }
     CRLF                     = asciiCR + asciiLF;
     LFCR                     = asciiLF + asciiCR;

     { Character sets }
     csComplete               = [#0..#255];
     csAnsi                   = [#0..#255];
     csAscii                  = [#0..#127];
     csNotAscii               = csComplete - csAscii;
     csAsciiCtl               = [#0..#31];
     csAsciiText              = [#32..#127];
     csAlphaLow               = ['a'..'z'];
     csAlphaUp                = ['A'..'Z'];
     csAlpha                  = csAlphaLow + csAlphaUp;
     csNotAlpha               = csComplete - csAlpha;
     csNumeric                = ['0'..'9'];
     csNotNumeric             = csComplete - csNumeric;
     csAlphaNumeric           = csNumeric + csAlpha;
     csNotAlphaNumeric        = csComplete - csAlphaNumeric;
     csWhiteSpace             = csAsciiCtl + [asciiSP];
     csSign                   = [chPlus, chMinus];
     csExponent               = ['E', 'e'];
     csBinaryDigit            = ['0'..'1'];
     csOctalDigit             = ['0'..'7'];
     csHexDigitLow            = csNumeric + ['a'..'f'];
     csHexDigitUp             = csNumeric + ['A'..'F'];
     csHexDigit               = csNumeric + ['A'..'F', 'a'..'f'];
     csQuotes                 = [chSingleQuote, chDoubleQuote];
     csParentheses            = ['(', ')'];
     csCurlyBrackets          = ['{', '}'];
     csBlockBrackets          = ['[', ']'];
     csPunctuation            = ['.', ',', ':', '/', '?', '<', '>', ';', '"', '''',
          '[', ']', '{', '}', '+', '=', '-', '\', '(', ')',
          '*', '&', '^', '%', '$', '#', '@', '!', '`', '~'];
     csSlash                  = [chBackSlash, chForwardSlash];



     {                                                                              }
     { AnsiString functions                                                         }
     {                                                                              }
Procedure SetLengthAndZero(Var S: AnsiString; Const NewLength: Integer); overload;

Function CharMatchNoCase(Const A, B: AnsiChar): Boolean;
Function CharMatch(Const A, B: AnsiChar;
     Const CaseSensitive: Boolean = True): Boolean; overload;
Function CharMatch(Const A: CharSet; Const B: AnsiChar;
     Const CaseSensitive: Boolean = True): Boolean; overload;

Function StrIsNumeric(Const S: AnsiString): Boolean;
Function StrIsHex(Const S: AnsiString): Boolean;
Function StrIsAlpha(Const S: AnsiString): Boolean;
Function StrIsAlphaNumeric(Const S: AnsiString): Boolean;
Function StrIsInteger(Const S: AnsiString): Boolean;

Function StrReverse(Const S: AnsiString): AnsiString;



{                                                                              }
{ Case conversion                                                              }
{                                                                              }
Const
     AnsiLowCaseLookup        : Array[AnsiChar] Of AnsiChar = (
          #$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07,
          #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
          #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17,
          #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
          #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27,
          #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
          #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37,
          #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
          #$40, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
          #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
          #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
          #$78, #$79, #$7A, #$5B, #$5C, #$5D, #$5E, #$5F,
          #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67,
          #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
          #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77,
          #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
          #$80, #$81, #$82, #$83, #$84, #$85, #$86, #$87,
          #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F,
          #$90, #$91, #$92, #$93, #$94, #$95, #$96, #$97,
          #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F,
          #$A0, #$A1, #$A2, #$A3, #$A4, #$A5, #$A6, #$A7,
          #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF,
          #$B0, #$B1, #$B2, #$B3, #$B4, #$B5, #$B6, #$B7,
          #$B8, #$B9, #$BA, #$BB, #$BC, #$BD, #$BE, #$BF,
          #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7,
          #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
          #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7,
          #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF,
          #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7,
          #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF,
          #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7,
          #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF);

Function LowCase(Const Ch: AnsiChar): AnsiChar;
Procedure ConvertUpper(Var S: AnsiString); overload;
Procedure ConvertLower(Var S: AnsiString); overload;
Procedure ConvertFirstUp(Var S: AnsiString);
Function FirstUp(Const S: AnsiString): AnsiString;
Procedure ConvertUpper(Var S: StringArray); overload;
Procedure ConvertLower(Var S: StringArray); overload;



{                                                                              }
{ Compare                                                                      }
{                                                                              }
Function StrPCompare(Const A, B: PAnsiChar; Const Len: Integer): TCompareResult;
Function StrPCompareNoCase(Const A, B: PAnsiChar; Const Len: Integer): TCompareResult;
Function StrCompareNoCase(Const A, B: AnsiString): TCompareResult;
Function StrEqualNoCase(Const A, B: AnsiString): Boolean;
Function StrEqual(Const A, B: AnsiString; Const CaseSensitive: Boolean): Boolean;
Function StrPEqual(Const P1, P2: PAnsiChar; Const Len1, Len2: Integer;
     Const CaseSensitive: Boolean = True): Boolean; overload;
Function StrPEqual(Const P: PAnsiChar; Const Len: Integer; Const S: AnsiString;
     Const CaseSensitive: Boolean): Boolean; overload;
Function StrMatch(Const M, S: AnsiString; Const Index: Integer): Boolean;
Function StrMatchNoCase(Const M, S: AnsiString; Const Index: Integer): Boolean;
Function StrPMatchStr(Const P: PAnsiChar; Const M: AnsiString): Boolean; overload;
Function StrPMatchStrNoCase(Const P: PAnsiChar; Const M: AnsiString): Boolean;
Function StrPMatchStr(Const P: PAnsiChar; Const M: AnsiString;
     Const CaseSensitive: Boolean): Boolean; overload;
Function StrMatchLeft(Const M, S: AnsiString;
     Const CaseSensitive: Boolean = True): Boolean;
Function StrMatchRight(Const M, S: AnsiString;
     Const CaseSensitive: Boolean = True): Boolean;
Function StrPMatchLen(Const S: PAnsiChar; Const C: CharSet;
     Const Len: Integer): Integer;
Function StrMatchChar(Const M: CharSet; Const S: AnsiString): Boolean;



{                                                                              }
{ Pos                                                                          }
{                                                                              }
Function PosChar(Const F: AnsiChar; Const S: AnsiString;
     Const Index: Integer = 1): Integer; overload;
Function PosChar(Const F: CharSet; Const S: AnsiString;
     Const Index: Integer = 1): Integer; overload;
Function PosNotChar(Const F: AnsiChar; Const S: AnsiString;
     Const Index: Integer = 1): Integer; overload;
Function PosNotChar(Const F: CharSet; Const S: AnsiString;
     Const Index: Integer = 1): Integer; overload;
Function PosCharRev(Const F: AnsiChar; Const S: AnsiString;
     Const Index: Integer = 1): Integer; overload;
Function PosCharRev(Const F: CharSet; Const S: AnsiString;
     Const Index: Integer = 1): Integer; overload;
Function PosStr(Const F, S: AnsiString; Const Index: Integer = 1;
     Const CaseSensitive: Boolean = True): Integer;
Function PosStrRev(Const F, S: AnsiString; Const Index: Integer = 1;
     Const CaseSensitive: Boolean = True): Integer;
Function PosNStr(Const F, S: AnsiString; Const N: Integer;
     Const Index: Integer = 1; Const CaseSensitive: Boolean = True): Integer;



{                                                                              }
{ Copy                                                                         }
{   Out-of-range values of StartIndex, StopIndex and Count are clipped.        }
{   These variants return a reference to the existing AnsiString if possible.      }
{                                                                              }
Function CopyRange(Const S: AnsiString;
     Const StartIndex, StopIndex: Integer): AnsiString; overload;
Function CopyFrom(Const S: AnsiString; Const Index: Integer): AnsiString; overload;
Function CopyLeft(Const S: AnsiString; Const Count: Integer): AnsiString; overload;
Function CopyRight(Const S: AnsiString; Const Count: Integer): AnsiString; overload;
Function CopyLeftEllipsed(Const S: AnsiString; Const Count: Integer): AnsiString;



{                                                                              }
{ CopyEx                                                                       }
{   CopyEx functions extend Copy so that negative Start/Stop values reference  }
{   indexes from the end of the AnsiString, eg. -2 will reference the second last  }
{   character in the AnsiString.                                                   }
{                                                                              }
Function CopyEx(Const S: AnsiString; Const Start, Count: Integer): AnsiString;
Function CopyRangeEx(Const S: AnsiString; Const Start, Stop: Integer): AnsiString;
Function CopyFromEx(Const S: AnsiString; Const Start: Integer): AnsiString;



{                                                                              }
{ Trim                                                                         }
{                                                                              }
Function TrimLeft(Const S: AnsiString;
     Const C: CharSet = csWhiteSpace): AnsiString;
Procedure TrimLeftInPlace(Var S: AnsiString;
     Const C: CharSet = csWhiteSpace);
Function TrimLeftStrNoCase(Const S: AnsiString;
     Const TrimStr: AnsiString): AnsiString;
Function TrimRight(Const S: AnsiString;
     Const C: CharSet = csWhiteSpace): AnsiString;
Procedure TrimRightInPlace(Var S: AnsiString;
     Const C: CharSet = csWhiteSpace);
Function TrimRightStrNoCase(Const S: AnsiString;
     Const TrimStr: AnsiString): AnsiString;
Function Trim(Const S: AnsiString; Const C: CharSet): AnsiString; overload;
Procedure TrimInPlace(Var S: AnsiString; Const C: CharSet = csWhiteSpace);
Procedure TrimStrings(Var S: StringArray; Const C: CharSet = csWhiteSpace); overload;



{                                                                              }
{ Duplicate                                                                    }
{                                                                              }
Function DupBuf(Const Buf; Const BufSize: Integer): AnsiString; overload;
Function DupBuf(Const Buf; Const BufSize: Integer; Const Count: Integer): AnsiString; overload;
Function DupStr(Const S: AnsiString; Const Count: Integer): AnsiString;
Function DupChar(Const Ch: AnsiChar; Const Count: Integer): AnsiString;



{                                                                              }
{ Pad                                                                          }
{                                                                              }
Function Pad(Const S: AnsiString; Const PadChar: AnsiChar; Const Length: Integer;
     Const Cut: Boolean = False): AnsiString;
Function PadLeft(Const S: AnsiString; Const PadChar: AnsiChar;
     Const Length: Integer; Const Cut: Boolean = False): AnsiString;
Function PadRight(Const S: AnsiString; Const PadChar: AnsiChar;
     Const Length: Integer; Const Cut: Boolean = False): AnsiString;



{                                                                              }
{ Delimited                                                                    }
{                                                                              }
Function StrBetweenChar(Const S: AnsiString;
     Const FirstDelim, SecondDelim: AnsiChar;
     Const FirstOptional: Boolean = False;
     Const SecondOptional: Boolean = False): AnsiString; overload;
Function StrBetweenChar(Const S: AnsiString;
     Const FirstDelim, SecondDelim: CharSet;
     Const FirstOptional: Boolean = False;
     Const SecondOptional: Boolean = False): AnsiString; overload;
Function StrBetween(Const S: AnsiString;
     Const FirstDelim: AnsiString; Const SecondDelim: CharSet;
     Const FirstOptional: Boolean = False;
     Const SecondOptional: Boolean = False;
     Const FirstDelimCaseSensitive: Boolean = True): AnsiString;
Function StrBefore(Const S, D: AnsiString;
     Const Optional: Boolean = True;
     Const CaseSensitive: Boolean = True): AnsiString;
Function StrBeforeRev(Const S, D: AnsiString;
     Const Optional: Boolean = True;
     Const CaseSensitive: Boolean = True): AnsiString;
Function StrBeforeChar(Const S: AnsiString; Const D: CharSet;
     Const Optional: Boolean = True): AnsiString;
Function StrBeforeCharRev(Const S: AnsiString; Const D: CharSet;
     Const Optional: Boolean = True): AnsiString;
Function StrAfter(Const S, D: AnsiString): AnsiString;
Function StrAfterChar(Const S: AnsiString; Const D: CharSet): AnsiString;
Function StrRemoveCharDelimited(Var S: AnsiString;
     Const FirstDelim, SecondDelim: AnsiChar): AnsiString;


{                                                                              }
{ Count                                                                        }
{                                                                              }
Function StrCountChar(Const S: AnsiString; Const C: AnsiChar): Integer; overload;
Function StrCountChar(Const S: AnsiString; Const C: CharSet): Integer; overload;



{                                                                              }
{ Replace                                                                      }
{                                                                              }
Function StrReplaceChar(Const Find, Replace: AnsiChar;
     Const S: AnsiString): AnsiString; overload;
Function StrReplaceChar(Const Find: CharSet; Const Replace: AnsiChar;
     Const S: AnsiString): AnsiString; overload;
Function StrReplace(Const Find, Replace, S: AnsiString;
     Const CaseSensitive: Boolean = True): AnsiString; overload;
Function StrReplace(Const Find: CharSet;
     Const Replace, S: AnsiString): AnsiString; overload;
Function StrRemoveDup(Const S: AnsiString; Const C: AnsiChar): AnsiString;
Function StrRemoveChar(Const S: AnsiString; Const C: AnsiChar): AnsiString; overload;
Function StrRemoveChar(Const S: AnsiString; Const C: CharSet): AnsiString; overload;



{                                                                              }
{ Split                                                                        }
{                                                                              }
Function StrSplitAt(Const S: AnsiString; Const C: AnsiString;
     Var Left, Right: AnsiString;
     Const CaseSensitive: Boolean = True;
     Const Optional: Boolean = True): Boolean;
Function StrSplitAtChar(Const S: AnsiString; Const C: AnsiChar;
     Var Left, Right: AnsiString;
     Const Optional: Boolean = True): Boolean; overload;
Function StrSplitAtChar(Const S: AnsiString; Const C: CharSet;
     Var Left, Right: AnsiString;
     Const Optional: Boolean = True): Boolean; overload;
Function StrSplit(Const S, D: AnsiString): StringArray;
Function StrSplitChar(Const S: AnsiString; Const D: AnsiChar): StringArray; overload;
Function StrSplitChar(Const S: AnsiString; Const D: CharSet): StringArray; overload;
Function StrSplitWords(Const S: AnsiString; Const C: CharSet): StringArray;
Function StrJoin(Const S: Array Of AnsiString; Const D: AnsiString): AnsiString;
Function StrJoinChar(Const S: Array Of AnsiString; Const D: AnsiChar): AnsiString;



{                                                                              }
{ Quoting                                                                      }
{   QuoteText, UnquoteText converts text where the AnsiString is enclosed in a     }
{   pair of the same quote characters, and two consequetive occurance of the   }
{   quote character inside the quotes indicate a quote character in the text.  }
{   Examples:                                                                  }
{     QuoteText ('abc', '"') = '"abc"'                                         }
{     QuoteText ('a"b"c', '"') = '"a""b""c"'                                   }
{     UnquoteText ('"a""b""c"') = 'a"b"c'                                      }
{                                                                              }
Function StrHasSurroundingQuotes(Const S: AnsiString;
     Const Quotes: CharSet = csQuotes): Boolean;
Function StrRemoveSurroundingQuotes(Const S: AnsiString;
     Const Quotes: CharSet = csQuotes): AnsiString;
Function StrQuote(Const S: AnsiString; Const Quote: AnsiChar = '"'): AnsiString;
Function StrUnquote(Const S: AnsiString): AnsiString;
Function StrMatchQuotedStr(Const S: AnsiString;
     Const ValidQuotes: CharSet = csQuotes;
     Const Index: Integer = 1): Integer;
Function StrIsQuotedStr(Const S: AnsiString;
     Const ValidQuotes: CharSet = csQuotes): Boolean;
Function StrFindClosingQuote(Const S: AnsiString;
     Const OpenQuotePos: Integer): Integer;



{                                                                              }
{ Escaping                                                                     }
{                                                                              }
Function StrHexEscape(Const S: AnsiString; Const C: CharSet;
     Const EscPrefix: AnsiString = '\x'; Const EscSuffix: AnsiString = '';
     Const UpperHex: Boolean = True;
     Const TwoDigitHex: Boolean = True): AnsiString;
Function StrHexUnescape(Const S: AnsiString; Const EscPrefix: AnsiString = '\x';
     Const CaseSensitive: Boolean = True): AnsiString;

Function StrCharEscape(Const S: AnsiString; Const C: Array Of AnsiChar;
     Const EscPrefix: AnsiString;
     Const EscSeq: Array Of AnsiString): AnsiString;
Function StrCharUnescape(Const S: AnsiString; Const EscPrefix: AnsiString;
     Const C: Array Of AnsiChar; Const Replace: Array Of AnsiString;
     Const PrefixCaseSensitive: Boolean = True;
     Const AlwaysDropPrefix: Boolean = True): AnsiString;

Function StrCStyleEscape(Const S: AnsiString): AnsiString;
Function StrCStyleUnescape(Const S: AnsiString): AnsiString;



{                                                                              }
{ Prefix and Suffix                                                            }
{                                                                              }
Function StrInclPrefix(Const S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean = True): AnsiString;
Function StrInclSuffix(Const S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean = True): AnsiString;
Function StrExclPrefix(Const S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean = True): AnsiString;
Function StrExclSuffix(Const S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean = True): AnsiString;
Procedure StrEnsurePrefix(Var S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean = True);
Procedure StrEnsureSuffix(Var S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean = True);
Procedure StrEnsureNoPrefix(Var S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean = True);
Procedure StrEnsureNoSuffix(Var S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean = True);



{                                                                              }
{ Skip                                                                         }
{                                                                              }
Function SkipChar(Var P: PAnsiChar; Const C: AnsiChar): Boolean; overload;
Function SkipChar(Var P: PAnsiChar; Const C: CharSet): Boolean; overload;
Function SkipAll(Var P: PAnsiChar; Const C: AnsiChar): Integer; overload;
Function SkipAll(Var P: PAnsiChar; Const C: CharSet): Integer; overload;
Function SkipToChar(Var P: PAnsiChar; Const C: CharSet): Integer;
Function SkipToStr(Var P: PAnsiChar; Const S: AnsiString;
     Const CaseSensitive: Boolean = True): Integer;
Function Skip2CharSeq(Var P: PAnsiChar; Const S1, S2: CharSet): Boolean;
Function Skip3CharSeq(Var P: PAnsiChar; Const S1, S2, S3: CharSet): Boolean;
Function SkipStr(Var P: PAnsiChar; Const S: AnsiString;
     Const CaseSensitive: Boolean = True): Boolean;



{                                                                              }
{ Extract                                                                      }
{                                                                              }
Function ExtractAll(Var P: PAnsiChar; Const C: AnsiChar): AnsiString; overload;
Function ExtractAll(Var P: PAnsiChar; Const C: CharSet): AnsiString; overload;
Function ExtractTo(Var P: PAnsiChar; Const C: CharSet): AnsiString;
Function ExtractToStr(Var P: PAnsiChar; Const S: AnsiString;
     Const CaseSensitive: Boolean = True): AnsiString;
Function ExtractQuoted(Var P: PAnsiChar): AnsiString;



{                                                                              }
{ Type conversion                                                              }
{                                                                              }
Function StrToFloatDef(Const S: AnsiString; Const Default: Extended): Extended;
Function BooleanToStr(Const B: Boolean): AnsiString;
Function StrToBoolean(Const S: AnsiString): Boolean;
Function VarRecToString(Const V: TVarRec; Const QuoteStrings: Boolean): AnsiString;



{                                                                              }
{ Fast abbreviated regular expression matcher                                  }
{                                                                              }
{   Matches regular expressions of the form: (<charset><quant>)*               }
{     where <charset> is a character set and <quant> is one of the quantifiers }
{     (mnOnce, mnOptional = ?, mnAny = *, mnLeastOnce = +).                    }
{                                                                              }
{   Supports deterministic/non-deterministic, greedy/non-greedy matching.      }
{   Returns first MatchPos (as opposed to longest).                            }
{   Uses an NFA (Non-deterministic Finite Automata).                           }
{                                                                              }
{   For example:                                                               }
{     I := 1                                                                   }
{     S := 'a123'                                                              }
{     MatchQuantSeq(I, [['a'..'z'], ['0'..9']], [mqOnce, mqAny], S) = True     }
{                                                                              }
{     is the same as matching the regular expression [a-z][0-9]*               }
{                                                                              }
Type
     TMatchQuantifier = (
          mqOnce,
          mqAny,
          mqLeastOnce,
          mqOptional);
     TMatchQuantSeqOptions = Set Of (
          moDeterministic,
          moNonGreedy);

Function MatchQuantSeq(Var MatchPos: Integer;
     Const MatchSeq: Array Of CharSet; Const Quant: Array Of TMatchQuantifier;
     Const S: AnsiString; Const MatchOptions: TMatchQuantSeqOptions = [];
     Const StartIndex: Integer = 1; Const StopIndex: Integer = -1): Boolean;



{                                                                              }
{ Fast Pattern Matcher                                                         }
{                                                                              }
{   Matches a subset of regular expressions (* ? and [])                       }
{   Matching is non-determistic (ie does backtracking) / non-greedy (ie lazy)  }
{       '*' Matches zero or more of any character                              }
{       '?' Matches exactly one character                                      }
{       [<AnsiChar set>] Matches character from <AnsiChar set>                         }
{       [^<AnsiChar set>] Matches character not in <AnsiChar set>                      }
{       where <AnsiChar set> can include multiple ranges and escaped characters    }
{         '\n' matches NewLine (#10), '\r' matches Return (#13)                }
{         '\\' matches a slash ('\'), '\]' matches a close bracket (']'), etc. }
{                                                                              }
{   Examples:                                                                  }
{       MatchPattern('[a-z0-9_]bc?*c', 'abcabc') = True                        }
{       MatchPattern('[\\\r\n]+', '\'#13#10) = True                            }
{                                                                              }
Function MatchPattern(M, S: PAnsiChar): Boolean;



{                                                                              }
{ File Mask Matcher                                                            }
{   Matches classic file mask type regular expressions.                        }
{     ? = matches one character (or zero if at end of mask)                    }
{     * = matches zero or more characters                                      }
{                                                                              }
Function MatchFileMask(Const Mask, Key: AnsiString;
     Const CaseSensitive: Boolean = False): Boolean;



{                                                                              }
{ Character class strings                                                      }
{                                                                              }
{   Perl-like character class AnsiString representation of character sets, eg      }
{   the set ['0', 'A'..'Z'] is presented as [0A-Z]. Negated classes are also   }
{   supported, eg '[^A-Za-z]' is all non-alpha characters. The empty and       }
{   complete sets have special representations; '[]' and '.' respectively.     }
{                                                                              }
Function CharSetToCharClassStr(Const C: CharSet): AnsiString;
Function CharClassStrToCharSet(Const S: AnsiString): CharSet;



{                                                                              }
{ Dynamic array functions                                                      }
{                                                                              }
Function StringsTotalLength(Const S: Array Of AnsiString): Integer;
Function PosNextNoCase(Const Find: AnsiString; Const V: Array Of AnsiString;
     Const PrevPos: Integer = -1;
     Const IsSortedAscending: Boolean = False): Integer;



{                                                                              }
{ Multi-Line encodings                                                         }
{                                                                              }
Function EncodeDotLineTerminated(Const S: AnsiString): AnsiString;
Function EncodeEmptyLineTerminated(Const S: AnsiString): AnsiString;
Function DecodeDotLineTerminated(Const S: AnsiString): AnsiString;
Function DecodeEmptyLineTerminated(Const S: AnsiString): AnsiString;



{                                                                              }
{ Natural language                                                             }
{                                                                              }
Function StorageSize(Const Bytes: Int64;
     Const ShortFormat: Boolean = False): AnsiString;
Function TransferRate(Const Bytes, MillisecondsElapsed: Int64;
     Const ShortFormat: Boolean = False): AnsiString;






Implementation

Uses
     { Delphi }
     SysUtils,
     Math;



{                                                                              }
{ Miscellaneous functions                                                      }
{                                                                              }

Procedure SetLengthAndZero(Var S: AnsiString; Const NewLength: Integer);
Var
     L                        : Integer;
     P                        : PAnsiChar;
Begin
     L := Length(S);
     If L = NewLength Then
          exit;
     SetLength(S, NewLength);
     If L > NewLength Then
          exit;
     P := Pointer(S);
     Inc(P, L);
     FillChar(P^, NewLength - L, #0);
End;

{$IFDEF CPU_INTEL386}

Function CharMatchNoCase(Const A, B: AnsiChar): Boolean;
Asm
    and eax, $000000FF
    and edx, $000000FF
    mov al, byte ptr [AnsiLowCaseLookup + eax]
    cmp al, byte ptr [AnsiLowCaseLookup + edx]
    setz al
End;
{$ELSE}

Function CharMatchNoCase(Const A, B: AnsiChar): Boolean;
Begin
     Result := AnsiLowCaseLookup[A] = AnsiLowCaseLookup[B];
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Function CharMatch(Const A, B: AnsiChar; Const CaseSensitive: Boolean): Boolean;
Asm
    or cl, cl
    jz CharMatchNoCase
    cmp al, dl
    setz al
End;
{$ELSE}

Function CharMatch(Const A, B: AnsiChar; Const CaseSensitive: Boolean): Boolean;
Begin
     If CaseSensitive Then
          Result := A = B
     Else
          Result := AnsiLowCaseLookup[A] = AnsiLowCaseLookup[B];
End;
{$ENDIF}

Function CharMatch(Const A: CharSet; Const B: AnsiChar;
     Const CaseSensitive: Boolean): Boolean;
Begin
     If CaseSensitive Then
          Result := CharInSet(B , A)
     Else
          Result := (CharInSet(UpCase(B) , A)) Or (CharInSet(LowCase(B) , A));
End;

Function StrIsNumeric(Const S: AnsiString): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(S);
     Result := (L > 0) And (StrPMatchLen(Pointer(S), csNumeric, L) = L);
End;

Function StrIsHex(Const S: AnsiString): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(S);
     Result := (L > 0) And (StrPMatchLen(Pointer(S), csHexDigit, L) = L);
End;

Function StrIsAlpha(Const S: AnsiString): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(S);
     Result := (L > 0) And (StrPMatchLen(Pointer(S), csAlpha, L) = L);
End;

Function StrIsAlphaNumeric(Const S: AnsiString): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(S);
     Result := (L > 0) And (StrPMatchLen(Pointer(S), csAlphaNumeric, L) = L);
End;

Function StrIsInteger(Const S: AnsiString): Boolean;
Var
     L                        : Integer;
     P                        : PAnsiChar;
Begin
     L := Length(S);
     Result := L > 0;
     If Not Result Then
          exit;
     P := Pointer(S);
     If P^ In csSign Then Begin
          Inc(P);
          Dec(L);
     End;
     Result := (L > 0) And (StrPMatchLen(P, csNumeric, L) = L);
End;

Function StrReverse(Const S: AnsiString): AnsiString;
Var
     I, L                     : Integer;
     P, Q                     : PAnsiChar;
Begin
     L := Length(S);
     If L = 0 Then Begin
          Result := '';
          exit;
     End;
     If L = 1 Then Begin
          Result := S;
          exit;
     End;
     SetLength(Result, L);
     P := Pointer(S);
     Q := Pointer(Result);
     Inc(Q, L - 1);
     For I := 1 To L Do Begin
          Q^ := P^;
          Dec(Q);
          Inc(P);
     End;
End;



{                                                                              }
{ Case conversion                                                              }
{                                                                              }
{$IFDEF CPU_INTEL386}

Function LowCase(Const Ch: AnsiChar): AnsiChar;
Asm
        CMP     AL,'A'
        JB      @@exit
        CMP     AL,'Z'
        JA      @@exit
        ADD     AL,'a' - 'A'
  @@exit:
End;
{$ELSE}

Function LowCase(Const Ch: AnsiChar): AnsiChar;
Begin
     If Ch In ['A'..'Z'] Then
          Result := AnsiChar(Byte(Ch) - 32)
     Else
          Result := Ch;
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure ConvertUpper(Var S: AnsiString);
Asm
      OR      EAX, EAX
      JZ      @Exit
      PUSH    EAX
      MOV     EAX, [EAX]
      OR      EAX, EAX
      JZ      @ExitP
      MOV     ECX, [EAX - 4]
      OR      ECX, ECX
      JZ      @ExitP
      XOR     DH, DH
  @L2:
      DEC     ECX
      MOV     DL, [EAX + ECX]
      CMP     DL, 'a'
      JB      @L1
      CMP     DL, 'z'
      JA      @L1
      OR      DH, DH
      JZ      @Uniq
  @L3:
      SUB     DL, 'a' - 'A'
      MOV     [EAX + ECX], DL
  @L1:
      OR      ECX, ECX
      JNZ     @L2
      OR      DH, DH
      JNZ     @Exit
  @ExitP:
      POP     EAX
  @Exit:
      RET
  @Uniq:
      POP     EAX
      PUSH    ECX
      PUSH    EDX
      CALL    UniqueString
      POP     EDX
      POP     ECX
      MOV     DH, 1
      JMP     @L3
End;
{$ELSE}

Procedure ConvertUpper(Var S: AnsiString);
Var
     F                        : Integer;
Begin
     For F := 0 To Length(S) - 1 Do
          If S[F] In ['a'..'z'] Then
               S[F] := AnsiChar(Ord(S[F]) - 32);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure ConvertLower(Var S: AnsiString);
Asm
      OR      EAX, EAX
      JZ      @Exit
      PUSH    EAX
      MOV     EAX, [EAX]
      OR      EAX, EAX
      JZ      @ExitP
      MOV     ECX, [EAX - 4]
      OR      ECX, ECX
      JZ      @ExitP
      XOR     DH, DH
  @L2:
      DEC     ECX
      MOV     DL, [EAX + ECX]
      CMP     DL, 'A'
      JB      @L1
      CMP     DL, 'Z'
      JA      @L1
      OR      DH, DH
      JZ      @Uniq
  @L3:
      ADD     DL, 'a' - 'A'
      MOV     [EAX + ECX], DL
  @L1:
      OR      ECX, ECX
      JNZ     @L2
      OR      DH, DH
      JNZ     @Exit
  @ExitP:
      POP     EAX
  @Exit:
      RET
  @Uniq:
      POP     EAX
      PUSH    ECX
      PUSH    EDX
      CALL    UniqueString
      POP     EDX
      POP     ECX
      MOV     DH, 1
      JMP     @L3
End;
{$ELSE}

Procedure ConvertLower(Var S: AnsiString);
Var
     F                        : Integer;
Begin
     For F := 1 To Length(S) Do
          If S[F] In ['A'..'Z'] Then
               S[F] := AnsiChar(Ord(S[F]) + 32);
End;
{$ENDIF}

{$IFDEF CPU_INTEL386}

Procedure ConvertFirstUp(Var S: AnsiString);
Asm
      TEST    EAX, EAX
      JZ      @Exit
      MOV     EDX, [EAX]
      TEST    EDX, EDX
      JZ      @Exit
      MOV     ECX, [EDX - 4]
      OR      ECX, ECX
      JZ      @Exit
      MOV     DL, [EDX]
      CMP     DL, 'a'
      JB      @Exit
      CMP     DL, 'z'
      JA      @Exit
      CALL    UniqueString
      SUB     BYTE PTR [EAX], 'a' - 'A'
  @Exit:
End;
{$ELSE}

Procedure ConvertFirstUp(Var S: AnsiString);
Var
     P                        : PAnsiChar;
Begin
     If S <> '' Then Begin
          P := Pointer(S);
          If P^ In ['a'..'z'] Then
               S[1] := UpCase(P^);
     End;
End;
{$ENDIF}

Function FirstUp(Const S: AnsiString): AnsiString;
Begin
     Result := S;
     ConvertFirstUp(Result);
End;

Procedure ConvertUpper(Var S: StringArray);
Var
     I                        : Integer;
Begin
     For I := 0 To Length(S) - 1 Do
          ConvertUpper(S[I]);
End;

Procedure ConvertLower(Var S: StringArray);
Var
     I                        : Integer;
Begin
     For I := 0 To Length(S) - 1 Do
          ConvertLower(S[I]);
End;



{                                                                              }
{ Match                                                                        }
{                                                                              }

Function StrPCompare(Const A, B: PAnsiChar; Const Len: Integer): TCompareResult;
Var
     P, Q                     : PAnsiChar;
     I                        : Integer;
Begin
     P := A;
     Q := B;
     If Len <= 0 Then Begin
          Result := crUndefined;
          exit;
     End;
     For I := 1 To Len Do
          If P^ = Q^ Then Begin
               Inc(P);
               Inc(Q);
          End
          Else Begin
               If Ord(P^) < Ord(Q^) Then
                    Result := crLess
               Else
                    Result := crGreater;
               exit;
          End;
     Result := crEqual;
End;

Function StrPCompareNoCase(Const A, B: PAnsiChar; Const Len: Integer): TCompareResult;
Var
     P, Q                     : PAnsiChar;
     C, D                     : AnsiChar;
     I                        : Integer;
Begin
     P := A;
     Q := B;
     If Len <= 0 Then Begin
          Result := crUndefined;
          exit;
     End;
     For I := 1 To Len Do Begin
          C := AnsiLowCaseLookup[P^];
          D := AnsiLowCaseLookup[Q^];
          If C = D Then Begin
               Inc(P);
               Inc(Q);
          End
          Else Begin
               If Ord(C) < Ord(D) Then
                    Result := crLess
               Else
                    Result := crGreater;
               exit;
          End;
     End;
     Result := crEqual;
End;

Function StrCompareNoCase(Const A, B: AnsiString): TCompareResult;
Var
     L, M                     : Integer;
Begin
     L := Length(A);
     M := Length(B);
     Result := StrPCompareNoCase(Pointer(A), Pointer(B), MinI(L, M));
     If Result <> crEqual Then
          exit;
     If L = M Then
          Result := crEqual
     Else If L < M Then
          Result := crLess
     Else
          Result := crGreater;
End;

Function StrEqualNoCase(Const A, B: AnsiString): Boolean;
Var
     L1, L2                   : Integer;
Begin
     L1 := Length(A);
     L2 := Length(B);
     Result := L1 = L2;
     If Not Result Or (L1 = 0) Then
          exit;
     If Pointer(A) = Pointer(B) Then
          exit;
     Result := StrPCompareNoCase(Pointer(A), Pointer(B), L1) = crEqual;
End;

Function StrEqual(Const A, B: AnsiString; Const CaseSensitive: Boolean): Boolean;
Var
     L1, L2                   : Integer;
Begin
     L1 := Length(A);
     L2 := Length(B);
     Result := L1 = L2;
     If Not Result Or (L1 = 0) Then
          exit;
     If Pointer(A) = Pointer(B) Then
          exit;
     If CaseSensitive Then
          Result := StrPCompare(Pointer(A), Pointer(B), L1) = crEqual
     Else
          Result := StrPCompareNoCase(Pointer(A), Pointer(B), L1) = crEqual;
End;

Function StrPEqual(Const P1, P2: PAnsiChar; Const Len1, Len2: Integer;
     Const CaseSensitive: Boolean): Boolean;
Begin
     Result := Len1 = Len2;
     If Not Result Or (Len1 = 0) Then
          exit;
     If P1 = P2 Then
          exit;
     If CaseSensitive Then
          Result := StrPCompare(P1, P2, Len1) = crEqual
     Else
          Result := StrPCompareNoCase(P1, P2, Len1) = crEqual;
End;

Function StrPEqual(Const P: PAnsiChar; Const Len: Integer; Const S: AnsiString;
     Const CaseSensitive: Boolean): Boolean;
Begin
     Result := Len = Length(S);
     If Not Result Or (Len = 0) Then
          exit;
     If P = Pointer(S) Then
          exit;
     If CaseSensitive Then
          Result := StrPCompare(P, Pointer(S), Len) = crEqual
     Else
          Result := StrPCompareNoCase(P, Pointer(S), Len) = crEqual;
End;

Function StrMatch(Const M, S: AnsiString; Const Index: Integer): Boolean;
Var
     N, T                     : Integer;
     Q                        : PAnsiChar;
Begin
     N := Length(M);
     T := Length(S);
     If (N = 0) Or (T = 0) Or (Index < 1) Or (Index + N - 1 > T) Then Begin
          Result := False;
          exit;
     End;
     Q := Pointer(S);
     Inc(Q, Index - 1);
     Result := StrPCompare(Pointer(M), Q, N) = crEqual;
End;

Function StrMatchNoCase(Const M, S: AnsiString; Const Index: Integer): Boolean;
Var
     N, T                     : Integer;
     Q                        : PAnsiChar;
Begin
     N := Length(M);
     T := Length(S);
     If (N = 0) Or (T = 0) Or (Index < 1) Or (Index + N - 1 > T) Then Begin
          Result := False;
          exit;
     End;
     Q := Pointer(S);
     Inc(Q, Index - 1);
     Result := StrPCompareNoCase(Pointer(M), Q, N) = crEqual;
End;

Function StrPMatchStr(Const P: PAnsiChar; Const M: AnsiString): Boolean;
Var
     T, Q                     : PAnsiChar;
     I, L                     : Integer;
     C                        : AnsiChar;
Begin
     L := Length(M);
     If L = 0 Then Begin
          Result := False;
          exit;
     End;
     T := P;
     Q := Pointer(M);
     For I := 1 To L Do Begin
          C := T^;
          If (C = #0) Or (C <> Q^) Then Begin
               Result := False;
               exit;
          End
          Else Begin
               Inc(T);
               Inc(Q);
          End;
     End;
     Result := True;
End;

Function StrPMatchStrNoCase(Const P: PAnsiChar; Const M: AnsiString): Boolean;
Var
     T, Q                     : PAnsiChar;
     I, L                     : Integer;
     C, D                     : AnsiChar;
Begin
     L := Length(M);
     If L = 0 Then Begin
          Result := False;
          exit;
     End;
     T := P;
     Q := Pointer(M);
     For I := 1 To L Do Begin
          C := AnsiLowCaseLookup[T^];
          D := AnsiLowCaseLookup[Q^];
          If (C = #0) Or (C <> D) Then Begin
               Result := False;
               exit;
          End
          Else Begin
               Inc(T);
               Inc(Q);
          End;
     End;
     Result := True;
End;

Function StrPMatchStr(Const P: PAnsiChar; Const M: AnsiString;
     Const CaseSensitive: Boolean): Boolean;
Begin
     If CaseSensitive Then
          Result := StrPMatchStr(P, M)
     Else
          Result := StrPMatchStrNoCase(P, M);
End;

Function StrMatchLeft(Const M, S: AnsiString; Const CaseSensitive: Boolean): Boolean;
Begin
     If CaseSensitive Then
          Result := StrMatch(M, S, 1)
     Else
          Result := StrMatchNoCase(M, S, 1);
End;

Function StrMatchRight(Const M, S: AnsiString; Const CaseSensitive: Boolean): Boolean;
Var
     I                        : Integer;
Begin
     I := Length(S) - Length(M) + 1;
     If CaseSensitive Then
          Result := StrMatch(M, S, I)
     Else
          Result := StrMatchNoCase(M, S, I);
End;

Function StrPMatchLen(Const S: PAnsiChar; Const C: CharSet;
     Const Len: Integer): Integer;
Var
     P                        : PAnsiChar;
     L                        : Integer;
Begin
     P := S;
     L := Len;
     Result := 0;
     While L > 0 Do
          If P^ In C Then Begin
               Inc(P);
               Dec(L);
               Inc(Result);
          End
          Else
               exit;
End;

Function StrMatchChar(Const M: CharSet; Const S: AnsiString): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(S);
     Result := StrPMatchLen(Pointer(S), M, L) = L;
End;



{                                                                              }
{ Pos                                                                          }
{                                                                              }

Function PosChar(Const F: AnsiChar; Const S: AnsiString;
     Const Index: Integer): Integer;
Var
     P                        : PAnsiChar;
     L, I                     : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Index > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     Inc(P, I - 1);
     While I <= L Do
          If P^ = F Then Begin
               Result := I;
               exit;
          End
          Else Begin
               Inc(P);
               Inc(I);
          End;
     Result := 0;
End;

Function PosChar(Const F: CharSet; Const S: AnsiString;
     Const Index: Integer): Integer;
Var
     P                        : PAnsiChar;
     L, I                     : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Index > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     Inc(P, I - 1);
     While I <= L Do
          If P^ In F Then Begin
               Result := I;
               exit;
          End
          Else Begin
               Inc(P);
               Inc(I);
          End;
     Result := 0;
End;

Function PosNotChar(Const F: AnsiChar; Const S: AnsiString;
     Const Index: Integer): Integer;
Var
     P                        : PAnsiChar;
     L, I                     : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Index > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     Inc(P, I - 1);
     While I <= L Do
          If P^ <> F Then Begin
               Result := I;
               exit;
          End
          Else Begin
               Inc(P);
               Inc(I);
          End;
     Result := 0;
End;

Function PosNotChar(Const F: CharSet; Const S: AnsiString;
     Const Index: Integer): Integer;
Var
     P                        : PAnsiChar;
     L, I                     : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Index > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     Inc(P, I - 1);
     While I <= L Do
          If Not (P^ In F) Then Begin
               Result := I;
               exit;
          End
          Else Begin
               Inc(P);
               Inc(I);
          End;
     Result := 0;
End;

Function PosCharRev(Const F: AnsiChar; Const S: AnsiString;
     Const Index: Integer): Integer;
Var
     P                        : PAnsiChar;
     L, I, J                  : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Index > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     J := L;
     Inc(P, J - 1);
     While J >= I Do
          If P^ = F Then Begin
               Result := J;
               exit;
          End
          Else Begin
               Dec(P);
               Dec(J);
          End;
     Result := 0;
End;

Function PosCharRev(Const F: CharSet; Const S: AnsiString;
     Const Index: Integer): Integer;
Var
     P                        : PAnsiChar;
     L, I, J                  : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Index > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     J := L;
     Inc(P, J - 1);
     While J >= I Do
          If P^ In F Then Begin
               Result := J;
               exit;
          End
          Else Begin
               Dec(P);
               Dec(J);
          End;
     Result := 0;
End;

Function PosStr(Const F, S: AnsiString; Const Index: Integer;
     Const CaseSensitive: Boolean): Integer;
Var
     P                        : PAnsiChar;
     L, M, I                  : Integer;
Begin
     L := Length(S);
     M := Length(F);
     If (L = 0) Or (Index > L) Or (M = 0) Or (M > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     Inc(P, I - 1);
     Dec(L, M - 1);
     While I <= L Do
          If StrPMatchStr(P, F, CaseSensitive) Then Begin
               Result := I;
               exit;
          End
          Else Begin
               Inc(P);
               Inc(I);
          End;
     Result := 0;
End;

Function PosStrRev(Const F, S: AnsiString; Const Index: Integer;
     Const CaseSensitive: Boolean): Integer;
Var
     P                        : PAnsiChar;
     L, M, I, J               : Integer;
Begin
     L := Length(S);
     M := Length(F);
     If (L = 0) Or (Index > L) Or (M = 0) Or (M > L) Then Begin
          Result := 0;
          exit;
     End;
     If Index < 1 Then
          I := 1
     Else
          I := Index;
     P := Pointer(S);
     Dec(L, M - 1);
     Inc(P, L - 1);
     J := L;
     While J >= I Do
          If StrPMatchStr(P, F, CaseSensitive) Then Begin
               Result := J;
               exit;
          End
          Else Begin
               Dec(P);
               Dec(J);
          End;
     Result := 0;
End;

Function PosNStr(Const F, S: AnsiString; Const N: Integer;
     Const Index: Integer; Const CaseSensitive: Boolean): Integer;
Var
     I, J, M                  : Integer;
Begin
     Result := 0;
     If N <= 0 Then
          exit;
     M := Length(F);
     If M = 0 Then
          exit;
     J := 1;
     For I := 1 To N Do Begin
          Result := PosStr(F, S, J, CaseSensitive);
          If Result = 0 Then
               exit;
          J := Result + M;
     End;
End;



{                                                                              }
{ Copy variations                                                              }
{                                                                              }

Function CopyRange(Const S: AnsiString; Const StartIndex, StopIndex: Integer): AnsiString;
Var
     L, I                     : Integer;
Begin
     L := Length(S);
     If (StartIndex > StopIndex) Or (StopIndex < 1) Or (StartIndex > L) Or (L = 0) Then
          Result := ''
     Else Begin
          If StartIndex <= 1 Then
               If StopIndex >= L Then Begin
                    Result := S;
                    exit;
               End
               Else
                    I := 1
          Else
               I := StartIndex;
          Result := Copy(S, I, StopIndex - I + 1);
     End;
End;

Function CopyFrom(Const S: AnsiString; Const Index: Integer): AnsiString;
Var
     L                        : Integer;
Begin
     If Index <= 1 Then
          Result := S
     Else Begin
          L := Length(S);
          If (L = 0) Or (Index > L) Then
               Result := ''
          Else
               Result := Copy(S, Index, L - Index + 1);
     End;
End;

Function CopyLeft(Const S: AnsiString; Const Count: Integer): AnsiString;
Var
     L                        : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Count <= 0) Then
          Result := ''
     Else If Count >= L Then
          Result := S
     Else
          Result := Copy(S, 1, Count);
End;

Function CopyRight(Const S: AnsiString; Const Count: Integer): AnsiString;
Var
     L                        : Integer;
Begin
     L := Length(S);
     If (L = 0) Or (Count <= 0) Then
          Result := ''
     Else If Count >= L Then
          Result := S
     Else
          Result := Copy(S, L - Count + 1, Count);
End;

Function CopyLeftEllipsed(Const S: AnsiString; Const Count: Integer): AnsiString;
Var
     L                        : Integer;
Begin
     If Count < 0 Then Begin
          Result := S;
          exit;
     End;
     If Count = 0 Then Begin
          Result := '';
          exit;
     End;
     L := Length(S);
     If L <= Count Then Begin
          Result := S;
          exit;
     End;
     If Count <= 3 Then Begin
          Result := DupChar(' ', Count);
          exit;
     End;
     Result := Copy(S, 1, Count - 3) + '...';
End;



{                                                                              }
{ CopyEx                                                                       }
{                                                                              }

{ TranslateStartStop translates Start, Stop parameters (negative values are    }
{ indexed from back of AnsiString) into StartIdx and StopIdx (relative to start).  }
{ Returns False if the Start, Stop does not specify a valid range.             }

Function TranslateStart(Const S: AnsiString; Const Start: Integer; Var Len, StartIndex: Integer): Boolean;
Begin
     Len := Length(S);
     If Len = 0 Then
          Result := False
     Else Begin
          StartIndex := Start;
          If Start < 0 Then
               Inc(StartIndex, Len + 1);
          If StartIndex > Len Then
               Result := False
          Else Begin
               If StartIndex < 1 Then
                    StartIndex := 1;
               Result := True;
          End;
     End;
End;

Function TranslateStartStop(Const S: AnsiString; Const Start, Stop: Integer; Var Len, StartIndex, StopIndex: Integer): Boolean;
Begin
     Len := Length(S);
     If Len = 0 Then
          Result := False
     Else Begin
          StartIndex := Start;
          If Start < 0 Then
               Inc(StartIndex, Len + 1);
          StopIndex := Stop;
          If StopIndex < 0 Then
               Inc(StopIndex, Len + 1);
          If (StopIndex < 1) Or (StartIndex > Len) Or (StopIndex < StartIndex) Then
               Result := False
          Else Begin
               If StopIndex > Len Then
                    StopIndex := Len;
               If StartIndex < 1 Then
                    StartIndex := 1;
               Result := True;
          End;
     End;
End;

Function CopyEx(Const S: AnsiString; Const Start, Count: Integer): AnsiString;
Var
     I, L                     : Integer;
Begin
     If (Count < 0) Or Not TranslateStart(S, Start, L, I) Then
          Result := ''
     Else If (I = 1) And (Count >= L) Then
          Result := S
     Else
          Result := Copy(S, I, Count);
End;

Function CopyRangeEx(Const S: AnsiString; Const Start, Stop: Integer): AnsiString;
Var
     I, J, L                  : Integer;
Begin
     If Not TranslateStartStop(S, Start, Stop, L, I, J) Then
          Result := ''
     Else If (I = 1) And (J = L) Then
          Result := S
     Else
          Result := Copy(S, I, J - I + 1);
End;

Function CopyFromEx(Const S: AnsiString; Const Start: Integer): AnsiString;
Var
     I, L                     : Integer;
Begin
     If Not TranslateStart(S, Start, L, I) Then
          Result := ''
     Else If I <= 1 Then
          Result := S
     Else
          Result := Copy(S, I, L - I + 1);
End;



{                                                                              }
{ Trim                                                                         }
{                                                                              }

Function TrimLeft(Const S: AnsiString; Const C: CharSet): AnsiString;
Var
     F, L                     : Integer;
Begin
     L := Length(S);
     F := 1;
     While (F <= L) And (S[F] In C) Do
          Inc(F);
     Result := CopyFrom(S, F);
End;

Procedure TrimLeftInPlace(Var S: AnsiString; Const C: CharSet);
Var
     F, L                     : Integer;
     P                        : PAnsiChar;
Begin
     L := Length(S);
     F := 1;
     While (F <= L) And (S[F] In C) Do
          Inc(F);
     If F > L Then
          S := ''
     Else If F > 1 Then Begin
          L := L - F + 1;
          If L > 0 Then Begin
               P := Pointer(S);
               Inc(P, F - 1);
               MoveMem(P^, Pointer(S)^, L);
          End;
          SetLength(S, L);
     End;
End;

Function TrimLeftStrNoCase(Const S: AnsiString; Const TrimStr: AnsiString): AnsiString;
Var
     F, L, M                  : Integer;
Begin
     L := Length(TrimStr);
     M := Length(S);
     F := 1;
     While (F <= M) And StrMatchNoCase(TrimStr, S, F) Do
          Inc(F, L);
     Result := CopyFrom(S, F);
End;

Function TrimRight(Const S: AnsiString; Const C: CharSet): AnsiString;
Var
     F                        : Integer;
Begin
     F := Length(S);
     While (F >= 1) And (S[F] In C) Do
          Dec(F);
     Result := CopyLeft(S, F);
End;

Procedure TrimRightInPlace(Var S: AnsiString; Const C: CharSet);
Var
     F                        : Integer;
Begin
     F := Length(S);
     While (F >= 1) And (S[F] In C) Do
          Dec(F);
     If F = 0 Then
          S := ''
     Else
          SetLength(S, F);
End;

Function TrimRightStrNoCase(Const S: AnsiString; Const TrimStr: AnsiString): AnsiString;
Var
     F, L                     : Integer;
Begin
     L := Length(TrimStr);
     F := Length(S) - L + 1;
     While (F >= 1) And StrMatchNoCase(TrimStr, S, F) Do
          Dec(F, L);
     Result := CopyLeft(S, F + L - 1);
End;

Function Trim(Const S: AnsiString; Const C: CharSet): AnsiString;
Var
     F, G, L                  : Integer;
Begin
     L := Length(S);
     F := 1;
     While (F <= L) And (S[F] In C) Do
          Inc(F);
     G := L;
     While (G >= F) And (S[G] In C) Do
          Dec(G);
     Result := CopyRange(S, F, G);
End;

Procedure TrimInPlace(Var S: AnsiString; Const C: CharSet);
Begin
     TrimLeftInPlace(S, C);
     TrimRightInPlace(S, C);
End;

Procedure TrimStrings(Var S: StringArray; Const C: CharSet);
Var
     I                        : Integer;
Begin
     For I := 0 To Length(S) - 1 Do
          TrimInPlace(S[I], C);
End;



{                                                                              }
{ Dup                                                                          }
{                                                                              }

Function DupBuf(Const Buf; Const BufSize: Integer; Const Count: Integer): AnsiString;
Var
     P                        : PAnsiChar;
     I                        : Integer;
Begin
     If (Count <= 0) Or (BufSize <= 0) Then
          Result := ''
     Else Begin
          SetLength(Result, Count * BufSize);
          P := Pointer(Result);
          For I := 1 To Count Do Begin
               MoveMem(Buf, P^, BufSize);
               Inc(P, BufSize);
          End;
     End;
End;

Function DupBuf(Const Buf; Const BufSize: Integer): AnsiString;
Begin
     If BufSize <= 0 Then
          Result := ''
     Else Begin
          SetLength(Result, BufSize);
          MoveMem(Buf, Pointer(Result)^, BufSize);
     End;
End;

Function DupStr(Const S: AnsiString; Const Count: Integer): AnsiString;
Var
     L                        : Integer;
Begin
     L := Length(S);
     If L = 0 Then
          Result := ''
     Else
          Result := DupBuf(Pointer(S)^, L, Count);
End;

Function DupChar(Const Ch: AnsiChar; Const Count: Integer): AnsiString;
Begin
     If Count <= 0 Then Begin
          Result := '';
          exit;
     End;
     SetLength(Result, Count);
     FillChar(Pointer(Result)^, Count, Ch);
End;



{                                                                              }
{ Pad                                                                          }
{                                                                              }

Function PadLeft(Const S: AnsiString; Const PadChar: AnsiChar;
     Const Length: Integer; Const Cut: Boolean): AnsiString;
Var
     F, L, P, M               : Integer;
     I, J                     : PAnsiChar;
Begin
     If Length = 0 Then Begin
          If Cut Then
               Result := ''
          Else
               Result := S;
          exit;
     End;
     M := System.Length(S);
     If Length = M Then Begin
          Result := S;
          exit;
     End;
     If Cut Then
          L := Length
     Else
          L := MaxI(Length, M);
     P := L - M;
     If P < 0 Then
          P := 0;
     SetLength(Result, L);
     If P > 0 Then
          FillChar(Pointer(Result)^, P, PadChar);
     If L > P Then Begin
          I := Pointer(Result);
          J := Pointer(S);
          Inc(I, P);
          For F := 1 To L - P Do Begin
               I^ := J^;
               Inc(I);
               Inc(J);
          End;
     End;
End;

Function PadRight(Const S: AnsiString; Const PadChar: AnsiChar;
     Const Length: Integer; Const Cut: Boolean): AnsiString;
Var
     F, L, P, M               : Integer;
     I, J                     : PAnsiChar;
Begin
     If Length = 0 Then Begin
          If Cut Then
               Result := ''
          Else
               Result := S;
          exit;
     End;
     M := System.Length(S);
     If Length = M Then Begin
          Result := S;
          exit;
     End;
     If Cut Then
          L := Length
     Else
          L := MaxI(Length, M);
     P := L - M;
     If P < 0 Then
          P := 0;
     SetLength(Result, L);
     If L > P Then Begin
          I := Pointer(Result);
          J := Pointer(S);
          For F := 1 To L - P Do Begin
               I^ := J^;
               Inc(I);
               Inc(J);
          End;
     End;
     If P > 0 Then
          FillChar(Result[L - P + 1], P, PadChar);
End;

Function Pad(Const S: AnsiString; Const PadChar: AnsiChar; Const Length: Integer;
     Const Cut: Boolean): AnsiString;
Var
     I                        : Integer;
Begin
     I := Length - System.Length(S);
     Result := DupChar(PadChar, I Div 2) + S + DupChar(PadChar, (I + 1) Div 2);
     If Cut Then
          SetLength(Result, Length);
End;



{                                                                              }
{ Delimited                                                                    }
{                                                                              }

Function StrBetweenChar(Const S: AnsiString;
     Const FirstDelim, SecondDelim: AnsiChar;
     Const FirstOptional: Boolean; Const SecondOptional: Boolean): AnsiString;
Var
     I, J                     : Integer;
Begin
     Result := '';
     I := PosChar(FirstDelim, S);
     If (I = 0) And Not FirstOptional Then
          exit;
     J := PosChar(SecondDelim, S, I + 1);
     If J = 0 Then
          If Not SecondOptional Then
               exit
          Else
               J := Length(S) + 1;
     Result := CopyRange(S, I + 1, J - 1);
End;

Function StrBetweenChar(Const S: AnsiString;
     Const FirstDelim, SecondDelim: CharSet;
     Const FirstOptional: Boolean; Const SecondOptional: Boolean): AnsiString;
Var
     I, J                     : Integer;
Begin
     Result := '';
     I := PosChar(FirstDelim, S);
     If (I = 0) And Not FirstOptional Then
          exit;
     J := PosChar(SecondDelim, S, I + 1);
     If J = 0 Then
          If Not SecondOptional Then
               exit
          Else
               J := Length(S) + 1;
     Result := CopyRange(S, I + 1, J - 1);
End;

Function StrBetween(Const S: AnsiString; Const FirstDelim: AnsiString;
     Const SecondDelim: CharSet; Const FirstOptional: Boolean;
     Const SecondOptional: Boolean;
     Const FirstDelimCaseSensitive: Boolean): AnsiString;
Var
     I, J                     : Integer;
Begin
     Result := '';
     I := PosStr(FirstDelim, S, 1, FirstDelimCaseSensitive);
     If (I = 0) And Not FirstOptional Then
          exit;
     J := PosChar(SecondDelim, S, I + 1);
     If J = 0 Then
          If Not SecondOptional Then
               exit
          Else
               J := Length(S) + 1;
     Result := CopyRange(S, I + 1, J - 1);
End;

Function StrBefore(Const S, D: AnsiString; Const Optional: Boolean;
     Const CaseSensitive: Boolean): AnsiString;
Var
     I                        : Integer;
Begin
     I := PosStr(D, S, 1, CaseSensitive);
     If I = 0 Then
          If Optional Then
               Result := S
          Else
               Result := ''
     Else
          Result := CopyLeft(S, I - 1);
End;

Function StrBeforeRev(Const S, D: AnsiString; Const Optional: Boolean;
     Const CaseSensitive: Boolean): AnsiString;
Var
     I                        : Integer;
Begin
     I := PosStrRev(D, S, 1, CaseSensitive);
     If I = 0 Then
          If Optional Then
               Result := S
          Else
               Result := ''
     Else
          Result := CopyLeft(S, I - 1);
End;

Function StrBeforeChar(Const S: AnsiString; Const D: CharSet;
     Const Optional: Boolean): AnsiString;
Var
     I                        : Integer;
Begin
     I := PosChar(D, S);
     If I = 0 Then
          If Optional Then
               Result := S
          Else
               Result := ''
     Else
          Result := CopyLeft(S, I - 1);
End;

Function StrBeforeCharRev(Const S: AnsiString; Const D: CharSet;
     Const Optional: Boolean): AnsiString;
Var
     I                        : Integer;
Begin
     I := PosCharRev(D, S);
     If I = 0 Then
          If Optional Then
               Result := S
          Else
               Result := ''
     Else
          Result := CopyLeft(S, I - 1);
End;

Function StrAfter(Const S, D: AnsiString): AnsiString;
Var
     I                        : Integer;
Begin
     I := PosStr(D, S);
     If I = 0 Then
          Result := ''
     Else
          Result := CopyFrom(S, I + 1);
End;

Function StrAfterChar(Const S: AnsiString; Const D: CharSet): AnsiString;
Var
     I                        : Integer;
Begin
     I := PosChar(D, S);
     If I = 0 Then
          Result := ''
     Else
          Result := CopyFrom(S, I + 1);
End;

Function StrRemoveCharDelimited(Var S: AnsiString;
     Const FirstDelim, SecondDelim: AnsiChar): AnsiString;
Var
     I, J                     : Integer;
Begin
     Result := '';
     I := PosChar(FirstDelim, S);
     If I = 0 Then
          exit;
     J := PosChar(SecondDelim, S, I + 1);
     If J = 0 Then
          exit;
     Result := CopyRange(S, I + 1, J - 1);
     Delete(S, I, J - I + 1);
End;



{                                                                              }
{ Count                                                                        }
{                                                                              }

Function StrCountChar(Const S: AnsiString; Const C: AnsiChar): Integer;
Var
     P                        : PAnsiChar;
     I                        : Integer;
Begin
     Result := 0;
     P := Pointer(S);
     For I := 1 To Length(S) Do Begin
          If P^ = C Then
               Inc(Result);
          Inc(P);
     End;
End;

Function StrCountChar(Const S: AnsiString; Const C: CharSet): Integer;
Var
     P                        : PAnsiChar;
     I                        : Integer;
Begin
     Result := 0;
     P := Pointer(S);
     For I := 1 To Length(S) Do Begin
          If P^ In C Then
               Inc(Result);
          Inc(P);
     End;
End;



{                                                                              }
{ Replace                                                                      }
{                                                                              }

Function StrReplaceChar(Const Find, Replace: AnsiChar;
     Const S: AnsiString): AnsiString;
Var
     P, Q                     : PAnsiChar;
     I, J                     : Integer;
Begin
     Result := S;
     I := PosChar(Find, S);
     If I = 0 Then
          exit;
     UniqueString(Result);
     Q := Pointer(Result);
     Inc(Q, I - 1);
     P := Pointer(S);
     Inc(P, I - 1);
     For J := I To Length(S) Do Begin
          If P^ = Find Then
               Q^ := Replace;
          Inc(P);
          Inc(Q);
     End;
End;

Function StrReplaceChar(Const Find: CharSet; Const Replace: AnsiChar;
     Const S: AnsiString): AnsiString;
Var
     P, Q                     : PAnsiChar;
     I, J                     : Integer;
Begin
     Result := S;
     I := PosChar(Find, S);
     If I = 0 Then
          exit;
     UniqueString(Result);
     Q := Pointer(Result);
     Inc(Q, I - 1);
     P := Pointer(S);
     Inc(P, I - 1);
     For J := I To Length(S) Do Begin
          If P^ In Find Then
               Q^ := Replace;
          Inc(P);
          Inc(Q);
     End;
End;

{ Quick AnsiString replace, adapted from a routine by Andrew N. Driazgov }

Function StrReplace(Const Find, Replace, S: AnsiString;
     Const CaseSensitive: Boolean): AnsiString;
Var
     P, PS                    : PAnsiChar;
     L, L1, L2, Cnt           : Integer;
     I, J, K, M               : Integer;
Begin
     L1 := Length(Find);
     If L1 = 0 Then Begin
          Result := S;
          exit;
     End;
     Cnt := 0;
     I := PosStr(Find, S, 1, CaseSensitive);
     While I <> 0 Do Begin
          Inc(I, L1);
          Asm
        PUSH I
          End;
          Inc(Cnt);
          I := PosStr(Find, S, I, CaseSensitive);
     End;
     If Cnt <> 0 Then Begin
          L := Length(S);
          L2 := Length(Replace);
          J := L + 1;
          Inc(L, (L2 - L1) * Cnt);
          If L <> 0 Then Begin
               SetString(Result, Nil, L);
               P := Pointer(Result);
               Inc(P, L);
               PS := Pointer(LongWord(S) - 1);
               If L2 <= 32 Then
                    For I := 0 To Cnt - 1 Do Begin
                         Asm
                  POP K
                         End;
                         M := J - K;
                         If M > 0 Then Begin
                              Dec(P, M);
                              MoveMem(PS[K], P^, M);
                         End;
                         Dec(P, L2);
                         If L2 > 0 Then
                              MoveMem(Pointer(Replace)^, P^, L2);
                         J := K - L1;
                    End
               Else
                    For I := 0 To Cnt - 1 Do Begin
                         Asm
                  POP K
                         End;
                         M := J - K;
                         If M > 0 Then Begin
                              Dec(P, M);
                              MoveMem(PS[K], P^, M);
                         End;
                         Dec(P, L2);
                         If L2 > 0 Then
                              MoveMem(Pointer(Replace)^, P^, L2);
                         J := K - L1;
                    End;
               Dec(J);
               If J > 0 Then
                    MoveMem(Pointer(S)^, Pointer(Result)^, J);
          End
          Else Begin
               For I := 0 To Cnt - 1 Do
                    Asm
              POP K
                    End;
               Result := '';
          End;
     End
     Else
          Result := S;
End;

Function StrReplace(Const Find: CharSet; Const Replace, S: AnsiString): AnsiString;
Var
     P, PS                    : PAnsiChar;
     L, L2, Cnt               : Integer;
     I, J, K, M               : Integer;
Begin
     Cnt := 0;
     I := PosChar(Find, S, 1);
     While I <> 0 Do Begin
          Inc(I);
          Asm
        PUSH I
          End;
          Inc(Cnt);
          I := PosChar(Find, S, I);
     End;
     If Cnt <> 0 Then Begin
          L := Length(S);
          L2 := Length(Replace);
          J := L + 1;
          Inc(L, (L2 - 1) * Cnt);
          If L <> 0 Then Begin
               SetString(Result, Nil, L);
               P := Pointer(Result);
               Inc(P, L);
               PS := Pointer(LongWord(S) - 1);
               If L2 <= 32 Then
                    For I := 0 To Cnt - 1 Do Begin
                         Asm
                  POP K
                         End;
                         M := J - K;
                         If M > 0 Then Begin
                              Dec(P, M);
                              MoveMem(PS[K], P^, M);
                         End;
                         Dec(P, L2);
                         If L2 > 0 Then
                              MoveMem(Pointer(Replace)^, P^, L2);
                         J := K - 1;
                    End
               Else
                    For I := 0 To Cnt - 1 Do Begin
                         Asm
                  POP K
                         End;
                         M := J - K;
                         If M > 0 Then Begin
                              Dec(P, M);
                              MoveMem(PS[K], P^, M);
                         End;
                         Dec(P, L2);
                         If L2 > 0 Then
                              MoveMem(Pointer(Replace)^, P^, L2);
                         J := K - 1;
                    End;
               Dec(J);
               If J > 0 Then
                    MoveMem(Pointer(S)^, Pointer(Result)^, J);
          End
          Else Begin
               For I := 0 To Cnt - 1 Do
                    Asm
              POP K
                    End;
               Result := '';
          End;
     End
     Else
          Result := S;
End;

Function StrRemoveDup(Const S: AnsiString; Const C: AnsiChar): AnsiString;
Var
     P, Q                     : PAnsiChar;
     D, E                     : AnsiChar;
     I, L, M                  : Integer;
     R                        : Boolean;
Begin
     L := Length(S);
     If L <= 1 Then Begin
          Result := S;
          exit;
     End;
     // Check for duplicate
     P := Pointer(S);
     D := P^;
     Inc(P);
     R := False;
     For I := 2 To L Do
          If (D = C) And (P^ = C) Then Begin
               R := True;
               break;
          End
          Else
               Inc(P);
     If Not R Then Begin
          Result := S;
          exit;
     End;
     // Remove duplicates
     Result := S;
     UniqueString(Result);
     P := Pointer(S);
     Q := Pointer(Result);
     D := P^;
     Q^ := D;
     Inc(P);
     Inc(Q);
     M := 1;
     For I := 2 To L Do Begin
          E := P^;
          If (D <> C) Or (E <> C) Then Begin
               D := E;
               Q^ := E;
               Inc(M);
               Inc(Q);
          End;
          Inc(P);
     End;
     If M < L Then
          SetLength(Result, M);
End;

Function StrRemoveChar(Const S: AnsiString; Const C: AnsiChar): AnsiString;
Var
     P, Q                     : PAnsiChar;
     I, L, M                  : Integer;
Begin
     L := Length(S);
     If L = 0 Then Begin
          Result := '';
          exit;
     End;
     M := 0;
     P := Pointer(S);
     For I := 1 To L Do Begin
          If P^ = C Then
               Inc(M);
          Inc(P);
     End;
     If M = 0 Then Begin
          Result := S;
          exit;
     End;
     SetLength(Result, L - M);
     Q := Pointer(Result);
     P := Pointer(S);
     For I := 1 To L Do Begin
          If P^ <> C Then Begin
               Q^ := P^;
               Inc(Q);
          End;
          Inc(P);
     End;
End;

Function StrRemoveChar(Const S: AnsiString; Const C: CharSet): AnsiString;
Var
     P, Q                     : PAnsiChar;
     I, L, M                  : Integer;
Begin
     L := Length(S);
     If L = 0 Then Begin
          Result := '';
          exit;
     End;
     M := 0;
     P := Pointer(S);
     For I := 1 To L Do Begin
          If P^ In C Then
               Inc(M);
          Inc(P);
     End;
     If M = 0 Then Begin
          Result := S;
          exit;
     End;
     SetLength(Result, L - M);
     Q := Pointer(Result);
     P := Pointer(S);
     For I := 1 To L Do Begin
          If Not (P^ In C) Then Begin
               Q^ := P^;
               Inc(Q);
          End;
          Inc(P);
     End;
End;



{                                                                              }
{ Split                                                                        }
{                                                                              }

Function StrSplitAt(Const S: AnsiString; Const C: AnsiString;
     Var Left, Right: AnsiString; Const CaseSensitive: Boolean;
     Const Optional: Boolean): Boolean;
Var
     I                        : Integer;
     T                        : AnsiString;
Begin
     I := PosStr(C, S, 1, CaseSensitive);
     Result := I > 0;
     If Result Then Begin
          T := S;
          Left := Copy(T, 1, I - 1);
          Right := CopyFrom(T, I + Length(C));
     End
     Else Begin
          If Optional Then
               Left := S
          Else
               Left := '';
          Right := '';
     End;
End;

Function StrSplitAtChar(Const S: AnsiString; Const C: AnsiChar;
     Var Left, Right: AnsiString; Const Optional: Boolean): Boolean;
Var
     I                        : Integer;
     T                        : AnsiString;
Begin
     I := PosChar(C, S);
     Result := I > 0;
     If Result Then Begin
          T := S;
          Left := Copy(T, 1, I - 1);
          Right := CopyFrom(T, I + 1);
     End
     Else Begin
          If Optional Then
               Left := S
          Else
               Left := '';
          Right := '';
     End;
End;

Function StrSplitAtChar(Const S: AnsiString; Const C: CharSet;
     Var Left, Right: AnsiString; Const Optional: Boolean): Boolean;
Var
     I                        : Integer;
     T                        : AnsiString;
Begin
     I := PosChar(C, S);
     Result := I > 0;
     If Result Then Begin
          T := S;
          Left := Copy(T, 1, I - 1);
          Right := CopyFrom(T, I + 1);
     End
     Else Begin
          If Optional Then
               Left := S
          Else
               Left := '';
          Right := '';
     End;
End;

Function StrSplit(Const S, D: AnsiString): StringArray;
Var
     I, J, L, M               : Integer;
Begin
     // Check valid parameters
     If S = '' Then Begin
          Result := Nil;
          exit;
     End;
     M := Length(D);
     If M = 0 Then Begin
          SetLength(Result, 1);
          Result[0] := S;
          exit;
     End;
     // Count
     L := 0;
     I := 1;
     Repeat
          I := PosStr(D, S, I, True);
          If I = 0 Then
               break;
          Inc(L);
          Inc(I, M);
     Until False;
     SetLength(Result, L + 1);
     If L = 0 Then Begin
          // No split
          Result[0] := S;
          exit;
     End;
     // Split
     L := 0;
     I := 1;
     Repeat
          J := PosStr(D, S, I, True);
          If J = 0 Then Begin
               Result[L] := CopyFrom(S, I);
               break;
          End;
          Result[L] := CopyRange(S, I, J - 1);
          Inc(L);
          I := J + M;
     Until False;
End;

Function StrSplitChar(Const S: AnsiString; Const D: AnsiChar): StringArray;
Var
     I, J, L                  : Integer;
Begin
     // Check valid parameters
     If S = '' Then Begin
          Result := Nil;
          exit;
     End;
     // Count
     L := 0;
     I := 1;
     Repeat
          I := PosChar(D, S, I);
          If I = 0 Then
               break;
          Inc(L);
          Inc(I);
     Until False;
     SetLength(Result, L + 1);
     If L = 0 Then Begin
          // No split
          Result[0] := S;
          exit;
     End;
     // Split
     L := 0;
     I := 1;
     Repeat
          J := PosChar(D, S, I);
          If J = 0 Then Begin
               Result[L] := CopyFrom(S, I);
               break;
          End;
          Result[L] := CopyRange(S, I, J - 1);
          Inc(L);
          I := J + 1;
     Until False;
End;

Function StrSplitChar(Const S: AnsiString; Const D: CharSet): StringArray;
Var
     I, J, L                  : Integer;
Begin
     // Check valid parameters
     If S = '' Then Begin
          Result := Nil;
          exit;
     End;
     // Count
     L := 0;
     I := 1;
     Repeat
          I := PosChar(D, S, I);
          If I = 0 Then
               break;
          Inc(L);
          Inc(I);
     Until False;
     SetLength(Result, L + 1);
     If L = 0 Then Begin
          // No split
          Result[0] := S;
          exit;
     End;
     // Split
     L := 0;
     I := 1;
     Repeat
          J := PosChar(D, S, I);
          If J = 0 Then Begin
               Result[L] := CopyFrom(S, I);
               break;
          End;
          Result[L] := CopyRange(S, I, J - 1);
          Inc(L);
          I := J + 1;
     Until False;
End;

Function StrSplitWords(Const S: AnsiString; Const C: CharSet): StringArray;
Var
     P, Q                     : PAnsiChar;
     L, M                     : Integer;
     T                        : AnsiString;
Begin
     Result := Nil;
     L := Length(S);
     P := Pointer(S);
     Q := P;
     M := 0;
     While L > 0 Do
          If P^ In C Then Begin
               Inc(P);
               Dec(L);
               Inc(M);
          End
          Else Begin
               If M > 0 Then Begin
                    SetLength(T, M);
                    MoveMem(Q^, Pointer(T)^, M);
                    Append(Result, T);
               End;
               M := 0;
               Inc(P);
               Dec(L);
               Q := P;
          End;
     If M > 0 Then Begin
          SetLength(T, M);
          MoveMem(Q^, Pointer(T)^, M);
          Append(Result, T);
     End;
End;

Function StrJoin(Const S: Array Of AnsiString; Const D: AnsiString): AnsiString;
Var
     I, L, M, C               : Integer;
     P                        : PAnsiChar;
     T                        : AnsiString;
Begin
     L := Length(S);
     If L = 0 Then Begin
          Result := '';
          exit;
     End;
     M := Length(D);
     SetLength(Result, StringsTotalLength(S) + (L - 1) * M);
     P := Pointer(Result);
     For I := 0 To L - 1 Do Begin
          If (I > 0) And (M > 0) Then Begin
               MoveMem(Pointer(D)^, P^, M);
               Inc(P, M);
          End;
          T := S[I];
          C := Length(T);
          If C > 0 Then Begin
               MoveMem(Pointer(T)^, P^, C);
               Inc(P, C);
          End;
     End;
End;

Function StrJoinChar(Const S: Array Of AnsiString; Const D: AnsiChar): AnsiString;
Var
     I, L, C                  : Integer;
     P                        : PAnsiChar;
     T                        : AnsiString;
Begin
     L := Length(S);
     If L = 0 Then Begin
          Result := '';
          exit;
     End;
     SetLength(Result, StringsTotalLength(S) + L - 1);
     P := Pointer(Result);
     For I := 0 To L - 1 Do Begin
          If I > 0 Then Begin
               P^ := D;
               Inc(P);
          End;
          T := S[I];
          C := Length(T);
          If C > 0 Then Begin
               MoveMem(Pointer(T)^, P^, C);
               Inc(P, C);
          End;
     End;
End;



{                                                                              }
{ Quoting                                                                      }
{                                                                              }

Function StrHasSurroundingQuotes(Const S: AnsiString;
     Const Quotes: CharSet): Boolean;
Var
     P                        : PAnsiChar;
     Q                        : AnsiChar;
     L                        : Integer;
Begin
     Result := False;
     L := Length(S);
     If L >= 2 Then Begin
          P := Pointer(S);
          Q := P^;
          If Q In Quotes Then Begin
               Inc(P, L - 1);
               If P^ = Q Then
                    Result := True;
          End;
     End;
End;

Function StrRemoveSurroundingQuotes(Const S: AnsiString;
     Const Quotes: CharSet): AnsiString;
Begin
     If StrHasSurroundingQuotes(S, Quotes) Then
          Result := Copy(S, 2, Length(S) - 2)
     Else
          Result := S;
End;

Function StrQuote(Const S: AnsiString; Const Quote: AnsiChar): AnsiString;
Begin
     Result := Quote + StrReplace(Quote, Quote + Quote, S) + Quote;
End;

Function StrUnquote(Const S: AnsiString): AnsiString;
Var
     Quote                    : AnsiChar;
Begin
     If Not StrHasSurroundingQuotes(S, csQuotes) Then Begin
          Result := S;
          exit;
     End;
     Quote := PAnsiChar(Pointer(S))^;
     Result := StrRemoveSurroundingQuotes(S, csQuotes);
     Result := StrReplace(Quote + Quote, Quote, Result);
End;

Function StrMatchQuotedStr(Const S: AnsiString; Const ValidQuotes: CharSet;
     Const Index: Integer): Integer;
Var
     Quote                    : AnsiChar;
     I, L                     : Integer;
     R                        : Boolean;
Begin
     L := Length(S);
     If (Index < 1) Or (L < Index + 1) Or Not (S[Index] In ValidQuotes) Then Begin
          Result := 0;
          exit;
     End;
     Quote := S[Index];
     I := Index + 1;
     R := False;
     Repeat
          I := PosChar(Quote, S, I);
          If I = 0 Then                 {// no closing quote} Begin
               Result := 0;
               exit;
          End
          Else If I = L Then            // closing quote is last character
               R := True
          Else If S[I + 1] <> Quote Then // not double quoted
               R := True
          Else
               Inc(I, 2);
     Until R;
     Result := I - Index + 1;
End;

Function StrIsQuotedStr(Const S: AnsiString; Const ValidQuotes: CharSet): Boolean;
Var
     L                        : Integer;
Begin
     L := Length(S);
     If (L < 2) Or (S[1] <> S[L]) Or Not (S[1] In ValidQuotes) Then
          Result := False
     Else
          Result := StrMatchQuotedStr(S, ValidQuotes) = L;
End;

Function StrFindClosingQuote(Const S: AnsiString; Const OpenQuotePos: Integer): Integer;
Var
     I                        : Integer;
     OpenQuote                : AnsiChar;
     R                        : Boolean;
Begin
     If (OpenQuotePos <= 0) Or (OpenQuotePos > Length(S)) Then Begin
          Result := 0;
          exit;
     End;
     I := OpenQuotePos;
     OpenQuote := S[I];
     Repeat
          I := PosChar(OpenQuote, S, I + 1);
          If I = 0 Then Begin
               Result := 0;
               exit;
          End;
          R := (I = Length(S)) Or (S[I + 1] <> OpenQuote);
          If Not R Then
               Inc(I);
     Until R;
     Result := I;
End;



{                                                                              }
{ Escaping                                                                     }
{                                                                              }

Function StrHexEscape(Const S: AnsiString; Const C: CharSet;
     Const EscPrefix: AnsiString; Const EscSuffix: AnsiString;
     Const UpperHex: Boolean; Const TwoDigitHex: Boolean): AnsiString;
Var
     I, J                     : Integer;
     HexStr                   : AnsiString;
Begin
     Result := '';
     J := 1;
     I := PosChar(C, S);
     While I > 0 Do Begin
          If TwoDigitHex Then
               HexStr := LongWordToHex(Ord(S[I]), 2)
          Else
               HexStr := LongWordToHex(Ord(S[I]), 1);
          If UpperHex Then
               ConvertUpper(HexStr)
          Else
               ConvertLower(HexStr);
          Result := Result + CopyRange(S, J, I - 1) +
               EscPrefix + HexStr + EscSuffix;
          J := I + 1;
          I := PosChar(C, S, J);
     End;
     If J = 1 Then
          Result := S
     Else
          Result := Result + CopyFrom(S, J);
End;

Function StrHexUnescape(Const S: AnsiString; Const EscPrefix: AnsiString;
     Const CaseSensitive: Boolean): AnsiString;
Var
     I, J, L, M               : Integer;
     V                        : Byte;
Begin
     Result := '';
     L := Length(S);
     If L = 0 Then
          exit;
     M := Length(EscPrefix);
     If M = 0 Then
          exit;
     // Replace
     J := 1;
     Repeat
          I := PosStr(EscPrefix, S, J, CaseSensitive);
          If I > 0 Then Begin
               Result := Result + CopyRange(S, J, I - 1);
               Inc(I, M);
               If (I <= L) And IsHexChar(S[I]) Then Begin
                    If (I < L) And IsHexChar(S[I + 1]) Then Begin
                         V := HexCharValue(S[I]) * 16 + HexCharValue(S[I + 1]);
                         Inc(I, 2);
                    End
                    Else Begin
                         V := HexCharValue(S[I]);
                         Inc(I);
                    End;
                    Result := Result + AnsiChar(V);
               End;
               J := I;
          End;
     Until I = 0;
     If (I = 0) And (J = 0) Then
          Result := S
     Else
          Result := Result + CopyFrom(S, J);
End;

Function StrCharEscape(Const S: AnsiString; Const C: Array Of AnsiChar;
     Const EscPrefix: AnsiString; Const EscSeq: Array Of AnsiString): AnsiString;
Var
     I, J, L                  : Integer;
     F                        : CharSet;
     T                        : AnsiChar;
     Lookup                   : Array[AnsiChar] Of Integer;
Begin
     L := Length(C);
     If L = 0 Then Begin
          Result := S;
          exit;
     End;
     If L <> Length(EscSeq) Then
          Raise EInvalidArgument.Create('StrCharEscape: Invalid parameters');
     // Initialize lookup
     FillChar(Lookup, Sizeof(Lookup), #0);
     F := [];
     For I := 0 To Length(C) - 1 Do Begin
          T := C[I];
          Include(F, T);
          Lookup[T] := I;
     End;
     // Replace
     Result := '';
     J := 1;
     I := PosChar(F, S);
     While I > 0 Do Begin
          Result := Result + CopyRange(S, J, I - 1) +
               EscPrefix + EscSeq[Lookup[S[I]]];
          J := I + 1;
          I := PosChar(F, S, J);
     End;
     If J = 1 Then
          Result := S
     Else
          Result := Result + CopyFrom(S, J);
End;

Function StrCharUnescape(Const S: AnsiString; Const EscPrefix: AnsiString;
     Const C: Array Of AnsiChar; Const Replace: Array Of AnsiString;
     Const PrefixCaseSensitive: Boolean; Const
     AlwaysDropPrefix: Boolean): AnsiString;
Var
     I, J, L                  : Integer;
     F, G, M                  : Integer;
     D                        : AnsiChar;
Begin
     If High(C) <> High(Replace) Then
          Raise EInvalidArgument.Create('StrCharUnescape: Invalid parameters');
     L := Length(EscPrefix);
     M := Length(S);
     If (L = 0) Or (M <= L) Then Begin
          Result := S;
          exit;
     End;
     // Replace
     Result := '';
     J := 1;
     Repeat
          I := PosStr(EscPrefix, S, J, PrefixCaseSensitive);
          If I > 0 Then Begin
               G := -1;
               If I < Length(S) Then Begin
                    D := S[I + L];
                    For F := 0 To High(C) Do
                         If C[F] = D Then Begin
                              G := F;
                              break;
                         End;
               End;
               Result := Result + CopyRange(S, J, I - 1);
               If G >= 0 Then
                    Result := Result + Replace[G]
               Else If Not AlwaysDropPrefix Then
                    Result := Result + EscPrefix;
               J := I + L + 1;
          End;
     Until I = 0;
     If (I = 0) And (J = 0) Then
          Result := S
     Else
          Result := Result + CopyFrom(S, J);
End;

Function StrCStyleEscape(Const S: AnsiString): AnsiString;
Begin
     Result := StrCharEscape(S,
          [asciiCR, asciiLF, asciiNULL, asciiBEL, asciiBS, asciiESC, asciiHT,
          asciiFF, asciiVT, '\'], '\',
               ['n', 'l', '0', 'a', 'b', 'e', 't',
          'f', 'v', '\']);
End;

Function StrCStyleUnescape(Const S: AnsiString): AnsiString;
Begin
     Result := StrCharUnescape(S, '\',
          ['n', 'l', '0', 'a', 'b', 'e', 't',
          'f', 'v', '\', '''', '"', '?'],
               [asciiCR, asciiLF, asciiNULL, asciiBEL, asciiBS, asciiESC, asciiHT,
          asciiFF, asciiVT, '\', '''', '"', '?'], True, False);
     Result := StrHexUnescape(Result, '\x', True);
End;



{                                                                              }
{ Prefix and Suffix                                                            }
{                                                                              }

Function StrInclPrefix(Const S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean): AnsiString;
Begin
     If Not StrMatchLeft(Prefix, S, CaseSensitive) Then
          Result := Prefix + S
     Else
          Result := S;
End;

Function StrInclSuffix(Const S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean): AnsiString;
Begin
     If Not StrMatchRight(Suffix, S, CaseSensitive) Then
          Result := S + Suffix
     Else
          Result := S;
End;

Function StrExclPrefix(Const S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean): AnsiString;
Begin
     If StrMatchLeft(Prefix, S, CaseSensitive) Then
          Result := CopyFrom(S, Length(Prefix) + 1)
     Else
          Result := S;
End;

Function StrExclSuffix(Const S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean): AnsiString;
Begin
     If StrMatchRight(Suffix, S, CaseSensitive) Then
          Result := Copy(S, 1, Length(S) - Length(Suffix))
     Else
          Result := S;
End;

Procedure StrEnsurePrefix(Var S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean);
Var
     L, M                     : Integer;
     P                        : PAnsiChar;
Begin
     If (Prefix <> '') And Not StrMatchLeft(Prefix, S, CaseSensitive) Then Begin
          L := Length(S);
          M := Length(Prefix);
          SetLength(S, L + M);
          If L > 0 Then Begin
               P := Pointer(S);
               Inc(P, M);
               MoveMem(Pointer(S)^, P^, L);
          End;
          MoveMem(Pointer(Prefix)^, Pointer(S)^, M);
     End;
End;

Procedure StrEnsureSuffix(Var S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean);
Var
     L, M                     : Integer;
     P                        : PAnsiChar;
Begin
     If (Suffix <> '') And Not StrMatchRight(Suffix, S, CaseSensitive) Then Begin
          L := Length(S);
          M := Length(Suffix);
          SetLength(S, L + M);
          P := Pointer(S);
          Inc(P, L);
          MoveMem(Pointer(Suffix)^, P^, M);
     End;
End;

Procedure StrEnsureNoPrefix(Var S: AnsiString; Const Prefix: AnsiString;
     Const CaseSensitive: Boolean);
Var
     L, M                     : Integer;
     P                        : PAnsiChar;
Begin
     If StrMatchLeft(Prefix, S, CaseSensitive) Then Begin
          L := Length(S);
          M := Length(Prefix);
          P := Pointer(S);
          Inc(P, M);
          MoveMem(P^, Pointer(S)^, L - M);
          SetLength(S, L - M);
     End;
End;

Procedure StrEnsureNoSuffix(Var S: AnsiString; Const Suffix: AnsiString;
     Const CaseSensitive: Boolean);
Begin
     If StrMatchRight(Suffix, S, CaseSensitive) Then
          SetLength(S, Length(S) - Length(Suffix));
End;



{                                                                              }
{ Skip                                                                         }
{                                                                              }

Function SkipChar(Var P: PAnsiChar; Const C: AnsiChar): Boolean;
Var
     Q                        : PAnsiChar;
     D                        : AnsiChar;
Begin
     Assert(C <> #0, 'Invalid parameter');
     Q := P;
     If Not Assigned(Q) Then
          Result := False
     Else Begin
          D := Q^;
          If D = #0 Then
               Result := False
          Else If D = C Then Begin
               Inc(P);
               Result := True;
          End
          Else
               Result := False;
     End;
End;

Function SkipChar(Var P: PAnsiChar; Const C: CharSet): Boolean;
Var
     Q                        : PAnsiChar;
     D                        : AnsiChar;
Begin
     Q := P;
     If Not Assigned(Q) Then
          Result := False
     Else Begin
          D := Q^;
          If D = #0 Then
               Result := False
          Else If D In C Then Begin
               Inc(P);
               Result := True;
          End
          Else
               Result := False;
     End;
End;

Function SkipAll(Var P: PAnsiChar; Const C: AnsiChar): Integer;
Var
     Q                        : PAnsiChar;
Begin
     Assert(C <> #0, 'Invalid parameter');
     Result := 0;
     Q := P;
     If Not Assigned(Q) Then
          exit;
     While (Q^ <> #0) And (Q^ = C) Do Begin
          Inc(Q);
          Inc(Result);
     End;
     P := Q;
End;

Function SkipAll(Var P: PAnsiChar; Const C: CharSet): Integer;
Var
     Q                        : PAnsiChar;
Begin
     Result := 0;
     Q := P;
     If Not Assigned(Q) Then
          exit;
     While (Q^ <> #0) And (Q^ In C) Do Begin
          Inc(Q);
          Inc(Result);
     End;
     P := Q;
End;

Function SkipToChar(Var P: PAnsiChar; Const C: CharSet): Integer;
Var
     Q                        : PAnsiChar;
Begin
     Result := 0;
     Q := P;
     If Not Assigned(Q) Then
          exit;
     While (Q^ <> #0) And Not (Q^ In C) Do Begin
          Inc(Q);
          Inc(Result);
     End;
     P := Q;
End;

Function SkipToStr(Var P: PAnsiChar; Const S: AnsiString; Const CaseSensitive: Boolean): Integer;
Var
     Q                        : PAnsiChar;
Begin
     Result := 0;
     Q := P;
     If Not Assigned(Q) Then
          exit;
     While (Q^ <> #0) And Not StrPMatchStr(Q, S, CaseSensitive) Do Begin
          Inc(Q);
          Inc(Result);
     End;
     P := Q;
End;

Function Skip2CharSeq(Var P: PAnsiChar; Const S1, S2: CharSet): Boolean;
Var
     Q                        : PAnsiChar;
     C                        : AnsiChar;
Begin
     Q := P;
     If Not Assigned(Q) Then Begin
          Result := False;
          exit;
     End;
     C := Q^;
     If (C = #0) Or Not (C In S1) Then Begin
          Result := False;
          exit;
     End;
     Inc(Q);
     C := Q^;
     If (C = #0) Or Not (C In S2) Then
          Result := False
     Else Begin
          Inc(P, 2);
          Result := True;
     End;
End;

Function Skip3CharSeq(Var P: PAnsiChar; Const S1, S2, S3: CharSet): Boolean;
Var
     Q                        : PAnsiChar;
     C                        : AnsiChar;
Begin
     Q := P;
     If Not Assigned(Q) Then Begin
          Result := False;
          exit;
     End;
     C := Q^;
     If (C = #0) Or Not (C In S1) Then Begin
          Result := False;
          exit;
     End;
     Inc(Q);
     C := Q^;
     If (C = #0) Or Not (C In S2) Then Begin
          Result := False;
          exit;
     End;
     Inc(Q);
     C := Q^;
     If (C = #0) Or Not (C In S3) Then
          Result := False
     Else Begin
          Inc(P, 3);
          Result := True;
     End;
End;

Function SkipStr(Var P: PAnsiChar; Const S: AnsiString; Const CaseSensitive: Boolean): Boolean;
Begin
     Result := StrPMatchStr(P, S, CaseSensitive);
     If Result Then
          Inc(P, Length(S));
End;



{                                                                              }
{ Extract                                                                      }
{                                                                              }

Function ExtractAll(Var P: PAnsiChar; Const C: AnsiChar): AnsiString;
Var
     Q                        : PAnsiChar;
     I                        : Integer;
Begin
     Q := P;
     I := SkipAll(P, C);
     If I = 0 Then Begin
          Result := '';
          exit;
     End;
     SetLength(Result, I);
     MoveMem(Q^, Pointer(Result)^, I);
End;

Function ExtractAll(Var P: PAnsiChar; Const C: CharSet): AnsiString;
Var
     Q                        : PAnsiChar;
     I                        : Integer;
Begin
     Q := P;
     I := SkipAll(P, C);
     If I = 0 Then Begin
          Result := '';
          exit;
     End;
     SetLength(Result, I);
     MoveMem(Q^, Pointer(Result)^, I);
End;

Function ExtractTo(Var P: PAnsiChar; Const C: CharSet): AnsiString;
Var
     Q                        : PAnsiChar;
     L                        : Integer;
Begin
     L := 0;
     Q := P;
     While (P^ <> #0) And Not (P^ In C) Do Begin
          Inc(P);
          Inc(L);
     End;
     SetLength(Result, L);
     MoveMem(Q^, Pointer(Result)^, L);
End;

Function ExtractToStr(Var P: PAnsiChar; Const S: AnsiString;
     Const CaseSensitive: Boolean): AnsiString;
Var
     Q                        : PAnsiChar;
     L                        : Integer;
Begin
     Q := P;
     L := 0;
     While (P^ <> #0) And Not StrPMatchStr(P, S, CaseSensitive) Do Begin
          Inc(P);
          Inc(L);
     End;
     SetLength(Result, L);
     If L = 0 Then
          exit;
     MoveMem(Q^, Pointer(Result)^, L);
End;

Function ExtractQuoted(Var P: PAnsiChar): AnsiString;
Var
     Q                        : PAnsiChar;
     C, D                     : AnsiChar;
     L                        : Integer;
Begin
     C := P^;
     If Not (C In ['"', '''']) Then Begin
          Result := '';
          exit;
     End;
     Inc(P);
     Q := P;
     L := 0;
     Repeat
          D := P^;
          If D = #0 Then
               break;
          If D = C Then Begin
               Inc(P);
               break;
          End;
          Inc(P);
          Inc(L);
     Until False;
     If L > 0 Then Begin
          SetLength(Result, L);
          Move(Q^, Pointer(Result)^, L);
     End
     Else
          Result := '';
End;



{                                                                              }
{ Type conversion                                                              }
{                                                                              }

Function StrToFloatDef(Const S: AnsiString; Const Default: Extended): Extended;
Begin
     Try
          Result := StrToFloat(String(S));
     Except
          Result := Default;
     End;
End;

Function BooleanToStr(Const B: Boolean): AnsiString;
Begin
     If B Then
          Result := 'True'
     Else
          Result := 'False';
End;

Function StrToBoolean(Const S: AnsiString): Boolean;
Begin
     Result := StrEqualNoCase(S, 'True');
End;

Function VarRecToString(Const V: TVarRec; Const QuoteStrings: Boolean): AnsiString;
Begin
     With V Do
          Case VType Of
               vtInteger: Result := AnsiString(IntToStr(VInteger));
               vtInt64: Result := AnsiString(IntToStr(VInt64^));
               vtChar: Result := VChar;
               vtString: Result := VString^;
               vtPChar: Result := VPChar;
               vtAnsiString: Result := AnsiString(VAnsiString);
               vtExtended: Result := AnsiString(FloatToStr(VExtended^));
               vtBoolean: Result := BooleanToStr(VBoolean);
               vtObject: Result := ObjectToStr(VObject);
               vtClass: Result := ClassToStr(VClass);
               vtCurrency: Result := AnsiString(CurrToStr(VCurrency^));
               vtVariant: Result := AnsiString(VVariant^);
          End;
     If QuoteStrings And (V.VType In [vtChar, vtString, vtPChar, vtAnsiString]) Then
          Result := StrQuote(Result);
End;



{                                                                              }
{ Abbreviated regular expression matcher                                       }
{                                                                              }

Function MatchQuantSeq(Var MatchPos: Integer; Const MatchSeq: Array Of CharSet;
     Const Quant: Array Of TMatchQuantifier; Const S: AnsiString;
     Const MatchOptions: TMatchQuantSeqOptions;
     Const StartIndex: Integer; Const StopIndex: Integer): Boolean;

Var
     Stop                     : Integer;
     Deterministic            : Boolean;
     NonGreedy                : Boolean;

     Function MatchAt(MPos, SPos: Integer; Var MatchPos: Integer): Boolean;

          Function MatchAndAdvance: Boolean;
          Var
               I              : Integer;
          Begin
               I := SPos;
               Result := S[I] In MatchSeq[MPos];
               If Result Then Begin
                    MatchPos := I;
                    Inc(SPos);
               End;
          End;

          Function MatchAndSetResult(Var Res: Boolean): Boolean;
          Begin
               Result := MatchAndAdvance;
               Res := Result;
               If Not Result Then
                    MatchPos := 0;
          End;

          Function MatchAny: Boolean;
          Var
               I, L           : Integer;
               P              : PAnsiChar;
          Begin
               L := Stop;
               If Deterministic Then Begin
                    While (SPos <= L) And MatchAndAdvance Do
                         ;
                    Result := False;
               End
               Else If NonGreedy Then
                    Repeat
                         Result := MatchAt(MPos + 1, SPos, MatchPos);
                         If Result Or Not MatchAndAdvance Then
                              exit;
                    Until SPos > L
               Else Begin
                    I := SPos;
                    P := Pointer(S);
                    Inc(P, I - 1);
                    While (I <= L) And (P^ In MatchSeq[MPos]) Do Begin
                         Inc(I);
                         Inc(P);
                    End;
                    Repeat
                         MatchPos := I - 1;
                         Result := MatchAt(MPos + 1, I, MatchPos);
                         If Result Then
                              exit;
                         Dec(I);
                    Until SPos > I;
               End;
          End;

     Var
          Q                   : TMatchQuantifier;
          L, M                : Integer;
     Begin
          L := Length(MatchSeq);
          M := Stop;
          While (MPos < L) And (SPos <= M) Do Begin
               Q := Quant[MPos];
               If Q In [mqOnce, mqLeastOnce] Then
                    If Not MatchAndSetResult(Result) Then
                         exit;
               If (Q = mqAny) Or ((Q = mqLeastOnce) And (SPos <= M)) Then Begin
                    Result := MatchAny;
                    If Result Then
                         exit;
               End
               Else If Q = mqOptional Then
                    If Deterministic Then
                         MatchAndAdvance
                    Else Begin
                         If NonGreedy Then Begin
                              Result := MatchAt(MPos + 1, SPos, MatchPos);
                              If Result Or Not MatchAndSetResult(Result) Then
                                   exit;
                         End
                         Else Begin
                              Result := (MatchAndAdvance And MatchAt(MPos + 1, SPos, MatchPos)) Or
                                   MatchAt(MPos + 1, SPos, MatchPos);
                              exit;
                         End;
                    End;
               Inc(MPos);
          End;
          While (MPos < L) And (Quant[MPos] In [mqAny, mqOptional]) Do
               Inc(MPos);
          Result := MPos = L;
          If Not Result Then
               MatchPos := 0;
     End;

Begin
     Assert(Length(MatchSeq) = Length(Quant), 'MatchSeq and Quant not of equal length');
     If StopIndex < 0 Then
          Stop := Length(S)
     Else
          Stop := MinI(StopIndex, Length(S));
     MatchPos := 0;
     If (Length(MatchSeq) = 0) Or (StartIndex > Stop) Or (StartIndex <= 0) Then Begin
          Result := False;
          exit;
     End;
     NonGreedy := moNonGreedy In MatchOptions;
     Deterministic := moDeterministic In MatchOptions;
     Result := MatchAt(0, StartIndex, MatchPos);
End;



{                                                                              }
{ MatchPattern                                                                 }
{   Based on MatchPattern from a Delphi 3000 article by Paramjeet Reen         }
{   (http://www.delphi3000.com/articles/article_1561.asp).                     }
{                                                                              }

Function MatchPattern(M, S: PAnsiChar): Boolean;

     Function EscapedChar(Const C: AnsiChar): AnsiChar;
     Begin
          Case C Of
               'b': Result := asciiBS;
               'e': Result := asciiESC;
               'f': Result := asciiFF;
               'n': Result := asciiLF;
               'r': Result := asciiCR;
               't': Result := asciiHT;
               'v': Result := asciiVT;
          Else
               Result := C;
          End;
     End;

Var
     A, C, D                  : AnsiChar;
     N                        : Boolean;
Begin
     Repeat
          Case M^ Of
               #0:                      {// end of pattern} Begin
                         Result := S^ = #0;
                         exit;
                    End;
               '?':                     // match one
                    If S^ = #0 Then Begin
                         Result := False;
                         exit;
                    End
                    Else Begin
                         Inc(M);
                         Inc(S);
                    End;
               '*': Begin
                         Inc(M);
                         If M^ = #0 Then {// always match at end of mask} Begin
                              Result := True;
                              exit;
                         End
                         Else
                              While S^ <> #0 Do
                                   If MatchPattern(M, S) Then Begin
                                        Result := True;
                                        Exit;
                                   End
                                   Else
                                        Inc(S);
                    End;
               '[':                     {// character class} Begin
                         A := S^;
                         Inc(M);
                         C := M^;
                         N := C = '^';
                         Result := N;
                         While C <> ']' Do Begin
                              If C = #0 Then Begin
                                   Result := False;
                                   exit;
                              End;
                              Inc(M);
                              If C = '\' Then {// escaped character} Begin
                                   C := M^;
                                   If C = #0 Then Begin
                                        Result := False;
                                        exit;
                                   End;
                                   C := EscapedChar(C);
                                   Inc(M);
                              End;
                              D := M^;
                              If D = '-' Then {// match range} Begin
                                   Inc(M);
                                   D := M^;
                                   If D = #0 Then Begin
                                        Result := False;
                                        exit;
                                   End;
                                   If D = '\' Then {// escaped character} Begin
                                        Inc(M);
                                        D := M^;
                                        If D = #0 Then Begin
                                             Result := False;
                                             exit;
                                        End;
                                        D := EscapedChar(D);
                                        Inc(M);
                                   End;
                                   If (A >= C) And (A <= D) Then Begin
                                        Result := Not N;
                                        break;
                                   End;
                                   Inc(M);
                                   C := M^;
                              End
                              Else Begin // match single character
                                   If A = C Then Begin
                                        Result := Not N;
                                        break;
                                   End;
                                   C := D;
                              End;
                         End;
                         If Not Result Then
                              exit;
                         Inc(S);
                         // Locate closing bracket
                         While M^ <> ']' Do
                              If M^ = #0 Then Begin
                                   Result := False;
                                   exit;
                              End
                              Else
                                   Inc(M);
                         Inc(M);
                    End;
          Else                          // single character match
               If M^ <> S^ Then Begin
                    Result := False;
                    exit;
               End
               Else Begin
                    Inc(M);
                    Inc(S);
               End;
          End;
     Until False;
End;



{                                                                              }
{ MatchFileMask                                                                }
{                                                                              }

Function MatchFileMask(Const Mask, Key: AnsiString; Const CaseSensitive: Boolean): Boolean;
Var
     ML, KL                   : Integer;

     Function MatchAt(MaskPos, KeyPos: Integer): Boolean;
     Begin
          While (MaskPos <= ML) And (KeyPos <= KL) Do
               Case Mask[MaskPos] Of
                    '?': Begin
                              Inc(MaskPos);
                              Inc(KeyPos);
                         End;
                    '*': Begin
                              While (MaskPos <= ML) And (Mask[MaskPos] = '*') Do
                                   Inc(MaskPos);
                              If MaskPos > ML Then Begin
                                   Result := True;
                                   exit;
                              End;
                              Repeat
                                   If MatchAt(MaskPos, KeyPos) Then Begin
                                        Result := True;
                                        exit;
                                   End;
                                   Inc(KeyPos);
                              Until KeyPos > KL;
                              Result := False;
                              exit;
                         End;
               Else
                    If Not CharMatch(Mask[MaskPos], Key[KeyPos], CaseSensitive) Then Begin
                         Result := False;
                         exit;
                    End
                    Else Begin
                         Inc(MaskPos);
                         Inc(KeyPos);
                    End;
               End;
          While (MaskPos <= ML) And (Mask[MaskPos] In ['?', '*']) Do
               Inc(MaskPos);
          If (MaskPos <= ML) Or (KeyPos <= KL) Then Begin
               Result := False;
               exit;
          End;
          Result := True;
     End;

Begin
     ML := Length(Mask);
     If ML = 0 Then Begin
          Result := True;
          exit;
     End;
     KL := Length(Key);
     Result := MatchAt(1, 1);
End;



{                                                                              }
{ Character class strings                                                      }
{                                                                              }

Function CharSetToCharClassStr(Const C: CharSet): AnsiString;

     Function ChStr(Const Ch: AnsiChar): AnsiString;
     Begin
          Case Ch Of
               '\': Result := AnsiString('\\');
               ']': Result := AnsiString('\]');
               asciiBEL: Result := AnsiString('\a');
               asciiBS: Result := AnsiString('\b');
               asciiESC: Result := AnsiString('\e');
               asciiFF: Result := AnsiString('\f');
               asciiLF: Result := AnsiString('\n');
               asciiCR: Result := AnsiString('\r');
               asciiHT: Result := AnsiString('\t');
               asciiVT: Result := AnsiString('\v');
          Else If (Ch < #32) Or (Ch > #127) Then // non-printable
               Result := AnsiString('\x' + IntToHex(Ord(Ch), 1))
          Else
               Result := Ch;
          End;
     End;

     Function SeqStr(Const SeqStart, SeqEnd: AnsiChar): AnsiString;
     Begin
          Result := ChStr(SeqStart);
          If Ord(SeqEnd) = Ord(SeqStart) + 1 Then
               Result := Result + ChStr(SeqEnd)
          Else {// consequetive chars} If SeqEnd > SeqStart Then // range
               Result := Result + '-' + ChStr(SeqEnd);
     End;

Var
     CS                       : CharSet;
     F                        : AnsiChar;
     SeqStart                 : AnsiChar;
     Seq                      : Boolean;

Begin
     If IsComplete(C) Then
          Result := '.'
     Else If IsEmpty(C) Then
          Result := '[]'
     Else Begin
          Result := '[';
          CS := C;
          If (AnsiChar(#0) In C) And (AnsiChar(#255) In C) Then Begin
               ComplementCharSet(CS);
               Result := Result + '^';
          End;
          Seq := False;
          SeqStart := #0;
          For F := #0 To #255 Do
               If F In CS Then Begin
                    If Not Seq Then Begin
                         SeqStart := F;
                         Seq := True;
                    End;
               End
               Else If Seq Then Begin
                    Result := Result + SeqStr(SeqStart, AnsiChar(Ord(F) - 1));
                    Seq := False;
               End;
          If Seq Then
               Result := Result + SeqStr(SeqStart, #255);
          Result := Result + ']';
     End;
End;

Function CharClassStrToCharSet(Const S: AnsiString): CharSet;
Var
     I, L                     : Integer;

     Function DecodeChar: AnsiChar;
     Var
          J                   : Integer;
     Begin
          If S[I] = '\' Then
               If I + 1 = L Then Begin
                    Inc(I);
                    Result := '\';
               End
               Else If Not MatchQuantSeq(J, [['x'], csHexDigit, csHexDigit],
                    [mqOnce, mqOnce, mqOptional], S, [moDeterministic], I + 1) Then Begin
                    Case S[I + 1] Of
                         '0': Result := asciiNULL;
                         'a': Result := asciiBEL;
                         'b': Result := asciiBS;
                         'e': Result := asciiESC;
                         'f': Result := asciiFF;
                         'n': Result := asciiLF;
                         'r': Result := asciiCR;
                         't': Result := asciiHT;
                         'v': Result := asciiVT;
                    Else
                         Result := S[I + 1];
                    End;
                    Inc(I, 2);
               End
               Else Begin
                    If J = I + 2 Then
                         Result := AnsiChar(HexCharValue(S[J]))
                    Else
                         Result := AnsiChar(HexCharValue(S[J - 1]) * 16 + HexCharValue(S[J]));
                    I := J + 1;
               End
          Else Begin
               Result := S[I];
               Inc(I);
          End;
     End;

Var
     Neg                      : Boolean;
     A, B                     : AnsiChar;
Begin
     L := Length(S);
     If (L = 0) Or (S = '[]') Then
          Result := []
     Else If L = 1 Then
          If S[1] In ['.', '*', '?'] Then
               Result := CompleteCharSet
          Else
               Result := [S[1]]
     Else If (S[1] <> '[') Or (S[L] <> ']') Then
          Raise EConvertError.Create('Invalid character class AnsiString')
     Else Begin
          Neg := S[2] = '^';
          I := iif(Neg, 3, 2);
          Result := [];
          While I < L Do Begin
               A := DecodeChar;
               If (I + 1 < L) And (S[I] = '-') Then Begin
                    Inc(I);
                    B := DecodeChar;
                    Result := Result + [A..B];
               End
               Else
                    Include(Result, A);
          End;
          If Neg Then
               ComplementCharSet(Result);
     End;
End;



{                                                                              }
{ Dynamic array functions                                                      }
{                                                                              }

Function StringsTotalLength(Const S: Array Of AnsiString): Integer;
Var
     I                        : Integer;
Begin
     Result := 0;
     For I := 0 To Length(S) - 1 Do
          Inc(Result, Length(S[I]));
End;

Function PosNextNoCase(Const Find: AnsiString; Const V: Array Of AnsiString;
     Const PrevPos: Integer; Const IsSortedAscending: Boolean): Integer;
Var
     I, L, H                  : Integer;
Begin
     If IsSortedAscending Then          {// binary search} Begin
          If MaxI(PrevPos + 1, 0) = 0 Then {// find first} Begin
               L := 0;
               H := Length(V) - 1;
               Repeat
                    I := (L + H) Div 2;
                    If StrEqualNoCase(V[I], Find) Then Begin
                         While (I > 0) And StrEqualNoCase(V[I - 1], Find) Do
                              Dec(I);
                         Result := I;
                         exit;
                    End
                    Else If StrCompareNoCase(V[I], Find) = crGreater Then
                         H := I - 1
                    Else
                         L := I + 1;
               Until L > H;
               Result := -1;
          End
          Else {// find next} If PrevPos >= Length(V) - 1 Then
               Result := -1
          Else If StrEqualNoCase(V[PrevPos + 1], Find) Then
               Result := PrevPos + 1
          Else
               Result := -1;
     End
     Else Begin                         // linear search
          For I := MaxI(PrevPos + 1, 0) To Length(V) - 1 Do
               If StrEqualNoCase(V[I], Find) Then Begin
                    Result := I;
                    exit;
               End;
          Result := -1;
     End;
End;



{                                                                              }
{ Multi-Line encodings                                                         }
{                                                                              }

Function EncodeDotLineTerminated(Const S: AnsiString): AnsiString;
Begin
     Result := S;
     If (Length(Result) >= 1) And (Result[1] = '.') Then
          Insert('.', Result, 1);
     Result := StrReplace(CRLF + '.', CRLF + '..', Result) +
          '.' + CRLF;
End;

Function DecodeDotLineTerminated(Const S: AnsiString): AnsiString;
Begin
     If Not StrMatchRight('.' + CRLF, S) Then
          Raise EConvertError.Create('Not dot line terminated');
     Result := StrReplace(CRLF + '.', CRLF, S);
     Delete(Result, Length(Result) - 1, 2);
     If (Length(Result) >= 1) And (Result[1] = '.') Then
          Delete(Result, 1, 1);
End;

Function EncodeEmptyLineTerminated(Const S: AnsiString): AnsiString;
Begin
     Result := StrInclSuffix(S, CRLF);
     If (Length(Result) >= 2) And (Result[1] = asciiCR) And (Result[2] = asciiLF) Then
          Insert('.', Result, 1);
     Result := StrReplace(CRLF + CRLF, CRLF + '.' + CRLF, Result) +
          CRLF;
End;

Function DecodeEmptyLineTerminated(Const S: AnsiString): AnsiString;
Begin
     If Not StrMatchRight(CRLF, S) Then
          Raise EConvertError.Create('Not dot line terminated');
     Result := StrReplace(CRLF + '.', CRLF, CopyLeft(S, Length(S) - 2));
     If (Length(Result) >= 1) And (Result[1] = '.') Then
          Delete(Result, 1, 1);
End;



{                                                                              }
{ Natural language                                                             }
{                                                                              }

Function StorageSize(Const Bytes: Int64; Const ShortFormat: Boolean): AnsiString;
Var
     Size, Suffix             : AnsiString;
     Fmt                      : AnsiString;
Begin
     Fmt := iif(ShortFormat, '%1.0f', '%0.1f');
     If Bytes < 1024 Then Begin
          Size := AnsiString(IntToStr(Bytes));
          Suffix := iif(ShortFormat, 'b', 'bytes');
     End
     Else If Bytes < 1024 * 1024 Then Begin
          Size := AnsiString(Format(Fmt, [Bytes / 1024]));
          Suffix := iif(ShortFormat, 'K', 'Kb');
     End
     Else If Bytes < 1024 * 1024 * 1024 Then Begin
          Size := AnsiString(Format(Fmt, [Bytes / (1024 * 1024)]));
          Suffix := iif(ShortFormat, 'M', 'Mb');
     End
     Else If Bytes < Int64(1024) * 1024 * 1024 * 1024 Then Begin
          Size := AnsiString(Format(Fmt, [Bytes / (1024 * 1024 * 1024)]));
          Suffix := iif(ShortFormat, 'G', 'Gb');
     End
     Else Begin
          Size := AnsiString(Format(Fmt, [Bytes / (Int64(1024) * 1024 * 1024 * 1024)]));
          Suffix := iif(ShortFormat, 'T', 'Tb');
     End;
     If StrMatchRight('.0', Size) Then
          SetLength(Size, Length(Size) - 2);
     Result := Size + ' ' + Suffix;
End;

Function TransferRate(Const Bytes, MillisecondsElapsed: Int64;
     Const ShortFormat: Boolean): AnsiString;
Begin
     If MillisecondsElapsed <= 0 Then
          Result := ''
     Else
          Result := StorageSize(Trunc(Bytes / (MillisecondsElapsed / 1000.0)), ShortFormat) + '/s';
End;





End.
