{ unit NativeXml.inc

  Nativexml a small-footprint implementation to read and write XML documents
  natively from Delpi code. NativeXml has very fast parsing speeds.

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 - 2010 Simdesign B.V.

  It is NOT allowed under ANY circumstances to publish, alter or copy this code
  without accepting the license conditions in accompanying LICENSE.txt
  first!

  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied.

  Please visit http://www.simdesign.nl/xml.html for more information.
}
// Delphi and BCB versions

// Freepascal (MK)
{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF FPC}
// Delphi 5
{$IFDEF VER130}
  {$DEFINE D5UP}
{$ENDIF}
//Delphi 6
{$IFDEF VER140}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
{$ENDIF}
//Delphi 7
{$IFDEF VER150}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
{$ENDIF}
//Delphi 8
{$IFDEF VER160}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
{$ENDIF}
// Delphi 2005
{$IFDEF VER170}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
{$ENDIF}
// Delphi 2006
{$IFDEF VER180}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
  {$DEFINE D10UP}
{$ENDIF}
// Delphi 2007 - NET
{$IFDEF VER190}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
  {$DEFINE D10UP}
{$ENDIF}
// Delphi 2009
{$IFDEF VER200}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
  {$DEFINE D10UP}
  {$DEFINE D11UP}
  {$DEFINE D12UP}
{$ENDIF}
// Delphi 2010
{$IFDEF VER210}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
  {$DEFINE D7UP}
  {$DEFINE D8UP}
  {$DEFINE D9UP}
  {$DEFINE D10UP}
  {$DEFINE D11UP}
  {$DEFINE D12UP}
  {$DEFINE D14UP}
{$ENDIF}

// Uncomment to save memory space for large documents if you don't need tags.
// Tags are an additional integer field that can be used by the application.
{$DEFINE USETAGS}

// uncomment if you do not want to include the Graphics unit.
{$DEFINE USEGRAPHICS}

// uncomment if you do not want line number/position info from the source file
{$DEFINE SOURCEPOS}

