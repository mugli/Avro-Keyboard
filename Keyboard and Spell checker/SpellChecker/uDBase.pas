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
Unit uDBase;

{$INCLUDE ../ProjectDefines.inc}
{$I DI.inc}
{$I DISQLite3.inc}

Interface
Uses
     SysUtils,
     Forms,
     cDictionaries,
     widestrings,
     Classes,
     JclAnsiStrings,
     DISQLite3Database;

Type
     LongIntArray = Array Of LongInt;
     IntegerArray = LongIntArray;
     HashArray = Array Of IntegerArray;

Procedure LoadWordDatabase;
Procedure UnloadWordDatabase;
Procedure LoadSuffix;
Procedure LoadOneDatabase(FileName: String; Var Arr: TAnsiStringList; Var HArr: HashArray);


Var
     FDatabase                : TDISQLite3Database;


     W_A                      : TAnsiStringList;
     W_AA                     : TAnsiStringList;
     W_I                      : TAnsiStringList;
     W_II                     : TAnsiStringList;
     W_U                      : TAnsiStringList;
     W_UU                     : TAnsiStringList;
     W_RRI                    : TAnsiStringList;
     W_E                      : TAnsiStringList;
     W_OI                     : TAnsiStringList;
     W_O                      : TAnsiStringList;
     W_OU                     : TAnsiStringList;


     W_B                      : TAnsiStringList;
     W_BH                     : TAnsiStringList;
     W_C                      : TAnsiStringList;
     W_CH                     : TAnsiStringList;
     W_D                      : TAnsiStringList;
     W_Dh                     : TAnsiStringList;
     W_Dd                     : TAnsiStringList;
     W_Ddh                    : TAnsiStringList;
     W_G                      : TAnsiStringList;
     W_Gh                     : TAnsiStringList;
     W_H                      : TAnsiStringList;
     W_J                      : TAnsiStringList;
     W_Jh                     : TAnsiStringList;
     W_K                      : TAnsiStringList;
     W_Kh                     : TAnsiStringList;
     W_L                      : TAnsiStringList;
     W_M                      : TAnsiStringList;
     W_N                      : TAnsiStringList;
     W_NGA                    : TAnsiStringList;
     W_NYA                    : TAnsiStringList;
     W_Nn                     : TAnsiStringList;
     W_P                      : TAnsiStringList;
     W_Ph                     : TAnsiStringList;
     W_R                      : TAnsiStringList;
     W_Rr                     : TAnsiStringList;
     W_Rrh                    : TAnsiStringList;
     W_S                      : TAnsiStringList;
     W_Sh                     : TAnsiStringList;
     W_Ss                     : TAnsiStringList;
     W_T                      : TAnsiStringList;
     W_Th                     : TAnsiStringList;
     W_Tt                     : TAnsiStringList;
     W_Tth                    : TAnsiStringList;
     W_Y                      : TAnsiStringList;
     W_Z                      : TAnsiStringList;
     W_Khandatta              : TAnsiStringList;

     Suffix                   : TStringDictionary;
     Suffix_Spell             : TWideStringList;

     //Hash arrays
Var
     W_Hash_A                 : HashArray;
     W_Hash_AA                : HashArray;
     W_Hash_I                 : HashArray;
     W_Hash_II                : HashArray;
     W_Hash_U                 : HashArray;
     W_Hash_UU                : HashArray;
     W_Hash_RRI               : HashArray;
     W_Hash_E                 : HashArray;
     W_Hash_OI                : HashArray;
     W_Hash_O                 : HashArray;
     W_Hash_OU                : HashArray;


     W_Hash_B                 : HashArray;
     W_Hash_BH                : HashArray;
     W_Hash_C                 : HashArray;
     W_Hash_CH                : HashArray;
     W_Hash_D                 : HashArray;
     W_Hash_Dh                : HashArray;
     W_Hash_Dd                : HashArray;
     W_Hash_Ddh               : HashArray;
     W_Hash_G                 : HashArray;
     W_Hash_Gh                : HashArray;
     W_Hash_H                 : HashArray;
     W_Hash_J                 : HashArray;
     W_Hash_Jh                : HashArray;
     W_Hash_K                 : HashArray;
     W_Hash_Kh                : HashArray;
     W_Hash_L                 : HashArray;
     W_Hash_M                 : HashArray;
     W_Hash_N                 : HashArray;
     W_Hash_NGA               : HashArray;
     W_Hash_NYA               : HashArray;
     W_Hash_Nn                : HashArray;
     W_Hash_P                 : HashArray;
     W_Hash_Ph                : HashArray;
     W_Hash_R                 : HashArray;
     W_Hash_Rr                : HashArray;
     W_Hash_Rrh               : HashArray;
     W_Hash_S                 : HashArray;
     W_Hash_Sh                : HashArray;
     W_Hash_Ss                : HashArray;
     W_Hash_T                 : HashArray;
     W_Hash_Th                : HashArray;
     W_Hash_Tt                : HashArray;
     W_Hash_Tth               : HashArray;
     W_Hash_Y                 : HashArray;
     W_Hash_Z                 : HashArray;
     W_Hash_Khandatta         : HashArray;

