{
  =============================================================================
  *****************************************************************************
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  https://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is Avro Keyboard 5.

  The Initial Developer of the Original Code is
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../../ProjectDefines.inc}
unit DebugLog;

interface

uses
  Windows,
  System.SysUtils;

procedure Log(const Msg: string); overload;
procedure Log(const Msg: string; i: LongInt); overload;

implementation

procedure Log(const Msg: string);
begin
  {$IFDEF DebugLog}
  OutputDebugString(PChar(Msg));
  {$ENDIF}
end;

procedure Log(const Msg: string; i: LongInt);
begin
  {$IFDEF DebugLog}
  OutputDebugString(PChar(Msg + IntToStr(i)));
  {$ENDIF}
end;

end.
