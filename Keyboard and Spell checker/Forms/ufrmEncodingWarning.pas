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
unit ufrmEncodingWarning;

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
  ExtCtrls;

type
  TfrmEncodingWarning = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    Button1: TButton;
    Button2: TButton;
    CheckBox_ShowWarning: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    private
      { Private declarations }
    public
      { Public declarations }
  end;

var
  frmEncodingWarning: TfrmEncodingWarning;

implementation

{$R *.dfm}

uses
  uWindowHandlers,
  uRegistrySettings,
  uform1;

procedure TfrmEncodingWarning.Button1Click(Sender: TObject);
begin
  OutputIsBijoy := 'NO';
  if CheckBox_ShowWarning.Checked then
    ShowOutputwarning := 'YES'
  else
    ShowOutputwarning := 'NO';

  AvroMainForm1.RefreshSettings;
  Self.Close;
end;

procedure TfrmEncodingWarning.Button2Click(Sender: TObject);
begin
  OutputIsBijoy := 'YES';
  if CheckBox_ShowWarning.Checked then
    ShowOutputwarning := 'YES'
  else
    ShowOutputwarning := 'NO';

  AvroMainForm1.RefreshSettings;
  Self.Close;
end;

procedure TfrmEncodingWarning.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmEncodingWarning := nil;
end;

procedure TfrmEncodingWarning.FormCreate(Sender: TObject);
begin
  DisableCloseButton(Self.Handle);
  TOPMOST(Self.Handle);
end;

end.
