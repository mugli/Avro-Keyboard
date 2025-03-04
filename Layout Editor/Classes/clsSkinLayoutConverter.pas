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

Unit clsSkinLayoutConverter;

Interface

Uses
  classes,
  dialogs,
  XMLIntf, XMLDoc,
  Soap.EncdDecd,
  jpeg,
  GIFImg,
  Graphics,
  SysUtils,
  StrUtils,
  Forms;

Type
  TSkinLayoutConverter = Class
  Private
    mPath: String;
    OldXML, NewXML: IXMLDocument;
    OldNode: IXmlNode;

    child: IXmlNode;
    CdataChild: IXmlNode;
    KeyData: IXmlNode;

    Procedure CopyCDataNode(Nodename: UTF8String);
    Procedure CopyNode(Nodename: UTF8String);
    Procedure CreateVersionNode;
    Procedure CopyImageNode(Nodename: UTF8String);
    Procedure CopyKeyDataNodes;
    Function NeedConversion: Boolean;
    Procedure CheckCreateXMLObject;
  Public
    Constructor Create; // Initializer
    Destructor Destroy; Override;
    Function CheckConvertSkin(Path: String): Boolean;
    Function CheckConvertLayout(Path: String): Boolean;
  End;

Const
  AvroKeyboardVersion: String = '5';

Implementation

{ TSkinLayoutConverter }

{ =============================================================================== }

Function TSkinLayoutConverter.CheckConvertLayout(Path: String): Boolean;
Begin
  result := False;
  mPath := Path;
  CheckCreateXMLObject;

  Try
    Try
      OldXML.LoadFromFile(mPath);
      Application.ProcessMessages;

      If Not NeedConversion Then
        exit;

      // NewXML.Root.Name := 'Layout';
      NewXML.AddChild('Layout');
      CreateVersionNode;
      CopyCDataNode('LayoutName');
      CopyCDataNode('LayoutVersion');
      CopyCDataNode('DeveloperName');
      CopyCDataNode('DeveloperComment');

      CopyImageNode('ImageNormalShift');
      CopyImageNode('ImageAltGrShift');

      CopyKeyDataNodes;

      OldXML.Active := False;
      OldXML := Nil;
      NewXML.XML.Text := XMLDoc.FormatXMLData(NewXML.XML.Text);
      NewXML.Active := true;
      NewXML.SaveToFile(Path);
      result := true;
    Except
      On E: Exception Do
      Begin
        result := False;
      End;
    End;
  Finally
    OldXML.Active := False;
    OldXML := Nil;
    NewXML.Active := False;
    NewXML := Nil;
    Application.ProcessMessages;
  End;

End;

{ =============================================================================== }

