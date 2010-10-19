// $Id: PCRE.pas,v 1.23 2005/08/27 13:24:39 Renato Exp $

{**************************************************************}
{                                                              }
{  Borland Delphi Wrapper for Philip Hazel's PCRE library      }
{                                                              }
{  Author: Renato Mancuso <mancuso@renatomancuso.com>          }
{                                                              }
{       Copyright (C) 2003-2004 Renato Mancuso                 }
{                                                              }
{==============================================================}
{                                                              }
{  Regular expression support is provided by the PCRE library  }
{  package, which is open source software, written by Philip   }
{  Hazel, and copyright by the University of Cambridge,        }
{  England.                                                    }
{                                                              }
{  The latest release of PCRE is always available from:        }
{                                                              }
{  ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/      }
{                                                              }
{==============================================================}
{                                                              }
{   DISCLAIMER                                                 }
{   ----------                                                 }
{   This software is distributed in the hope that it will be   }
{   useful, but WITHOUT ANY WARRANTY; without even the implied }
{   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR    }
{   PURPOSE.                                                   }
{                                                              }
{**************************************************************}
//
//  Revision History
//  ----------------
//
//  03-FEB-2008
//    David (dreamfly1024@126.com) wrote:
//    I notice there is a bug of PCRE Workbench:
//    Regex-Replace '1234567890' with '(?<=\d)(?=(\d{3})+$)' to ','
//    Result   : 1,,234,,567,,890 => ERROR
//    Should be: 1,234,567,890
//
//    Modified TRegex.Replace and TRegex.Split to use fix
//    provided by David
//
//  27-AUG-2005
//    Added support for DFA matching
//
//  30-JUN-2005
//    Added preliminary support for PCRE 6.1
//
//  26-OCT-2004
//    Updated for PCRE 5.0
//
//  01-MAR-2004
//      Added support for named capture groups using code
//      contributed by Sacha De Vos <sacha@flexfone.net>
//
//  29-FEB-2004
//      Added call to LocaleLock.Free() in unit finalization
//      thanks to Miha Vrhovnik - http://simail.sourceforge.net
//
//**************************************************************

unit PCRE;

{$ALIGN ON}
{$MINENUMSIZE 4}
{$B-}

interface

uses
  SysUtils, dialogs,JclAnsiStrings;

const
  CAPTURE_GROUP_BEFORE_START = -1;
  CAPTURE_GROUP_AFTER_END    = -2;
  CAPTURE_GROUP_ENTIRE_MATCH =  0;

const
  INVALID_INDEX_VALUE        = -1;

type
  // Options used to control compilation of regex patterns
  TRegCompileOption =
  (
    rcoAnchored,                  // PCRE_ANCHORED
    rcoIgnoreCase,                // PCRE_CASELESS
    rcoDollarEndOnly,             // PCRE_DOLLAR_ENDONLY
    rcoSingleLine,                // PCRE_DOTALL
    rcoIgnorePatternWhitespace,   // PCRE_EXTENDED
    rcoExtra,                     // PCRE_EXTRA
    rcoMultiLine,                 // PCRE_MULTILINE
    rcoUngreedy,                  // PCRE_UNGREEDY
    rcoNoAutoCapture,             // PCRE_NO_AUTO_CAPTURE
    rcoUTF8,                      // PCRE_UTF8
    rcoNoUTF8Check,               // PCRE_NO_UTF8_CHECK
    rcoAutoCallout,               // PCRE_AUTO_CALLOUT
    rcoPartial,                   // PCRE_PARTIAL
    rcoFirstLine                  // PCRE_FIRSTLINE
(*    rcoDupNames,                  // PCRE_DUPNAMES          -- DW
    rcoNewLineCR,                 // PCRE_NEWLINE_CR
    rcoNewLineLF,                 // PCRE_NEWLINE_LF
    rcoNewLineCRLF,               // PCRE_NEWLINE_CRLF
    rcoNewLineAny,                // PCRE_NEWLINE_ANY
    rcoNewLineAnyCRLF,            // PCRE_NEWLINE_ANYCRLF
    rcoBSRAnyCRLF,                // PCRE_BSR_ANYCRLF
    rcoBSRUnicode                 // PCRE_BSR_UNICODE 
*)
  );

  // Options used to control matching behavior
  TRegMatchOption =
  (
    rmoAnchored,                  // PCRE_ANCHORED
    rmoNotBOL,                    // PCRE_NOTBOL
    rmoNotEOL,                    // PCRE_NOTEOL
    rmoNotEmpty,                  // PCRE_NOTEMPTY
    rmoNoUTF8Check,               // PCRE_NO_UTF8_CHECK
    rmoDfaShortest                // PCRE_DFA_SHORTEST
  );

  TRegSplitOption = ( rsoIncludeSeparators );

  TRegCompileOptions = set of TRegCompileOption;
  TRegMatchOptions   = set of TRegMatchOption;
  TRegSplitOptions   = set of TRegSplitOption;

type
  ICaptureGroup = interface
  ['{2AAF1F28-63F8-4977-95EE-13AAC0E3E866}']
    function GetMatched: Boolean; stdcall;
    function GetValue: AnsiString; stdcall;
    function GetIndex: Integer; stdcall;
    function GetLength: Integer; stdcall;

    property Matched: Boolean
        read GetMatched;

    property Value: Ansistring
        read GetValue;

    property Index: Integer
        read GetIndex;

    property Length: Integer
        read GetLength;
  end;

  ICaptureGroupCollection = interface
  ['{662BAD69-E186-4582-A3EB-568AE049E16A}']
    function GetCount: Integer; stdcall;
    function GetItem(Index: Integer): ICaptureGroup; stdcall;
    function GetItemByName(const Name: ansistring): ICaptureGroup; stdcall;

    property Count: Integer
        read GetCount;

    property Items[Index: Integer]: ICaptureGroup
        read GetItem; default;

    property ItemsByName[const Name: ansistring]: ICaptureGroup
        read GetItemByName;
  end;

  IMatch = interface(ICaptureGroup)
  ['{99E6F66B-1D9F-41D6-8C30-497AF04EF2BA}']
    function GetGroups: ICaptureGroupCollection; stdcall;

    property Success: Boolean
        read GetMatched;

    property Groups: ICaptureGroupCollection
        read GetGroups;
  end;

  IMatchCollection = interface
  ['{86D9C75F-754A-4A71-9965-3854DB68F8E9}']
    function GetCount: Integer; stdcall;
    function GetItem(Index: Integer): IMatch; stdcall;

    property Count: Integer
        read GetCount;

    property Items[Index: Integer]: IMatch
        read GetItem; default;
  end;

  IStringCollection = interface
  ['{4FC62381-7D61-4399-B22E-4AB27BBC070C}']
    function GetCount: Integer; stdcall;
    function GetString(Index: Integer): AnsiString; stdcall;

    property Count: Integer
        read GetCount;

    property Strings[Index: Integer]: AnsiString
        read GetString; default;
  end;

  IDfaMatch = interface
  ['{66D0477C-0ADB-4BB5-AA0A-73E4F578458B}']
    function GetValue: ansistring; stdcall;
    function GetIndex: Integer; stdcall;
    function GetLength: Integer; stdcall;

    property Value: ansistring
        read GetValue;

    property Index: Integer
        read GetIndex;

    property Length: Integer
        read GetLength;
  end;

  IDfaMatchCollection = interface
  ['{4AAC53FA-9681-42D6-8949-086EF141B430}']
    function GetCount: Integer; stdcall;
    function GetItem(Index: Integer): IDfaMatch; stdcall;

    property Count: Integer
        read GetCount;

    property Items[Index: Integer]: IDfaMatch
        read GetItem; default;
  end;

  TRegexMatchEvaluator = function(theMatch: IMatch): ansistring of object;
  TRegexMatchEvent     = procedure(theMatch: IMatch) of object;

  IRegex = interface
  ['{C8DA961E-33ED-4C3A-AA9F-400DD9A766EB}']
    { IsMatch }
    function IsMatch(const Input    : ansistring): Boolean; overload; stdcall;

    function IsMatch(const Input    : ansistring;
                           Options  : TRegMatchOptions): Boolean; overload; stdcall;

    function IsMatch(const Input    : ansistring;
                           Start    : Integer): Boolean; overload; stdcall;

    function IsMatch(const Input    : ansistring;
                           Start    : Integer;
                           Options  : TRegMatchOptions): Boolean; overload; stdcall;

    { Match }
    function Match(const Input    : ansistring): IMatch; overload; stdcall;

    function Match(const Input    : ansistring;
                         Options  : TRegMatchOptions): IMatch; overload; stdcall;

    function Match(const Input    : ansistring;
                         Start    : Integer): IMatch; overload; stdcall;

    function Match(const Input    : ansistring;
                         Start    : Integer;
                         Options  : TRegMatchOptions): IMatch; overload; stdcall;


    { DFA Match }
    function DfaMatch(const Input    : ansistring): IDfaMatchCollection; overload; stdcall;

    function DfaMatch(const Input    : ansistring;
                            Options  : TRegMatchOptions): IDfaMatchCollection; overload; stdcall;

    function DfaMatch(const Input    : ansistring;
                            Start    : Integer): IDfaMatchCollection; overload; stdcall;

    function DfaMatch(const Input    : ansistring;
                            Start    : Integer;
                            Options  : TRegMatchOptions): IDfaMatchCollection; overload; stdcall;

    { Matches }
    function Matches(const Input  : ansistring): IMatchCollection; overload; stdcall;

    function Matches(const Input  : ansistring;
                           Options: TRegMatchOptions): IMatchCollection; overload; stdcall;

    { Grep }
    procedure Grep(const Input    : ansistring;
                         OnMatch  : TRegexMatchEvent); overload; stdcall;

    procedure Grep(const Input    : ansistring;
                         Options  : TRegMatchOptions;
                         OnMatch  : TRegexMatchEvent); overload; stdcall;

    { Split }
    function Split(const Input        : ansistring): IStringCollection; overload; stdcall;

    function Split(const Input        : ansistring;
                         Options      : TRegSplitOptions): IStringCollection; overload; stdcall;

    function Split(const Input        : ansistring;
                         Options      : TRegSplitOptions;
                         MatchOptions : TRegMatchOptions): IStringCollection; overload; stdcall;

    { Replace }
    function Replace(const Input        : ansistring;
                     const Replacement  : ansistring): ansistring; overload; stdcall;

    function Replace(const Input        : ansistring;
                           Evaluator    : TRegexMatchEvaluator): ansistring; overload; stdcall;

    function Replace(const Input        : ansistring;
                     const Replacement  : ansistring;
                           MatchOptions : TRegMatchOptions): ansistring; overload; stdcall;

    function Replace(const Input        : ansistring;
                           Evaluator    : TRegexMatchEvaluator;
                           MatchOptions : TRegMatchOptions): ansistring; overload; stdcall;

    { Misc }
    function GetOptions: TRegCompileOptions; stdcall;

    function GetPattern: ansistring; stdcall;

    { properties }
    property Options: TRegCompileOptions
        read GetOptions;

    property Pattern: ansistring
        read GetPattern;
  end;

  TNamedGroupInfo = record
    Name  : ansistring;
    Index : Integer;
  end;

  IRegexInfo = interface
  ['{9BEAD385-793F-441A-8721-D161B2DCA6B7}']
    function GetCompiledSize    : Cardinal; stdcall;
    function GetCaptureCount    : Integer; stdcall;
    function GetBackRefMax      : Integer; stdcall;
    function GetFirstChar       : Integer; stdcall;
    function GetFirstTable      : Pointer; stdcall;
    function GetLastLiteral     : Integer; stdcall;
    function GetLocale          : ansistring; stdcall;
    function GetOptions         : TRegCompileOptions; stdcall;
    function GetPattern         : ansistring; stdcall;
    function GetNamedGroupCount : Integer; stdcall;
    function GetNamedGroup(Index: Integer): TNamedGroupInfo; stdcall;

    property Options: TRegCompileOptions
        read GetOptions;

    property Pattern: ansistring
        read GetPattern;

    property CompiledSize: Cardinal
        read GetCompiledSize;

    property CaptureCount: Integer
        read GetCaptureCount;

    property BackRefMax: Integer
        read GetBackRefMax;

    property FirstChar: Integer
        read GetFirstChar;

    property FirstTable: Pointer
        read GetFirstTable;

    property LastLiteral: Integer
        read GetLastLiteral;

    property Locale: ansistring
        read GetLocale;

    property NamedGroupCount: Integer
        read GetNamedGroupCount;

    property NamedGroup[Index: Integer]: TNamedGroupInfo
        read GetNamedGroup;
  end;

type
  TRegexLocaleCategory =
  (
    RXLC_ALL,        // = LC_ALL,
    RXLC_COLLATE,    // = LC_COLLATE,
    RXLC_CTYPE,      // = LC_CTYPE,
    RXLC_MONETARY,   // = LC_MONETARY,
    RXLC_NUMERIC,    // = LC_NUMERIC,
    RXLC_TIME        // = LC_TIME
  );

type
  ERegexException                 = class(Exception);
  EBadRegexLocale                 = class(ERegexException);
  ERegexInvalidSubstitutionGroup  = class(ERegexException);
  ERegexBadGroupName              = class(ERegexException);

function RegexCreate(const thePattern       : ansistring): IRegex; overload;

function RegexCreate(const thePattern       : ansistring;
                           theOptions       : TRegCompileOptions): IRegex; overload;

function RegexCreate(const thePattern       : ansistring;
                     const theLocale        : ansistring;
                           theLocaleCategory: TRegexLocaleCategory = RXLC_ALL): IRegex; overload;

function RegexCreate(const thePattern       : ansistring;
                           theOptions       : TRegCompileOptions;
                     const theLocale        : ansistring;
                           theLocaleCategory: TRegexLocaleCategory = RXLC_ALL): IRegex; overload;

function EncodeRegCompileOptions(theOptions : TRegCompileOptions): LongWord;
function DecodeRegCompileOptions(theOptions : LongWord): TRegCompileOptions;

function EncodeRegMatchOptions  (theOptions : TRegMatchOptions): LongWord;
function DecodeRegMatchOptions  (theOptions : LongWord): TRegMatchOptions;

implementation

uses
  Classes,
  SyncObjs,
  Math,
  pcre_dll;

{ ********************************************************* }
{ ********************************************************* }
{ ********************************************************* }

type
  INameIndexLookup = interface
  ['{4EB901AE-50F9-4552-84B6-1676613B6F0E}']
    function  GetGroupIndex(const theName: ansistring): Integer;
    procedure AddMapping(const theName: ansistring; theIndex: Integer);
    function  GetMappingCount: Integer;
    function  GetMappingAt(theIndex: Integer): TNamedGroupInfo;
  end;

  TNameIndexLookup = class(TInterfacedObject, INameIndexLookup)
  private
    FMappings : TAnsiStringList;

  public
    constructor Create;
    destructor Destroy; override;

    // INameIndexLookup
    function  GetGroupIndex(const theName: ansistring): Integer;
    procedure AddMapping(const theName: ansistring; theIndex: Integer);
    function  GetMappingCount: Integer;
    function  GetMappingAt(theIndex: Integer): TNamedGroupInfo;
  end;

  TRegexLocale = class
  private
    FNlsTable: TPcre_tableH;
    FDispose : Boolean;
    FLocale  : ansistring;
  public
    constructor Create(const theLocale: ansistring; theLocaleCategory: TRegexLocaleCategory);
    destructor  Destroy; override;

    property Locale: ansistring
        read FLocale;

    property CharTable: TPcre_tableH
        read FNlsTable;
  end;

  TRegexStringCollection = class(TInterfacedObject, IStringCollection)
  private
    FStrings  : TAnsiStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const S: ansistring);
    { IStringCollection }
    function GetCount: Integer; stdcall;
    function GetString(Index: Integer): Ansistring; stdcall;
  end;

  TRegexMatchCollection = class(TInterfacedObject, IMatchCollection)
  private
    FList : TInterfaceList;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure Add(Element: IMatch);
    { IMatchCollection }
    function GetCount: Integer; stdcall;
    function GetItem(Index: Integer): IMatch; stdcall;
  end;

  TOVector = array of Integer;

  TMatchPos = record
    First : Integer;
    Last  : Integer;
  end;

  TRegexMatch = class(TInterfacedObject, IMatch, ICaptureGroupCollection)
  private
    FSubject : ansistring;
    FCount   : Integer;
    FMatches : TOvector;
    FNames   : INameIndexLookup;

  public
    constructor Create(const S: ansistring; var VOffset: TOVector; const Names: INameIndexLookup);
    destructor  Destroy; override;

    function InternalGetMatchPos(Index: Integer): TMatchPos;
    function InternalGetMatched(Index: Integer): Boolean;
    function InternalGetValue(Index: Integer): ansistring;
    function InternalGetIndex(Index: Integer): Integer;
    function InternalGetLength(Index: Integer): Integer;

    { ICaptureGroup }
    function GetMatched: Boolean; stdcall;
    function GetValue: Ansistring; stdcall;
    function GetIndex: Integer; stdcall;
    function GetLength: Integer; stdcall;

    { IMatch }
    function GetGroups: ICaptureGroupCollection; stdcall;

    { ICaptureGroupCollection }
    function GetCount: Integer; stdcall;
    function GetItem(Index: Integer): ICaptureGroup; stdcall;
    function GetItemByName(const Name: ansistring): ICaptureGroup; stdcall;
  end;

  TRegexCaptureGroup = class(TInterfacedObject, ICaptureGroup)
  private
    FMatch  : TRegexMatch;
    FIndex  : Integer;
  public
    constructor Create(Match: TRegexMatch; Index: Integer);
    destructor Destroy; override;
    { ICaptureGroup }
    function GetMatched: Boolean; stdcall;
    function GetValue: Ansistring; stdcall;
    function GetIndex: Integer; stdcall;
    function GetLength: Integer; stdcall;
  end;

  TDfaMatchCollection = class(TInterfacedObject, IDfaMatchCollection)
  private
    FSubject : ansistring;
    FCount   : Integer;
    FMatches : TOvector;

  public
    constructor Create(const S: ansistring; var VOffset: TOVector);
    destructor  Destroy; override;

    function InternalGetMatchPos(Index: Integer): TMatchPos;
    function InternalGetValue(Index: Integer): ansistring;
    function InternalGetIndex(Index: Integer): Integer;
    function InternalGetLength(Index: Integer): Integer;

    { IDfaMatchCollection }
    function GetCount: Integer; stdcall;
    function GetItem(Index: Integer): IDfaMatch; stdcall;
  end;

  TDfaMatch = class(TInterfacedObject, IDfaMatch)
  private
    FMatchCollection: TDfaMatchCollection;
    FIndex: Integer;

  public
    constructor Create(MatchCollection: TDfaMatchCollection; Index: Integer);
    destructor Destroy; override;

    { IDfaMatch }
    function GetValue: ansistring; stdcall;
    function GetIndex: Integer; stdcall;
    function GetLength: Integer; stdcall;
  end;

  TRegex = class(TInterfacedObject, IRegex, IRegexInfo)
  private
    FPattern    : AnsiString;
    FOptions    : TRegCompileOptions;
    FRegex      : TPcreH;
    FRegExtra   : TPcre_extraH;
    FLocaleInfo : TRegexLocale;
    FNames      : INameIndexLookup;

    procedure CompilePattern;
    procedure RetrieveNames;
    procedure PcreCheck(ErrorCode: Integer);

  public
    constructor Create(const Pattern        : ansistring;
                             Options        : TRegCompileOptions;
                       const Locale         : ansistring;
                             LocaleCategory : TRegexLocaleCategory = RXLC_ALL);

    destructor Destroy; override;

    { IRegex }
    function IsMatch(const Input: ansistring): Boolean; overload; stdcall;
    function IsMatch(const Input: ansistring; Options: TRegMatchOptions): Boolean; overload; stdcall;
    function IsMatch(const Input: ansistring; Start: Integer): Boolean; overload; stdcall;
    function IsMatch(const Input: ansistring; Start: Integer; Options: TRegMatchOptions): Boolean; overload; stdcall;

    function Match(const Input: ansistring): IMatch; overload; stdcall;
    function Match(const Input: ansistring; Options: TRegMatchOptions): IMatch; overload; stdcall;
    function Match(const Input: ansistring; Start: Integer): IMatch; overload; stdcall;
    function Match(const Input: ansistring; Start: Integer; Options: TRegMatchOptions): IMatch; overload; stdcall;

    function DfaMatch(const Input    : ansistring): IDfaMatchCollection; overload; stdcall;

    function DfaMatch(const Input    : ansistring;
                            Options  : TRegMatchOptions): IDfaMatchCollection; overload; stdcall;

    function DfaMatch(const Input    : ansistring;
                            Start    : Integer): IDfaMatchCollection; overload; stdcall;

    function DfaMatch(const Input    : ansistring;
                            Start    : Integer;
                            Options  : TRegMatchOptions): IDfaMatchCollection; overload; stdcall;


    function Matches(const Input: ansistring): IMatchCollection; overload; stdcall;
    function Matches(const Input: ansistring; Options: TRegMatchOptions): IMatchCollection; overload; stdcall;

    procedure Grep(const Input: ansistring; OnMatch: TRegexMatchEvent); overload; stdcall;
    procedure Grep(const Input: ansistring; Options: TRegMatchOptions; OnMatch: TRegexMatchEvent); overload; stdcall;

    function Split(const Input: ansistring): IStringCollection; overload; stdcall;
    function Split(const Input: ansistring; Options: TRegSplitOptions): IStringCollection; overload; stdcall;
    function Split(const Input: ansistring; Options: TRegSplitOptions; MatchOptions: TRegMatchOptions): IStringCollection; overload; stdcall;

    function Replace(const Input: ansistring; const Replacement: ansistring): ansistring; overload; stdcall;
    function Replace(const Input: ansistring; Evaluator: TRegexMatchEvaluator): ansistring; overload; stdcall;
    function Replace(const Input: ansistring; const Replacement: ansistring; MatchOptions: TRegMatchOptions): ansistring; overload; stdcall;
    function Replace(const Input: ansistring; Evaluator: TRegexMatchEvaluator; MatchOptions: TRegMatchOptions): ansistring; overload; stdcall;

    function GetOptions: TRegCompileOptions; stdcall;
    function GetPattern: ansistring; stdcall;

    { IRegexInfo }
    function GetCompiledSize: Cardinal; stdcall;
    function GetCaptureCount: Integer; stdcall;
    function GetBackRefMax: Integer; stdcall;
    function GetFirstChar: Integer; stdcall;
    function GetFirstTable: Pointer; stdcall;
    function GetLastLiteral: Integer; stdcall;
    function GetLocale: ansistring; stdcall;
    function GetNamedGroupCount : Integer; stdcall;
    function GetNamedGroup(Index: Integer): TNamedGroupInfo; stdcall;
  end;

  TSubstitute = class(TObject)
  private
    FMatch  : IMatch;
  public
    constructor Create(theMatch: IMatch);
    function    RegexSubstitute(Match: IMatch): ansistring;
  end;

