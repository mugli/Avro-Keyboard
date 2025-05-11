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
unit uFrmMain;

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
  ToolWin,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  GIFImg,
  jpeg,
  ExtDlgs,
  StrUtils,
  uShapeInterceptor,
  XMLIntf,
  XMLDoc,
  System.NetEncoding,
  System.Generics.Collections,
  Soap.EncdDecd,
  ImgList,
  Vcl.AppEvnts {Always must be the last};

type
  TfrmMain = class(TForm)
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
    Source: TImage;
    AppEvents: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure Shape_QMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure txtLayoutNameEnter(Sender: TObject);
    procedure txtCommentEnter(Sender: TObject);
    procedure txtNormalEnter(Sender: TObject);
    procedure butNewClick(Sender: TObject);
    procedure txtLayoutNameChange(Sender: TObject);
    procedure txtNormalChange(Sender: TObject);
    procedure txtShiftChange(Sender: TObject);
    procedure txtAltGrChange(Sender: TObject);
    procedure txtShiftAltGrChange(Sender: TObject);
    procedure butFontClick(Sender: TObject);
    procedure butHelpClick(Sender: TObject);
    procedure butImageNormalShiftClick(Sender: TObject);
    procedure butImageAltGrShiftClick(Sender: TObject);
    procedure ButSaveAsClick(Sender: TObject);
    procedure ButSaveClick(Sender: TObject);
    procedure butAboutClick(Sender: TObject);
    procedure butOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);

  private
    { Private declarations }
    fDirty: Boolean;
    fSelected: TShape;
    fFileName: string;
    procedure SetSelectedKey(ControlName: string);
    procedure InitializeKeys;
    procedure NewLayout;
    procedure BuildLayout;
    function NoErrorFound: Boolean;
    procedure EncodeAndSaveImage(XML: IXMLDocument; NodeName: string; FileName: string);

    procedure HandleThemes;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uFileFolderHandling,
  uFrmAbout,
  clsSkinLayoutConverter,
  uRegistrySettings,
  WindowsDarkMode;

{ =============================================================================== }

procedure TfrmMain.AppEventsSettingChange(Sender: TObject; Flag: Integer; const Section: string; var Result: LongInt);
begin
  if SameText('ImmersiveColorSet', string(Section)) then
    HandleThemes;
end;

procedure TfrmMain.BuildLayout;
const
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
var
  XML: IXMLDocument;
  Child: IXMLNode;
  KeyData: IXMLNode;
  I: Int64;
  FStream: TFileStream;
  SStream: TStringStream;
  ImageStream: TMemoryStream;
  TempStr: string;
begin
  XML := TXMLDocument.Create(nil);
  XML.Active := True;
  XML.Encoding := 'UTF-8';

  XML.DocumentElement := XML.CreateNode('Layout');

  Child := XML.DocumentElement.AddChild('AvroKeyboardVersion');
  Child.NodeValue := '5';

  Child := XML.DocumentElement.AddChild('LayoutName');
  Child.NodeValue := txtLayoutName.Text;

  Child := XML.DocumentElement.AddChild('LayoutVersion');
  Child.NodeValue := txtVersion.Text;

  Child := XML.DocumentElement.AddChild('DeveloperName');
  Child.NodeValue := txtDeveloper.Text;

  Child := XML.DocumentElement.AddChild('DeveloperComment');
  Child.NodeValue := txtComment.Text;

  EncodeAndSaveImage(XML, 'ImageNormalShift', GetAvroDataDir + 'tmpImage_Normal_Shift.bmp');
  txtImageNormalShift.Text := GetAvroDataDir + 'tmpImage_Normal_Shift.bmp';

  EncodeAndSaveImage(XML, 'ImageAltGrShift', GetAvroDataDir + 'tmpImage_AltGr_Shift.bmp');
  txtImageAltGrShift.Text := GetAvroDataDir + 'tmpImage_AltGr_Shift.bmp';

  KeyData := XML.DocumentElement.AddChild('KeyData');

  for I := 0 to ComponentCount - 1 do
    if Components[I] is TShape then
    begin
      Child := KeyData.AddChild('Key_' + UpperCase((Components[I] as TShape).KeyName) + '_Normal');
      Child.NodeValue := (Components[I] as TShape).Normal;

      Child := KeyData.AddChild('Key_' + UpperCase((Components[I] as TShape).KeyName) + '_Shift');
      Child.NodeValue := (Components[I] as TShape).Shift;

      Child := KeyData.AddChild('Key_' + UpperCase((Components[I] as TShape).KeyName) + '_AltGr');
      Child.NodeValue := (Components[I] as TShape).AltGr;

      Child := KeyData.AddChild('Key_' + UpperCase((Components[I] as TShape).KeyName) + '_ShiftAltGr');
      Child.NodeValue := (Components[I] as TShape).ShiftAltGr;
    end;

  Child := KeyData.AddChild('Num1');
  Child.NodeValue := b_1;

  Child := KeyData.AddChild('Num2');
  Child.NodeValue := b_2;

  Child := KeyData.AddChild('Num3');
  Child.NodeValue := b_3;

  Child := KeyData.AddChild('Num4');
  Child.NodeValue := b_4;

  Child := KeyData.AddChild('Num5');
  Child.NodeValue := b_5;

  Child := KeyData.AddChild('Num6');
  Child.NodeValue := b_6;

  Child := KeyData.AddChild('Num7');
  Child.NodeValue := b_7;

  Child := KeyData.AddChild('Num8');
  Child.NodeValue := b_8;

  Child := KeyData.AddChild('Num9');
  Child.NodeValue := b_9;

  Child := KeyData.AddChild('Num0');
  Child.NodeValue := b_0;

  Child := KeyData.AddChild('NumAdd');
  Child.NodeValue := '+';

  Child := KeyData.AddChild('NumDecimal');
  Child.NodeValue := '.';

  Child := KeyData.AddChild('NumDivide');
  Child.NodeValue := '/';

  Child := KeyData.AddChild('NumMultiply');
  Child.NodeValue := '*';

  Child := KeyData.AddChild('NumSubtract');
  Child.NodeValue := '-';

  try
    XML.SaveToFile(fFileName);
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Error occurred!' + #10 + #10 + E.Message), PChar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end;
  XML := nil;

