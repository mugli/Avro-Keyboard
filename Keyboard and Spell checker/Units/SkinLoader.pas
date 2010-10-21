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

{COMPLETE TRANSFERING EXCEPT SKIN CONVERSION}

Unit SkinLoader;

Interface

Uses
     Classes,
     SysUtils,
     Forms,
     Windows,
     NativeXml,
     Graphics;

Function LoadSkin(Const FullSkinPath: String): Boolean;
Procedure GetSkinPreviewPicture(Const SkinPath: String; Pic: TPicture);
Function GetSkinDescription(Const SkinPath: String): Boolean;
Function InstallSkin(Const SkinPath: String): Boolean;


Implementation
{$R ../Skin/Internal_Skin.res}
{ DONE : Add final skin here }

Uses
     uTopBar,
     ufrmAboutSkinLayout,
     uWindowHandlers,
     clsSkinLayoutConverter,
     uFileFolderHandling;
{$HINTS Off}

Function LoadSkin(Const FullSkinPath: String): Boolean;
Var
     XML                      : TNativeXml;
     Stream                   : TStringStream;

     AvroIconAdded            : Boolean;
     KeyboardModeAdded        : Boolean;
     KeyboardLayoutAdded      : Boolean;
     LayoutViewerAdded        : Boolean;
     AvroMouseAdded           : Boolean;
     ToolsAdded               : Boolean;
     WebAdded                 : Boolean;
     HelpAdded                : Boolean;
     ExitAdded                : Boolean;
     Resource                 : TResourceStream;
     m_Converter              : TSkinLayoutConverter;
