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
     Mehdi Hasan Khan <mhasan@omicronlab.com>.

     Copyright (C) OmicronLab <http://www.omicronlab.com>. All Rights Reserved.


     Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

Unit clsSkinLayoutConverter;

Interface
Uses
     classes,
     NativeXml,
     jpeg,
     GIFImg,
     Graphics,
     SysUtils,
     StrUtils;

Type
     TSkinLayoutConverter = Class
     Private
          mPath: String;
          OldXML, NewXML: TNativeXML;
          OldNode: TXmlNode;

          child: TXmlNode;
          CdataChild: TXmlNode;
          KeyData: TXmlNode;

          Procedure CopyCDataNode(Nodename: String);
          Procedure CopyNode(Nodename: String);
          Procedure CreateVersionNode;
          Procedure CopyImageNode(Nodename: String);
          Procedure CopyKeyDataNodes;
          Function NeedConversion: Boolean;
          Procedure CheckCreateXMLObject;
     Public
          Constructor Create;           //Initializer
          Destructor Destroy; Override;
          Function CheckConvertSkin(Path: String): Boolean;
          Function CheckConvertLayout(Path: String): Boolean;
     End;

Const
     AvroKeyboardVersion      = '5';


Implementation

{ TSkinLayoutConverter }

{===============================================================================}

Function TSkinLayoutConverter.CheckConvertLayout(Path: String): Boolean;
Begin
     result := False;
     mPath := Path;
     CheckCreateXMLObject;

     Try
          Try
               OldXML.LoadFromFile(mPath);

               If Not NeedConversion Then exit;


               NewXML.Root.Name := 'Layout';
               CreateVersionNode;
               CopyCDataNode('LayoutName');
               CopyCDataNode('LayoutVersion');
               CopyCDataNode('DeveloperName');
               CopyCDataNode('DeveloperComment');

               CopyImageNode('ImageNormalShift');
               CopyImageNode('ImageAltGrShift');

               CopyKeyDataNodes;

               FreeAndNil(OldXML);
               NewXML.SaveToFile(Path);
               Result := True;
          Except
               On E: Exception Do Begin
                    Result := false;
               End;
          End;
     Finally
          FreeAndNil(OldXML);
          FreeAndNil(NewXML);
     End;

End;

{===============================================================================}

Function TSkinLayoutConverter.CheckConvertSkin(Path: String): Boolean;
Begin
     result := False;
     mPath := Path;
     CheckCreateXMLObject;

     Try
          Try
               OldXML.LoadFromFile(mPath);

               If Not NeedConversion Then exit;

               NewXML.Root.Name := 'Layout';
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

               //Main Image
               CopyImageNode('TopBarMain');
               CopyNode('TopBarHeight');
               CopyNode('TopBarWidth');

               //Avro icon
               CopyImageNode('AvroIconNormal');
               CopyImageNode('AvroIconOver');
               CopyImageNode('AvroIconDown');
               CopyNode('AvroIconHeight');
               CopyNode('AvroIconWidth');
               CopyNode('AvroIconLeft');
               CopyNode('AvroIconTop');


               //Keyboard Mode
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

               //Keyboard Layout
               CopyImageNode('KeyboardLayoutNormal');
               CopyImageNode('KeyboardLayoutOver');
               CopyImageNode('KeyboardLayoutDown');
               CopyNode('KeyboardLayoutHeight');
               CopyNode('KeyboardLayoutWidth');
               CopyNode('KeyboardLayoutLeft');
               CopyNode('KeyboardLayoutTop');

               //LayoutViewer
               CopyImageNode('LayoutViewerNormal');
               CopyImageNode('LayoutViewerOver');
               CopyImageNode('LayoutViewerDown');
               CopyNode('LayoutViewerHeight');
               CopyNode('LayoutViewerWidth');
               CopyNode('LayoutViewerLeft');
               CopyNode('LayoutViewerTop');

               //AvroMouse
               CopyImageNode('AvroMouseNormal');
               CopyImageNode('AvroMouseOver');
               CopyImageNode('AvroMouseDown');
               CopyNode('AvroMouseHeight');
               CopyNode('AvroMouseWidth');
               CopyNode('AvroMouseLeft');
               CopyNode('AvroMouseTop');

               //Tools
               CopyImageNode('ToolsNormal');
               CopyImageNode('ToolsOver');
               CopyImageNode('ToolsDown');
               CopyNode('ToolsHeight');
               CopyNode('ToolsWidth');
               CopyNode('ToolsLeft');
               CopyNode('ToolsTop');

               //Web
               CopyImageNode('WebNormal');
               CopyImageNode('WebOver');
               CopyImageNode('WebDown');
               CopyNode('WebHeight');
               CopyNode('WebWidth');
               CopyNode('WebLeft');
               CopyNode('WebTop');

               //Help
               CopyImageNode('HelpNormal');
               CopyImageNode('HelpOver');
               CopyImageNode('HelpDown');
               CopyNode('HelpHeight');
               CopyNode('HelpWidth');
               CopyNode('HelpLeft');
               CopyNode('HelpTop');

               //Exit
               CopyImageNode('ExitNormal');
               CopyImageNode('ExitOver');
               CopyImageNode('ExitDown');
               CopyNode('ExitHeight');
               CopyNode('ExitWidth');
               CopyNode('ExitLeft');
               CopyNode('ExitTop');

               FreeAndNil(OldXML);
               NewXML.SaveToFile(Path);
               Result := True;
          Except
               On E: Exception Do Begin
                    Result := false;
               End;
          End;
     Finally

     End;
