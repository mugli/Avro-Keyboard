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

Unit uFrmMain;

Interface

Uses
     Windows,
     Messages,
     SysUtils,
     Variants,
     Classes,
     Graphics,
     Controls,
     Forms,
     Dialogs,
     ToolWin,
     ComCtrls,
     StdCtrls,
     ExtCtrls,
     GIFImg,
     jpeg,
     ExtDlgs,
     StrUtils,
     uShapeInterceptor,
     nativeXML,
     ImgList {Always must be the last};

Type
     TfrmMain = Class(TForm)
          ToolBar1: TToolBar;
          ToolButton5: TToolButton;
          butNew: TToolButton;
          butOpen: TToolButton;
          butFont: TToolButton;
          butHelp: TToolButton;
          butAbout: TToolButton;
          Panel1: TPanel;
          Image1: TImage;
          GroupBox1: TGroupBox;
          GroupBox2: TGroupBox;
          Label1: TLabel;
          txtLayoutName: TEdit;
          ToolButton12: TToolButton;
          ToolButton13: TToolButton;
          ToolButton14: TToolButton;
          ToolButton15: TToolButton;
          txtVersion: TEdit;
          Label2: TLabel;
          txtDeveloper: TEdit;
          Label3: TLabel;
          Label4: TLabel;
          txtComment: TMemo;
          txtImageAltGrShift: TEdit;
          txtImageNormalShift: TEdit;
          Label5: TLabel;
          Label6: TLabel;
          butImageAltGrShift: TButton;
          butImageNormalShift: TButton;
          Label8: TLabel;
          txtNormal: TEdit;
          txtShift: TEdit;
          Label9: TLabel;
          txtShiftAltGr: TEdit;
          Label10: TLabel;
          txtAltGr: TEdit;
          Label11: TLabel;
          Image3: TImage;
          LabelShift: TLabel;
          Shape_E: TShape;
          imgNormal: TImage;
          imgShift: TImage;
          imgAltGr: TImage;
          imgShiftAltGr: TImage;
          Shape_R: TShape;
          Shape_D: TShape;
          Shape_S: TShape;
          LabelNormal: TLabel;
          Shape_F: TShape;
          Shape_C: TShape;
          Shape_X: TShape;
          Shape_V: TShape;
          Shape_G: TShape;
          Shape_T: TShape;
          Shape_Y: TShape;
          Shape_U: TShape;
          Shape_H: TShape;
          Shape_B: TShape;
          Shape_N: TShape;
          Shape_OEM2: TShape;
          Shape_PERIOD: TShape;
          Shape_COMMA: TShape;
          Shape_M: TShape;
          Shape_Z: TShape;
          Shape_J: TShape;
          Shape_K: TShape;
          Shape_L: TShape;
          Shape_OEM1: TShape;
          Shape_OEM7: TShape;
          Shape_A: TShape;
          Shape_OEM4: TShape;
          Shape_P: TShape;
          Shape_O: TShape;
          Shape_I: TShape;
          Shape_W: TShape;
          Shape_Q: TShape;
          Shape_OEM5: TShape;
          Shape_OEM6: TShape;
          Shape_OEM3: TShape;
          Shape_1: TShape;
          Shape_2: TShape;
          Shape_3: TShape;
          Shape_4: TShape;
          Shape_5: TShape;
          Shape_6: TShape;
          Shape_7: TShape;
          Shape_8: TShape;
          Shape_9: TShape;
          Shape_0: TShape;
          Shape_MINUS: TShape;
          Shape_PLUS: TShape;
          OpenPictureDialog1: TOpenPictureDialog;
          SaveDialog1: TSaveDialog;
          FontDialog1: TFontDialog;
          OpenDialog1: TOpenDialog;
          ButSave: TToolButton;
          ButSaveAs: TToolButton;
          ToolButton3: TToolButton;
          ToolButton4: TToolButton;
          Label7: TLabel;
          Panel2: TPanel;
          Label14: TLabel;
          Label15: TLabel;
          Source: TImage;
          Procedure FormCreate(Sender: TObject);
          Procedure Shape_QMouseDown(Sender: TObject; Button: TMouseButton;
               Shift: TShiftState; X, Y: Integer);
          Procedure txtLayoutNameEnter(Sender: TObject);
          Procedure txtCommentEnter(Sender: TObject);
          Procedure txtNormalEnter(Sender: TObject);
          Procedure butNewClick(Sender: TObject);
          Procedure txtLayoutNameChange(Sender: TObject);
          Procedure txtNormalChange(Sender: TObject);
          Procedure txtShiftChange(Sender: TObject);
          Procedure txtAltGrChange(Sender: TObject);
          Procedure txtShiftAltGrChange(Sender: TObject);
          Procedure butFontClick(Sender: TObject);
          Procedure butHelpClick(Sender: TObject);
          Procedure Label15Click(Sender: TObject);
          Procedure butImageNormalShiftClick(Sender: TObject);
          Procedure butImageAltGrShiftClick(Sender: TObject);
          Procedure ButSaveAsClick(Sender: TObject);
          Procedure ButSaveClick(Sender: TObject);
          Procedure butAboutClick(Sender: TObject);
          Procedure butOpenClick(Sender: TObject);
          Procedure FormClose(Sender: TObject; Var Action: TCloseAction);


     Private
          { Private declarations }
          fDirty: Boolean;
          fSelected: TShape;
          fFileName: String;
          Procedure SetSelectedKey(ControlName: String);
          Procedure InitializeKeys;
          Procedure NewLayout;
          Procedure BuildLayout;
          Function NoErrorFound: Boolean;
     Public
          { Public declarations }
     End;

