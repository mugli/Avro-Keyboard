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

{$IFDEF SpellChecker}
{$INCLUDE ../../ProjectDefines.inc}
{$ELSE}
{$INCLUDE ../ProjectDefines.inc}
{$ENDIF}

{COMPLETE TRANSFERING!}

Unit clsFileVersion;

Interface

Uses Windows,
     SysUtils,
     Classes,
     Forms;

Type

     {TFileVersion Class}
     TFileVersion = Class(TObject)
     Private
          FMajor, FMinor,
               FRelease, FBuild: word;
          FFileName: String;
          Procedure SetFFileName(Const AValue: String);
          Function GetAsString: String;
          Function GetAsStringZero: String;
          Function GetAsHex: String;
          Function GetAsHexDelim: String;
          Function GetAsInt64: Int64;
     Protected
          Procedure GetVersionInfo;
     Public
          Constructor Create(Const AFileName: String = '');
          // Properties
          Property FileName: String Read FFileName Write SetFFileName;
          Property VerMajor: word Read FMajor;
          Property VerMinor: word Read FMinor;
          Property VerRelease: word Read FRelease;
          Property VerBuild: word Read FBuild;
          Property AsString: String Read GetAsString;
          Property AsStringZero: String Read GetAsStringZero;
          Property AsHex: String Read GetAsHex;
          Property AsHexDelim: String Read GetAsHexDelim;
          Property AsInt64: Int64 Read GetAsInt64;
     End;


Implementation

{===============================================================================}

Constructor TFileVersion.Create(Const AFileName: String = '');
Begin
     Inherited Create;

     If AFileName = '' Then
          FFileName := ExtractFilePath(Application.ExeName) +
               ExtractFileName(Application.ExeName)
     Else
          FFileName := AFileName;

     GetVersionInfo;
End;

{===============================================================================}

Procedure TFileVersion.SetFFileName(Const AValue: String);
Begin
     FFileName := AValue;
     GetVersionInfo;
End;

{===============================================================================}

Function TFileVersion.GetAsString: String;
Begin
     Result := IntToStr(FMajor) + '.' + IntToStr(FMinor) + '.' +
          IntToStr(FRelease) + '.' + IntToStr(FBuild);
End;

{===============================================================================}

Function TFileVersion.GetAsStringZero: String;
Begin
     Result := FormatFloat('000', FMajor Mod 1000) + '.' +
          FormatFloat('000', FMinor Mod 1000) + '.' +
          FormatFloat('000', FRelease Mod 1000) + '.' +
          FormatFloat('000', FBuild Mod 1000);
End;

{===============================================================================}

Function TFileVersion.GetAsHex: String;
Begin
     Result := IntToHex(FMajor, 4) + IntToHex(FMinor, 4) +
          IntToHex(FRelease, 4) + IntToHex(FBuild, 4);
End;

{===============================================================================}

Function TFileVersion.GetAsHexDelim: String;
Begin
     Result := IntToHex(FMajor, 4) + '-' + IntToHex(FMinor, 4) + '-' +
          IntToHex(FRelease, 4) + '-' + IntToHex(FBuild, 4);
End;

{===============================================================================}

Function TFileVersion.GetAsInt64: Int64;
Var
     iResult                  : Int64;
Begin
     iResult := FMajor;
     iResult := (iResult Shl 16) + FMinor;
     iResult := (iResult Shl 16) + FRelease;
     iResult := (iResult Shl 16) + FBuild;

     Result := iResult;
End;

{===============================================================================}

Procedure TFileVersion.GetVersionInfo;
Var
     iVerInfoSize, iVerValueSize, iDummy: DWORD;
     pVerInfo                 : Pointer;
     rVerValue                : PVSFixedFileInfo;
Begin
     FMajor := 0;
     FMinor := 0;
     FRelease := 0;
     FBuild := 0;
     iVerInfoSize := GetFileVersionInfoSize(PChar(FFileName), iDummy);

     If iVerInfoSize > 0 Then Begin
          GetMem(pVerInfo, iVerInfoSize);

          Try
               GetFileVersionInfo(PChar(FFileName), 0, iVerInfoSize, pVerInfo);
               VerQueryValue(pVerInfo, '\', Pointer(rVerValue), iVerValueSize);

               With rVerValue^ Do Begin
                    FMajor := dwFileVersionMS Shr 16;
                    FMinor := dwFileVersionMS And $FFFF;
                    FRelease := dwFileVersionLS Shr 16;
                    FBuild := dwFileVersionLS And $FFFF;
               End;
          Finally
               FreeMem(pVerInfo, iVerInfoSize);
          End;
     End;
End;

{===============================================================================}

End.