Function TSkinLayoutConverter.CheckConvertSkin(Path: String): Boolean;
Begin
  result := False;
  mPath := Path;
  CheckCreateXMLObject;

  Try
    Try
      OldXML.LoadFromFile(mPath);

      If Not NeedConversion Then
        exit;

      // NewXML.Root.Name := 'Layout';
      NewXML.AddChild('Layout');
      CreateVersionNode;

      CopyCDataNode('SkinName');
      CopyCDataNode('SkinVersion');
      CopyCDataNode('DesignerName');
      CopyCDataNode('DesignerComment');

      CopyImageNode('Preview');

      CopyNode('AvroIconAdded');
      CopyNode('KeyboardModeAdded');
      CopyNode('KeyboardLayoutAdded');
      CopyNode('LayoutViewerAdded');
      CopyNode('AvroMouseAdded');
      CopyNode('ToolsAdded');
      CopyNode('WebAdded');
      CopyNode('HelpAdded');
      CopyNode('ExitAdded');

      // Main Image
      CopyImageNode('TopBarMain');
      CopyNode('TopBarHeight');
      CopyNode('TopBarWidth');

      // Avro icon
      CopyImageNode('AvroIconNormal');
      CopyImageNode('AvroIconOver');
      CopyImageNode('AvroIconDown');
      CopyNode('AvroIconHeight');
      CopyNode('AvroIconWidth');
      CopyNode('AvroIconLeft');
      CopyNode('AvroIconTop');

      // Keyboard Mode
      CopyImageNode('KeyboardModeEnglishNormal');
      CopyImageNode('KeyboardModeEnglishOver');
      CopyImageNode('KeyboardModeEnglishDown');
      CopyImageNode('KeyboardModeBanglaNormal');
      CopyImageNode('KeyboardModeBanglaOver');
      CopyImageNode('KeyboardModeBanglaDown');
      CopyNode('KeyboardModeHeight');
      CopyNode('KeyboardModeWidth');
      CopyNode('KeyboardModeLeft');
      CopyNode('KeyboardModeTop');

      // Keyboard Layout
      CopyImageNode('KeyboardLayoutNormal');
      CopyImageNode('KeyboardLayoutOver');
      CopyImageNode('KeyboardLayoutDown');
      CopyNode('KeyboardLayoutHeight');
      CopyNode('KeyboardLayoutWidth');
      CopyNode('KeyboardLayoutLeft');
      CopyNode('KeyboardLayoutTop');

      // LayoutViewer
      CopyImageNode('LayoutViewerNormal');
      CopyImageNode('LayoutViewerOver');
      CopyImageNode('LayoutViewerDown');
      CopyNode('LayoutViewerHeight');
      CopyNode('LayoutViewerWidth');
      CopyNode('LayoutViewerLeft');
      CopyNode('LayoutViewerTop');

      // AvroMouse
      CopyImageNode('AvroMouseNormal');
      CopyImageNode('AvroMouseOver');
      CopyImageNode('AvroMouseDown');
      CopyNode('AvroMouseHeight');
      CopyNode('AvroMouseWidth');
      CopyNode('AvroMouseLeft');
      CopyNode('AvroMouseTop');

      // Tools
      CopyImageNode('ToolsNormal');
      CopyImageNode('ToolsOver');
      CopyImageNode('ToolsDown');
      CopyNode('ToolsHeight');
      CopyNode('ToolsWidth');
      CopyNode('ToolsLeft');
      CopyNode('ToolsTop');

      // Web
      CopyImageNode('WebNormal');
      CopyImageNode('WebOver');
      CopyImageNode('WebDown');
      CopyNode('WebHeight');
      CopyNode('WebWidth');
      CopyNode('WebLeft');
      CopyNode('WebTop');

      // Help
      CopyImageNode('HelpNormal');
      CopyImageNode('HelpOver');
      CopyImageNode('HelpDown');
      CopyNode('HelpHeight');
      CopyNode('HelpWidth');
      CopyNode('HelpLeft');
      CopyNode('HelpTop');

      // Exit
      CopyImageNode('ExitNormal');
      CopyImageNode('ExitOver');
      CopyImageNode('ExitDown');
      CopyNode('ExitHeight');
      CopyNode('ExitWidth');
      CopyNode('ExitLeft');
      CopyNode('ExitTop');

      OldXML.Active := False;
      OldXML := Nil;
      NewXML.XML.Text := XMLDoc.FormatXMLData(NewXML.XML.Text);
      NewXML.Active := true;
      NewXML.SaveToFile(Path);
      result := true;
    Except
      On E: Exception Do
      Begin
        result := False;
      End;
    End;
  Finally

  End;
End;

{ =============================================================================== }

Procedure TSkinLayoutConverter.CheckCreateXMLObject;
Begin
  if OldXML <> nil then
  begin

    OldXML.Active := False;
    OldXML := Nil;
  end;
  if NewXML <> nil then
  begin
    NewXML.Active := False;
    NewXML := Nil;
  end;

  OldXML := TXMLDocument.Create(nil);
  OldXML.Active := true;
  OldXML.Encoding := 'UTF-8';

  NewXML := TXMLDocument.Create(nil);
  NewXML.Active := true;
  // NewXML.XmlFormat := xfReadable;

  NewXML.Encoding := 'UTF-8';

  Application.ProcessMessages;
