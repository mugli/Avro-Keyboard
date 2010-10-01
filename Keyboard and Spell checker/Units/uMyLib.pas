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

Unit uMyLib;

Interface
Uses Classes;

Procedure Split(Const Delimiter: Char; Input: String; Const Strings: TStrings);

Implementation

Procedure Split
     (Const Delimiter: Char;
     Input: String;
     Const Strings: TStrings);
Begin
     Assert(Assigned(Strings));
     Strings.Clear;
     Strings.Delimiter := Delimiter;
     Strings.DelimitedText := Input;
End;

End.

