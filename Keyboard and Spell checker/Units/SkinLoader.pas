{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING EXCEPT SKIN CONVERSION }

unit SkinLoader;

interface

uses
  Classes,
  SysUtils,
  Forms,
  Windows,
  XMLIntf,
  XMLDoc,
  Graphics;

function LoadSkin(const FullSkinPath: string): Boolean;
procedure GetSkinPreviewPicture(const SkinPath: string; Pic: TPicture);
function GetSkinDescription(const SkinPath: string): Boolean;
function InstallSkin(const SkinPath: string): Boolean;

implementation

{$R ../Skin/Internal_Skin.res}
{ DONE : Add final skin here }

uses
  uTopBar,
  ufrmAboutSkinLayout,
  uWindowHandlers,
  Soap.EncdDecd,
  clsSkinLayoutConverter,
  uFileFolderHandling;
{$HINTS Off}

function LoadSkin(const FullSkinPath: string): Boolean;
var
  XML:                 IXMLDocument;
  Stream:              TStringStream;
  AvroIconAdded:       Boolean;
  KeyboardModeAdded:   Boolean;
  KeyboardLayoutAdded: Boolean;
  LayoutViewerAdded:   Boolean;
  AvroMouseAdded:      Boolean;
  ToolsAdded:          Boolean;
  WebAdded:            Boolean;
  HelpAdded:           Boolean;
  ExitAdded:           Boolean;
  Resource:            TResourceStream;
  m_Converter:         TSkinLayoutConverter;

