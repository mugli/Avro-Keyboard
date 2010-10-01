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

Unit uRegExPhoneticSearch;

{.$DEFINE FASTSEARCH_OFF}  //Uncomment to turn OFF fast searching

Interface
Uses
     WideStrings;

Function SearchPhonetic(SearchIn, SearchStr: AnsiString; Var wList: TWideStringList): Integer;


Implementation

Uses
     Pcre,
     pcre_dll,
     uDBase,
     classes,
     StrUtils,
     SysUtils;

Function SearchPhonetic(SearchIn, SearchStr: AnsiString; Var wList: TWideStringList): Integer;
Var
     theRegex                 : IRegex;
     theMatch                 : IMatch;
     theLocale                : ansistring;
     RegExOpt                 : TRegMatchOptions;
     RegExCompileOptions      : TRegCompileOptions;
     I                        : Integer;
     mSearchIn                : String;

     StartCounter, EndCounter : Integer;
     TotalSearch              : Integer; {For diagnosis purpose}
Begin
     wList.Clear;
     wList.Sorted := True;
     wList.Duplicates := dupIgnore;

     TotalSearch := 0;

     SearchStr := '^' + SearchStr + '$';
     RegExOpt := [];
     theLocale := 'C';
     RegExCompileOptions := DecodeRegCompileOptions({PCRE_CASELESS Or}PCRE_UTF8);
     theRegex := Pcre.RegexCreate(SearchStr, RegExCompileOptions, theLocale);

     mSearchIn := LeftStr(LowerCase(SearchIn), 1);

     wList.BeginUpdate;

     {*****************************************}
     {                Search W_A                 }
     If (mSearchIn = 'o') Or (mSearchIn = 'a') Then Begin

          StartCounter := 0;
          EndCounter := W_A.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;

          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_A[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_A[i]));
               End;
          End;
     End;
     {*****************************************}



     {*****************************************}
     {                Search W_AA                 }
     If {$IFDEF FASTSEARCH_OFF}(mSearchIn = 'r') Or {$ENDIF}
     (mSearchIn = 'i') Or (mSearchIn = 'a') Then Begin

          StartCounter := 0;
          EndCounter := W_AA.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_AA[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_AA[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_I                 }
     If (mSearchIn = 'y')
          {$IFDEF FASTSEARCH_OFF} Or (mSearchIn = 'u'){$ENDIF}
     Or (mSearchIn = 'i')
          Or (mSearchIn = 'e') Then Begin

          StartCounter := 0;
          EndCounter := W_I.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_I[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_I[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_II                 }
     If (mSearchIn = 'i') Or (mSearchIn = 'e') Then Begin

          StartCounter := 0;
          EndCounter := W_II.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_II[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_II[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_U                 }
     If (mSearchIn = 'u') Or (mSearchIn = 'o') Then Begin

          StartCounter := 0;
          EndCounter := W_U.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_U[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_U[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_UU                 }
     If (mSearchIn = 'u') Or (mSearchIn = 'o') Then Begin

          StartCounter := 0;
          EndCounter := W_UU.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_UU[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_UU[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_RRI                 }
     If (mSearchIn = 'r') Then Begin

          StartCounter := 0;
          EndCounter := W_RRI.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_RRI[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_RRI[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_E                 }
     If (mSearchIn = 'x'){$IFDEF FASTSEARCH_OFF} Or (mSearchIn = 's') Or (mSearchIn = 'n') Or (mSearchIn = 'm')
     Or (mSearchIn = 'l') Or (mSearchIn = 'h') Or (mSearchIn = 'f'){$ENDIF}
     Or (mSearchIn = 'e') Or (mSearchIn = 'a') Then Begin

          StartCounter := 0;
          EndCounter := W_E.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_E[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_E[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_OI                 }
     If (mSearchIn = 'a') Or (mSearchIn = 'o') Then Begin

          StartCounter := 0;
          EndCounter := W_OI.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_OI[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_OI[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_O                 }
     If {$IFDEF FASTSEARCH_OFF}(mSearchIn = 'y') Or {$ENDIF}(mSearchIn = 'w') Or (mSearchIn = 'o')
     Or (mSearchIn = 'a') Then Begin

          StartCounter := 0;
          EndCounter := W_O.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_O[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_O[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_OU                 }
     If (mSearchIn = 'o') Then Begin

          StartCounter := 0;
          EndCounter := W_OU.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_OU[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_OU[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_B                 }
     If (mSearchIn = 'b') Then Begin

          StartCounter := 0;
          EndCounter := W_B.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_B[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_B[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_BH                 }
     If (mSearchIn = 'b') Or (mSearchIn = 'v') Then Begin

          StartCounter := 0;
          EndCounter := W_BH.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_BH[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_BH[i]));
               End;
          End;
     End;
     {*****************************************}



     {*****************************************}
     {                Search W_C                 }
     If (mSearchIn = 'c') Then Begin

          StartCounter := 0;
          EndCounter := W_C.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_C[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_C[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_CH                 }
     If (mSearchIn = 'c') Then Begin

          StartCounter := 0;
          EndCounter := W_CH.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_CH[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_CH[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_D                 }
     If (mSearchIn = 'd') Then Begin

          StartCounter := 0;
          EndCounter := W_D.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_D[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_D[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Dh                 }
     If (mSearchIn = 'd') Then Begin

          StartCounter := 0;
          EndCounter := W_Dh.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Dh[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Dh[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Dd                 }
     If {$IFDEF FASTSEARCH_OFF}(mSearchIn = 'w') Or {$ENDIF}(mSearchIn = 'd') Then Begin

          StartCounter := 0;
          EndCounter := W_Dd.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Dd[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Dd[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Ddh                 }
     If (mSearchIn = 'd') Then Begin

          StartCounter := 0;
          EndCounter := W_Ddh.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Ddh[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Ddh[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_G                 }
     If (mSearchIn = 'g') Then Begin

          StartCounter := 0;
          EndCounter := W_G.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_G[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_G[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Gh                 }
     If (mSearchIn = 'g') Then Begin

          StartCounter := 0;
          EndCounter := W_Gh.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Gh[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Gh[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_H                 }
     If (mSearchIn = 'z') Or (mSearchIn = 'r') Or (mSearchIn = 'm')
          Or (mSearchIn = 'h') Then Begin

          StartCounter := 0;
          EndCounter := W_H.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_H[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_H[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_J                 }
     If (mSearchIn = 'z') Or (mSearchIn = 'j') Or (mSearchIn = 'g') Then Begin

          StartCounter := 0;
          EndCounter := W_J.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_J[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_J[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Jh                 }
     If (mSearchIn = 'j') Or (mSearchIn = 'z') Then Begin

          StartCounter := 0;
          EndCounter := W_Jh.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Jh[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Jh[i]));
               End;
          End;
     End;
     {*****************************************}



     {*****************************************}
     {                Search W_K                 }
     If (mSearchIn = 'x') Or (mSearchIn = 'q') Or (mSearchIn = 'k')
          Or (mSearchIn = 'c') Then Begin

          StartCounter := 0;
          EndCounter := W_K.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_K[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_K[i]));
               End;
          End;
     End;
     {*****************************************}



     {*****************************************}
     {                Search W_Kh                 }
     If (mSearchIn = 'k') Then Begin

          StartCounter := 0;
          EndCounter := W_Kh.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Kh[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Kh[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_L                 }
     If (mSearchIn = 'l') Then Begin

          StartCounter := 0;
          EndCounter := W_L.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_L[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_L[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_M                 }
     If (mSearchIn = 'm') Then Begin

          StartCounter := 0;
          EndCounter := W_M.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_M[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_M[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_N                 }
     If (mSearchIn = 'n') Then Begin

          StartCounter := 0;
          EndCounter := W_N.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_N[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_N[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_NGA                 }
     If (mSearchIn = 'n') Then Begin

          StartCounter := 0;
          EndCounter := W_NGA.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_NGA[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_NGA[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_NYA                 }
     If (mSearchIn = 'n') Or (mSearchIn = 'a') Then Begin

          StartCounter := 0;
          EndCounter := W_NYA.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_NYA[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_NYA[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Nn                 }
     If (mSearchIn = 'n') Then Begin

          StartCounter := 0;
          EndCounter := W_Nn.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Nn[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Nn[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_P                    }
     If (mSearchIn = 'p') Then Begin

          StartCounter := 0;
          EndCounter := W_P.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_P[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_P[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Ph                 }
     If (mSearchIn = 'p') Or (mSearchIn = 'f') Then Begin

          StartCounter := 0;
          EndCounter := W_Ph.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Ph[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Ph[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_R                 }
     If (mSearchIn = 'r') Then Begin

          StartCounter := 0;
          EndCounter := W_R.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_R[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_R[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Rr                 }
     If (mSearchIn = 'r') Then Begin

          StartCounter := 0;
          EndCounter := W_Rr.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Rr[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Rr[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Rrh                 }
     If (mSearchIn = 'r') Then Begin

          StartCounter := 0;
          EndCounter := W_Rrh.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Rrh[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Rrh[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_S                 }
     If (mSearchIn = 's'){$IFDEF FASTSEARCH_OFF} Or (mSearchIn = 'c'){$ENDIF} Then Begin

          StartCounter := 0;
          EndCounter := W_S.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_S[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_S[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Sh                 }
     If (mSearchIn = 's') Then Begin

          StartCounter := 0;
          EndCounter := W_Sh.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Sh[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Sh[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Ss                 }
     If (mSearchIn = 's'){$IFDEF FASTSEARCH_OFF} Or (mSearchIn = 'x'){$ENDIF} Then Begin

          StartCounter := 0;
          EndCounter := W_Ss.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Ss[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Ss[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_T                 }
     If (mSearchIn = 't') Then Begin

          StartCounter := 0;
          EndCounter := W_T.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_T[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_T[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Th                 }
     If (mSearchIn = 't') Then Begin

          StartCounter := 0;
          EndCounter := W_Th.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Th[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Th[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Tt                 }
     If (mSearchIn = 't') Then Begin

          StartCounter := 0;
          EndCounter := W_Tt.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Tt[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Tt[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Tth                 }
     If (mSearchIn = 't') Then Begin

          StartCounter := 0;
          EndCounter := W_Tth.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Tth[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Tth[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Y                 }
     If (mSearchIn = 'u') Or (mSearchIn = 'o') Or (mSearchIn = 'i')
          Or (mSearchIn = 'e') Or (mSearchIn = 'a') or (mSearchIn='y') Then Begin

          StartCounter := 0;
          EndCounter := W_Y.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Y[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Y[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Z                 }
     If (mSearchIn = 'j') Or (mSearchIn = 'z') Then Begin

          StartCounter := 0;
          EndCounter := W_Z.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Z[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Z[i]));
               End;
          End;
     End;
     {*****************************************}


     {*****************************************}
     {                Search W_Khandatta                 }
     If (mSearchIn = 't') Then Begin

          StartCounter := 0;
          EndCounter := W_Khandatta.Count-1;
          TotalSearch := TotalSearch + EndCounter + 1;


          For I := StartCounter To EndCounter Do Begin
               theMatch := theRegex.Match(W_Khandatta[i], RegExOpt);
               If theMatch.Success Then Begin
                    wList.Add(utf8decode(W_Khandatta[i]));
               End;
          End;
     End;
     {*****************************************}



     wList.EndUpdate;

     Result := TotalSearch;
End;

End.

