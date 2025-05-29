{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit clsSkinLayoutConverter;

interface

uses
  classes,
  dialogs,
  XMLIntf,
  XMLDoc,
  Soap.EncdDecd,
  jpeg,
  GIFImg,
  Graphics,
  SysUtils,
  StrUtils,
  Forms;

type
  TSkinLayoutConverter = class
    private
      mPath:          string;
      OldXML, NewXML: IXMLDocument;
      OldNode:        IXmlNode;

      child:      IXmlNode;
      CdataChild: IXmlNode;
      KeyData:    IXmlNode;

      procedure CopyCDataNode(Nodename: UTF8String);
      procedure CopyNode(Nodename: UTF8String);
      procedure CreateVersionNode;
      procedure CopyImageNode(Nodename: UTF8String);
      procedure CopyKeyDataNodes;
      function NeedConversion: Boolean;
      procedure CheckCreateXMLObject;
      procedure AddCDATA(Node: IXmlNode; const Value: string);
    public
      constructor Create; // Initializer
      destructor Destroy; override;
      function CheckConvertSkin(Path: string): Boolean;
      function CheckConvertLayout(Path: string): Boolean;
  end;

const
  AvroKeyboardVersion: string = '5';

implementation

{ TSkinLayoutConverter }

{ =============================================================================== }

function TSkinLayoutConverter.CheckConvertLayout(Path: string): Boolean;
begin
  result := False;
  mPath := Path;
  CheckCreateXMLObject;

  try
    try
      OldXML.LoadFromFile(mPath);
      Application.ProcessMessages;

      if not NeedConversion then
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
      OldXML := nil;
      NewXML.XML.Text := XMLDoc.FormatXMLData(NewXML.XML.Text);
      NewXML.Active := true;
      NewXML.SaveToFile(Path);
      result := true;
    except
      on E: Exception do
      begin
        result := False;
      end;
    end;
  finally
    OldXML.Active := False;
    OldXML := nil;
    NewXML.Active := False;
    NewXML := nil;
    Application.ProcessMessages;
  end;

end;

{ =============================================================================== }

function TSkinLayoutConverter.CheckConvertSkin(Path: string): Boolean;
begin
  result := False;
  mPath := Path;
  CheckCreateXMLObject;

  try
    try
      OldXML.LoadFromFile(mPath);

      if not NeedConversion then
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
      OldXML := nil;
      NewXML.XML.Text := XMLDoc.FormatXMLData(NewXML.XML.Text);
      NewXML.Active := true;
      NewXML.SaveToFile(Path);
      result := true;
    except
      on E: Exception do
      begin
        result := False;
      end;
    end;
  finally

  end;
end;

{ =============================================================================== }

procedure TSkinLayoutConverter.CheckCreateXMLObject;
begin
  if OldXML <> nil then
  begin

    OldXML.Active := False;
    OldXML := nil;
  end;
  if NewXML <> nil then
  begin
    NewXML.Active := False;
    NewXML := nil;
  end;

  OldXML := TXMLDocument.Create(nil);
  OldXML.Active := true;
  OldXML.Encoding := 'UTF-8';

  NewXML := TXMLDocument.Create(nil);
  NewXML.Options := [doNodeAutoIndent];
  NewXML.Active := true;
  NewXML.Encoding := 'UTF-8';

  Application.ProcessMessages;
end;

{ =============================================================================== }

procedure TSkinLayoutConverter.CopyCDataNode(Nodename: UTF8String);
var
  CDATASection: IXmlNode;
begin
  try
    child := NewXML.DocumentElement.AddChild(Nodename);
    AddCDATA(child, OldXML.DocumentElement.ChildNodes.Nodes[0].ChildNodes.FindNode(Nodename).ChildNodes.Nodes[0].NodeValue);
  except
    on E: Exception do
    begin

    end;
  end;
  Application.ProcessMessages;
end;

{ =============================================================================== }

procedure TSkinLayoutConverter.CopyImageNode(Nodename: UTF8String);
var
  OldSStream, NewSStream: TStringStream;
  JpegImg:                TjpegImage;
  GIFImg:                 TGifImage;
  BMPImg, Bitmap:         TBitmap;
  Successful:             Boolean;

var
  s, Encoded: string;

begin
  try

    s := OldXML.DocumentElement.ChildNodes.Nodes[0].ChildNodes.FindNode(Nodename).NodeValue;

    OldSStream := TStringStream.Create(EncodeBase64(pchar(s), length(s)));
  except
    on E: Exception do
    begin

    end;
  end;
  Application.ProcessMessages;

  if OldSStream.Size > 0 then
  begin
    Successful := False;

    // Try Gif
    if not Successful then
    begin
      try
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
      except
        on E: Exception do
        begin
          Successful := False;
        end;
      end;
    end;
    Application.ProcessMessages;

    // Try JPG
    if not Successful then
    begin
      try
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
      except
        on E: Exception do
        begin
          Successful := False;
        end;
      end;
    end;
    Application.ProcessMessages;

    // Try BMP
    if not Successful then
    begin
      try
        BMPImg := TBitmap.Create;
        OldSStream.Position := 0;
        BMPImg.LoadFromStream(OldSStream);

        NewSStream := TStringStream.Create('');
        BMPImg.SaveToStream(NewSStream);
        FreeAndNil(BMPImg);
        Successful := true;
      except
        on E: Exception do
        begin
          Successful := False;
        end;
      end;
    end;

    Application.ProcessMessages;

  end;

  try
    child := NewXML.DocumentElement.AddChild(Nodename);
    // child.BinaryEncoding := xbeBase64;
    child.NodeValue := NewSStream.DataString;
  except
    on E: Exception do
    begin

    end;
  end;
  Application.ProcessMessages;
end;

{ =============================================================================== }

procedure TSkinLayoutConverter.AddCDATA(Node: IXmlNode; const Value: string);
var
  CDATASection: IXmlNode;
begin
  // Create a CDATA section and append it to the node
  CDATASection := Node.OwnerDocument.CreateNode(Value, ntCData, '');
  Node.ChildNodes.Add(CDATASection);
end;

{ =============================================================================== }

procedure TSkinLayoutConverter.CopyKeyDataNodes;
var
  I: Integer;
begin
  try
    KeyData := NewXML.DocumentElement.AddChild('KeyData');
    OldNode := OldXML.DocumentElement.ChildNodes.FindNode('KeyData');

    for I := 0 to OldNode.ChildNodes.Count - 1 do
    begin

      Application.ProcessMessages;

      if LowerCase(LeftStr(string(OldNode.ChildNodes.Nodes[I].Nodename), 3)) <> 'num' then
      begin
        if OldNode.ChildNodes.Nodes[I].ChildNodes.Count <= 0 then
        begin
          // If item has no cdata
          child := KeyData.AddChild('Key_' + OldNode.ChildNodes.Nodes[I].Nodename);
          AddCDATA(child, '');
        end
        else
        begin
          // if item has cdata
          child := KeyData.AddChild('Key_' + OldNode.ChildNodes.Nodes[I].Nodename);
          AddCDATA(child, OldNode.ChildNodes.Nodes[I].ChildNodes.Nodes[0].NodeValue);
        end;
      end
      else
      begin
        if OldNode.ChildNodes.Nodes[I].ChildNodes.Count <= 0 then
        begin
          // If item has no cdata
          child := KeyData.AddChild(OldNode.ChildNodes.Nodes[I].Nodename);
          AddCDATA(child, '');
        end
        else
        begin
          // if item has cdata
          child := KeyData.AddChild(OldNode.ChildNodes.Nodes[I].Nodename);
          AddCDATA(child, OldNode.ChildNodes.Nodes[I].ChildNodes.Nodes[0].NodeValue);
        end;
      end;
    end;
  except
    on E: Exception do
    begin

    end;

  end;

  Application.ProcessMessages;
end;

{ =============================================================================== }

procedure TSkinLayoutConverter.CopyNode(Nodename: UTF8String);
begin
  try
    child := NewXML.DocumentElement.AddChild(Nodename);
    child.NodeValue := OldXML.DocumentElement.ChildNodes.Nodes[0].ChildNodes.FindNode(Nodename).NodeValue;
  except
    on E: Exception do
    begin

    end;
  end;
end;

{ =============================================================================== }

constructor TSkinLayoutConverter.Create;
begin
  inherited; // Call the parent Create method

  CheckCreateXMLObject;
end;

{ =============================================================================== }

procedure TSkinLayoutConverter.CreateVersionNode;
begin
  try
    child := NewXML.DocumentElement.AddChild('AvroKeyboardVersion');
    child.NodeValue := AvroKeyboardVersion;
  except
    on E: Exception do
    begin

    end;
  end;
  Application.ProcessMessages;
end;

{ =============================================================================== }

destructor TSkinLayoutConverter.Destroy;
begin
  if OldXML <> nil then
  begin
    OldXML.Active := False;
    OldXML := nil;
  end;
  if NewXML <> nil then
  begin
    NewXML.Active := False;
    NewXML := nil;
  end;
  // Always call the parent destructor after running all codes
  inherited;
end;

{ =============================================================================== }

function TSkinLayoutConverter.NeedConversion: Boolean;
var
  AvroVer: string;
begin
  try

    AvroVer := trim(OldXML.DocumentElement.ChildNodes.FindNode('AvroKeyboardVersion').NodeValue);
  except
    on E: Exception do
    begin

    end;
  end;

  if AvroVer = '4' then
    result := true
  else if AvroVer = '5' then
    result := False
  else
    result := False;

end;

{ =============================================================================== }

end.