End;

{ =============================================================================== }

Procedure TSkinLayoutConverter.CopyCDataNode(Nodename: UTF8String);
Begin
  Try
    child := NewXML.DocumentElement.AddChild(Nodename);
    CdataChild := child.AddChild(Nodename);
    // CdataChild.ElementType := xeCData;
    CdataChild.NodeValue := OldXML.DocumentElement.ChildNodes.Nodes[0]
      .ChildNodes.FindNode(Nodename).ChildNodes.Nodes[0].NodeValue;
  Except
    On E: Exception Do
    Begin

    End;
  End;
  Application.ProcessMessages;
End;

{ =============================================================================== }

Procedure TSkinLayoutConverter.CopyImageNode(Nodename: UTF8String);
Var
  OldSStream, NewSStream: TStringStream;
  JpegImg: TjpegImage;
  GIFImg: TGifImage;
  BMPImg, Bitmap: TBitmap;
  Successful: Boolean;

var
  s, Encoded: string;

Begin
  Try

    s := OldXML.DocumentElement.ChildNodes.Nodes[0].ChildNodes.FindNode
      (Nodename).NodeValue;

    OldSStream := TStringStream.Create(EncodeBase64(pchar(s), length(s)));
  Except
    On E: Exception Do
    Begin

    End;
  End;
  Application.ProcessMessages;

  If OldSStream.Size > 0 Then
  Begin
    Successful := False;

    // Try Gif
    If Not Successful Then
    Begin
      Try
        GIFImg := TGifImage.Create;
        OldSStream.Position := 0;
        GIFImg.LoadFromStream(OldSStream);
        Bitmap := TBitmap.Create;
        Bitmap.Assign(GIFImg);

        NewSStream := TStringStream.Create('');
        Bitmap.SaveToStream(NewSStream);
        FreeAndNil(GIFImg);
        FreeAndNil(Bitmap);
        Successful := true;
      Except
        On E: Exception Do
        Begin
          Successful := False;
        End;
      End;
    End;
    Application.ProcessMessages;

    // Try JPG
    If Not Successful Then
    Begin
      Try
        JpegImg := TjpegImage.Create;
        OldSStream.Position := 0;
        JpegImg.LoadFromStream(OldSStream);
        Bitmap := TBitmap.Create;
        Bitmap.Assign(JpegImg);

        NewSStream := TStringStream.Create('');
        Bitmap.SaveToStream(NewSStream);
        FreeAndNil(JpegImg);
        FreeAndNil(Bitmap);
        Successful := true;
      Except
        On E: Exception Do
        Begin
          Successful := False;
        End;
      End;
    End;
    Application.ProcessMessages;

    // Try BMP
    If Not Successful Then
    Begin
      Try
        BMPImg := TBitmap.Create;
        OldSStream.Position := 0;
        BMPImg.LoadFromStream(OldSStream);

        NewSStream := TStringStream.Create('');
        BMPImg.SaveToStream(NewSStream);
        FreeAndNil(BMPImg);
        Successful := true;
      Except
        On E: Exception Do
        Begin
          Successful := False;
        End;
      End;
    End;

    Application.ProcessMessages;

  End;

  Try
    child := NewXML.DocumentElement.AddChild(Nodename);
    // child.BinaryEncoding := xbeBase64;
    child.NodeValue := NewSStream.DataString;
  Except
    On E: Exception Do
    Begin

    End;
  End;
  Application.ProcessMessages;
End;

{ =============================================================================== }

Procedure TSkinLayoutConverter.CopyKeyDataNodes;
Var
  I: Integer;
