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
  Mehdi Hasan Khan <mhasan@omicronlab.com>.

  Copyright (C) OmicronLab <https://www.omicronlab.com>. All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit ufrmSkinCreator;

interface

uses
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
  GIFImg,
  Vcl.AppEvnts;

type
  TfrmSkinCreator = class(TForm)
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
    Panel3: TPanel;
    Image1: TImage;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    AppEvents: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure ButtonPrevClick(Sender: TObject);
    procedure ButtonSaveSkinClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);
  private
                { Private declarations }
    Index: Integer;
    function ValidateNext(Val: Integer): Boolean;
    function Validate_1To2_Page: Boolean;
    function Validate_2To3_Page: Boolean;
    function Validate_3To4_Page: Boolean;

    procedure HandleThemes;
  public
                { Public declarations }
  end;

var
  frmSkinCreator: TfrmSkinCreator;

implementation

{$R *.dfm}

uses
  ufrmAbout,
  Xml.XMLIntf,
  Xml.XMLDoc,
  NetEncoding,
  uFileFolderHandling,
  WindowsDarkMode;

procedure TfrmSkinCreator.HandleThemes;
begin
  SetAppropriateThemeMode('Windows10 Dark', 'Windows10');
end;

procedure TfrmSkinCreator.AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);
begin
  if SameText('ImmersiveColorSet', string(Section)) then
    HandleThemes;
end;

procedure TfrmSkinCreator.ButtonAboutClick(Sender: TObject);
begin
  Application.CreateForm(TfrmAbout, frmAbout);
  frmAbout.ShowModal;
end;

procedure TfrmSkinCreator.ButtonExitClick(Sender: TObject);
begin

  if Application.MessageBox('Exit Skin Designer?', 'Skin Designer', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_APPLMODAL) = ID_YES then
    Self.Close;
end;

procedure TfrmSkinCreator.ButtonHelpClick(Sender: TObject);
begin
        { TODO : Write help and make this button Visible! }
end;

procedure TfrmSkinCreator.ButtonNextClick(Sender: TObject);
begin
  if ValidateNext(Index + 1) = False then
    System.Exit;
  Inc(Index);

  if Index = 4 then
    ButtonNext.Enabled := False
  else
    ButtonNext.Enabled := True;

  if Index = 1 then
    ButtonPrev.Enabled := False
  else
    ButtonPrev.Enabled := True;

  (FindComponent('GroupBox' + IntToStr(Index)) as TGroupBox).BringToFront;

end;

procedure TfrmSkinCreator.ButtonPrevClick(Sender: TObject);
begin
  if Index <= 1 then
    System.Exit;

  Dec(Index);

  if Index = 4 then
    ButtonNext.Enabled := False
  else
    ButtonNext.Enabled := True;

  if Index = 1 then
    ButtonPrev.Enabled := False
  else
    ButtonPrev.Enabled := True;

  (FindComponent('GroupBox' + IntToStr(Index)) as TGroupBox).BringToFront;

end;