{ ********************************************************* }
{ ********************************************************* }
{ ********************************************************* }

{ RegexCreate }

//===========================================================================

function RegexCreate(const thePattern: ansistring): IRegex;

begin
  Result := RegexCreate(thePattern, [], 'C');
end;

//===========================================================================

function RegexCreate(const thePattern: ansistring; theOptions: TRegCompileOptions): IRegex;

begin
  Result := RegexCreate(thePattern, theOptions, 'C');
end;

//===========================================================================

function RegexCreate(const thePattern         : ansistring;
                     const theLocale          : ansistring;
                           theLocaleCategory  : TRegexLocaleCategory = RXLC_ALL): IRegex;

begin
  Result := RegexCreate(thePattern, [], theLocale, theLocaleCategory);
end;

//===========================================================================

function RegexCreate(const thePattern       : ansistring;
                           theOptions       : TRegCompileOptions;
                     const theLocale        : ansistring;
                           theLocaleCategory: TRegexLocaleCategory = RXLC_ALL): IRegex;

begin
  Result := TRegex.Create(thePattern, theOptions, theLocale, theLocaleCategory);
end;

//===========================================================================

{ Utility functions}

function EncodeRegCompileOptions(theOptions: TRegCompileOptions): LongWord;

begin
  Result := 0;

  if rcoAnchored in theOptions then
    Result := Result or PCRE_ANCHORED;

  if rcoIgnoreCase in theOptions then
    Result := Result or PCRE_CASELESS;

  if rcoDollarEndOnly in theOptions then
    Result := Result or PCRE_DOLLAR_ENDONLY;

  if rcoSingleLine in theOptions then
    Result := Result or PCRE_DOTALL;

  if rcoIgnorePatternWhitespace in theOptions then
    Result := Result or PCRE_EXTENDED;

  if rcoExtra in theOptions then
    Result := Result or PCRE_EXTRA;

  if rcoMultiLine in theOptions then
    Result := Result or PCRE_MULTILINE;

  if rcoUngreedy in theOptions then
    Result := Result or PCRE_UNGREEDY;

  if rcoNoAutoCapture in theOptions then
    Result := Result or PCRE_NO_AUTO_CAPTURE;

  if rcoUTF8 in theOptions then
    Result := Result or PCRE_UTF8;

  if rcoNoUTF8Check in theOptions then
    Result := Result or PCRE_NO_UTF8_CHECK;

  if rcoAutoCallout in theOptions then
    Result := Result or PCRE_AUTO_CALLOUT;

  if rcoPartial in theOptions then
    Result := Result or PCRE_PARTIAL;

  if rcoFirstLine in theOptions then
    Result := Result or PCRE_FIRSTLINE;