begin
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
  try
    try
      XML := TXMLDocument.Create(nil);

      XML.Active := true;
      XML.Encoding := 'UTF-8';

      if LowerCase(FullSkinPath) <> 'internalskin*' then
      begin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(FullSkinPath);
        FreeAndNil(m_Converter);
        XML.LoadFromFile(FullSkinPath);
      end
      else
      begin
        Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
        XML.LoadFromStream(Resource);
        FreeAndNil(Resource);
      end;

      // ----------------------------------------------
      // Check if the skin is a compatible one
      if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue) <> '5' then
      begin
        Application.MessageBox('This Skin is not compatible with current version of Avro Keyboard.', 'Error loading skin...',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        Result := False;
        Exit;
      end;
      // ----------------------------------------------

      // 'Which buttons are added?
      if trim(XML.DocumentElement.childnodes.FindNode('AvroIconAdded').nodevalue) = '1' then
        AvroIconAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('KeyboardModeAdded').nodevalue) = '1' then
        KeyboardModeAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('KeyboardLayoutAdded').nodevalue) = '1' then
        KeyboardLayoutAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('LayoutViewerAdded').nodevalue) = '1' then
        LayoutViewerAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('AvroMouseAdded').nodevalue) = '1' then
        AvroMouseAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('ToolsAdded').nodevalue) = '1' then
        ToolsAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('WebAdded').nodevalue) = '1' then
        WebAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('HelpAdded').nodevalue) = '1' then
        HelpAdded := true;

      if trim(XML.DocumentElement.childnodes.FindNode('ExitAdded').nodevalue) = '1' then
        ExitAdded := true;

      // ----------------------------------------------

      // Skin the TopBar
      Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('TopBarMain').nodevalue));
      Topbar.ImgMain.Picture.Bitmap.LoadFromStream(Stream);
      Stream.Free;
      Topbar.Height := XML.DocumentElement.childnodes.FindNode('TopBarHeight').nodevalue;
      Topbar.Width := XML.DocumentElement.childnodes.FindNode('TopBarWidth').nodevalue;
      // ----------------------------------------------

      // Skin Buttons
      if AvroIconAdded = true then
      begin
        Topbar.ImgAppIcon.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('AvroIconNormal').nodevalue));
        Topbar.BMP_AppIcon.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('AvroIconDown').nodevalue));
        Topbar.BMP_AppIcon_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('AvroIconOver').nodevalue));
        Topbar.BMP_AppIcon_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgAppIcon.Height := XML.DocumentElement.childnodes.FindNode('AvroIconHeight').nodevalue;
        Topbar.ImgAppIcon.Width := XML.DocumentElement.childnodes.FindNode('AvroIconWidth').nodevalue;
        Topbar.ImgAppIcon.Top := XML.DocumentElement.childnodes.FindNode('AvroIconTop').nodevalue;
        Topbar.ImgAppIcon.Left := XML.DocumentElement.childnodes.FindNode('AvroIconLeft').nodevalue;
      end
      else
      begin
        Topbar.ImgAppIcon.Visible := False;
      end;

      if KeyboardModeAdded = true then
      begin
        Topbar.ImgButtonMode.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardModeEnglishNormal').nodevalue));
        Topbar.BMP_ButtonModeE.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardModeEnglishDown').nodevalue));
        Topbar.BMP_ButtonModeE_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardModeEnglishOver').nodevalue));
        Topbar.BMP_ButtonModeE_Over.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardModeBanglaNormal').nodevalue));
        Topbar.BMP_ButtonModeB.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardModeBanglaDown').nodevalue));
        Topbar.BMP_ButtonModeB_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardModeBanglaOver').nodevalue));
        Topbar.BMP_ButtonModeB_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonMode.Height := XML.DocumentElement.childnodes.FindNode('KeyboardModeHeight').nodevalue;
        Topbar.ImgButtonMode.Width := XML.DocumentElement.childnodes.FindNode('KeyboardModeWidth').nodevalue;
        Topbar.ImgButtonMode.Top := XML.DocumentElement.childnodes.FindNode('KeyboardModeTop').nodevalue;
        Topbar.ImgButtonMode.Left := XML.DocumentElement.childnodes.FindNode('KeyboardModeLeft').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonMode.Visible := False;
      end;

      if KeyboardLayoutAdded = true then
      begin
        Topbar.ImgButtonLayoutDown.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardLayoutNormal').nodevalue));
        Topbar.BMP_ButtonLayoutDown.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardLayoutDown').nodevalue));
        Topbar.BMP_ButtonLayoutDown_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('KeyboardLayoutOver').nodevalue));
        Topbar.BMP_ButtonLayoutDown_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonLayoutDown.Height := XML.DocumentElement.childnodes.FindNode('KeyboardLayoutHeight').nodevalue;
        Topbar.ImgButtonLayoutDown.Width := XML.DocumentElement.childnodes.FindNode('KeyboardLayoutWidth').nodevalue;
        Topbar.ImgButtonLayoutDown.Top := XML.DocumentElement.childnodes.FindNode('KeyboardLayoutTop').nodevalue;
        Topbar.ImgButtonLayoutDown.Left := XML.DocumentElement.childnodes.FindNode('KeyboardLayoutLeft').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonLayoutDown.Visible := False;
      end;

      if LayoutViewerAdded = true then
      begin
        Topbar.ImgButtonLayout.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('LayoutViewerNormal').nodevalue));
        Topbar.BMP_ButtonLayout.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('LayoutViewerDown').nodevalue));
        Topbar.BMP_ButtonLayout_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('LayoutViewerOver').nodevalue));
        Topbar.BMP_ButtonLayout_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonLayout.Height := XML.DocumentElement.childnodes.FindNode('LayoutViewerHeight').nodevalue;
        Topbar.ImgButtonLayout.Width := XML.DocumentElement.childnodes.FindNode('LayoutViewerWidth').nodevalue;
        Topbar.ImgButtonLayout.Top := XML.DocumentElement.childnodes.FindNode('LayoutViewerTop').nodevalue;
        Topbar.ImgButtonLayout.Left := XML.DocumentElement.childnodes.FindNode('LayoutViewerLeft').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonLayout.Visible := False;
      end;

      if AvroMouseAdded = true then
      begin
        Topbar.ImgButtonMouse.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('AvroMouseNormal').nodevalue));
        Topbar.BMP_ButtonMouse.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('AvroMouseDown').nodevalue));
        Topbar.BMP_ButtonMouse_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('AvroMouseOver').nodevalue));
        Topbar.BMP_ButtonMouse_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonMouse.Height := XML.DocumentElement.childnodes.FindNode('AvroMouseHeight').nodevalue;
        Topbar.ImgButtonMouse.Width := XML.DocumentElement.childnodes.FindNode('AvroMouseWidth').nodevalue;
        Topbar.ImgButtonMouse.Top := XML.DocumentElement.childnodes.FindNode('AvroMouseTop').nodevalue;
        Topbar.ImgButtonMouse.Left := XML.DocumentElement.childnodes.FindNode('AvroMouseLeft').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonMouse.Visible := False;
      end;

      if ToolsAdded = true then
      begin
        Topbar.ImgButtonTools.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('ToolsNormal').nodevalue));
        Topbar.BMP_ButtonTools.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('ToolsDown').nodevalue));
        Topbar.BMP_ButtonTools_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('ToolsOver').nodevalue));
        Topbar.BMP_ButtonTools_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonTools.Height := XML.DocumentElement.childnodes.FindNode('ToolsHeight').nodevalue;
        Topbar.ImgButtonTools.Width := XML.DocumentElement.childnodes.FindNode('ToolsWidth').nodevalue;
        Topbar.ImgButtonTools.Top := XML.DocumentElement.childnodes.FindNode('ToolsTop').nodevalue;
        Topbar.ImgButtonTools.Left := XML.DocumentElement.childnodes.FindNode('ToolsLeft').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonTools.Visible := False;
      end;

      if WebAdded = true then
      begin
        Topbar.ImgButtonWWW.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('WebNormal').nodevalue));
        Topbar.BMP_ButtonWWW.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('WebDown').nodevalue));
        Topbar.BMP_ButtonWWW_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('WebOver').nodevalue));
        Topbar.BMP_ButtonWWW_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonWWW.Height := XML.DocumentElement.childnodes.FindNode('WebHeight').nodevalue;
        Topbar.ImgButtonWWW.Width := XML.DocumentElement.childnodes.FindNode('WebWidth').nodevalue;
        Topbar.ImgButtonWWW.Left := XML.DocumentElement.childnodes.FindNode('WebLeft').nodevalue;
        Topbar.ImgButtonWWW.Top := XML.DocumentElement.childnodes.FindNode('WebTop').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonWWW.Visible := False;
      end;

      if HelpAdded = true then
      begin
        Topbar.ImgButtonHelp.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('HelpNormal').nodevalue));
        Topbar.BMP_ButtonHelp.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('HelpDown').nodevalue));
        Topbar.BMP_ButtonHelp_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('HelpOver').nodevalue));
        Topbar.BMP_ButtonHelp_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonHelp.Height := XML.DocumentElement.childnodes.FindNode('HelpHeight').nodevalue;
        Topbar.ImgButtonHelp.Width := XML.DocumentElement.childnodes.FindNode('HelpWidth').nodevalue;
        Topbar.ImgButtonHelp.Left := XML.DocumentElement.childnodes.FindNode('HelpLeft').nodevalue;
        Topbar.ImgButtonHelp.Top := XML.DocumentElement.childnodes.FindNode('HelpTop').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonHelp.Visible := False;
      end;

      if ExitAdded = true then
      begin
        Topbar.ImgButtonMinimize.Visible := true;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('ExitNormal').nodevalue));
        Topbar.BMP_ButtonMinimize.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('ExitDown').nodevalue));
        Topbar.BMP_ButtonMinimize_Down.LoadFromStream(Stream);
        Stream.Free;
        Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('ExitOver').nodevalue));
        Topbar.BMP_ButtonMinimize_Over.LoadFromStream(Stream);
        Stream.Free;
        Topbar.ImgButtonMinimize.Height := XML.DocumentElement.childnodes.FindNode('ExitHeight').nodevalue;
        Topbar.ImgButtonMinimize.Width := XML.DocumentElement.childnodes.FindNode('ExitWidth').nodevalue;
        Topbar.ImgButtonMinimize.Left := XML.DocumentElement.childnodes.FindNode('ExitLeft').nodevalue;
        Topbar.ImgButtonMinimize.Top := XML.DocumentElement.childnodes.FindNode('ExitTop').nodevalue;
      end
      else
      begin
        Topbar.ImgButtonMinimize.Visible := False;
      end;

      // ----------------------------------------------

      // Loading skin is succefull
      Result := true;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Error loading skin!' + #10 + '' + #10 + 'Make sure ' + ExtractFileName(FullSkinPath) +
              ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        Result := False;
      end;
    end;
  finally

    XML.Active := False;
    XML := nil;

  end;
