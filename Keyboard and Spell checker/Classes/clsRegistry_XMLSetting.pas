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

{$IFDEF SpellChecker}
{$INCLUDE ../../ProjectDefines.inc}
{$ELSE}
{$INCLUDE ../ProjectDefines.inc}
{$ENDIF}

{COMPLETE TRANSFERING!}


Unit clsRegistry_XMLSetting;

Interface

Uses
     classes,
     sysutils,
     StrUtils,
     NativeXML,
     Forms,
     Registry,
     uFileFolderHandling;

//Custom Registry class
Type
     TMyRegistry = Class(TRegistry)
     Public
          Function ReadStringDef(Const Name: String; DefaultVal: String = ''): String;
          Function ReadDateDef(Const Name: String; DefaultVal: TDateTime): TDateTime;
     End;

     //Skeleton of Class TXMLSetting
Type
     TXMLSetting = Class
     Private
          XML: TNativeXml;
          child: TXmlNode;

     Public
          Constructor Create;           //Initializer
          Destructor Destroy; Override; //Destructor

          Function LoadXMLData(): Boolean;
          Function GetValue(Const ValueName: String; DefaultValue: String = ''): String; Overload;
          Function GetValue(Const ValueName: String; DefaultValue: TDateTime): TDateTime; Overload;
          Procedure CreateNewXMLData;
          Procedure SetValue(Const ValueName: String; Const ValueData: String); Overload;
          Procedure SetValue(Const ValueName: String; Const ValueData: TDateTime); Overload;
          Procedure SaveXMLData;

     End;



Implementation

{===============================================================================}

{ TXMLSetting }

Constructor TXMLSetting.Create;
Begin
     Inherited;

     XML := TNativeXml.Create;
     XML.ExternalEncoding := seUTF8;

End;

{===============================================================================}

Procedure TXMLSetting.CreateNewXMLData;
Begin
     Xml.Free;
     XML := TNativeXml.Create;
     XML.EncodingString := 'UTF-8';
     XML.ExternalEncoding := seUTF8;
     XML.Root.Name := 'Settings';     
End;

{===============================================================================}

Destructor TXMLSetting.Destroy;
Begin
     FreeAndNil(XML);
     Inherited;
End;

{===============================================================================}

Function TXMLSetting.GetValue(Const ValueName: String;
     DefaultValue: TDateTime): TDateTime;
Begin
     Try
          Child := Xml.Root.FindNode(ValueName);
          Result := Child.Nodes[0].ValueAsDateTimeDef(DefaultValue);
     Except
          On E: Exception Do
               Result := DefaultValue;
     End;
End;

{===============================================================================}

Function TXMLSetting.GetValue(Const ValueName: String;
     DefaultValue: String): String;
Begin
     Try
          Child := Xml.Root.FindNode(ValueName);
          If Length(Trim(Child.Nodes[0].ValueAsString)) <= 0 Then
               Result := DefaultValue
          Else
               Result := Trim(Child.Nodes[0].ValueAsString);
     Except
          On E: Exception Do
               Result := DefaultValue;
     End;
End;

{===============================================================================}
{$HINTS Off}

Function TXMLSetting.LoadXMLData(): Boolean;
Begin
     Result := False;
     Try
          If FileExists(ExtractFilePath(Application.ExeName) + 'Settings.xml') = True Then Begin
               XML.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Settings.xml');
               Result := True;
          End
          Else
               Result := False;
     Except
          On E: Exception Do
               Result := False;
     End;
End;
{$HINTS On}
{===============================================================================}

Procedure TXMLSetting.SaveXMLData;
Begin
     XML.XmlFormat := xfReadable;
     Try
          Xml.SaveToFile(GetAvroDataDir + 'Settings.xml');
     Except
          On E: Exception Do Begin
               //Nothing
          End;
     End;
End;

{===============================================================================}

Procedure TXMLSetting.SetValue(Const ValueName: String;
     Const ValueData: TDateTime);
Var
     CdataChild               : TXmlNode;
Begin
     Child := XML.Root.NodeNew(ValueName);
     CdataChild := Child.NodeNew(ValueName);
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsDateTime := ValueData;
End;

{===============================================================================}

Procedure TXMLSetting.SetValue(Const ValueName, ValueData: String);
Var
     CdataChild               : TXmlNode;
Begin
     Child := XML.Root.NodeNew(ValueName);
     CdataChild := Child.NodeNew(ValueName);
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsString := ValueData;
End;

{===============================================================================}
{===============================================================================}
{===============================================================================}

{ TMyRegistry }

{===============================================================================}

Function TMyRegistry.ReadDateDef(Const Name: String;
     DefaultVal: TDateTime): TDateTime;
Begin
     Try
          If ValueExists(Name) = True Then Begin
               Result := ReadDateTime(Name);
          End
          Else Begin
               Result := DefaultVal;
          End;
     Except
          On E: Exception Do
               Result := DefaultVal;
     End;
End;

{===============================================================================}

Function TMyRegistry.ReadStringDef(Const Name: String;
     DefaultVal: String = ''): String;
Begin
     Try
          If ValueExists(Name) = True Then Begin
               Result := ReadString(Name);
          End
          Else Begin
               Result := DefaultVal;
          End;
     Except
          On E: Exception Do
               If Trim(Result) = '' Then
                    Result := DefaultVal;
     End;
End;

End.

