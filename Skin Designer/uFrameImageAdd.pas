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
unit uFrameImageAdd;

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
  ExtCtrls,
  ExtDlgs;

type
  TFrameImageAdd = class(TFrame)
    PanelTopBar: TPanel;
    OpenPictureDialog: TOpenPictureDialog;
    Label1: TLabel;
    Label2: TLabel;
    ImagePath_TopBar: TEdit;
    Button_ImagePath_TopBar: TButton;
    PanelAvroIcon: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    AvroIcon: TEdit;
    Button_AvroIcon: TButton;
    Label5: TLabel;
    AvroIconOver: TEdit;
    Button_AvroIconOver: TButton;
    Label6: TLabel;
    AvroIconDown: TEdit;
    Button_AvroIconDown: TButton;
    PanelKM_E: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    KMSys: TEdit;
    Button_KMSys: TButton;
    KMSysOver: TEdit;
    Button_KMSysOver: TButton;
    KMSysDown: TEdit;
    Button_KMSysDown: TButton;
    PanelKM_B: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    KMBangla: TEdit;
    Button_KMBangla: TButton;
    KMBanglaOver: TEdit;
    Button_KMBanglaOver: TButton;
    KMBanglaDown: TEdit;
    Button_KMBanglaDown: TButton;
    PanelKL: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    KL: TEdit;
    Button_KL: TButton;
    KLOver: TEdit;
    Button_KLOver: TButton;
    KLDown: TEdit;
    Button_KLDown: TButton;
    PanelLV: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    LayoutV: TEdit;
    Button_LayoutV: TButton;
    LayoutVOver: TEdit;
    Button_LayoutVOver: TButton;
    LayoutVDown: TEdit;
    Button_LayoutVDown: TButton;
    PanelMouse: TPanel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    AvroMouse: TEdit;
    Button_AvroMouse: TButton;
    AvroMouseOver: TEdit;
    Button_AvroMouseOver: TButton;
    AvroMouseDown: TEdit;
    Button_AvroMouseDown: TButton;
    PanelTools: TPanel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Tools: TEdit;
    Button_Tools: TButton;
    ToolsOver: TEdit;
    Button_ToolsOver: TButton;
    ToolsDown: TEdit;
    Button_ToolsDown: TButton;
    PanelHelp: TPanel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Help: TEdit;
    Button_Help: TButton;
    HelpOver: TEdit;
    Button_HelpOver: TButton;
    HelpDown: TEdit;
    Button_HelpDown: TButton;
    PanelWeb: TPanel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Web: TEdit;
    Button_Web: TButton;
    WebOver: TEdit;
    Button_WebOver: TButton;
    WebDown: TEdit;
    Button_WebDown: TButton;
    PanelExit: TPanel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Exit: TEdit;
    Button_Exit: TButton;
    ExitOver: TEdit;
    Button_ExitOver: TButton;
    ExitDown: TEdit;
    Button_ExitDown: TButton;
    PanelPreview: TPanel;
    Label43: TLabel;
    Preview: TEdit;
    Button_Preview: TButton;
    procedure Button_ImagePath_TopBarClick(Sender: TObject);
    procedure ImagePath_TopBarClick(Sender: TObject);
    private
      { Private declarations }
      procedure FillAll(ImageDir: string);
    public
      { Public declarations }
      procedure Initialize;
      procedure SetVisibleControls(bKL, bLV, bMouse, bTools, bWeb, bHelp: Boolean);
      function Validate: Boolean;
  end;

implementation

{$R *.dfm}

uses
  StrUtils;

{ TFrameImageAdd }

