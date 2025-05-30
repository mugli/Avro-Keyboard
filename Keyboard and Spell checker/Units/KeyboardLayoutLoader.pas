{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING Except layout conversion }

unit KeyboardLayoutLoader;

interface

uses
  Classes,
  SysUtils,
  Forms,
  system.Variants,
  Windows,
  Soap.EncdDecd,
  XMLIntf,
  XMLDoc,
  BanglaChars,
  VirtualKeyCode,
  uRegistrySettings,
  uFileFolderHandling,
  Graphics,
  StrUtils,
  Generics.Collections,
  system.NetEncoding;

function LoadLayout(const LayoutPath: string): Boolean;
function Init_KeyboardLayout(const KeyboardLayoutName: string): Boolean;
procedure Destroy_KeyboardLayoutData;
procedure Init_KeyboardLayoutData;
function GetCharForKey(const KeyCode: Integer; const var_IsLogicalShift, var_IsTrueShift, var_IsAltGr: Boolean): string;
procedure ShowLayoutDescription(const LayoutPath: string);
procedure LoadKeyboardLayoutNames;
procedure LoadKeyboardLayoutImages(const LayoutPath: string; var Pic_LayoutNormal: TBitmap; var Pic_LayoutAltGr: TBitmap);
function InstallLayout(const LayoutPath: string): Boolean;

var
  KeyData:         TDictionary<string, string>;
  KeyboardLayouts: TStringList;

implementation

uses
  uWindowHandlers,
  ufrmAboutSkinLayout,
  clsSkinLayoutConverter;

{ =============================================================================== }

function GetCharForKey(const KeyCode: Integer; const var_IsLogicalShift, var_IsTrueShift, var_IsAltGr: Boolean): string;
var
  KC_Key: string;
