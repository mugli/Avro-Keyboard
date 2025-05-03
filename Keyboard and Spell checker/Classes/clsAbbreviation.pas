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

Unit clsAbbreviation;

Interface

Uses
  classes,
  sysutils,
  StrUtils;

Type
  TAbbreviation = Class
  Private

  Public
    Function CheckConvert(EnglishT: String): String;
  End;

Implementation

Uses
  BanglaChars;

{ TAbbreviation }

{ =============================================================================== }

Function TAbbreviation.CheckConvert(EnglishT: String): String;
Var
  T: String;
Begin
  EnglishT := Trim(EnglishT);

  If Length(EnglishT) <= 0 Then
  Begin
    Result := '';
    exit;
  End;

  If Uppercase(EnglishT) <> EnglishT Then
  Begin
    Result := '';
    exit;
  End;

  T := EnglishT;
  T := ReplaceStr(T, 'A', b_E);
  T := ReplaceStr(T, 'B', b_B + b_Ikar);
  T := ReplaceStr(T, 'C', b_S + b_Ikar);
  T := ReplaceStr(T, 'D', b_Dd + b_Ikar);
  T := ReplaceStr(T, 'E', b_I);
  T := ReplaceStr(T, 'F', b_E + b_Ph);
  T := ReplaceStr(T, 'G', b_J + b_Ikar);
  T := ReplaceStr(T, 'H', b_E + b_I + b_C);
  T := ReplaceStr(T, 'I', b_AA + b_I);
  T := ReplaceStr(T, 'J', b_J + b_EKar);
  T := ReplaceStr(T, 'K', b_K + b_EKar);
  T := ReplaceStr(T, 'L', b_E + b_L);
  T := ReplaceStr(T, 'M', b_E + b_m);
  T := ReplaceStr(T, 'N', b_E + b_n);
  T := ReplaceStr(T, 'O', b_O);
  T := ReplaceStr(T, 'P', b_p + b_Ikar);
  T := ReplaceStr(T, 'Q', b_K + b_Ikar + b_U);
  T := ReplaceStr(T, 'R', b_AA + b_R);
  T := ReplaceStr(T, 'S', b_E + b_S);
  T := ReplaceStr(T, 'T', b_Tt + b_Ikar);
  T := ReplaceStr(T, 'U', b_I + b_U);
  T := ReplaceStr(T, 'V', b_Bh + b_Ikar);
  T := ReplaceStr(T, 'W', b_Dd + b_B + b_Hasanta + b_L + b_Ikar + b_U);
  T := ReplaceStr(T, 'X', b_E + b_K + b_Hasanta + b_S);
  T := ReplaceStr(T, 'Y', b_O + b_Y + b_AAkar + b_I);
  T := ReplaceStr(T, 'Z', b_J + b_EKar + b_Dd);

  T := ReplaceStr(T, '0', b_0);
  T := ReplaceStr(T, '1', b_1);
  T := ReplaceStr(T, '2', b_2);
  T := ReplaceStr(T, '3', b_3);
  T := ReplaceStr(T, '4', b_4);
  T := ReplaceStr(T, '5', b_5);
  T := ReplaceStr(T, '6', b_6);
  T := ReplaceStr(T, '7', b_7);
  T := ReplaceStr(T, '8', b_8);
  T := ReplaceStr(T, '9', b_9);

  Result := T;

End;

{ =============================================================================== }

End.