end;
{$HINTS On}

procedure GetSkinPreviewPicture(const SkinPath: string; Pic: TPicture);
var
  XML:         IXMLDocument;
  Stream:      TStringStream;
  Resource:    TResourceStream;
  m_Converter: TSkinLayoutConverter;

begin
  try
    try

      XML := TXMLDocument.Create(nil);
      XML.Active := true;
      XML.Encoding := 'UTF-8';

      if LowerCase(SkinPath) <> 'internalskin*' then
      begin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(SkinPath);
        FreeAndNil(m_Converter);
        XML.LoadFromFile(SkinPath);
      end
      else
      begin
        Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
        XML.LoadFromStream(Resource);
        FreeAndNil(Resource);
      end;

      // ----------------------------------------------
      // Check if the skin is a compatible one
      if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue) <> '5' then
      begin
        Application.MessageBox('This Skin is not compatible with current version of Avro Keyboard.', 'Error loading skin...',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        Exit;
      end;
      // ----------------------------------------------

      Stream := TStringStream.Create(Soap.EncdDecd.DecodeBase64(XML.DocumentElement.childnodes.FindNode('Preview').nodevalue));
      Pic.Bitmap.LoadFromStream(Stream);
      Stream.Free;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Error loading skin preview image!' + #10 + '' + #10 + 'Make sure ' + ExtractFileName(SkinPath) +
              ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;
    end;
  finally
    XML.Active := False;
    XML := nil;

  end;
end;

function GetSkinDescription(const SkinPath: string): Boolean;
var
  XML:      IXMLDocument;
  Resource: TResourceStream;

  SkinName, DesignerName, SkinVersion, DesignerComment: string;
  m_Converter:                                          TSkinLayoutConverter;

begin
  Result := False;
  try
    try

      XML := TXMLDocument.Create(nil);
      XML.Active := true;
      XML.Encoding := 'UTF-8';

      if LowerCase(SkinPath) <> 'internalskin*' then
      begin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(SkinPath);
        FreeAndNil(m_Converter);
        XML.LoadFromFile(SkinPath);
      end
      else
      begin
        Resource := TResourceStream.Create(Hinstance, 'SKIN0', RT_RCDATA);
        XML.LoadFromStream(Resource);
        FreeAndNil(Resource);
      end;

      // ----------------------------------------------
      // Check if the skin is a compatible one
      if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue) <> '5' then
      begin
        Application.MessageBox('This Skin is not compatible with current version of Avro Keyboard.', 'Error loading skin...',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        Exit;
      end;
      // ----------------------------------------------

      SkinName := XML.DocumentElement.childnodes.FindNode('SkinName').childnodes.nodes[0].nodevalue;
      DesignerName := XML.DocumentElement.childnodes.FindNode('DesignerName').childnodes.nodes[0].nodevalue;
      SkinVersion := XML.DocumentElement.childnodes.FindNode('SkinVersion').childnodes.nodes[0].nodevalue;
      DesignerComment := XML.DocumentElement.childnodes.FindNode('DesignerComment').childnodes.nodes[0].nodevalue;

      CheckCreateForm(TfrmAboutSkinLayout, frmAboutSkinLayout, 'frmAboutSkinLayout');

      frmAboutSkinLayout.txtName.text := SkinName;
      frmAboutSkinLayout.txtVersion.text := SkinVersion;
      frmAboutSkinLayout.txtDeveloper.text := DesignerName;
      frmAboutSkinLayout.txtComment.text := DesignerComment;

      frmAboutSkinLayout.ShowDescription;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Error loading skin description!' + #10 + '' + #10 + 'Make sure ' + ExtractFileName(SkinPath) +
              ' is a valid skin file or skin is not corrupt.'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        Result := False;
      end;
    end;
  finally
    XML.Active := False;
    XML := nil;

  end;
end;

{$HINTS Off}

function InstallSkin(const SkinPath: string): Boolean;
var
  XML: IXMLDocument;

  SkinName, DesignerName, SkinVersion, DesignerComment: string;
  m_Converter:                                          TSkinLayoutConverter;
  FileName:                                             string;
  Overwrite:                                            Boolean;
begin
  Result := False;

  try
    try

      XML := TXMLDocument.Create(nil);
      XML.Active := true;
      XML.Encoding := 'UTF-8';

      XML.LoadFromFile(SkinPath);

      SkinName := XML.DocumentElement.childnodes.FindNode('SkinName').childnodes.nodes[0].nodevalue;
      DesignerName := XML.DocumentElement.childnodes.FindNode('DesignerName').childnodes.nodes[0].nodevalue;
      SkinVersion := XML.DocumentElement.childnodes.FindNode('SkinVersion').childnodes.nodes[0].nodevalue;
      DesignerComment := XML.DocumentElement.childnodes.FindNode('DesignerComment').childnodes.nodes[0].nodevalue;

      XML.Active := False;
      XML := nil;

      FileName := ExtractFileName(SkinPath);

      if FileExists(GetAvroDataDir + 'Skin\' + FileName) then
      begin
        if Application.MessageBox(PChar('Skin "' + FileName + '" is already installed.' + #10 + 'Do you want to overwrite it?'), 'Avro Keyboard',
          MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_SYSTEMMODAL) = ID_YES then
          Overwrite := true
        else
          Overwrite := False;
      end;

      if MyCopyFile(SkinPath, GetAvroDataDir + 'Skin\' + FileName, Overwrite) then
      begin
        Result := true;
        Application.MessageBox(PChar('Skin "' + FileName + '" has been installed successfully!' + #10 + '' + #10 + 'Skin name: ' + SkinName + #10 + 'Version: '
              + SkinVersion + #10 + 'Designer: ' + DesignerName + #10 + 'Comment: ' + DesignerComment + #10 + '' + #10 +
              'Please use the settings dialog box to activate this skin.'), 'Avro Keyboard', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

        // Check and convert the skin
        m_Converter := TSkinLayoutConverter.Create;
        m_Converter.CheckConvertSkin(GetAvroDataDir + 'Skin\' + FileName);
        FreeAndNil(m_Converter);

      end
      else
      begin
        Result := False;
        Application.MessageBox(PChar('Skin "' + FileName + '" was not installed!'), 'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);
      end;
    except
      on E: Exception do
      begin
        Result := False;

        Application.MessageBox(PChar('Error installing skin!' + #10 + '' + #10 + '' + #10 + 'Make sure this is a valid skin file' + #10 + 'or,' + #10 +
              'You have enough permission to write in skin folder' + #10 + 'or,' + #10 + 'Skin directory is writable'), 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

      end;
    end;
  finally
    XML.Active := False;
    XML := nil;

  end;
end;
{$HINTS On}

end.
