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
          FrameImageAdd: TFrameImageAdd;
          GroupBox3: TGroupBox;
          FrameDrag: TFrameDrag;
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
     frmSkinCreator           : TfrmSkinCreator;

Implementation

{$R *.dfm}

Uses
     ufrmAbout,
     NativeXml,
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
     If ValidateNext(Index + 1) = False Then System.Exit;
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
     If Index <= 1 Then System.Exit;

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
////////////////////////////////////////

     Procedure NewCDataNode(Var mXML: TNativeXML; NodeName, NodeData: String);
     Var
          mChild              : TXmlNode;
          mCDataChild         : TXmlNode;
     Begin
          mChild := mXML.Root.NodeNew(NodeName);
          mCDataChild := mChild.NodeNew(NodeName);
          mCDataChild.ElementType := xeCData;
          mCDataChild.ValueAsString := NodeData;
     End;
     ////////////////////////////////////////

     Procedure NewNode(Var mXML: TNativeXML; NodeName, NodeData: String);
     Var
          mChild              : TXmlNode;
     Begin
          mChild := mXML.Root.NodeNew(NodeName);
          mChild.ValueAsString := NodeData;
     End;
     ////////////////////////////////////////

     Function ImageToXml(Var mXML: TNativeXml; NodeName: String; ImagePath: String): Boolean;
     Var
          FStream             : TFileStream;
          SStream             : TStringStream;
          mChild              : TXmlNode;
          // mCDataChild         : TXmlNode;

          ErrorOccured        : Boolean;
     Begin
          ErrorOccured := False;
          ImagePath := Trim(ImagePath);

          mChild := mXML.Root.NodeNew(NodeName);
          // mCDataChild := mChild.NodeNew(NodeName);
          // mCDataChild.ElementType := xeCData;
          mChild.BinaryEncoding := xbeBase64;
          Try
               Try
                    If ImagePath <> '' Then Begin
                         SStream := TStringStream.Create('');
                         FStream := TFileStream.Create(ImagePath, fmOpenRead, fmShareDenyWrite);
                         SStream.CopyFrom(FStream, FStream.Size);
                         mChild.BinaryString := SStream.DataString;
                    End
                    Else
                         mChild.BinaryString := '';

               Except
                    On E: Exception Do Begin
                         ErrorOccured := True;
                    End;
               End;
          Finally
               If ImagePath <> '' Then Begin
                    FStream.Free;
                    SStream.Free;
               End;

               If ErrorOccured Then
                    Result := False
               Else
                    Result := True;
          End;
     End;
     ////////////////////////////////////////

     Function MyBoolToStr(b: Boolean): String;
     Begin
          If b Then
               result := '1'
          Else
               Result := '0';

     End;
     ////////////////////////////////////////
Var
     XML                      : TNativeXml;
     child                    : TXmlNode;
     CdataChild               : TXmlNode;
