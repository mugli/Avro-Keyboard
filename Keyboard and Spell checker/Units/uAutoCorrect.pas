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

Unit uAutoCorrect;

Interface
Uses
     Windows,
     Classes,
     SysUtils,
     StrUtils,
     CDictionaries,
     Forms,
     uFileFolderHandling;


Procedure InitDict;
Procedure LoadDict;
Procedure DestroyDict;

Var
     Dict                     : TStringDictionary;




Implementation

{===============================================================================}

Procedure InitDict;
Begin
     Dict := TStringDictionary.Create;
     Dict.DuplicatesAction := ddIgnore;
     LoadDict;
End;

{===============================================================================}

Procedure DestroyDict;
Begin
     FreeAndNil(Dict);
End;

{===============================================================================}

Procedure LoadDict;
Var
     List                     : TStringList;
     I, P                     : Integer;
     Path, FirstPart, SecondPart: String;
Begin
     Try
          Try
               List := TStringList.Create;
               Path := GetAvroDataDir + 'autodict.dct';
               List.LoadFromFile(Path);

               For I := 0 To List.Count - 1 Do Begin
                    If (LeftStr(Trim(List[i]), 1) <> '/') And (Trim(List[i]) <> '') Then Begin
                         P := Pos(' ', Trim(List[i]));
                         FirstPart := LeftStr(Trim(List[i]), P - 1);
                         SecondPart := MidStr(Trim(List[i]), p + 1, Length(Trim(List[i])));
                         dict.Add(FirstPart, SecondPart);
                    End;
               End;
          Except
               On E: Exception Do Begin
                    Application.MessageBox(Pchar('Cannot load auto-correct dictionary!' + #10 + '' + #10 + '-> Make sure ''autodict.dct'' file is present in ' + Path + ' folder, or' + #10 + '-> ''autodict.dct'' file is not corrupt.' + #10 + '' + #10 + 'Reinstalling Avro Keyboard may solve this problem.' + #10 + 'You may contact OmicronLab (http://www.omicronlab.com/forum/) for free support.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
               End;
          End;
     Finally
          FreeAndNil(List);
     End;

End;

{===============================================================================}

End.

