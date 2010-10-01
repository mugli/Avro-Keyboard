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

Unit uCmdLineHelper;

Interface

Uses windows,
     sysutils;



//command line parameters + program path
Function GetCommandLine: String;
//number of parameters
Function GetParamCount: Integer;
//parameter by index
Function GetParamStr(Index: Integer): String;

Function ParamPresent(Param: String): Boolean;

Implementation

{===============================================================================}

Function ParamPresent(Param: String): Boolean;
Var
     i                        : integer;
Begin
     result := False;
     If uCmdLineHelper.GetParamCount <= 0 Then exit;

     For i := 1 To uCmdLineHelper.GetParamCount Do Begin
          If (UpperCase(uCmdLineHelper.GetParamStr(i)) = '/' + UpperCase(Param)) Or
               (UpperCase(uCmdLineHelper.GetParamStr(i)) = '-' + UpperCase(Param)) Or
               (UpperCase(uCmdLineHelper.GetParamStr(i)) = '--' + UpperCase(Param)) Or
               (UpperCase(uCmdLineHelper.GetParamStr(i)) = UpperCase(Param)) Then Begin

               Result := True;
          End;
     End;
End;

{===============================================================================}

Function GetCommandLine: String;
Begin
     result := windows.GetCommandLine;
End;

{===============================================================================}

Function GetNextParam(Var CmdLine: PChar; Buffer: PChar; Len: PInteger): Boolean;
Var
     InQuotedStr, IsOdd       : Boolean;
     NumSlashes, NewLen, cnt  : Integer;
Begin
     Result := False;
     If Len <> Nil Then Len^ := 0;
     If CmdLine = Nil Then Exit;
     While (CmdLine^ <= ' ') And (CmdLine^ <> #0) Do
          CmdLine := CharNext(CmdLine);
     If CmdLine^ = #0 Then Exit;
     InQuotedStr := False;
     NewLen := 0;
     Repeat
          If CmdLine^ = '\' Then Begin
               NumSlashes := 0;
               Repeat
                    Inc(NumSlashes);
                    CmdLine := CharNext(CmdLine);
               Until CmdLine^ <> '\';
               If CmdLine^ = '"' Then Begin
                    IsOdd := (NumSlashes Mod 2) <> 0;
                    NumSlashes := NumSlashes Div 2;
                    Inc(NewLen, NumSlashes);
                    If IsOdd Then Inc(NewLen);
                    If Buffer <> Nil Then Begin
                         For cnt := 0 To NumSlashes - 1 Do Begin
                              Buffer^ := '\';
                              Inc(Buffer);
                         End;
                         If IsOdd Then Begin
                              Buffer^ := '"';
                              Inc(Buffer);
                         End;
                    End;
                    If IsOdd Then CmdLine := CharNext(CmdLine);
               End
               Else Begin
                    Inc(NewLen, NumSlashes);
                    If Buffer <> Nil Then Begin
                         For cnt := 0 To NumSlashes - 1 Do Begin
                              Buffer^ := '\';
                              Inc(Buffer);
                         End;
                    End;
               End;
               Continue;
          End;
          If CmdLine^ <> '"' Then Begin
               If (CmdLine^ <= ' ') And (Not InQuotedStr) Then Break;
               Inc(NewLen);
               If Buffer <> Nil Then Begin
                    Buffer^ := CmdLine^;
                    Inc(Buffer);
               End;
          End
          Else
               InQuotedStr := Not InQuotedStr;
          CmdLine := CharNext(CmdLine);
     Until CmdLine^ = #0;
     If Len <> Nil Then Len^ := NewLen;
     Result := True;
End;

{===============================================================================}

Function GetParamCount: Integer;
Var
     CmdLine                  : PChar;
Begin
     Result := 0;
     CmdLine := windows.GetCommandLine;
     GetNextParam(CmdLine, Nil, Nil);
     While GetNextParam(CmdLine, Nil, Nil) Do
          Inc(Result);
End;

{===============================================================================}

Function GetParamStr(Index: Integer): String;
Var
     Buffer                   : Array[0..MAX_PATH] Of Char;
     CmdLine, P               : PChar;
     Len                      : Integer;
Begin
     Result := '';
     If Index <= 0 Then Begin
          Len := GetModuleFileName(0, Buffer, MAX_PATH + 1);
          SetString(Result, Buffer, Len);
     End
     Else Begin
          CmdLine := windows.GetCommandLine;
          GetNextParam(CmdLine, Nil, Nil);
          Repeat
               Dec(Index);
               If Index = 0 Then Break;
               If Not GetNextParam(CmdLine, Nil, Nil) Then Exit;
          Until False;
          P := CmdLine;
          If GetNextParam(P, Nil, @Len) Then Begin
               SetLength(Result, Len);
               GetNextParam(CmdLine, PChar(Result), Nil);
          End;
     End;
End;

{===============================================================================}

End.

