{
  =============================================================================
  *****************************************************************************
     The contents of this file are subject to the Mozilla Public License
     Version 1.1 (the "License"); you may not use this file except in
     compliance with the License. You may obtain a copy of the License at
     http://www.mozilla.org/MPL/

     Software distributed under the License is distributed on an "AS IS"
     basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
     License for the specific language governing rights and limitations
     under the License.

     The Original Code is Avro Keyboard 5.

     The Initial Developer of the Original Code is
     Mehdi Hasan Khan (mhasan@omicronlab.com).

     Copyright (C) OmicronLab (http://www.omicronlab.com). All Rights Reserved.


     Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}

{COMPLETE TRANSFERING!}

//Supported values:
// HIGH_PRIORITY_CLASS
// IDLE_PRIORITY_CLASS
// NORMAL_PRIORITY_CLASS
// REALTIME_PRIORITY_CLASS


Unit uProcessHandler;

Interface
Uses
     Windows;


Procedure Set_Process_Priority(Const xPriority: Integer);


Implementation

{===============================================================================}

Procedure Set_Process_Priority(Const xPriority: Integer);
Begin
     //Supported values:
     // HIGH_PRIORITY_CLASS
     // IDLE_PRIORITY_CLASS
     // NORMAL_PRIORITY_CLASS
     // REALTIME_PRIORITY_CLASS
     SetPriorityClass(GetCurrentProcess(), xPriority);
End;

{===============================================================================}

End.
