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

{COMPLETE TRANSFERING Except layout conversion}

Unit KeyboardLayoutLoader;

Interface

Uses
     Classes,
     SysUtils,
     Forms,
     Windows,
     NativeXml,
     cDictionaries,
     BanglaChars,
     VirtualKeyCode,
     uRegistrySettings,
     uFileFolderHandling,
     Graphics,
     StrUtils;

Function LoadLayout(Const LayoutPath: String): Boolean;
Function Init_KeyboardLayout(Const KeyboardLayoutName: String): Boolean;
Procedure Destroy_KeyboardLayoutData;
Procedure Init_KeyboardLayoutData;
Function GetCharForKey(Const KeyCode: Integer; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): Widestring;
Procedure ShowLayoutDescription(Const LayoutPath: String);
Procedure LoadKeyboardLayoutNames;
Procedure LoadKeyboardLayoutImages(Const LayoutPath: String; Var Pic_LayoutNormal: TBitmap; Var Pic_LayoutAltGr: TBitmap);
Function InstallLayout(Const LayoutPath: String): Boolean;

Var
     KeyData                  : TStringDictionary;
     KeyboardLayouts          : TStringList;

Implementation

Uses
     uWindowHandlers,
     ufrmAboutSkinLayout,
     clsSkinLayoutConverter;
{===============================================================================}

Function GetCharForKey(Const KeyCode: Integer; Const var_IfShift, var_IfTrueShift, var_IfAltGr: Boolean): Widestring;
Var
     KC_Key                   : String;
