{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit uFrmSplash;

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
  jpeg,
  ExtCtrls;

type
  TfrmSplash = class(TForm)
    Image1: TImage;
    SplashTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure SplashTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    private
      { Private declarations }
    public
      { Public declarations }
    protected
      procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmSplash: TfrmSplash;

implementation

uses
  DebugLog;

{$R *.dfm}

const
  Show_Window_in_Taskbar = False;

procedure TfrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  frmSplash := nil;
end;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  Self.ClientWidth := Image1.Width;
  Self.ClientHeight := Image1.Height;
  Log('Splash created');
end;

procedure TfrmSplash.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Close;
end;

procedure TfrmSplash.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TfrmSplash.SplashTimerTimer(Sender: TObject);
begin
  Close;
end;

procedure TfrmSplash.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle or WS_EX_APPWINDOW and not WS_EX_TOOLWINDOW;
      WndParent := GetDesktopwindow;
    end
    else if not Show_Window_in_Taskbar then
    begin
      ExStyle := ExStyle and not WS_EX_APPWINDOW;
    end;
  end;
end;

end.