Var
     frmMain                  : TfrmMain;

Implementation

{$R *.dfm}

Uses
     uFileFolderHandling,
     uFrmAbout,
     clsSkinLayoutConverter,
     uRegistrySettings;


{===============================================================================}

Procedure TfrmMain.BuildLayout;
Const
     b_0                      : Char = #$9E6;
     b_1                      : Char = #$9E7;
     b_2                      : Char = #$9E8;
     b_3                      : Char = #$9E9;
     b_4                      : Char = #$9EA;
     b_5                      : Char = #$9EB;
     b_6                      : Char = #$9EC;
     b_7                      : Char = #$9ED;
     b_8                      : Char = #$9EE;
     b_9                      : Char = #$9EF;
Var
     XML                      : TNativeXml;
     child                    : TXmlNode;
     CdataChild               : TXmlNode;
     KeyData                  : TXmlNode;
     I                        : Integer;
     FStream                  : TFileStream;
     SStream                  : TStringStream;
Begin

     XML := TNativeXml.Create;
     XML.EncodingString := 'UTF-8';
     XML.XmlFormat := xfReadable;
     XML.ExternalEncoding := seUTF8;

     XML.Root.Name := 'Layout';

     Child := XML.Root.NodeNew('AvroKeyboardVersion');
     Child.ValueAsUnicodeString := '5';

     Child := XML.Root.NodeNew('LayoutName');
     CdataChild := Child.NodeNew('LayoutName');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := txtLayoutName.Text;

     Child := XML.Root.NodeNew('LayoutVersion');
     CdataChild := Child.NodeNew('LayoutVersion');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := txtVersion.Text;

     Child := XML.Root.NodeNew('DeveloperName');
     CdataChild := Child.NodeNew('DeveloperName');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := txtDeveloper.Text;

     Child := XML.Root.NodeNew('DeveloperComment');
     CdataChild := Child.NodeNew('DeveloperComment');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := txtComment.Text;


     Child := XML.Root.NodeNew('ImageNormalShift');
     Child.BinaryEncoding := xbeBase64;
     If FileExists(trim(txtImageNormalShift.Text)) Then Begin
          Try
               Try
                    FStream := TFileStream.Create(txtImageNormalShift.Text, fmOpenRead, fmShareDenyWrite);
                    SStream := TStringStream.Create('');
                    SStream.CopyFrom(FStream, FStream.Size);
                    Child.BinaryString := SStream.DataString;
               Except
                    On E: Exception Do Begin
                         Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    End;
               End;
          Finally
               FreeAndNil(FStream);
               FreeAndNil(SStream);
          End;
     End;




     Child := XML.Root.NodeNew('ImageAltGrShift');
     Child.BinaryEncoding := xbeBase64;
     If FileExists(trim(txtImageAltGrShift.Text)) Then Begin
          Try
               Try
                    FStream := TFileStream.Create(txtImageAltGrShift.Text, fmOpenRead, fmShareDenyWrite);
                    SStream := TStringStream.Create('');
                    SStream.CopyFrom(FStream, FStream.Size);
                    Child.BinaryString := SStream.DataString;
               Except
                    On E: Exception Do Begin
                         Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    End;
               End;
          Finally
               FStream.Free;
               SStream.Free;
          End;
     End;


     KeyData := XML.Root.NodeNew('KeyData');

     For I := 0 To ComponentCount - 1 Do Begin
          If Components[I] Is TShape Then Begin
               Child := KeyData.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_Normal'));
               CdataChild := Child.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_Normal'));
               CdataChild.ElementType := xeCData;
               CdataChild.ValueAsUnicodeString := (Components[i] As TShape).Normal;

               Child := KeyData.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_Shift'));
               CdataChild := Child.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_Shift'));
               CdataChild.ElementType := xeCData;
               CdataChild.ValueAsUnicodeString := (Components[i] As TShape).Shift;

               Child := KeyData.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_AltGr'));
               CdataChild := Child.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_AltGr'));
               CdataChild.ElementType := xeCData;
               CdataChild.ValueAsUnicodeString := (Components[i] As TShape).AltGr;

               Child := KeyData.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_ShiftAltGr'));
               CdataChild := Child.NodeNew(UTF8String('Key_' + UpperCase((Components[i] As TShape).KeyName) + '_ShiftAltGr'));
               CdataChild.ElementType := xeCData;
               CdataChild.ValueAsUnicodeString := (Components[i] As TShape).ShiftAltGr;
          End;
     End;

     Child := KeyData.NodeNew('Num1');
     CdataChild := Child.NodeNew('Num1');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_1;

     Child := KeyData.NodeNew('Num2');
     CdataChild := Child.NodeNew('Num2');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_2;

     Child := KeyData.NodeNew('Num3');
     CdataChild := Child.NodeNew('Num3');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_3;

     Child := KeyData.NodeNew('Num4');
     CdataChild := Child.NodeNew('Num4');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_4;

     Child := KeyData.NodeNew('Num5');
     CdataChild := Child.NodeNew('Num5');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_5;

     Child := KeyData.NodeNew('Num6');
     CdataChild := Child.NodeNew('Num6');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_6;

     Child := KeyData.NodeNew('Num7');
     CdataChild := Child.NodeNew('Num7');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_7;

     Child := KeyData.NodeNew('Num8');
     CdataChild := Child.NodeNew('Num8');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_8;

     Child := KeyData.NodeNew('Num9');
     CdataChild := Child.NodeNew('Num9');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_9;

     Child := KeyData.NodeNew('Num0');
     CdataChild := Child.NodeNew('Num0');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := b_0;

     Child := KeyData.NodeNew('NumAdd');
     CdataChild := Child.NodeNew('NumAdd');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := '+';

     Child := KeyData.NodeNew('NumDecimal');
     CdataChild := Child.NodeNew('NumDecimal');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := '.';

     Child := KeyData.NodeNew('NumDivide');
     CdataChild := Child.NodeNew('NumDivide');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := '/';

     Child := KeyData.NodeNew('NumMultiply');
     CdataChild := Child.NodeNew('NumMultiply');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := '*';

     Child := KeyData.NodeNew('NumSubtract');
     CdataChild := Child.NodeNew('NumSubtract');
     CdataChild.ElementType := xeCData;
     CdataChild.ValueAsUnicodeString := '-';

     Try
          Try
               Xml.SaveToFile(fFileName);
          Except
               On E: Exception Do Begin
                    Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
               End;
          End;
     Finally
          FreeAndNil(XML);
     End;

