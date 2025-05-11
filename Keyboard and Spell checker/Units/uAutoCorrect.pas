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

unit uAutoCorrect;

interface

uses
  Windows,
  Classes,
  SysUtils,
  StrUtils,
  Generics.Collections,
  Forms,
  uFileFolderHandling;

procedure InitDict;
procedure LoadDict;
procedure DestroyDict;

var
  Dict: TDictionary<string, string>;

implementation

{ =============================================================================== }

procedure InitDict;
begin
  Dict := TDictionary<string, string>.create;
  LoadDict;
end;

{ =============================================================================== }

procedure DestroyDict;
begin
  FreeAndNil(Dict);
end;

{ =============================================================================== }

procedure LoadDict;
var
  List:                  TStringList;
  I, P:                  Integer;
  Path:                  string;
  FirstPart, SecondPart: string;
begin
  try
    try
      List := TStringList.create;
      Path := GetAvroDataDir + 'autodict.dct';
      List.LoadFromFile(Path);

      for I := 0 to List.Count - 1 do
      begin
        if (LeftStr(Trim(List[I]), 1) <> '/') and (Trim(List[I]) <> '') then
        begin
          P := Pos(' ', Trim(List[I]));
          FirstPart := LeftStr(Trim(List[I]), P - 1);
          SecondPart := MidStr(Trim(List[I]), P + 1, Length(Trim(List[I])));
          Dict.AddOrSetValue(FirstPart, SecondPart);
        end;
      end;
    except
      on E: Exception do
      begin
        Application.MessageBox(Pchar('Cannot load auto-correct dictionary!' + #10 + '' + #10 + '-> Make sure ''autodict.dct'' file is present in ' + Path +
              ' folder, or' + #10 + '-> ''autodict.dct'' file is not corrupt.' + #10 + '' + #10 + 'Reinstalling Avro Keyboard may solve this problem.'),
          'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;
    end;
  finally
    FreeAndNil(List);
  end;

end;

{ =============================================================================== }

end.
