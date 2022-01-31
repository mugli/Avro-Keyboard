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

{$INCLUDE ../../ProjectDefines.inc}
{ COMPLETE TRANSFERING! }

Unit clsRegistry_XMLSetting;

Interface

Uses
  classes,
  sysutils,
  StrUtils,
  XmlDoc, XmlIntf,
  Forms,
  Registry,
  uFileFolderHandling;

// Custom Registry class
Type
  TMyRegistry = Class(TRegistry)
  Public
    Function ReadStringDef(Const Name: String; DefaultVal: String = ''): String;
    Function ReadDateDef(Const Name: String; DefaultVal: TDateTime): TDateTime;
  End;

  // Skeleton of Class TXMLSetting
Type
  TXMLSetting = Class
  Private
    XML: IXMLDocument;
    child: IXmlNode;

  Public
    Constructor Create; // Initializer
    Destructor Destroy; Override; // Destructor

    Function LoadXMLData(): Boolean;
    Function GetValue(Const ValueName: UTF8String; DefaultValue: String = '')
      : String; Overload;
    Function GetValue(Const ValueName: UTF8String; DefaultValue: TDateTime)
      : TDateTime; Overload;
    Procedure CreateNewXMLData;
    Procedure SetValue(Const ValueName: UTF8String;
      Const ValueData: String); Overload;
    Procedure SetValue(Const ValueName: UTF8String;
      Const ValueData: TDateTime); Overload;
    Procedure SaveXMLData;

  End;

Implementation

{ =============================================================================== }

{ TXMLSetting }

Constructor TXMLSetting.Create;
Begin
  Inherited;

  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  XML.Encoding := 'UTF-8';

End;

{ =============================================================================== }

Procedure TXMLSetting.CreateNewXMLData;
Begin
  if XML <> nil then
  begin
    XML.Active := false;
    XML := nil;
  end;

  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  XML.Encoding := 'UTF-8';

  XML.addChild('Settings');
End;

{ =============================================================================== }

Destructor TXMLSetting.Destroy;
Begin
  XML.Active := false;
  XML := nil;
  Inherited;
End;

{ =============================================================================== }

Function TXMLSetting.GetValue(Const ValueName: UTF8String;
  DefaultValue: TDateTime): TDateTime;
Begin
  Try
    child := XML.documentElement.ChildNodes.FindNode(ValueName);
    Result := child.ChildNodes.Nodes[0].NodeValue;
  Except
    On E: Exception Do
      Result := DefaultValue;
  End;
End;

{ =============================================================================== }

Function TXMLSetting.GetValue(Const ValueName: UTF8String;
  DefaultValue: String): String;
Begin
  Try
    child := XML.documentElement.ChildNodes.FindNode(ValueName);
    If Length(Trim(child.ChildNodes.Nodes[0].NodeValue)) <= 0 Then
      Result := DefaultValue
    Else
      Result := Trim(child.ChildNodes.Nodes[0].NodeValue);
  Except
    On E: Exception Do
      Result := DefaultValue;
  End;
End;

{ =============================================================================== }
{$HINTS Off}

Function TXMLSetting.LoadXMLData(): Boolean;
Var
  SettingFileName: String;
Begin
  Result := false;
{$IFNDEF SpellCheckerDll}
  SettingFileName := 'Spell Settings.xml';
{$ELSE}
  SettingFileName := 'Spell dll Settings.xml';
{$ENDIF}
  Try
    If FileExists(GetAvroDataDir + SettingFileName) = true Then
    Begin
      XML.LoadFromFile(GetAvroDataDir + SettingFileName);
      Result := true;
    End
    Else
      Result := false;
  Except
    On E: Exception Do
      Result := false;
  End;
End;
{$HINTS On}
{ =============================================================================== }

Procedure TXMLSetting.SaveXMLData;
Var
  SettingFileName: String;
Begin
  // XML.XmlFormat := xfReadable;
{$IFNDEF SpellCheckerDll}
  SettingFileName := 'Spell Settings.xml';
{$ELSE}
  SettingFileName := 'Spell dll Settings.xml';
{$ENDIF}
  Try
    XML.SaveToFile(GetAvroDataDir + SettingFileName);
  Except
    On E: Exception Do
    Begin
      // Nothing
    End;
  End;
End;

{ =============================================================================== }

Procedure TXMLSetting.SetValue(Const ValueName: UTF8String;
  Const ValueData: TDateTime);
Var
  CdataChild: IXmlNode;
Begin
  child := XML.documentElement.addChild(ValueName);
  CdataChild := XML.CreateNode(DateTimeToStr(ValueData), ntCDATA);
  XML.documentElement.ChildNodes.Nodes[ValueName].ChildNodes.Add(CdataChild);
End;

{ =============================================================================== }

Procedure TXMLSetting.SetValue(Const ValueName: UTF8String;
  Const ValueData: String);
Var
  CdataChild: IXmlNode;
Begin

  child := XML.documentElement.addChild(ValueName);
  CdataChild := XML.CreateNode(ValueData, ntCDATA);
  XML.documentElement.ChildNodes.Nodes[ValueName].ChildNodes.Add(CdataChild);
End;

{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }

{ TMyRegistry }

{ =============================================================================== }

Function TMyRegistry.ReadDateDef(Const Name: String; DefaultVal: TDateTime)
  : TDateTime;
Begin
  Try
    If ValueExists(Name) = true Then
    Begin
      Result := ReadDateTime(Name);
    End
    Else
    Begin
      Result := DefaultVal;
    End;
  Except
    On E: Exception Do
      Result := DefaultVal;
  End;
End;

{ =============================================================================== }

Function TMyRegistry.ReadStringDef(Const Name: String;
  DefaultVal: String = ''): String;
Begin
  Try
    If ValueExists(Name) = true Then
    Begin
      Result := ReadString(Name);
    End
    Else
    Begin
      Result := DefaultVal;
    End;
  Except
    On E: Exception Do
      If Trim(Result) = '' Then
        Result := DefaultVal;
  End;
End;

End.