end;

//===========================================================================

function DecodeRegCompileOptions(theOptions: LongWord): TRegCompileOptions;

begin
  Result := [];

  if (theOptions and PCRE_ANCHORED <> 0) then
    Include(Result, rcoAnchored);

  if (theOptions and PCRE_CASELESS <> 0) then
    Include(Result, rcoIgnoreCase);

  if (theOptions and PCRE_DOLLAR_ENDONLY <> 0) then
    Include(Result, rcoDollarEndOnly);

  if (theOptions and PCRE_DOTALL <> 0) then
    Include(Result, rcoSingleLine);

  if (theOptions and PCRE_EXTENDED <> 0) then
    Include(Result, rcoIgnorePatternWhitespace);

  if (theOptions and PCRE_EXTRA <> 0) then
    Include(Result, rcoExtra);

  if (theOptions and PCRE_MULTILINE <> 0) then
    Include(Result, rcoMultiLine);

  if (theOptions and PCRE_UNGREEDY <> 0) then
    Include(Result, rcoUngreedy);

  if (theOptions and PCRE_NO_AUTO_CAPTURE <> 0) then
    Include(Result, rcoNoAutoCapture);

  if (theOptions and PCRE_UTF8 <> 0) then
    Include(Result, rcoUTF8);

  if (theOptions and PCRE_NO_UTF8_CHECK <> 0) then
    Include(Result, rcoNoUTF8Check);

  if (theOptions and PCRE_AUTO_CALLOUT <> 0) then
    Include(Result, rcoAutoCallout);

  if (theOptions and PCRE_PARTIAL <> 0) then
    Include(Result, rcoPartial);

  if (theOptions and PCRE_FIRSTLINE <> 0) then
    Include(Result, rcoFirstLine);