procedure TfrmSkinCreator.ButtonSaveSkinClick(Sender: TObject);

  procedure NewCDataNode(var Doc: IXMLDocument; ParentNode: IXMLNode; NodeName, NodeData: string);
  var
    NewNode: IXMLNode;
  begin
    NewNode := ParentNode.AddChild(NodeName);
    NewNode.NodeValue := NodeData;
  end;

  procedure NewNode(var Doc: IXMLDocument; ParentNode: IXMLNode; NodeName, NodeData: string);
  var
    NewNode: IXMLNode;
  begin
    NewNode := ParentNode.AddChild(NodeName);
    NewNode.Text := NodeData;
  end;

  function ImageToXml(var Doc: IXMLDocument; ParentNode: IXMLNode; NodeName, ImagePath: string): Boolean;
  var
    FileStream: TFileStream;
    ByteStream: TBytesStream;
    EncodedStr: string;
    ImageNode: IXMLNode;
  begin
    Result := False;
    ImagePath := Trim(ImagePath);

    if ImagePath = '' then
      Exit(True);

    ImageNode := ParentNode.AddChild(NodeName);

    try
      FileStream := TFileStream.Create(ImagePath, fmOpenRead or fmShareDenyWrite);
      try
        ByteStream := TBytesStream.Create;
        try
          ByteStream.CopyFrom(FileStream, 0);
          EncodedStr := TNetEncoding.Base64.EncodeBytesToString(ByteStream.Bytes, ByteStream.Size);
          ImageNode.Text := EncodedStr;
          Result := True;
        finally
          ByteStream.Free;
        end;
      finally
        FileStream.Free;
      end;
    except
      on E: Exception do
        Application.MessageBox(PChar('Error loading image: ' + ImagePath + #10 + E.Message), PChar('Error'), MB_OK or MB_ICONHAND);
    end;
  end;

  function MyBoolToStr(b: Boolean): string;
  begin
    if b then
      Result := '1'
    else
      Result := '0';

  end;

var
  XMLDoc: IXMLDocument;
  RootNode, ChildNode: IXMLNode;
begin
  XMLDoc := NewXMLDocument;
  XMLDoc.Encoding := 'UTF-8';
  XMLDoc.Options := [doNodeAutoIndent];

  RootNode := XMLDoc.AddChild('Skin');

        // Avro version
  ChildNode := RootNode.AddChild('AvroKeyboardVersion');
  ChildNode.Text := '5';

        // Skin info
  NewCDataNode(XMLDoc, RootNode, 'SkinName', EditSkinName.Text);
  NewCDataNode(XMLDoc, RootNode, 'SkinVersion', EditSkinVer.Text);
  NewCDataNode(XMLDoc, RootNode, 'DesignerName', EditDesignerName.Text);
  NewCDataNode(XMLDoc, RootNode, 'DesignerComment', EditComment.Text);

        // Preview Image
  if not ImageToXml(XMLDoc, RootNode, 'Preview', FrameImageAdd1.Preview.Text) then
    Exit;

        // Button info
  NewNode(XMLDoc, RootNode, 'AvroIconAdded', MyBoolToStr(CheckAvroIcon.Checked));
  NewNode(XMLDoc, RootNode, 'KeyboardModeAdded', MyBoolToStr(CheckKM.Checked));
  NewNode(XMLDoc, RootNode, 'KeyboardLayoutAdded', MyBoolToStr(CheckKL.Checked));
  NewNode(XMLDoc, RootNode, 'LayoutViewerAdded', MyBoolToStr(CheckLayoutViewer.Checked));
  NewNode(XMLDoc, RootNode, 'AvroMouseAdded', MyBoolToStr(CheckMouse.Checked));
  NewNode(XMLDoc, RootNode, 'ToolsAdded', MyBoolToStr(CheckTools.Checked));
  NewNode(XMLDoc, RootNode, 'WebAdded', MyBoolToStr(CheckWeb.Checked));
  NewNode(XMLDoc, RootNode, 'HelpAdded', MyBoolToStr(CheckHelp.Checked));
  NewNode(XMLDoc, RootNode, 'ExitAdded', MyBoolToStr(CheckExit.Checked));

        // Main Image
  if not ImageToXml(XMLDoc, RootNode, 'TopBarMain', FrameImageAdd1.ImagePath_TopBar.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'TopBarHeight', IntToStr(FrameDrag1.Background.Height));
  NewNode(XMLDoc, RootNode, 'TopBarWidth', IntToStr(FrameDrag1.Background.Width));

        // Avro Icon
  if not ImageToXml(XMLDoc, RootNode, 'AvroIconNormal', FrameImageAdd1.AvroIcon.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'AvroIconOver', FrameImageAdd1.AvroIconOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'AvroIconDown', FrameImageAdd1.AvroIconDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'AvroIconHeight', IntToStr(FrameDrag1.AvroIcon.Height));
  NewNode(XMLDoc, RootNode, 'AvroIconWidth', IntToStr(FrameDrag1.AvroIcon.Width));
  NewNode(XMLDoc, RootNode, 'AvroIconLeft', IntToStr(FrameDrag1.AvroIcon.Left));
  NewNode(XMLDoc, RootNode, 'AvroIconTop', IntToStr(FrameDrag1.AvroIcon.Top));

        // Keyboard Mode
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardModeEnglishNormal', FrameImageAdd1.KMSys.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardModeEnglishOver', FrameImageAdd1.KMSysOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardModeEnglishDown', FrameImageAdd1.KMSysDown.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardModeBanglaNormal', FrameImageAdd1.KMBangla.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardModeBanglaOver', FrameImageAdd1.KMBanglaOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardModeBanglaDown', FrameImageAdd1.KMBanglaDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'KeyboardModeHeight', IntToStr(FrameDrag1.KM.Height));
  NewNode(XMLDoc, RootNode, 'KeyboardModeWidth', IntToStr(FrameDrag1.KM.Width));
  NewNode(XMLDoc, RootNode, 'KeyboardModeLeft', IntToStr(FrameDrag1.KM.Left));
  NewNode(XMLDoc, RootNode, 'KeyboardModeTop', IntToStr(FrameDrag1.KM.Top));

        // Keyboard Layout
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardLayoutNormal', FrameImageAdd1.KL.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardLayoutOver', FrameImageAdd1.KLOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'KeyboardLayoutDown', FrameImageAdd1.KLDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'KeyboardLayoutHeight', IntToStr(FrameDrag1.KL.Height));
  NewNode(XMLDoc, RootNode, 'KeyboardLayoutWidth', IntToStr(FrameDrag1.KL.Width));
  NewNode(XMLDoc, RootNode, 'KeyboardLayoutLeft', IntToStr(FrameDrag1.KL.Left));
  NewNode(XMLDoc, RootNode, 'KeyboardLayoutTop', IntToStr(FrameDrag1.KL.Top));

        // LayoutViewer
  if not ImageToXml(XMLDoc, RootNode, 'LayoutViewerNormal', FrameImageAdd1.LayoutV.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'LayoutViewerOver', FrameImageAdd1.LayoutVOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'LayoutViewerDown', FrameImageAdd1.LayoutVDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'LayoutViewerHeight', IntToStr(FrameDrag1.LayoutV.Height));
  NewNode(XMLDoc, RootNode, 'LayoutViewerWidth', IntToStr(FrameDrag1.LayoutV.Width));
  NewNode(XMLDoc, RootNode, 'LayoutViewerLeft', IntToStr(FrameDrag1.LayoutV.Left));
  NewNode(XMLDoc, RootNode, 'LayoutViewerTop', IntToStr(FrameDrag1.LayoutV.Top));

        // AvroMouse
  if not ImageToXml(XMLDoc, RootNode, 'AvroMouseNormal', FrameImageAdd1.AvroMouse.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'AvroMouseOver', FrameImageAdd1.AvroMouseOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'AvroMouseDown', FrameImageAdd1.AvroMouseDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'AvroMouseHeight', IntToStr(FrameDrag1.AvroMouse.Height));
  NewNode(XMLDoc, RootNode, 'AvroMouseWidth', IntToStr(FrameDrag1.AvroMouse.Width));
  NewNode(XMLDoc, RootNode, 'AvroMouseLeft', IntToStr(FrameDrag1.AvroMouse.Left));
  NewNode(XMLDoc, RootNode, 'AvroMouseTop', IntToStr(FrameDrag1.AvroMouse.Top));

        // Tools
  if not ImageToXml(XMLDoc, RootNode, 'ToolsNormal', FrameImageAdd1.Tools.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'ToolsOver', FrameImageAdd1.ToolsOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'ToolsDown', FrameImageAdd1.ToolsDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'ToolsHeight', IntToStr(FrameDrag1.Tools.Height));
  NewNode(XMLDoc, RootNode, 'ToolsWidth', IntToStr(FrameDrag1.Tools.Width));
  NewNode(XMLDoc, RootNode, 'ToolsLeft', IntToStr(FrameDrag1.Tools.Left));
  NewNode(XMLDoc, RootNode, 'ToolsTop', IntToStr(FrameDrag1.Tools.Top));

        // Web
  if not ImageToXml(XMLDoc, RootNode, 'WebNormal', FrameImageAdd1.Web.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'WebOver', FrameImageAdd1.WebOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'WebDown', FrameImageAdd1.WebDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'WebHeight', IntToStr(FrameDrag1.Web.Height));
  NewNode(XMLDoc, RootNode, 'WebWidth', IntToStr(FrameDrag1.Web.Width));
  NewNode(XMLDoc, RootNode, 'WebLeft', IntToStr(FrameDrag1.Web.Left));
  NewNode(XMLDoc, RootNode, 'WebTop', IntToStr(FrameDrag1.Web.Top));

        // Help
  if not ImageToXml(XMLDoc, RootNode, 'HelpNormal', FrameImageAdd1.Help.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'HelpOver', FrameImageAdd1.HelpOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'HelpDown', FrameImageAdd1.HelpDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'HelpHeight', IntToStr(FrameDrag1.Help.Height));
  NewNode(XMLDoc, RootNode, 'HelpWidth', IntToStr(FrameDrag1.Help.Width));
  NewNode(XMLDoc, RootNode, 'HelpLeft', IntToStr(FrameDrag1.Help.Left));
  NewNode(XMLDoc, RootNode, 'HelpTop', IntToStr(FrameDrag1.Help.Top));

        // Exit
  if not ImageToXml(XMLDoc, RootNode, 'ExitNormal', FrameImageAdd1.Exit.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'ExitOver', FrameImageAdd1.ExitOver.Text) then
    Exit;
  if not ImageToXml(XMLDoc, RootNode, 'ExitDown', FrameImageAdd1.ExitDown.Text) then
    Exit;
  NewNode(XMLDoc, RootNode, 'ExitHeight', IntToStr(FrameDrag1.Exit.Height));
  NewNode(XMLDoc, RootNode, 'ExitWidth', IntToStr(FrameDrag1.Exit.Width));
  NewNode(XMLDoc, RootNode, 'ExitLeft', IntToStr(FrameDrag1.Exit.Left));
  NewNode(XMLDoc, RootNode, 'ExitTop', IntToStr(FrameDrag1.Exit.Top));

        // Save file
  SaveDialog1.FileName := EditSkinName.Text + '.avroskin';
  if SaveDialog1.Execute then
    XMLDoc.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmSkinCreator.FormCreate(Sender: TObject);
