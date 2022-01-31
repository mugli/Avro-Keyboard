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
Unit ufrmSkinCreator;

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
  StdCtrls,
  uFrameImageAdd,
  uFrameDrag,
  xmlDoc, XMLIntf,
  Soap.EncdDecd,
  ExtCtrls,
  GIFImg;

Type
  TfrmSkinCreator = Class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    EditSkinName: TEdit;
    Label5: TLabel;
    EditSkinVer: TEdit;
    Label6: TLabel;
    EditDesignerName: TEdit;
    Label7: TLabel;
    EditComment: TMemo;
    Label8: TLabel;
    CheckAvroIcon: TCheckBox;
    CheckKM: TCheckBox;
    CheckKL: TCheckBox;
    CheckLayoutViewer: TCheckBox;
    CheckMouse: TCheckBox;
    CheckTools: TCheckBox;
    CheckWeb: TCheckBox;
    CheckHelp: TCheckBox;
    CheckExit: TCheckBox;
    ButtonHelp: TButton;
    ButtonAbout: TButton;
    ButtonPrev: TButton;
    ButtonNext: TButton;
    ButtonExit: TButton;
    GroupBox2: TGroupBox;
    ScrollBoxImageAdd: TScrollBox;
    FrameImageAdd1: TFrameImageAdd;
    GroupBox3: TGroupBox;
    FrameDrag1: TFrameDrag;
    GroupBox4: TGroupBox;
    ButtonSaveSkin: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Panel2: TPanel;
    Label11: TLabel;
    LabelShareLink: TLabel;
    Panel3: TPanel;
    Image1: TImage;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    Procedure FormCreate(Sender: TObject);
    Procedure ButtonNextClick(Sender: TObject);
    Procedure ButtonPrevClick(Sender: TObject);
    Procedure ButtonSaveSkinClick(Sender: TObject);
    Procedure ButtonHelpClick(Sender: TObject);
    Procedure LabelShareLinkClick(Sender: TObject);
    Procedure ButtonAboutClick(Sender: TObject);
    Procedure ButtonExitClick(Sender: TObject);
  Private
    { Private declarations }
    Index: Integer;
    Function ValidateNext(Val: Integer): Boolean;
    Function Validate_1To2_Page: Boolean;
    Function Validate_2To3_Page: Boolean;
    Function Validate_3To4_Page: Boolean;
  Public
    { Public declarations }
  End;

Var
  frmSkinCreator: TfrmSkinCreator;

Implementation

{$R *.dfm}

Uses
  ufrmAbout,

  uFileFolderHandling;

Procedure TfrmSkinCreator.ButtonAboutClick(Sender: TObject);
Begin
  Application.CreateForm(TfrmAbout, frmAbout);
  frmAbout.ShowModal;
End;

Procedure TfrmSkinCreator.ButtonExitClick(Sender: TObject);
Begin

  If Application.MessageBox('Exit Skin Designer?', 'Skin Designer',
    MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_APPLMODAL) = ID_YES Then
    Self.Close;
End;

Procedure TfrmSkinCreator.ButtonHelpClick(Sender: TObject);
Begin
  { TODO : Write help and make this button Visible! }
End;

Procedure TfrmSkinCreator.ButtonNextClick(Sender: TObject);
Begin
  If ValidateNext(Index + 1) = False Then
    System.Exit;
  Inc(Index);

  If Index = 4 Then
    ButtonNext.Enabled := False
  Else
    ButtonNext.Enabled := True;

  If Index = 1 Then
    ButtonPrev.Enabled := False
  Else
    ButtonPrev.Enabled := True;

  (FindComponent('GroupBox' + IntToStr(Index)) As TGroupBox).BringToFront;

End;

Procedure TfrmSkinCreator.ButtonPrevClick(Sender: TObject);
Begin
  If Index <= 1 Then
    System.Exit;

  Dec(Index);

  If Index = 4 Then
    ButtonNext.Enabled := False
  Else
    ButtonNext.Enabled := True;

  If Index = 1 Then
    ButtonPrev.Enabled := False
  Else
    ButtonPrev.Enabled := True;

  (FindComponent('GroupBox' + IntToStr(Index)) As TGroupBox).BringToFront;

