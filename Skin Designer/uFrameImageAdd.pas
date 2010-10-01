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

Unit uFrameImageAdd;

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
     ExtCtrls,
     ExtDlgs;

Type
     TFrameImageAdd = Class(TFrame)
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
          Procedure Button_ImagePath_TopBarClick(Sender: TObject);
          Procedure ImagePath_TopBarClick(Sender: TObject);
     Private
          { Private declarations }
          Procedure FillAll(ImageDir: String);
     Public
          { Public declarations }
          Procedure Initialize;
          Procedure SetVisibleControls(bKL, bLV, bMouse, bTools, bWeb, bHelp: Boolean);
          Function Validate: Boolean;
     End;

Implementation

{$R *.dfm}

Uses
     StrUtils;

{ TFrameImageAdd }

Procedure TFrameImageAdd.Button_ImagePath_TopBarClick(Sender: TObject);
Begin
     OpenPictureDialog.FileName := '';
     Try
          If OpenPictureDialog.Execute(Self.Handle) Then Begin
               TEdit(FindComponent(MidStr((Sender As TButton).Name, 8, Length((Sender As TButton).Name)))).Text := OpenPictureDialog.FileName;
               TEdit(FindComponent(MidStr((Sender As TButton).Name, 8, Length((Sender As TButton).Name)))).SelStart := Length(TEdit(FindComponent(MidStr((Sender As TButton).Name, 8, Length((Sender As TButton).Name)))).Text);
               FillAll(ExtractFilePath(OpenPictureDialog.FileName));
          End;
     Except
          On E: Exception Do Begin
               Application.MessageBox(pchar('Error occured!' + #10 + #10 + e.Message), Pchar('Skin Designer'), MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
          End;
     End;

End;

Procedure TFrameImageAdd.FillAll(ImageDir: String);
Var
     i                        : integer;
Begin
     //Background
     If FileExists(ImageDir + 'main.bmp') And (ImagePath_TopBar.Text = '') Then ImagePath_TopBar.Text := ImageDir + 'main.bmp';

     //Avro icon
     If FileExists(ImageDir + 'AvroIcon.bmp') And (AvroIcon.Text = '') Then AvroIcon.Text := ImageDir + 'AvroIcon.bmp';
     If FileExists(ImageDir + 'AvroIcon-Over.bmp') And (AvroIconOver.Text= '') Then AvroIconOver.Text := ImageDir + 'AvroIcon-Over.bmp';
     If FileExists(ImageDir + 'AvroIcon-Down.bmp') And (AvroIconDown.Text = '') Then AvroIconDown.Text := ImageDir + 'AvroIcon-Down.bmp';

     //Keyboard mode
     If FileExists(ImageDir + 'Mode-English.bmp') And (KMSys.Text = '') Then KMSys.Text := ImageDir + 'Mode-English.bmp';
     If FileExists(ImageDir + 'Mode-English-Over.bmp') And (KMSysOver.Text = '') Then KMSysOver.Text := ImageDir + 'Mode-English-Over.bmp';
     If FileExists(ImageDir + 'Mode-English-Down.bmp') And (KMSysDown.Text ='') Then KMSysDown.Text := ImageDir + 'Mode-English-Down.bmp';

     If FileExists(ImageDir + 'Mode-Bangla.bmp') And (KMBangla.Text = '') Then KMBangla.Text := ImageDir + 'Mode-Bangla.bmp';
     If FileExists(ImageDir + 'Mode-Bangla-Over.bmp') And (KMBanglaOver.Text = '') Then KMBanglaOver.Text := ImageDir + 'Mode-Bangla-Over.bmp';
     If FileExists(ImageDir + 'Mode-Bangla-Down.bmp') And (KMBanglaDown.Text = '') Then KMBanglaDown.Text := ImageDir + 'Mode-Bangla-Down.bmp';

     //Keyboard Layoit
     If PanelKL.Visible Then Begin
          If FileExists(ImageDir + 'Keyboards.bmp') And (KL.Text = '') Then KL.Text := ImageDir + 'Keyboards.bmp';
          If FileExists(ImageDir + 'Keyboards-Over.bmp') And (KLOver.Text = '') Then KLOver.Text := ImageDir + 'Keyboards-Over.bmp';
          If FileExists(ImageDir + 'Keyboards-Down.bmp') And (KLDown.Text= '') Then KLDown.Text := ImageDir + 'Keyboards-Down.bmp';
     End;

     //Layout viewer
     If PanelLV.Visible Then Begin
          If FileExists(ImageDir + 'Layout.bmp') And (LayoutV.Text = '') Then LayoutV.Text := ImageDir + 'Layout.bmp';
          If FileExists(ImageDir + 'Layout-Over.bmp') And (LayoutVOver.Text='') Then LayoutVOver.Text := ImageDir + 'Layout-Over.bmp';
          If FileExists(ImageDir + 'Layout-Down.bmp') And (LayoutVDown.Text = '') Then LayoutVDown.Text := ImageDir + 'Layout-Down.bmp';
     End;

     //Avro Mouse
     If PanelMouse.Visible Then Begin
          If FileExists(ImageDir + 'Mouse.bmp') And (AvroMouse.Text ='') Then AvroMouse.Text := ImageDir + 'Mouse.bmp';
          If FileExists(ImageDir + 'Mouse-Over.bmp') And (AvroMouseOver.Text='') Then AvroMouseOver.Text := ImageDir + 'Mouse-Over.bmp';
          If FileExists(ImageDir + 'Mouse-Down.bmp') And (AvroMouseDown.Text ='') Then AvroMouseDown.Text := ImageDir + 'Mouse-Down.bmp';
     End;

     //Tools
     If PanelTools.Visible Then Begin
          If FileExists(ImageDir + 'Tools.bmp') And (Tools.Text = '') Then Tools.Text := ImageDir + 'Tools.bmp';
          If FileExists(ImageDir + 'Tools-Over.bmp') And (ToolsOver.Text= '') Then ToolsOver.Text := ImageDir + 'Tools-Over.bmp';
          If FileExists(ImageDir + 'Tools-Down.bmp') And (ToolsDown.Text = '') Then ToolsDown.Text := ImageDir + 'Tools-Down.bmp';
     End;

     //Web
     If PanelWeb.Visible Then Begin
          If FileExists(ImageDir + 'Web.bmp') And (Web.Text = '') Then Web.Text := ImageDir + 'Web.bmp';
          If FileExists(ImageDir + 'Web-Over.bmp') And (WebOver.Text = '') Then WebOver.Text := ImageDir + 'Web-Over.bmp';
          If FileExists(ImageDir + 'Web-Down.bmp') And (WebDown.Text= '') Then WebDown.Text := ImageDir + 'Web-Down.bmp';
     End;

     //Help
     If PanelHelp.Visible Then Begin
          If FileExists(ImageDir + 'Help.bmp') And (Help.Text ='') Then Help.Text := ImageDir + 'Help.bmp';
          If FileExists(ImageDir + 'Help-Over.bmp') And (HelpOver.Text = '') Then HelpOver.Text := ImageDir + 'Help-Over.bmp';
          If FileExists(ImageDir + 'Help-Down.bmp') And (HelpDown.Text = '') Then HelpDown.Text := ImageDir + 'Help-Down.bmp';
     End;

     //Exit
     If FileExists(ImageDir + 'Exit.bmp') And (Exit.Text = '') Then Exit.Text := ImageDir + 'Exit.bmp';
     If FileExists(ImageDir + 'Exit-Over.bmp') And (ExitOver.Text = '') Then ExitOver.Text := ImageDir + 'Exit-Over.bmp';
     If FileExists(ImageDir + 'Exit-Down.bmp') And (ExitDown.Text = '') Then ExitDown.Text := ImageDir + 'Exit-Down.bmp';

     //Preview
     If FileExists(ImageDir + 'Preview.bmp') And (Preview.Text= '') Then Preview.Text := ImageDir + 'Preview.bmp';


     //Set cursor to the end
     For I := 0 To ComponentCount - 1 Do Begin
          If Components[I] Is TEdit Then Begin
               If (Components[I] As TEdit).Visible Then Begin
                    (Components[I] As TEdit).SelStart := Length((Components[I] As TEdit).Text)

               End;
          End;
     End;
End;

Procedure TFrameImageAdd.ImagePath_TopBarClick(Sender: TObject);
Begin
     If Trim((Sender As TEdit).Text) = '' Then
          Button_ImagePath_TopBarClick(TButton(FindComponent('Button_' + (Sender As TEdit).Name)));
End;

Procedure TFrameImageAdd.Initialize;
Var
     i                        : integer;
Begin
     Self.Color := clBtnFace;
     For I := 0 To ComponentCount - 1 Do Begin
          If Components[I] Is TPanel Then
               (Components[i] As TPanel).Color := clBtnFace;
          If Components[I] Is TLabel Then
               (Components[i] As TLabel).Transparent := True;
          If Components[I] Is TEdit Then
               (Components[i] As TEdit).Text := '';
     End;
End;



Procedure TFrameImageAdd.SetVisibleControls(bKL, bLV, bMouse, bTools, bWeb,
     bHelp: Boolean);
Var
     Gap, CurrentHeight       : Integer;

Begin
     //Set Visibility
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

     //SetHeight
     Gap := PanelAvroIcon.Top - PanelTopBar.Top - PanelTopBar.Height;
     CurrentHeight := PanelKM_B.Top + PanelKM_B.Height + Gap;

     If bKL Then Begin
          PanelKL.Top := CurrentHeight;
          CurrentHeight := CurrentHeight + PanelKL.Height + gap;
     End;

     If bLV Then Begin
          PanelLV.Top := CurrentHeight;
          CurrentHeight := CurrentHeight + PanelLV.Height + gap;
     End;

     If bMouse Then Begin
          PanelMouse.Top := CurrentHeight;
          CurrentHeight := CurrentHeight + PanelMouse.Height + gap;
     End;

     If bTools Then Begin
          PanelTools.Top := CurrentHeight;
          CurrentHeight := CurrentHeight + PanelTools.Height + gap;
     End;

     If bWeb Then Begin
          PanelWeb.Top := CurrentHeight;
          CurrentHeight := CurrentHeight + PanelWeb.Height + gap;
     End;

     If bHelp Then Begin
          PanelHelp.Top := CurrentHeight;
          CurrentHeight := CurrentHeight + PanelHelp.Height + gap;
     End;

     PanelExit.Top := CurrentHeight;
     CurrentHeight := CurrentHeight + PanelExit.Height + gap;

     PanelPreview.Top := CurrentHeight;
     CurrentHeight := CurrentHeight + PanelPreview.Height + gap;

     Self.Height := CurrentHeight;
End;

Function TFrameImageAdd.Validate: Boolean;
Var
     I                        : Integer;
Begin
     Result := False;
     For I := 0 To ComponentCount - 1 Do Begin
          If Components[I] Is TEdit Then Begin
               If (Components[I] As TEdit).Visible Then Begin
                    If FileExists(Trim((Components[I] As TEdit).Text)) = False Then Begin
                         Application.MessageBox('All images are required!' + #10 + 'Make sure you have entered all image paths or all images do exist.', 'Skin Designer', MB_OK +
                              MB_ICONEXCLAMATION +
                              MB_DEFBUTTON1 +
                              MB_APPLMODAL);
                         (Components[I] As TEdit).SetFocus;
                         (Components[I] As TEdit).SelectAll;
                         System.Exit;
                    End;
               End;
          End;
     End;
     Result := True;
End;

End.