End;

{===============================================================================}

Procedure TfrmMain.butAboutClick(Sender: TObject);
Begin
     Application.CreateForm(TfrmAbout, frmAbout);

     Try
          frmAbout.ShowModal;
     Except
          On E: Exception Do Begin
               //Nothing
          End;
     End;
End;

{===============================================================================}

Procedure TfrmMain.butFontClick(Sender: TObject);
Begin
     //Initialize
     FontDialog1.Font.Name := LEFontName;
     FontDialog1.Font.Size := StrToInt(LEFontSize);

     //Open dialog
     If FontDialog1.Execute Then Begin
          txtNormal.Font := FontDialog1.Font;
          txtShift.Font := FontDialog1.Font;
          txtAltGr.Font := FontDialog1.Font;
          txtShiftAltGr.Font := FontDialog1.Font;
          LEFontName := FontDialog1.Font.Name;
          LEFontSize := IntToStr(FontDialog1.Font.Size);
     End;
End;

{===============================================================================}

Procedure TfrmMain.butHelpClick(Sender: TObject);
Begin
     If FileExists(ExtractFilePath(Application.ExeName) + 'Editing Keyboard Layout.pdf') Then
          Execute_Something(ExtractFilePath(Application.ExeName) + 'Editing Keyboard Layout.pdf')
     Else
          Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(35));
