{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
