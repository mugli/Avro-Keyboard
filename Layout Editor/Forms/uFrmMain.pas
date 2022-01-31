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
  XMLIntf, XMLDoc,
  Soap.EncdDecd,
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
  frmMain: TfrmMain;

Implementation

{$R *.dfm}

Uses
  uFileFolderHandling,
  uFrmAbout,
  clsSkinLayoutConverter,
  uRegistrySettings;

{ =============================================================================== }

Procedure TfrmMain.BuildLayout;
Const
  b_0: Char = #$9E6;
  b_1: Char = #$9E7;
  b_2: Char = #$9E8;
  b_3: Char = #$9E9;
  b_4: Char = #$9EA;
  b_5: Char = #$9EB;
  b_6: Char = #$9EC;
  b_7: Char = #$9ED;
  b_8: Char = #$9EE;
  b_9: Char = #$9EF;
Var
  XML: IXMLDocument;
  child: IXmlNode;
  CdataChild: IXmlNode;
  KeyData: IXmlNode;
  I: Integer;
  FStream: TFileStream;
  SStream: TStringStream;
Begin

  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  XML.Encoding := 'UTF-8';

  XML.Addchild('Layout');

  child := XML.DocumentElement.Addchild('AvroKeyboardVersion');
  child.nodevalue := '5';

  child := XML.DocumentElement.Addchild('LayoutName');
  CdataChild := XML.CreateNode(txtLayoutName.Text, ntCDATA);
  XML.DocumentElement.ChildNodes.nodes['LayoutName'].ChildNodes.Add(CdataChild);

  child := XML.DocumentElement.Addchild('LayoutVersion');
  CdataChild := XML.CreateNode(txtVersion.Text, ntCDATA);
  XML.DocumentElement.ChildNodes.nodes['LayoutVersion'].ChildNodes.Add
    (CdataChild);

  child := XML.DocumentElement.Addchild('DeveloperName');
  CdataChild := XML.CreateNode(txtDeveloper.Text, ntCDATA);
  XML.DocumentElement.ChildNodes.nodes['DeveloperName'].ChildNodes.Add
    (CdataChild);

  child := XML.DocumentElement.Addchild('DeveloperComment');
  CdataChild := XML.CreateNode(txtComment.Text, ntCDATA);
  XML.DocumentElement.ChildNodes.nodes['DeveloperComment'].ChildNodes.Add
    (CdataChild);

  child := XML.DocumentElement.Addchild('ImageNormalShift');
  // child.BinaryEncoding := xbeBase64;
  If FileExists(trim(txtImageNormalShift.Text)) Then
  Begin
    Try
      Try
        FStream := TFileStream.Create(txtImageNormalShift.Text, fmOpenRead,
          fmShareDenyWrite);
        SStream := TStringStream.Create('');
        SStream.CopyFrom(FStream, FStream.Size);
        child.nodevalue := EncodeBase64(Pchar(SStream.DataString),
          Length(SStream.DataString));
      Except
        On E: Exception Do
        Begin
          Application.MessageBox
            (Pchar('Error occured!' + #10 + #10 + E.Message),
            Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
            MB_APPLMODAL);
        End;
      End;
    Finally
      FreeAndNil(FStream);
      FreeAndNil(SStream);
    End;
  End;

  child := XML.DocumentElement.Addchild('ImageAltGrShift');
  // child.BinaryEncoding := xbeBase64;
  If FileExists(trim(txtImageAltGrShift.Text)) Then
  Begin
    Try
      Try
        FStream := TFileStream.Create(txtImageAltGrShift.Text, fmOpenRead,
          fmShareDenyWrite);
        SStream := TStringStream.Create('');
        SStream.CopyFrom(FStream, FStream.Size);
        child.nodevalue := EncodeBase64(Pchar(SStream.DataString),
          Length(SStream.DataString));
      Except
        On E: Exception Do
        Begin
          Application.MessageBox
            (Pchar('Error occured!' + #10 + #10 + E.Message),
            Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
            MB_APPLMODAL);
        End;
      End;
    Finally
      FStream.Free;
      SStream.Free;
    End;
  End;

  KeyData := XML.DocumentElement.Addchild('KeyData');

  For I := 0 To ComponentCount - 1 Do
  Begin
    If Components[I] Is TShape Then
    Begin

      child := KeyData.Addchild
        (UTF8String('Key_' + UpperCase((Components[I] As TShape).KeyName) +
        '_Normal'));
      CdataChild := XML.CreateNode((Components[I] As TShape).Normal, ntCDATA);
      KeyData.ChildNodes.nodes
        [('Key_' + UpperCase((Components[I] As TShape).KeyName) + '_Normal')
        ].ChildNodes.Add(CdataChild);

      child := KeyData.Addchild
        (UTF8String('Key_' + UpperCase((Components[I] As TShape).KeyName) +
        '_Shift'));
      CdataChild := XML.CreateNode((Components[I] As TShape).Shift, ntCDATA);
      KeyData.ChildNodes.nodes
        [('Key_' + UpperCase((Components[I] As TShape).KeyName) + '_Shift')
        ].ChildNodes.Add(CdataChild);

      child := KeyData.Addchild
        (UTF8String('Key_' + UpperCase((Components[I] As TShape).KeyName) +
        '_AltGr'));
      CdataChild := XML.CreateNode((Components[I] As TShape).AltGr, ntCDATA);
      KeyData.ChildNodes.nodes
        [('Key_' + UpperCase((Components[I] As TShape).KeyName) + '_AltGr')
        ].ChildNodes.Add(CdataChild);

      child := KeyData.Addchild
        (UTF8String('Key_' + UpperCase((Components[I] As TShape).KeyName) +
        '_ShiftAltGr'));
      CdataChild := XML.CreateNode((Components[I] As TShape)
        .ShiftAltGr, ntCDATA);
      KeyData.ChildNodes.nodes
        [('Key_' + UpperCase((Components[I] As TShape).KeyName) + '_ShiftAltGr')
        ].ChildNodes.Add(CdataChild);

    End;
  End;

  child := KeyData.Addchild('Num1');
  CdataChild := XML.CreateNode(b_1, ntCDATA);
  KeyData.ChildNodes.nodes['Num1'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num2');
  CdataChild := XML.CreateNode(b_2, ntCDATA);
  KeyData.ChildNodes.nodes['Num2'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num3');
  CdataChild := XML.CreateNode(b_3, ntCDATA);
  KeyData.ChildNodes.nodes['Num3'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num4');
  CdataChild := XML.CreateNode(b_4, ntCDATA);
  KeyData.ChildNodes.nodes['Num4'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num5');
  CdataChild := XML.CreateNode(b_5, ntCDATA);
  KeyData.ChildNodes.nodes['Num5'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num6');
  CdataChild := XML.CreateNode(b_6, ntCDATA);
  KeyData.ChildNodes.nodes['Num6'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num7');
  CdataChild := XML.CreateNode(b_7, ntCDATA);
  KeyData.ChildNodes.nodes['Num7'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num8');
  CdataChild := XML.CreateNode(b_8, ntCDATA);
  KeyData.ChildNodes.nodes['Num8'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num9');
  CdataChild := XML.CreateNode(b_9, ntCDATA);
  KeyData.ChildNodes.nodes['Num9'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('Num0');
  CdataChild := XML.CreateNode(b_0, ntCDATA);
  KeyData.ChildNodes.nodes['Num0'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('NumAdd');
  CdataChild := XML.CreateNode('+', ntCDATA);
  KeyData.ChildNodes.nodes['NumAdd'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('NumDecimal');
  CdataChild := XML.CreateNode('.', ntCDATA);
  KeyData.ChildNodes.nodes['NumDecimal'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('NumDivide');
  CdataChild := XML.CreateNode('/', ntCDATA);
  KeyData.ChildNodes.nodes['NumDivide'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('NumMultiply');
  CdataChild := XML.CreateNode('*', ntCDATA);
  KeyData.ChildNodes.nodes['NumMultiply'].ChildNodes.Add(CdataChild);

  child := KeyData.Addchild('NumSubtract');
  CdataChild := XML.CreateNode('-', ntCDATA);
  KeyData.ChildNodes.nodes['NumSubtract'].ChildNodes.Add(CdataChild);

  Try
    Try
      XML.SaveToFile(fFileName);
    Except
      On E: Exception Do
      Begin
        Application.MessageBox(Pchar('Error occured!' + #10 + #10 + E.Message),
          Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
          MB_APPLMODAL);
      End;
    End;
  Finally

    XML.Active := false;
    XML := nil;
  End;

End;

{ =============================================================================== }

Procedure TfrmMain.butAboutClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmAbout, frmAbout);

  Try
    frmAbout.ShowModal;
  Except
    On E: Exception Do
    Begin
      // Nothing
    End;
  End;
End;

{ =============================================================================== }

Procedure TfrmMain.butFontClick(Sender: TObject);
Begin
  // Initialize
  FontDialog1.Font.Name := LEFontName;
  FontDialog1.Font.Size := StrToInt(LEFontSize);

  // Open dialog
  If FontDialog1.Execute Then
  Begin
    txtNormal.Font := FontDialog1.Font;
    txtShift.Font := FontDialog1.Font;
    txtAltGr.Font := FontDialog1.Font;
    txtShiftAltGr.Font := FontDialog1.Font;
    LEFontName := FontDialog1.Font.Name;
    LEFontSize := IntToStr(FontDialog1.Font.Size);
  End;
End;

{ =============================================================================== }

Procedure TfrmMain.butHelpClick(Sender: TObject);
Begin
  If FileExists(ExtractFilePath(Application.ExeName) +
    'Editing Keyboard Layout.pdf') Then
    Execute_Something(ExtractFilePath(Application.ExeName) +
      'Editing Keyboard Layout.pdf')
  Else
    Execute_Something('http://www.omicronlab.com/go.php?id=' + IntToStr(35));
End;

{ =============================================================================== }

Procedure TfrmMain.butImageAltGrShiftClick(Sender: TObject);
Begin
  OpenPictureDialog1.FileName := '';
  Try
    If OpenPictureDialog1.Execute(Self.Handle) Then
      txtImageAltGrShift.Text := OpenPictureDialog1.FileName;
  Except
    On E: Exception Do
    Begin
      Application.MessageBox(Pchar('Error occured!' + #10 + #10 + E.Message),
        Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
        MB_APPLMODAL);
    End;
  End;
End;

{ =============================================================================== }

Procedure TfrmMain.butImageNormalShiftClick(Sender: TObject);
Begin
  OpenPictureDialog1.FileName := '';
  Try
    If OpenPictureDialog1.Execute(Self.Handle) Then
      txtImageNormalShift.Text := OpenPictureDialog1.FileName;

  Except
    On E: Exception Do
    Begin
      Application.MessageBox(Pchar('Error occured!' + #10 + #10 + E.Message),
        Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
        MB_APPLMODAL);
    End;
  End;
End;

{ =============================================================================== }

Procedure TfrmMain.butNewClick(Sender: TObject);
Begin
  NewLayout;
End;

{ =============================================================================== }

Procedure TfrmMain.butOpenClick(Sender: TObject);
Var
  XML: IXMLDocument;
  Node: IXmlNode;
  I, P: Integer;
  KeyName, Layer, TrimLeftString: String;
  tmpShape: TShape;
  FStream: TFileStream;
  SStream: TStringStream;

  m_Converter: TSkinLayoutConverter;
Begin
  OpenDialog1.InitialDir := LELastDir;
  If OpenDialog1.Execute(Self.Handle) = false Then
    exit;
  LELastDir := ExtractFilePath(OpenDialog1.FileName);

  m_Converter := TSkinLayoutConverter.Create;
  m_Converter.CheckConvertLayout(OpenDialog1.FileName);
  FreeAndNil(m_Converter);

  XML := TXMLDocument.Create(nil);
  XML.Active := true;
  XML.Encoding := 'UTF-8';
  Try
    Try
      XML.LoadFromFile(OpenDialog1.FileName);

      // ----------------------------------------------
      // Check if the layout is a compatible one
      If trim(XML.DocumentElement.ChildNodes.FindNode('AvroKeyboardVersion')
        .nodevalue) <> '5' Then
      Begin
        Application.MessageBox
          ('This Keyboard Layout is not compatible with current version of Avro Keyboard.',
          'Error loading keyboard layout...', MB_OK + MB_ICONHAND +
          MB_DEFBUTTON1 + MB_APPLMODAL);
        exit;
      End;
      // ----------------------------------------------

      // Load basic informations
      txtLayoutName.Text := XML.DocumentElement.ChildNodes.FindNode
        ('LayoutName').nodevalue;
      txtDeveloper.Text := XML.DocumentElement.ChildNodes.FindNode
        ('DeveloperName').nodevalue;
      txtVersion.Text := XML.DocumentElement.ChildNodes.FindNode
        ('LayoutVersion').nodevalue;
      txtComment.Text := XML.DocumentElement.ChildNodes.FindNode
        ('DeveloperComment').nodevalue;

      // Extract images
      If XML.DocumentElement.ChildNodes.FindNode('ImageNormalShift') <> Nil Then
      Begin

        FStream := TFileStream.Create(GetAvroDataDir +
          'tmpImage_Normal_Shift.bmp', fmCreate);
        SStream := TStringStream.Create
          (DecodeBase64(VarToStr(XML.DocumentElement.ChildNodes.FindNode
          ('ImageNormalShift').nodevalue)));
        SStream.Position := 0;
        FStream.CopyFrom(SStream, SStream.Size);
        txtImageNormalShift.Text := GetAvroDataDir +
          'tmpImage_Normal_Shift.bmp';
        FStream.Free;
        SStream.Free;
      End;

      If XML.DocumentElement.ChildNodes.FindNode('ImageAltGrShift') <> Nil Then
      Begin
        FStream := TFileStream.Create(GetAvroDataDir +
          'tmpImage_AltGr_Shift.bmp', fmCreate);
        SStream := TStringStream.Create
          (DecodeBase64(VarToStr(XML.DocumentElement.ChildNodes.FindNode
          ('ImageAltGrShift').nodevalue)));
        SStream.Position := 0;
        FStream.CopyFrom(SStream, SStream.Size);
        txtImageAltGrShift.Text := GetAvroDataDir + 'tmpImage_AltGr_Shift.bmp';
        FStream.Free;
        SStream.Free;
      End;

      // Load Keys
      Node := XML.DocumentElement.ChildNodes.FindNode('KeyData');

      For I := 0 To Node.ChildNodes.Count - 1 Do
      Begin
        If LowerCase(LeftStr(Node.ChildNodes.nodes[I].Nodename, 3)) <>
          'num' Then
        Begin

          // Structure: Key_OEM1_Normal
          TrimLeftString := MidStr(Node.ChildNodes.nodes[I].Nodename, 5,
            Length(Node.ChildNodes.nodes[I].Nodename)); // OEM1_normal
          P := Pos('_', TrimLeftString);
          KeyName := MidStr(TrimLeftString, 1, P - 1); // OEM
          Layer := LowerCase(MidStr(TrimLeftString, P + 1,
            Length(TrimLeftString))); // normal/Shift/AltGr/ShiftAltGr

          tmpShape := FindComponent('Shape_' + KeyName) As TShape;

          If Node.ChildNodes.nodes[I].ChildNodes.Count <= 0 Then
          Begin
            // If item has no cdata
            If Layer = 'normal' Then
              tmpShape.Normal := '';
            If Layer = 'shift' Then
              tmpShape.Shift := '';
            If Layer = 'altgr' Then
              tmpShape.AltGr := '';
            If Layer = 'shiftaltgr' Then
              tmpShape.ShiftAltGr := '';
          End
          Else
          Begin

            // if item has cdata
            If Layer = 'normal' Then
              tmpShape.Normal :=
                VarToStr(Node.ChildNodes.nodes[I].ChildNodes.nodes[0]
                .nodevalue);
            If Layer = 'shift' Then
              tmpShape.Shift :=
                VarToStr(Node.ChildNodes.nodes[I].ChildNodes.nodes[0]
                .nodevalue);
            If Layer = 'altgr' Then
              tmpShape.AltGr :=
                VarToStr(Node.ChildNodes.nodes[I].ChildNodes.nodes[0]
                .nodevalue);
            If Layer = 'shiftaltgr' Then
              tmpShape.ShiftAltGr :=
                VarToStr(Node.ChildNodes.nodes[I].ChildNodes.nodes[0]
                .nodevalue);
          End;
        End;
      End;

    Except
      On E: Exception Do
      Begin
        Application.MessageBox(Pchar('Error occured!' + #10 + #10 + E.Message),
          Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
          MB_APPLMODAL);
        NewLayout;
      End;
    End;
  Finally

    XML.Active := false;
    XML := nil;
  End;

  SetSelectedKey('Shape_Q');

End;

{ =============================================================================== }

Procedure TfrmMain.ButSaveAsClick(Sender: TObject);
Begin
  If NoErrorFound = false Then
    exit;

  Try
    SaveDialog1.FileName := txtLayoutName.Text + '.avrolayout';
    If SaveDialog1.Execute(Self.Handle) Then
    Begin
      LELastDir := ExtractFilePath(SaveDialog1.FileName);
      fFileName := SaveDialog1.FileName;
      BuildLayout;
    End;

  Except
    On E: Exception Do
    Begin
      Application.MessageBox(Pchar('Error occured!' + #10 + #10 + E.Message),
        Pchar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
        MB_APPLMODAL);
    End;
  End;
End;

{ =============================================================================== }

Procedure TfrmMain.ButSaveClick(Sender: TObject);
Begin
  If NoErrorFound = false Then
    exit;

  If fFileName = '' Then
    ButSaveAsClick(Nil)
  Else
    BuildLayout;
End;

{ =============================================================================== }

Procedure TfrmMain.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  SaveSettings;

  Action := caFree;
  frmMain := Nil;
End;

{ =============================================================================== }

Procedure TfrmMain.FormCreate(Sender: TObject);
Begin
  InitializeKeys;
  NewLayout;
  fDirty := false;
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

{ =============================================================================== }

Procedure TfrmMain.InitializeKeys;
Var
  I: Integer;
Begin
{$REGION 'Initializing stuffs'}
  With Shape_OEM3 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '`';
    CaptionShift := '~';
  End;

  With Shape_1 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '1';
    CaptionShift := '!';
  End;

  With Shape_2 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '2';
    CaptionShift := '@';
  End;

  With Shape_3 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '3';
    CaptionShift := '#';
  End;

  With Shape_4 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '4';
    CaptionShift := '$';
  End;

  With Shape_4 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '4';
    CaptionShift := '$';
  End;

  With Shape_5 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '5';
    CaptionShift := '%';
  End;

  With Shape_6 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '6';
    CaptionShift := '^';
  End;

  With Shape_7 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '7';
    CaptionShift := '&';
  End;

  With Shape_8 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '8';
    CaptionShift := '*';
  End;

  With Shape_9 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '9';
    CaptionShift := '(';
  End;

  With Shape_0 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '0';
    CaptionShift := ')';
  End;

  With Shape_MINUS Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '-';
    CaptionShift := '_';
  End;

  With Shape_PLUS Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '=';
    CaptionShift := '+';
  End;

  With Shape_OEM4 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '[';
    CaptionShift := '{';
  End;

  With Shape_OEM6 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := ']';
    CaptionShift := '}';
  End;

  With Shape_OEM5 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '\';
    CaptionShift := '|';
  End;

  With Shape_COMMA Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := ',';
    CaptionShift := '<';
  End;

  With Shape_PERIOD Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '.';
    CaptionShift := '>';
  End;

  With Shape_OEM2 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '/';
    CaptionShift := '?';
  End;

  With Shape_OEM1 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := ';';
    CaptionShift := ':';
  End;

  With Shape_OEM7 Do
  Begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := #39;
    CaptionShift := '"';
  End;

  /// //////////// Initialize alphabet keys
  For I := 0 To ComponentCount - 1 Do
  Begin
    If Components[I] Is TShape Then
    Begin
      If (Components[I] As TShape).KeyName = '' Then
      Begin
        With (Components[I] As TShape) Do
        Begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := LowerCase(KeyName);
          CaptionShift := UpperCase(CaptionNormal);
        End;
      End;
    End;
  End;
{$ENDREGION}
End;

{ =============================================================================== }

Procedure TfrmMain.Label15Click(Sender: TObject);
Begin
  Execute_Something('http://www.omicronlab.com/go.php?id=5');
End;

{ =============================================================================== }

Procedure TfrmMain.NewLayout;
Var
  retVal: Integer;
Begin
  If fDirty Then
  Begin
    retVal := Application.MessageBox
      ('Save changes to the current keyboard layout?', 'Layout Editor',
      MB_YESNOCANCEL + +MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
    If retVal = ID_YES Then
    Begin
      If NoErrorFound = true Then
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
  fDirty := false;
End;

{ =============================================================================== }

Function TfrmMain.NoErrorFound: Boolean;
Begin
  result := false;
  If (trim(txtLayoutName.Text) = '') Or
    (trim(txtLayoutName.Text) = '[My Layout]') Then
  Begin
    Application.MessageBox('Please give a name to your layout first.',
      'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    txtLayoutName.SetFocus;
    txtLayoutName.SelectAll;
    exit;
  End;
  If trim(txtImageNormalShift.Text) = '' Then
  Begin
    Application.MessageBox
      ('Please add bitmap images for Layout Viewer of Avro Keyboard before building keyboard layout.',
      'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    exit;
  End;
  If trim(txtImageAltGrShift.Text) = '' Then
  Begin
    Application.MessageBox
      ('Please add bitmap images for Layout Viewer of Avro Keyboard before building keyboard layout.',
      'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    exit;
  End;
  result := true;
End;

{ =============================================================================== }

Procedure TfrmMain.SetSelectedKey(ControlName: String);
Var
  I: Integer;
Begin

  For I := 0 To ComponentCount - 1 Do
  Begin
    If Components[I] Is TShape Then
    Begin
      If UpperCase((Components[I] As TShape).Name) = UpperCase(ControlName) Then
      Begin
        (Components[I] As TShape).Selected := true;
        fSelected := Components[I] As TShape;

        If (Components[I] As TShape).CaptionShift <> '&' Then
          LabelShift.Caption := (Components[I] As TShape).CaptionShift
        Else
          LabelShift.Caption := '&&';

        LabelNormal.Caption := (Components[I] As TShape).CaptionNormal;

        txtNormal.Text := (Components[I] As TShape).Normal;
        txtShift.Text := (Components[I] As TShape).Shift;
        txtAltGr.Text := (Components[I] As TShape).AltGr;
        txtShiftAltGr.Text := (Components[I] As TShape).ShiftAltGr;

      End
      Else
        (Components[I] As TShape).Selected := false;
    End;
  End;
End;

{ =============================================================================== }

Procedure TfrmMain.Shape_QMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Begin
  SetSelectedKey((Sender As TShape).Name);
End;

{ =============================================================================== }

Procedure TfrmMain.txtAltGrChange(Sender: TObject);
Begin
  fSelected.AltGr := txtAltGr.Text;
  If txtAltGr.Text = '' Then
    imgAltGr.Visible := true
  Else
    imgAltGr.Visible := false;

  fDirty := true;
End;

{ =============================================================================== }

Procedure TfrmMain.txtCommentEnter(Sender: TObject);
Begin
  txtComment.SelectAll;
End;

{ =============================================================================== }

Procedure TfrmMain.txtLayoutNameChange(Sender: TObject);
Begin
  fDirty := true;
End;

{ =============================================================================== }

Procedure TfrmMain.txtLayoutNameEnter(Sender: TObject);
Begin
  (Sender As TEdit).SelectAll;
End;

{ =============================================================================== }

Procedure TfrmMain.txtNormalChange(Sender: TObject);
Begin
  fSelected.Normal := txtNormal.Text;
  If txtNormal.Text = '' Then
    imgNormal.Visible := true
  Else
    imgNormal.Visible := false;

  fDirty := true;
End;

{ =============================================================================== }

Procedure TfrmMain.txtNormalEnter(Sender: TObject);
Begin
  (Sender As TEdit).SelectAll;
End;

{ =============================================================================== }

Procedure TfrmMain.txtShiftAltGrChange(Sender: TObject);
Begin
  fSelected.ShiftAltGr := txtShiftAltGr.Text;
  If txtShiftAltGr.Text = '' Then
    imgShiftAltGr.Visible := true
  Else
    imgShiftAltGr.Visible := false;

  fDirty := true;

End;

{ =============================================================================== }

Procedure TfrmMain.txtShiftChange(Sender: TObject);
Begin
  fSelected.Shift := txtShift.Text;
  If txtShift.Text = '' Then
    imgShift.Visible := true
  Else
    imgShift.Visible := false;

  fDirty := true;

End;

{ =============================================================================== }

End.
