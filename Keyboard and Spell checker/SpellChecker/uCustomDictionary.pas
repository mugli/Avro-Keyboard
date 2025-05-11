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

unit uCustomDictionary;

interface

uses
  Classes,
  Generics.Collections;

var
  FCustomDictLoaded: Boolean;
  SpellCustomDict:   TStringList;
  SpellIgnoreDict:   TStringList;
  SpellChangeDict:   TDictionary<string, string>;

procedure InitSpellCustomDict;
procedure SaveSpellCustomDict;
function WordPresentInCustomDict(const w: string): Boolean;
function WordPresentInIgnoreDict(const w: string): Boolean;

implementation

uses
  uFileFolderHandling,
  SysUtils;

procedure InitSpellCustomDict;
var
  TempList: TStringList;
begin
  if FCustomDictLoaded then
    exit;

  TempList := TStringList.Create;

  SpellCustomDict := TStringList.Create;
  SpellCustomDict.Sorted := True;
  SpellCustomDict.Duplicates := dupIgnore;
  try
    TempList.Clear;
    TempList.LoadFromFile(GetAvroDataDir + 'CustomSpellingDictionary.dat', TEncoding.UTF8);
    TempList.Delete(0); // Avoid BOM
    SpellCustomDict.Assign(TempList);
  except
    on E: Exception do
    begin
      // Nothing
    end;
  end;
  TempList.Clear;
  FreeAndNil(TempList);

  SpellIgnoreDict := TStringList.Create;
  SpellIgnoreDict.Sorted := True;
  SpellIgnoreDict.Duplicates := dupIgnore;

  SpellChangeDict := TDictionary<string, string>.Create;
  FCustomDictLoaded := True;
end;

procedure SaveSpellCustomDict;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Assign(SpellCustomDict);
  TempList.Sorted := False;
  TempList.Insert(0, '// Custom Bangla Dictionary for Avro Spell Checker (Do not remove this line)');
  try
    TempList.SaveToFile(GetAvroDataDir + 'CustomSpellingDictionary.dat', TEncoding.UTF8);
  except
    on E: Exception do
    begin
      // Nothing
    end;
  end;
  TempList.Clear;
  FreeAndNil(TempList);

  SpellCustomDict.Clear;
  FreeAndNil(SpellCustomDict);

  SpellIgnoreDict.Clear;
  FreeAndNil(SpellIgnoreDict);

  SpellChangeDict.Clear;
  FreeAndNil(SpellChangeDict);

  FCustomDictLoaded := False;
end;

function WordPresentInCustomDict(const w: string): Boolean;
var
  Dummy: Integer;
begin
  Result := SpellCustomDict.Find(w, Dummy);
end;

function WordPresentInIgnoreDict(const w: string): Boolean;
var
  Dummy: Integer;
begin
  Result := SpellIgnoreDict.Find(w, Dummy);
end;

// ------------------------------------------------------------------------------

initialization

FCustomDictLoaded := False;

end.