Begin
     Result := False;
     AvroIconAdded := False;
     KeyboardModeAdded := False;
     KeyboardLayoutAdded := False;
     LayoutViewerAdded := False;
     AvroMouseAdded := False;
     ToolsAdded := False;
     WebAdded := False;
     HelpAdded := False;
     ExitAdded := False;
     Try
          Try
               XML := TNativeXml.Create;
               XML.ExternalEncoding := seUTF8;


               If LowerCase(FullSkinPath) <> 'internalskin*' Then Begin
                    m_Converter := TSkinLayoutConverter.Create;
                    m_Converter.CheckConvertSkin(FullSkinPath);
                    FreeAndNil(m_Converter);
                    XML.LoadFromFile(FullSkinPath);
               End
               Else Begin
                    Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
                    XML.LoadFromStream(Resource);
                    FreeAndNil(Resource);
               End;

               //----------------------------------------------
               //Check if the skin is a compatible one
               If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsUnicodeString) <> '5' Then Begin
                    Application.MessageBox('This Skin is not compatible with current version of Avro Keyboard.', 'Error loading skin...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    Result := False;
                    Exit;
               End;
               //----------------------------------------------

               //'Which buttons are added?
               If trim(Xml.Root.FindNode('AvroIconAdded').ValueAsUnicodeString) = '1' Then
                    AvroIconAdded := True;

               If trim(Xml.Root.FindNode('KeyboardModeAdded').ValueAsUnicodeString) = '1' Then
                    KeyboardModeAdded := True;

               If trim(Xml.Root.FindNode('KeyboardLayoutAdded').ValueAsUnicodeString) = '1' Then
                    KeyboardLayoutAdded := True;

               If trim(Xml.Root.FindNode('LayoutViewerAdded').ValueAsUnicodeString) = '1' Then
                    LayoutViewerAdded := True;

               If trim(Xml.Root.FindNode('AvroMouseAdded').ValueAsUnicodeString) = '1' Then
                    AvroMouseAdded := True;

               If trim(Xml.Root.FindNode('ToolsAdded').ValueAsUnicodeString) = '1' Then
                    ToolsAdded := True;

               If trim(Xml.Root.FindNode('WebAdded').ValueAsUnicodeString) = '1' Then
                    WebAdded := True;

               If trim(Xml.Root.FindNode('HelpAdded').ValueAsUnicodeString) = '1' Then
                    HelpAdded := True;

               If trim(Xml.Root.FindNode('ExitAdded').ValueAsUnicodeString) = '1' Then
                    ExitAdded := True;

               //----------------------------------------------

               //Skin the TopBar
               Stream := TStringStream.Create(Xml.Root.FindNode('TopBarMain').BinaryString);
               Topbar.ImgMain.Picture.Bitmap.LoadFromStream(Stream);
               Stream.Free;
               TopBar.Height := Xml.Root.FindNode('TopBarHeight').ValueAsInteger;
               TopBar.Width := Xml.Root.FindNode('TopBarWidth').ValueAsInteger;
               //----------------------------------------------

               //Skin Buttons
               If AvroIconAdded = True Then Begin
                    Topbar.ImgAppIcon.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('AvroIconNormal').BinaryString);
                    Topbar.BMP_AppIcon.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('AvroIconDown').BinaryString);
                    Topbar.BMP_AppIcon_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('AvroIconOver').BinaryString);
                    Topbar.BMP_AppIcon_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgAppIcon.Height := Xml.Root.FindNode('AvroIconHeight').ValueAsInteger;
                    TopBar.ImgAppIcon.Width := Xml.Root.FindNode('AvroIconWidth').ValueAsInteger;
                    TopBar.ImgAppIcon.Top := Xml.Root.FindNode('AvroIconTop').ValueAsInteger;
                    TopBar.ImgAppIcon.Left := Xml.Root.FindNode('AvroIconLeft').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgAppIcon.Visible := False;
               End;



               If KeyboardModeAdded = True Then Begin
                    Topbar.ImgButtonMode.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardModeEnglishNormal').BinaryString);
                    Topbar.BMP_ButtonModeE.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardModeEnglishDown').BinaryString);
                    Topbar.BMP_ButtonModeE_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardModeEnglishOver').BinaryString);
                    Topbar.BMP_ButtonModeE_Over.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardModeBanglaNormal').BinaryString);
                    Topbar.BMP_ButtonModeB.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardModeBanglaDown').BinaryString);
                    Topbar.BMP_ButtonModeB_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardModeBanglaOver').BinaryString);
                    Topbar.BMP_ButtonModeB_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonMode.Height := Xml.Root.FindNode('KeyboardModeHeight').ValueAsInteger;
                    TopBar.ImgButtonMode.Width := Xml.Root.FindNode('KeyboardModeWidth').ValueAsInteger;
                    TopBar.ImgButtonMode.Top := Xml.Root.FindNode('KeyboardModeTop').ValueAsInteger;
                    TopBar.ImgButtonMode.Left := Xml.Root.FindNode('KeyboardModeLeft').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonMode.Visible := False;
               End;


               If KeyboardLayoutAdded = True Then Begin
                    Topbar.ImgButtonLayoutDown.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardLayoutNormal').BinaryString);
                    Topbar.BMP_ButtonLayoutDown.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardLayoutDown').BinaryString);
                    Topbar.BMP_ButtonLayoutDown_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('KeyboardLayoutOver').BinaryString);
                    Topbar.BMP_ButtonLayoutDown_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonLayoutDown.Height := Xml.Root.FindNode('KeyboardLayoutHeight').ValueAsInteger;
                    TopBar.ImgButtonLayoutDown.Width := Xml.Root.FindNode('KeyboardLayoutWidth').ValueAsInteger;
                    TopBar.ImgButtonLayoutDown.Top := Xml.Root.FindNode('KeyboardLayoutTop').ValueAsInteger;
                    TopBar.ImgButtonLayoutDown.Left := Xml.Root.FindNode('KeyboardLayoutLeft').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonLayoutDown.Visible := False;
               End;


               If LayoutViewerAdded = True Then Begin
                    Topbar.ImgButtonLayout.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('LayoutViewerNormal').BinaryString);
                    Topbar.BMP_ButtonLayout.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('LayoutViewerDown').BinaryString);
                    Topbar.BMP_ButtonLayout_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('LayoutViewerOver').BinaryString);
                    Topbar.BMP_ButtonLayout_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonLayout.Height := Xml.Root.FindNode('LayoutViewerHeight').ValueAsInteger;
                    TopBar.ImgButtonLayout.Width := Xml.Root.FindNode('LayoutViewerWidth').ValueAsInteger;
                    TopBar.ImgButtonLayout.Top := Xml.Root.FindNode('LayoutViewerTop').ValueAsInteger;
                    TopBar.ImgButtonLayout.Left := Xml.Root.FindNode('LayoutViewerLeft').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonLayout.Visible := False;
               End;


               If AvroMouseAdded = True Then Begin
                    Topbar.ImgButtonMouse.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('AvroMouseNormal').BinaryString);
                    Topbar.BMP_ButtonMouse.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('AvroMouseDown').BinaryString);
                    Topbar.BMP_ButtonMouse_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('AvroMouseOver').BinaryString);
                    Topbar.BMP_ButtonMouse_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonMouse.Height := Xml.Root.FindNode('AvroMouseHeight').ValueAsInteger;
                    TopBar.ImgButtonMouse.Width := Xml.Root.FindNode('AvroMouseWidth').ValueAsInteger;
                    TopBar.ImgButtonMouse.Top := Xml.Root.FindNode('AvroMouseTop').ValueAsInteger;
                    TopBar.ImgButtonMouse.Left := Xml.Root.FindNode('AvroMouseLeft').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonMouse.Visible := False;
               End;


               If ToolsAdded = True Then Begin
                    Topbar.ImgButtonTools.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('ToolsNormal').BinaryString);
                    Topbar.BMP_ButtonTools.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('ToolsDown').BinaryString);
                    Topbar.BMP_ButtonTools_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('ToolsOver').BinaryString);
                    Topbar.BMP_ButtonTools_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonTools.Height := Xml.Root.FindNode('ToolsHeight').ValueAsInteger;
                    TopBar.ImgButtonTools.Width := Xml.Root.FindNode('ToolsWidth').ValueAsInteger;
                    TopBar.ImgButtonTools.Top := Xml.Root.FindNode('ToolsTop').ValueAsInteger;
                    TopBar.ImgButtonTools.Left := Xml.Root.FindNode('ToolsLeft').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonTools.Visible := False;
               End;



               If WebAdded = True Then Begin
                    Topbar.ImgButtonWWW.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('WebNormal').BinaryString);
                    Topbar.BMP_ButtonWWW.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('WebDown').BinaryString);
                    Topbar.BMP_ButtonWWW_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('WebOver').BinaryString);
                    Topbar.BMP_ButtonWWW_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonWWW.Height := Xml.Root.FindNode('WebHeight').ValueAsInteger;
                    TopBar.ImgButtonWWW.Width := Xml.Root.FindNode('WebWidth').ValueAsInteger;
                    TopBar.ImgButtonWWW.Left := Xml.Root.FindNode('WebLeft').ValueAsInteger;
                    TopBar.ImgButtonWWW.Top := Xml.Root.FindNode('WebTop').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonWWW.Visible := False;
               End;


               If HelpAdded = True Then Begin
                    Topbar.ImgButtonHelp.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('HelpNormal').BinaryString);
                    Topbar.BMP_ButtonHelp.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('HelpDown').BinaryString);
                    Topbar.BMP_ButtonHelp_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('HelpOver').BinaryString);
                    Topbar.BMP_ButtonHelp_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonHelp.Height := Xml.Root.FindNode('HelpHeight').ValueAsInteger;
                    TopBar.ImgButtonHelp.Width := Xml.Root.FindNode('HelpWidth').ValueAsInteger;
                    TopBar.ImgButtonHelp.Left := Xml.Root.FindNode('HelpLeft').ValueAsInteger;
                    TopBar.ImgButtonHelp.Top := Xml.Root.FindNode('HelpTop').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonHelp.Visible := False;
               End;


               If ExitAdded = True Then Begin
                    Topbar.ImgButtonMinimize.Visible := True;
                    Stream := TStringStream.Create(Xml.Root.FindNode('ExitNormal').BinaryString);
                    Topbar.BMP_ButtonMinimize.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('ExitDown').BinaryString);
                    Topbar.BMP_ButtonMinimize_Down.LoadFromStream(Stream);
                    Stream.Free;
                    Stream := TStringStream.Create(Xml.Root.FindNode('ExitOver').BinaryString);
                    Topbar.BMP_ButtonMinimize_Over.LoadFromStream(Stream);
                    Stream.Free;
                    TopBar.ImgButtonMinimize.Height := Xml.Root.FindNode('ExitHeight').ValueAsInteger;
                    TopBar.ImgButtonMinimize.Width := Xml.Root.FindNode('ExitWidth').ValueAsInteger;
                    TopBar.ImgButtonMinimize.Left := Xml.Root.FindNode('ExitLeft').ValueAsInteger;
                    TopBar.ImgButtonMinimize.Top := Xml.Root.FindNode('ExitTop').ValueAsInteger;
               End
               Else Begin
                    Topbar.ImgButtonMinimize.Visible := False;
               End;

               //----------------------------------------------


               //Loading skin is succefull
               Result := True;
          Except
               On E: Exception Do Begin
                    Application.MessageBox(PChar('Error loading skin!' + #10 + '' + #10 + 'Make sure ' + ExtractFileName(FullSkinPath) + ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    Result := False;
               End;
          End;
     Finally
          FreeAndNil(XML);
     End;
End;
{$HINTS On}

Procedure GetSkinPreviewPicture(Const SkinPath: String; Pic: TPicture);
Var
     XML                      : TNativeXml;
     Stream                   : TStringStream;
     Resource                 : TResourceStream;
     m_Converter              : TSkinLayoutConverter;
Begin
     Try
          Try
               XML := TNativeXml.Create;
               XML.ExternalEncoding := seUTF8;

               If LowerCase(SkinPath) <> 'internalskin*' Then Begin
                    m_Converter := TSkinLayoutConverter.Create;
                    m_Converter.CheckConvertSkin(SkinPath);
                    FreeAndNil(m_Converter);
                    XML.LoadFromFile(SkinPath);
               End
               Else Begin
                    Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
                    XML.LoadFromStream(Resource);
                    FreeAndNil(Resource);
               End;

               //----------------------------------------------
               //Check if the skin is a compatible one
               If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsUnicodeString) <> '5' Then Begin
                    Application.MessageBox('This Skin is not compatible with current version of Avro Keyboard.', 'Error loading skin...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    Exit;
               End;
               //----------------------------------------------


               Stream := TStringStream.Create(Xml.Root.FindNode('Preview').BinaryString);
               Pic.Bitmap.LoadFromStream(Stream);
               Stream.Free;

          Except
               On E: Exception Do Begin
                    Application.MessageBox(Pchar('Error loading skin preview image!' + #10 + '' + #10 + 'Make sure ' + ExtractFileName(SkinPath) + ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
               End;
          End;
     Finally
          FreeAndNil(XML);
     End;
End;

Function GetSkinDescription(Const SkinPath: String): Boolean;
Var
     XML                      : TNativeXml;
     Resource                 : TResourceStream;

     SkinName, DesignerName, SkinVersion, DesignerComment: String;
     m_Converter              : TSkinLayoutConverter;
Begin
     result := False;
     Try
          Try
               XML := TNativeXml.Create;
               XML.ExternalEncoding := seUTF8;

               If LowerCase(SkinPath) <> 'internalskin*' Then Begin
                    m_Converter := TSkinLayoutConverter.Create;
                    m_Converter.CheckConvertSkin(SkinPath);
                    FreeAndNil(m_Converter);
                    XML.LoadFromFile(SkinPath);
               End
               Else Begin
                    Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
                    XML.LoadFromStream(Resource);
                    FreeAndNil(Resource);
               End;

               //----------------------------------------------
               //Check if the skin is a compatible one
               If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsUnicodeString) <> '5' Then Begin
                    Application.MessageBox('This Skin is not compatible with current version of Avro Keyboard.', 'Error loading skin...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    Exit;
               End;
               //----------------------------------------------

               SkinName := Xml.Root.FindNode('SkinName').Nodes[0].ValueAsUnicodeString;
               DesignerName := Xml.Root.FindNode('DesignerName').Nodes[0].ValueAsUnicodeString;
               SkinVersion := Xml.Root.FindNode('SkinVersion').Nodes[0].ValueAsUnicodeString;
               DesignerComment := Xml.Root.FindNode('DesignerComment').Nodes[0].ValueAsUnicodeString;

               CheckCreateForm(TfrmAboutSkinLayout, frmAboutSkinLayout, 'frmAboutSkinLayout');

               frmAboutSkinLayout.txtName.text := SkinName;
               frmAboutSkinLayout.txtVersion.text := SkinVersion;
               frmAboutSkinLayout.txtDeveloper.text := DesignerName;
               frmAboutSkinLayout.txtComment.text := DesignerComment;

               frmAboutSkinLayout.ShowDescription;

          Except
               On E: Exception Do Begin
                    Application.MessageBox(PChar('Error loading skin description!' + #10 + '' + #10 + 'Make sure ' + ExtractFileName(SkinPath) + ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    result := False;
               End;
          End;
     Finally
          FreeAndNil(XML);
     End;
End;

 {$HINTS Off}
Function InstallSkin(Const SkinPath: String): Boolean;
Var
     XML                      : TNativeXml;

     SkinName, DesignerName, SkinVersion, DesignerComment: String;
     m_Converter              : TSkinLayoutConverter;
     FileName                 : String;
     Overwrite                : boolean;
Begin
     result := False;

     Try
          Try
               XML := TNativeXml.Create;
               XML.ExternalEncoding := seUTF8;
               XML.LoadFromFile(SkinPath);



               SkinName := Xml.Root.FindNode('SkinName').Nodes[0].ValueAsUnicodeString;
               DesignerName := Xml.Root.FindNode('DesignerName').Nodes[0].ValueAsUnicodeString;
               SkinVersion := Xml.Root.FindNode('SkinVersion').Nodes[0].ValueAsUnicodeString;
               DesignerComment := Xml.Root.FindNode('DesignerComment').Nodes[0].ValueAsUnicodeString;

               FreeAndNil(XML);
               Filename := ExtractFilename(SkinPath);

               If FileExists(GetAvroDataDir + 'Skin\' + Filename) Then Begin
                    If Application.MessageBox(pchar('Skin "' + Filename + '" is already installed.' + #10 + 'Do you want to overwrite it?'), 'Avro Keyboard', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_SYSTEMMODAL) = ID_YES Then
                         Overwrite := True
                    Else
                         Overwrite := False;
               End;

               If MyCopyFile(SkinPath, GetAvroDataDir + 'Skin\' + Filename, Overwrite) Then Begin
                    Result := True;
                    Application.MessageBox(Pchar('Skin "' + Filename + '" has been installed successfully!' + #10 + '' + #10 +
                         'Skin name: ' + SkinName + #10 +
                         'Version: ' + SkinVersion + #10 +
                         'Designer: ' + DesignerName + #10 +
                         'Comment: ' + DesignerComment + #10 +
                         '' + #10 + 'Please use the settings dialog box to activate this skin.'), 'Avro Keyboard', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

                    //Check and convert the skin
                    m_Converter := TSkinLayoutConverter.Create;
                    m_Converter.CheckConvertSkin(GetAvroDataDir + 'Skin\' + Filename);
                    FreeAndNil(m_Converter);


               End
               Else Begin
                    Result := False;
                    Application.MessageBox(pchar('Skin "' + Filename + '" was not installed!'),
                         'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);
               End;
          Except
               On e: exception Do Begin
                    result := False;

                    Application.MessageBox(pchar('Error installing skin!' + #10 + '' + #10 + '' + #10 +
                         'Make sure this is a valid skin file' + #10 + 'or,'
                         + #10 + 'You have enough permission to write in skin folder' + #10 +
                         'or,' + #10 + 'Skin directory is writable'),
                         'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

               End;
          End;
     Finally
          FreeAndNil(XML);
     End;
End;
 {$HINTS On}
End.

