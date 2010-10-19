// $Id: pcre_dll.pas,v 1.21 2005/06/29 23:04:28 Renato Exp $
// 2006/10/21
// Static Link Version by Do-wan Kim    
// Refine isxxxx functions
// 2007/05/19
// converted to pcre 7.1
// sync some constant with pcre.h
// fix bug in isspace() function
//


{**************************************************************}
{                                                              }
{  Borland Delphi Import Unit for Philip Hazel's PCRE 6.1      }
{    library                                                   }
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
{ To do :                                                      }
{   SetLocale Implementation                                   }

{.$define USE_MSVCRT}


unit pcre_dll;

{$ALIGN ON}
{$MINENUMSIZE 4}

// OBJ files, do not reorder them.
{$L pcreposix}
{$L pcre_exec.obj}
{$L pcre_compile.obj}
{$L pcre_config.obj}
{$L pcre_dfa_exec.obj}
{$L pcre_get.obj}
{$L pcre_study.obj}
{$L pcre_info.obj}
{$L pcre_fullinfo.obj}
{$L pcre_refcount.obj}
{$L pcre_ucd.obj}
{$L pcre_try_flipped.obj}
{$L pcre_valid_utf8.obj}
{$L pcre_maketables.obj}
{$L pcre_version.obj}
{$L pcre_xclass.obj}
{$L pcre_ord2utf8.obj}
{$L pcre_globals.obj}
{$L pcre_tables.obj}
{$L pcre_newline.obj}
{$L pcre_chartables.obj}


interface

//===========================================================================
//                              Native API
//===========================================================================

const
  (*
  --- Options used with pcre_compile ---

  PCRE_ANCHORED
    If this bit is set, the pattern is forced to be "anchored",
    that is, it is constrained to match only at the start of the
    string which is being searched (the "subject string").
    This effect can also be achieved by appropriate constructs in the
    pattern itself, which is the only way to do it in Perl.

  PCRE_AUTO_CALLOUT    
    If this bit is set, pcre_compile() automatically inserts callout items,
    all with number 255, before each pattern item.
    For discussion of the callout facility, see the pcrecallout documentation.

  PCRE_CASELESS
    If this bit is set, letters in the pattern match both upper and lower
    case letters. It is equivalent to Perl's /i option.

  PCRE_DOLLAR_ENDONLY
    If this bit is set, a dollar metacharacter in the pattern matches
    only at the end of the subject string.
    Without this option, a dollar also matches immediately before
    the final character if it is a newline (but not before any other newlines).
    The PCRE_DOLLAR_ENDONLY option is ignored if PCRE_MULTILINE is set.
    There is no equivalent to this option in Perl.

  PCRE_DOTALL
    If this bit is set, a dot metacharater in the pattern matches all
    characters, including newlines. Without it, newlines are excluded.
    This option is equivalent to Perl's /s option.
    A negative class such as [^a] always matches a newline character,
    independent of the setting of this option.

  PCRE_EXTENDED
    If this bit is set, whitespace data characters in the pattern are
    totally ignored except when escaped or inside a character class,
    and characters between an unescaped # outside a character class
    and the next newline character, inclusive, are also ignored.
    This is equivalent to Perl's /x option, and makes it possible to
    include comments inside complicated patterns.
    Note, however, that this applies only to data characters.
    Whitespace characters may never appear within special character sequences
    in a pattern, for example within the sequence
    (?( which introduces a conditional subpattern.

  PCRE_EXTRA
    This option was invented in order to turn on additional functionality
    of PCRE that is incompatible with Perl, but it is currently of very
    little use. When set, any backslash in a pattern that is followed by a
    letter that has no special meaning causes an error, thus reserving
    these combinations for future expansion.
    By default, as in Perl, a backslash followed by a letter with no
    special meaning is treated as a literal.
    There are at present no other features controlled by this option.
    It can also be set by a (?X) option setting within a pattern.

  PCRE_FIRSTLINE
    If this option is set, an unanchored pattern is required to match
    before or at the first newline character in the subject string,
    though the matched text may continue over the newline.

  PCRE_MULTILINE
    By default, PCRE treats the subject string as consisting of a single "line"
    of characters (even if it actually contains several newlines).
    The "start of line" metacharacter (^) matches only at the start of
    the string, while the "end of line" metacharacter ($) matches only
    at the end of the string, or before a terminating newline
    (unless PCRE_DOLLAR_ENDONLY is set). This is the same as Perl.
    When PCRE_MULTILINE it is set, the "start of line" and "end of line"
    constructs match immediately following or immediately before any
    newline in the subject string, respectively, as well as at the very
    start and end.
    This is equivalent to Perl's /m option.
    If there are no "\n" characters in a subject string, or no occurrences
    of ^ or $ in a pattern, setting PCRE_MULTILINE has no effect.

  PCRE_NO_AUTO_CAPTURE
    If this option is set, it disables the use of numbered capturing
    parentheses in the pattern. Any opening parenthesis that is not
    followed by ? behaves as if it were followed by ?: but named
    parentheses can still be used for capturing
    (and they acquire numbers in the usual way).
    There is no equivalent of this option in Perl.

  PCRE_UNGREEDY
    This option inverts the "greediness" of the quantifiers so that they are
    not greedy by default, but become greedy if followed by "?".
    It is not compatible with Perl.
    It can also be set by a (?U) option setting within the pattern.

  PCRE_UTF8
    This option causes PCRE to regard both the pattern and the subject as
    strings of UTF-8 characters instead of single-byte character strings.
    However, it is available only if PCRE has been built to include UTF-8 support.
    If not, the use of this option provokes an error.

  PCRE_NO_UTF8_CHECK
    When PCRE_UTF8 is set, the validity of the pattern as a UTF-8 string is
    automatically checked. If an invalid UTF-8 sequence of bytes is found,
    pcre_compile() returns an error.
    If you already know that your pattern is valid, and you want to skip this
    check for performance reasons, you can set the PCRE_NO_UTF8_CHECK option.
    When it is set, the effect of passing an invalid UTF-8 string as a pattern
    is undefined. It may cause your program to crash.
    Note that there is a similar option for suppressing the checking of subject
    strings passed to pcre_exec().

  --- Options that can be used with pcre_exec ---

  PCRE_ANCHORED

  PCRE_NOTBOL
    The first character of the string is not the beginning of a line,
    so the circumflex metacharacter should not match before it.
    Setting this without PCRE_MULTILINE (at compile time) causes
    circumflex never to match.

  PCRE_NOTEOL
    The end of the string is not the end of a line, so the dollar
    metacharacter should not match it nor (except in multiline mode) a
    newline immediately before it.
    Setting this without PCRE_MULTILINE (at compile time)
    causes dollar never to match.

  PCRE_NOTEMPTY
    An empty string is not considered to be a valid match if this option is set.
    If there are alternatives in the pattern, they are tried.
    If all the alternatives match the empty string, the entire match
    fails. For example, if the pattern

      a?b?

    is applied to a string not beginning with "a" or "b", it matches
    the empty string at the start of the subject.
    With PCRE_NOTEMPTY set, this match is not valid, so PCRE searches
    further into the string for occurrences of "a" or "b".

  PCRE_NO_UTF8_CHECK

  PCRE_PARTIAL
    This option turns on the partial matching feature.
    If the subject string fails to match the pattern, but at some point during
    the matching process the end of the subject was reached (that is, the
    subject partially matches the pattern and the failure to match occurred only
    because there were not enough subject characters), pcre_exec() returns
    PCRE_ERROR_PARTIAL instead of PCRE_ERROR_NOMATCH.
    When PCRE_PARTIAL is used, there are restrictions on what may appear in
    the pattern. These are discussed in the pcrepartial documentation.

  --- Options that can be used with pcre_dfa_exec ---

  PCRE_ANCHORED      Match only at the first position
  PCRE_NOTBOL        Subject is not the beginning of a line
  PCRE_NOTEOL        Subject is not the end of a line
  PCRE_NOTEMPTY      An empty string is not a valid match
  PCRE_NO_UTF8_CHECK Do not check the subject for UTF-8
                       validity (only relevant if PCRE_UTF8
                       was set at compile time)
  PCRE_PARTIAL       Return PCRE_ERROR_PARTIAL for a partial match
  PCRE_DFA_SHORTEST  Return only the shortest match
  PCRE_DFA_RESTART   This is a restart after a partial match

  *)

  // Options

  PCRE_CASELESS             = $00000001;  // case insensitive: same as Perl /i
  PCRE_MULTILINE            = $00000002;  // same as Perl /m option
  PCRE_DOTALL               = $00000004;  // same as Perl /s option
  PCRE_EXTENDED             = $00000008;  // same as Perl /x option
  PCRE_ANCHORED             = $00000010;
  PCRE_DOLLAR_ENDONLY       = $00000020;
  PCRE_EXTRA                = $00000040;  // turn ON pcre functionality incompatible with Perl
  PCRE_NOTBOL               = $00000080;
  PCRE_NOTEOL               = $00000100;
  PCRE_UNGREEDY             = $00000200;  // make the match ungreedy: incompatible with Perl
  PCRE_NOTEMPTY             = $00000400;
  PCRE_UTF8                 = $00000800;  // evaluate both the pattern and the subject as UTF8 strings
  PCRE_NO_AUTO_CAPTURE      = $00001000;  // disables the use of numbered capturing
  PCRE_NO_UTF8_CHECK        = $00002000;  // skip validity check for UTF8 pattern
  PCRE_AUTO_CALLOUT         = $00004000;  // automatically insert callout items
  PCRE_PARTIAL              = $00008000;  // turns on partial matching
  PCRE_DFA_SHORTEST         = $00010000;  // return only the shortest match
  PCRE_DFA_RESTART          = $00020000;  // this is a restart after a partial match
  PCRE_FIRSTLINE            = $00040000;  // force matching to be before newline
  PCRE_DUPNAMES             = $00080000;  // DW 7.1
  PCRE_NEWLINE_CR           = $00100000;
  PCRE_NEWLINE_LF           = $00200000;
  PCRE_NEWLINE_CRLF         = $00300000;
  PCRE_NEWLINE_ANY          = $00400000;
  PCRE_NEWLINE_ANYCRLF      = $00500000;
  PCRE_BSR_ANYCRLF          = $00800000;
  PCRE_BSR_UNICODE          = $01000000;
  
  

  // Exec-time and get-time error codes
  PCRE_ERROR_NOMATCH        = -1;
  PCRE_ERROR_NULL           = -2;
  PCRE_ERROR_BADOPTION      = -3;
  PCRE_ERROR_BADMAGIC       = -4;
  PCRE_ERROR_UNKNOWN_NODE   = -5;
  PCRE_ERROR_NOMEMORY       = -6;
  PCRE_ERROR_NOSUBSTRING    = -7;
  PCRE_ERROR_MATCHLIMIT     = -8;
  PCRE_ERROR_CALLOUT        = -9; // never used by PCRE itself
  PCRE_ERROR_BADUTF8        = -10;
  PCRE_ERROR_BADUTF8_OFFSET = -11;
  PCRE_ERROR_PARTIAL        = -12;
  PCRE_ERROR_BADPARTIAL     = -13;
  PCRE_ERROR_INTERNAL       = -14;
  PCRE_ERROR_BADCOUNT       = -15;
  PCRE_ERROR_DFA_UITEM      = -16;
  PCRE_ERROR_DFA_UCOND      = -17;
  PCRE_ERROR_DFA_UMLIMIT    = -18;
  PCRE_ERROR_DFA_WSSIZE     = -19;
  PCRE_ERROR_DFA_RECURSE    = -20;
  PCRE_ERROR_RECURSIONLIMIT = -21;
  PCRE_ERROR_NULLWSLIMIT    = -22; // actually not used
  PCRE_ERROR_BADNEWLINE     = -23;
  

  // Request types for pcre_fullinfo()
  PCRE_INFO_OPTIONS         = 0;
  PCRE_INFO_SIZE            = 1;
  PCRE_INFO_CAPTURECOUNT    = 2;
  PCRE_INFO_BACKREFMAX      = 3;
  PCRE_INFO_FIRSTCHAR       = 4;
  PCRE_INFO_FIRSTTABLE      = 5;
  PCRE_INFO_LASTLITERAL     = 6;
  PCRE_INFO_FIRSTBYTE       = 4;
  PCRE_INFO_NAMEENTRYSIZE   = 7;
  PCRE_INFO_NAMECOUNT       = 8;
  PCRE_INFO_NAMETABLE       = 9;
  PCRE_INFO_STUDYSIZE       = 10;
  PCRE_INFO_DEFAULT_TABLES  = 11;
  PCRE_INFO_OKPARTIAL       = 12; //DW 7.2
  PCRE_INFO_JCHANGED        = 13; //DW 7.2
  PCRE_INFO_HASCRORLF       = 14; //DW 7.6  
  

  // Request type for pcre_config()
  PCRE_CONFIG_UTF8                    = 0;
  PCRE_CONFIG_NEWLINE                 = 1;
  PCRE_CONFIG_LINK_SIZE               = 2;
  PCRE_CONFIG_POSIX_MALLOC_THRESHOLD  = 3;
  PCRE_CONFIG_MATCH_LIMIT             = 4;
  PCRE_CONFIG_STACKRECURSE            = 5;
  PCRE_CONFIG_UNICODE_PROPERTIES      = 6;
  PCRE_CONFIG_MATCH_LIMIT_RECURSION   = 7; //DW 7.1
  PCRE_CONFIG_BSR                     = 8; //DW 7.6

  // Bit flags for the pcre_extra structure
  PCRE_EXTRA_STUDY_DATA               = $0001;
  PCRE_EXTRA_MATCH_LIMIT              = $0002;
  PCRE_EXTRA_CALLOUT_DATA             = $0004;
  PCRE_EXTRA_TABLES                   = $0008;
  PCRE_EXTRA_MATCH_LIMIT_RECURSION    = $0010;  //DW 7.1

type
  // Pseudo classes (handles)
  TPcreH       = class end;
  TPcre_extraH = class end;
  TPcre_tableH = class end;

type
  PLongWord   = ^LongWord;
  PPAnsiChar      = ^PAnsiChar;

const
  MAX_CAPTURING_SUBPATTERNS = 65535;

type
  PIntArray   = ^TIntArray;
  TIntArray   = array[0..((MAX_CAPTURING_SUBPATTERNS+1) * 3)-1] of Integer;

type
  // The structure for passing additional data to pcre_exec().
  // This is defined in such as way as to be extensible.

  TPcreExtra = record
    flags         : Cardinal;
    study_data    : Pointer;
    match_limit   : Cardinal;
    callout_data  : Pointer;
    tables        : PAnsiChar;  // Pointer to character tables
    match_limit_recursion: Cardinal; // Max recursive calls to match()
  end;

  // The structure for passing out data via the pcre_callout_function. We use a
  // structure so that new fields can be added on the end in future versions,
  // without changing the API of the function, thereby allowing old clients to work
  // without modification.

  pcre_callout_block = record
    version         : Integer;  // Identifies version of block
    // ------------------------ Version 0 -------------------------------
    callout_number  : Integer;  // Number compiled into pattern
    offset_vector   : PIntArray;// The offset vector
    subject         : PAnsiChar;    // The subject being matched
    subject_length  : Integer;  // The length of the subject
    start_match     : Integer;  // Offset to start of this match attempt
    current_position: Integer;  // Where we currently are
    capture_top     : Integer;  // Max current capture
    capture_last    : Integer;  // Most recently closed capture
    callout_data    : Pointer;  // Data passed in with the call
    // ------------------- Added for Version 1 --------------------------
    pattern_position: Integer;  // Offset to next item in the pattern
    next_item_length: Integer;  // Length of next item in the pattern    
  end;

  TPcreCalloutBlock    = pcre_callout_block;
  TPcreCalloutCallback = function(const theCalloutData: TPcreCalloutBlock): Integer; cdecl;

// Version information - removed
//function PCRE_MAJOR : Integer; cdecl;
//function PCRE_MINOR : Integer; cdecl;
//function PCRE_DATE  : PAnsiChar; cdecl;

//extern const char *pcre_version(void);
function pcre_version: PAnsiChar; cdecl;

// Memory management

type
  TPcreMemAlloc = function(amount: Cardinal): Pointer; cdecl;
  TPcreMemFree = procedure(P: Pointer); cdecl;
  TPcreStackAlloc = function(amount: Cardinal): Pointer; cdecl;
  TPcreStackMemFree = procedure(P: Pointer); cdecl;

(* function pcre_set_malloc(Func: TPcreMemAlloc): TPcreMemAlloc; cdecl;
function pcre_set_free(Proc: TPcreMemFree): TPcreMemFree; cdecl;
function pcre_set_stack_malloc(Func: TPcreMemAlloc): TPcreMemAlloc; cdecl;
function pcre_set_stack_free(Proc: TPcreMemFree): TPcreMemFree; cdecl; *)

//function  pcre_malloc_ex(size: LongWord): Pointer; cdecl;
procedure pcre_free_ex(P: Pointer); cdecl;

// Callout management
//function pcre_set_callout_handler(Func: TPcreCalloutCallback): TPcreCalloutCallback; cdecl;

// Locale management
const
  // Locale categories (from <locale.h>)
  LC_ALL                    = 0;
  LC_COLLATE                = 1;
  LC_CTYPE                  = 2;
  LC_MONETARY               = 3;
  LC_NUMERIC                = 4;
  LC_TIME                   = 5;

function pcre_setlocale(category: Integer; locale: PAnsiChar): PAnsiChar; stdcall;

function pcre_isalnum(c: AnsiChar): Boolean;
function pcre_isalpha(c: AnsiChar): Boolean;
function pcre_iscntrl(c: AnsiChar): Boolean;
function pcre_isdigit(c: AnsiChar): Boolean;
function pcre_isgraph(c: AnsiChar): Boolean;
function pcre_islower(c: AnsiChar): Boolean;
function pcre_isprint(c: AnsiChar): Boolean;
function pcre_ispunct(c: AnsiChar): Boolean;
function pcre_isspace(c: AnsiChar): Boolean;
function pcre_isupper(c: AnsiChar): Boolean;
function pcre_isxdigit(c: AnsiChar): Boolean;

//extern const unsigned char *pcre_maketables(void);
function pcre_maketables: TPcre_tableH; cdecl;

//extern pcre *pcre_compile(const char *, int, const char **, int *,
//              const unsigned char *);
function pcre_compile( pattern        : PAnsiChar;
                       options        : LongWord;
                       out errptr     : PAnsiChar;
                       out erroffset  : Integer;
                       tableptr       : TPcre_tableH = nil ): TPcreH; cdecl;

// extern pcre *pcre_compile2(const char *, int, int *, const char **,
//                  int *, const unsigned char *);
function pcre_compile2( pattern         : PAnsiChar;
                       options          : LongWord;
                       out errorcodeptr : Integer;
                       out errptr       : PAnsiChar;
                       out erroffset    : Integer;
                       tableptr         : TPcre_tableH = nil ): TPcreH; cdecl;

//extern pcre_extra *pcre_study(const pcre *, int, const char **);
function pcre_study( pcre             : TPcreH;
                     options          : LongWord;  // must be set to 0
                     out errptr       : PAnsiChar ): TPcre_extraH; cdecl;

//extern int  pcre_info(const pcre *, int *, int *);
function pcre_info( pcre              : TPcreH;
                    optptr            : PLongWord = nil;
                    firstcharptr      : PPAnsiChar    = nil ): Integer; cdecl;

//extern int  pcre_fullinfo(const pcre *, const pcre_extra *, int, void *);
function pcre_fullinfo( pattern       : TPcreH;
                        pcre_extra    : TPcre_extraH;
                        what          : Integer;
                        out where                 ): Integer; cdecl;

//extern int  pcre_exec(const pcre *, const pcre_extra *, const char *,
//              int, int, int, int *, int);
//
// Captured substrings are returned to the caller via a vector of integer
// offsets whose address is passed in ovector.
// The number of elements in the vector is passed in ovecsize.
// The first two-thirds of the vector is used to pass back captured substrings,
// each substring using a pair of integers.
// The remaining third of the vector is used as workspace by pcre_exec()
// while matching capturing subpatterns, and is not available for passing back
// information.
// The length passed in ovecsize should always be a multiple of three.
// If it is not, it is rounded down.
//
// Note that pcre_info() can be used to find out how many capturing subpatterns
// there are in a compiled pattern.
// The smallest size for ovector that will allow for n captured substrings
// in addition to the offsets of the substring matched by the whole pattern
//  is (n+1)*3.
//
// When a match has been successful, information about captured substrings is
// returned in pairs of integers, starting at the beginning of ovector,
// and continuing up to two-thirds of its length at the most.
// The first element of a pair is set to the offset of the first character in
// a substring, and the second is set to the offset of the first character after
// the end of a substring. The first pair, ovector[0] and ovector[1],
// identify the portion of the subject string matched by the entire pattern.
// The next pair is used for the first capturing subpattern, and so on.
// The value returned by pcre_exec() is the number of pairs that have been set.
// If there are no capturing subpatterns, the return value from a successful
// match is 1, indicating that just the first pair of offsets has been set.
//

function pcre_exec( pcre              : TPcreH;
                    pcre_extra        : TPcre_extraH;
                    subject           : PAnsiChar;
                    length            : Integer;
                    startoffset       : Integer;
                    options           : LongWord;
                    ovector           : PIntArray;
                    ovecsize          : Cardinal  ): Integer; cdecl;

// int pcre_dfa_exec(const pcre *code, const pcre_extra *extra,
//                   const char *subject, int length, int startoffset,
//                   int options, int *ovector, int ovecsize,
//                   int *workspace, int wscount);
//
//This function matches a compiled regular expression against a given subject string, using a DFA matching algorithm (not Perl-compatible). Note that the main, Perl-compatible, matching function is pcre_exec(). The arguments for this function are:
//
//  code         Points to the compiled pattern
//  extra        Points to an associated pcre_extra structure,
//                 or is NULL
//  subject      Points to the subject string
//  length       Length of the subject string, in bytes
//  startoffset  Offset in bytes in the subject at which to
//                 start matching
//  options      Option bits
//  ovector      Points to a vector of ints for result offsets
//  ovecsize     Number of elements in the vector
//  workspace    Points to a vector of ints used as working space
//  wscount      Number of elements in the vector
//
function pcre_dfa_exec( pcre          : TPcreH;
                        pcre_extra    : TPcre_extraH;
                        subject       : PAnsiChar;
                        length        : Integer;
                        startoffset   : Integer;
                        options       : LongWord;
                        ovector       : PIntArray;
                        ovecsize      : Cardinal;
                        workspace     : PIntArray;
                        wscount       : Cardinal ): Integer; cdecl;

//extern int  pcre_copy_substring(const char *, int *, int, int, char *, int);
function pcre_copy_substring( subject         : PAnsiChar;
                              ovector         : PIntArray;
                              stringcount     : Integer;
                              stringnumber    : Integer;
                              buffer          : PAnsiChar;
                              bufsize         : Integer ): Integer; cdecl;

//extern int  pcre_get_substring(const char *, int *, int, int, const char **);
function pcre_get_substring( subject          : PAnsiChar;
                             ovector          : PIntArray;
                             stringcount      : Integer;
                             stringnumber     : Integer;
                             out stringptr    : PAnsiChar ): Integer; cdecl;

//extern int  pcre_get_substring_list(const char *, int *, int, const char ***);
function pcre_get_substring_list( subject     : PAnsiChar;
                                  ovector     : PIntArray;
                                  stringcount : Integer;
                                  out listptr : PPAnsiChar ): Integer; cdecl;

//void pcre_free_substring(const char *stringptr);
procedure pcre_free_substring( stringptr: PAnsiChar ); cdecl;

//void pcre_free_substring_list(const char **stringptr);
procedure pcre_free_substring_list( stringptr: PPAnsiChar ); cdecl;

//extern int  pcre_config(int what, void * where);
function pcre_config( what            : Integer;
                      out where                 ): Integer; cdecl;

// extern int pcre_copy_named_substring(const pcre *code, const char *subject,
//      int *ovector, int stringcount, const char *stringname,
//      char *buffer, int buffersize);
function pcre_copy_named_substring( code        : TPcreH;
                                    subject     : PAnsiChar;
                                    ovector     : PIntArray;
                                    stringcount : Integer;
                                    stringname  : PAnsiChar;
                                    buffer      : PAnsiChar;
                                    buffersize  : Integer  ): Integer; cdecl;

//extern int pcre_get_named_substring(const pcre *code, const char *subject,
//      int *ovector, int stringcount, const char *stringname,
//      const char **stringptr);
function pcre_get_named_substring(  code        : TPcreH;
                                    subject     : PAnsiChar;
                                    ovector     : PIntArray;
                                    stringcount : Integer;
                                    stringname  : PAnsiChar;
                                    stringptr   : PPAnsiChar ): Integer; cdecl;

//extern int pcre_get_stringnumber(const pcre *code, const char *name);
function pcre_get_stringnumber(     code        : TPcreH;
                                    name        : PAnsiChar   ): Integer; cdecl;

//extern int  pcre_get_stringtable_entries(const pcre *, const char *,
//                  char **, char **);
function pcre_get_stringtable_entries(code      : TPcreH;
                                      name      : PAnsiChar;
                                      first     : PPAnsiChar;
                                      last      : PPAnsiChar ): Integer; cdecl;

// extern pcre_extra* pcre_set_match_limit(pcre_extra* extraptr, long value);
//function pcre_extra_set_match_limit(var pcre_extra: TPcre_extraH; value: Longint): Integer; cdecl;

//extern pcre_extra* pcre_extra_set_callout_data(pcre_extra* extraptr, void* data);
//function pcre_extra_set_callout_data(var pcre_extra: TPcre_extraH; Data: Pointer): Integer; cdecl;

//===========================================================================
//                            POSIX-style API
//===========================================================================

const
  // Options defined by POSIX with a couple of extra
  REG_ICASE     = $01;
  REG_NEWLINE   = $02;
  REG_NOTBOL    = $04;
  REG_NOTEOL    = $08;
  REG_DOTALL    = $10;
  REG_NOSUB     = $20;
  REG_UTF8      = $40;

  // These are not used by PCRE, but by defining them we make it easier
  // to slot PCRE into existing programs that make POSIX calls.
  REG_EXTENDED  = 0;

  // Error values. Not all these are relevant or used by the wrapper.
  REG_ASSERT    = 1;  // internal error ?
  REG_BADBR     = 2;  // invalid repeat counts in {}
  REG_BADPAT    = 3;  // pattern error
  REG_BADRPT    = 4;  // ? * + invalid
  REG_EBRACE    = 5;  // unbalanced {}
  REG_EBRACK    = 6;  // unbalanced []
  REG_ECOLLATE  = 7;  // collation error - not relevant
  REG_ECTYPE    = 8;  // bad class
  REG_EESCAPE   = 9;  // bad escape sequence
  REG_EMPTY     = 10; // empty expression
  REG_EPAREN    = 11; // unbalanced ()
  REG_ERANGE    = 12; // bad range inside []
  REG_ESIZE     = 13; // expression too big
  REG_ESPACE    = 14; // failed to get memory
  REG_ESUBREG   = 15; // bad back reference
  REG_INVARG    = 16; // bad argument
  REG_NOMATCH   = 17; // match failed

type
  // The structure representing a compiled regular expression.
  regex_t = record
    re_pcre       : Pointer;
    re_nsub       : Cardinal;
    re_erroffset  : Cardinal;
  end;

  // The structure in which a captured offset is returned.
  regmatch_t = record
    rm_so         : Integer;
    rm_eo         : Integer;
  end;

  regmatch_ptr = ^regmatch_t;

// The functions

//extern int regcomp(regex_t *, const char *, int);
function regcomp( out preg: regex_t; pattern: PAnsiChar; cflags: Cardinal): Integer; cdecl;

//int
//regexec(regex_t *preg, const char *string, size_t nmatch,
//  regmatch_t pmatch[], int eflags)

function regexec( var preg      : regex_t;
                  str           : PAnsiChar;
                  nmatch        : Cardinal;
                  pmatch        : regmatch_ptr;
                  eflags        : Cardinal): Integer; cdecl;

//size_t
//regerror(int errcode, const regex_t *preg, char *errbuf, size_t errbuf_size)
function regerror(errcode       : Integer;
                  var preg      : regex_t;
                  errbuf        : PAnsiChar;
                  errbuf_size   : Cardinal): Integer; cdecl;

//extern void regfree(regex_t *);
procedure regfree(var preg: regex_t); cdecl;
function _ltolower(c : integer):Integer; cdecl;
function _ltoupper(c : integer):Integer; cdecl;


implementation


uses sysutils, windows;

{$IFDEF USE_MSVCRT}
function _setlocale(category: Integer; locale: PAnsiChar):PAnsiChar; cdecl; external 'MSVCRT.DLL' name 'setlocale';
{$ENDIF}
// setlocale function
function pcre_setlocale(category: Integer; locale: PAnsiChar): PAnsiChar; stdcall;
begin
{$IFDEF USE_MSVCRT}
  result := _setlocale(category, locale);
{$ELSE}
  result := '';
{$ENDIF}  
end;

//function  pcre_malloc_ex(size: LongWord): Pointer; cdecl; external;// PCRE_DLL_NAME name 'pcre_malloc_ex';
procedure pcre_free_ex(P: Pointer); cdecl; // PCRE_DLL_NAME name 'pcre_free_ex';
begin
  freemem(P);
end;

function pcre_compile( pattern        : PAnsiChar;
                       options        : LongWord;
                       out errptr     : PAnsiChar;
                       out erroffset  : Integer;
                       tableptr       : TPcre_tableH = nil ): TPcreH; cdecl; external;// PCRE_DLL_NAME name 'pcre_compile';
function pcre_compile2( pattern         : PAnsiChar;
                       options          : LongWord;
                       out errorcodeptr : Integer;
                       out errptr       : PAnsiChar;
                       out erroffset    : Integer;
                       tableptr         : TPcre_tableH = nil ): TPcreH; cdecl; external;// PCRE_DLL_NAME name 'pcre_compile2';
function pcre_exec( pcre              : TPcreH;
                    pcre_extra        : TPcre_extraH;
                    subject           : PAnsiChar;
                    length            : Integer;
                    startoffset       : Integer;
                    options           : LongWord;
                    ovector           : PIntArray;
                    ovecsize          : Cardinal  ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_exec';
function pcre_dfa_exec( pcre          : TPcreH;
                        pcre_extra    : TPcre_extraH;
                        subject       : PAnsiChar;
                        length        : Integer;
                        startoffset   : Integer;
                        options       : LongWord;
                        ovector       : PIntArray;
                        ovecsize      : Cardinal;
                        workspace     : PIntArray;
                        wscount       : Cardinal ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_dfa_exec';
function pcre_study( pcre             : TPcreH;
                     options          : LongWord;  // must be set to 0
                     out errptr       : PAnsiChar ): TPcre_extraH; cdecl; external;// PCRE_DLL_NAME name 'pcre_study';
function pcre_info( pcre              : TPcreH;
                    optptr            : PLongWord = nil;
                    firstcharptr      : PPAnsiChar    = nil ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_info';
function pcre_fullinfo( pattern       : TPcreH;
                        pcre_extra    : TPcre_extraH;
                        what          : Integer;
                        out where                 ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_fullinfo';
function pcre_maketables: TPcre_tableH; cdecl; external;// PCRE_DLL_NAME name 'pcre_maketables';
function pcre_version: PAnsiChar; cdecl; external; // // PCRE_DLL_NAME name 'pcre_version';
function pcre_get_substring( subject          : PAnsiChar;
                             ovector          : PIntArray;
                             stringcount      : Integer;
                             stringnumber     : Integer;
                             out stringptr    : PAnsiChar ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_get_substring';
function pcre_get_substring_list( subject     : PAnsiChar;
                                  ovector     : PIntArray;
                                  stringcount : Integer;
                                  out listptr : PPAnsiChar ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_get_substring_list';
function pcre_copy_substring( subject         : PAnsiChar;
                              ovector         : PIntArray;
                              stringcount     : Integer;
                              stringnumber    : Integer;
                              buffer          : PAnsiChar;
                              bufsize         : Integer ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_copy_substring';
procedure pcre_free_substring( stringptr: PAnsiChar ); cdecl; external;// PCRE_DLL_NAME name 'pcre_free_substring';
procedure pcre_free_substring_list( stringptr: PPAnsiChar ); cdecl; external;// PCRE_DLL_NAME name 'pcre_free_substring_list';

function regcomp( out preg: regex_t; pattern: PAnsiChar; cflags: Cardinal): Integer; cdecl; external;// PCRE_DLL_NAME name 'regcomp';
function regexec( var preg      : regex_t;
                  str           : PAnsiChar;
                  nmatch        : Cardinal;
                  pmatch        : regmatch_ptr;
                  eflags        : Cardinal): Integer; cdecl; external;// PCRE_DLL_NAME name 'regexec';
function regerror(errcode       : Integer;
                  var preg      : regex_t;
                  errbuf        : PAnsiChar;
                  errbuf_size   : Cardinal): Integer; cdecl; external;// PCRE_DLL_NAME name 'regerror';
procedure regfree(var preg: regex_t); cdecl; external;// PCRE_DLL_NAME name 'regfree';

//function pcre_set_callout_handler(Func: TPcreCalloutCallback): TPcreCalloutCallback; cdecl; external;// PCRE_DLL_NAME name 'pcre_set_callout_handler';
function pcre_config( what            : Integer;
                      out where                 ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_config';
function pcre_copy_named_substring( code        : TPcreH;
                                    subject     : PAnsiChar;
                                    ovector     : PIntArray;
                                    stringcount : Integer;
                                    stringname  : PAnsiChar;
                                    buffer      : PAnsiChar;
                                    buffersize  : Integer  ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_copy_named_substring';
function pcre_get_named_substring(  code        : TPcreH;
                                    subject     : PAnsiChar;
                                    ovector     : PIntArray;
                                    stringcount : Integer;
                                    stringname  : PAnsiChar;
                                    stringptr   : PPAnsiChar ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_get_named_substring';
function pcre_get_stringnumber(     code        : TPcreH;
                                    name        : PAnsiChar   ): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_get_stringnumber';
function pcre_get_stringtable_entries(code      : TPcreH;
                                      name      : PAnsiChar;
                                      first     : PPAnsiChar;
                                      last      : PPAnsiChar ): Integer; cdecl; external;
//function pcre_extra_set_match_limit(var pcre_extra: TPcre_extraH; value: Longint): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_extra_set_match_limit';
//function pcre_extra_set_callout_data(var pcre_extra: TPcre_extraH; Data: Pointer): Integer; cdecl; external;// PCRE_DLL_NAME name 'pcre_extra_set_callout_data';

// === for c ref

function strchr(s: PAnsiChar; c: Integer): PAnsiChar; cdecl;
begin
  Result := StrScan(s, AnsiChar(c));
end;

function isalnum(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in ['A'..'Z','a'..'z','0'..'9'];
end;

function isalpha(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in ['A'..'Z','a'..'z'];
end;

function iscntrl(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in [#0..#$1F,#$7F];
end;

function isdigit(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in ['0'..'9'];
end;

function isgraph(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in [#$21..#$7E];
end;

function islower(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in ['a'..'z'];
end;

function isprint(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in [#$20..#$7E];
end;

function ispunct(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in [#$21..#$2F,#$3A..#$40,#$5B..#$60,#$7B..#$7E];
end;

function isspace(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in [#$09..#$0D,#$20];
end;

function isupper(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in ['A'..'Z'];
end;

function isxdigit(c: integer): LongBool; cdecl;
begin
  Result:= char(c) in ['0'..'9','A'..'F','a'..'f'];
end;

{
function _ltolower(c: Char): Char; cdecl;
begin
  Result:= c;
  if Result in ['A'..'Z'] then Inc(Result,$20);
end;

function _ltoupper(c: Char): Char; cdecl;
begin
  Result:= c;
  if Result in ['a'..'z'] then Dec(Result,$20);
end;
}

function strncmp(s1, s2: PAnsiChar; maxlen: Cardinal): Integer; cdecl;
begin
  Result := AnsiStrLComp(s1, s2, maxlen);
end;

function strcmp(s1, s2: PAnsiChar): Integer; cdecl;
begin
  Result := AnsiStrComp(s1,s2);
end;

procedure free(P: Pointer); cdecl;
begin
  FreeMem(P);
end;

function strncpy(strDest, strSource: PAnsiChar; count: Cardinal): PAnsiChar; cdecl;
var
  Len: Cardinal;
begin
  Len := StrLen(strSource);
  if count <= Len then
    StrLCopy(strDest, strSource, count)
  else
  begin
    StrLCopy(strDest, strSource, Len);
    FillChar((strDest + Len)^, count - Len, 0);
  end;
  Result := strDest;
end;

function memmove(dest, src: Pointer; n: Cardinal): Pointer; cdecl;
begin
  Move(src^, dest^, n);
  Result := dest;
end;

procedure memset(P: Pointer; B: Integer; count: Integer); cdecl;
begin
  FillChar(P^, count, B);
end;

function malloc(size: Integer): Pointer; cdecl;
begin
  GetMem(Result, size);
end;

function memcmp(s1, s2: Pointer; n: Integer): Integer; cdecl;
begin
  Result := AnsiStrLComp(PAnsiChar(s1), PAnsiChar(s2), n);
end;

procedure memcpy(dest, source: Pointer; count: Integer); cdecl;
begin
  Move(source^, dest^, count);
end;

procedure sprintf(Buffer, Format: PAnsiChar; Arguments: va_list); cdecl;
// Optional parameters are passed in a va_list as the last parameter.
begin
  wvsprintfA(Buffer, Format, @Arguments);
end;

//===========================================================================
//
// These are strongly typed versions of the same named functions
// exported by the pcre.dll
//
//===========================================================================

function pcre_isalnum(c: AnsiChar): Boolean;
begin
  Result := isalnum(Ord(c));
end;

//===========================================================================

function pcre_isalpha(c: AnsiChar): Boolean;
begin
  Result := isalnum(Ord(c));
end;

//===========================================================================

function pcre_iscntrl(c: AnsiChar): Boolean;
begin
  Result := iscntrl(Ord(c));
end;

//===========================================================================

function pcre_isdigit(c: AnsiChar): Boolean;
begin
  Result := isdigit(Ord(c));
end;

//===========================================================================

function pcre_isgraph(c: AnsiChar): Boolean;
begin
  Result := isgraph(Ord(c));
end;

//===========================================================================

function pcre_islower(c: AnsiChar): Boolean;
begin
  Result := islower(Ord(c));
end;

//===========================================================================

function pcre_isprint(c: AnsiChar): Boolean;
begin
  Result := isprint(Ord(c));
end;

//===========================================================================

function pcre_ispunct(c: AnsiChar): Boolean;
begin
  Result := ispunct(Ord(c));
end;

//===========================================================================

function pcre_isspace(c: AnsiChar): Boolean;
begin
  Result := isspace(Ord(c));
end;

//===========================================================================

function pcre_isupper(c: AnsiChar): Boolean;
begin
  Result := isupper(Ord(c));
end;

//===========================================================================

function pcre_isxdigit(c: AnsiChar): Boolean;
begin
  Result := isxdigit(Ord(c));
end;

//===========================================================================
function _ltolower(c : integer):Integer; cdecl;
var
  s : array[0..3] of char;
  res : pansichar;
begin
  s[0] := char(c); s[1] := #0;
  res := Sysutils.AnsiStrLower(PAnsiChar( @(s[0])));
  result := ord(res[0]);
end;

function _ltoupper(c : integer):Integer; cdecl;
var
  s : array[0..3] of char;
  res : pansichar;
begin
  s[0] := char(c); s[1] := #0;
  res := sysutils.AnsiStrUpper(PAnsiChar(@(s[0])));
  result := ord(res[0]);
end;




end.
