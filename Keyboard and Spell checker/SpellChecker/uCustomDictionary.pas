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

Unit uCustomDictionary;

Interface

Uses
  Classes,
  cDictionaries;

Var
  FCustomDictLoaded: Boolean;
  SpellCustomDict: TStringList;
  SpellIgnoreDict: TStringList;
  SpellChangeDict: TStringDictionary;

Procedure InitSpellCustomDict;
Procedure SaveSpellCustomDict;
Function WordPresentInCustomDict(Const w: String): Boolean;
Function WordPresentInIgnoreDict(Const w: String): Boolean;

Implementation

Uses
  uFileFolderHandling,
  SysUtils;

Procedure InitSpellCustomDict;
Var
  TempList: TStringList;
Begin
  If FCustomDictLoaded Then
    exit;

  TempList := TStringList.Create;

  SpellCustomDict := TStringList.Create;
  SpellCustomDict.Sorted := True;
  SpellCustomDict.Duplicates := dupIgnore;
  Try
    TempList.Clear;
    TempList.LoadFromFile(GetAvroDataDir + 'CustomSpellingDictionary.dat',TEncoding.UTF8);
    TempList.Delete(0); // Avoid BOM
    SpellCustomDict.Assign(TempList);
  Except
    On E: Exception Do Begin
        // Nothing
      End;
  End;
  TempList.Clear;
  FreeAndNil(TempList);

  SpellIgnoreDict := TStringList.Create;
  SpellIgnoreDict.Sorted := True;
  SpellIgnoreDict.Duplicates := dupIgnore;

  SpellChangeDict := TStringDictionary.Create;
  SpellChangeDict.DuplicatesAction := ddIgnore;
  FCustomDictLoaded := True;
End;

Procedure SaveSpellCustomDict;
Var
  TempList: TStringList;
Begin
  TempList := TStringList.Create;
  TempList.Assign(SpellCustomDict);
  TempList.Sorted := False;
  TempList.Insert(0, '// Custom Bangla Dictionary for Avro Spell Checker (Do not remove this line)');
  Try
    TempList.SaveToFile(GetAvroDataDir + 'CustomSpellingDictionary.dat',TEncoding.UTF8);
  Except
    On E: Exception Do Begin
        // Nothing
      End;
  End;
  TempList.Clear;
  FreeAndNil(TempList);

  SpellCustomDict.Clear;
  FreeAndNil(SpellCustomDict);

  SpellIgnoreDict.Clear;
  FreeAndNil(SpellIgnoreDict);

  SpellChangeDict.Clear;
  FreeAndNil(SpellChangeDict);

  FCustomDictLoaded := False;
End;

Function WordPresentInCustomDict(Const w: String): Boolean;
Var
  Dummy: Integer;
Begin
  Result := SpellCustomDict.Find(w, Dummy);
End;

Function WordPresentInIgnoreDict(Const w: String): Boolean;
Var
  Dummy: Integer;
Begin
  Result := SpellIgnoreDict.Find(w, Dummy);
End;

// ------------------------------------------------------------------------------

Initialization

FCustomDictLoaded := False;

End.