End;

{===============================================================================}

Procedure TSkinLayoutConverter.CheckCreateXMLObject;
Begin
     FreeAndNil(OldXML);
     FreeAndNil(NewXML);

     OldXML := TNativeXML.Create;
     OldXML.Utf8Encoded := True;
     OldXML.EncodingString := 'UTF-8';
     OldXML.ExternalEncoding := seUTF8;



     NewXML := TNativeXML.Create;
     NewXML.Utf8Encoded := True;
     NewXML.EncodingString := 'UTF-8';
     NewXML.XmlFormat := xfReadable;
     NewXML.ExternalEncoding := seUTF8;

End;

{===============================================================================}

Procedure TSkinLayoutConverter.CopyCDataNode(Nodename: String);
Begin
     Try
          Child := NewXML.Root.NodeNew(Nodename);
          CdataChild := Child.NodeNew(Nodename);
          CdataChild.ElementType := xeCData;
          CdataChild.ValueAsString := OldXML.Root.FindNode(Nodename).Nodes[0].ValueAsString;
     Except
          On e: Exception Do Begin

          End;
     End;
End;

{===============================================================================}

Procedure TSkinLayoutConverter.CopyImageNode(Nodename: String);
Var
     OldSStream, NewSStream   : TStringStream;
     JpegImg                  : TjpegImage;
     GifImg                   : TGifImage;
     BMPImg, Bitmap           : TBitmap;
     Successful               : Boolean;
Begin
     Try
          OldSStream := TStringStream.Create(OldXML.Root.FindNode(Nodename).BinaryString);
     Except
          On e: Exception Do Begin

          End;
     End;



     If OldSStream.Size > 0 Then Begin
          Successful := False;

          //Try Gif
          If Not Successful Then Begin
               Try
                    GifImg := TGifImage.Create;
                    OldSStream.Position:=0;
                    GifImg.LoadFromStream(OldSStream);
                    Bitmap := TBitmap.Create;
                    Bitmap.Assign(GifImg);

                    NewSStream := TStringStream.Create('');
                    Bitmap.SaveToStream(NewSStream);
                    FreeAndNil(GifImg);
                    FreeAndNil(Bitmap);
                    Successful := True;
               Except
                    On e: Exception Do Begin
                         Successful := False;
                    End;
               End;
          End;


          //Try JPG
          If Not Successful Then Begin
               Try
                    JpegImg := TjpegImage.Create;
                    OldSStream.Position:=0;
                    JpegImg.LoadFromStream(OldSStream);
                    Bitmap := TBitmap.Create;
                    Bitmap.Assign(JpegImg);

                    NewSStream := TStringStream.Create('');
                    Bitmap.SaveToStream(NewSStream);
                    FreeAndNil(JpegImg);
                    FreeAndNil(Bitmap);
                    Successful := True;
               Except
                    On e: Exception Do Begin
                         Successful := False;
                    End;
               End;
          End;



          //Try BMP
          If Not Successful Then Begin
               Try
                    BMPImg := TBitmap.Create;
                    OldSStream.Position:=0;
                    BMPImg.LoadFromStream(OldSStream);

                    NewSStream := TStringStream.Create('');
                    BMPImg.SaveToStream(NewSStream);
                    FreeAndNil(BMPImg);
                    Successful := True;
               Except
                    On e: Exception Do Begin
                         Successful := False;
                    End;
               End;
          End;
     End;

     Try
          Child := NewXML.Root.NodeNew(Nodename);
          Child.BinaryEncoding := xbeBase64;
          Child.BinaryString := NewSStream.DataString;
     Except
          On e: Exception Do Begin

          End;
     End;