end;

//===========================================================================

function EncodeRegMatchOptions(theOptions: TRegMatchOptions): LongWord;

begin
  Result := 0;

  if rmoAnchored in theOptions then
    Result := Result or PCRE_ANCHORED;

  if rmoNotBOL in theOptions then
    Result := Result or PCRE_NOTBOL;

  if rmoNotEOL in theOptions then
    Result := Result or PCRE_NOTEOL;

  if rmoNotEmpty in theOptions then
    Result := Result or PCRE_NOTEMPTY;

  if rmoNoUTF8Check in theOptions then
    Result := Result or PCRE_NO_UTF8_CHECK;

  if rmoDfaShortest in theOptions then
    Result := Result or PCRE_DFA_SHORTEST;
end;

//===========================================================================

function DecodeRegMatchOptions(theOptions: LongWord): TRegMatchOptions;

begin
  Result := [];

  if (theOptions and PCRE_ANCHORED <> 0) then
    Include(Result, rmoAnchored);

  if (theOptions and PCRE_NOTBOL <> 0) then
    Include(Result, rmoNotBOL);

  if (theOptions and PCRE_NOTEOL <> 0) then
    Include(Result, rmoNotEOL);

  if (theOptions and PCRE_NOTEMPTY <> 0) then
    Include(Result, rmoNotEmpty);

  if (theOptions and PCRE_NO_UTF8_CHECK <> 0) then
    Include(Result, rmoNoUTF8Check);

  if (theOptions and PCRE_DFA_SHORTEST <> 0) then
    Include(Result, rmoDfaShortest);
end;

//===========================================================================

constructor TSubstitute.Create(theMatch: IMatch);

begin
  inherited Create();
  FMatch := theMatch;
end;

//===========================================================================

function TSubstitute.RegexSubstitute(Match: IMatch): ansistring;

