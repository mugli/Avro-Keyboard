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

Unit u_VirtualFontInstall;

Interface
Uses
     Windows,
     SysUtils,
     classes,
     Messages;


Procedure InstallVirtualFont(FontFilePath: String);
Procedure RemoveVirtualFont(FontFilePath: String);



//Privately used
Function GetTempDirectory: String;
Function GetFontName(TTF_Path: String): String;
Procedure CheckDeleteTempFile(fname: String);

Implementation

Uses
     clsRegistry_XMLSetting;

{===============================================================================}

Function GetTempDirectory: String;
Var
     tempFolder               : Array[0..MAX_PATH] Of Char;
Begin
     GetTempPath(MAX_PATH, @tempFolder);
     result := StrPas(tempFolder);
End;

{===============================================================================}

Procedure CheckDeleteTempFile(fname: String);
Begin
     If fileexists(fname) Then
          DeleteFile(fname);

End;

{===============================================================================}

Function GetFontName(TTF_Path: String): String;
Var
     TempName, FontName, AInfo: String;
     S                        : TFileStream;
     APos                     : Integer;
Begin
     TempName := GetTempDirectory + 'tmpfntavro.tmp';
     CheckDeleteTempFile(TempName);


     If CreateScalableFontResource(
          0,                            // Hidden
          pchar(TempName),              // FON file
          pchar(TTF_Path),              // TTF file
          Nil) {// Path - not required} Then Begin

     End;

     Try
          FontName := '';
          S := TFileStream.Create(TempName, fmOpenRead Or fmShareDenyWrite);
          Try
               // Copy resource to string
               SetLength(AInfo, S.Size);
               S.Read(AInfo[1], S.Size);
               // Find FONTRES:
               APos := Pos('FONTRES:', AInfo);
               // This is followed by the font typeface name (null terminated)
               If APos > 0 Then
                    FontName := PChar(@AInfo[APos + 8]);
          Except
               On e: exception Do Begin
                    //nothing
               End;
          End;
     Finally
          S.Free;
          CheckDeleteTempFile(TempName);
     End;
     result := FontName;
End;

{===============================================================================}

Procedure InstallVirtualFont(FontFilePath: String);
Var
     PrevDefaultFixedFont, PrevDefaultPropFont, VirtualFontName: String;
     Reg                      : TMyRegistry;
Begin
     Reg := TMyRegistry.Create;
     AddFontResource(PChar(FontFilePath));
     VirtualFontName := GetFontName(FontFilePath);

     Reg.RootKey := HKEY_CURRENT_USER;
     If Reg.OpenKey('Software\Microsoft\Internet Explorer\International\Scripts\11', True) = True Then Begin
          PrevDefaultFixedFont := trim(REG.ReadString('IEFixedFontName'));
          PrevDefaultPropFont := trim(REG.ReadString('IEPropFontName'));

          If PrevDefaultFixedFont = '' Then PrevDefaultFixedFont := 'none';
          If PrevDefaultPropFont = '' Then PrevDefaultPropFont := 'none';

          If trim(REG.ReadString('IEFixedFontName_Prev')) = '' Then
               reg.WriteString('IEFixedFontName_Prev', PrevDefaultFixedFont);

          If trim(REG.ReadString('IEPropFontName_Prev')) = '' Then
               reg.WriteString('IEPropFontName_Prev', PrevDefaultPropFont);

          reg.WriteString('IEFixedFontName', VirtualFontName);
          reg.WriteString('IEPropFontName', VirtualFontName);

     End;

     SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
     FreeAndNil(Reg);
End;

{===============================================================================}

Procedure RemoveVirtualFont(FontFilePath: String);
Var
     PrevDefaultFixedFont, PrevDefaultPropFont: String;
     Reg                      : TMyRegistry;
Begin
     Reg := TMyRegistry.Create;
     RemoveFontResource(PChar(FontFilePath));

     If Reg.OpenKey('Software\Microsoft\Internet Explorer\International\Scripts\11', True) = True Then Begin
          PrevDefaultFixedFont := trim(REG.ReadString('IEFixedFontName_Prev'));
          PrevDefaultPropFont := trim(REG.ReadString('IEPropFontName_Prev'));

          If PrevDefaultFixedFont = 'none' Then PrevDefaultFixedFont := '';
          If PrevDefaultPropFont = 'none' Then PrevDefaultPropFont := '';

          reg.DeleteValue('IEFixedFontName_Prev');
          reg.DeleteValue('IEPropFontName_Prev');

          reg.WriteString('IEFixedFontName', PrevDefaultFixedFont);
          reg.WriteString('IEPropFontName', PrevDefaultPropFont);

     End;

     SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
     FreeAndNil(Reg);
End;



End.