End;

{===============================================================================}

Procedure TSkinLayoutConverter.CopyKeyDataNodes;
Var
     I                        : Integer;
Begin
     Try
          KeyData := NewXML.Root.NodeNew('KeyData');
          OldNode := OldXML.Root.FindNode('KeyData');

          For I := 0 To OldNode.NodeCount - 1 Do Begin
               If LowerCase(LeftStr(OldNode.Nodes[i].Name, 3)) <> 'num' Then Begin
                    If OldNode.Nodes[i].NodeCount <= 0 Then Begin
                         //If item has no cdata
                         Child := KeyData.NodeNew('Key_' + OldNode.Nodes[i].Name);
                         CdataChild := Child.NodeNew('Key_' + OldNode.Nodes[i].Name);
                         CdataChild.ElementType := xeCData;
                         CdataChild.ValueAsWidestring := '';
                    End
                    Else Begin
                         //if item has cdata
                         Child := KeyData.NodeNew('Key_' + OldNode.Nodes[i].Name);
                         CdataChild := Child.NodeNew('Key_' + OldNode.Nodes[i].Name);
                         CdataChild.ElementType := xeCData;
                         CdataChild.ValueAsWidestring := utf8decode(OldNode.Nodes[i].Nodes[0].ValueAsWidestring);
                    End;
               End
               Else Begin
                    If OldNode.Nodes[i].NodeCount <= 0 Then Begin
                         //If item has no cdata
                         Child := KeyData.NodeNew(OldNode.Nodes[i].Name);
                         CdataChild := Child.NodeNew(OldNode.Nodes[i].Name);
                         CdataChild.ElementType := xeCData;
                         CdataChild.ValueAsWidestring := '';
                    End
                    Else Begin
                         //if item has cdata
                         Child := KeyData.NodeNew(OldNode.Nodes[i].Name);
                         CdataChild := Child.NodeNew(OldNode.Nodes[i].Name);
                         CdataChild.ElementType := xeCData;
                         CdataChild.ValueAsWidestring := utf8decode(OldNode.Nodes[i].Nodes[0].ValueAsWidestring);
                    End;
               End;
          End;
     Except
          On e: Exception Do Begin

          End;

     End;
End;

{===============================================================================}

Procedure TSkinLayoutConverter.CopyNode(Nodename: String);
Begin
     Try
          Child := NewXML.Root.NodeNew(Nodename);
          Child.ValueAsString := OldXML.Root.FindNode(Nodename).ValueAsString;
     Except
          On e: Exception Do Begin

          End;
     End;
End;

{===============================================================================}

Constructor TSkinLayoutConverter.Create;
Begin
     Inherited;                         // Call the parent Create method

     CheckCreateXMLObject;
End;

{===============================================================================}

Procedure TSkinLayoutConverter.CreateVersionNode;
Begin
     Try
          Child := NewXML.Root.NodeNew('AvroKeyboardVersion');
          Child.ValueAsString := AvroKeyboardVersion;
     Except
          On e: Exception Do Begin

          End;
     End;
End;

{===============================================================================}

Destructor TSkinLayoutConverter.Destroy;
Begin
     FreeAndNil(OldXML);
     FreeAndNil(NewXML);
     // Always call the parent destructor after running all codes
     Inherited;
End;

{===============================================================================}

Function TSkinLayoutConverter.NeedConversion: Boolean;
Var
     AvroVer                  : String;
Begin
     Try
          AvroVer := trim(OldXML.Root.FindNode('AvroKeyboardVersion').ValueAsString);
     Except
          On e: Exception Do Begin

          End;
     End;

     If AvroVer = '4' Then
          Result := True
     Else If AvroVer = '5' Then
          Result := False
     Else
          Result := False;

End;

{===============================================================================}

End.

