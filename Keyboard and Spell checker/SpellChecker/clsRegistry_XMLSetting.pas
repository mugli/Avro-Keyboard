{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

unit clsRegistry_XMLSetting;

interface

uses
  classes,
  sysutils,
  StrUtils,
  XMLIntf,
  XMLDoc,
  system.Variants,
  Forms,
  Registry,
  uFileFolderHandling;

// Custom Registry class
type
  TMyRegistry = class(TRegistry)
    public
      function ReadStringDef(const Name: string; DefaultVal: string = ''): string;
      function ReadDateDef(const Name: string; DefaultVal: TDateTime): TDateTime;
  end;

  // Skeleton of Class TXMLSetting
type
  TXMLSetting = class
    private
      XML:   IXMLDocument;
      child: IXMLNode;
    public
      constructor Create;           // Initializer
      destructor Destroy; override; // Destructor

      function LoadXMLData(): Boolean;
      function GetValue(const ValueName: UTF8String; DefaultValue: string = ''): string; overload;
      function GetValue(const ValueName: UTF8String; DefaultValue: TDateTime): TDateTime; overload;
      procedure CreateNewXMLData;
      procedure SetValue(const ValueName: UTF8String; const ValueData: string); overload;
      procedure SetValue(const ValueName: UTF8String; const ValueData: TDateTime); overload;
      procedure SaveXMLData;

  end;

implementation

{ =============================================================================== }

{ TXMLSetting }

constructor TXMLSetting.Create;
begin
  inherited;

  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  XML.Encoding := 'UTF-8';
  XML.AddChild('Settings');

end;

{ =============================================================================== }

procedure TXMLSetting.CreateNewXMLData;
begin
  if XML <> nil then
    XML := nil;

  XML := TXMLDocument.Create(nil);
  XML.Active := true;

  XML.Encoding := 'UTF-8';
  XML.AddChild('Settings');
end;

{ =============================================================================== }

destructor TXMLSetting.Destroy;
begin
  XML.Active := false;
  XML := nil;
  inherited;
end;

{ =============================================================================== }

function TXMLSetting.GetValue(const ValueName: UTF8String; DefaultValue: TDateTime): TDateTime;
begin
  try
    child := XML.DocumentElement.ChildNodes.FindNode(ValueName);
    if assigned(child) then
      Result := VarToDateTime((child.ChildNodes.Nodes[0].NodeValue))
    else
      Result := DefaultValue;

  except
    on E: Exception do
      Result := DefaultValue;
  end;
end;

{ =============================================================================== }

function TXMLSetting.GetValue(const ValueName: UTF8String; DefaultValue: string): string;
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
    on E: Exception do
      Result := DefaultValue;
  end;
end;

{ =============================================================================== }
{$HINTS Off}

function TXMLSetting.LoadXMLData(): Boolean;
var
  SettingFileName: string;
begin
  Result := false;
  {$IFNDEF SpellCheckerDll}
  SettingFileName := 'Spell Settings.xml';
  {$ELSE}
  SettingFileName := 'Spell dll Settings.xml';
  {$ENDIF}
  try
    if FileExists(ExtractFilePath(Application.ExeName) + SettingFileName) = true then
    begin
      XML.LoadFromFile(ExtractFilePath(Application.ExeName) + SettingFileName);
      Result := true;
    end
    else
      Result := false;
  except
    on E: Exception do
      Result := false;
  end;
end;

{$HINTS On}
{ =============================================================================== }

procedure TXMLSetting.SaveXMLData;
var
  SettingFileName: string;
begin
  // XML.XmlFormat := xfReadable;
  {$IFNDEF SpellCheckerDll}
  SettingFileName := 'Spell Settings.xml';
  {$ELSE}
  SettingFileName := 'Spell dll Settings.xml';
  {$ENDIF}
  XML.XML.Text := XMLDoc.FormatXMLData(XML.XML.Text);
  XML.Active := true;
  try
    XML.SaveToFile(GetAvroDataDir + SettingFileName);
  except
    on E: Exception do
    begin
      // Nothing
    end;
  end;
end;

{ =============================================================================== }

procedure TXMLSetting.SetValue(const ValueName: UTF8String; const ValueData: TDateTime);
var
  CdataChild: IXMLNode;
begin
  child := XML.DocumentElement.AddChild(ValueName);
  CdataChild := XML.CreateNode(DateTimeToStr(ValueData), ntCDATA);
  XML.DocumentElement.ChildNodes.Nodes[ValueName].ChildNodes.Add(CdataChild);

end;

{ =============================================================================== }

procedure TXMLSetting.SetValue(const ValueName: UTF8String; const ValueData: string);
var
  CdataChild: IXMLNode;
begin

  child := XML.DocumentElement.AddChild(ValueName);
  CdataChild := XML.CreateNode(ValueData, ntCDATA);
  XML.DocumentElement.ChildNodes.Nodes[ValueName].ChildNodes.Add(CdataChild);

end;

{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }

{ TMyRegistry }

{ =============================================================================== }

function TMyRegistry.ReadDateDef(const Name: string; DefaultVal: TDateTime): TDateTime;
begin
  try
    if ValueExists(name) = true then
    begin
      Result := ReadDateTime(name);
    end
    else
    begin
      Result := DefaultVal;
    end;
  except
    on E: Exception do
      Result := DefaultVal;
  end;
end;

{ =============================================================================== }

function TMyRegistry.ReadStringDef(const Name: string; DefaultVal: string = ''): string;
begin
  try
    if ValueExists(name) = true then
    begin
      Result := ReadString(name);
    end
    else
    begin
      Result := DefaultVal;
    end;
  except
    on E: Exception do
      if Trim(Result) = '' then
        Result := DefaultVal;
  end;
end;

end.
