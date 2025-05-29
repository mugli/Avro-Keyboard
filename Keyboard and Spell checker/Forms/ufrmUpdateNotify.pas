{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
