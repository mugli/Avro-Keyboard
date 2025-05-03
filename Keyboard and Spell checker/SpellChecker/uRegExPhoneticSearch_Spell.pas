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

Unit uRegExPhoneticSearch_Spell;

Interface

Uses
  Classes;

Function SearchPhonetic_Spell(SearchIn, SearchStr: String;
  Var wList: TStringList): Integer;

Implementation

Uses
  RegularExpressions,
  uDBase,
  StrUtils,
  SysUtils,
  uCustomDictionary;

Function SearchPhonetic_Spell(SearchIn, SearchStr: String;
  Var wList: TStringList): Integer;
Var
  theRegex: TRegex;
  theMatch: TMatch;
  theLocale: ansistring;

  I: Integer;
  mSearchIn: String;
  AnsiSearchStr: ansistring;

  StartCounter, EndCounter: Integer;
  TotalSearch: Integer; { For diagnosis purpose }
Begin
  wList.Clear;
  wList.Sorted := True;
  wList.Duplicates := dupIgnore;

  TotalSearch := 0;

  AnsiSearchStr := '^' + utf8encode(SearchStr) + '$';

  theLocale := 'C';

  theRegex := TRegex.Create(AnsiSearchStr);

  mSearchIn := LeftStr(LowerCase(SearchIn), 1);

  wList.BeginUpdate;

  { ***************************************** }
  { Search W_A }
  If (mSearchIn = 'o') Or (mSearchIn = 'a') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_A.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_A[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_A[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_AA }
  If (mSearchIn = 'a') Or (mSearchIn = 'i') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_AA.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_AA[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_AA[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_I }
  If (mSearchIn = 'y') Or (mSearchIn = 'e') Or (mSearchIn = 'i') or
    (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_I.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_I[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_I[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_II }
  If (mSearchIn = 'i') Or (mSearchIn = 'e') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_II.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_II[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_II[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_U }
  If (mSearchIn = 'o') Or (mSearchIn = 'u') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_U.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_U[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_U[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_UU }
  If (mSearchIn = 'o') Or (mSearchIn = 'u') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_UU.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_UU[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_UU[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_RRI }
  If (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_RRI.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_RRI[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_RRI[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_E }
  If (mSearchIn = 'x') Or (mSearchIn = 'o') Or (mSearchIn = 'a') Or
    (mSearchIn = 'i') Or (mSearchIn = 'e') Or (mSearchIn = 'u') or
    (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_E.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_E[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_E[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_OI }
  If (mSearchIn = 'o') Or (mSearchIn = 'a') Or (mSearchIn = 'i') Or
    (mSearchIn = 'e') Or (mSearchIn = 'u') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_OI.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_OI[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_OI[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_O }
  If (mSearchIn = 'w') Or (mSearchIn = 'o') Or (mSearchIn = 'a') Or
    (mSearchIn = 'i') Or (mSearchIn = 'e') Or (mSearchIn = 'u') or
    (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_O.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_O[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_O[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_OU }
  If (mSearchIn = 'o') Or (mSearchIn = 'a') Or (mSearchIn = 'i') Or
    (mSearchIn = 'e') Or (mSearchIn = 'u') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_OU.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_OU[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_OU[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_B }
  If (mSearchIn = 'b') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_B.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_B[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_B[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_BH }
  If (mSearchIn = 'b') Or (mSearchIn = 'v') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_BH.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_BH[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_BH[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_C }
  If (mSearchIn = 'c') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_C.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_C[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_C[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_CH }
  If (mSearchIn = 'c') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_CH.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_CH[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_CH[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_D }
  If (mSearchIn = 'd') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_D.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_D[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_D[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Dh }
  If (mSearchIn = 'd') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Dh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Dh[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Dh[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Dd }
  If (mSearchIn = 'd') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Dd.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Dd[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Dd[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Ddh }
  If (mSearchIn = 'd') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Ddh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Ddh[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Ddh[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_G }
  If (mSearchIn = 'g') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_G.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_G[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_G[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Gh }
  If (mSearchIn = 'g') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Gh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Gh[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Gh[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_H }
  If (mSearchIn = 'z') Or (mSearchIn = 'r') Or (mSearchIn = 'm') Or
    (mSearchIn = 'h') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_H.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_H[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_H[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_J }
  If (mSearchIn = 'z') Or (mSearchIn = 'j') Or (mSearchIn = 'g') or
    (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_J.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_J[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_J[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Jh }
  If (mSearchIn = 'j') Or (mSearchIn = 'z') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Jh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Jh[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Jh[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_K }
  If (mSearchIn = 'x') Or (mSearchIn = 'q') Or (mSearchIn = 'k') Or
    (mSearchIn = 'c') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_K.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_K[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_K[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Kh }
  If (mSearchIn = 'k') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Kh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Kh[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Kh[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_L }
  If (mSearchIn = 'l') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_L.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_L[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_L[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_M }
  If (mSearchIn = 'm') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_M.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_M[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_M[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_N }
  If (mSearchIn = 'n') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_N.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_N[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_N[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_NGA }
  If (mSearchIn = 'n') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_NGA.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_NGA[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_NGA[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_NYA }
  If (mSearchIn = 'n') Or (mSearchIn = 'a') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_NYA.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_NYA[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_NYA[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Nn }
  If (mSearchIn = 'n') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Nn.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Nn[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Nn[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_P }
  If (mSearchIn = 'p') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_P.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_P[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_P[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Ph }
  If (mSearchIn = 'p') Or (mSearchIn = 'f') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Ph.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Ph[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Ph[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_R }
  If (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_R.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_R[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_R[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Rr }
  If (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Rr.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Rr[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Rr[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Rrh }
  If (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Rrh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Rrh[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Rrh[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_S }
  If (mSearchIn = 's') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_S.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_S[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_S[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Sh }
  If (mSearchIn = 's') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Sh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Sh[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Sh[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Ss }
  If (mSearchIn = 's') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Ss.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Ss[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Ss[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_T }
  If (mSearchIn = 't') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_T.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_T[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_T[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Th }
  If (mSearchIn = 't') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Th.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Th[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Th[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Tt }
  If (mSearchIn = 't') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Tt.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Tt[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Tt[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Tth }
  If (mSearchIn = 't') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Tth.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Tth[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Tth[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Y }
  If (mSearchIn = 'u') Or (mSearchIn = 'o') Or (mSearchIn = 'i') Or
    (mSearchIn = 'e') Or (mSearchIn = 'a') or (mSearchIn = 'y') or
    (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Y.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Y[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Y[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Z }
  If (mSearchIn = 'j') Or (mSearchIn = 'z') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Z.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Z[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Z[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  { Search W_Khandatta }
  If (mSearchIn = 't') or (mSearchIn = 'r') Then
  Begin

    StartCounter := 0;
    EndCounter := W_Khandatta.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    For I := StartCounter To EndCounter Do
    Begin
      theMatch := theRegex.Match(W_Khandatta[I]);
      If theMatch.Success Then
      Begin
        wList.Add(UTF8ToString(W_Khandatta[I]));
      End;
    End;
  End;
  { ***************************************** }

  { ***************************************** }
  // Search custom dictionary
  { ***************************************** }
  StartCounter := 0;
  EndCounter := SpellCustomDict.Count - 1;
  TotalSearch := TotalSearch + EndCounter + 1;

  For I := StartCounter To EndCounter Do
  Begin
    theMatch := theRegex.Match(utf8encode(SpellCustomDict[I]));
    If theMatch.Success Then
    Begin
      wList.Add(SpellCustomDict[I]);
    End;
  End;

  wList.EndUpdate;

  Result := TotalSearch;
End;

End.