const
  REGEX_SUBST_DOLLAR        = '$';
  REGEX_SUBST_ALL_MATCH     = '&';
  REGEX_SUBST_BEFORE_MATCH  = '`';
  REGEX_SUBST_AFTER_MATCH   = '''';
  REGEX_SUBST_LAST_GROUP    = '+';
  REGEX_SUBST_ALL_INPUT     = '_';
  REGEX_SUBST_NAMED_GROUP   = '{';

var
  theSubstitution : ansistring;
  theIndex        : Integer;

begin
  theSubstitution := Match.Groups[1].Value;

  case theSubstitution[1] of
    REGEX_SUBST_DOLLAR        : Result := '$';
    REGEX_SUBST_NAMED_GROUP   : Result := FMatch.Groups.ItemsByName[Match.Groups[2].Value].Value;
    REGEX_SUBST_ALL_MATCH     : Result := FMatch.Value;
    REGEX_SUBST_BEFORE_MATCH  : Result := FMatch.Groups[CAPTURE_GROUP_BEFORE_START].Value;
    REGEX_SUBST_AFTER_MATCH   : Result := FMatch.Groups[CAPTURE_GROUP_AFTER_END].Value;
    REGEX_SUBST_LAST_GROUP    : Result := FMatch.Groups[FMatch.Groups.Count - 1].Value;
    REGEX_SUBST_ALL_INPUT     : Result := FMatch.Groups[CAPTURE_GROUP_BEFORE_START].Value +
                                          FMatch.Value                                    +
                                          FMatch.Groups[CAPTURE_GROUP_AFTER_END].Value;
  else
    // it must be a number
    theIndex := StrToInt(String(theSubstitution));

    if theIndex >= FMatch.Groups.Count then
      raise ERegexInvalidSubstitutionGroup.CreateFmt('Invalid substitution variable $%d',
                                                     [theIndex]);

    Result := FMatch.Groups[theIndex].Value;
  end;
end;

//===========================================================================

var
  RegexSubstitute : TRegex;

//===========================================================================

function Substitute(const Replace: ansistring; theMatch: IMatch): ansistring;

var
  theAction : TSubstitute;

begin
  theAction := TSubstitute.Create(theMatch);
  try
    Result := RegexSubstitute.Replace(Replace, theAction.RegexSubstitute);
  finally
    theAction.Free();
  end;
end;

//===========================================================================

{ TRegexLocale }

var
  LocaleLock : TCriticalSection;

//===========================================================================

function GetLocaleTable(const theLocale         : ansistring;
                              theLocaleCategory : Integer;
                        var   theCharTable      : TPcre_tableH): ansistring;

var
  szLocale : PAnsiChar;

begin
  LocaleLock.Enter;

  try
    szLocale := pcre_setlocale(theLocaleCategory, PAnsiChar(theLocale));

    if szLocale = nil then
    begin
      raise EBadRegexLocale.CreateFmt('Invalid locale string %s or invalid locale category %d',
                                      [theLocale, theLocaleCategory]);
    end;

    theCharTable := pcre_maketables();

    if theCharTable = nil then
      OutOfMemoryError;

    Result    := szLocale;

  finally
    LocaleLock.Leave;
  end;

end;

//===========================================================================

constructor TRegexLocale.Create(const theLocale         : ansistring;
                                      theLocaleCategory : TRegexLocaleCategory);

begin
  inherited Create;

  if (theLocale = 'C') and (theLocaleCategory = RXLC_ALL) then
  begin
    FNlsTable := nil;
    FLocale   := 'C';
    FDispose  := false;
  end
  else
  begin
    FLocale   := GetLocaleTable(theLocale, Ord(theLocaleCategory), FNlsTable);
    FDispose  := true;
  end;
end;

//===========================================================================

destructor TRegexLocale.Destroy;

begin
  if FDispose then
  begin
    pcre_free_ex(FNlsTable);
    FDispose := false;
  end;

  inherited;
end;

//===========================================================================

{ TRegexStringCollection }

procedure TRegexStringCollection.Add(const S: ansistring);

begin
  FStrings.Add(S);
end;

//===========================================================================

constructor TRegexStringCollection.Create;

begin
  inherited;
  FStrings := TAnsiStringList.Create();
end;

//===========================================================================

destructor TRegexStringCollection.Destroy;

begin
  FStrings.Free();
  inherited;
end;

//===========================================================================

function TRegexStringCollection.GetCount: Integer;

begin
  Result := FStrings.Count;
end;

//===========================================================================

function TRegexStringCollection.GetString(Index: Integer): AnsiString;

begin
  Result := FStrings[Index];
end;

//===========================================================================

{ TRegexMatchCollection }

procedure TRegexMatchCollection.Add(Element: IMatch);

begin
  ASSERT(Element <> nil);
  FList.Add(Element);
end;

//===========================================================================

constructor TRegexMatchCollection.Create;

begin
  inherited;
  FList := TInterfaceList.Create();
end;

//===========================================================================

destructor TRegexMatchCollection.Destroy;

begin
  FList.Free();
  inherited;
end;

//===========================================================================

function TRegexMatchCollection.GetCount: Integer;

begin
  Result := FList.Count;
end;

//===========================================================================

function TRegexMatchCollection.GetItem(Index: Integer): IMatch;

begin
  Result := FList[Index] as IMatch;
end;

//===========================================================================

{ TRegexCaptureGroup }

constructor TRegexCaptureGroup.Create(Match: TRegexMatch; Index: Integer);

begin
  inherited Create();
  FMatch := Match;
  FIndex := Index;
end;

//===========================================================================

destructor TRegexCaptureGroup.Destroy;

begin
  inherited;
end;

//===========================================================================

function TRegexCaptureGroup.GetIndex: Integer;

begin
  Result := FMatch.InternalGetIndex(FIndex);
end;

//===========================================================================

function TRegexCaptureGroup.GetLength: Integer;

begin
  Result := FMatch.InternalGetLength(FIndex);
end;

//===========================================================================

function TRegexCaptureGroup.GetMatched: Boolean;

begin
  Result := FMatch.InternalGetMatched(FIndex);
end;

//===========================================================================

function TRegexCaptureGroup.GetValue: Ansistring;

begin
  Result := FMatch.InternalGetValue(FIndex);
end;

//===========================================================================

{ TRegexMatch }

constructor TRegexMatch.Create(const S: ansistring; var VOffset: TOVector; const Names: INameIndexLookup);

begin
  ASSERT(Names <> nil);

  inherited Create();

  FSubject := S;
  FMatches := Voffset;

  if Assigned(FMatches) then
    FCount := Length(FMatches) div 3;

  FNames := Names;

  ASSERT(((FCount <> 0) and (FMatches <> nil)) or ((FCount = 0) and (FMatches = nil)));
  ASSERT((FMatches = nil) or (Length(FMatches) mod 3 = 0));
end;

//===========================================================================

destructor TRegexMatch.Destroy;

begin
  FMatches := nil;
  inherited;
end;

//===========================================================================

function TRegexMatch.InternalGetIndex(Index: Integer): Integer;

var
  MatchPos : TMatchPos;

begin
  MatchPos := InternalGetMatchPos(Index);
  Result   := MatchPos.First;
end;

//===========================================================================

function TRegexMatch.InternalGetLength(Index: Integer): Integer;

var
  MatchPos : TMatchPos;

begin
  MatchPos := InternalGetMatchPos(Index);
  Result   := MatchPos.Last - MatchPos.First;
end;

//===========================================================================

function TRegexMatch.InternalGetValue(Index: Integer): ansistring;

var
  MatchPos: TMatchPos;

begin
  Result := '';

  MatchPos := InternalGetMatchPos(Index);

  if MatchPos.First <> INVALID_INDEX_VALUE then
  begin
    Result := System.Copy(FSubject,
                          MatchPos.First + 1,
                          MatchPos.Last - MatchPos.First);
  end;
end;

//===========================================================================

function TRegexMatch.InternalGetMatched(Index: Integer): Boolean;

begin
  Result := InternalGetMatchPos(Index).First <> INVALID_INDEX_VALUE;
end;

//===========================================================================

function TRegexMatch.InternalGetMatchPos(Index: Integer): TMatchPos;
begin
  // assume failure
  Result.First := INVALID_INDEX_VALUE;
  Result.Last  := INVALID_INDEX_VALUE;

  // if no matches return
  if (FCount = 0) or (FMatches[0] = INVALID_INDEX_VALUE) then
    Exit;

  if (Index >= 0) and (Index < FCount) then
  begin
    // take values from OVector
    Result.First := FMatches[Index * 2];
    Result.Last  := FMatches[Index * 2 + 1];
  end
  else if Index = CAPTURE_GROUP_BEFORE_START then
  begin
    // return index from the Start of the string to
    // the Start of the match
    Result.First := 0;
    Result.Last  := FMatches[0];
  end
  else if Index = CAPTURE_GROUP_AFTER_END then
  begin
    // return everything from the end of the match
    // until the end of the subject string
    Result.First := FMatches[1];
    Result.Last  := Length(FSubject);
  end;
end;

//===========================================================================

function TRegexMatch.GetCount: Integer;

begin
  Result := FCount;
end;

//===========================================================================

function TRegexMatch.GetGroups: ICaptureGroupCollection;

begin
  Result := (Self as ICaptureGroupCollection);
end;

//===========================================================================

function TRegexMatch.GetItem(Index: Integer): ICaptureGroup;

begin
  Result := TRegexCaptureGroup.Create(Self, Index) as ICaptureGroup;
end;

//===========================================================================

function TRegexMatch.GetItemByName(const Name: ansistring): ICaptureGroup;

begin
  Result := GetItem(FNames.GetGroupIndex(Name));
end;

//===========================================================================

function TRegexMatch.GetIndex: Integer;

begin
  Result := InternalGetIndex(CAPTURE_GROUP_ENTIRE_MATCH);
end;

//===========================================================================

function TRegexMatch.GetLength: Integer;

begin
  Result := InternalGetLength(CAPTURE_GROUP_ENTIRE_MATCH);
end;

//===========================================================================

function TRegexMatch.GetMatched: Boolean;

begin
  Result := InternalGetMatched(CAPTURE_GROUP_ENTIRE_MATCH);
end;

//===========================================================================

function TRegexMatch.GetValue: Ansistring;

begin
  Result := InternalGetValue(CAPTURE_GROUP_ENTIRE_MATCH);
end;

//===========================================================================

{ TRegex }

constructor TRegex.Create(const Pattern       : ansistring;
                                Options       : TRegCompileOptions;
                          const Locale        : ansistring;
                                LocaleCategory: TRegexLocaleCategory);

begin
  inherited Create();

  FPattern    := Pattern;
  FOptions    := Options;
  FLocaleInfo := TRegexLocale.Create(Locale, LocaleCategory);

  CompilePattern();
  RetrieveNames();
end;

//===========================================================================

destructor TRegex.Destroy;

begin
  pcre_free_ex(FRegex);
  pcre_free_ex(FRegExtra);
  FLocaleInfo.Free();
  inherited;
end;

//===========================================================================

procedure TRegex.CompilePattern;

var
  Pcre            : TPcreH;
  CharTable       : TPcre_tableH;
  ErrMsg          : PAnsiChar;
  ErrOffs         : Integer;
  CompileOptions  : LongWord;

begin
  CharTable       := FLocaleInfo.CharTable;
  CompileOptions  := EncodeRegCompileOptions(FOptions);


  Pcre            := pcre_compile(PAnsiChar(FPattern),
                                  CompileOptions,
                                  ErrMsg,
                                  ErrOffs,
                                  CharTable);

  if Pcre = nil then
    raise ERegexException.CreateFmt('Invalid Pattern ''%s'': error at position %d: %s',
                                    [FPattern, ErrOffs, ErrMsg]);

  FRegex := Pcre;

  if not (rcoAnchored in GetOptions()) and (GetFirstChar() < 0) then
  begin
    FRegExtra := pcre_study(FRegex, 0, ErrMsg);

    if ErrMsg <> nil then
      raise ERegexException.CreateFmt('Failed to study pattern''%s'' : %s',
                                      [FPattern, ErrMsg]);
  end;
end;

//===========================================================================

procedure TRegex.RetrieveNames;

var
  NameCount     : Integer;
  NameEntrySize : Integer;
  Ptr           : PByte;
  Idx           : Word;
  i             : Integer;

begin
  FNames := TNameIndexLookup.Create();

  //get count of names
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_NAMECOUNT, NameCount));

  if NameCount <= 0 then
    Exit;

  //get size of name
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_NAMEENTRYSIZE, NameEntrySize));

  //get pointer to name table
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_NAMETABLE, Ptr));

  for i := 0 to NameCount - 1 do
  begin
    WordRec(Idx).Hi := Ptr^; Inc(Ptr);
    WordRec(Idx).Lo := Ptr^; Inc(Ptr);
    FNames.AddMapping(PAnsiChar(Ptr), Idx);
    Inc(Ptr, NameEntrySize - 2 );
  end;
end;

//===========================================================================

procedure TRegex.PcreCheck(ErrorCode: Integer);

begin
  if ErrorCode < 0 then
    case ErrorCode of
      PCRE_ERROR_NOMATCH        : raise ERegexException.Create('PCRE_ERROR_NOMATCH');
      PCRE_ERROR_NULL           : raise ERegexException.Create('PCRE_ERROR_NULL');
      PCRE_ERROR_BADOPTION      : raise ERegexException.Create('PCRE_ERROR_BADOPTION');
      PCRE_ERROR_BADMAGIC       : raise ERegexException.Create('PCRE_ERROR_BADMAGIC');
      PCRE_ERROR_UNKNOWN_NODE   : raise ERegexException.Create('PCRE_ERROR_UNKNOWN_NODE');
      PCRE_ERROR_NOMEMORY       : raise ERegexException.Create('PCRE_ERROR_NOMEMORY');
      PCRE_ERROR_NOSUBSTRING    : raise ERegexException.Create('PCRE_ERROR_NOSUBSTRING');
      PCRE_ERROR_BADUTF8        : raise ERegexException.Create('PCRE_ERROR_BADUTF8');
      PCRE_ERROR_BADUTF8_OFFSET : raise ERegexException.Create('PCRE_ERROR_BADUTF8_OFFSET');
      PCRE_ERROR_PARTIAL        : raise ERegexException.Create('PCRE_ERROR_PARTIAL');
      PCRE_ERROR_BADPARTIAL     : raise ERegexException.Create('PCRE_ERROR_BADPARTIAL');
      PCRE_ERROR_BADCOUNT       : raise ERegexException.Create('PCRE_ERROR_BADCOUNT');
      PCRE_ERROR_INTERNAL       : raise ERegexException.Create('PCRE_ERROR_INTERNAL');
      PCRE_ERROR_DFA_UITEM      : raise ERegexException.Create('PCRE_ERROR_DFA_UITEM');
      PCRE_ERROR_DFA_UCOND      : raise ERegexException.Create('PCRE_ERROR_DFA_UCOND');
      PCRE_ERROR_DFA_UMLIMIT    : raise ERegexException.Create('PCRE_ERROR_DFA_UMLIMIT');
      PCRE_ERROR_DFA_WSSIZE     : raise ERegexException.Create('PCRE_ERROR_DFA_WSSIZE');
      PCRE_ERROR_DFA_RECURSE    : raise ERegexException.Create('PCRE_ERROR_DFA_RECURSE');
      PCRE_ERROR_RECURSIONLIMIT : raise ERegexException.Create('PCRE_ERROR_RECURSIONLIMIT');
      PCRE_ERROR_NULLWSLIMIT    : raise ERegexException.Create('PCRE_ERROR_NULLWSLIMIT');
      PCRE_ERROR_BADNEWLINE     : raise ERegexException.Create('PCRE_ERROR_BADNEWLINE');            
    else
      raise ERegexException.CreateFmt('Unknown PCRE error code %d', [ErrorCode]);
    end;
end;

//===========================================================================

function TRegex.GetBackRefMax: Integer;

var
  Value: Integer;

begin
  Value := 0;
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_BACKREFMAX, Value));
  Result := Value;
end;

//===========================================================================

function TRegex.GetCaptureCount: Integer;

var
  Value: Integer;

begin
  Value := 0;
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_CAPTURECOUNT, Value));
  Result := Value;
end;

//===========================================================================

function TRegex.GetCompiledSize: Cardinal;

var
  Value: Cardinal;

begin
  Value := 0;
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_SIZE, Value));
  Result := Value;
end;

//===========================================================================

function TRegex.GetFirstChar: Integer;

var
  Value: Integer;

begin
  Value := 0;
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_FIRSTCHAR, Value));
  Result := Value;
end;

//===========================================================================

function TRegex.GetFirstTable: Pointer;

var
  Value: Pointer;

begin
  Value := nil;
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_FIRSTTABLE, Value));
  Result := Value;
end;

//===========================================================================

function TRegex.GetLastLiteral: Integer;

var
  Value: Integer;

begin
  Value := -1;
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_LASTLITERAL, Value));
  Result := Value;
end;

//===========================================================================

function TRegex.GetLocale: ansistring;

begin
  Result := FLocaleInfo.Locale;
end;

//===========================================================================

function TRegex.GetOptions: TRegCompileOptions;

var
  Value  : LongWord;

begin
  Value := 0;
  PcreCheck(pcre_fullinfo(FRegex, FRegExtra, PCRE_INFO_OPTIONS, Value));
  Result := DecodeRegCompileOptions(Value);
end;

//===========================================================================

function TRegex.GetPattern: ansistring;

begin
  Result := FPattern;
end;

//===========================================================================

function TRegex.IsMatch(const Input: ansistring): Boolean;

begin
  Result := Match(Input).Success;
end;

//===========================================================================

function TRegex.IsMatch(const Input: ansistring; Start: Integer): Boolean;

begin
  Result := Match(Input, Start).Success;
end;

//===========================================================================

function TRegex.IsMatch(const Input: ansistring; Options: TRegMatchOptions): Boolean;

begin
  Result := Match(Input, Options).Success;
end;

//===========================================================================

function TRegex.IsMatch(const Input: ansistring; Start: Integer; Options: TRegMatchOptions): Boolean;

begin
  Result := Match(Input, Start, Options).Success;
end;

//===========================================================================

function TRegex.Match(const Input: ansistring): IMatch;

begin
  Result := Match(Input, 0, []);
end;

//===========================================================================

function TRegex.Match(const Input: ansistring; Options: TRegMatchOptions): IMatch;

begin
  Result := Match(Input, 0, Options);
end;

//===========================================================================

function TRegex.Match(const Input: ansistring; Start: Integer): IMatch;

begin
  Result := Match(Input, Start, []);
end;

//===========================================================================

function TRegex.Match(const Input: ansistring; Start: Integer; Options: TRegMatchOptions): IMatch;

var
  ErrorCode : Integer;
  OVector   : TOvector;

begin
  OVector  := nil;

  // NOTE:
  //
  //  If you are wondering whether the
  //
  //    (Start <= Length(Input))
  //
  //  condition should instead be
  //
  //    (Start < Length(Input))
  //
  //  This is NOT an off-by-one error: we need to be
  //  able to evaluate an empty string against an empty
  //  pattern and get a succesful match.
  //
  //  Also note that an empty pattern evaluated against
  //  a string matches both at the Start
  //  and PAST the end of the string (and in case you wonder
  //  an empty pattern need not be '', in fact '\s*' can match
  //  the empty string as well).
  //
  if (Start >= 0) and (Start <= Length(Input)) then
  begin
    SetLength(OVector, (GetCaptureCount + 1) * 3);

    ErrorCode := pcre_exec(FRegex,
                           FRegExtra,
                           PAnsiChar(Input),
                           Length(Input),
                           Start,
                           EncodeRegMatchOptions(Options),
                           @OVector[0],
                           Length(OVector));

    if ErrorCode = PCRE_ERROR_NOMATCH then
      OVector := nil
    else
      PcreCheck(ErrorCode);
  end;

  Result := TRegexMatch.Create(Input, OVector, FNames) as IMatch;
end;

//===========================================================================

function TRegex.Matches(const Input: ansistring): IMatchCollection;

begin
  Result := Matches(Input, []);
end;

//===========================================================================

function TRegex.Matches(const Input: ansistring; Options: TRegMatchOptions): IMatchCollection;

var
  theCollection: TRegexMatchCollection;

begin
  theCollection := TRegexMatchCollection.Create;
  Result        := theCollection as IMatchCollection;
  Grep(Input, Options, theCollection.Add);
end;

//===========================================================================

function TRegex.Replace(const Input, Replacement: ansistring): ansistring;

begin
  Result := Replace(Input, Replacement, []);
end;

//===========================================================================

function TRegex.Replace(const Input: ansistring; Evaluator: TRegexMatchEvaluator): ansistring;

begin
  Result := Replace(Input, Evaluator, []);
end;

//===========================================================================

function TRegex.Replace(const Input, Replacement  : ansistring;
                              MatchOptions        : TRegMatchOptions): ansistring;

var
  theOffset     : Integer;
  theToken      : ansistring;
  theMatch      : IMatch;
  firstPosition : Integer;
  lastPosition  : Integer;

begin
  Result        := '';
  theOffset     := 0;
  firstPosition := 0;
  theMatch      := Match(Input, theOffset, MatchOptions);

  while theMatch.Matched do
  begin
    lastPosition    := theMatch.Index;
    theToken        := System.Copy(Input, firstPosition + 1, lastPosition - firstPosition);

    if Length(theToken) <> 0 then
      Result := Result + theToken;

    Result          := Result + Substitute(Replacement, theMatch);
    
    firstPosition   := theMatch.Index + theMatch.Length;
    theOffset       := Max(firstPosition, theMatch.Index + 1);
    theMatch        := Match(Input, theOffset, MatchOptions);
  end;

  theToken := System.Copy(Input, firstPosition + 1, MaxInt);

  if Length(theToken) <> 0 then
    Result := Result + theToken;
end;

//===========================================================================

function TRegex.Replace(const Input         : ansistring;
                              Evaluator     : TRegexMatchEvaluator;
                              MatchOptions  : TRegMatchOptions): ansistring;

var
  theOffset     : Integer;
  theToken      : ansistring;
  theMatch      : IMatch;
  firstPosition : Integer;
  lastPosition  : Integer;

begin
  if not Assigned(Evaluator) then
  begin
    Result := Input;
    Exit;
  end;

  Result        := '';
  theOffset     := 0;
  firstPosition := 0;
  theMatch      := Match(Input, theOffset, MatchOptions);

  while theMatch.Matched do
  begin
    lastPosition    := theMatch.Index;
    theToken        := System.Copy(Input, firstPosition + 1, lastPosition - firstPosition);

    if Length(theToken) <> 0 then
      Result := Result + theToken;

    Result          := Result + Evaluator(theMatch);
    firstPosition   := theMatch.Index + theMatch.Length;
    theOffset       := Max(firstPosition, theMatch.Index + 1);
    theMatch        := Match(Input, theOffset, MatchOptions);
  end;

  theToken := System.Copy(Input, firstPosition + 1, MaxInt);

  if Length(theToken) <> 0 then
    Result := Result + theToken;
end;

//===========================================================================

function TRegex.Split(const Input: ansistring): IStringCollection;

begin
  Result := Split(Input, [], []);
end;

//===========================================================================

function TRegex.Split(const Input: ansistring; Options: TRegSplitOptions): IStringCollection;

begin
  Result := Split(Input, Options, []);
end;

//===========================================================================

function TRegex.Split(const Input         : ansistring;
                            Options       : TRegSplitOptions;
                            MatchOptions  : TRegMatchOptions): IStringCollection;
var
  theCollection : TRegexStringCollection;
  theOffset     : Integer;
  theToken      : ansistring;
  theMatch      : IMatch;
  hasGroups     : Boolean;
  firstPosition : Integer;
  lastPosition  : Integer;
  n             : Integer;
begin
  theCollection := TRegexStringCollection.Create;
  Result        := theCollection as IStringCollection;
  hasGroups     := GetCaptureCount() > 0;
  theOffset     := 0;
  firstPosition := 0;
  theMatch      := Match(Input, theOffset, MatchOptions);

  while theMatch.Matched do
  begin
    lastPosition  := theMatch.Index;
    theToken      := System.Copy(Input, firstPosition + 1, lastPosition - firstPosition);

    theCollection.Add(theToken);

    if (rsoIncludeSeparators in Options) then
      theCollection.Add(theMatch.Value);

    if hasGroups then
    begin
      for n := 1 to theMatch.Groups.Count - 1 do
        if theMatch.Groups[n].Matched then
          theCollection.Add(theMatch.Groups[n].Value);
    end;

    firstPosition := theMatch.Index + theMatch.Length;
    theOffset     := Max(firstPosition, theMatch.Index + 1);
    theMatch      := Match(Input, theOffset, MatchOptions);
  end;

  theToken := System.Copy(Input, firstPosition + 1, MaxInt);

  theCollection.Add(theToken);
end;

//===========================================================================

procedure TRegex.Grep(const Input: ansistring; OnMatch: TRegexMatchEvent);
begin
  Grep(Input, [], OnMatch);
end;

//===========================================================================

procedure TRegex.Grep(const Input: ansistring; Options: TRegMatchOptions; OnMatch: TRegexMatchEvent);

var
  theOffset : Integer;
  theMatch  : IMatch;

begin
  if not Assigned(OnMatch) then
    Exit;

  theOffset := 0;
  theMatch  := Match(Input, theOffset, Options);

  while theMatch.Matched do
  begin
    OnMatch(theMatch);
    theOffset  := Max(theMatch.Index + theMatch.Length, theOffset + 1);
    theMatch   := Match(Input, theOffset, Options);
  end;
end;

//===========================================================================

function TRegex.GetNamedGroup(Index: Integer): TNamedGroupInfo;

begin
  Result := FNames.GetMappingAt(Index);
end;

//===========================================================================

function TRegex.GetNamedGroupCount: Integer;

begin
  Result := FNames.GetMappingCount();
end;

//===========================================================================

function TRegex.DfaMatch(const Input: ansistring; Start: Integer;
  Options: TRegMatchOptions): IDfaMatchCollection;

var
  ErrorCode : Integer;
  OVector   : TOvector;
  WVector   : TOvector;
  VecLen    : Integer;

begin
  OVector := nil;
  WVector := nil;

  if (Start >= 0) and (Start <= Length(Input)) then
  begin
    VecLen := Max(10, 2 * (Length(Input) - Start + 1));
    SetLength(OVector, VecLen);
    SetLength(WVector, Max(100, Length(OVector)));

    ErrorCode := pcre_dfa_exec(FRegex,
                               FRegExtra,
                               PAnsiChar(Input),
                               Length(Input),
                               Start,
                               EncodeRegMatchOptions(Options),
                               @OVector[0],
                               Length(OVector),
                               @WVector[0],
                               Length(WVector));

    ASSERT(ErrorCode <> 0);

    if ErrorCode > 0 then
      SetLength(OVector, 2 * ErrorCode)
    else if ErrorCode = PCRE_ERROR_NOMATCH then
      OVector := nil
    else
      PcreCheck(ErrorCode);
  end;

  Result := TDfaMatchCollection.Create(Input, OVector) as IDfaMatchCollection;
end;

//===========================================================================

function TRegex.DfaMatch(const Input: ansistring;
  Start: Integer): IDfaMatchCollection;

begin
  Result := DfaMatch(Input, Start, []);
end;

//===========================================================================

function TRegex.DfaMatch(const Input: ansistring;
  Options: TRegMatchOptions): IDfaMatchCollection;

begin
  Result := DfaMatch(Input, 0, Options);
end;

//===========================================================================

function TRegex.DfaMatch(const Input: ansistring): IDfaMatchCollection;

begin
  Result := DfaMatch(Input, 0, []);
end;

//===========================================================================

{ TNameIndexLookup }

constructor TNameIndexLookup.Create;

begin
  inherited Create();
  FMappings := TAnsiStringList.Create();

  FMappings.Sorted         := true;
  FMappings.CaseSensitive  := true;
  FMappings.Duplicates     := dupError;
end;

//===========================================================================

destructor TNameIndexLookup.Destroy;

begin
  FMappings.Free;
  inherited Destroy;
end;

//===========================================================================

procedure TNameIndexLookup.AddMapping(const theName: ansistring; theIndex: Integer);

begin
  FMappings.AddObject(theName, Pointer(theIndex));
end;

//===========================================================================

function TNameIndexLookup.GetGroupIndex(const theName: ansistring): Integer;

var
  theIndex : Integer;

begin
  if not FMappings.Find(theName, theIndex) then
    raise ERegexBadGroupName.CreateFmt('Invalid group name ''%s''', [theName]);

  Result := Integer(FMappings.Objects[theIndex]);