End;

Procedure TfrmSkinCreator.ButtonSaveSkinClick(Sender: TObject);
/// /////////////////////////////////////

  Procedure NewCDataNode(Var mXML: IXMLDocument; NodeName: UTF8String;
    NodeData: String);
  Var
    mChild: IXMLNode;
    mCDataChild: IXMLNode;
  Begin
    mChild := mXML.DocumentElement.AddChild(NodeName);
    mCDataChild := mXML.CreateNode(NodeData, ntCDATA);
    mXML.DocumentElement.ChildNodes.nodes[NodeName].ChildNodes.Add(mCDataChild);

  End;
/// /////////////////////////////////////

  Procedure NewNode(Var mXML: IXMLDocument; NodeName: UTF8String;
    NodeData: String);
  Var
    mChild: IXMLNode;
  Begin
    mChild := mXML.DocumentElement.AddChild(NodeName);
    mChild.NodeValue := NodeData;
  End;
/// /////////////////////////////////////

  Function ImageToXml(Var mXML: IXMLDocument; NodeName: UTF8String;
    ImagePath: String): Boolean;
  Var
    FStream: TFileStream;
    SStream: TStringStream;
    mChild: IXMLNode;
    // mCDataChild         : IXMLNode;

    ErrorOccured: Boolean;
  Begin
    ErrorOccured := False;
    ImagePath := Trim(ImagePath);

    mChild := mXML.DocumentElement.AddChild(NodeName);
    // mCDataChild := mChild.NodeNew(NodeName);
    // mCDataChild.ElementType := xeCData;
    // mChild.BinaryEncoding := xbeBase64;
    Try
      Try
        If ImagePath <> '' Then
        Begin
          SStream := TStringStream.Create('');
          FStream := TFileStream.Create(ImagePath, fmOpenRead,
            fmShareDenyWrite);
          SStream.CopyFrom(FStream, FStream.Size);
          // mChild.BinaryString := RawByteString(SStream.DataString);
          mChild.NodeValue := EncodeBase64(Pchar(SStream.DataString),
            Length(SStream.DataString));
        End
        Else
          // mChild.BinaryString := '';
          mChild.NodeValue := '';
      Except
        On E: Exception Do
        Begin
          ErrorOccured := True;
        End;
      End;
    Finally
      If ImagePath <> '' Then
      Begin
        SStream.Free;
        FStream.Free;
      End;

      If ErrorOccured Then
        Result := False
      Else
        Result := True;
    End;
  End;
/// /////////////////////////////////////

  Function MyBoolToStr(b: Boolean): String;
  Begin
    If b Then
      Result := '1'
    Else
      Result := '0';

  End;

/// /////////////////////////////////////
Var
  XML: IXMLDocument;
  child: IXMLNode;
