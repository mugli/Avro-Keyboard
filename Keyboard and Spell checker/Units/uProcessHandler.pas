{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

// Supported values:
// HIGH_PRIORITY_CLASS
// IDLE_PRIORITY_CLASS
// NORMAL_PRIORITY_CLASS
// REALTIME_PRIORITY_CLASS

unit uProcessHandler;

interface

uses
  Windows;

procedure Set_Process_Priority(const xPriority: Integer);

implementation

{ =============================================================================== }

procedure Set_Process_Priority(const xPriority: Integer);
begin
  // Supported values:
  // HIGH_PRIORITY_CLASS
  // IDLE_PRIORITY_CLASS
  // NORMAL_PRIORITY_CLASS
  // REALTIME_PRIORITY_CLASS
  SetPriorityClass(GetCurrentProcess(), xPriority);
end;

{ =============================================================================== }

end.
