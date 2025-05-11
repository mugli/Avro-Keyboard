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

unit clsAvroPhonetic;

interface

uses
  classes,
  sysutils,
  StrUtils,
  clsE2BCharBased;

// Skeleton of Class TAvroPhonetic
type
  TAvroPhonetic = class
    private
      CharBased: TE2BCharBased;

      procedure SetAutoCorrectEnabled(const Value: Boolean);
      function GetAutoCorrectEnabled: Boolean;
    public
      constructor Create;           // Initializer
      destructor Destroy; override; // Destructor

      function ProcessVKeyDown(const KeyCode: Integer; var Block: Boolean): string;
      procedure ProcessVKeyUP(const KeyCode: Integer; var Block: Boolean);
      procedure ResetDeadKey;
      procedure SelectCandidate(const Item: string); // For Avro Phonetic
      // Published
      property AutoCorrectEnabled: Boolean read GetAutoCorrectEnabled write SetAutoCorrectEnabled;
  end;

implementation

{ TAvroPhonetic }
{ =============================================================================== }

constructor TAvroPhonetic.Create;
begin
  inherited;

  CharBased := TE2BCharBased.Create;
end;

{ =============================================================================== }

destructor TAvroPhonetic.Destroy;
begin
  FreeAndNil(CharBased);
  inherited;
end;
{ =============================================================================== }

function TAvroPhonetic.GetAutoCorrectEnabled: Boolean;
begin
  Result := CharBased.AutoCorrectEnabled;
end;

{ =============================================================================== }

function TAvroPhonetic.ProcessVKeyDown(const KeyCode: Integer; var Block: Boolean): string;
begin
  Result := CharBased.ProcessVKeyDown(KeyCode, Block);
end;

{ =============================================================================== }

procedure TAvroPhonetic.ProcessVKeyUP(const KeyCode: Integer; var Block: Boolean);
begin
  CharBased.ProcessVKeyUP(KeyCode, Block);
end;

{ =============================================================================== }

procedure TAvroPhonetic.ResetDeadKey;
begin
  CharBased.ResetDeadKey;
end;

{ =============================================================================== }

procedure TAvroPhonetic.SelectCandidate(const Item: string);
begin
  CharBased.SelectCandidate(Item);
end;

{ =============================================================================== }

procedure TAvroPhonetic.SetAutoCorrectEnabled(const Value: Boolean);
begin
  CharBased.AutoCorrectEnabled := Value;
end;

{ =============================================================================== }

end.
