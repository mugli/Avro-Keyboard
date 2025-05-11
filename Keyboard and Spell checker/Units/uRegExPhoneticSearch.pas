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

unit uRegExPhoneticSearch;

{ .$DEFINE FASTSEARCH_OFF }  // Uncomment to turn OFF fast searching

interface

uses
  Classes;

function SearchPhonetic(SearchIn, SearchStr: string; var wList: TStringList): Integer;

implementation

uses
  RegularExpressions,
  uDBase,
  StrUtils,
  SysUtils;

function SearchPhonetic(SearchIn, SearchStr: string; var wList: TStringList): Integer;
var
  theRegex: TRegex;
  theMatch: TMatch;

  I:             Integer;
  WideSearchStr: string;
  mSearchIn:     string;

  StartCounter, EndCounter: Integer;
  TotalSearch:              Integer; { For diagnosis purpose }
begin
  wList.Clear;
  wList.Sorted := True;
  wList.Duplicates := dupIgnore;

  TotalSearch := 0;
  WideSearchStr := ('^') + (SearchStr) + ('$');
  theRegex := TRegex.Create(WideSearchStr);

  mSearchIn := LeftStr(LowerCase(SearchIn), 1);

  wList.BeginUpdate;

  { ***************************************** }
  { Search W_A }
  if (mSearchIn = 'o') or (mSearchIn = 'a') then
  begin

    StartCounter := 0;
    EndCounter := W_A.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_A[I]);
      if theMatch.Success then
      begin
        wList.Add((W_A[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_AA }
  if {$IFDEF FASTSEARCH_OFF}(mSearchIn = 'r') or {$ENDIF}
    (mSearchIn = 'i') or (mSearchIn = 'a') then
  begin

    StartCounter := 0;
    EndCounter := W_AA.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_AA[I]);
      if theMatch.Success then
      begin
        wList.Add((W_AA[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_I }
  if (mSearchIn = 'y')

  {$IFDEF FASTSEARCH_OFF} or (mSearchIn = 'u'){$ENDIF}
    or (mSearchIn = 'i') or (mSearchIn = 'e') then
  begin

    StartCounter := 0;
    EndCounter := W_I.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_I[I]);
      if theMatch.Success then
      begin
        wList.Add((W_I[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_II }
  if (mSearchIn = 'i') or (mSearchIn = 'e') then
  begin

    StartCounter := 0;
    EndCounter := W_II.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_II[I]);
      if theMatch.Success then
      begin
        wList.Add((W_II[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_U }
  if (mSearchIn = 'u') or (mSearchIn = 'o') then
  begin

    StartCounter := 0;
    EndCounter := W_U.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_U[I]);
      if theMatch.Success then
      begin
        wList.Add((W_U[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_UU }
  if (mSearchIn = 'u') or (mSearchIn = 'o') then
  begin

    StartCounter := 0;
    EndCounter := W_UU.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_UU[I]);
      if theMatch.Success then
      begin
        wList.Add((W_UU[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_RRI }
  if (mSearchIn = 'r') then
  begin

    StartCounter := 0;
    EndCounter := W_RRI.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_RRI[I]);
      if theMatch.Success then
      begin
        wList.Add((W_RRI[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_E }
  if (mSearchIn = 'x'){$IFDEF FASTSEARCH_OFF} or (mSearchIn = 's') or (mSearchIn = 'n') or (mSearchIn = 'm') or (mSearchIn = 'l') or (mSearchIn = 'h') or
    (mSearchIn = 'f'){$ENDIF}
    or (mSearchIn = 'e') or (mSearchIn = 'a') then
  begin

    StartCounter := 0;
    EndCounter := W_E.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_E[I]);
      if theMatch.Success then
      begin
        wList.Add((W_E[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_OI }
  if (mSearchIn = 'a') or (mSearchIn = 'o') then
  begin

    StartCounter := 0;
    EndCounter := W_OI.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_OI[I]);
      if theMatch.Success then
      begin
        wList.Add((W_OI[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_O }
  if {$IFDEF FASTSEARCH_OFF}(mSearchIn = 'y') or
  {$ENDIF}(mSearchIn = 'w') or (mSearchIn = 'o') or (mSearchIn = 'a') then
  begin

    StartCounter := 0;
    EndCounter := W_O.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_O[I]);
      if theMatch.Success then
      begin
        wList.Add((W_O[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_OU }
  if (mSearchIn = 'o') then
  begin

    StartCounter := 0;
    EndCounter := W_OU.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_OU[I]);
      if theMatch.Success then
      begin
        wList.Add((W_OU[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_B }
  if (mSearchIn = 'b') then
  begin

    StartCounter := 0;
    EndCounter := W_B.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_B[I]);
      if theMatch.Success then
      begin
        wList.Add((W_B[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_BH }
  if (mSearchIn = 'b') or (mSearchIn = 'v') then
  begin

    StartCounter := 0;
    EndCounter := W_BH.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_BH[I]);
      if theMatch.Success then
      begin
        wList.Add((W_BH[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_C }
  if (mSearchIn = 'c') then
  begin

    StartCounter := 0;
    EndCounter := W_C.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_C[I]);
      if theMatch.Success then
      begin
        wList.Add((W_C[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_CH }
  if (mSearchIn = 'c') then
  begin

    StartCounter := 0;
    EndCounter := W_CH.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_CH[I]);
      if theMatch.Success then
      begin
        wList.Add((W_CH[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_D }
  if (mSearchIn = 'd') then
  begin

    StartCounter := 0;
    EndCounter := W_D.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_D[I]);
      if theMatch.Success then
      begin
        wList.Add((W_D[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Dh }
  if (mSearchIn = 'd') then
  begin

    StartCounter := 0;
    EndCounter := W_Dh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Dh[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Dh[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Dd }
  if {$IFDEF FASTSEARCH_OFF}(mSearchIn = 'w') or {$ENDIF}(mSearchIn = 'd') then
  begin

    StartCounter := 0;
    EndCounter := W_Dd.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Dd[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Dd[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Ddh }
  if (mSearchIn = 'd') then
  begin

    StartCounter := 0;
    EndCounter := W_Ddh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Ddh[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Ddh[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_G }
  if (mSearchIn = 'g') then
  begin

    StartCounter := 0;
    EndCounter := W_G.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_G[I]);
      if theMatch.Success then
      begin
        wList.Add((W_G[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Gh }
  if (mSearchIn = 'g') then
  begin

    StartCounter := 0;
    EndCounter := W_Gh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Gh[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Gh[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_H }
  if (mSearchIn = 'z') or (mSearchIn = 'r') or (mSearchIn = 'm') or (mSearchIn = 'h') then
  begin

    StartCounter := 0;
    EndCounter := W_H.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_H[I]);
      if theMatch.Success then
      begin
        wList.Add((W_H[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_J }
  if (mSearchIn = 'z') or (mSearchIn = 'j') or (mSearchIn = 'g') then
  begin

    StartCounter := 0;
    EndCounter := W_J.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_J[I]);
      if theMatch.Success then
      begin
        wList.Add((W_J[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Jh }
  if (mSearchIn = 'j') or (mSearchIn = 'z') then
  begin

    StartCounter := 0;
    EndCounter := W_Jh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Jh[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Jh[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_K }
  if (mSearchIn = 'x') or (mSearchIn = 'q') or (mSearchIn = 'k') or (mSearchIn = 'c') then
  begin

    StartCounter := 0;
    EndCounter := W_K.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_K[I]);
      if theMatch.Success then
      begin
        wList.Add((W_K[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Kh }
  if (mSearchIn = 'k') then
  begin

    StartCounter := 0;
    EndCounter := W_Kh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Kh[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Kh[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_L }
  if (mSearchIn = 'l') then
  begin

    StartCounter := 0;
    EndCounter := W_L.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_L[I]);
      if theMatch.Success then
      begin
        wList.Add((W_L[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_M }
  if (mSearchIn = 'm') then
  begin

    StartCounter := 0;
    EndCounter := W_M.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_M[I]);
      if theMatch.Success then
      begin
        wList.Add((W_M[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_N }
  if (mSearchIn = 'n') then
  begin

    StartCounter := 0;
    EndCounter := W_N.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_N[I]);
      if theMatch.Success then
      begin
        wList.Add((W_N[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_NGA }
  if (mSearchIn = 'n') then
  begin

    StartCounter := 0;
    EndCounter := W_NGA.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_NGA[I]);
      if theMatch.Success then
      begin
        wList.Add((W_NGA[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_NYA }
  if (mSearchIn = 'n') or (mSearchIn = 'a') then
  begin

    StartCounter := 0;
    EndCounter := W_NYA.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_NYA[I]);
      if theMatch.Success then
      begin
        wList.Add((W_NYA[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Nn }
  if (mSearchIn = 'n') then
  begin

    StartCounter := 0;
    EndCounter := W_Nn.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Nn[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Nn[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_P }
  if (mSearchIn = 'p') then
  begin

    StartCounter := 0;
    EndCounter := W_P.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_P[I]);
      if theMatch.Success then
      begin
        wList.Add((W_P[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Ph }
  if (mSearchIn = 'p') or (mSearchIn = 'f') then
  begin

    StartCounter := 0;
    EndCounter := W_Ph.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Ph[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Ph[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_R }
  if (mSearchIn = 'r') then
  begin

    StartCounter := 0;
    EndCounter := W_R.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_R[I]);
      if theMatch.Success then
      begin
        wList.Add((W_R[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Rr }
  if (mSearchIn = 'r') then
  begin

    StartCounter := 0;
    EndCounter := W_Rr.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Rr[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Rr[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Rrh }
  if (mSearchIn = 'r') then
  begin

    StartCounter := 0;
    EndCounter := W_Rrh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Rrh[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Rrh[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_S }
  if (mSearchIn = 's'){$IFDEF FASTSEARCH_OFF} or (mSearchIn = 'c'){$ENDIF} then
  begin

    StartCounter := 0;
    EndCounter := W_S.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_S[I]);
      if theMatch.Success then
      begin
        wList.Add((W_S[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Sh }
  if (mSearchIn = 's') then
  begin

    StartCounter := 0;
    EndCounter := W_Sh.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Sh[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Sh[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Ss }
  if (mSearchIn = 's'){$IFDEF FASTSEARCH_OFF} or (mSearchIn = 'x'){$ENDIF} then
  begin

    StartCounter := 0;
    EndCounter := W_Ss.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Ss[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Ss[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_T }
  if (mSearchIn = 't') then
  begin

    StartCounter := 0;
    EndCounter := W_T.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_T[I]);
      if theMatch.Success then
      begin
        wList.Add((W_T[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Th }
  if (mSearchIn = 't') then
  begin

    StartCounter := 0;
    EndCounter := W_Th.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Th[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Th[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Tt }
  if (mSearchIn = 't') then
  begin

    StartCounter := 0;
    EndCounter := W_Tt.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Tt[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Tt[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Tth }
  if (mSearchIn = 't') then
  begin

    StartCounter := 0;
    EndCounter := W_Tth.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Tth[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Tth[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Y }
  if (mSearchIn = 'u') or (mSearchIn = 'o') or (mSearchIn = 'i') or (mSearchIn = 'e') or (mSearchIn = 'a') or (mSearchIn = 'y') then
  begin

    StartCounter := 0;
    EndCounter := W_Y.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Y[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Y[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Z }
  if (mSearchIn = 'j') or (mSearchIn = 'z') then
  begin

    StartCounter := 0;
    EndCounter := W_Z.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Z[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Z[I]));
      end;
    end;
  end;
  { ***************************************** }

  { ***************************************** }
  { Search W_Khandatta }
  if (mSearchIn = 't') then
  begin

    StartCounter := 0;
    EndCounter := W_Khandatta.Count - 1;
    TotalSearch := TotalSearch + EndCounter + 1;

    for I := StartCounter to EndCounter do
    begin
      theMatch := theRegex.Match(W_Khandatta[I]);
      if theMatch.Success then
      begin
        wList.Add((W_Khandatta[I]));
      end;
    end;
  end;
  { ***************************************** }

  wList.EndUpdate;

  Result := TotalSearch;
end;

end.