procedure TFrameImageAdd.Button_ImagePath_TopBarClick(Sender: TObject);
begin
  OpenPictureDialog.FileName := '';
  try
    if OpenPictureDialog.Execute(Self.Handle) then
    begin
      TEdit(FindComponent(MidStr((Sender as TButton).Name, 8, Length((Sender as TButton).Name)))).Text := OpenPictureDialog.FileName;
      TEdit(FindComponent(MidStr((Sender as TButton).Name, 8, Length((Sender as TButton).Name)))).SelStart :=
        Length(TEdit(FindComponent(MidStr((Sender as TButton).Name, 8, Length((Sender as TButton).Name)))).Text);
      FillAll(ExtractFilePath(OpenPictureDialog.FileName));
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(pchar('Error occured!' + #10 + #10 + E.Message), pchar('Skin Designer'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end;

end;

procedure TFrameImageAdd.FillAll(ImageDir: string);
var
  i: integer;
begin
  // Background
  if FileExists(ImageDir + 'main.bmp') and (ImagePath_TopBar.Text = '') then
    ImagePath_TopBar.Text := ImageDir + 'main.bmp';

  // Avro icon
  if FileExists(ImageDir + 'AvroIcon.bmp') and (AvroIcon.Text = '') then
    AvroIcon.Text := ImageDir + 'AvroIcon.bmp';
  if FileExists(ImageDir + 'AvroIcon-Over.bmp') and (AvroIconOver.Text = '') then
    AvroIconOver.Text := ImageDir + 'AvroIcon-Over.bmp';
  if FileExists(ImageDir + 'AvroIcon-Down.bmp') and (AvroIconDown.Text = '') then
    AvroIconDown.Text := ImageDir + 'AvroIcon-Down.bmp';

  // Keyboard mode
  if FileExists(ImageDir + 'Mode-English.bmp') and (KMSys.Text = '') then
    KMSys.Text := ImageDir + 'Mode-English.bmp';
  if FileExists(ImageDir + 'Mode-English-Over.bmp') and (KMSysOver.Text = '') then
    KMSysOver.Text := ImageDir + 'Mode-English-Over.bmp';
  if FileExists(ImageDir + 'Mode-English-Down.bmp') and (KMSysDown.Text = '') then
    KMSysDown.Text := ImageDir + 'Mode-English-Down.bmp';

  if FileExists(ImageDir + 'Mode-Bangla.bmp') and (KMBangla.Text = '') then
    KMBangla.Text := ImageDir + 'Mode-Bangla.bmp';
  if FileExists(ImageDir + 'Mode-Bangla-Over.bmp') and (KMBanglaOver.Text = '') then
    KMBanglaOver.Text := ImageDir + 'Mode-Bangla-Over.bmp';
  if FileExists(ImageDir + 'Mode-Bangla-Down.bmp') and (KMBanglaDown.Text = '') then
    KMBanglaDown.Text := ImageDir + 'Mode-Bangla-Down.bmp';

  // Keyboard Layoit
  if PanelKL.Visible then
  begin
    if FileExists(ImageDir + 'Keyboards.bmp') and (KL.Text = '') then
      KL.Text := ImageDir + 'Keyboards.bmp';
    if FileExists(ImageDir + 'Keyboards-Over.bmp') and (KLOver.Text = '') then
      KLOver.Text := ImageDir + 'Keyboards-Over.bmp';
    if FileExists(ImageDir + 'Keyboards-Down.bmp') and (KLDown.Text = '') then
      KLDown.Text := ImageDir + 'Keyboards-Down.bmp';
  end;

  // Layout viewer
  if PanelLV.Visible then
  begin
    if FileExists(ImageDir + 'Layout.bmp') and (LayoutV.Text = '') then
      LayoutV.Text := ImageDir + 'Layout.bmp';
    if FileExists(ImageDir + 'Layout-Over.bmp') and (LayoutVOver.Text = '') then
      LayoutVOver.Text := ImageDir + 'Layout-Over.bmp';
    if FileExists(ImageDir + 'Layout-Down.bmp') and (LayoutVDown.Text = '') then
      LayoutVDown.Text := ImageDir + 'Layout-Down.bmp';
  end;

  // Avro Mouse
  if PanelMouse.Visible then
  begin
    if FileExists(ImageDir + 'Mouse.bmp') and (AvroMouse.Text = '') then
      AvroMouse.Text := ImageDir + 'Mouse.bmp';
    if FileExists(ImageDir + 'Mouse-Over.bmp') and (AvroMouseOver.Text = '') then
      AvroMouseOver.Text := ImageDir + 'Mouse-Over.bmp';
    if FileExists(ImageDir + 'Mouse-Down.bmp') and (AvroMouseDown.Text = '') then
      AvroMouseDown.Text := ImageDir + 'Mouse-Down.bmp';
  end;

  // Tools
  if PanelTools.Visible then
  begin
    if FileExists(ImageDir + 'Tools.bmp') and (Tools.Text = '') then
      Tools.Text := ImageDir + 'Tools.bmp';
    if FileExists(ImageDir + 'Tools-Over.bmp') and (ToolsOver.Text = '') then
      ToolsOver.Text := ImageDir + 'Tools-Over.bmp';
    if FileExists(ImageDir + 'Tools-Down.bmp') and (ToolsDown.Text = '') then
      ToolsDown.Text := ImageDir + 'Tools-Down.bmp';
  end;

  // Web
  if PanelWeb.Visible then
  begin
    if FileExists(ImageDir + 'Web.bmp') and (Web.Text = '') then
      Web.Text := ImageDir + 'Web.bmp';
    if FileExists(ImageDir + 'Web-Over.bmp') and (WebOver.Text = '') then
      WebOver.Text := ImageDir + 'Web-Over.bmp';
    if FileExists(ImageDir + 'Web-Down.bmp') and (WebDown.Text = '') then
      WebDown.Text := ImageDir + 'Web-Down.bmp';
  end;

  // Help
  if PanelHelp.Visible then
  begin
    if FileExists(ImageDir + 'Help.bmp') and (Help.Text = '') then
      Help.Text := ImageDir + 'Help.bmp';
    if FileExists(ImageDir + 'Help-Over.bmp') and (HelpOver.Text = '') then
      HelpOver.Text := ImageDir + 'Help-Over.bmp';
    if FileExists(ImageDir + 'Help-Down.bmp') and (HelpDown.Text = '') then
      HelpDown.Text := ImageDir + 'Help-Down.bmp';
  end;

  // Exit
  if FileExists(ImageDir + 'Exit.bmp') and (Exit.Text = '') then
    Exit.Text := ImageDir + 'Exit.bmp';
  if FileExists(ImageDir + 'Exit-Over.bmp') and (ExitOver.Text = '') then
    ExitOver.Text := ImageDir + 'Exit-Over.bmp';
  if FileExists(ImageDir + 'Exit-Down.bmp') and (ExitDown.Text = '') then
    ExitDown.Text := ImageDir + 'Exit-Down.bmp';

  // Preview
  if FileExists(ImageDir + 'Preview.bmp') and (Preview.Text = '') then
    Preview.Text := ImageDir + 'Preview.bmp';

  // Set cursor to the end
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
    begin
      if (Components[i] as TEdit).Visible then
      begin
        (Components[i] as TEdit).SelStart := Length((Components[i] as TEdit).Text)

      end;
    end;
  end;
end;

procedure TFrameImageAdd.ImagePath_TopBarClick(Sender: TObject);
begin
  if Trim((Sender as TEdit).Text) = '' then
    Button_ImagePath_TopBarClick(TButton(FindComponent('Button_' + (Sender as TEdit).Name)));
end;

procedure TFrameImageAdd.Initialize;
var
  i: integer;
begin
  Self.Color := clBtnFace;
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TPanel then
      (Components[i] as TPanel).Color := clBtnFace;
    if Components[i] is TLabel then
      (Components[i] as TLabel).Transparent := True;
    if Components[i] is TEdit then
      (Components[i] as TEdit).Text := '';
  end;
end;

procedure TFrameImageAdd.SetVisibleControls(bKL, bLV, bMouse, bTools, bWeb, bHelp: Boolean);
var
  Gap, CurrentHeight: integer;

begin
  // Set Visibility
  PanelKL.Visible := bKL;
  KL.Visible := bKL;
  KLOver.Visible := bKL;
  KLDown.Visible := bKL;

  PanelLV.Visible := bLV;
  LayoutV.Visible := bLV;
  LayoutVOver.Visible := bLV;
  LayoutVDown.Visible := bLV;

  PanelMouse.Visible := bMouse;
  AvroMouse.Visible := bMouse;
  AvroMouseOver.Visible := bMouse;
  AvroMouseDown.Visible := bMouse;

  PanelTools.Visible := bTools;
  Tools.Visible := bTools;
  ToolsOver.Visible := bTools;
  ToolsDown.Visible := bTools;

  PanelWeb.Visible := bWeb;
  Web.Visible := bWeb;
  WebOver.Visible := bWeb;
  WebDown.Visible := bWeb;

  PanelHelp.Visible := bHelp;
  Help.Visible := bHelp;
  HelpOver.Visible := bHelp;
  HelpDown.Visible := bHelp;

  // SetHeight
  Gap := PanelAvroIcon.Top - PanelTopBar.Top - PanelTopBar.Height;
  CurrentHeight := PanelKM_B.Top + PanelKM_B.Height + Gap;

  if bKL then
  begin
    PanelKL.Top := CurrentHeight;
    CurrentHeight := CurrentHeight + PanelKL.Height + Gap;
  end;

  if bLV then
  begin
    PanelLV.Top := CurrentHeight;
    CurrentHeight := CurrentHeight + PanelLV.Height + Gap;
  end;

  if bMouse then
  begin
    PanelMouse.Top := CurrentHeight;
    CurrentHeight := CurrentHeight + PanelMouse.Height + Gap;
  end;

  if bTools then
  begin
    PanelTools.Top := CurrentHeight;
    CurrentHeight := CurrentHeight + PanelTools.Height + Gap;
  end;

  if bWeb then
  begin
    PanelWeb.Top := CurrentHeight;
    CurrentHeight := CurrentHeight + PanelWeb.Height + Gap;
  end;

  if bHelp then
  begin
    PanelHelp.Top := CurrentHeight;
    CurrentHeight := CurrentHeight + PanelHelp.Height + Gap;
  end;

  PanelExit.Top := CurrentHeight;
  CurrentHeight := CurrentHeight + PanelExit.Height + Gap;

  PanelPreview.Top := CurrentHeight;
  CurrentHeight := CurrentHeight + PanelPreview.Height + Gap;

  Self.Height := CurrentHeight;
end;

function TFrameImageAdd.Validate: Boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
    begin
      if (Components[i] as TEdit).Visible then
      begin
        if FileExists(Trim((Components[i] as TEdit).Text)) = False then
        begin
          Application.MessageBox('All images are required!' + #10 + 'Make sure you have entered all image paths or all images do exist.', 'Skin Designer',
            MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_APPLMODAL);
          (Components[i] as TEdit).SetFocus;
          (Components[i] as TEdit).SelectAll;
          System.Exit;
        end;
      end;
    end;
  end;
  Result := True;
end;

end.
