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

Unit Unit1;

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
		 clsUnicodeToBijoy2000,
		 ComCtrls;

Type
		 TForm1 = Class(TForm)
					MEMO1: TMemo;
					MEMO2: TMemo;
					Label1: TLabel;
					Button1: TButton;
					Progress: TProgressBar;
					Label8: TLabel;
					Label_OmicronLab: TLabel;
					Label4: TLabel;
					Procedure FormCreate(Sender: TObject);
					Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
					Procedure Button1Click(Sender: TObject);
					Procedure Label_OmicronLabClick(Sender: TObject);
		 Private
					{ Private declarations }
					FUniToBijoy: TUnicodeToBijoy2000;
		 Public
					{ Public declarations }
		 End;

Var
		 Form1: TForm1;

Implementation

{$R *.dfm}

Uses
		 uFileFolderHandling;

{ =============================================================================== }

Procedure TForm1.Button1Click(Sender: TObject);
Var
		 i, TotalLines: integer;
Begin
		 MEMO1.Enabled := False;
		 MEMO2.Enabled := False;
		 Button1.Enabled := False;
		 Progress.Visible := True;
		 Progress.Position := 0;
		 MEMO2.Clear;
		 application.ProcessMessages;

		 TotalLines := MEMO1.Lines.Count;
		 MEMO2.Lines.BeginUpdate;
		 For i := 0 To TotalLines - 1 Do Begin
					MEMO2.Lines.Add(FUniToBijoy.Convert(MEMO1.Lines[i]));

					Progress.Position := ((i + 1) * 100) Div (TotalLines + 1);

					application.ProcessMessages;
		 End;
		 MEMO2.Lines.EndUpdate;

		 Progress.Visible := False;
		 MEMO1.Enabled := True;
		 MEMO2.Enabled := True;
		 Button1.Enabled := True;
End;


{ =============================================================================== }


Procedure TForm1.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
		 FUniToBijoy.Free;
		 Action := caFree;
		 Form1 := Nil;
End;

{ =============================================================================== }

Procedure TForm1.FormCreate(Sender: TObject);
Begin
		 FUniToBijoy := TUnicodeToBijoy2000.Create;
End;

{ =============================================================================== }

Procedure TForm1.Label_OmicronLabClick(Sender: TObject);
Begin
		 Execute_Something('http://www.omicronlab.com');
End;

{ =============================================================================== }

End.