begin
  case KeyCode of
    VK_ADD:
      KC_Key := 'NumAdd';
    VK_DECIMAL:
      KC_Key := 'NumDecimal';
    VK_DIVIDE:
      KC_Key := 'NumDivide';
    VK_MULTIPLY:
      KC_Key := 'NumMultiply';
    VK_SUBTRACT:
      KC_Key := 'NumSubtract';

    VK_NUMPAD0:
      KC_Key := 'Num0';
    VK_NUMPAD1:
      KC_Key := 'Num1';
    VK_NUMPAD2:
      KC_Key := 'Num2';
    VK_NUMPAD3:
      KC_Key := 'Num3';
    VK_NUMPAD4:
      KC_Key := 'Num4';
    VK_NUMPAD5:
      KC_Key := 'Num5';
    VK_NUMPAD6:
      KC_Key := 'Num6';
    VK_NUMPAD7:
      KC_Key := 'Num7';
    VK_NUMPAD8:
      KC_Key := 'Num8';
    VK_NUMPAD9:
      KC_Key := 'Num9';

    VK_OEM_1:
      KC_Key := 'OEM1';
    VK_OEM_2:
      KC_Key := 'OEM2';
    VK_OEM_3:
      KC_Key := 'OEM3';
    VK_OEM_4:
      KC_Key := 'OEM4';
    VK_OEM_5:
      KC_Key := 'OEM5';
    VK_OEM_6:
      KC_Key := 'OEM6';
    VK_OEM_7:
      KC_Key := 'OEM7';

    VK_OEM_COMMA:
      KC_Key := 'COMMA';
    VK_OEM_MINUS:
      KC_Key := 'MINUS';
    VK_OEM_PERIOD:
      KC_Key := 'PERIOD';
    VK_OEM_PLUS:
      KC_Key := 'PLUS';

    VK_0:
      KC_Key := '0';
    VK_1:
      KC_Key := '1';
    VK_2:
      KC_Key := '2';
    VK_3:
      KC_Key := '3';
    VK_4:
      KC_Key := '4';
    VK_5:
      KC_Key := '5';
    VK_6:
      KC_Key := '6';
    VK_7:
      KC_Key := '7';
    VK_8:
      KC_Key := '8';
    VK_9:
      KC_Key := '9';
    A_Key:
      KC_Key := 'A';
    B_Key:
      KC_Key := 'B';
    C_Key:
      KC_Key := 'C';
    D_Key:
      KC_Key := 'D';
    E_Key:
      KC_Key := 'E';
    F_Key:
      KC_Key := 'F';
    G_Key:
      KC_Key := 'G';
    H_Key:
      KC_Key := 'H';
    I_Key:
      KC_Key := 'I';
    J_Key:
      KC_Key := 'J';
    K_Key:
      KC_Key := 'K';
    L_Key:
      KC_Key := 'L';
    M_Key:
      KC_Key := 'M';
    N_Key:
      KC_Key := 'N';
    O_Key:
      KC_Key := 'O';
    P_Key:
      KC_Key := 'P';
    Q_Key:
      KC_Key := 'Q';
    R_Key:
      KC_Key := 'R';
    S_Key:
      KC_Key := 'S';
    T_Key:
      KC_Key := 'T';
    U_Key:
      KC_Key := 'U';
    V_Key:
      KC_Key := 'V';
    W_Key:
      KC_Key := 'W';
    X_Key:
      KC_Key := 'X';
    Y_Key:
      KC_Key := 'Y';
    Z_Key:
      KC_Key := 'Z';
  end;

  if KC_Key = '' then
  begin
    GetCharForKey := '';
    Exit;
  end;

  { Version 5 }
  if LowerCase(LeftStr(KC_Key, 3)) <> 'num' then
    KC_Key := 'Key_' + KC_Key;

  // Process Numpad
  if Pos('Num', KC_Key) > 0 then
  begin
    if NumPadBangla = 'YES' then
    begin
      if (var_IsLogicalShift = False) and (var_IsTrueShift = False) and (var_IsAltGr = False) then
      begin
        // In Numpad, no modifier is allowed for Bangla Layout
        GetCharForKey := KeyData.Items[KC_Key];
        Exit;
      end
      else
      begin
        GetCharForKey := '';
        Exit;
      end;
    end
    else
    begin
      GetCharForKey := '';
      Exit;
    end;
  end;

  // Process OEM and Number Keys
  if (KC_Key = '1') or (KC_Key = '2') or (KC_Key = '3') or (KC_Key = '4') or (KC_Key = '5') or (KC_Key = '6') or (KC_Key = '7') or (KC_Key = '8') or
    (KC_Key = '9') or (KC_Key = '0') or (Pos('OEM', KC_Key) > 0) then
  begin
    if (var_IsTrueShift = False) and (var_IsAltGr = False) then
    begin
      // In OEM Keys, Capslock has no value
      // Normal State
      KC_Key := KC_Key + '_Normal';
      GetCharForKey := KeyData.Items[KC_Key];
      Exit;
    end
    else if (var_IsTrueShift = True) and (var_IsAltGr = False) then
    begin
      // True Shift State
      KC_Key := KC_Key + '_Shift';
      GetCharForKey := KeyData.Items[KC_Key];
      Exit;
    end
    else if (var_IsTrueShift = False) and (var_IsAltGr = True) then
    begin
      // AltGr state
      KC_Key := KC_Key + '_AltGr';
      GetCharForKey := KeyData.Items[KC_Key];
      Exit;
    end
    else if (var_IsTrueShift = True) and (var_IsAltGr = True) then
    begin
      // Shift+AltGr state
      KC_Key := KC_Key + '_ShiftAltGr';
      GetCharForKey := KeyData.Items[KC_Key];
      Exit;
    end;
  end;

  // Process Alpha Keys
  if (var_IsLogicalShift = False) and (var_IsAltGr = False) then
  begin
    // All Normal
    KC_Key := KC_Key + '_Normal';
    GetCharForKey := KeyData.Items[KC_Key];
    Exit;
  end
  else if (var_IsLogicalShift = True) and (var_IsAltGr = False) then
  begin
    // Shift State
    KC_Key := KC_Key + '_Shift';
    GetCharForKey := KeyData.Items[KC_Key];
    Exit;
  end
  else if (var_IsLogicalShift = False) and (var_IsAltGr = True) then
  begin
    // AltGr State
    KC_Key := KC_Key + '_AltGr';
    // Debug.Print 'KeyName is:' & KC_Key & ' AltGr=' & var_IsAltGr
    GetCharForKey := KeyData.Items[KC_Key];
    Exit;
  end
  else if (var_IsLogicalShift = True) and (var_IsAltGr = True) then
  begin
    // Shift+AltGr State
    KC_Key := KC_Key + '_ShiftAltGr';
    // Debug.Print 'KeyName is:' & KC_Key & ' AltGr=' & var_IsAltGr
    GetCharForKey := KeyData.Items[KC_Key];
    Exit;
  end;

end;

{ =============================================================================== }

{$HINTS Off}

function Init_KeyboardLayout(const KeyboardLayoutName: string): Boolean;
var
  LayoutPath: string;