end;

{ =============================================================================== }

procedure TfrmMain.HandleThemes;
begin
  SetAppropriateThemeMode('Windows10 Dark', 'Windows10');
end;

{ =============================================================================== }

procedure TfrmMain.EncodeAndSaveImage(XML: IXMLDocument; NodeName: string; FileName: string);
var
  FStream: TFileStream;
  ImageStream: TMemoryStream;
  EncodedString: string;
  Node: IXMLNode;
begin
  if FileExists(Trim(FileName)) then
  begin
    ImageStream := TMemoryStream.Create;
    try
      FStream := TFileStream.Create(FileName, fmOpenRead, fmShareDenyWrite);
      try
        ImageStream.CopyFrom(FStream, FStream.Size);
        ImageStream.Position := 0;
      finally
        FreeAndNil(FStream);
      end;

      EncodedString := TNetEncoding.Base64.EncodeBytesToString(ImageStream.Memory, ImageStream.Size);

      Node := XML.DocumentElement.AddChild(NodeName);
      Node.NodeValue := EncodedString;
    finally
      FreeAndNil(ImageStream);
    end;
  end;
end;

procedure TfrmMain.butAboutClick(Sender: TObject);
begin
  Application.CreateForm(TfrmAbout, frmAbout);

  try
    frmAbout.ShowModal;
  except
    on E: Exception do
    begin
      // Nothing
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmMain.butFontClick(Sender: TObject);
begin
  // Initialize
  FontDialog1.Font.Name := LEFontName;
  FontDialog1.Font.Size := StrToInt(LEFontSize);

  // Open dialog
  if FontDialog1.Execute then
  begin
    txtNormal.Font := FontDialog1.Font;
    txtShift.Font := FontDialog1.Font;
    txtAltGr.Font := FontDialog1.Font;
    txtShiftAltGr.Font := FontDialog1.Font;
    LEFontName := FontDialog1.Font.Name;
    LEFontSize := IntToStr(FontDialog1.Font.Size);
  end;
end;

{ =============================================================================== }

procedure TfrmMain.butHelpClick(Sender: TObject);
begin
  if FileExists(ExtractFilePath(Application.ExeName) + 'Editing Keyboard Layout.pdf') then
    Execute_Something(ExtractFilePath(Application.ExeName) + 'Editing Keyboard Layout.pdf')
  else
    Execute_Something('https://www.omicronlab.com/go.php?id=' + IntToStr(35));
end;

{ =============================================================================== }

procedure TfrmMain.butImageAltGrShiftClick(Sender: TObject);
begin
  OpenPictureDialog1.FileName := '';
  try
    if OpenPictureDialog1.Execute(Self.Handle) then
      txtImageAltGrShift.Text := OpenPictureDialog1.FileName;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Error occured!' + #10 + #10 + E.Message), PChar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmMain.butImageNormalShiftClick(Sender: TObject);