Begin
     Try
          Try
               XML := TNativeXml.Create;
               XML.EncodingString := 'UTF-8';
               XML.XmlFormat := xfReadable;
               XML.ExternalEncoding := seUTF8;

               XML.Root.Name := 'Skin';

               //Avro version
               Child := XML.Root.NodeNew('AvroKeyboardVersion');
               Child.ValueAsString := '5';

               //Skin info
               NewCDataNode(XML, 'SkinName', EditSkinName.Text);
               NewCDataNode(XML, 'SkinVersion', EditSkinVer.Text);
               NewCDataNode(XML, 'DesignerName', EditDesignerName.Text);
               NewCDataNode(XML, 'DesignerComment', EditComment.Text);

               //Preview Image
               If Not ImageToXml(XML, 'Preview', FrameImageAdd.Preview.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.Preview.Text);

               //Button info
               NewNode(XML, 'AvroIconAdded', MyBoolToStr(CheckAvroIcon.Checked));
               NewNode(XML, 'KeyboardModeAdded', MyBoolToStr(CheckKM.Checked));
               NewNode(XML, 'KeyboardLayoutAdded', MyBoolToStr(CheckKL.Checked));
               NewNode(XML, 'LayoutViewerAdded', MyBoolToStr(CheckLayoutViewer.Checked));
               NewNode(XML, 'AvroMouseAdded', MyBoolToStr(CheckMouse.Checked));
               NewNode(XML, 'ToolsAdded', MyBoolToStr(CheckTools.Checked));
               NewNode(XML, 'WebAdded', MyBoolToStr(CheckWeb.Checked));
               NewNode(XML, 'HelpAdded', MyBoolToStr(CheckHelp.Checked));
               NewNode(XML, 'ExitAdded', MyBoolToStr(CheckExit.Checked));

               //Main Image
               If Not ImageToXml(XML, 'TopBarMain', FrameImageAdd.ImagePath_TopBar.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.ImagePath_TopBar.Text);
               NewNode(XML, 'TopBarHeight', IntToStr(FrameDrag.Background.Height));
               NewNode(XML, 'TopBarWidth', IntToStr(FrameDrag.Background.Width));

               //Avro icon
               If Not ImageToXml(XML, 'AvroIconNormal', FrameImageAdd.AvroIcon.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.AvroIcon.Text);
               If Not ImageToXml(XML, 'AvroIconOver', FrameImageAdd.AvroIconOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.AvroIconOver.Text);
               If Not ImageToXml(XML, 'AvroIconDown', FrameImageAdd.AvroIconDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.AvroIconDown.Text);
               NewNode(XML, 'AvroIconHeight', IntToStr(FrameDrag.AvroIcon.Height));
               NewNode(XML, 'AvroIconWidth', IntToStr(FrameDrag.AvroIcon.Width));
               NewNode(XML, 'AvroIconLeft', IntToStr(FrameDrag.AvroIcon.Left));
               NewNode(XML, 'AvroIconTop', IntToStr(FrameDrag.AvroIcon.Top));


               //Keyboard Mode
               If Not ImageToXml(XML, 'KeyboardModeEnglishNormal', FrameImageAdd.KMSys.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KMSys.Text);
               If Not ImageToXml(XML, 'KeyboardModeEnglishOver', FrameImageAdd.KMSysOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KMSysOver.Text);
               If Not ImageToXml(XML, 'KeyboardModeEnglishDown', FrameImageAdd.KMSysDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KMSysDown.Text);
               If Not ImageToXml(XML, 'KeyboardModeBanglaNormal', FrameImageAdd.KMBangla.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KMBangla.Text);
               If Not ImageToXml(XML, 'KeyboardModeBanglaOver', FrameImageAdd.KMBanglaOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KMBanglaOver.Text);
               If Not ImageToXml(XML, 'KeyboardModeBanglaDown', FrameImageAdd.KMBanglaDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KMBanglaDown.Text);
               NewNode(XML, 'KeyboardModeHeight', IntToStr(FrameDrag.KM.Height));
               NewNode(XML, 'KeyboardModeWidth', IntToStr(FrameDrag.KM.Width));
               NewNode(XML, 'KeyboardModeLeft', IntToStr(FrameDrag.KM.Left));
               NewNode(XML, 'KeyboardModeTop', IntToStr(FrameDrag.KM.Top));

               //Keyboard Layout
               If Not ImageToXml(XML, 'KeyboardLayoutNormal', FrameImageAdd.KL.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KL.Text);
               If Not ImageToXml(XML, 'KeyboardLayoutOver', FrameImageAdd.KLOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KLOver.Text);
               If Not ImageToXml(XML, 'KeyboardLayoutDown', FrameImageAdd.KLDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.KLDown.Text);
               NewNode(XML, 'KeyboardLayoutHeight', IntToStr(FrameDrag.KL.Height));
               NewNode(XML, 'KeyboardLayoutWidth', IntToStr(FrameDrag.KL.Width));
               NewNode(XML, 'KeyboardLayoutLeft', IntToStr(FrameDrag.KL.Left));
               NewNode(XML, 'KeyboardLayoutTop', IntToStr(FrameDrag.KL.Top));


               //LayoutViewer
               If Not ImageToXml(XML, 'LayoutViewerNormal', FrameImageAdd.LayoutV.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.LayoutV.Text);
               If Not ImageToXml(XML, 'LayoutViewerOver', FrameImageAdd.LayoutVOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.LayoutVOver.Text);
               If Not ImageToXml(XML, 'LayoutViewerDown', FrameImageAdd.LayoutVDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.LayoutVDown.Text);
               NewNode(XML, 'LayoutViewerHeight', IntToStr(FrameDrag.LayoutV.Height));
               NewNode(XML, 'LayoutViewerWidth', IntToStr(FrameDrag.LayoutV.Width));
               NewNode(XML, 'LayoutViewerLeft', IntToStr(FrameDrag.LayoutV.Left));
               NewNode(XML, 'LayoutViewerTop', IntToStr(FrameDrag.LayoutV.Top));


               //AvroMouse
               If Not ImageToXml(XML, 'AvroMouseNormal', FrameImageAdd.AvroMouse.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.AvroMouse.Text);
               If Not ImageToXml(XML, 'AvroMouseOver', FrameImageAdd.AvroMouseOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.AvroMouseOver.Text);
               If Not ImageToXml(XML, 'AvroMouseDown', FrameImageAdd.AvroMouseDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.AvroMouseDown.Text);
               NewNode(XML, 'AvroMouseHeight', IntToStr(FrameDrag.AvroMouse.Height));
               NewNode(XML, 'AvroMouseWidth', IntToStr(FrameDrag.AvroMouse.Width));
               NewNode(XML, 'AvroMouseLeft', IntToStr(FrameDrag.AvroMouse.Left));
               NewNode(XML, 'AvroMouseTop', IntToStr(FrameDrag.AvroMouse.Top));


               //Tools
               If Not ImageToXml(XML, 'ToolsNormal', FrameImageAdd.Tools.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.Tools.Text);
               If Not ImageToXml(XML, 'ToolsOver', FrameImageAdd.ToolsOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.ToolsOver.Text);
               If Not ImageToXml(XML, 'ToolsDown', FrameImageAdd.ToolsDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.ToolsDown.Text);
               NewNode(XML, 'ToolsHeight', IntToStr(FrameDrag.Tools.Height));
               NewNode(XML, 'ToolsWidth', IntToStr(FrameDrag.Tools.Width));
               NewNode(XML, 'ToolsLeft', IntToStr(FrameDrag.Tools.Left));
               NewNode(XML, 'ToolsTop', IntToStr(FrameDrag.Tools.Top));

               //Web
               If Not ImageToXml(XML, 'WebNormal', FrameImageAdd.Web.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.Web.Text);
               If Not ImageToXml(XML, 'WebOver', FrameImageAdd.WebOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.WebOver.Text);
               If Not ImageToXml(XML, 'WebDown', FrameImageAdd.WebDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.WebDown.Text);
               NewNode(XML, 'WebHeight', IntToStr(FrameDrag.Web.Height));
               NewNode(XML, 'WebWidth', IntToStr(FrameDrag.Web.Width));
               NewNode(XML, 'WebLeft', IntToStr(FrameDrag.Web.Left));
               NewNode(XML, 'WebTop', IntToStr(FrameDrag.Web.Top));

               //Help
               If Not ImageToXml(XML, 'HelpNormal', FrameImageAdd.Help.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.Help.Text);
               If Not ImageToXml(XML, 'HelpOver', FrameImageAdd.HelpOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.HelpOver.Text);
               If Not ImageToXml(XML, 'HelpDown', FrameImageAdd.HelpDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.HelpDown.Text);
               NewNode(XML, 'HelpHeight', IntToStr(FrameDrag.Help.Height));
               NewNode(XML, 'HelpWidth', IntToStr(FrameDrag.Help.Width));
               NewNode(XML, 'HelpLeft', IntToStr(FrameDrag.Help.Left));
               NewNode(XML, 'HelpTop', IntToStr(FrameDrag.Help.Top));

               //Exit
               If Not ImageToXml(XML, 'ExitNormal', FrameImageAdd.Exit.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.Exit.Text);
               If Not ImageToXml(XML, 'ExitOver', FrameImageAdd.ExitOver.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.ExitOver.Text);
               If Not ImageToXml(XML, 'ExitDown', FrameImageAdd.ExitDown.Text) Then
                    Raise Exception.Create('Unable to convert image to skin!' + #10 + FrameImageAdd.ExitDown.Text);
               NewNode(XML, 'ExitHeight', IntToStr(FrameDrag.Exit.Height));
               NewNode(XML, 'ExitWidth', IntToStr(FrameDrag.Exit.Width));
               NewNode(XML, 'ExitLeft', IntToStr(FrameDrag.Exit.Left));
               NewNode(XML, 'ExitTop', IntToStr(FrameDrag.Exit.Top));

               Savedialog1.FileName := EditSkinName.Text + '.avroskin';
               If Savedialog1.Execute(self.Handle) Then Begin
                    Xml.SaveToFile(Savedialog1.FileName);
               End;
               { TODO : Save path in registry }


          Except
               On E: Exception Do Begin
                    Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Skin Designer'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
               End;
          End;
     Finally
          FreeAndNil(XML);
     End;


End;

Procedure TfrmSkinCreator.FormCreate(Sender: TObject);
Begin
     With FrameImageAdd Do Begin
          Initialize;
          Top := 0;
          Left := 0;
     End;

     With FrameDrag Do Begin
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
     Case Index Of
          1: Result := Validate_1To2_Page;

          2: Result := Validate_2To3_Page;

          3: Result := Validate_3To4_Page;
     End;
End;

Function TfrmSkinCreator.Validate_1To2_Page: Boolean;
Begin
     Result := False;

     //Validate
     If Trim(EditSkinName.Text) = '' Then Begin
          Application.MessageBox('Please enter Skin Name', 'Skin Designer', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
          EditSkinName.SetFocus;
          System.Exit;
     End;

     //Cosmetics
     FrameImageAdd.SetVisibleControls(CheckKL.Checked, CheckLayoutViewer.Checked,
          CheckMouse.Checked, CheckTools.Checked, CheckWeb.Checked, CheckHelp.Checked);
     Result := True;
End;

Function TfrmSkinCreator.Validate_2To3_Page: Boolean;
Begin
     Result := False;

     //Validate
     If FrameImageAdd.Validate = False Then System.Exit;


     //Load Images
     With FrameImageAdd Do
          FrameDrag.SetImages(ImagePath_TopBar.Text,
               AvroIcon.Text,
               KMSys.Text,
               KL.Text,
               LayoutV.Text,
               AvroMouse.Text,
               Tools.Text,
               Web.Text,
               Help.Text,
               Exit.Text
               );

     Result := True;
End;

Function TfrmSkinCreator.Validate_3To4_Page: Boolean;
Begin
     Result := FrameDrag.Validate;
End;

End.