Begin
     Case KeyCode Of
          VK_ADD: KC_Key := 'NumAdd';
          VK_DECIMAL: KC_Key := 'NumDecimal';
          VK_DIVIDE: KC_Key := 'NumDivide';
          VK_MULTIPLY: KC_Key := 'NumMultiply';
          VK_SUBTRACT: KC_Key := 'NumSubtract';


          VK_NUMPAD0: KC_Key := 'Num0';
          VK_NUMPAD1: KC_Key := 'Num1';
          VK_NUMPAD2: KC_Key := 'Num2';
          VK_NUMPAD3: KC_Key := 'Num3';
          VK_NUMPAD4: KC_Key := 'Num4';
          VK_NUMPAD5: KC_Key := 'Num5';
          VK_NUMPAD6: KC_Key := 'Num6';
          VK_NUMPAD7: KC_Key := 'Num7';
          VK_NUMPAD8: KC_Key := 'Num8';
          VK_NUMPAD9: KC_Key := 'Num9';

          VK_OEM_1: KC_Key := 'OEM1';
          VK_OEM_2: KC_Key := 'OEM2';
          VK_OEM_3: KC_Key := 'OEM3';
          VK_OEM_4: KC_Key := 'OEM4';
          VK_OEM_5: KC_Key := 'OEM5';
          VK_OEM_6: KC_Key := 'OEM6';
          VK_OEM_7: KC_Key := 'OEM7';


          VK_OEM_COMMA: KC_Key := 'COMMA';
          VK_OEM_MINUS: KC_Key := 'MINUS';
          VK_OEM_PERIOD: KC_Key := 'PERIOD';
          VK_OEM_PLUS: KC_Key := 'PLUS';


          VK_0: KC_Key := '0';
          VK_1: KC_Key := '1';
          VK_2: KC_Key := '2';
          VK_3: KC_Key := '3';
          VK_4: KC_Key := '4';
          VK_5: KC_Key := '5';
          VK_6: KC_Key := '6';
          VK_7: KC_Key := '7';
          VK_8: KC_Key := '8';
          VK_9: KC_Key := '9'
               ;
          A_Key: KC_Key := 'A';
          B_Key: KC_Key := 'B';
          C_Key: KC_Key := 'C';
          D_Key: KC_Key := 'D';
          E_Key: KC_Key := 'E';
          F_Key: KC_Key := 'F';
          G_Key: KC_Key := 'G';
          H_Key: KC_Key := 'H';
          I_Key: KC_Key := 'I';
          J_Key: KC_Key := 'J';
          K_Key: KC_Key := 'K';
          L_Key: KC_Key := 'L';
          M_Key: KC_Key := 'M';
          N_Key: KC_Key := 'N';
          O_Key: KC_Key := 'O';
          P_Key: KC_Key := 'P';
          Q_Key: KC_Key := 'Q';
          R_Key: KC_Key := 'R';
          S_Key: KC_Key := 'S';
          T_Key: KC_Key := 'T';
          U_Key: KC_Key := 'U';
          V_Key: KC_Key := 'V';
          W_Key: KC_Key := 'W';
          X_Key: KC_Key := 'X';
          Y_Key: KC_Key := 'Y';
          Z_Key: KC_Key := 'Z';
     End;

     If KC_Key = '' Then Begin
          GetCharForKey := '';
          Exit;
     End;

     {Version 5}
     If LowerCase(LeftStr(KC_Key, 3)) <> 'num' Then
          KC_Key := 'Key_' + KC_Key;

     //Process Numpad
     If Pos('Num', KC_Key) > 0 Then Begin
          If NumPadBangla = 'YES' Then Begin
               If (var_IfShift = False) And (var_IfTrueShift = False) And (var_IfAltGr = False) Then Begin
                    //In Numpad, no modifier is allowed for Bangla Layout
                    GetCharForKey := utf8decode(KeyData.item[KC_Key]);
                    Exit;
               End
               Else Begin
                    GetCharForKey := '';
                    Exit;
               End;
          End
          Else Begin
               GetCharForKey := '';
               Exit;
          End;
     End;


     //Process OEM and Number Keys
     If (KC_Key = '1') Or (KC_Key = '2') Or (KC_Key = '3') Or (KC_Key = '4') Or (KC_Key = '5') Or
          (KC_Key = '6') Or (KC_Key = '7') Or (KC_Key = '8') Or (KC_Key = '9') Or (KC_Key = '0') Or
          (Pos('OEM', KC_Key) > 0) Then Begin
          If (var_IfTrueShift = False) And (var_IfAltGr = False) Then Begin
               //In OEM Keys, Capslock has no value
               //Normal State
               KC_Key := KC_Key + '_Normal';
               GetCharForKey := utf8decode(KeyData.item[KC_Key]);
               Exit;
          End
          Else If (var_IfTrueShift = True) And (var_IfAltGr = False) Then Begin
               //True Shift State
               KC_Key := KC_Key + '_Shift';
               GetCharForKey := utf8decode(KeyData.item[KC_Key]);
               Exit;
          End
          Else If (var_IfTrueShift = False) And (var_IfAltGr = True) Then Begin
               //AltGr state
               KC_Key := KC_Key + '_AltGr';
               GetCharForKey := utf8decode(KeyData.item[KC_Key]);
               Exit;
          End
          Else If (var_IfTrueShift = True) And (var_IfAltGr = True) Then Begin
               //Shift+AltGr state
               KC_Key := KC_Key + '_ShiftAltGr';
               GetCharForKey := utf8decode(KeyData.item[KC_Key]);
               Exit;
          End;
     End;

     //Process Alpha Keys
     If (var_IfShift = False) And (var_IfAltGr = False) Then Begin
          //All Normal
          KC_Key := KC_Key + '_Normal';
          GetCharForKey := utf8decode(KeyData.item[KC_Key]);
          Exit;
     End
     Else If (var_IfShift = True) And (var_IfAltGr = False) Then Begin
          //Shift State
          KC_Key := KC_Key + '_Shift';
          GetCharForKey := utf8decode(KeyData.item[KC_Key]);
          Exit;
     End
     Else If (var_IfShift = False) And (var_IfAltGr = True) Then Begin
          //AltGr State
          KC_Key := KC_Key + '_AltGr';
          //Debug.Print 'KeyName is:' & KC_Key & ' AltGr=' & var_IfAltGr
          GetCharForKey := utf8decode(KeyData.item[KC_Key]);
          Exit;
     End
     Else If (var_IfShift = True) And (var_IfAltGr = True) Then Begin
          //Shift+AltGr State
          KC_Key := KC_Key + '_ShiftAltGr';
          //Debug.Print 'KeyName is:' & KC_Key & ' AltGr=' & var_IfAltGr
          GetCharForKey := utf8decode(KeyData.item[KC_Key]);
          Exit;
     End;