begin
  HandleThemes;

  with FrameImageAdd1 do
  begin
    Initialize;
    Top := 0;
    Left := 0;
  end;

  with FrameDrag1 do
    Initialize;

  Index := 1;
  GroupBox1.BringToFront;
  Self.Show;
  Application.ProcessMessages;
  EditSkinName.SetFocus;
end;

function TfrmSkinCreator.ValidateNext(Val: Integer): Boolean;
begin
  Result := False;
  case Index of
    1:
      Result := Validate_1To2_Page;

    2:
      Result := Validate_2To3_Page;

    3:
      Result := Validate_3To4_Page;
  end;
end;

function TfrmSkinCreator.Validate_1To2_Page: Boolean;
begin
  Result := False;

  // Validate
  if Trim(EditSkinName.Text) = '' then
  begin
    Application.MessageBox('Please enter Skin Name', 'Skin Designer', MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
    EditSkinName.SetFocus;
    System.Exit;
  end;

  // Cosmetics
  FrameImageAdd1.SetVisibleControls(CheckKL.Checked, CheckLayoutViewer.Checked, CheckMouse.Checked, CheckTools.Checked, CheckWeb.Checked, CheckHelp.Checked);
  Result := True;
end;

function TfrmSkinCreator.Validate_2To3_Page: Boolean;
begin
  Result := False;

        // Validate
  if FrameImageAdd1.Validate = False then
    System.Exit;

        // Load Images
  with FrameImageAdd1 do
    FrameDrag1.SetImages(ImagePath_TopBar.Text, AvroIcon.Text, KMSys.Text, KL.Text, LayoutV.Text, AvroMouse.Text, Tools.Text, Web.Text, Help.Text, Exit.Text);

  Result := True;
end;

function TfrmSkinCreator.Validate_3To4_Page: Boolean;
begin
  Result := FrameDrag1.Validate;
end;

end.

