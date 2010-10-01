{                                                                              }
{ Conditional defines defined here:                                            }
{   DELPHI       - Delphi compiler.                                            }
{     DELPHI3    - Delphi 3.                                                   }
{     DELPHI4    - Delphi 4.                                                   }
{     DELPHI5    - Delphi 5.                                                   }
{     DELPHI6    - Delphi 6.                                                   }
{     DELPHI7    - Delphi 7.                                                   }
{     DELPHI3_UP - Delphi 3 or later.                                          }
{     DELPHI4_UP - Delphi 4 or later.                                          }
{     DELPHI5_UP - Delphi 5 or later.                                          }
{     DELPHI6_UP - Delphi 6 or later.                                          }
{     DELPHI7_UP - Delphi 7 or later.                                          }
{   OS_UNIX      - Unix type operating system.                                 }
{     OS_LINUX   - Linux operating system.                                     }
{   OS_MSWIN     - MS Windows type operating system.                           }
{     OS_WIN32   - Win32 operating system.                                     }
{   CPU_INTEL386 - Intel 386 compatible CPU.                                   }
{   WINTEL       - OS_WIN32 and CPU_INTEL386.                                  }
{   LINTEL       - OS_LINUX and CPU_INTEL386.                                  }
{                                                                              }



{                                                                              }
{ Pre Delphi 3                                                                 }
{                                                                              }
{$IFDEF VER80}
  {$DEFINE DELPHI}
{$ENDIF}
{$IFDEF VER90}
  {$DEFINE DELPHI}
{$ENDIF}
{$IFDEF VER93}
  {$DEFINE DELPHI}
{$ENDIF}
{$IFDEF VER100}
  {$DEFINE DELPHI}
{$ENDIF}



{                                                                              }
{ Delphi 3                                                                     }
{                                                                              }
{$IFDEF VER110}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI3}
  {$DEFINE DELPHI3_UP}
  {$DEFINE WIN32}
  {$DEFINE OS_WIN32}
  {$DEFINE CPU386}
{$ENDIF}



{                                                                              }
{ Delphi 4                                                                     }
{                                                                              }
{$IFDEF VER120}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI3_UP}
  {$DEFINE DELPHI4_UP}
  {$DEFINE WIN32}
  {$DEFINE OS_WIN32}
  {$DEFINE CPU386}
{$ENDIF}
{$IFDEF VER125}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI3_UP}
  {$DEFINE DELPHI4_UP}
  {$DEFINE WIN32}
  {$DEFINE OS_WIN32}
  {$DEFINE CPU386}
{$ENDIF}



{                                                                              }
{ Delphi 5                                                                     }
{                                                                              }
{$IFDEF VER130}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI3_UP}
  {$DEFINE DELPHI4_UP}
  {$DEFINE DELPHI5_UP}
  {$DEFINE WIN32}
  {$DEFINE OS_WIN32}
  {$DEFINE CPU386}
{$ENDIF}



{                                                                              }
{ Delphi 6                                                                     }
{                                                                              }
{$IFDEF VER140}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI3_UP}
  {$DEFINE DELPHI4_UP}
  {$DEFINE DELPHI5_UP}
  {$DEFINE DELPHI6_UP}
  {$IFDEF LINUX}
    {$DEFINE OS_LINUX}
  {$ENDIF}
  {$IFDEF WIN32}
    {$DEFINE OS_WIN32}
  {$ENDIF}
{$ENDIF}



{                                                                              }
{ Delphi 7                                                                     }
{                                                                              }
{$IFDEF VER150}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI3_UP}
  {$DEFINE DELPHI4_UP}
  {$DEFINE DELPHI5_UP}
  {$DEFINE DELPHI6_UP}
  {$DEFINE DELPHI7_UP}
  {$IFDEF LINUX}
    {$DEFINE OS_LINUX}
  {$ENDIF}
  {$IFDEF WIN32}
    {$DEFINE OS_WIN32}
  {$ENDIF}
{$ENDIF}



{                                                                              }
{ CPU Type                                                                     }
{                                                                              }
{$IFDEF DELPHI}
  {$IFDEF CPU386}
    {$DEFINE CPU_INTEL386}
  {$ENDIF}
{$ENDIF}



{                                                                              }
{ Operating system type                                                        }
{                                                                              }
{$IFDEF OS_WIN32}
  {$DEFINE OS_MSWIN}
{$ENDIF}
{$IFDEF OS_LINUX}
  {$DEFINE OS_UNIX}
{$ENDIF}



{                                                                              }
{ OS / CPU combination                                                         }
{                                                                              }
{$IFDEF CPU_INTEL386}
  {$IFDEF OS_MSWIN}
    {$DEFINE WINTEL}
  {$ENDIF}
  {$IFDEF OS_LINUX}
    {$DEFINE LINTEL}
  {$ENDIF}
{$ENDIF}



{                                                                              }
{ Standard compiler directives                                                 }
{                                                                              }
{$IFDEF DELPHI}
  {$EXTENDEDSYNTAX ON}
  {$IOCHECKS ON}
  {$LONGSTRINGS ON}
  {$BOOLEVAL OFF}
  {$OPTIMIZATION ON}
  {$IFDEF DEBUG}
    {$ASSERTIONS ON}
    {$DEBUGINFO ON}
    {$OVERFLOWCHECKS ON}
    {$RANGECHECKS ON}
    {$WARNINGS ON}
    {$HINTS ON}
  {$ELSE}
    {$ASSERTIONS OFF}
    {$DEBUGINFO OFF}
    {$OVERFLOWCHECKS OFF}
    {$RANGECHECKS OFF}
    {$WARNINGS OFF}
    {$HINTS OFF}
  {$ENDIF}
{$ENDIF}

{$IFNDEF DEBUG}
  {$IFDEF DELPHI6_UP}
    {$WARN SYMBOL_PLATFORM OFF}
    {$WARN UNIT_PLATFORM OFF}
  {$ENDIF}
{$ENDIF}

{$IFDEF DELPHI7_UP}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