End;

{===============================================================================}
{$HINTS Off}

Function Init_KeyboardLayout(Const KeyboardLayoutName: String): Boolean;
Var
     LayoutPath               : String;

Begin
     Result := False;
     Destroy_KeyboardLayoutData;
     Init_KeyboardLayoutData;

     LayoutPath := GetAvroDataDir + 'Keyboard Layouts\' + KeyboardLayoutName + '.avrolayout';

     If FileExists(LayoutPath) Then
          Result := LoadLayout(LayoutPath)
     Else
          Result := False;

End;
{$HINTS On}
{===============================================================================}

Procedure Init_KeyboardLayoutData;
Begin
     KeyData := TStringDictionary.Create;
     KeyData.DuplicatesAction := ddIgnore;
     KeyData.Clear;
End;

{===============================================================================}

Procedure Destroy_KeyboardLayoutData;
Begin
     KeyData.Free;
End;

{===============================================================================}
{$HINTS Off}

Function LoadLayout(Const LayoutPath: String): Boolean;
Var
     XML                      : TNativeXml;
     Node                     : TXmlNode;
     I                        : Integer;

     m_Converter              : TSkinLayoutConverter;
Begin
     Result := False;

     Try
          Try

               XML := TNativeXml.Create;
               XML.ExternalEncoding := seUTF8;
               XML.LoadFromFile(LayoutPath);
               Application.ProcessMessages;

               //----------------------------------------------
               //Check if the skin is a compatible one
               If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsString) <> '5' Then Begin

                    FreeAndNil(XML);

                    m_Converter := TSkinLayoutConverter.Create;
                    m_Converter.CheckConvertLayout(LayoutPath);
                    FreeAndNil(m_Converter);


                    XML := TNativeXml.Create;
                    XML.ExternalEncoding := seUTF8;
                    XML.LoadFromFile(LayoutPath);
                    Application.ProcessMessages;

                    //Check again
                    If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsString) <> '5' Then Begin
                         Application.MessageBox('This Keyboard Layout is not compatible with current version of Avro Keyboard.', 'Error loading keyboard layout...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                         Result := False;
                         Exit;
                    End;
               End;
               //----------------------------------------------

               Application.ProcessMessages;

               //----------------------------------------------
               //Load Key Data
               Node := XML.Root.FindNode('KeyData');
               Application.ProcessMessages;
               For I := 0 To Node.NodeCount - 1 Do Begin
                    If Node.Nodes[i].NodeCount <= 0 Then
                         //If item has no cdata
                         KeyData.Add(Node.Nodes[i].Name, '')
                    Else
                         //if item has cdata
                         KeyData.Add(Node.Nodes[i].Name, Node.Nodes[i].Nodes[0].ValueAsstring);
                    Application.ProcessMessages;
               End;

               Result := True;
          Except
               On E: Exception Do Begin
                    Result := False;
                    Application.ProcessMessages;
               End;
          End;
     Finally
          XML.Free;
          Application.ProcessMessages;
     End;
End;
{$HINTS On}
{===============================================================================}

Procedure LoadKeyboardLayoutImages(Const LayoutPath: String; Var Pic_LayoutNormal: TBitmap; Var Pic_LayoutAltGr: TBitmap);
Var
     XML                      : TNativeXml;
     Stream                   : TStringStream;
     Resource                 : TResourceStream;

     m_Converter              : TSkinLayoutConverter;
Begin

     FreeAndNil(Pic_LayoutNormal);
     FreeAndNil(Pic_LayoutAltGr);
     Application.ProcessMessages;


     Try
          Try
               If LowerCase(LayoutPath) <> 'avrophonetic*' Then Begin



                    XML := TNativeXml.Create;
                    XML.ExternalEncoding := seUTF8;

                    XML.LoadFromFile(LayoutPath);
                    Application.ProcessMessages;

                    //----------------------------------------------
                    //Check if the layout is a compatible one
                    If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsString) <> '5' Then Begin

                         FreeAndNil(XML);

                         m_Converter := TSkinLayoutConverter.Create;
                         m_Converter.CheckConvertLayout(LayoutPath);
                         FreeAndnil(m_Converter);
                         Application.ProcessMessages;


                         XML := TNativeXml.Create;
                         XML.ExternalEncoding := seUTF8;
                         XML.LoadFromFile(LayoutPath);
                         Application.ProcessMessages;

                         //Check again
                         If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsString) <> '5' Then Begin
                              Application.MessageBox('This Keyboard Layout is not compatible with current version of Avro Keyboard.', 'Error loading keyboard layout...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                              Exit;
                         End;
                    End;
                    //----------------------------------------------
                    Application.ProcessMessages;

                    Stream := TStringStream.Create(Xml.Root.FindNode('ImageNormalShift').BinaryString);
                    Pic_LayoutNormal := TBitmap.Create;
                    If Stream.Size > 0 Then
                         Pic_LayoutNormal.LoadFromStream(Stream)
                    Else
                         FreeAndNil(Pic_LayoutNormal);
                    FreeAndNil(Stream);

                    Application.ProcessMessages;

                    Stream := TStringStream.Create(Xml.Root.FindNode('ImageAltGrShift').BinaryString);
                    Pic_LayoutAltGr := TBitmap.Create;
                    If Stream.Size > 0 Then
                         Pic_LayoutAltGr.LoadFromStream(Stream)
                    Else
                         FreeAndNil(Pic_LayoutAltGr);

                    Application.ProcessMessages;

                    FreeAndNil(Stream);

                    FreeAndNil(XML);

               End
               Else Begin
                    Resource := TResourceStream.Create(Hinstance, 'PHONETIC0', RT_RCDATA);
                    Pic_LayoutNormal := TBitmap.Create;
                    Pic_LayoutNormal.LoadFromStream(Resource);
                    FreeAndNil(Resource);
                    Application.ProcessMessages;
               End;

          Except
               On E: Exception Do Begin
                    //Do nothing
               End;
          End;
     Finally
          //
     End;


End;


{===============================================================================}

Procedure ShowLayoutDescription(Const LayoutPath: String);
Var
     XML                      : TNativeXml;
     InternalName, Developer, Version, Comment: String;
     m_Converter              : TSkinLayoutConverter;
Begin
     Try
          Try
               If LowerCase(LayoutPath) <> 'avrophonetic*' Then Begin


                    XML := TNativeXml.Create;
                    XML.ExternalEncoding := seUTF8;
                    XML.LoadFromFile(LayoutPath);
                    Application.ProcessMessages;

                    //----------------------------------------------
                    //Check if the layout is a compatible one
                    If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsString) <> '5' Then Begin


                         FreeAndNil(XML);

                         m_Converter := TSkinLayoutConverter.Create;
                         m_Converter.CheckConvertLayout(LayoutPath);
                         FreeAndNil(m_Converter);

                         Application.ProcessMessages;


                         XML := TNativeXml.Create;
                         XML.ExternalEncoding := seUTF8;
                         XML.LoadFromFile(LayoutPath);
                         Application.ProcessMessages;

                         //Check again
                         If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsString) <> '5' Then Begin
                              Application.MessageBox('This Keyboard Layout is not compatible with current version of Avro Keyboard.', 'Error loading keyboard layout...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                              Exit;
                         End;
                    End;
                    //----------------------------------------------
                    Application.ProcessMessages;

                    InternalName := Xml.Root.FindNode('LayoutName').Nodes[0].ValueAsString;
                    Application.ProcessMessages;
                    Developer := Xml.Root.FindNode('DeveloperName').Nodes[0].ValueAsString;
                    Application.ProcessMessages;
                    Version := Xml.Root.FindNode('LayoutVersion').Nodes[0].ValueAsString;
                    Application.ProcessMessages;
                    Comment := Xml.Root.FindNode('DeveloperComment').Nodes[0].ValueAsString;
                    Application.ProcessMessages;
               End
               Else Begin
                    InternalName := 'Avro Phonetic';
                    Developer := 'Mehdi Hasan (OmicronLab)';
                    Version := '4';
                    Comment := 'In technical definition, Avro Phonetic is not a fixed keyboard layout. ' +
                         'This is actually a text parser which takes input as english text and produce bangla ' +
                         'characters with similarity matching phonetic converter algorithm of OmicronLab.';
               End;

               CheckCreateForm(TfrmAboutSkinLayout, frmAboutSkinLayout, 'frmAboutSkinLayout');

               frmAboutSkinLayout.txtName.text := InternalName;
               frmAboutSkinLayout.txtVersion.text := Version;
               frmAboutSkinLayout.txtDeveloper.text := Developer;
               frmAboutSkinLayout.txtComment.text := Comment;

               frmAboutSkinLayout.ShowDescription;
          Except
               On E: Exception Do Begin
                    //Do nothing
               End;
          End;
     Finally
          FreeAndNil(XML);
     End;

End;

{===============================================================================}

Function InstallLayout(Const LayoutPath: String): Boolean;
Var
     XML                      : TNativeXml;
     InternalName, Developer, Version, Comment: String;
     m_Converter              : TSkinLayoutConverter;
     FileName                 : String;
     Overwrite                : boolean;
Begin
     result := False;
     Try
          Try
               XML := TNativeXml.Create;
               XML.ExternalEncoding := seUTF8;
               XML.LoadFromFile(LayoutPath);
               Application.ProcessMessages;

               InternalName := Xml.Root.FindNode('LayoutName').Nodes[0].ValueAsString;
               Application.ProcessMessages;
               Developer := Xml.Root.FindNode('DeveloperName').Nodes[0].ValueAsString;
               Application.ProcessMessages;
               Version := Xml.Root.FindNode('LayoutVersion').Nodes[0].ValueAsString;
               Application.ProcessMessages;
               Comment := Xml.Root.FindNode('DeveloperComment').Nodes[0].ValueAsString;
               Application.ProcessMessages;

               FreeAndNil(XML);
               Filename := ExtractFilename(LayoutPath);

               If FileExists(GetAvroDataDir + 'Keyboard Layouts\' + Filename) Then Begin
                    If Application.MessageBox(pchar('Keyboard layout "' + Filename + '" is already installed.' + #10 + 'Do you want to overwrite it?'), 'Avro Keyboard', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_SYSTEMMODAL) = ID_YES Then
                         Overwrite := True
                    Else
                         Overwrite := False;
               End;

               If MyCopyFile(LayoutPath, GetAvroDataDir + 'Keyboard Layouts\' + Filename, Overwrite) Then Begin
                    Result := True;
                    Application.MessageBox(Pchar('Keyboard layout "' + Filename + '" has been installed successfully!' + #10 + '' + #10 +
                         'Layout name: ' + InternalName + #10 +
                         'Version: ' + Version + #10 +
                         'Developer: ' + Developer + #10 +
                         'Comment: ' + Comment + #10), 'Avro Keyboard', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

                    //Check and convert the skin
                    m_Converter := TSkinLayoutConverter.Create;
                    m_Converter.CheckConvertLayout(GetAvroDataDir + 'Keyboard Layouts\' + Filename);
                    FreeAndNil(m_Converter);
                    Application.ProcessMessages;

               End
               Else Begin
                    Result := False;
                    Application.MessageBox(pchar('Keyboard layout "' + Filename + '" was not installed!'),
                         'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);
               End;

          Except
               On e: exception Do Begin
                    result := False;

                    Application.MessageBox(pchar('Error installing keyboard layout!' + #10 + '' + #10 + '' + #10 +
                         'Make sure this is a valid keyboard layout file' + #10 + 'or,'
                         + #10 + 'You have enough permission to write in keyboard layouts folder' + #10 +
                         'or,' + #10 + 'Keyboard layouts directory is writable'),
                         'Avro Keyboard', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_SYSTEMMODAL);

               End;
          End;
     Finally
          FreeAndNil(XML);
     End;

End;

{===============================================================================}

Procedure LoadKeyboardLayoutNames;
Var
     I, Count                 : Integer;
Begin
     KeyboardLayouts := TStringList.Create;
     Count := GetFileList(GetAvroDataDir + 'Keyboard Layouts\*.avrolayout', KeyboardLayouts);

     If Count <= 0 Then exit;

     For I := 0 To Count - 1 Do Begin
          KeyboardLayouts[I] := RemoveExtension(KeyboardLayouts[I]);
     End;
End;

End.