Begin
  Try
    Try
      XML := TXMLDocument.Create(nil);
      XML.Active := True;
      XML.Encoding := 'UTF-8';

      XML.AddChild('Skin');

      // Avro version
      child := XML.DocumentElement.AddChild('AvroKeyboardVersion');
      child.NodeValue := '5';

      // Skin info
      NewCDataNode(XML, 'SkinName', EditSkinName.Text);
      NewCDataNode(XML, 'SkinVersion', EditSkinVer.Text);
      NewCDataNode(XML, 'DesignerName', EditDesignerName.Text);
      NewCDataNode(XML, 'DesignerComment', EditComment.Text);

      // Preview Image
      If Not ImageToXml(XML, 'Preview', FrameImageAdd1.Preview.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.Preview.Text);

      // Button info
      NewNode(XML, 'AvroIconAdded', MyBoolToStr(CheckAvroIcon.Checked));
      NewNode(XML, 'KeyboardModeAdded', MyBoolToStr(CheckKM.Checked));
      NewNode(XML, 'KeyboardLayoutAdded', MyBoolToStr(CheckKL.Checked));
      NewNode(XML, 'LayoutViewerAdded', MyBoolToStr(CheckLayoutViewer.Checked));
      NewNode(XML, 'AvroMouseAdded', MyBoolToStr(CheckMouse.Checked));
      NewNode(XML, 'ToolsAdded', MyBoolToStr(CheckTools.Checked));
      NewNode(XML, 'WebAdded', MyBoolToStr(CheckWeb.Checked));
      NewNode(XML, 'HelpAdded', MyBoolToStr(CheckHelp.Checked));
      NewNode(XML, 'ExitAdded', MyBoolToStr(CheckExit.Checked));

      // Main Image
      If Not ImageToXml(XML, 'TopBarMain',
        FrameImageAdd1.ImagePath_TopBar.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.ImagePath_TopBar.Text);
      NewNode(XML, 'TopBarHeight', IntToStr(FrameDrag1.Background.Height));
      NewNode(XML, 'TopBarWidth', IntToStr(FrameDrag1.Background.Width));

      // Avro icon
      If Not ImageToXml(XML, 'AvroIconNormal',
        FrameImageAdd1.AvroIcon.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.AvroIcon.Text);
      If Not ImageToXml(XML, 'AvroIconOver',
        FrameImageAdd1.AvroIconOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.AvroIconOver.Text);
      If Not ImageToXml(XML, 'AvroIconDown',
        FrameImageAdd1.AvroIconDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.AvroIconDown.Text);
      NewNode(XML, 'AvroIconHeight', IntToStr(FrameDrag1.AvroIcon.Height));
      NewNode(XML, 'AvroIconWidth', IntToStr(FrameDrag1.AvroIcon.Width));
      NewNode(XML, 'AvroIconLeft', IntToStr(FrameDrag1.AvroIcon.Left));
      NewNode(XML, 'AvroIconTop', IntToStr(FrameDrag1.AvroIcon.Top));

      // Keyboard Mode
      If Not ImageToXml(XML, 'KeyboardModeEnglishNormal',
        FrameImageAdd1.KMSys.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KMSys.Text);
      If Not ImageToXml(XML, 'KeyboardModeEnglishOver',
        FrameImageAdd1.KMSysOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KMSysOver.Text);
      If Not ImageToXml(XML, 'KeyboardModeEnglishDown',
        FrameImageAdd1.KMSysDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KMSysDown.Text);
      If Not ImageToXml(XML, 'KeyboardModeBanglaNormal',
        FrameImageAdd1.KMBangla.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KMBangla.Text);
      If Not ImageToXml(XML, 'KeyboardModeBanglaOver',
        FrameImageAdd1.KMBanglaOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KMBanglaOver.Text);
      If Not ImageToXml(XML, 'KeyboardModeBanglaDown',
        FrameImageAdd1.KMBanglaDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KMBanglaDown.Text);
      NewNode(XML, 'KeyboardModeHeight', IntToStr(FrameDrag1.KM.Height));
      NewNode(XML, 'KeyboardModeWidth', IntToStr(FrameDrag1.KM.Width));
      NewNode(XML, 'KeyboardModeLeft', IntToStr(FrameDrag1.KM.Left));
      NewNode(XML, 'KeyboardModeTop', IntToStr(FrameDrag1.KM.Top));

      // Keyboard Layout
      If Not ImageToXml(XML, 'KeyboardLayoutNormal',
        FrameImageAdd1.KL.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KL.Text);
      If Not ImageToXml(XML, 'KeyboardLayoutOver',
        FrameImageAdd1.KLOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KLOver.Text);
      If Not ImageToXml(XML, 'KeyboardLayoutDown',
        FrameImageAdd1.KLDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.KLDown.Text);
      NewNode(XML, 'KeyboardLayoutHeight', IntToStr(FrameDrag1.KL.Height));
      NewNode(XML, 'KeyboardLayoutWidth', IntToStr(FrameDrag1.KL.Width));
      NewNode(XML, 'KeyboardLayoutLeft', IntToStr(FrameDrag1.KL.Left));
      NewNode(XML, 'KeyboardLayoutTop', IntToStr(FrameDrag1.KL.Top));

      // LayoutViewer
      If Not ImageToXml(XML, 'LayoutViewerNormal',
        FrameImageAdd1.LayoutV.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.LayoutV.Text);
      If Not ImageToXml(XML, 'LayoutViewerOver',
        FrameImageAdd1.LayoutVOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.LayoutVOver.Text);
      If Not ImageToXml(XML, 'LayoutViewerDown',
        FrameImageAdd1.LayoutVDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.LayoutVDown.Text);
      NewNode(XML, 'LayoutViewerHeight', IntToStr(FrameDrag1.LayoutV.Height));
      NewNode(XML, 'LayoutViewerWidth', IntToStr(FrameDrag1.LayoutV.Width));
      NewNode(XML, 'LayoutViewerLeft', IntToStr(FrameDrag1.LayoutV.Left));
      NewNode(XML, 'LayoutViewerTop', IntToStr(FrameDrag1.LayoutV.Top));

      // AvroMouse
      If Not ImageToXml(XML, 'AvroMouseNormal',
        FrameImageAdd1.AvroMouse.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.AvroMouse.Text);
      If Not ImageToXml(XML, 'AvroMouseOver',
        FrameImageAdd1.AvroMouseOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.AvroMouseOver.Text);
      If Not ImageToXml(XML, 'AvroMouseDown',
        FrameImageAdd1.AvroMouseDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.AvroMouseDown.Text);
      NewNode(XML, 'AvroMouseHeight', IntToStr(FrameDrag1.AvroMouse.Height));
      NewNode(XML, 'AvroMouseWidth', IntToStr(FrameDrag1.AvroMouse.Width));
      NewNode(XML, 'AvroMouseLeft', IntToStr(FrameDrag1.AvroMouse.Left));
      NewNode(XML, 'AvroMouseTop', IntToStr(FrameDrag1.AvroMouse.Top));

      // Tools
      If Not ImageToXml(XML, 'ToolsNormal', FrameImageAdd1.Tools.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.Tools.Text);
      If Not ImageToXml(XML, 'ToolsOver', FrameImageAdd1.ToolsOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.ToolsOver.Text);
      If Not ImageToXml(XML, 'ToolsDown', FrameImageAdd1.ToolsDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.ToolsDown.Text);
      NewNode(XML, 'ToolsHeight', IntToStr(FrameDrag1.Tools.Height));
      NewNode(XML, 'ToolsWidth', IntToStr(FrameDrag1.Tools.Width));
      NewNode(XML, 'ToolsLeft', IntToStr(FrameDrag1.Tools.Left));
      NewNode(XML, 'ToolsTop', IntToStr(FrameDrag1.Tools.Top));

      // Web
      If Not ImageToXml(XML, 'WebNormal', FrameImageAdd1.Web.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.Web.Text);
      If Not ImageToXml(XML, 'WebOver', FrameImageAdd1.WebOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.WebOver.Text);
      If Not ImageToXml(XML, 'WebDown', FrameImageAdd1.WebDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.WebDown.Text);
      NewNode(XML, 'WebHeight', IntToStr(FrameDrag1.Web.Height));
      NewNode(XML, 'WebWidth', IntToStr(FrameDrag1.Web.Width));
      NewNode(XML, 'WebLeft', IntToStr(FrameDrag1.Web.Left));
      NewNode(XML, 'WebTop', IntToStr(FrameDrag1.Web.Top));

      // Help
      If Not ImageToXml(XML, 'HelpNormal', FrameImageAdd1.Help.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.Help.Text);
      If Not ImageToXml(XML, 'HelpOver', FrameImageAdd1.HelpOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.HelpOver.Text);
      If Not ImageToXml(XML, 'HelpDown', FrameImageAdd1.HelpDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.HelpDown.Text);
      NewNode(XML, 'HelpHeight', IntToStr(FrameDrag1.Help.Height));
      NewNode(XML, 'HelpWidth', IntToStr(FrameDrag1.Help.Width));
      NewNode(XML, 'HelpLeft', IntToStr(FrameDrag1.Help.Left));
      NewNode(XML, 'HelpTop', IntToStr(FrameDrag1.Help.Top));

      // Exit
      If Not ImageToXml(XML, 'ExitNormal', FrameImageAdd1.Exit.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.Exit.Text);
      If Not ImageToXml(XML, 'ExitOver', FrameImageAdd1.ExitOver.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.ExitOver.Text);
      If Not ImageToXml(XML, 'ExitDown', FrameImageAdd1.ExitDown.Text) Then
        Raise Exception.Create('Unable to convert image to skin!' + #10 +
          FrameImageAdd1.ExitDown.Text);
      NewNode(XML, 'ExitHeight', IntToStr(FrameDrag1.Exit.Height));
      NewNode(XML, 'ExitWidth', IntToStr(FrameDrag1.Exit.Width));
      NewNode(XML, 'ExitLeft', IntToStr(FrameDrag1.Exit.Left));
      NewNode(XML, 'ExitTop', IntToStr(FrameDrag1.Exit.Top));

      SaveDialog1.FileName := EditSkinName.Text + '.avroskin';
      If SaveDialog1.Execute(Self.Handle) Then
      Begin
        XML.SaveToFile(SaveDialog1.FileName);
      End;
      { TODO : Save path in registry }

    Except
      On E: Exception Do
      Begin
        Application.MessageBox(Pchar('Error occured!' + #10 + #10 + E.Message),
          Pchar('Skin Designer'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 +
          MB_APPLMODAL);
      End;
    End;
  Finally
    XML.Active := False;
    XML := nil;
  End;

End;

Procedure TfrmSkinCreator.FormCreate(Sender: TObject);
Begin
  With FrameImageAdd1 Do
  Begin
    Initialize;
    Top := 0;
    Left := 0;
  End;

  With FrameDrag1 Do
  Begin
    Initialize;
  End;

  Index := 1;
  GroupBox1.BringToFront;
  Self.Show;
  Application.ProcessMessages;
  EditSkinName.SetFocus;
End;

Procedure TfrmSkinCreator.LabelShareLinkClick(Sender: TObject);
Begin
  Execute_Something('http://www.omicronlab.com/go.php?id=7');
End;

Function TfrmSkinCreator.ValidateNext(Val: Integer): Boolean;
Begin
  Result := False;
  Case Index Of
    1:
      Result := Validate_1To2_Page;

    2:
      Result := Validate_2To3_Page;

    3:
      Result := Validate_3To4_Page;
  End;
End;

Function TfrmSkinCreator.Validate_1To2_Page: Boolean;
Begin
  Result := False;

  // Validate
  If Trim(EditSkinName.Text) = '' Then
  Begin
    Application.MessageBox('Please enter Skin Name', 'Skin Designer',
      MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
    EditSkinName.SetFocus;
    System.Exit;
  End;

  // Cosmetics
  FrameImageAdd1.SetVisibleControls(CheckKL.Checked, CheckLayoutViewer.Checked,
    CheckMouse.Checked, CheckTools.Checked, CheckWeb.Checked,
    CheckHelp.Checked);
  Result := True;
End;

Function TfrmSkinCreator.Validate_2To3_Page: Boolean;
Begin
  Result := False;

  // Validate
  If FrameImageAdd1.Validate = False Then
    System.Exit;

  // Load Images
  With FrameImageAdd1 Do
    FrameDrag1.SetImages(ImagePath_TopBar.Text, AvroIcon.Text, KMSys.Text,
      KL.Text, LayoutV.Text, AvroMouse.Text, Tools.Text, Web.Text, Help.Text,
      Exit.Text);

  Result := True;
End;

Function TfrmSkinCreator.Validate_3To4_Page: Boolean;
Begin
  Result := FrameDrag1.Validate;
End;

End.