begin
  OpenPictureDialog1.FileName := '';
  try
    if OpenPictureDialog1.Execute(Self.Handle) then
      txtImageNormalShift.Text := OpenPictureDialog1.FileName;

  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Error occured!' + #10 + #10 + E.Message), PChar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmMain.butNewClick(Sender: TObject);
begin
  NewLayout;
end;

{ =============================================================================== }

procedure TfrmMain.butOpenClick(Sender: TObject);
var
  XML: IXMLDocument;
  Node: IXMLNode;
  I: Int64;
  KeyName, Layer, TrimLeftString: string;
  tmpShape: TShape;
  FStream: TFileStream;
  SStream: TStringStream;
  DecodedData: TBytes;
  m_Converter: TSkinLayoutConverter;
  P: Integer;
begin
  OpenDialog1.InitialDir := LELastDir;
  if OpenDialog1.Execute(Self.Handle) = False then
    exit;
  LELastDir := ExtractFilePath(OpenDialog1.FileName);

  m_Converter := TSkinLayoutConverter.Create;
  m_Converter.CheckConvertLayout(OpenDialog1.FileName);
  FreeAndNil(m_Converter);

  XML := TXMLDocument.Create(nil);
  XML.Active := True;
  XML.Encoding := 'UTF-8';

  try
    try
      XML.LoadFromFile(OpenDialog1.FileName);

      // ----------------------------------------------
      // Check if the layout is a compatible one
      if Trim(VarToStr(XML.DocumentElement.ChildNodes.FindNode('AvroKeyboardVersion').NodeValue)) <> '5' then
      begin
        Application.MessageBox('This Keyboard Layout is not compatible with the current version of Avro Keyboard.', 'Error loading keyboard layout...', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        exit;
      end;
      // ----------------------------------------------

      // Load basic information
      txtLayoutName.Text := VarToStr(XML.DocumentElement.ChildNodes.FindNode('LayoutName').ChildNodes[0].NodeValue);
      txtDeveloper.Text := VarToStr(XML.DocumentElement.ChildNodes.FindNode('DeveloperName').ChildNodes[0].NodeValue);
      txtVersion.Text := VarToStr(XML.DocumentElement.ChildNodes.FindNode('LayoutVersion').ChildNodes[0].NodeValue);
      txtComment.Text := VarToStr(XML.DocumentElement.ChildNodes.FindNode('DeveloperComment').ChildNodes[0].NodeValue);

      // Extract images
      if XML.DocumentElement.ChildNodes.FindNode('ImageNormalShift') <> nil then
      begin
        SStream := TStringStream.Create(VarToStr(XML.DocumentElement.ChildNodes.FindNode('ImageNormalShift').NodeValue));
        try
          DecodedData := DecodeBase64(SStream.DataString);
          FStream := TFileStream.Create(GetAvroDataDir + 'tmpImage_Normal_Shift.bmp', fmCreate);
          try
            FStream.WriteBuffer(DecodedData[0], Length(DecodedData));
            txtImageNormalShift.Text := GetAvroDataDir + 'tmpImage_Normal_Shift.bmp';
          finally
            FreeAndNil(FStream);
          end;
        finally
          FreeAndNil(SStream);
        end;
      end;

      if XML.DocumentElement.ChildNodes.FindNode('ImageAltGrShift') <> nil then
      begin
        SStream := TStringStream.Create(VarToStr(XML.DocumentElement.ChildNodes.FindNode('ImageAltGrShift').NodeValue));

        try
          DecodedData := DecodeBase64(SStream.DataString);
          FStream := TFileStream.Create(GetAvroDataDir + 'tmpImage_AltGr_Shift.bmp', fmCreate);
          try
            FStream.WriteBuffer(DecodedData[0], Length(DecodedData));
            txtImageAltGrShift.Text := GetAvroDataDir + 'tmpImage_AltGr_Shift.bmp';
          finally
            FreeAndNil(FStream)
          end;
        finally
          FreeAndNil(SStream);
        end;
      end;

      // Load Keys
      Node := XML.DocumentElement.ChildNodes.FindNode('KeyData');

      for I := 0 to Node.ChildNodes.Count - 1 do
        if LowerCase(LeftStr(Node.ChildNodes[I].NodeName, 3)) <> 'num' then
        begin

          // Structure: Key_OEM1_Normal
          TrimLeftString := MidStr(Node.ChildNodes[I].NodeName, 5, Length(Node.ChildNodes[I].NodeName));
          // OEM1_normal
          P := Pos('_', TrimLeftString);
          KeyName := MidStr(TrimLeftString, 1, P - 1); // OEM
          Layer := LowerCase(MidStr(TrimLeftString, P + 1, Length(TrimLeftString)));
          // normal/Shift/AltGr/ShiftAltGr

          tmpShape := FindComponent('Shape_' + KeyName) as TShape;

          if Node.ChildNodes[I].ChildNodes.Count <= 0 then
          begin
            // If item has no cdata
            if Layer = 'normal' then
              tmpShape.Normal := '';
            if Layer = 'shift' then
              tmpShape.Shift := '';
            if Layer = 'altgr' then
              tmpShape.AltGr := '';
            if Layer = 'shiftaltgr' then
              tmpShape.ShiftAltGr := '';
          end
          else
          begin
            // if item has cdata
            if Layer = 'normal' then
              tmpShape.Normal := VarToStr(Node.ChildNodes[I].ChildNodes[0].NodeValue);
            if Layer = 'shift' then
              tmpShape.Shift := VarToStr(Node.ChildNodes[I].ChildNodes[0].NodeValue);
            if Layer = 'altgr' then
              tmpShape.AltGr := VarToStr(Node.ChildNodes[I].ChildNodes[0].NodeValue);
            if Layer = 'shiftaltgr' then
              tmpShape.ShiftAltGr := VarToStr(Node.ChildNodes[I].ChildNodes[0].NodeValue);
          end;
        end;

    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Error occurred!' + #10 + #10 + E.Message), PChar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
        NewLayout;
      end;
    end;
  finally
    XML := nil;

  end;

  SetSelectedKey('Shape_Q');

end;
{ =============================================================================== }

procedure TfrmMain.ButSaveAsClick(Sender: TObject);
begin
  if NoErrorFound = False then
    exit;

  try
    SaveDialog1.FileName := txtLayoutName.Text + '.avrolayout';
    if SaveDialog1.Execute(Self.Handle) then
    begin
      LELastDir := ExtractFilePath(SaveDialog1.FileName);
      fFileName := SaveDialog1.FileName;
      BuildLayout;
    end;

  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Error occured!' + #10 + #10 + E.Message), PChar('Layout Editor'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmMain.ButSaveClick(Sender: TObject);
begin
  if NoErrorFound = False then
    exit;

  if fFileName = '' then
    ButSaveAsClick(nil)
  else
    BuildLayout;
end;

{ =============================================================================== }

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;

  Action := caFree;
  frmMain := nil;
end;

{ =============================================================================== }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  HandleThemes;

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
end;

{ =============================================================================== }

procedure TfrmMain.InitializeKeys;
var
  I: Integer;
begin
{$REGION 'Initializing stuffs'}
  with Shape_OEM3 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '`';
    CaptionShift := '~';
  end;

  with Shape_1 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '1';
    CaptionShift := '!';
  end;

  with Shape_2 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '2';
    CaptionShift := '@';
  end;

  with Shape_3 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '3';
    CaptionShift := '#';
  end;

  with Shape_4 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '4';
    CaptionShift := '$';
  end;

  with Shape_4 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '4';
    CaptionShift := '$';
  end;

  with Shape_5 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '5';
    CaptionShift := '%';
  end;

  with Shape_6 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '6';
    CaptionShift := '^';
  end;

  with Shape_7 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '7';
    CaptionShift := '&';
  end;

  with Shape_8 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '8';
    CaptionShift := '*';
  end;

  with Shape_9 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '9';
    CaptionShift := '(';
  end;

  with Shape_0 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '0';
    CaptionShift := ')';
  end;

  with Shape_MINUS do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '-';
    CaptionShift := '_';
  end;

  with Shape_PLUS do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '=';
    CaptionShift := '+';
  end;

  with Shape_OEM4 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '[';
    CaptionShift := '{';
  end;

  with Shape_OEM6 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := ']';
    CaptionShift := '}';
  end;

  with Shape_OEM5 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '\';
    CaptionShift := '|';
  end;

  with Shape_COMMA do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := ',';
    CaptionShift := '<';
  end;

  with Shape_PERIOD do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '.';
    CaptionShift := '>';
  end;

  with Shape_OEM2 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := '/';
    CaptionShift := '?';
  end;

  with Shape_OEM1 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := ';';
    CaptionShift := ':';
  end;

  with Shape_OEM7 do
  begin
    KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
    CaptionNormal := #39;
    CaptionShift := '"';
  end;

  /// //////////// Initialize alphabet keys
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TShape then
      if (Components[I] as TShape).KeyName = '' then
        with (Components[I] as TShape) do
        begin
          KeyName := UpperCase(MidStr(Name, 7, Length(Name)));
          CaptionNormal := LowerCase(KeyName);
          CaptionShift := UpperCase(CaptionNormal);
        end;
{$ENDREGION}
end;

{ =============================================================================== }

procedure TfrmMain.NewLayout;
var
  retVal: Integer;
begin
  if fDirty then
  begin
    retVal := Application.MessageBox('Save changes to the current keyboard layout?', 'Layout Editor', MB_YESNOCANCEL + +MB_ICONQUESTION + MB_DEFBUTTON1 + MB_APPLMODAL);
    if retVal = ID_YES then
    begin
      if NoErrorFound = True then
        ButSaveClick(nil)
      else
        exit;
    end
    else if retVal = ID_CANCEL then
      exit;
  end;

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
end;

{ =============================================================================== }

function TfrmMain.NoErrorFound: Boolean;
begin
  Result := False;
  if (Trim(txtLayoutName.Text) = '') or (Trim(txtLayoutName.Text) = '[My Layout]') then
  begin
    Application.MessageBox('Please give a name to your layout first.', 'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    txtLayoutName.SetFocus;
    txtLayoutName.SelectAll;
    exit;
  end;
  if Trim(txtImageNormalShift.Text) = '' then
  begin
    Application.MessageBox('Please add bitmap images for Layout Viewer of Avro Keyboard before building keyboard layout.', 'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    exit;
  end;
  if Trim(txtImageAltGrShift.Text) = '' then
  begin
    Application.MessageBox('Please add bitmap images for Layout Viewer of Avro Keyboard before building keyboard layout.', 'Layout Editor', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    exit;
  end;
  Result := True;
end;

{ =============================================================================== }

procedure TfrmMain.SetSelectedKey(ControlName: string);
var
  I: Integer;
begin

  for I := 0 to ComponentCount - 1 do
    if Components[I] is TShape then
      if UpperCase((Components[I] as TShape).Name) = UpperCase(ControlName) then
      begin
        (Components[I] as TShape).Selected := True;
        fSelected := Components[I] as TShape;

        if (Components[I] as TShape).CaptionShift <> '&' then
          LabelShift.Caption := (Components[I] as TShape).CaptionShift
        else
          LabelShift.Caption := '&&';

        LabelNormal.Caption := (Components[I] as TShape).CaptionNormal;

        txtNormal.Text := (Components[I] as TShape).Normal;
        txtShift.Text := (Components[I] as TShape).Shift;
        txtAltGr.Text := (Components[I] as TShape).AltGr;
        txtShiftAltGr.Text := (Components[I] as TShape).ShiftAltGr;

      end
      else
        (Components[I] as TShape).Selected := False;
end;

{ =============================================================================== }

procedure TfrmMain.Shape_QMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetSelectedKey((Sender as TShape).Name);
end;

{ =============================================================================== }

procedure TfrmMain.txtAltGrChange(Sender: TObject);
begin
  fSelected.AltGr := txtAltGr.Text;
  if txtAltGr.Text = '' then
    imgAltGr.Visible := True
  else
    imgAltGr.Visible := False;

  fDirty := True;
end;

{ =============================================================================== }

procedure TfrmMain.txtCommentEnter(Sender: TObject);
begin
  txtComment.SelectAll;
end;

{ =============================================================================== }

procedure TfrmMain.txtLayoutNameChange(Sender: TObject);
begin
  fDirty := True;
end;

{ =============================================================================== }

procedure TfrmMain.txtLayoutNameEnter(Sender: TObject);
begin
  (Sender as TEdit).SelectAll;
end;

{ =============================================================================== }

procedure TfrmMain.txtNormalChange(Sender: TObject);
begin
  fSelected.Normal := txtNormal.Text;
  if txtNormal.Text = '' then
    imgNormal.Visible := True
  else
    imgNormal.Visible := False;

  fDirty := True;
end;

{ =============================================================================== }

procedure TfrmMain.txtNormalEnter(Sender: TObject);
begin
  (Sender as TEdit).SelectAll;
end;

{ =============================================================================== }

procedure TfrmMain.txtShiftAltGrChange(Sender: TObject);
begin
  fSelected.ShiftAltGr := txtShiftAltGr.Text;
  if txtShiftAltGr.Text = '' then
    imgShiftAltGr.Visible := True
  else
    imgShiftAltGr.Visible := False;

  fDirty := True;

end;

{ =============================================================================== }

procedure TfrmMain.txtShiftChange(Sender: TObject);
begin
  fSelected.Shift := txtShift.Text;
  if txtShift.Text = '' then
    imgShift.Visible := True
  else
    imgShift.Visible := False;

  fDirty := True;

end;

{ =============================================================================== }

end.

