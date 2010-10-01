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

Unit clsAvroPhonetic;

Interface

Uses
     classes,
     sysutils,
     StrUtils,
     clsE2BCharBased;

//Skeleton of Class TAvroPhonetic
Type
     TAvroPhonetic = Class
     Private
          CharBased: TE2BCharBased;

          Procedure SetAutoCorrectEnabled(Const Value: Boolean);
          Function GetAutoCorrectEnabled: Boolean;
     Public
          Constructor Create;           //Initializer
          Destructor Destroy; Override; //Destructor

          Function ProcessVKeyDown(Const KeyCode: Integer; Var Block: Boolean): WideString;
          Procedure ProcessVKeyUP(Const KeyCode: Integer; Var Block: Boolean);
          Procedure ResetDeadKey;
          Procedure SelectCandidate(Const Item: WideString); //For Avro Phonetic
          //Published
          Property AutoCorrectEnabled: Boolean
               Read GetAutoCorrectEnabled Write SetAutoCorrectEnabled;
     End;


Implementation

{ TAvroPhonetic }
{===============================================================================}

Constructor TAvroPhonetic.Create;
Begin
     Inherited;

     CharBased := TE2BCharBased.Create;
End;

{===============================================================================}

Destructor TAvroPhonetic.Destroy;
Begin
     FreeAndNil(CharBased);
     Inherited;
End;
{===============================================================================}

Function TAvroPhonetic.GetAutoCorrectEnabled: Boolean;
Begin
     Result := CharBased.AutoCorrectEnabled;
End;

{===============================================================================}

Function TAvroPhonetic.ProcessVKeyDown(Const KeyCode: Integer;
     Var Block: Boolean): WideString;
Begin
     Result := CharBased.ProcessVKeyDown(Keycode, Block);
End;

{===============================================================================}

Procedure TAvroPhonetic.ProcessVKeyUP(Const KeyCode: Integer;
     Var Block: Boolean);
Begin
     CharBased.ProcessVKeyUP(Keycode, Block);
End;

{===============================================================================}

Procedure TAvroPhonetic.ResetDeadKey;
Begin
     CharBased.ResetDeadKey;
End;

{===============================================================================}

Procedure TAvroPhonetic.SelectCandidate(Const Item: WideString);
Begin
     CharBased.SelectCandidate(Item);
End;

{===============================================================================}

Procedure TAvroPhonetic.SetAutoCorrectEnabled(Const Value: Boolean);
Begin
     CharBased.AutoCorrectEnabled := Value;
End;

{===============================================================================}

End.

