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
{ COMPLETE TRANSFERING EXCEPT SKIN CONVERSION }

Unit SkinLoader;

Interface

Uses
  Classes,
  SysUtils,
  Forms,
  Windows,
  XMLIntf, XMLDoc,
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
  Soap.EncdDecd,
  clsSkinLayoutConverter,
  uFileFolderHandling;
{$HINTS Off}

Function LoadSkin(Const FullSkinPath: String): Boolean;
Var
  XML: IXMLDocument;
  Stream: TStringStream;
  AvroIconAdded: Boolean;
  KeyboardModeAdded: Boolean;
  KeyboardLayoutAdded: Boolean;
  LayoutViewerAdded: Boolean;
  AvroMouseAdded: Boolean;
  ToolsAdded: Boolean;
  WebAdded: Boolean;
  HelpAdded: Boolean;
  ExitAdded: Boolean;
  Resource: TResourceStream;
  m_Converter: TSkinLayoutConverter;

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
      XML := TXMLDocument.Create(nil);

      XML.Active := true;
      XML.Encoding := 'UTF-8';

      If LowerCase(FullSkinPath) <> 'internalskin*' Then
      Begin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(FullSkinPath);
        FreeAndNil(m_Converter);
        XML.LoadFromFile(FullSkinPath);
      End
      Else
      Begin
        Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
        XML.LoadFromStream(Resource);
        FreeAndNil(Resource);
      End;

      // ----------------------------------------------
      // Check if the skin is a compatible one
      If trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion')
        .nodevalue) <> '5' Then
      Begin
        Application.MessageBox
          ('This Skin is not compatible with current version of Avro Keyboard.',
          'Error loading skin...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
          MB_APPLMODAL);
        Result := False;
        Exit;
      End;
      // ----------------------------------------------

      // 'Which buttons are added?
      If trim(XML.DocumentElement.childnodes.FindNode('AvroIconAdded')
        .nodevalue) = '1' Then
        AvroIconAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('KeyboardModeAdded')
        .nodevalue) = '1' Then
        KeyboardModeAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('KeyboardLayoutAdded')
        .nodevalue) = '1' Then
        KeyboardLayoutAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('LayoutViewerAdded')
        .nodevalue) = '1' Then
        LayoutViewerAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('AvroMouseAdded')
        .nodevalue) = '1' Then
        AvroMouseAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('ToolsAdded').nodevalue)
        = '1' Then
        ToolsAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('WebAdded').nodevalue)
        = '1' Then
        WebAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('HelpAdded').nodevalue)
        = '1' Then
        HelpAdded := true;

      If trim(XML.DocumentElement.childnodes.FindNode('ExitAdded').nodevalue)
        = '1' Then
        ExitAdded := true;

      // ----------------------------------------------

      // Skin the TopBar
      Stream := TStringStream.Create
        (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
        ('TopBarMain').nodevalue));
      Topbar.ImgMain.Picture.Bitmap.LoadFromStream(Stream);
      Stream.Free;
      Topbar.Height := XML.DocumentElement.childnodes.FindNode('TopBarHeight')
        .nodevalue;
      Topbar.Width := XML.DocumentElement.childnodes.FindNode('TopBarWidth')
        .nodevalue;
      // ----------------------------------------------

      // Skin Buttons
      If AvroIconAdded = true Then
      Begin
        Topbar.ImgAppIcon.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('AvroIconNormal').nodevalue));
        Topbar.BMP_AppIcon.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('AvroIconDown').nodevalue));
        Topbar.BMP_AppIcon_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('AvroIconOver').nodevalue));
        Topbar.BMP_AppIcon_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgAppIcon.Height := XML.DocumentElement.childnodes.FindNode
          ('AvroIconHeight').nodevalue;
        Topbar.ImgAppIcon.Width := XML.DocumentElement.childnodes.FindNode
          ('AvroIconWidth').nodevalue;
        Topbar.ImgAppIcon.Top := XML.DocumentElement.childnodes.FindNode
          ('AvroIconTop').nodevalue;
        Topbar.ImgAppIcon.Left := XML.DocumentElement.childnodes.FindNode
          ('AvroIconLeft').nodevalue;
      End
      Else
      Begin
        Topbar.ImgAppIcon.Visible := False;
      End;

      If KeyboardModeAdded = true Then
      Begin
        Topbar.ImgButtonMode.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeEnglishNormal').nodevalue));
        Topbar.BMP_ButtonModeE.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeEnglishDown').nodevalue));
        Topbar.BMP_ButtonModeE_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeEnglishOver').nodevalue));
        Topbar.BMP_ButtonModeE_Over.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeBanglaNormal').nodevalue));
        Topbar.BMP_ButtonModeB.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeBanglaDown').nodevalue));
        Topbar.BMP_ButtonModeB_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeBanglaOver').nodevalue));
        Topbar.BMP_ButtonModeB_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonMode.Height := XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeHeight').nodevalue;
        Topbar.ImgButtonMode.Width := XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeWidth').nodevalue;
        Topbar.ImgButtonMode.Top := XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeTop').nodevalue;
        Topbar.ImgButtonMode.Left := XML.DocumentElement.childnodes.FindNode
          ('KeyboardModeLeft').nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonMode.Visible := False;
      End;

      If KeyboardLayoutAdded = true Then
      Begin
        Topbar.ImgButtonLayoutDown.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardLayoutNormal').nodevalue));
        Topbar.BMP_ButtonLayoutDown.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardLayoutDown').nodevalue));
        Topbar.BMP_ButtonLayoutDown_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('KeyboardLayoutOver').nodevalue));
        Topbar.BMP_ButtonLayoutDown_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonLayoutDown.Height :=
          XML.DocumentElement.childnodes.FindNode('KeyboardLayoutHeight')
          .nodevalue;
        Topbar.ImgButtonLayoutDown.Width :=
          XML.DocumentElement.childnodes.FindNode('KeyboardLayoutWidth')
          .nodevalue;
        Topbar.ImgButtonLayoutDown.Top :=
          XML.DocumentElement.childnodes.FindNode('KeyboardLayoutTop')
          .nodevalue;
        Topbar.ImgButtonLayoutDown.Left :=
          XML.DocumentElement.childnodes.FindNode('KeyboardLayoutLeft')
          .nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonLayoutDown.Visible := False;
      End;

      If LayoutViewerAdded = true Then
      Begin
        Topbar.ImgButtonLayout.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('LayoutViewerNormal').nodevalue));
        Topbar.BMP_ButtonLayout.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('LayoutViewerDown').nodevalue));
        Topbar.BMP_ButtonLayout_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('LayoutViewerOver').nodevalue));
        Topbar.BMP_ButtonLayout_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonLayout.Height := XML.DocumentElement.childnodes.FindNode
          ('LayoutViewerHeight').nodevalue;
        Topbar.ImgButtonLayout.Width := XML.DocumentElement.childnodes.FindNode
          ('LayoutViewerWidth').nodevalue;
        Topbar.ImgButtonLayout.Top := XML.DocumentElement.childnodes.FindNode
          ('LayoutViewerTop').nodevalue;
        Topbar.ImgButtonLayout.Left := XML.DocumentElement.childnodes.FindNode
          ('LayoutViewerLeft').nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonLayout.Visible := False;
      End;

      If AvroMouseAdded = true Then
      Begin
        Topbar.ImgButtonMouse.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('AvroMouseNormal').nodevalue));
        Topbar.BMP_ButtonMouse.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('AvroMouseDown').nodevalue));
        Topbar.BMP_ButtonMouse_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('AvroMouseOver').nodevalue));
        Topbar.BMP_ButtonMouse_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonMouse.Height := XML.DocumentElement.childnodes.FindNode
          ('AvroMouseHeight').nodevalue;
        Topbar.ImgButtonMouse.Width := XML.DocumentElement.childnodes.FindNode
          ('AvroMouseWidth').nodevalue;
        Topbar.ImgButtonMouse.Top := XML.DocumentElement.childnodes.FindNode
          ('AvroMouseTop').nodevalue;
        Topbar.ImgButtonMouse.Left := XML.DocumentElement.childnodes.FindNode
          ('AvroMouseLeft').nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonMouse.Visible := False;
      End;

      If ToolsAdded = true Then
      Begin
        Topbar.ImgButtonTools.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('ToolsNormal').nodevalue));
        Topbar.BMP_ButtonTools.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('ToolsDown').nodevalue));
        Topbar.BMP_ButtonTools_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('ToolsOver').nodevalue));
        Topbar.BMP_ButtonTools_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonTools.Height := XML.DocumentElement.childnodes.FindNode
          ('ToolsHeight').nodevalue;
        Topbar.ImgButtonTools.Width := XML.DocumentElement.childnodes.FindNode
          ('ToolsWidth').nodevalue;
        Topbar.ImgButtonTools.Top := XML.DocumentElement.childnodes.FindNode
          ('ToolsTop').nodevalue;
        Topbar.ImgButtonTools.Left := XML.DocumentElement.childnodes.FindNode
          ('ToolsLeft').nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonTools.Visible := False;
      End;

      If WebAdded = true Then
      Begin
        Topbar.ImgButtonWWW.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('WebNormal').nodevalue));
        Topbar.BMP_ButtonWWW.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('WebDown').nodevalue));
        Topbar.BMP_ButtonWWW_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('WebOver').nodevalue));
        Topbar.BMP_ButtonWWW_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonWWW.Height := XML.DocumentElement.childnodes.FindNode
          ('WebHeight').nodevalue;
        Topbar.ImgButtonWWW.Width := XML.DocumentElement.childnodes.FindNode
          ('WebWidth').nodevalue;
        Topbar.ImgButtonWWW.Left := XML.DocumentElement.childnodes.FindNode
          ('WebLeft').nodevalue;
        Topbar.ImgButtonWWW.Top := XML.DocumentElement.childnodes.FindNode
          ('WebTop').nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonWWW.Visible := False;
      End;

      If HelpAdded = true Then
      Begin
        Topbar.ImgButtonHelp.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('HelpNormal').nodevalue));
        Topbar.BMP_ButtonHelp.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('HelpDown').nodevalue));
        Topbar.BMP_ButtonHelp_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('HelpOver').nodevalue));
        Topbar.BMP_ButtonHelp_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonHelp.Height := XML.DocumentElement.childnodes.FindNode
          ('HelpHeight').nodevalue;
        Topbar.ImgButtonHelp.Width := XML.DocumentElement.childnodes.FindNode
          ('HelpWidth').nodevalue;
        Topbar.ImgButtonHelp.Left := XML.DocumentElement.childnodes.FindNode
          ('HelpLeft').nodevalue;
        Topbar.ImgButtonHelp.Top := XML.DocumentElement.childnodes.FindNode
          ('HelpTop').nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonHelp.Visible := False;
      End;

      If ExitAdded = true Then
      Begin
        Topbar.ImgButtonMinimize.Visible := true;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('ExitNormal').nodevalue));
        Topbar.BMP_ButtonMinimize.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('ExitDown').nodevalue));
        Topbar.BMP_ButtonMinimize_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create
          (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
          ('ExitOver').nodevalue));
        Topbar.BMP_ButtonMinimize_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonMinimize.Height :=
          XML.DocumentElement.childnodes.FindNode('ExitHeight').nodevalue;
        Topbar.ImgButtonMinimize.Width :=
          XML.DocumentElement.childnodes.FindNode('ExitWidth').nodevalue;
        Topbar.ImgButtonMinimize.Left := XML.DocumentElement.childnodes.FindNode
          ('ExitLeft').nodevalue;
        Topbar.ImgButtonMinimize.Top := XML.DocumentElement.childnodes.FindNode
          ('ExitTop').nodevalue;
      End
      Else
      Begin
        Topbar.ImgButtonMinimize.Visible := False;
      End;

      // ----------------------------------------------

      // Loading skin is succefull
      Result := true;
    Except
      On E: Exception Do
      Begin
        Application.MessageBox(PChar('Error loading skin!' + #10 + '' + #10 +
          'Make sure ' + ExtractFileName(FullSkinPath) +
          ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        Result := False;
      End;
    End;
  Finally

    XML.Active := False;
    XML := Nil;

  End;
End;
{$HINTS On}

Procedure GetSkinPreviewPicture(Const SkinPath: String; Pic: TPicture);
Var
  XML: IXMLDocument;
  Stream: TStringStream;
  Resource: TResourceStream;
  m_Converter: TSkinLayoutConverter;

Begin
  Try
    Try

      XML := TXMLDocument.Create(nil);
      XML.Active := true;
      XML.Encoding := 'UTF-8';

      If LowerCase(SkinPath) <> 'internalskin*' Then
      Begin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(SkinPath);
        FreeAndNil(m_Converter);
        XML.LoadFromFile(SkinPath);
      End
      Else
      Begin
        Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
        XML.LoadFromStream(Resource);
        FreeAndNil(Resource);
      End;

      // ----------------------------------------------
      // Check if the skin is a compatible one
      If trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion')
        .nodevalue) <> '5' Then
      Begin
        Application.MessageBox
          ('This Skin is not compatible with current version of Avro Keyboard.',
          'Error loading skin...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
          MB_APPLMODAL);
        Exit;
      End;
      // ----------------------------------------------

      Stream := TStringStream.Create
        (Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode
        ('Preview').nodevalue));
      Pic.Bitmap.LoadFromStream(Stream);
      Stream.Free;

    Except
      On E: Exception Do
      Begin
        Application.MessageBox(PChar('Error loading skin preview image!' + #10 +
          '' + #10 + 'Make sure ' + ExtractFileName(SkinPath) +
          ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      End;
    End;
  Finally
    XML.Active := False;
    XML := Nil;

  End;
End;

Function GetSkinDescription(Const SkinPath: String): Boolean;
Var
  XML: IXMLDocument;
  Resource: TResourceStream;

  SkinName, DesignerName, SkinVersion, DesignerComment: String;
  m_Converter: TSkinLayoutConverter;

Begin
  Result := False;
  Try
    Try

      XML := TXMLDocument.Create(nil);
      XML.Active := true;
      XML.Encoding := 'UTF-8';

      If LowerCase(SkinPath) <> 'internalskin*' Then
      Begin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(SkinPath);
        FreeAndNil(m_Converter);
        XML.LoadFromFile(SkinPath);
      End
      Else
      Begin
        Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
        XML.LoadFromStream(Resource);
        FreeAndNil(Resource);
      End;

      // ----------------------------------------------
      // Check if the skin is a compatible one
      If trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion')
        .nodevalue) <> '5' Then
      Begin
        Application.MessageBox
          ('This Skin is not compatible with current version of Avro Keyboard.',
          'Error loading skin...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
          MB_APPLMODAL);
        Exit;
      End;
      // ----------------------------------------------

      SkinName := XML.DocumentElement.childnodes.FindNode('SkinName')
        .childnodes.nodes[0].nodevalue;
      DesignerName := XML.DocumentElement.childnodes.FindNode('DesignerName')
        .childnodes.nodes[0].nodevalue;
      SkinVersion := XML.DocumentElement.childnodes.FindNode('SkinVersion')
        .childnodes.nodes[0].nodevalue;
      DesignerComment := XML.DocumentElement.childnodes.FindNode
        ('DesignerComment').childnodes.nodes[0].nodevalue;

      CheckCreateForm(TfrmAboutSkinLayout, frmAboutSkinLayout,
        'frmAboutSkinLayout');

      frmAboutSkinLayout.txtName.text := SkinName;
      frmAboutSkinLayout.txtVersion.text := SkinVersion;
      frmAboutSkinLayout.txtDeveloper.text := DesignerName;
      frmAboutSkinLayout.txtComment.text := DesignerComment;

      frmAboutSkinLayout.ShowDescription;

    Except
      On E: Exception Do
      Begin
        Application.MessageBox(PChar('Error loading skin description!' + #10 +
          '' + #10 + 'Make sure ' + ExtractFileName(SkinPath) +
          ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        Result := False;
      End;
    End;
  Finally
    XML.Active := False;
    XML := Nil;

  End;
End;

{$HINTS Off}

Function InstallSkin(Const SkinPath: String): Boolean;
Var
  XML: IXMLDocument;

  SkinName, DesignerName, SkinVersion, DesignerComment: String;
  m_Converter: TSkinLayoutConverter;
  FileName: String;
  Overwrite: Boolean;
Begin
  Result := False;

  Try
    Try

      XML := TXMLDocument.Create(nil);
      XML.Active := true;
      XML.Encoding := 'UTF-8';

      XML.LoadFromFile(SkinPath);

      SkinName := XML.DocumentElement.childnodes.FindNode('SkinName')
        .childnodes.nodes[0].nodevalue;
      DesignerName := XML.DocumentElement.childnodes.FindNode('DesignerName')
        .childnodes.nodes[0].nodevalue;
      SkinVersion := XML.DocumentElement.childnodes.FindNode('SkinVersion')
        .childnodes.nodes[0].nodevalue;
      DesignerComment := XML.DocumentElement.childnodes.FindNode
        ('DesignerComment').childnodes.nodes[0].nodevalue;

      XML.Active := False;
      XML := Nil;

      FileName := ExtractFileName(SkinPath);

      If FileExists(GetAvroDataDir + 'Skin\' + FileName) Then
      Begin
        If Application.MessageBox
          (PChar('Skin "' + FileName + '" is already installed.' + #10 +
          'Do you want to overwrite it?'), 'Avro Keyboard',
          MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_SYSTEMMODAL)
          = ID_YES Then
          Overwrite := true
        Else
          Overwrite := False;
      End;

      If MyCopyFile(SkinPath, GetAvroDataDir + 'Skin\' + FileName,
        Overwrite) Then
      Begin
        Result := true;
        Application.MessageBox
          (PChar('Skin "' + FileName + '" has been installed successfully!' +
          #10 + '' + #10 + 'Skin name: ' + SkinName + #10 + 'Version: ' +
          SkinVersion + #10 + 'Designer: ' + DesignerName + #10 + 'Comment: ' +
          DesignerComment + #10 + '' + #10 +
          'Please use the settings dialog box to activate this skin.'),
          'Avro Keyboard', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 +
          MB_SYSTEMMODAL);

        // Check and convert the skin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(GetAvroDataDir + 'Skin\' + FileName);
        FreeAndNil(m_Converter);

      End
      Else
      Begin
        Result := False;
        Application.MessageBox
          (PChar('Skin "' + FileName + '" was not installed!'), 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);
      End;
    Except
      On E: Exception Do
      Begin
        Result := False;

        Application.MessageBox(PChar('Error installing skin!' + #10 + '' + #10 +
          '' + #10 + 'Make sure this is a valid skin file' + #10 + 'or,' + #10 +
          'You have enough permission to write in skin folder' + #10 + 'or,' +
          #10 + 'Skin directory is writable'), 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

      End;
    End;
  Finally
    XML.Active := False;
    XML := Nil;

  End;
End;
{$HINTS On}

End.
