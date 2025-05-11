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
  Mehdi Hasan Khan (mhasan@omicronlab.com).

  Copyright (C) OmicronLab (https://www.omicronlab.com). All Rights Reserved.


  Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit ufrmUpdateNotify;

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
  Buttons,
  ExtCtrls;

type
  TfrmUpdateNotify = class(TForm)
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblWhatsNewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure but_DownloadClick(Sender: TObject);
    private
      { Private declarations }
      WhatsNewURL: string;
      DownloadURL: string;
    public
      { Public declarations }
      procedure SetupAndShow(const mNewVer, mDate, mWhatsNew, mDownload: string);
    protected
      procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmUpdateNotify: TfrmUpdateNotify;

implementation

{$R *.dfm}

uses
  uFileFolderHandling,
  clsFileVersion,
  uWindowHandlers;

const
  Show_Window_in_Taskbar = True;

  { =============================================================================== }

procedure TfrmUpdateNotify.Button1Click(Sender: TObject);
begin
  self.Close;
end;

{ =============================================================================== }

procedure TfrmUpdateNotify.but_DownloadClick(Sender: TObject);
begin
  Execute_Something(DownloadURL);
  self.Close;
end;

{ =============================================================================== }

procedure TfrmUpdateNotify.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle or WS_EX_APPWINDOW and not WS_EX_TOOLWINDOW;
      ExStyle := ExStyle or WS_EX_TOPMOST or WS_EX_NOACTIVATE;
      WndParent := GetDesktopwindow;
    end
    else if not Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle and not WS_EX_APPWINDOW;
    end;
  end;
end;

{ =============================================================================== }

procedure TfrmUpdateNotify.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  frmUpdateNotify := nil;
end;

{ =============================================================================== }

procedure TfrmUpdateNotify.lblWhatsNewClick(Sender: TObject);
begin
  Execute_Something(WhatsNewURL);
end;

{ =============================================================================== }

procedure TfrmUpdateNotify.SetupAndShow(const mNewVer, mDate, mWhatsNew, mDownload: string);
var
  Version: TFileVersion;
  mOldVer: string;
begin
  Version := TFileVersion.Create();
  mOldVer := IntToStr(Version.VerMajor) + '.' + IntToStr(Version.VerMinor) + '.' + IntToStr(Version.VerRelease) + '.' + IntToStr(Version.VerBuild);
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
end;
{ =============================================================================== }

end.
