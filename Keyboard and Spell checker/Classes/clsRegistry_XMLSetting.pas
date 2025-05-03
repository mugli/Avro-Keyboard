{
  =============================================================================
  *****************************************************************************
  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  https://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is Avro Keyboard 5.

  The Initial Developer of the Original Code is
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}
{$IFDEF SpellChecker}
{$INCLUDE ../../ProjectDefines.inc}
{$ELSE}
{$INCLUDE ../ProjectDefines.inc}
{$ENDIF}
{ COMPLETE TRANSFERING! }

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
  dialogs,
  system.Variants,
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
    child: IXMLNode;

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
  XML.AddChild('Settings');

End;

{ =============================================================================== }

Procedure TXMLSetting.CreateNewXMLData;
Begin

  if XML <> nil then
    XML := nil;

  XML := TXMLDocument.Create(nil);
  XML.Active := true;

  XML.Encoding := 'UTF-8';
  XML.AddChild('Settings');
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
    child := XML.DocumentElement.ChildNodes.FindNode(ValueName);
    if assigned(child) then
      Result := VarToDateTime((child.ChildNodes.Nodes[0].NodeValue))
    else
      Result := DefaultValue;

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

    child := XML.DocumentElement.ChildNodes.FindNode(ValueName);

    if assigned(child) then
    begin
      If Length(Trim(child.ChildNodes.Nodes[0].NodeValue)) <= 0 Then
        Result := DefaultValue
      Else
        Result := VarToStr(Trim(child.ChildNodes.Nodes[0].NodeValue));
    end
    else
      Result := DefaultValue
  Except
    On E: Exception Do
      Result := DefaultValue;
  End;
End;

{ =============================================================================== }
{$HINTS Off}

Function TXMLSetting.LoadXMLData(): Boolean;
Begin
  Result := false;
  Try
    If FileExists(ExtractFilePath(Application.ExeName) + 'Settings.xml')
      = true Then
    Begin
      XML.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Settings.xml');
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
Begin
  // XML.XmlFormat := xfReadable;

  XML.XML.Text := XMLDoc.FormatXMLData(XML.XML.Text);
  XML.Active := true;
  Try
    XML.SaveToFile(GetAvroDataDir + 'Settings.xml');
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
  CdataChild: IXMLNode;
Begin
  child := XML.DocumentElement.AddChild(ValueName);
  CdataChild := XML.CreateNode(DateTimeToStr(ValueData), ntCDATA);
  XML.DocumentElement.ChildNodes.Nodes[ValueName].ChildNodes.Add(CdataChild);

End;

{ =============================================================================== }

Procedure TXMLSetting.SetValue(Const ValueName: UTF8String;
  const ValueData: String);
Var
  CdataChild: IXMLNode;
Begin

  child := XML.DocumentElement.AddChild(ValueName);
  CdataChild := XML.CreateNode(ValueData, ntCDATA);
  XML.DocumentElement.ChildNodes.Nodes[ValueName].ChildNodes.Add(CdataChild);

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