end;

//===========================================================================

function TNameIndexLookup.GetMappingAt(theIndex: Integer): TNamedGroupInfo;

begin
  Result.Name   := FMappings[theIndex];
  Result.Index  := Integer(FMappings.Objects[theIndex]);
end;

//===========================================================================

function TNameIndexLookup.GetMappingCount: Integer;

begin
  Result := FMappings.Count;
end;

//===========================================================================

{ TDfaMatch }

constructor TDfaMatch.Create(
  MatchCollection: TDfaMatchCollection;
  Index: Integer);

begin
  inherited Create();
  FMatchCollection := MatchCollection;
  FIndex           := Index;
end;

//===========================================================================

destructor TDfaMatch.Destroy;

begin
  inherited;
end;

//===========================================================================

function TDfaMatch.GetIndex: Integer;

begin
  Result := FMatchCollection.InternalGetIndex(FIndex);
end;

//===========================================================================

function TDfaMatch.GetValue: ansistring;

begin
  Result := FMatchCollection.InternalGetValue(FIndex);
end;

//===========================================================================

function TDfaMatch.GetLength: Integer;

begin
  Result := FMatchCollection.InternalGetLength(FIndex);
end;

//===========================================================================

{ TDfaMatchCollection }

constructor TDfaMatchCollection.Create(const S: ansistring; var VOffset: TOVector);