Implementation

Uses
     StrUtils,
     HashTable,
     DISQLite3Api,
     uFileFolderHandling,
     windows;

Procedure LoadSuffix;
Var
     FirstPart, SecondPart    : String;

     Stmt                     : TDISQLite3Statement;
     SelectSQL                : String;
Begin
     SelectSQL := 'SELECT English, Bangla FROM Suffix;';

     Suffix := TStringDictionary.Create;
     Suffix.DuplicatesAction := ddIgnore;

     Suffix_Spell := TWideStringList.Create;
     Suffix_Spell.Sorted := True;
     Suffix_Spell.Duplicates := dupIgnore;
     Stmt := FDatabase.Prepare16(SelectSQL);

     Suffix_Spell.BeginUpdate;
     While Stmt.Step = SQLITE_ROW Do Begin
          FirstPart := Stmt.Column_Str(0); // English
          SecondPart := Stmt.Column_Str(1); // Bangla

          Suffix.Add(FirstPart, SecondPart);
          Suffix_Spell.Add(utf8decode(SecondPart));
     End;
     Suffix_Spell.EndUpdate;


     FreeAndNil(Stmt);
End;


Procedure UnloadWordDatabase;
Begin
     W_A.Clear;
     FreeAndNil(W_A);
     W_AA.Clear;
     FreeAndNil(W_AA);
     W_I.Clear;
     FreeAndNil(W_I);
     W_II.Clear;
     FreeAndNil(W_II);
     W_U.Clear;
     FreeAndNil(W_U);
     W_UU.Clear;
     FreeAndNil(W_UU);
     W_RRI.Clear;
     FreeAndNil(W_RRI);
     W_E.Clear;
     FreeAndNil(W_E);
     W_OI.Clear;
     FreeAndNil(W_OI);
     W_O.Clear;
     FreeAndNil(W_O);
     W_OU.Clear;
     FreeAndNil(W_OU);


     W_B.Clear;
     FreeAndNil(W_B);
     W_BH.Clear;
     FreeAndNil(W_BH);
     W_C.Clear;
     FreeAndNil(W_C);
     W_CH.Clear;
     FreeAndNil(W_CH);
     W_D.Clear;
     FreeAndNil(W_D);
     W_Dh.Clear;
     FreeAndNil(W_Dh);
     W_Dd.Clear;
     FreeAndNil(W_Dd);
     W_Ddh.Clear;
     FreeAndNil(W_Ddh);
     W_G.Clear;
     FreeAndNil(W_G);
     W_Gh.Clear;
     FreeAndNil(W_Gh);
     W_H.Clear;
     FreeAndNil(W_H);
     W_J.Clear;
     FreeAndNil(W_J);
     W_Jh.Clear;
     FreeAndNil(W_Jh);
     W_K.Clear;
     FreeAndNil(W_K);
     W_Kh.Clear;
     FreeAndNil(W_Kh);
     W_L.Clear;
     FreeAndNil(W_L);
     W_M.Clear;
     FreeAndNil(W_M);
     W_N.Clear;
     FreeAndNil(W_N);
     W_NGA.Clear;
     FreeAndNil(W_NGA);
     W_NYA.Clear;
     FreeAndNil(W_NYA);
     W_Nn.Clear;
     FreeAndNil(W_Nn);
     W_P.Clear;
     FreeAndNil(W_P);
     W_Ph.Clear;
     FreeAndNil(W_Ph);
     W_R.Clear;
     FreeAndNil(W_R);
     W_Rr.Clear;
     FreeAndNil(W_Rr);
     W_Rrh.Clear;
     FreeAndNil(W_Rrh);
     W_S.Clear;
     FreeAndNil(W_S);
     W_Sh.Clear;
     FreeAndNil(W_Sh);
     W_Ss.Clear;
     FreeAndNil(W_Ss);
     W_T.Clear;
     FreeAndNil(W_T);
     W_Th.Clear;
     FreeAndNil(W_Th);
     W_Tt.Clear;
     FreeAndNil(W_Tt);
     W_Tth.Clear;
     FreeAndNil(W_Tth);
     W_Y.Clear;
     FreeAndNil(W_Y);
     W_Z.Clear;
     FreeAndNil(W_Z);
     W_Khandatta.Clear;
     FreeAndNil(W_Khandatta);

     Suffix_Spell.Clear;
     FreeAndNil(Suffix_Spell);
     Suffix.Clear;
     FreeAndNil(Suffix);
End;