End;

{===============================================================================}

Procedure TfrmMain.butImageAltGrShiftClick(Sender: TObject);
Begin
     OpenPictureDialog1.FileName := '';
     Try
          If OpenPictureDialog1.Execute(Self.Handle) Then
               txtImageAltGrShift.Text := OpenPictureDialog1.FileName;
     Except
          On E: Exception Do Begin
               Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          End;
     End;
End;

{===============================================================================}

Procedure TfrmMain.butImageNormalShiftClick(Sender: TObject);
Begin
     OpenPictureDialog1.FileName := '';
     Try
          If OpenPictureDialog1.Execute(Self.Handle) Then
               txtImageNormalShift.Text := OpenPictureDialog1.FileName;

     Except
          On E: Exception Do Begin
               Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          End;
     End;
End;

{===============================================================================}

Procedure TfrmMain.butNewClick(Sender: TObject);
Begin
     NewLayout;
End;

{===============================================================================}

Procedure TfrmMain.butOpenClick(Sender: TObject);
Var
     XML                      : TNativeXml;
     Node                     : TXmlNode;
     I, P                     : Integer;
     KeyName, Layer, TrimLeftString: String;
     tmpShape                 : TShape;
     FStream                  : TFileStream;
     SStream                  : TStringStream;

     m_Converter              : TSkinLayoutConverter;
