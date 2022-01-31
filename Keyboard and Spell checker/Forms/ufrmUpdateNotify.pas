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

{$INCLUDE ../ProjectDefines.inc}
Unit ufrmUpdateNotify;

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
  Buttons,
  ExtCtrls;

Type
  TfrmUpdateNotify = Class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    lblWhatsNew: TLabel;
    Label6: TLabel;
    lblOldVer: TLabel;
    lblNewVer: TLabel;
    lblDate: TLabel;
    but_Download: TButton;
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure lblWhatsNewClick(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure but_DownloadClick(Sender: TObject);
  Private
    { Private declarations }
    WhatsNewURL: String;
    DownloadURL: String;
  Public
    { Public declarations }
    Procedure SetupAndShow(Const mNewVer, mDate, mWhatsNew, mDownload: String);
  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  End;

Var
  frmUpdateNotify: TfrmUpdateNotify;

Implementation

{$R *.dfm}

Uses
  uFileFolderHandling,
  clsFileVersion,
  uWindowHandlers;

Const
  Show_Window_in_Taskbar = True;

  { =============================================================================== }

Procedure TfrmUpdateNotify.Button1Click(Sender: TObject);
Begin
  self.Close;
End;

{ =============================================================================== }

Procedure TfrmUpdateNotify.but_DownloadClick(Sender: TObject);
Begin
  Execute_Something(DownloadURL);
  self.Close;
End;

{ =============================================================================== }

Procedure TfrmUpdateNotify.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  With Params Do
  Begin
    If Show_Window_in_Taskbar Then
    Begin
      ExStyle := ExStyle Or WS_EX_APPWINDOW And Not WS_EX_TOOLWINDOW;
      ExStyle := ExStyle Or WS_EX_TOPMOST Or WS_EX_NOACTIVATE;
      WndParent := GetDesktopwindow;
    End
    Else If Not Show_Window_in_Taskbar Then
    Begin
      ExStyle := ExStyle And Not WS_EX_APPWINDOW;
    End;
  End;
End;

{ =============================================================================== }

Procedure TfrmUpdateNotify.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  Action := caFree;

  frmUpdateNotify := Nil;
End;

{ =============================================================================== }

Procedure TfrmUpdateNotify.lblWhatsNewClick(Sender: TObject);
Begin
  Execute_Something(WhatsNewURL);
End;

{ =============================================================================== }

Procedure TfrmUpdateNotify.SetupAndShow(Const mNewVer, mDate, mWhatsNew,
  mDownload: String);
Var
  Version: TFileVersion;
  mOldVer: String;
Begin
  Version := TFileVersion.Create();
  mOldVer := IntToStr(Version.VerMajor) + '.' + IntToStr(Version.VerMinor) + '.'
    + IntToStr(Version.VerRelease) + '.' + IntToStr(Version.VerBuild);
  lblOldVer.Caption := '';
  lblNewVer.Caption := '';
  lblDate.Caption := '';

  lblOldVer.Caption := mOldVer;
  lblNewVer.Caption := mNewVer;
  lblDate.Caption := mDate;

  WhatsNewURL := mWhatsNew;
  DownloadURL := mDownload;
  TOPMOST(self.Handle);
  self.Show;
End;
{ =============================================================================== }

End.