Begin
  Try
    KeyData := NewXML.DocumentElement.AddChild('KeyData');
    OldNode := OldXML.DocumentElement.ChildNodes.FindNode('KeyData');

    For I := 0 To OldNode.ChildNodes.Count - 1 Do
    Begin

      Application.ProcessMessages;

      If LowerCase(LeftStr(String(OldNode.ChildNodes.Nodes[I].Nodename), 3)) <>
        'num' Then
      Begin
        If OldNode.ChildNodes.Nodes[I].ChildNodes.Count <= 0 Then
        Begin
          // If item has no cdata
          child := KeyData.AddChild('Key_' + OldNode.ChildNodes.Nodes[I]
            .Nodename);
          CdataChild := child.AddChild('Key_' + OldNode.ChildNodes.Nodes[I]
            .Nodename);
          // CdataChild.ElementType := xeCData;
          CdataChild.NodeValue := '';
        End
        Else
        Begin
          // if item has cdata
          child := KeyData.AddChild('Key_' + OldNode.ChildNodes.Nodes[I]
            .Nodename);
          CdataChild := child.AddChild('Key_' + OldNode.ChildNodes.Nodes[I]
            .Nodename);
          // CdataChild.ElementType := xeCData;
          CdataChild.NodeValue := OldNode.ChildNodes.Nodes[I].ChildNodes.Nodes
            [0].NodeValue;
        End;
      End
      Else
      Begin
        If OldNode.ChildNodes.Nodes[I].ChildNodes.Count <= 0 Then
        Begin
          // If item has no cdata
          child := KeyData.AddChild(OldNode.ChildNodes.Nodes[I].Nodename);
          CdataChild := child.AddChild(OldNode.ChildNodes.Nodes[I].Nodename);
          // CdataChild.ElementType := xeCData;
          CdataChild.NodeValue := '';
        End
        Else
        Begin
          // if item has cdata
          child := KeyData.AddChild(OldNode.ChildNodes.Nodes[I].Nodename);
          CdataChild := child.AddChild(OldNode.ChildNodes.Nodes[I].Nodename);
          // CdataChild.ElementType := xeCData;
          CdataChild.NodeValue := OldNode.ChildNodes.Nodes[I].ChildNodes.Nodes
            [0].NodeValue;
        End;
      End;
    End;
  Except
    On E: Exception Do
    Begin

    End;

  End;

  Application.ProcessMessages;
End;

{ =============================================================================== }

Procedure TSkinLayoutConverter.CopyNode(Nodename: UTF8String);
Begin
  Try
    child := NewXML.DocumentElement.AddChild(Nodename);
    child.NodeValue := OldXML.DocumentElement.ChildNodes.Nodes[0]
      .ChildNodes.FindNode(Nodename).NodeValue;
  Except
    On E: Exception Do
    Begin

    End;
  End;
End;

{ =============================================================================== }

Constructor TSkinLayoutConverter.Create;
Begin
  Inherited; // Call the parent Create method

  CheckCreateXMLObject;
End;

{ =============================================================================== }

Procedure TSkinLayoutConverter.CreateVersionNode;
Begin
  Try
    child := NewXML.DocumentElement.AddChild('AvroKeyboardVersion');
    child.NodeValue := AvroKeyboardVersion;
  Except
    On E: Exception Do
    Begin

    End;
  End;
  Application.ProcessMessages;
End;

{ =============================================================================== }

Destructor TSkinLayoutConverter.Destroy;
Begin
  if OldXML <> nil then
  begin
    OldXML.Active := False;
    OldXML := Nil;
  end;
  if NewXML <> nil then
  begin
    NewXML.Active := False;
    NewXML := Nil;
  end;
  // Always call the parent destructor after running all codes
  Inherited;
End;

{ =============================================================================== }

Function TSkinLayoutConverter.NeedConversion: Boolean;
Var
  AvroVer: String;
Begin
  Try

    AvroVer := trim(OldXML.DocumentElement.ChildNodes.FindNode
      ('AvroKeyboardVersion').NodeValue);
  Except
    On E: Exception Do
    Begin

    End;
  End;

  If AvroVer = '4' Then
    result := true
  Else If AvroVer = '5' Then
    result := False
  Else
    result := False;

End;

{ =============================================================================== }

End.
