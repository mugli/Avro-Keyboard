{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
