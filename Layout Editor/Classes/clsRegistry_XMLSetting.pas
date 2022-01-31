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
{ COMPLETE TRANSFERING! }

Unit clsRegistry_XMLSetting;

Interface

Uses
  classes,
  sysutils,
  StrUtils,
  // NativeXML,
  Forms,
  Registry,
  XMLIntf, XMLDoc,
  uFileFolderHandling;

// Custom Registry class
Type
  TMyRegistry = Class(TRegistry)
  Public
    Function ReadStringDef(Const Name: String; DefaultVal: String = ''): String;
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
    Function GetValue(Const ValueName: UTF8String;
      DefaultValue: String = ''): String;
    Procedure CreateNewXMLData;
    Procedure SetValue(Const ValueName: UTF8String; Const ValueData: String);
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
  DefaultValue: String): String;
Begin
  Try
    child := XML.DocumentElement.childnodes.FindNode(ValueName);

    if assigned(child) then
    begin

      If Length(Trim(child.childnodes.Nodes[0].nodevalue)) <= 0 Then
        Result := DefaultValue
      Else
        Result := Trim(child.childnodes.Nodes[0].nodevalue);
    end
    else
      Result := DefaultValue
  Except
    On E: Exception Do
      Result := DefaultValue;
  End;
End;

{ =============================================================================== }

Function TXMLSetting.LoadXMLData(): Boolean;
Begin
  Try
    If FileExists(ExtractFilePath(Application.ExeName) +
      'Layout Editor Settings.xml') = true Then
    Begin
      XML.LoadFromFile(ExtractFilePath(Application.ExeName) +
        'Layout Editor Settings.xml');
      Result := true;
    End
    Else
      Result := false;
  Except
    On E: Exception Do
      Result := false;
  End;
End;

{ =============================================================================== }

Procedure TXMLSetting.SaveXMLData;
Begin
  XML.XML.Text := XMLDoc.FormatXMLData(XML.XML.Text);
  XML.Active := true;
  Try
    XML.SaveToFile(GetAvroDataDir + 'Layout Editor Settings.xml');
  Except
    On E: Exception Do
    Begin
      // Nothing
    End;
  End;
End;

{ =============================================================================== }

Procedure TXMLSetting.SetValue(Const ValueName: UTF8String;
  const ValueData: String);
Var
  CdataChild: IXmlNode;
Begin
  child := XML.DocumentElement.AddChild(ValueName);

  CdataChild := XML.CreateNode(ValueName, ntCDATA);
  CdataChild.nodevalue := ValueData;
  child.childnodes.Add(CdataChild);

End;

{ =============================================================================== }
{ =============================================================================== }
{ =============================================================================== }

{ TMyRegistry }

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
