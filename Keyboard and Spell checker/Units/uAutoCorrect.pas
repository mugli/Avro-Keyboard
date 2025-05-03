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

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

Unit uAutoCorrect;

Interface

Uses
  Windows,
  Classes,
  SysUtils,
  StrUtils,
  Generics.Collections,
  Forms,
  uFileFolderHandling;

Procedure InitDict;
Procedure LoadDict;
Procedure DestroyDict;

Var
  Dict: TDictionary<String, String>;

Implementation

{ =============================================================================== }

Procedure InitDict;
Begin
  Dict := TDictionary<String, String>.create;
  LoadDict;
End;

{ =============================================================================== }

Procedure DestroyDict;
Begin
  FreeAndNil(Dict);
End;

{ =============================================================================== }

Procedure LoadDict;
Var
  List: TStringList;
  I, P: Integer;
  Path: String;
  FirstPart, SecondPart: String;
Begin
  Try
    Try
      List := TStringList.create;
      Path := GetAvroDataDir + 'autodict.dct';
      List.LoadFromFile(Path);

      For I := 0 To List.Count - 1 Do
      Begin
        If (LeftStr(Trim(List[I]), 1) <> '/') And (Trim(List[I]) <> '') Then
        Begin
          P := Pos(' ', Trim(List[I]));
          FirstPart := LeftStr(Trim(List[I]), P - 1);
          SecondPart := MidStr(Trim(List[I]), P + 1, Length(Trim(List[I])));
          Dict.AddOrSetValue(FirstPart, SecondPart);
        End;
      End;
    Except
      On E: Exception Do
      Begin
        Application.MessageBox(Pchar('Cannot load auto-correct dictionary!' +
          #10 + '' + #10 + '-> Make sure ''autodict.dct'' file is present in ' +
          Path + ' folder, or' + #10 +
          '-> ''autodict.dct'' file is not corrupt.' + #10 + '' + #10 +
          'Reinstalling Avro Keyboard may solve this problem.'),
          'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      End;
    End;
  Finally
    FreeAndNil(List);
  End;

End;

{ =============================================================================== }

End.
