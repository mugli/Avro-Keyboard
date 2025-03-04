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
Unit ufrmAbout;

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
        ExtCtrls;

Type
        TfrmAbout = Class(TForm)
                Panel1: TPanel;
                Image1: TImage;
                Label1: TLabel;
                lblVer: TLabel;
                Label5: TLabel;
                Memo1: TMemo;
                Label3: TLabel;
                lblOmicronLab: TLabel;
                Label8: TLabel;
                butClose: TButton;
                Procedure butCloseClick(Sender: TObject);
                Procedure lblOmicronLabClick(Sender: TObject);
                procedure FormCreate(Sender: TObject);
        Private
                { Private declarations }
        Public
                { Public declarations }
        End;

Var
        frmAbout: TfrmAbout;

Implementation

{$R *.dfm}

Uses
        clsFileVersion,
        uFileFolderHandling;

Procedure TfrmAbout.butCloseClick(Sender: TObject);
Begin
        Self.close;
End;

procedure TfrmAbout.FormCreate(Sender: TObject);
Var
        FileVar: TFileVersion;
Begin
        FileVar := TFileVersion.Create();
        lblVer.Caption := lblVer.Caption + ' ' + FileVar.AsString
{$IFDEF BetaVersion} + ' BETA'{$ENDIF}{$IFDEF PortableOn} +
          ' (Portable)'{$ENDIF};
        FileVar.Free;
end;

Procedure TfrmAbout.lblOmicronLabClick(Sender: TObject);
Begin
        Execute_Something('http://www.omicronlab.com/');
End;

End.