begin
  inherited Create();

  FSubject := S;
  FMatches := VOffset;

  if Assigned(FMatches) then
    FCount := Length(FMatches) div 2;

  ASSERT(((FCount <> 0) and (FMatches <> nil)) or ((FCount = 0) and (FMatches = nil)));
  ASSERT((FMatches = nil) or (Length(FMatches) mod 2 = 0));
end;

//===========================================================================

destructor TDfaMatchCollection.Destroy;

begin
  FMatches := nil; 
  inherited;
end;

//===========================================================================

function TDfaMatchCollection.GetCount: Integer;

begin
  Result := FCount;
end;

//===========================================================================

function TDfaMatchCollection.InternalGetIndex(Index: Integer): Integer;

var
  MatchPos : TMatchPos;

begin
  MatchPos := InternalGetMatchPos(Index);
  Result   := MatchPos.First;
end;

//===========================================================================

function TDfaMatchCollection.InternalGetValue(Index: Integer): ansistring;

var
  MatchPos: TMatchPos;

begin
  Result := '';

  MatchPos := InternalGetMatchPos(Index);

  if MatchPos.First <> INVALID_INDEX_VALUE then
  begin
    Result := System.Copy(FSubject,
                          MatchPos.First + 1,
                          MatchPos.Last - MatchPos.First);
  end;
