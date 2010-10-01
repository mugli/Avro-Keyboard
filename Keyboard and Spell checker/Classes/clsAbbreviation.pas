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

Unit clsAbbreviation;

Interface

Uses
     classes,
     sysutils,
     StrUtils,
     WideStrUtils;

Type
     TAbbreviation = Class
     Private

     Public
          Function CheckConvert(EnglishT: AnsiString): WideString;
     End;


Implementation

Uses
     BanglaChars;

{ TAbbreviation }

{===============================================================================}

Function TAbbreviation.CheckConvert(EnglishT: AnsiString): WideString;
Var
     T                        : WideString;
Begin
     EnglishT := Trim(EnglishT);

     If Length(EnglishT) <= 0 Then Begin
          Result := '';
          exit;
     End;


     If Uppercase(EnglishT) <> EnglishT Then Begin
          Result := '';
          exit;
     End;

     T := EnglishT;
     T := WideReplaceStr(T, 'A', b_E);
     T := WideReplaceStr(T, 'B', b_B + b_Ikar);
     T := WideReplaceStr(T, 'C', b_S + b_Ikar);
     T := WideReplaceStr(T, 'D', b_Dd + b_Ikar);
     T := WideReplaceStr(T, 'E', b_I);
     T := WideReplaceStr(T, 'F', b_E + b_Ph);
     T := WideReplaceStr(T, 'G', b_J + b_Ikar);
     T := WideReplaceStr(T, 'H', b_E + b_I + b_C);
     T := WideReplaceStr(T, 'I', b_AA + b_I);
     T := WideReplaceStr(T, 'J', b_J + b_EKar);
     T := WideReplaceStr(T, 'K', b_K + b_EKar);
     T := WideReplaceStr(T, 'L', b_E + b_L);
     T := WideReplaceStr(T, 'M', b_E + b_m);
     T := WideReplaceStr(T, 'N', b_E + b_n);
     T := WideReplaceStr(T, 'O', b_O);
     T := WideReplaceStr(T, 'P', b_p + b_Ikar);
     T := WideReplaceStr(T, 'Q', b_k + b_Ikar + b_U);
     T := WideReplaceStr(T, 'R', b_AA + b_R);
     T := WideReplaceStr(T, 'S', b_E + b_S);
     T := WideReplaceStr(T, 'T', b_Tt + b_Ikar);
     T := WideReplaceStr(T, 'U', b_I + b_U);
     T := WideReplaceStr(T, 'V', b_Bh + b_Ikar);
     T := WideReplaceStr(T, 'W', b_Dd + b_b + b_Hasanta + b_L + b_Ikar + b_U);
     T := WideReplaceStr(T, 'X', b_E+b_k+b_Hasanta+b_S);
     T := WideReplaceStr(T, 'Y', b_O+b_Y+b_AAkar+b_I);
     T := WideReplaceStr(T, 'Z', b_J + b_EKar+b_Dd);

     T := WideReplaceStr(T, '0', b_0);
     T := WideReplaceStr(T, '1', b_1);
     T := WideReplaceStr(T, '2', b_2);
     T := WideReplaceStr(T, '3', b_3);
     T := WideReplaceStr(T, '4', b_4);
     T := WideReplaceStr(T, '5', b_5);
     T := WideReplaceStr(T, '6', b_6);
     T := WideReplaceStr(T, '7', b_7);
     T := WideReplaceStr(T, '8', b_8);
     T := WideReplaceStr(T, '9', b_9);

     Result := T;

End;

{===============================================================================}

End.