Begin
     Opendialog1.InitialDir := LELastDir;
     If Opendialog1.Execute(Self.Handle) = False Then
          exit;
     LELastDir := ExtractFilePath(Opendialog1.FileName);

     m_Converter := TSkinLayoutConverter.Create;
     m_Converter.CheckConvertLayout(Opendialog1.FileName);
     FreeAndNil(m_Converter);

     XML := TNativeXml.Create;
     XML.EncodingString := 'UTF-8';
     XML.XmlFormat := xfReadable;
     XML.ExternalEncoding := seUTF8;

     Try
          Try
               XML.LoadFromFile(Opendialog1.FileName);

               //----------------------------------------------
               //Check if the layout is a compatible one
               If trim(Xml.Root.FindNode('AvroKeyboardVersion').ValueAsUnicodeString) <> '5' Then Begin
                    Application.MessageBox('This Keyboard Layout is not compatible with current version of Avro Keyboard.', 'Error loading keyboard layout...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    Exit;
               End;
               //----------------------------------------------

          //Load basic informations
               txtLayoutName.Text := Xml.Root.FindNode('LayoutName').Nodes[0].ValueAsUnicodeString;
               txtDeveloper.Text := Xml.Root.FindNode('DeveloperName').Nodes[0].ValueAsUnicodeString;
               txtVersion.Text := Xml.Root.FindNode('LayoutVersion').Nodes[0].ValueAsUnicodeString;
               txtComment.Text := Xml.Root.FindNode('DeveloperComment').Nodes[0].ValueAsUnicodeString;

               //Extract images
               If Xml.Root.FindNode('ImageNormalShift') <> Nil Then Begin

                    FStream := TFileStream.Create(GetAvroDataDir + 'tmpImage_Normal_Shift.bmp', fmCreate);
                    SStream := TStringStream.Create(Xml.Root.FindNode('ImageNormalShift').BinaryString);
                    SStream.Position := 0;
                    FStream.CopyFrom(SStream, SStream.Size);
                    txtImageNormalShift.Text := GetAvroDataDir + 'tmpImage_Normal_Shift.bmp';
                    FStream.Free;
                    SStream.Free;
               End;

               If Xml.Root.FindNode('ImageAltGrShift') <> Nil Then Begin
                    FStream := TFileStream.Create(GetAvroDataDir + 'tmpImage_AltGr_Shift.bmp', fmCreate);
                    SStream := TStringStream.Create(Xml.Root.FindNode('ImageAltGrShift').BinaryString);
                    SStream.Position := 0;
                    FStream.CopyFrom(SStream, SStream.Size);
                    txtImageAltGrShift.Text := GetAvroDataDir + 'tmpImage_AltGr_Shift.bmp';
                    FStream.Free;
                    SStream.Free;
               End;



               //Load Keys
               Node := XML.Root.FindNode('KeyData');

               For I := 0 To Node.NodeCount - 1 Do Begin
                    If LowerCase(LeftStr(Node.Nodes[i].Name, 3)) <> 'num' Then Begin

                         // Structure: Key_OEM1_Normal
                         TrimLeftString := MidStr(Node.Nodes[i].Name, 5, Length(Node.Nodes[i].Name)); //OEM1_normal
                         P := Pos('_', TrimLeftString);
                         KeyName := MidStr(TrimLeftString, 1, P - 1); //OEM
                         Layer := LowerCase(MidStr(TrimLeftString, P + 1, Length(TrimLeftString))); //normal/Shift/AltGr/ShiftAltGr

                         tmpShape := FindComponent('Shape_' + KeyName) As TShape;

                         If Node.Nodes[i].NodeCount <= 0 Then Begin
                              //If item has no cdata
                              If Layer = 'normal' Then tmpShape.Normal := '';
                              If Layer = 'shift' Then tmpShape.Shift := '';
                              If Layer = 'altgr' Then tmpShape.AltGr := '';
                              If Layer = 'shiftaltgr' Then tmpShape.ShiftAltGr := '';
                         End
                         Else Begin
                              //if item has cdata
                              If Layer = 'normal' Then tmpShape.Normal := Node.Nodes[i].Nodes[0].ValueAsUnicodeString;
                              If Layer = 'shift' Then tmpShape.Shift := Node.Nodes[i].Nodes[0].ValueAsUnicodeString;
                              If Layer = 'altgr' Then tmpShape.AltGr := Node.Nodes[i].Nodes[0].ValueAsUnicodeString;
                              If Layer = 'shiftaltgr' Then tmpShape.ShiftAltGr := Node.Nodes[i].Nodes[0].ValueAsUnicodeString;
                         End;
                    End;
               End;


          Except
               On E: Exception Do Begin
                    Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
                    NewLayout;
               End;
          End;
     Finally
          FreeAndNil(XML);
     End;

     SetSelectedKey('Shape_Q');

End;

{===============================================================================}

Procedure TfrmMain.ButSaveAsClick(Sender: TObject);
Begin
     If NoErrorFound = False Then
          exit;

     Try
          Savedialog1.FileName := txtLayoutName.Text + '.avrolayout';
          If Savedialog1.Execute(self.Handle) Then Begin
               LELastDir := ExtractFilePath(Savedialog1.FileName);
               fFileName := Savedialog1.FileName;
               BuildLayout;
          End;

     Except
          On E: Exception Do Begin
               Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          End;
     End;
End;

{===============================================================================}

Procedure TfrmMain.ButSaveClick(Sender: TObject);
Begin
     If NoErrorFound = False Then
          exit;

     If fFileName = '' Then
          ButSaveAsClick(Nil)
     Else
          BuildLayout;
End;

{===============================================================================}

Procedure TfrmMain.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
     SaveSettings;

     Action := caFree;
     frmMain := Nil;
End;

{===============================================================================}

Procedure TfrmMain.FormCreate(Sender: TObject);
Begin
     InitializeKeys;
     NewLayout;
     fDirty := False;

     LoadSettings;
     Self.Top := StrToInt(LETop);
     Self.Left := StrToInt(LELeft);
     txtNormal.Font.Name := LEFontName;
     txtShift.Font.Name := LEFontName;
     txtAltGr.Font.Name := LEFontName;
     txtShiftAltGr.Font.Name := LEFontName;
     txtNormal.Font.Size := StrToInt(LEFontSize);
     txtShift.Font.Size := StrToInt(LEFontSize);
     txtAltGr.Font.Size := StrToInt(LEFontSize);
     txtShiftAltGr.Font.Size := StrToInt(LEFontSize);
End;

{===============================================================================}

Procedure TfrmMain.InitializeKeys;
Var
     I                        : Integer;
Begin
     {$REGION 'Initializing stuffs'}
     With Shape_OEM3 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '`';
          CaptionShift := '~';
     End;

     With Shape_1 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '1';
          CaptionShift := '!';
     End;

     With Shape_2 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '2';
          CaptionShift := '@';
     End;

     With Shape_3 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '3';
          CaptionShift := '#';
     End;

     With Shape_4 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '4';
          CaptionShift := '$';
     End;

     With Shape_4 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '4';
          CaptionShift := '$';
     End;

     With Shape_5 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '5';
          CaptionShift := '%';
     End;

     With Shape_6 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '6';
          CaptionShift := '^';
     End;

     With Shape_7 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '7';
          CaptionShift := '&';
     End;

     With Shape_8 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '8';
          CaptionShift := '*';
     End;

     With Shape_9 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '9';
          CaptionShift := '(';
     End;

     With Shape_0 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '0';
          CaptionShift := ')';
     End;

     With Shape_MINUS Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '-';
          CaptionShift := '_';
     End;

     With Shape_PLUS Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '=';
          CaptionShift := '+';
     End;

     With Shape_OEM4 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '[';
          CaptionShift := '{';
     End;

     With Shape_OEM6 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := ']';
          CaptionShift := '}';
     End;

     With Shape_OEM5 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '\';
          CaptionShift := '|';
     End;

     With Shape_COMMA Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := ',';
          CaptionShift := '<';
     End;

     With Shape_PERIOD Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '.';
          CaptionShift := '>';
     End;

     With Shape_OEM2 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := '/';
          CaptionShift := '?';
     End;

     With Shape_OEM1 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := ';';
          CaptionShift := ':';
     End;

     With Shape_OEM7 Do Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := #39;
          CaptionShift := '"';
     End;

     /////////////// Initialize alphabet keys
     For I := 0 To ComponentCount - 1 Do Begin
          If Components[I] Is TShape Then Begin
               If (Components[i] As TShape).KeyName = '' Then Begin
                    With (Components[i] As TShape) Do Begin
                         KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
                         CaptionNormal := LowerCase(KeyName);
                         CaptionShift := UpperCase(CaptionNormal);
                    End;
               End;
          End;
     End;
     {$ENDREGION}

End;

{===============================================================================}

Procedure TfrmMain.Label15Click(Sender: TObject);
Begin
     Execute_Something('http://www.omicronlab.com/go.php?id=5');
End;

{===============================================================================}

Procedure TfrmMain.NewLayout;
Var
     retVal                   : Integer;
Begin
     If fDirty Then Begin
          retVal := Application.MessageBox('Save changes to the current keyboard layout?', 'Layout Editor', MB_YESNOCANCEL + +MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
          If retVal = ID_YES Then Begin
               If NoErrorFound = True Then
                    ButSaveClick(Nil)
               Else
                    exit;
          End
          Else If retVal = ID_CANCEL Then
               exit;
     End;

     txtLayoutName.Text := '[My Layout]';
     txtVersion.Text := '1';
     txtDeveloper.Text := 'Your Name';
     txtComment.Text := 'Some Comments';
     txtImageNormalShift.Text := '';
     txtImageAltGrShift.Text := '';

     txtNormal.Text := '';
     txtShift.Text := '';
     txtAltGr.Text := '';
     txtShiftAltGr.Text := '';

     SetSelectedKey('Shape_Q');

     fFileName := '';
     fDirty := False;
End;

{===============================================================================}

Function TfrmMain.NoErrorFound: Boolean;
Begin
     result := False;
     If (Trim(txtLayoutName.Text) = '') Or (Trim(txtLayoutName.Text) = '[My Layout]') Then Begin
          Application.MessageBox('Please give a name to your layout first.', 'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          txtLayoutName.SetFocus;
          txtLayoutName.SelectAll;
          exit;
     End;
     If trim(txtImageNormalShift.Text) = '' Then Begin
          Application.MessageBox('Please add bitmap images for Layout Viewer of Avro Keyboard before building keyboard layout.', 'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          exit;
     End;
     If trim(txtImageAltGrShift.Text) = '' Then Begin
          Application.MessageBox('Please add bitmap images for Layout Viewer of Avro Keyboard before building keyboard layout.', 'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          exit;
     End;
     result := True;
End;

{===============================================================================}

Procedure TfrmMain.SetSelectedKey(ControlName: String);
Var
     I                        : Integer;
Begin

     For I := 0 To ComponentCount - 1 Do Begin
          If Components[I] Is TShape Then Begin
               If UpperCase((Components[i] As TShape).Name) = UpperCase(ControlName) Then Begin
                    (Components[i] As TShape).Selected := True;
                    fSelected := Components[i] As TShape;

                    If (Components[i] As TShape).CaptionShift <> '&' Then
                         LabelShift.Caption := (Components[i] As TShape).CaptionShift
                    Else
                         LabelShift.Caption := '&&';

                    LabelNormal.Caption := (Components[i] As TShape).CaptionNormal;

                    txtNormal.Text := (Components[i] As TShape).Normal;
                    txtShift.Text := (Components[i] As TShape).Shift;
                    txtAltGr.Text := (Components[i] As TShape).AltGr;
                    txtShiftAltGr.Text := (Components[i] As TShape).ShiftAltGr;

               End
               Else
                    (Components[i] As TShape).Selected := False;
          End;
     End;
End;

{===============================================================================}

Procedure TfrmMain.Shape_QMouseDown(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
Begin
     SetSelectedKey((Sender As TShape).Name);
End;

{===============================================================================}

Procedure TfrmMain.txtAltGrChange(Sender: TObject);
Begin
     fSelected.AltGr := txtAltGr.Text;
     If txtAltGr.Text = '' Then
          imgAltGr.Visible := True
     Else
          imgAltGr.Visible := False;

     fDirty := True;
End;

{===============================================================================}

Procedure TfrmMain.txtCommentEnter(Sender: TObject);
Begin
     txtComment.SelectAll;
End;

{===============================================================================}

Procedure TfrmMain.txtLayoutNameChange(Sender: TObject);
Begin
     fDirty := True;
End;

{===============================================================================}

Procedure TfrmMain.txtLayoutNameEnter(Sender: TObject);
Begin
     (Sender As TEdit).SelectAll;
End;

{===============================================================================}

Procedure TfrmMain.txtNormalChange(Sender: TObject);
Begin
     fSelected.Normal := txtNormal.Text;
     If txtNormal.Text = '' Then
          imgNormal.Visible := True
     Else
          imgNormal.Visible := False;

     fDirty := True;
End;

{===============================================================================}

Procedure TfrmMain.txtNormalEnter(Sender: TObject);
Begin
     (Sender As TEdit).SelectAll;
End;

{===============================================================================}

Procedure TfrmMain.txtShiftAltGrChange(Sender: TObject);
Begin
     fSelected.ShiftAltGr := txtShiftAltGr.Text;
     If txtShiftAltGr.Text = '' Then
          imgShiftAltGr.Visible := True
     Else
          imgShiftAltGr.Visible := False;

     fDirty := True;

End;

{===============================================================================}

Procedure TfrmMain.txtShiftChange(Sender: TObject);
Begin
     fSelected.Shift := txtShift.Text;
     If txtShift.Text = '' Then
          imgShift.Visible := True
     Else
          imgShift.Visible := False;

     fDirty := True;

End;

{===============================================================================}

End.