Procedure LoadWordDatabase;
Begin
     FDatabase := TDISQLite3Database.Create(Nil);
     Try
          Try
               FDatabase.DatabaseName := GetAvroDataDir + 'Database.db3';
               FDatabase.Open;

               LoadOneDatabase('A', W_A, W_Hash_A);
               LoadOneDatabase('AA', W_AA, W_Hash_AA);
               LoadOneDatabase('I', W_I, W_Hash_I);
               LoadOneDatabase('II', W_II, W_Hash_II);
               LoadOneDatabase('U', W_U, W_Hash_U);
               LoadOneDatabase('UU', W_UU, W_Hash_UU);
               LoadOneDatabase('RRI', W_RRI, W_Hash_RRI);
               LoadOneDatabase('E', W_E, W_Hash_E);
               LoadOneDatabase('OI', W_OI, W_Hash_OI);
               LoadOneDatabase('O', W_O, W_Hash_O);
               LoadOneDatabase('OU', W_OU, W_Hash_OU);


               LoadOneDatabase('B', W_B, W_Hash_B);
               LoadOneDatabase('BH', W_BH, W_Hash_BH);
               LoadOneDatabase('C', W_C, W_Hash_C);
               LoadOneDatabase('CH', W_CH, W_Hash_CH);
               LoadOneDatabase('D', W_D, W_Hash_D);
               LoadOneDatabase('Dd', W_Dd, W_Hash_Dd);
               LoadOneDatabase('Dh', W_Dh, W_Hash_Dh);
               LoadOneDatabase('Ddh', W_Ddh, W_Hash_Ddh);
               LoadOneDatabase('G', W_G, W_Hash_G);
               LoadOneDatabase('Gh', W_Gh, W_Hash_Gh);
               LoadOneDatabase('H', W_H, W_Hash_H);
               LoadOneDatabase('J', W_J, W_Hash_J);
               LoadOneDatabase('Jh', W_Jh, W_Hash_Jh);
               LoadOneDatabase('K', W_K, W_Hash_K);
               LoadOneDatabase('Kh', W_Kh, W_Hash_Kh);
               LoadOneDatabase('L', W_L, W_Hash_L);
               LoadOneDatabase('M', W_M, W_Hash_M);
               LoadOneDatabase('N', W_N, W_Hash_N);
               LoadOneDatabase('NN', W_Nn, W_Hash_Nn);
               LoadOneDatabase('NGA', W_NGA, W_Hash_NGA);
               LoadOneDatabase('NYA', W_NYA, W_Hash_NYA);
               LoadOneDatabase('P', W_P, W_Hash_P);
               LoadOneDatabase('Ph', W_Ph, W_Hash_Ph);
               LoadOneDatabase('R', W_R, W_Hash_R);
               LoadOneDatabase('Rr', W_Rr, W_Hash_Rr);
               LoadOneDatabase('Rrh', W_Rrh, W_Hash_Rrh);
               LoadOneDatabase('S', W_S, W_Hash_S);
               LoadOneDatabase('Sh', W_Sh, W_Hash_Sh);
               LoadOneDatabase('Ss', W_Ss, W_Hash_Ss);
               LoadOneDatabase('T', W_T, W_Hash_T);
               LoadOneDatabase('TT', W_Tt, W_Hash_Tt);
               LoadOneDatabase('TH', W_Th, W_Hash_Th);
               LoadOneDatabase('TTH', W_Tth, W_Hash_Tth);
               LoadOneDatabase('Y', W_Y, W_Hash_Y);
               LoadOneDatabase('Z', W_Z, W_Hash_Z);
               LoadOneDatabase('Khandatta', W_Khandatta, W_Hash_Khandatta);

               LoadSuffix;

               FDatabase.Close;
          Except
               On E: Exception Do Begin
                    Application.MessageBox(Pchar('Cannot load Avro database!' + #10 + '' + #10 + '-> Make sure ''Database.db3'' file is present in ' + GetAvroDataDir + ' folder, or' + #10 + '-> ''Database.db3'' file is not corrupt.' + #10 + '' + #10 + 'Reinstalling Avro Keyboard may solve this problem.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
               End;
          End;
     Finally
          FreeAndNil(FDatabase);
     End;

End;

Procedure LoadOneDatabase(FileName: String; Var Arr: TAnsiStringList; Var HArr: HashArray);
Var
     Stmt                     : TDISQLite3Statement;
     SelectSQL                : String;

Begin
     SelectSQL := 'SELECT Words FROM ' + FileName + ';';
     // Inititialize Data
     Arr := TAnsiStringList.Create;

     Stmt := FDatabase.Prepare16(SelectSQL);
     Arr.BeginUpdate;

     While Stmt.Step = SQLITE_ROW Do Begin
          Arr.Add(Stmt.Column_Str(0));
     End;

     Arr.EndUpdate;

     BuildOneHashTable(Arr, HArr);

     Stmt.Free;

     //Application.ProcessMessages;

End;

//------------------------------------------------------------------------------

Initialization
     { Initialize the DISQLite3 library prior to using any other DISQLite3
       functionality. See also sqlite3_shutdown() below.}
     sqlite3_initialize;

Finalization
     { Deallocate any resources that were allocated by
     sqlite3_initialize() above. }
     sqlite3_shutdown;


End.