begin
  Result := False;
  Destroy_KeyboardLayoutData;
  Init_KeyboardLayoutData;

  LayoutPath := GetAvroDataDir + 'Keyboard Layouts\' + KeyboardLayoutName + '.avrolayout';

  if FileExists(LayoutPath) then
    Result := LoadLayout(LayoutPath)
  else
    Result := False;

end;

{$HINTS On}
{ =============================================================================== }

procedure Init_KeyboardLayoutData;
begin
  KeyData := TDictionary<string, string>.create;
end;

{ =============================================================================== }

procedure Destroy_KeyboardLayoutData;
begin
  KeyData.Free;
end;

{ =============================================================================== }

{$HINTS Off}

function LoadLayout(const LayoutPath: string): Boolean;
var
  XML:                  IXMLDocument;
  Node:                 IXmlNode;
  I:                    Integer;
  RawText, DecodedText: string;
  m_Converter:          TSkinLayoutConverter;
begin
  Result := False;

  try
    try

      XML := TXMLDocument.create(nil);
      XML.Active := True;
      XML.Encoding := 'UTF-8';

      XML.LoadFromFile(LayoutPath);
      Application.ProcessMessages;

      // ----------------------------------------------
      // Check if the skin is a compatible one
      if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue) <> '5' then
      begin

        XML.Active := False;
        XML := nil;

        m_Converter := TSkinLayoutConverter.create;
        m_Converter.CheckConvertLayout(LayoutPath);
        FreeAndNil(m_Converter);

        XML := TXMLDocument.create(nil);
        XML.Active := True;
        XML.Encoding := 'UTF-8';

        XML.LoadFromFile(LayoutPath);
        Application.ProcessMessages;

        // Check again
        if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue) <> '5' then
        begin
          Application.MessageBox('This Keyboard Layout is not compatible with current version of Avro Keyboard.', 'Error loading keyboard layout...',
            MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          Result := False;
          Exit;
        end;
      end;
      // ----------------------------------------------

      Application.ProcessMessages;

      // ----------------------------------------------
      // Load Key Data
      Node := XML.DocumentElement.childnodes.FindNode('KeyData');
      Application.ProcessMessages;
      for I := 0 to Node.childnodes.Count - 1 do
      begin
        // showmessage( inttostr(Node.childnodes.nodes[I].childnodes.Count );
        if Node.childnodes.nodes[I].childnodes.Count <= 0 then
          // If item has no cdata
          KeyData.AddOrSetValue(string(Node.childnodes.nodes[I].nodename), '')
        else
        begin
          // if item has cdata
          RawText := VarToStr(Node.childnodes.nodes[I].childnodes.nodes[0].nodevalue);
          DecodedText := TNetEncoding.HTML.Decode(RawText);
          KeyData.AddOrSetValue(Node.childnodes.nodes[I].nodename, DecodedText);
        end;

        Application.ProcessMessages;
      end;

      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        Application.ProcessMessages;
      end;
    end;
  finally

    XML.Active := False;
    XML := nil;
    Application.ProcessMessages;
  end;
end;

{$HINTS On}
{ =============================================================================== }

procedure LoadKeyboardLayoutImages(const LayoutPath: string; var Pic_LayoutNormal: TBitmap; var Pic_LayoutAltGr: TBitmap);
var
  XML:      IXMLDocument;
  Stream:   TStringStream;
  Resource: TResourceStream;

  m_Converter: TSkinLayoutConverter;

begin

  FreeAndNil(Pic_LayoutNormal);
  FreeAndNil(Pic_LayoutAltGr);
  Application.ProcessMessages;

  try
    try
      if LowerCase(LayoutPath) <> 'avrophonetic*' then
      begin

        XML := TXMLDocument.create(nil);
        XML.Active := True;
        XML.Encoding := 'UTF-8';

        XML.LoadFromFile(LayoutPath);
        Application.ProcessMessages;

        // ----------------------------------------------
        // Check if the layout is a compatible one
        if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue { UnicodeStr } ) <> '5' then
        begin

          XML.Active := False;
          XML := nil;

          m_Converter := TSkinLayoutConverter.create;
          m_Converter.CheckConvertLayout(LayoutPath);
          FreeAndNil(m_Converter);
          Application.ProcessMessages;

          XML := TXMLDocument.create(nil);
          XML.Active := True;
          XML.Encoding := 'UTF-8';
          XML.LoadFromFile(LayoutPath);
          Application.ProcessMessages;

          // Check again
          if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue { UnicodeStr } ) <> '5' then
          begin
            Application.MessageBox('This Keyboard Layout is not compatible with current version of Avro Keyboard.', 'Error loading keyboard layout...',
              MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
            Exit;
          end;
        end;
        // ----------------------------------------------
        Application.ProcessMessages;
        Application.ProcessMessages;
        if (VarIsNull(XML.DocumentElement.childnodes.FindNode('ImageNormalShift').nodevalue) = False) then
        begin
          Stream := TStringStream.create(DecodeBase64(XML.DocumentElement.childnodes.FindNode('ImageNormalShift').nodevalue));
          Pic_LayoutNormal := TBitmap.create;
          if Stream.Size > 0 then
            Pic_LayoutNormal.LoadFromStream(Stream)
          else
            FreeAndNil(Pic_LayoutNormal);
          Application.ProcessMessages;
          FreeAndNil(Stream);
        end;

        if (VarIsNull(XML.DocumentElement.childnodes.FindNode('ImageAltGrShift').nodevalue) = False) then
        begin

          Stream := TStringStream.create(DecodeBase64(XML.DocumentElement.childnodes.FindNode('ImageAltGrShift').nodevalue));
          Pic_LayoutAltGr := TBitmap.create;
          if Stream.Size > 0 then
            Pic_LayoutAltGr.LoadFromStream(Stream)
          else
            FreeAndNil(Pic_LayoutAltGr);

          Application.ProcessMessages;

          FreeAndNil(Stream);
        end;

        XML.Active := False;
        XML := nil;

      end
      else
      begin
        Resource := TResourceStream.create(Hinstance, 'PHONETIC0', RT_RCDATA);
        Pic_LayoutNormal := TBitmap.create;
        Pic_LayoutNormal.LoadFromStream(Resource);
        FreeAndNil(Resource);
        Application.ProcessMessages;
      end;

    except
      on E: Exception do
      begin
        // Do nothing
      end;
    end;
  finally
    //
  end;

end;

{ =============================================================================== }

procedure ShowLayoutDescription(const LayoutPath: string);
var
  XML:                                       IXMLDocument;
  InternalName, Developer, Version, Comment: string;
  m_Converter:                               TSkinLayoutConverter;
begin
  try
    try
      if LowerCase(LayoutPath) <> 'avrophonetic*' then
      begin

        XML := TXMLDocument.create(nil);
        XML.Active := True;
        XML.Encoding := 'UTF-8';
        XML.LoadFromFile(LayoutPath);
        Application.ProcessMessages;

        // ----------------------------------------------
        // Check if the layout is a compatible one
        if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue { UnicodeStr } ) <> '5' then
        begin

          XML.Active := False;
          XML := nil;

          m_Converter := TSkinLayoutConverter.create;
          m_Converter.CheckConvertLayout(LayoutPath);
          FreeAndNil(m_Converter);

          Application.ProcessMessages;

          XML := TXMLDocument.create(nil);
          XML.Active := True;

          XML.Encoding := 'UTF-8';
          XML.LoadFromFile(LayoutPath);
          Application.ProcessMessages;

          // Check again
          if trim(XML.DocumentElement.childnodes.FindNode('AvroKeyboardVersion').nodevalue { UnicodeStr } ) <> '5' then
          begin
            Application.MessageBox('This Keyboard Layout is not compatible with current version of Avro Keyboard.', 'Error loading keyboard layout...',
              MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
            Exit;
          end;
        end;
        // ----------------------------------------------
        Application.ProcessMessages;

        InternalName := XML.DocumentElement.childnodes.FindNode('LayoutName').childnodes.nodes[0].nodevalue; // UnicodeStr
        Application.ProcessMessages;
        Developer := XML.DocumentElement.childnodes.FindNode('DeveloperName').childnodes.nodes[0].nodevalue; // UnicodeStr
        Application.ProcessMessages;
        Version := XML.DocumentElement.childnodes.FindNode('LayoutVersion').childnodes.nodes[0].nodevalue; // UnicodeStr
        Application.ProcessMessages;
        Comment := XML.DocumentElement.childnodes.FindNode('DeveloperComment').childnodes.nodes[0].nodevalue; // UnicodeStr
        Application.ProcessMessages;
      end
      else
      begin
        InternalName := 'Avro Phonetic';
        Developer := 'Mehdi Hasan (OmicronLab)';
        Version := '4';
        Comment := 'In technical definition, Avro Phonetic is not a fixed keyboard layout. ' +
          'This is actually a text parser which takes input as english text and produce bangla ' +
          'characters with similarity matching phonetic converter algorithm of OmicronLab.';
      end;

      CheckCreateForm(TfrmAboutSkinLayout, frmAboutSkinLayout, 'frmAboutSkinLayout');

      frmAboutSkinLayout.txtName.text := InternalName;
      frmAboutSkinLayout.txtVersion.text := Version;
      frmAboutSkinLayout.txtDeveloper.text := Developer;
      frmAboutSkinLayout.txtComment.text := Comment;

      frmAboutSkinLayout.ShowDescription;
    except
      on E: Exception do
      begin
        // Do nothing
      end;
    end;
  finally
    XML := nil;

  end;

end;

{ =============================================================================== }

function InstallLayout(const LayoutPath: string): Boolean;
var
  XML:                                       IXMLDocument;
  InternalName, Developer, Version, Comment: string;
  m_Converter:                               TSkinLayoutConverter;
  FileName:                                  string;
  Overwrite:                                 Boolean;
begin
  Result := False;
  try
    try
      XML := TXMLDocument.create(nil);
      XML.Active := True;
      XML.Encoding := 'UTF-8';
      XML.LoadFromFile(LayoutPath);
      Application.ProcessMessages;

      InternalName := XML.DocumentElement.childnodes.FindNode('LayoutName').childnodes.nodes[0].nodevalue; // UnicodeStr
      Application.ProcessMessages;
      Developer := XML.DocumentElement.childnodes.FindNode('DeveloperName').childnodes.nodes[0].nodevalue; // UnicodeStr
      Application.ProcessMessages;
      Version := XML.DocumentElement.childnodes.FindNode('LayoutVersion').childnodes.nodes[0].nodevalue; // UnicodeStr
      Application.ProcessMessages;
      Comment := XML.DocumentElement.childnodes.FindNode('DeveloperComment').childnodes.nodes[0].nodevalue; // UnicodeStr
      Application.ProcessMessages;

      XML.Active := False;
      XML := nil;

      FileName := ExtractFilename(LayoutPath);

      if FileExists(GetAvroDataDir + 'Keyboard Layouts\' + FileName) then
      begin
        if Application.MessageBox(pchar('Keyboard layout "' + FileName + '" is already installed.' + #10 + 'Do you want to overwrite it?'), 'Avro Keyboard',
          MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_SYSTEMMODAL) = ID_YES then
          Overwrite := True
        else
          Overwrite := False;
      end;

      if MyCopyFile(LayoutPath, GetAvroDataDir + 'Keyboard Layouts\' + FileName, Overwrite) then
      begin
        Result := True;
        Application.MessageBox(pchar('Keyboard layout "' + FileName + '" has been installed successfully!' + #10 + '' + #10 + 'Layout name: ' + InternalName +
              #10 + 'Version: ' + Version + #10 + 'Developer: ' + Developer + #10 + 'Comment: ' + Comment + #10), 'Avro Keyboard',
          MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

        // Check and convert the skin
        m_Converter := TSkinLayoutConverter.create;
        m_Converter.CheckConvertLayout(GetAvroDataDir + 'Keyboard Layouts\' + FileName);
        FreeAndNil(m_Converter);
        Application.ProcessMessages;

      end
      else
      begin
        Result := False;
        Application.MessageBox(pchar('Keyboard layout "' + FileName + '" was not installed!'), 'Avro Keyboard',
          MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);
      end;

    except
      on E: Exception do
      begin
        Result := False;

        Application.MessageBox(pchar('Error installing keyboard layout!' + #10 + '' + #10 + '' + #10 + 'Make sure this is a valid keyboard layout file' + #10 +
              'or,' + #10 + 'You have enough permission to write in keyboard layouts folder' + #10 + 'or,' + #10 + 'Keyboard layouts directory is writable'),
          'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

      end;
    end;
  finally
    XML.Active := False;
    XML := nil;

  end;

end;

{ =============================================================================== }

procedure LoadKeyboardLayoutNames;
var
  I, Count: Integer;
begin
  KeyboardLayouts := TStringList.create;
  Count := GetFileList(GetAvroDataDir + 'Keyboard Layouts\*.avrolayout', KeyboardLayouts);

  if Count <= 0 then
    Exit;

  for I := 0 to Count - 1 do
  begin
    KeyboardLayouts[I] := RemoveExtension(KeyboardLayouts[I]);
  end;
end;

end.