end;

//===========================================================================

function TDfaMatchCollection.GetItem(Index: Integer): IDfaMatch;

begin
  Result := TDfaMatch.Create(Self, Index) as IDfaMatch;
end;

//===========================================================================

function TDfaMatchCollection.InternalGetLength(Index: Integer): Integer;

var
  MatchPos : TMatchPos;

begin
  MatchPos := InternalGetMatchPos(Index);
  Result   := MatchPos.Last - MatchPos.First;
end;

//===========================================================================

function TDfaMatchCollection.InternalGetMatchPos(Index: Integer): TMatchPos;

begin
  // assume failure
  Result.First := INVALID_INDEX_VALUE;
  Result.Last  := INVALID_INDEX_VALUE;

  // if no matches return
  if (FCount = 0) or (FMatches[0] = INVALID_INDEX_VALUE) then
    Exit;

  if (Index >= 0) and (Index < FCount) then
  begin
    // take values from OVector
    Result.First := FMatches[Index * 2];
    Result.Last  := FMatches[Index * 2 + 1];
  end
  else if Index = CAPTURE_GROUP_BEFORE_START then
  begin
    // return index from the Start of the string to
    // the Start of the match
    Result.First := 0;
    Result.Last  := FMatches[0];
  end
  else if Index = CAPTURE_GROUP_AFTER_END then
  begin
    // return everything from the end of the match
    // until the end of the subject string
    Result.First := FMatches[1];
    Result.Last  := Length(FSubject);
  end;
end;

//===========================================================================

initialization
  LocaleLock      := TCriticalSection.Create();
  RegexSubstitute := TRegex.Create('\$(\d+|\$|&|`|''''|\+|_|{([^}]*)})', [], 'C');

finalization
  RegexSubstitute.Free();
  LocaleLock.Free();
end.

