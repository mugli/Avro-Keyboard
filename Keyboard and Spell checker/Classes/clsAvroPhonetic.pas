{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
