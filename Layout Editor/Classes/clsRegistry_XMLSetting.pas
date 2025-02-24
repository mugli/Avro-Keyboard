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

{$INCLUDE ../ProjectDefines.inc}

{COMPLETE TRANSFERING!}


Unit clsRegistry_XMLSetting;

Interface

Uses
  classes,
  sysutils,
  StrUtils,
  windows,
  XMLIntf, XMLDoc,
  Forms,
  Registry,
  Dialogs,
  system.Variants,
  uFileFolderHandling;

Type
  TMyRegistry = class(TRegistry)
  public
    function ReadStringDef(const Name: String; DefaultVal: String = ''): String;
  end;

Type
  TXMLSetting = class
  private
    XML: IXMLDocument;
    child: IXMLNode;

  public
    constructor Create;
    destructor Destroy; override;

    function LoadXMLData(): Boolean;
    function GetValue(const ValueName: UTF8String; DefaultValue: String = ''): String; overload;
    procedure CreateNewXMLData;
    procedure SetValue(const ValueName: UTF8String; const ValueData: String); overload;
    procedure SaveXMLData;

  end;

implementation

{ TXMLSetting }

constructor TXMLSetting.Create;
begin
  inherited;

  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  XML.Encoding := 'UTF-8';
  XML.AddChild('Settings');

end;

{===============================================================================}

procedure TXMLSetting.CreateNewXMLData;
begin

  if XML <> nil then
    XML := nil;

  XML := TXMLDocument.Create(nil);
  XML.Active := true;

  XML.Encoding := 'UTF-8';
  XML.AddChild('Settings');
end;

{===============================================================================}

destructor TXMLSetting.Destroy;
begin
  XML.Active := false;
  XML := nil;
  inherited;
end;

{===============================================================================}


function TXMLSetting.GetValue(const ValueName: UTF8String;
  DefaultValue: String): String;
begin
  try

    child := XML.DocumentElement.ChildNodes.FindNode(ValueName);

    if assigned(child) then
    begin
      if Length(Trim(child.ChildNodes.Nodes[0].NodeValue)) <= 0 then
        Result := DefaultValue
      else
        Result := VarToStr(Trim(child.ChildNodes.Nodes[0].NodeValue));
    end
    else
      Result := DefaultValue
  except
    On E: Exception do
      Result := DefaultValue;
  end;
end;
{$HINTS Off}

function TXMLSetting.LoadXMLData(): Boolean;
begin
  Result := false;
  try
    if FileExists(ExtractFilePath(Application.ExeName) + 'Layout Editor Settings.xml') = true then
    begin
      XML.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Layout Editor Settings.xml');
      Result := True;
    end
    else
      Result := false;
  except
    On E: Exception do
      Result := false;
  end;
end;
{$HINTS On}

procedure TXMLSetting.SaveXMLData;
begin
  XML.XML.Text := XMLDoc.FormatXMLData(XML.XML.Text);
  XML.Active := true;
  try
    XML.SaveToFile(GetAvroDataDir + 'Settings.xml');
  except
    On E: Exception do
    begin
    end;
  end;
end;


{===============================================================================}

procedure TXMLSetting.SetValue(const ValueName: UTF8String;
  const ValueData: String);
var
  CdataChild: IXMLNode;
begin

  child := XML.DocumentElement.AddChild(ValueName);
  CdataChild := XML.CreateNode(ValueData, ntCDATA);
  child.ChildNodes.Add(CdataChild);

end;

{ TMyRegistry }


function TMyRegistry.ReadStringDef(const Name: String;
  DefaultVal: String = ''): String;
begin
  try
    if ValueExists(Name) = true then
      Result := ReadString(Name)
    else
      Result := DefaultVal;
  except
    On E: Exception do
      if Trim(Result) = '' then
        Result := DefaultVal;
  end;
end;

end.
